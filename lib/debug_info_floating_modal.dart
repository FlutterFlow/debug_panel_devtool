// import 'package:debug_panel_proto/debug_panel_proto.dart';
// import 'package:easy_debounce/easy_debounce.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_webapp/src/pages/debug/debug_utils.dart';
// import 'package:flutter_webapp/src/pages/flutter_render_page/flutter_render_page.dart';
// import 'package:flutter_webapp/src/pages/project_page/run_mode_nav_bar.dart';
// import 'package:flutter_webapp/src/pages/workspace_page/widget_palette_panel/widget_palette_panel.dart';
// import 'package:flutter_webapp/src/property_editors/checkbox_boolean_property.dart';
// import 'package:flutter_webapp/src/property_editors/searchable_multiselect_dropdown_property.dart';
// import 'package:flutter_webapp/src/ui/flutterflow_ui_widgets.dart';
// import 'package:flutter_webapp/src/ui/theme.dart';
// import 'package:flutter_webapp/src/ui/widgets/narrow_modal.dart';
// import 'package:flutter_webapp/src/ui/widgets/tree_view/flutterflow_treeview.dart';
// import 'package:flutter_webapp/src/utils/analytics.dart';
// import 'package:flutter_webapp/src/utils/buttons.dart';
// import 'package:flutter_webapp/src/utils/flutterflow_button_tabbar.dart';
// import 'package:flutter_webapp/src/utils/modal_menu_button.dart';
// import 'package:flutter_webapp/src/utils/styled_tooltip.dart';
// import 'package:flutter_webapp/src/variables/flutterflow_frontend_operation.dart';
// import 'package:provider/provider.dart';
// import 'package:text_search/text_search.dart';

// /// A map that contains the names of different data types and their
// /// corresponding [DebugDataField_ParamType].
// const kDebugDataTypeNames = {
//   'Integer': DebugDataField_ParamType.INT,
//   'Double': DebugDataField_ParamType.DOUBLE,
//   'String': DebugDataField_ParamType.STRING,
//   'Boolean': DebugDataField_ParamType.BOOL,
//   'Date Time': DebugDataField_ParamType.DATE_TIME,
//   'Timestamp Range': DebugDataField_ParamType.DATE_TIME_RANGE,
//   'Lat Lng': DebugDataField_ParamType.LAT_LNG,
//   'Color': DebugDataField_ParamType.COLOR,
//   'Google Place': DebugDataField_ParamType.FF_PLACE,
//   'Uploaded File': DebugDataField_ParamType.FF_UPLOADED_FILE,
//   'JSON': DebugDataField_ParamType.JSON,
//   'Data Struct': DebugDataField_ParamType.DATA_STRUCT,
//   'Enum': DebugDataField_ParamType.ENUM,
//   'Document Reference': DebugDataField_ParamType.DOCUMENT_REFERENCE,
//   'Document': DebugDataField_ParamType.DOCUMENT,
//   'Supabase Row': DebugDataField_ParamType.SUPABASE_ROW,
//   'Postgres Row': DebugDataField_ParamType.POSTGRES_ROW,
//   'SQLite Row': DebugDataField_ParamType.SQLITE_ROW,
// };

// const kDebugInfoFloatingModalBottomBarHeight = 24.0;

// /// Enum representing the tabs in the Debug Panel.
// ///
// /// The tabs include:
// /// - `activityLogs`: Tab for displaying activity logs.
// /// - `variables`: Tab for displaying variables.
// enum DebugInfoTab {
//   activityLogs,
//   variables,
// }

// final _kDebugTabNames = {
//   // TODO (debug panel): Uncomment when Activity Logs are available
//   // DebugInfoTab.activityLogs: 'Activity Logs',
//   DebugInfoTab.variables: 'Variables',
// };

// /// A widget that displays debug panel information.
// class DebugInfoViewerWidget extends StatefulWidget {
//   // Creates widget to show debug information in a floating modal.
//   const DebugInfoViewerWidget({super.key});

