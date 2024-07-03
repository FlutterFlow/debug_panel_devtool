import 'package:flutterflow_debug_panel/src/consts/theme_values.dart';
import 'package:flutterflow_debug_panel/src/utils/debug_utils.dart';
import 'package:flutterflow_debug_panel/src/utils/ff_icons.dart';
import 'package:flutterflow_debug_panel/src/utils/ff_utils.dart';
import 'package:flutterflow_debug_panel/src/themes/flutter_flow_default_theme.dart';
import 'package:debug_panel_proto/debug_panel_proto.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_debug_panel/src/widgets/debug_tree_view.dart';
import 'package:flutterflow_debug_panel/src/widgets/node_widget.dart';
import 'package:flutterflow_tree_view/flutterflow_tree_view.dart';

import 'action_text.dart';
import 'styled_tooltip.dart';

class NarrowModal extends StatelessWidget {
  /// Widget that displays a narrow modal with sections.
  ///
  /// * [narrowModalSections] parameter is required and represents the list of
  /// tree nodes that will be displayed in the narrow modal.
  ///
  /// * [treeController] parameter is optional and represents the tree controller
  /// to manage the tree state.
  const NarrowModal({
    super.key,
    required this.narrowModalSections,
    required this.treeController,
    this.listGradientColor,
  });

  /// The list of tree nodes that will be displayed in the narrow modal.
  final List<TreeNode> narrowModalSections;

  /// The tree controller to manage the tree state.
  final TreeController treeController;

  final Color? listGradientColor;

  @override
  Widget build(BuildContext context) {
    return DebugTreeView(
      treeController: treeController,
      listGradientColor: listGradientColor,
      listPadding: const EdgeInsets.only(
        top: kPadding16px,
        left: kPadding8px,
        right: kPadding8px,
        bottom: kPadding8px,
      ),
      nodeBuilder: (context, flattenedNode) => NodeWidget(
        treeNode: flattenedNode.node,
        state: treeController,
        level: flattenedNode.level,
        style: NodeStyle(
          levelIndent: kPadding12px,
          arrowIconSize: kIconSize16px,
          arrowIcon: FFIcons.arrow_down,
          arrowIconPrimaryColor: context.theme.white,
          arrowIconSecondaryColor: context.theme.secondaryText
              .withOpacity(context.theme.isLightMode ? 0.5 : 1),
          backgroundErrorColor: context.theme.messageRed.withOpacity(0.25),
        ),
      ),
      nodes: narrowModalSections
          .where((s) => s.children?.isNotEmpty ?? false)
          .toList(),
    );
  }
}

/// A widget that represents the content of a narrow modal field.
class NarrowModalFieldContent extends StatelessWidget {
  /// Constructs a widget that represents the content of a narrow modal field.
  ///
  /// * [dataField] is the [DebugDataField] object containing the field's data.
  /// * [name] of the field.
  /// * [hasChildren] indicates whether the field has children.
  /// * [parentSectionType] is the type of the parent section, it takes a
  /// [DebugSectionType] value.
  ///
  /// All parameters are required.
  const NarrowModalFieldContent({
    super.key,
    required this.treeController,
    required this.dataField,
    required this.name,
    required this.hasChildren,
    required this.parentSectionType,
  });

  final TreeController treeController;
  final DebugDataField dataField;
  final String name;
  final bool hasChildren;
  final DebugSectionType parentSectionType;

  void logEvent(String name, [Map<String, dynamic>? params]) =>
      treeController.onEvent((name: name, params: params));

