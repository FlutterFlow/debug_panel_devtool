import 'dart:convert';

import 'package:flutterflow_debug_panel/src/utils/ff_icons.dart';
import 'package:flutterflow_debug_panel/src/utils/ff_utils.dart';
import 'package:flutterflow_debug_panel/src/widgets/narrow_modal.dart';
import 'package:debug_panel_proto/debug_panel_proto.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_tree_view/flutterflow_tree_view.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:intl/intl.dart';

/// Enum representing the types of debug sections.
///
/// Used to categorize different types of debug sections. It includes the
/// following types:
///
/// - [appState]: Represents the app state debug section.
/// - [appConstant]: Represents the app constant debug section.
/// - [environmentValue]: Represents the environment value debug section.
/// - [globalProperty]: Represents the global property debug section.
/// - [authenticatedUser]: Represents the authenticated user debug section.
/// - [widgetClass]: Represents the widget class debug section.
enum DebugSectionType {
  pageState,
  pageParameters,
  componentState,
  componentParameters,
  appState,
  appConstants,
  environmentValues,
  globalProperties,
  authenticatedUser,
  widgetState,
  actionOutputs,
  generatorVariables,
  backendQueries,
}

/// A map that contains the names of different data types and their
/// corresponding [DebugDataField_ParamType].
const kDebugDataTypeNames = {
  'Integer': DebugDataField_ParamType.INT,
  'Double': DebugDataField_ParamType.DOUBLE,
  'String': DebugDataField_ParamType.STRING,
  'Boolean': DebugDataField_ParamType.BOOL,
  'Date Time': DebugDataField_ParamType.DATE_TIME,
  'Timestamp Range': DebugDataField_ParamType.DATE_TIME_RANGE,
  'Lat Lng': DebugDataField_ParamType.LAT_LNG,
  'Color': DebugDataField_ParamType.COLOR,
  'Google Place': DebugDataField_ParamType.FF_PLACE,
  'Uploaded File': DebugDataField_ParamType.FF_UPLOADED_FILE,
  'JSON': DebugDataField_ParamType.JSON,
  'Data Struct': DebugDataField_ParamType.DATA_STRUCT,
  'Enum': DebugDataField_ParamType.ENUM,
  'Document Reference': DebugDataField_ParamType.DOCUMENT_REFERENCE,
  'Document': DebugDataField_ParamType.DOCUMENT,
  'Supabase Row': DebugDataField_ParamType.SUPABASE_ROW,
  'Postgres Row': DebugDataField_ParamType.POSTGRES_ROW,
  'SQLite Row': DebugDataField_ParamType.SQLITE_ROW,
  'Action': DebugDataField_ParamType.ACTION,
};

/// A map that associates debug data field parameter types with corresponding
/// icons.
///
/// The keys of the map are instances of the [DebugDataField_ParamType] enum,
/// and the values are icons representing the parameter types.
final kFFDebugDataTypeToIconMap = {
  DebugDataField_ParamType.INT: FontAwesomeIcons.hashtag,
  DebugDataField_ParamType.DOUBLE: FontAwesomeIcons.percent,
  DebugDataField_ParamType.STRING: FFIcons.fonts,
  DebugDataField_ParamType.BOOL: Icons.toggle_on_outlined,
  DebugDataField_ParamType.DATE_TIME: Icons.access_time_sharp,
  DebugDataField_ParamType.DATE_TIME_RANGE: Icons.calendar_today_rounded,
  DebugDataField_ParamType.LAT_LNG: Icons.location_pin,
  DebugDataField_ParamType.COLOR: Icons.color_lens_outlined,
  DebugDataField_ParamType.FF_PLACE: FontAwesomeIcons.addressCard,
  DebugDataField_ParamType.FF_UPLOADED_FILE: FFIcons.uploaded_file,
  DebugDataField_ParamType.JSON: FontAwesomeIcons.database,
  DebugDataField_ParamType.DATA_STRUCT: FFIcons.data_types,
  DebugDataField_ParamType.ENUM: FFIcons.data_types,
  DebugDataField_ParamType.DOCUMENT_REFERENCE: FFIcons.database,
  DebugDataField_ParamType.DOCUMENT: FFIcons.database,
  DebugDataField_ParamType.SUPABASE_ROW: FFIcons.supabase,
  DebugDataField_ParamType.POSTGRES_ROW: FFIcons.postgres,
  DebugDataField_ParamType.SQLITE_ROW: FFIcons.database,
  DebugDataField_ParamType.ACTION: FFIcons.actions,
};

