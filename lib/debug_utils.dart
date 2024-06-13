// import 'dart:convert';

// import 'package:debug_panel_proto/debug_panel_proto.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_webapp/src/ui/widgets/narrow_modal.dart';
// import 'package:flutter_webapp/src/ui/widgets/tree_view/flutterflow_treeview.dart';
// import 'package:flutter_webapp/src/utils/ff_icons.dart';
// import 'package:flutterflow_codegen/components/flutterflow_module.dart';
// import 'package:font_awesome_flutter/font_awesome_flutter.dart';
// import 'package:intl/intl.dart';

// /// Enum representing the types of debug sections.
// ///
// /// Used to categorize different types of debug sections. It includes the
// /// following types:
// ///
// /// - [appState]: Represents the app state debug section.
// /// - [appConstant]: Represents the app constant debug section.
// /// - [globalProperty]: Represents the global property debug section.
// /// - [authenticatedUser]: Represents the authenticated user debug section.
// /// - [widgetClass]: Represents the widget class debug section.
// enum DebugSectionType {
//   pageState,
//   pageParameters,
//   componentState,
//   componentParameters,
//   appState,
//   appConstants,
//   globalProperties,
//   authenticatedUser,
//   widgetState,
//   actionOutputs,
// }

// /// A map that associates debug data field parameter types with corresponding
// /// icons.
// ///
// /// The keys of the map are instances of the [DebugDataField_ParamType] enum,
// /// and the values are icons representing the parameter types.
// final kFFDebugDataTypeToIconMap = {
//   DebugDataField_ParamType.INT: FontAwesomeIcons.hashtag,
//   DebugDataField_ParamType.DOUBLE: FontAwesomeIcons.percent,
//   DebugDataField_ParamType.STRING: FFIcons.fonts,
//   DebugDataField_ParamType.BOOL: Icons.toggle_on_outlined,
//   DebugDataField_ParamType.DATE_TIME: Icons.access_time_sharp,
//   DebugDataField_ParamType.DATE_TIME_RANGE: Icons.calendar_today_rounded,
//   DebugDataField_ParamType.LAT_LNG: Icons.location_pin,
//   DebugDataField_ParamType.COLOR: Icons.color_lens_outlined,
//   DebugDataField_ParamType.FF_PLACE: FontAwesomeIcons.addressCard,
//   DebugDataField_ParamType.FF_UPLOADED_FILE: FFIcons.uploaded_file,
//   DebugDataField_ParamType.JSON: FontAwesomeIcons.database,
//   DebugDataField_ParamType.DATA_STRUCT: FFIcons.data_types,
//   DebugDataField_ParamType.ENUM: FFIcons.data_types,
//   DebugDataField_ParamType.DOCUMENT_REFERENCE: FFIcons.database,
//   DebugDataField_ParamType.DOCUMENT: FFIcons.database,
//   DebugDataField_ParamType.SUPABASE_ROW: FFIcons.supabase,
//   DebugDataField_ParamType.POSTGRES_ROW: FFIcons.postgres,
//   DebugDataField_ParamType.SQLITE_ROW: FFIcons.database,
// };

// /// Extension on [DebugDataField] to provide additional functionality for getting
// /// formatted values.
// extension DebugDataFieldExtensions on DebugDataField {
//   /// Returns the formatted value based on the type of the [DebugDataField].
//   ///
//   /// - If the type is [DebugDataField_ParamType.DATE_TIME], it formats the
//   /// serialized value as a date and time.
//   /// - If the type is [DebugDataField_ParamType.DATE_TIME_RANGE], it formats
//   /// the serialized value as a date range.
//   /// - If the type is [DebugDataField_ParamType.LAT_LNG], it replaces the
//   /// comma in the serialized value with a comma and space.
//   /// - For any other type, it returns the serialized value as is.
//   String get value {
//     var dateFormatter = DateFormat('dd MMM yyyy, h:mm a');
//     switch (type) {
//       case DebugDataField_ParamType.DATE_TIME:
//         return dateFormatter.format(DateTime.fromMillisecondsSinceEpoch(
//             int.tryParse(serializedValue) ?? 0));
//       case DebugDataField_ParamType.DATE_TIME_RANGE:
//         final dateRange = serializedValue.split('|');
//         final startDate = dateFormatter.format(
//             DateTime.fromMillisecondsSinceEpoch(
//                 int.tryParse(dateRange[0]) ?? 0));
//         final endDate = dateFormatter.format(
//             DateTime.fromMillisecondsSinceEpoch(
//                 int.tryParse(dateRange[1]) ?? 0));
//         return '$startDate to $endDate';
//       case DebugDataField_ParamType.LAT_LNG:
//         return serializedValue.replaceFirst(',', ', ');
//       default:
//         return serializedValue;
//     }
//   }