  @override
  Widget build(BuildContext context) {
    // This is used to determine if the field is a route and should be opened
    // in the UI builder.
    // TODO (debug panel): Update this to use the correct FF's page path.
    // final isAppRoute =
    //     parentSectionType == DebugSectionType.globalProperty && name == 'route';
    // final builderLink = isAppRoute
    //     ? '$appBaseUrl${ProjectPage.routeFromId(variableDebugData.projectId)}?tab=uiBuilder&page=${dataField.value.substring(1).split('?').first}'
    //     : null;
    final isList = dataField.whichData() == DebugDataField_Data.listValue;
    final isDataStruct = dataField.type == DebugDataField_ParamType.DATA_STRUCT;
    final isDocumentOrRef = [
      DebugDataField_ParamType.DOCUMENT,
      DebugDataField_ParamType.DOCUMENT_REFERENCE
    ].contains(dataField.type);
    final isNullable = dataField.nullable;
    // Determine if the field is a string and should be displayed in quotes.
    final isString = !(isList || isDataStruct) &&
        dataField.type == DebugDataField_ParamType.STRING;
    // Determine if the field value should be displayed as "Null".
    final isValueNull = !(dataField.hasSerializedValue() ||
        dataField.hasListValue() ||
        dataField.hasMapValue());

    final iconData = isList
        ? FFIcons.list
        : isDataStruct
            ? FFIcons.data_types
            : kFFDebugDataTypeToIconMap[dataField.type] ??
                Icons.question_mark_rounded;

    final textValue = isValueNull
        ? 'Null'
        : dataField.value.isEmpty
            ? 'Empty'
            : isString
                ? '"${dataField.value}"'
                : dataField.value;
    final textValueStyle = monospace(
      context,
      size: 14,
      color: isValueNull && !isNullable
          ? context.theme.messageRed
          : isValueNull || dataField.value.isEmpty
              ? context.theme.secondaryText.withOpacity(0.6)
              : context.theme.primaryText,
    ).copyWith(
      fontStyle: isValueNull || dataField.value.isEmpty
          ? FontStyle.italic
          : FontStyle.normal,
    );
    // Determine if the field value is a URL.
    final isValueUrl =
        RegExp(r'\b(?:https?:\/\/|www\.)[^\s:@]+\.[a-z]{2,10}\b([^\s]*)')
            .hasMatch(textValue);

    final dataTypeName =
        (isDataStruct || isDocumentOrRef) && dataField.name.isNotEmpty
            ? dataField.name
            : kDebugDataTypeNames.reversed[dataField.type] ?? 'Unknown';
    return Expanded(
      child: Row(
        children: [
          StyledTooltip(
            preferredDirection: AxisDirection.up,
            textWidget: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      iconData,
                      color: context.theme.primaryText,
                      size: 16,
                    ),
                    const SizedBox(width: 8),
                    Text(
                      isList ? 'List<$dataTypeName>' : dataTypeName,
                      style: TextStyle(
                        color: context.theme.primaryText,
                        fontSize: 14,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Product Sans',
                      ),
                    ),
                    Text(
                      dataField.nullable
                          ? ', Allowed to be null'
                          : ', Can\'t be null',
                      style: TextStyle(
                        color: context.theme.secondaryText,
                        fontSize: 14,
                        fontFamily: 'Product Sans',
                      ),
                    ),
                  ],
                ),
              ],
            ),
            child: Stack(
              clipBehavior: Clip.none,
              children: [
                Icon(
                  iconData,
                  color: isValueNull && !isNullable
                      ? context.theme.messageRed
                      : context.theme.secondaryText,
                  size: 16,
                ),
                if (isNullable)
                  Positioned(
                    top: -8,
                    left: 14,
                    child: CircleAvatar(
                      backgroundColor: Colors.transparent,
                      radius: 5,
                      child: Icon(
                        Icons.question_mark_rounded,
                        color: isValueNull && !isNullable
                            ? context.theme.messageRed
                            : context.theme.secondaryText,
                        size: 9,
                      ),
                    ),
                  ),
              ],
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            flex: hasChildren ? 1 : 0,
            child: Text(
              name,
              maxLines: 1,
              style: productSans(
                context,
                size: 14,
                color: isValueNull && !isNullable
                    ? context.theme.messageRed
                    : context.theme.secondaryText,
              ),
              overflow: TextOverflow.ellipsis,
            ),
          ),
          const SizedBox(width: 8),
          if (!hasChildren)
            Expanded(
              child: Align(
                alignment: Alignment.centerRight,
                child: StyledTooltip(
                  textWidget: isValueNull || dataField.value.isEmpty
                      ? null
                      : ConstrainedBox(
                          constraints: const BoxConstraints(
                            maxWidth: 300,
                            maxHeight: 300,
                          ),
                          child: SelectableText(
                            [
                              DebugDataField_ParamType.JSON,
                              DebugDataField_ParamType.FF_PLACE
                            ].contains(dataField.type)
                                ? dataField.jsonFormattedValue
                                : dataField.value,
                            style: TextStyle(
                              color: context.theme.isLightMode
                                  ? context.theme.panelTextColor1
                                  : Colors.white,
                              fontSize: 14,
                              fontFamily: 'Product Sans',
                            ),
                          ),
                        ),
                  preferredDirection: AxisDirection.up,
                  child: isValueUrl
                      ? LinkText(
                          textValue,
                          url: isValueNull || dataField.value.isEmpty
                              ? null
                              : dataField.value,
                          hoverContainerColor: context.theme.greenAccent,
                          isIconAlwaysVisible: false,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                          textStyle: textValueStyle,
                          onOpen: () => logEvent('debug-panel-open-link'),
                        )
                      : CopyText(
                          textValue,
                          copyText: isValueNull || dataField.value.isEmpty
                              ? null
                              : dataField.value,
                          hoverContainerColor: context.theme.panelBorderColor,
                          copySnackbarMessage: 'Copied "$name" value!',
                          isIconAlwaysVisible: false,
                          maxLines: 1,
                          textOverflow: TextOverflow.ellipsis,
                          textStyle: textValueStyle,
                          onCopy: () => logEvent('debug-panel-copy-value'),
                        ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}

/// Creates a [TreeNode] for a narrow modal field.
///
/// * [name] parameter is the name of the field.
/// * [dataField] parameter is the [DebugDataField] object containing the field's data.
/// * [childrenNodes] parameter is an optional list of child [TreeNode] objects.
///
/// Returns a [TreeNode] object representing the narrow modal field.
TreeNode narrowModalField({
  required TreeController treeController,
  required String name,
  required DebugDataField dataField,
  List<TreeNode> childrenNodes = const [],
  required DebugSectionType parentSectionType,
}) {
  final isValueNull = !(dataField.hasSerializedValue() ||
      dataField.hasListValue() ||
      dataField.hasMapValue());
  return TreeNode(
    name: name,
    content: NarrowModalFieldContent(
      treeController: treeController,
      dataField: dataField,
      name: name,
      hasChildren: childrenNodes.isNotEmpty,
      parentSectionType: parentSectionType,
    ),
    children: childrenNodes,
    isSubLevel: true,
    isError: isValueNull && !dataField.nullable,
    metaData: {
      'name': name,
      'value': dataField.value,
      'type': dataField.type,
      'isNullable': dataField.nullable,
      'isValueNull': isValueNull,
      'link': dataField.link.isEmpty ? null : dataField.link,
      'searchReference':
          dataField.searchReference.isEmpty ? null : dataField.searchReference,
    },
  );
}

/// Creates a [TreeNode] widget for a narrow modal section.
///
/// This widget is used to display a section in a narrow modal. It consists of a [sectionTitle],
/// an optional [icon], and a list of [childrenNodes]. The [isSubLevel] parameter indicates
/// whether the section is a sub-level section. The [metaData] parameter can be used to attach
/// additional data to the section.
///
/// Example usage:
/// ```dart
/// TreeNode section = narrowModalSection(
///   context,
///   isSubLevel: true,
///   sectionTitle: 'Section Title',
///   icon: Icons.category,
///   childrenNodes: [
///     TreeNode(content: Text('Child 1')),
///     TreeNode(content: Text('Child 2')),
///   ],
/// );
/// ```
TreeNode narrowModalSection(
  BuildContext context, {
  required String sectionTitle,
  String? subtitle,
  IconData? icon,
  required List<TreeNode> childrenNodes,
  bool isSubLevel = false,
}) =>
    TreeNode(
      name: sectionTitle,
      content: Expanded(
        child: Row(
          children: [
            if (icon != null) ...[
              Icon(
                icon,
                color: isSubLevel
                    ? context.theme.secondaryText
                    : context.theme.primaryText,
                size: 16,
              ),
              const SizedBox(width: 8),
            ],
            Text(
              sectionTitle,
              style: productSans(
                context,
                size: 14,
                color: isSubLevel
                    ? context.theme.secondaryText
                    : context.theme.primaryText,
              ),
            ),
            if (subtitle != null)
              Text(
                subtitle,
                style: productSans(
                  context,
                  size: 14,
                  color: context.theme.secondaryText,
                ),
              ),
          ],
        ),
      ),
      isSubLevel: isSubLevel,
      children: childrenNodes,
      metaData: {
        'name': sectionTitle,
      },
    );