/// Extension on [DebugDataField] to provide additional functionality for getting
/// formatted values.
extension DebugDataFieldExtensions on DebugDataField {
  /// Returns the formatted value based on the type of the [DebugDataField].
  ///
  /// - If the type is [DebugDataField_ParamType.DATE_TIME], it formats the
  /// serialized value as a date and time.
  /// - If the type is [DebugDataField_ParamType.DATE_TIME_RANGE], it formats
  /// the serialized value as a date range.
  /// - If the type is [DebugDataField_ParamType.LAT_LNG], it replaces the
  /// comma in the serialized value with a comma and space.
  /// - For any other type, it returns the serialized value as is.
  String get value {
    var dateFormatter = DateFormat('dd MMM yyyy, h:mm a');
    switch (type) {
      case DebugDataField_ParamType.DATE_TIME:
        return dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(
            int.tryParse(serializedValue) ?? 0));
      case DebugDataField_ParamType.DATE_TIME_RANGE:
        final dateRange = serializedValue.split('|');
        final startDate = dateFormatter.format(
            DateTime.fromMillisecondsSinceEpoch(
                int.tryParse(dateRange[0]) ?? 0));
        final endDate = dateFormatter.format(
            DateTime.fromMillisecondsSinceEpoch(
                int.tryParse(dateRange[1]) ?? 0));
        return '$startDate to $endDate';
      case DebugDataField_ParamType.LAT_LNG:
        return serializedValue.replaceFirst(',', ', ');
      default:
        return serializedValue;
    }
  }

  /// Returns the serialized value formatted as a JSON string with indentation.
  /// If the serialized value cannot be parsed as JSON, it returns the
  /// serialized value as is.
  String get jsonFormattedValue {
    try {
      var encoder = const JsonEncoder.withIndent('    ');
      return encoder.convert(json.decode(serializedValue));
    } catch (_) {
      return serializedValue;
    }
  }
}

/// Deserializes the debug event data from a raw string.
///
/// The [rawEventData] parameter is the raw string containing the debug event data.
/// This function decodes the raw string into a JSON object and extracts the event
/// type, data source, and event data.
///
/// If the event type is 'variable', it switches on the event data source and
/// deserializes the corresponding debug data object using the serialized buffer
/// string.
void deserializeDebugEvent(String rawEventData) {
  var data = json.decode(rawEventData);

  final eventType = data['event_type'];
  final eventDataSource = data['data_source'];
  final eventData = data['data'];

  if (eventType == 'variable') {
    switch (eventDataSource) {
      case 'appState':
        variableDebugData.appState = AppStateDebugData()
          ..fromSerializedBufferString(eventData);
        break;
      case 'appConstant':
        variableDebugData.appConstant = AppConstantDebugData()
          ..fromSerializedBufferString(eventData);
        break;
      case 'environmentValue':
        variableDebugData.environmentValue = EnvironmentValueDebugData()
          ..fromSerializedBufferString(eventData);
        break;
      case 'globalProperty':
        variableDebugData.globalProperty = GlobalPropertyDebugData()
          ..fromSerializedBufferString(eventData);
        break;
      case 'authenticatedUser':
        variableDebugData.authenticatedUser = AuthenticatedUserDebugData()
          ..fromSerializedBufferString(eventData);
        break;
      case 'widgetClass':
        variableDebugData.widgetClass = WidgetClassDebugData()
          ..fromSerializedBufferString(eventData);
        break;
    }
  }
}