//   @override
//   State<DebugInfoViewerWidget> createState() => _DebugInfoViewerWidgetState();
// }

// class _DebugInfoViewerWidgetState extends State<DebugInfoViewerWidget>
//     with TickerProviderStateMixin {
//   late TabController tabBarController;
//   int get tabBarCurrentIndex => tabBarController.index;

//   @override
//   void initState() {
//     super.initState();
//     tabBarController = TabController(
//       vsync: this,
//       // TODO (debug panel): Update length when Activity Logs are available
//       length: 1,
//     )..addListener(() => setState(() {}));
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         FlutterFlowButtonTabBar(
//           useToggleButtonStyle: false,
//           isScrollable: true,
//           labelStyle: productSans(
//             context,
//             size: kFontSize14px,
//             weight: FontWeight.bold,
//           ),
//           unselectedLabelStyle: productSans(context, size: kFontSize14px),
//           labelColor: context.theme.primaryText,
//           unselectedLabelColor: context.theme.secondaryText,
//           backgroundColor: context.theme.primaryAccent,
//           unselectedBackgroundColor: context.theme.secondaryBackground,
//           borderColor: context.theme.primaryColor,
//           unselectedBorderColor: context.theme.alternate,
//           borderWidth: 2,
//           borderRadius: 10,
//           labelPadding: const EdgeInsetsDirectional.symmetric(horizontal: 16),
//           buttonMargin: const EdgeInsets.only(left: kPadding12px),
//           tabs: _kDebugTabNames.values.listMap(
//             (t) => Tab(
//               text: t,
//               height: 36,
//             ),
//           ),
//           controller: tabBarController,
//         ),
//         const SizedBox(height: kPadding12px),
//         Flexible(
//           child: TabBarView(
//             physics: const NeverScrollableScrollPhysics(),
//             controller: tabBarController,
//             children: const [
//               // TODO (debug panel): Uncomment when Activity Logs are available
//               // ActivityLogsPanel(),
//               VariablesPanel(),
//             ],
//           ),
//         ),
//       ],
//     );
//   }
// }

// /// A panel that displays activity logs.
// class ActivityLogsPanel extends StatefulWidget {
//   /// Widget to display activity logs.
//   const ActivityLogsPanel({super.key});

//   @override
//   State<ActivityLogsPanel> createState() => _ActivityLogsPanelState();
// }

// class _ActivityLogsPanelState extends State<ActivityLogsPanel> {
//   final _textController = TextEditingController();
//   final _focusNode = FocusNode();

//   @override
//   void dispose() {
//     super.dispose();
//     _textController.dispose();
//     _focusNode.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         PanelSearchWidget(
//           autofocus: true,
//           controller: _textController,
//           focusNode: _focusNode,
//           onChanged: (val) {
//             EasyDebounce.debounce(
//               'debug-panel-activity-logs-debounce',
//               1.seconds,
//               () => ffLogEvent('debug-panel-logs-search', {'term': val}),
//             );
//           },
//           hintText: 'Search logs...',
//         ),
//       ],
//     );
//   }
// }

// /// A panel that displays variables for debugging purposes.
// class VariablesPanel extends StatefulWidget {
//   /// Widget to display debug panel variables section.
//   const VariablesPanel({super.key});

//   @override
//   State<VariablesPanel> createState() => _VariablesPanelState();
// }

// class _VariablesPanelState extends State<VariablesPanel> {
//   final _textController = TextEditingController();
//   final _focusNode = FocusNode();
//   late final TreeController _treeController;

//   List<DebugDataField_ParamType> _selectedFilterDataTypes = [];
//   bool _isShowOnlyNonNullableVariables = false;
//   bool _isShowOnlyVariablesWithNullValues = false;

//   @override
//   void initState() {
//     super.initState();
//     _treeController = TreeController(
//       onNodeToggled: (name) => ffLogEvent(
//         'debug-panel-toggle-section',
//         {'name': name},
//       ),
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     final shouldShowFilteredView = _textController.text.isNotEmpty ||
//         _selectedFilterDataTypes.isNotEmpty ||
//         _isShowOnlyNonNullableVariables ||
//         _isShowOnlyVariablesWithNullValues;
//     return Consumer<VariableDebugData>(
//       builder: (context, debugData, child) {
//         final variablesDebugTree = debugData.toTreeNode(context);
//         final originalDebugTree = variablesDebugTree
//             .where((s) => s.children?.isNotEmpty ?? false)
//             .toList();
//         final filteredDebugTree = shouldShowFilteredView
//             ? searchTreeNodes(
//                 variablesDebugTree,
//                 (data) {
//                   if (_selectedFilterDataTypes.isNotEmpty) {
//                     if (!_selectedFilterDataTypes.contains(data['type'])) {
//                       return false;
//                     }
//                   }
//                   if (_isShowOnlyNonNullableVariables) {
//                     if (data['isNullable'] ?? false) {
//                       return false;
//                     }
//                   }
//                   if (_isShowOnlyVariablesWithNullValues) {
//                     if (!(data['isValueNull'] ?? false)) {
//                       return false;
//                     }
//                   }
//                   final searchTerm = _textController.text;
//                   final textSearch = TextSearch(
//                     [
//                       TextSearchItem.fromTerms(
//                         data,
//                         [data['name'].toString().sentenceCase, data['value']]
//                             .where((e) => e != null)
//                             .map((e) => e!),
//                       )
//                     ],
//                   );
//                   return textSearch.search(searchTerm).isNotEmpty;
//                 },
//               )
//             : originalDebugTree;
//         return originalDebugTree.isNotEmpty
//             ? Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   PanelSearchWidget(
//                     controller: _textController,
//                     focusNode: _focusNode,
//                     onChanged: (val) {
//                       setState(() {});
//                       EasyDebounce.debounce(
//                         'debug-panel-var-debounce',
//                         1.seconds,
//                         () => ffLogEvent(
//                             'debug-panel-variable-search', {'term': val}),
//                       );
//                     },
//                     hintText: 'Search variables...',
//                     suffixIcons: [
//                       Padding(
//                         padding: const EdgeInsets.only(right: 4.0),
//                         child: FilterIconButton(
//                           onDataTypeSelected: (val) {
//                             ffLogEvent('debug-panel-variable-filter', {
//                               'type': 'data-type-selected',
//                               'value': val.map((e) => e.toString()).toList(),
//                             });
//                             setState(() => _selectedFilterDataTypes = val);
//                           },
//                           onShowOnlyNonNullableVariables: (val) {
//                             ffLogEvent('debug-panel-variable-filter', {
//                               'type': 'toggle-only-non-nullable-variables',
//                               'value': val,
//                             });
//                             setState(
//                                 () => _isShowOnlyNonNullableVariables = val);
//                           },
//                           onShowOnlyVariablesWithNullValues: (val) {
//                             ffLogEvent('debug-panel-variable-filter', {
//                               'type': 'toggle-variables-with-null',
//                               'value': val,
//                             });
//                             setState(
//                                 () => _isShowOnlyVariablesWithNullValues = val);
//                           },
//                           onClearAll: () {
//                             ffLogEvent(
//                               'debug-panel-variable-filter',
//                               {'type': 'clear all'},
//                             );
//                             setState(() {
//                               _selectedFilterDataTypes = [];
//                               _isShowOnlyNonNullableVariables = false;
//                               _isShowOnlyVariablesWithNullValues = false;
//                             });
//                           },
//                         ),
//                       ),
//                     ],
//                   ),
//                   Expanded(
//                     child: shouldShowFilteredView && filteredDebugTree.isEmpty
//                         ? Center(
//                             child: Column(
//                               mainAxisSize: MainAxisSize.min,
//                               children: [
//                                 Icon(
//                                   FFIcons.debug_icon,
//                                   color: context.theme.secondaryText,
//                                   size: kIconSize32px,
//                                 ),
//                                 const SizedBox(height: kPadding12px),
//                                 const SizedBox(width: kPadding8px),
//                                 Text(
//                                   'No variables match your search',
//                                   style: productSans(
//                                     context,
//                                     size: kFontSize16px,
//                                     color: context.theme.secondaryText,
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           )
//                         : SingleChildScrollView(
//                             child: Padding(
//                               padding: const EdgeInsets.all(kPadding8px),
//                               child: NarrowModal(
//                                 treeController: _treeController,
//                                 narrowModalSections: filteredDebugTree,
//                               ),
//                             ),
//                           ),
//                   ),
//                   Container(
//                     height: kDebugInfoFloatingModalBottomBarHeight,
//                     color: context.theme.dark400,
//                   )
//                 ],
//               )
//             : Center(
//                 child: Column(
//                   mainAxisSize: MainAxisSize.min,
//                   children: [
//                     Icon(
//                       FFIcons.debug_icon,
//                       color: context.theme.secondaryText,
//                       size: kIconSize32px,
//                     ),
//                     const SizedBox(height: kPadding12px),
//                     Row(
//                       mainAxisSize: MainAxisSize.min,
//                       children: [
//                         FFProgressIndicator(
//                           size: 16,
//                           strokeWidth: 2,
//                           color: context.theme.secondaryText,
//                         ),
//                         const SizedBox(width: kPadding8px),
//                         Text(
//                           'Waiting for debug data',
//                           style: productSans(
//                             context,
//                             size: kFontSize16px,
//                             color: context.theme.secondaryText,
//                           ),
//                         ),
//                       ],
//                     ),
//                   ],
//                 ),
//               );
//       },
//     );
//   }
// }