//   /// Returns the serialized value formatted as a JSON string with indentation.
//   /// If the serialized value cannot be parsed as JSON, it returns the
//   /// serialized value as is.
//   String get jsonFormattedValue {
//     try {
//       var encoder = const JsonEncoder.withIndent('    ');
//       return encoder.convert(json.decode(serializedValue));
//     } catch (_) {
//       return serializedValue;
//     }
//   }
// }

// /// Deserializes the debug event data from a raw string.
// ///
// /// The [rawEventData] parameter is the raw string containing the debug event data.
// /// This function decodes the raw string into a JSON object and extracts the event
// /// type, data source, and event data.
// ///
// /// If the event type is 'variable', it switches on the event data source and
// /// deserializes the corresponding debug data object using the serialized buffer
// /// string.
// void deserializeDebugEvent(String rawEventData) {
//   final VariableDebugData variableDataView = VariableDebugData();
//   var data = json.decode(rawEventData);

//   final eventType = data['event_type'];
//   final eventDataSource = data['data_source'];
//   final eventData = data['data'];

//   if (eventType == 'variable') {
//     switch (eventDataSource) {
//       case 'appState':
//         variableDataView.appState = AppStateDebugData()
//           ..fromSerializedBufferString(eventData);
//         break;
//       case 'appConstant':
//         variableDataView.appConstant = AppConstantDebugData()
//           ..fromSerializedBufferString(eventData);
//         break;
//       case 'globalProperty':
//         variableDataView.globalProperty = GlobalPropertyDebugData()
//           ..fromSerializedBufferString(eventData);
//         break;
//       case 'authenticatedUser':
//         variableDataView.authenticatedUser = AuthenticatedUserDebugData()
//           ..fromSerializedBufferString(eventData);
//         break;
//       case 'widgetClass':
//         variableDataView.widgetClass = WidgetClassDebugData()
//           ..fromSerializedBufferString(eventData);
//         break;
//     }
//   } else {
//     // TODO: Handle activity logs events
//   }
// }

// /// A class representing the debug data for variables.
// ///
// /// It provides methods to convert the debug data into a tree structure
// /// for visualization.
// class VariableDebugData extends ChangeNotifier {
//   factory VariableDebugData() => _instance;

//   VariableDebugData._internal();
//   static final VariableDebugData _instance = VariableDebugData._internal();

//   GlobalPropertyDebugData? _globalProperty;
//   AppStateDebugData? _appState;
//   AppConstantDebugData? _appConstant;
//   AuthenticatedUserDebugData? _authenticatedUser;
//   WidgetClassDebugData? _widgetClass;
//   String? projectId;

//   GlobalPropertyDebugData? get globalProperty => _globalProperty;
//   set globalProperty(GlobalPropertyDebugData? value) {
//     _globalProperty = value;
//     notifyListeners();
//   }

//   AppStateDebugData? get appState => _appState;
//   set appState(AppStateDebugData? value) {
//     _appState = value;
//     notifyListeners();
//   }

//   AppConstantDebugData? get appConstant => _appConstant;
//   set appConstant(AppConstantDebugData? value) {
//     _appConstant = value;
//     notifyListeners();
//   }

//   AuthenticatedUserDebugData? get authenticatedUser => _authenticatedUser;
//   set authenticatedUser(AuthenticatedUserDebugData? value) {
//     _authenticatedUser = value;
//     notifyListeners();
//   }