/// Returns an instance of singleton [VariableDebugData].
VariableDebugData get variableDebugData => VariableDebugData();

/// A class representing the debug data for variables.
///
/// It provides methods to convert the debug data into a tree structure
/// for visualization.
class VariableDebugData extends ChangeNotifier {
  factory VariableDebugData() => _instance;

  VariableDebugData._internal();
  static final VariableDebugData _instance = VariableDebugData._internal();

  GlobalPropertyDebugData? _globalProperty;
  AppStateDebugData? _appState;
  AppConstantDebugData? _appConstant;
  EnvironmentValueDebugData? _environmentValue;
  AuthenticatedUserDebugData? _authenticatedUser;
  WidgetClassDebugData? _widgetClass;
  String? projectId;

  GlobalPropertyDebugData? get globalProperty => _globalProperty;
  set globalProperty(GlobalPropertyDebugData? value) {
    _globalProperty = value;
    notifyListeners();
  }

  AppStateDebugData? get appState => _appState;
  set appState(AppStateDebugData? value) {
    _appState = value;
    notifyListeners();
  }

  AppConstantDebugData? get appConstant => _appConstant;
  set appConstant(AppConstantDebugData? value) {
    _appConstant = value;
    notifyListeners();
  }

  EnvironmentValueDebugData? get environmentValue => _environmentValue;
  set environmentValue(EnvironmentValueDebugData? value) {
    _environmentValue = value;
    notifyListeners();
  }

  AuthenticatedUserDebugData? get authenticatedUser => _authenticatedUser;
  set authenticatedUser(AuthenticatedUserDebugData? value) {
    _authenticatedUser = value;
    notifyListeners();
  }

  WidgetClassDebugData? get widgetClass => _widgetClass;
  set widgetClass(WidgetClassDebugData? value) {
    _widgetClass = value;
    notifyListeners();
  }

  /// Clears all the debug variables and notifies the listeners.
  void clear() {
    _globalProperty = null;
    _appState = null;
    _appConstant = null;
    _environmentValue = null;
    _authenticatedUser = null;
    _widgetClass = null;
    notifyListeners();
  }

  @override
  void dispose() {
    clear();
    super.dispose();
  }

  /// Converts a JSON map of debug data fields into a list of tree nodes.
  ///
  /// * [data] parameter is a JSON map of debug data fields.
  /// * [context] parameter is the build context.
  /// * [parentSectionType] parameter is the type of the parent debug section.
  ///
  /// Returns a list of tree nodes representing the debug data.
  List<TreeNode> _treeNodeFromJsonMap(
    Map<String, DebugDataField>? data,
    BuildContext context,
    TreeController treeController, {
    required DebugSectionType parentSectionType,
  }) {
    if (data == null) {
      return [];
    }
    return data.entries
        .map((e) => _dataFieldToTreeNode(
              e.key,
              treeController,
              e.value,
              context,
              parentSectionType: parentSectionType,
            ))
        .toList();
  }

  /// Converts a debug data field into a tree node.
  ///
  /// * [key] parameter is the key of the debug data field.
  /// * [dataField] parameter is the debug data field.
  /// * [context] parameter is the build context.
  /// * [parentSectionType] parameter is the type of the parent debug section.
  ///
  /// Returns a tree node representing the debug data field.
  TreeNode _dataFieldToTreeNode(
    String key,
    TreeController treeController,
    DebugDataField dataField,
    BuildContext context, {
    required DebugSectionType parentSectionType,
  }) {
    try {
      if (dataField.whichData() == DebugDataField_Data.listValue) {
        return narrowModalField(
          treeController: treeController,
          parentSectionType: parentSectionType,
          dataField: dataField,
          name: key,
          childrenNodes: dataField.listValue.values
              .mapIndexed(
                (i, field) => _dataFieldToTreeNode(
                  'Item [$i]',
                  treeController,
                  field,
                  context,
                  parentSectionType: parentSectionType,
                ),
              )
              .toList(),
        );
      }

      // Show the contents in a separate level if the data field is a data struct
      // or document.
      if ([
        DebugDataField_ParamType.DATA_STRUCT,
        DebugDataField_ParamType.DOCUMENT
      ].contains(dataField.type)) {
        return narrowModalField(
          treeController: treeController,
          parentSectionType: parentSectionType,
          dataField: dataField,
          name: key,
          childrenNodes: _treeNodeFromJsonMap(
            dataField.mapValue.values,
            context,
            treeController,
            parentSectionType: parentSectionType,
          ),
        );
      }
      return narrowModalField(
        treeController: treeController,
        name: key,
        dataField: dataField,
        parentSectionType: parentSectionType,
      );
    } catch (e) {
      return narrowModalField(
        treeController: treeController,
        name: key,
        dataField: dataField,
        parentSectionType: parentSectionType,
      );
    }
  }