// /// A button widget that represents a debug filter icon.
// class FilterIconButton extends StatefulWidget {
//   /// Debug Filter Icon Button.
//   ///
//   /// * [onDataTypeSelected] callback is called when a data type is selected.
//   /// * [onShowOnlyNonNullableVariables] callback is called when the option to show only nullable variables is toggled.
//   /// * [onShowOnlyVariablesWithNullValues] callback is called when the option to show only variables with null values is toggled.
//   /// * [onClearAll] callback is called when the "Clear All" button is pressed.
//   const FilterIconButton({
//     super.key,
//     required this.onDataTypeSelected,
//     required this.onShowOnlyNonNullableVariables,
//     required this.onShowOnlyVariablesWithNullValues,
//     required this.onClearAll,
//   });

//   /// A callback function that is called when a data type is selected.
//   final Function(List<DebugDataField_ParamType>) onDataTypeSelected;

//   /// A callback function that is called when the option to show only nullable variables is toggled.
//   final Function(bool) onShowOnlyNonNullableVariables;

//   /// A callback function that is called when the option to show only variables with null values is toggled.
//   final Function(bool) onShowOnlyVariablesWithNullValues;

//   /// A callback function that is called when the "Clear All" button is pressed.
//   final VoidCallback onClearAll;

//   @override
//   State<FilterIconButton> createState() => _FilterIconButtonState();
// }