//   WidgetClassDebugData? get widgetClass => _widgetClass;
//   set widgetClass(WidgetClassDebugData? value) {
//     _widgetClass = value;
//     notifyListeners();
//   }

//   /// Converts a JSON map of debug data fields into a list of tree nodes.
//   ///
//   /// * [data] parameter is a JSON map of debug data fields.
//   /// * [context] parameter is the build context.
//   ///
//   /// Returns a list of tree nodes representing the debug data.
//   List<TreeNode> treeNodeFromJsonMap(
//     Map<String, DebugDataField>? data,
//     BuildContext context, {
//     required DebugSectionType parentSectionType,
//   }) {
//     if (data == null) {
//       return [];
//     }
//     return data.entries
//         .map((e) => dataFieldToTreeNode(
//               e.key,
//               e.value,
//               context,
//               parentSectionType: parentSectionType,
//             ))
//         .toList();
//   }

//   /// Converts a debug data field into a tree node.
//   ///
//   /// * [key] parameter is the key of the debug data field.
//   /// * [dataField] parameter is the debug data field.
//   /// * [context] parameter is the build context.
//   /// * [parentSectionType] parameter is the type of the parent debug section.
//   ///
//   /// Returns a tree node representing the debug data field.
//   TreeNode dataFieldToTreeNode(
//     String key,
//     DebugDataField dataField,
//     BuildContext context, {
//     required DebugSectionType parentSectionType,
//   }) {
//     try {
//       if (dataField.whichData() == DebugDataField_Data.listValue) {
//         return narrowModalField(
//           parentSectionType: parentSectionType,
//           dataField: dataField,
//           name: key,
//           childrenNodes: dataField.listValue.values
//               .mapIndexed(
//                 (i, field) => dataFieldToTreeNode(
//                   'Item [$i]',
//                   field,
//                   context,
//                   parentSectionType: parentSectionType,
//                 ),
//               )
//               .toList(),
//         );
//       }

//       final type = dataField.type;

//       if (type == DebugDataField_ParamType.DATA_STRUCT) {
//         return narrowModalField(
//           parentSectionType: parentSectionType,
//           dataField: dataField,
//           name: key,
//           childrenNodes: treeNodeFromJsonMap(
//             dataField.mapValue.values,
//             context,
//             parentSectionType: parentSectionType,
//           ),
//         );
//       }
//       return narrowModalField(
//         name: key,
//         dataField: dataField,
//         parentSectionType: parentSectionType,
//       );
//     } catch (e) {
//       return narrowModalField(
//         name: key,
//         dataField: dataField,
//         parentSectionType: parentSectionType,
//       );
//     }
//   }

//   /// Converts the debug data into a list of tree nodes.
//   ///
//   /// * [context] parameter is the build context.
//   ///
//   /// Returns a list of tree nodes representing the debug data.
//   List<TreeNode> toTreeNode(BuildContext context) {
//     return [
//       if (widgetClass != null) ...widgetClassToTreeNode(widgetClass!, context),
//       narrowModalSection(
//         context,
//         sectionTitle: 'App State',
//         childrenNodes: treeNodeFromJsonMap(
//           appState?.values,
//           context,
//           parentSectionType: DebugSectionType.appState,
//         ),
//       ),
//       narrowModalSection(
//         context,
//         sectionTitle: 'App Constants',
//         childrenNodes: treeNodeFromJsonMap(
//           appConstant?.values,
//           context,
//           parentSectionType: DebugSectionType.appConstants,
//         ),
//       ),
//       narrowModalSection(
//         context,
//         sectionTitle: 'Global Properties',
//         childrenNodes: treeNodeFromJsonMap(
//           globalProperty?.values,
//           context,
//           parentSectionType: DebugSectionType.globalProperties,
//         ),
//       ),
//       narrowModalSection(
//         context,
//         sectionTitle: 'Authenticated User',
//         childrenNodes: treeNodeFromJsonMap(
//           authenticatedUser?.values,
//           context,
//           parentSectionType: DebugSectionType.authenticatedUser,
//         ),
//       ),
//     ];
//   }