  /// Converts the debug data into a list of tree nodes.
  ///
  /// * [context] parameter is the build context.
  ///
  /// Returns a list of tree nodes representing the debug data.
  List<TreeNode> toTreeNode(
    BuildContext context,
    TreeController controller,
  ) {
    return [
      if (widgetClass != null)
        ...widgetClassToTreeNode(
          widgetClass!,
          context,
          controller,
        ),
      narrowModalSection(
        context,
        sectionTitle: 'App State',
        childrenNodes: _treeNodeFromJsonMap(
          appState?.values,
          context,
          controller,
          parentSectionType: DebugSectionType.appState,
        ),
      ),
      narrowModalSection(
        context,
        sectionTitle: 'App Constants',
        childrenNodes: _treeNodeFromJsonMap(
          appConstant?.values,
          context,
          controller,
          parentSectionType: DebugSectionType.appConstants,
        ),
      ),
      narrowModalSection(
        context,
        sectionTitle: 'Global Properties',
        childrenNodes: _treeNodeFromJsonMap(
          globalProperty?.values,
          context,
          controller,
          parentSectionType: DebugSectionType.globalProperties,
        ),
      ),
      narrowModalSection(
        context,
        sectionTitle: 'Authenticated User',
        childrenNodes: _treeNodeFromJsonMap(
          authenticatedUser?.values,
          context,
          controller,
          parentSectionType: DebugSectionType.authenticatedUser,
        ),
      ),
      narrowModalSection(
        context,
        sectionTitle: 'Environment Values',
        childrenNodes: _treeNodeFromJsonMap(
          environmentValue?.values,
          context,
          controller,
          parentSectionType: DebugSectionType.environmentValues,
        ),
      ),
    ];
  }