// class _FilterIconButtonState extends State<FilterIconButton> {
//   List<DebugDataField_ParamType> _selectedFilterDataTypes = [];
//   bool _isShowOnlyNonNullableVariables = false;
//   bool _isShowOnlyVariablesWithNullValues = false;

//   @override
//   Widget build(BuildContext context) {
//     return ModalMenuButton(
//       buttonBuilder: (toggleMenuFn) => StyledTooltip(
//         message: 'Filters',
//         preferredDirection: AxisDirection.up,
//         child: InkWell(
//           onTap: () => toggleMenuFn(eventName: 'toggle-filters-menu'),
//           // onTap: controller.isOpen ? controller.close : controller.open,
//           child: Icon(
//             FFIcons.filter,
//             color: context.theme.panelTextColor2,
//             size: kIconSize16px,
//           ),
//         ),
//       ),
//       menuBuilder: (removeMenuFn) =>
//           StatefulBuilder(builder: (context, setState) {
//         return Container(
//           width: 300,
//           decoration: BoxDecoration(
//             color: context.theme.panelColor,
//             borderRadius: BorderRadius.circular(8),
//             border: Border.all(
//               color: context.theme.panelBorderColor,
//             ),
//           ),
//           child: Padding(
//             padding: const EdgeInsets.all(kPadding16px),
//             child: Column(
//               mainAxisSize: MainAxisSize.min,
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Row(
//                   children: [
//                     Text(
//                       'Variable Filters',
//                       style: productSans(
//                         context,
//                         size: kFontSize16px,
//                         weight: FontWeight.bold,
//                       ),
//                     ),
//                     const Spacer(),
//                     FFButtonWidget(
//                       onPressed: () {
//                         _selectedFilterDataTypes.clear();
//                         _isShowOnlyNonNullableVariables = false;
//                         _isShowOnlyVariablesWithNullValues = false;
//                         setState(() {});
//                         widget.onClearAll();
//                         removeMenuFn();
//                       },
//                       text: 'CLEAR ALL',
//                       options: FFButtonOptions(
//                         height: kHeight24px,
//                         color: context.theme.dark400,
//                         elevation: 0,
//                         borderRadius: BorderRadius.circular(30),
//                         textStyle: productSans(
//                           context,
//                           color: context.theme.panelTextColor2,
//                           size: kFontSize12px,
//                         ),
//                       ),
//                     ),
//                   ],
//                 ),
//                 const SizedBox(height: kPadding8px),
//                 SearchableMultiselectDropdownProperty<DebugDataField_ParamType>(
//                   (val) {
//                     setState(() => _selectedFilterDataTypes =
//                         List<DebugDataField_ParamType>.from(val));
//                     widget.onDataTypeSelected(_selectedFilterDataTypes);
//                   },
//                   currentValue: _selectedFilterDataTypes,
//                   nameToValue: kDebugDataTypeNames,
//                   propertyLabel: 'Data Type',
//                   noItemSelectedText: 'Select Data Type...',
//                   noItemsFoundText: 'Data type not found',
//                   node: null,
//                   projectUpdateType: ProjectUpdateType.setState,
//                 ),
//                 const SizedBox(height: kPadding8px),
//                 CheckboxBooleanProperty(
//                   (val) {
//                     setState(() => _isShowOnlyNonNullableVariables = val);
//                     widget.onShowOnlyNonNullableVariables(val);
//                   },
//                   labelText: 'Show only non-nullable variables',
//                   currentValue: _isShowOnlyNonNullableVariables,
//                   textStyle: productSans(
//                     context,
//                     size: kFontSize14px,
//                     weight: FontWeight.normal,
//                     color: context.theme.panelGrey,
//                   ),
//                   projectUpdateType: ProjectUpdateType.setState,
//                   node: null,
//                   tooltipIconSize: 16,
//                 ),
//                 CheckboxBooleanProperty(
//                   (val) {
//                     setState(() => _isShowOnlyVariablesWithNullValues = val);
//                     widget.onShowOnlyVariablesWithNullValues(val);
//                   },
//                   labelText: 'Show only variables with null values',
//                   currentValue: _isShowOnlyVariablesWithNullValues,
//                   textStyle: productSans(
//                     context,
//                     size: kFontSize14px,
//                     weight: FontWeight.normal,
//                     color: context.theme.panelGrey,
//                   ),
//                   projectUpdateType: ProjectUpdateType.setState,
//                   node: null,
//                   tooltipIconSize: 16,
//                 ),
//               ],
//             ),
//           ),
//         );
//       }),
//     );
//   }
// }