//   /// Converts a widget class debug data into a list of tree nodes.
//   ///
//   /// * [widgetClass] parameter is the widget class debug data.
//   /// * [context] parameter is the build context.
//   /// * [isSubLevel] parameter is a flag indicating whether the widget class is a sub-level.
//   /// * [isComponent] parameter is a flag indicating whether the widget class is a component.
//   ///
//   /// Returns a list of tree nodes representing the widget class debug data.
//   List<TreeNode> widgetClassToTreeNode(
//     WidgetClassDebugData widgetClass,
//     BuildContext context, {
//     isSubLevel = false,
//     isComponent = false,
//   }) {
//     // Page Parameters
//     final widgetParameterNodes = treeNodeFromJsonMap(
//       widgetClass.widgetParameters,
//       context,
//       parentSectionType: DebugSectionType.pageParameters,
//     );
//     // Page State
//     final localStateNodes = treeNodeFromJsonMap(
//       widgetClass.localStates,
//       context,
//       parentSectionType: DebugSectionType.pageState,
//     );
//     // Widget State
//     final widgetStateNodes = treeNodeFromJsonMap(
//       widgetClass.widgetStates,
//       context,
//       parentSectionType: DebugSectionType.widgetState,
//     );
//     // Action Outputs
//     final actionOutputNodes = treeNodeFromJsonMap(
//       widgetClass.actionOutputs,
//       context,
//       parentSectionType: DebugSectionType.actionOutputs,
//     );
//     // Components
//     final componentStateNodes = widgetClass.componentStates.values
//         .listMap(
//           (component) => narrowModalSection(
//             context,
//             sectionTitle: component.widgetClassName,
//             childrenNodes: widgetClassToTreeNode(
//               component,
//               context,
//               isSubLevel: true,
//               isComponent: true,
//             ),
//           ),
//         )
//         .toList();
//     // Dynamically Generated Components
//     final dynamicComponentStateNodes =
//         widgetClass.dynamicComponentStates.values.listMap(
//       (dynamicComponent) {
//         final dynamicallyGeneratedCompName = dynamicComponent
//             .componentStates.values.firstOrNull?.widgetClassName;
//         return narrowModalSection(
//           context,
//           sectionTitle:
//               'Dynamically Generated ${dynamicallyGeneratedCompName ?? 'Component'}s',
//           childrenNodes: dynamicComponent.componentStates.values
//               .mapIndexed(
//                 (index, component) => narrowModalSection(
//                   context,
//                   isSubLevel: true,
//                   sectionTitle: '${component.widgetClassName}[$index]',
//                   childrenNodes: widgetClassToTreeNode(
//                     component,
//                     context,
//                     isSubLevel: true,
//                     isComponent: true,
//                   ),
//                 ),
//               )
//               .toList(),
//         );
//       },
//     ).toList();
//     return [
//       if (widgetParameterNodes.isNotEmpty)
//         narrowModalSection(
//           context,
//           isSubLevel: isSubLevel,
//           sectionTitle: '${isComponent ? 'Component' : 'Page'} Parameters',
//           childrenNodes: widgetParameterNodes,
//         ),
//       if (localStateNodes.isNotEmpty)
//         narrowModalSection(
//           context,
//           isSubLevel: isSubLevel,
//           sectionTitle: '${isComponent ? 'Component' : 'Page'} State',
//           childrenNodes: localStateNodes,
//         ),
//       if (widgetStateNodes.isNotEmpty)
//         narrowModalSection(
//           context,
//           isSubLevel: isSubLevel,
//           sectionTitle: 'Widget State',
//           childrenNodes: widgetStateNodes,
//         ),
//       if (actionOutputNodes.isNotEmpty)
//         narrowModalSection(
//           context,
//           isSubLevel: isSubLevel,
//           sectionTitle: 'Action Output',
//           childrenNodes: actionOutputNodes,
//         ),
//       if (componentStateNodes.isNotEmpty) ...componentStateNodes,
//       if (dynamicComponentStateNodes.isNotEmpty) ...dynamicComponentStateNodes,
//     ];
//   }
// }