  /// Converts a widget class debug data into a list of tree nodes.
  ///
  /// * [widgetClass] parameter is the widget class debug data.
  /// * [context] parameter is the build context.
  /// * [isSubLevel] parameter is a flag indicating whether the widget class is a sub-level.
  /// * [isComponent] parameter is a flag indicating whether the widget class is a component.
  ///
  /// Returns a list of tree nodes representing the widget class debug data.
  List<TreeNode> widgetClassToTreeNode(
    WidgetClassDebugData widgetClass,
    BuildContext context,
    TreeController controller, {
    isSubLevel = false,
    isComponent = false,
  }) {
    // Page Parameters
    final widgetParameterNodes = _treeNodeFromJsonMap(
      widgetClass.widgetParameters,
      context,
      controller,
      parentSectionType: DebugSectionType.pageParameters,
    );
    // Page State
    final localStateNodes = _treeNodeFromJsonMap(
      widgetClass.localStates,
      context,
      controller,
      parentSectionType: DebugSectionType.pageState,
    );
    // Widget State
    final widgetStateNodes = _treeNodeFromJsonMap(
      widgetClass.widgetStates,
      context,
      controller,
      parentSectionType: DebugSectionType.widgetState,
    );
    // Action Outputs
    final actionOutputNodes = _treeNodeFromJsonMap(
      widgetClass.actionOutputs,
      context,
      controller,
      parentSectionType: DebugSectionType.actionOutputs,
    );
    // Generator Variables
    final generatorVariablesNodes = _treeNodeFromJsonMap(
      widgetClass.generatorVariables,
      context,
      controller,
      parentSectionType: DebugSectionType.generatorVariables,
    );
    // Backend Queries
    final backendQueriesNodes = _treeNodeFromJsonMap(
      widgetClass.backendQueries,
      context,
      controller,
      parentSectionType: DebugSectionType.backendQueries,
    );
    // Components
    final componentStateNodes = widgetClass.componentStates.values
        .listMap(
          (component) => narrowModalSection(
            context,
            sectionTitle: component.widgetClassName,
            childrenNodes: widgetClassToTreeNode(
              component,
              context,
              controller,
              isSubLevel: true,
              isComponent: true,
            ),
          ),
        )
        .toList();
    // Dynamically Generated Components
    final dynamicComponentStateNodes =
        widgetClass.dynamicComponentStates.values.listMap(
      (dynamicComponent) {
        final dynamicallyGeneratedCompName = dynamicComponent
            .componentStates.values.firstOrNull?.widgetClassName;
        return narrowModalSection(
          context,
          sectionTitle:
              'Dynamically Generated ${dynamicallyGeneratedCompName ?? 'Component'}s',
          childrenNodes: dynamicComponent.componentStates.values
              .mapIndexed(
                (index, component) => narrowModalSection(
                  context,
                  isSubLevel: true,
                  sectionTitle: '${component.widgetClassName}[$index]',
                  childrenNodes: widgetClassToTreeNode(
                    component,
                    context,
                    controller,
                    isSubLevel: true,
                    isComponent: true,
                  ),
                ),
              )
              .toList(),
        );
      },
    ).toList();
    return [
      if (widgetParameterNodes.isNotEmpty)
        narrowModalSection(
          context,
          isSubLevel: isSubLevel,
          sectionTitle: '${isComponent ? 'Component' : 'Page'} Parameters',
          childrenNodes: widgetParameterNodes,
        ),
      if (localStateNodes.isNotEmpty)
        narrowModalSection(
          context,
          isSubLevel: isSubLevel,
          sectionTitle: '${isComponent ? 'Component' : 'Page'} State',
          childrenNodes: localStateNodes,
        ),
      if (widgetStateNodes.isNotEmpty)
        narrowModalSection(
          context,
          isSubLevel: isSubLevel,
          sectionTitle: 'Widget State',
          childrenNodes: widgetStateNodes,
        ),
      if (actionOutputNodes.isNotEmpty)
        narrowModalSection(
          context,
          isSubLevel: isSubLevel,
          sectionTitle: 'Action Output',
          childrenNodes: actionOutputNodes,
        ),
      if (generatorVariablesNodes.isNotEmpty)
        narrowModalSection(
          context,
          isSubLevel: isSubLevel,
          sectionTitle: 'Generator Variables',
          childrenNodes: generatorVariablesNodes,
        ),
      if (backendQueriesNodes.isNotEmpty)
        narrowModalSection(
          context,
          isSubLevel: isSubLevel,
          sectionTitle: 'Backend Queries',
          childrenNodes: backendQueriesNodes,
        ),
      if (componentStateNodes.isNotEmpty) ...componentStateNodes,
      if (dynamicComponentStateNodes.isNotEmpty) ...dynamicComponentStateNodes,
    ];
  }
}

extension SerializationExtensions on GeneratedMessage {
  String get serializedBufferString => base64.encode(writeToBuffer());
  void fromSerializedBufferString(String buffer, [int? recursionLimit]) {
    if (recursionLimit == null) {
      mergeFromBuffer(base64.decode(buffer));
      return;
    }

    final decodedInput = CodedBufferReader(
      base64.decode(buffer),
      recursionLimit: recursionLimit,
    );
    mergeFromCodedBufferReader(decodedInput);
  }
}
