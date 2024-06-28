import 'dart:async';

import 'package:debug_panel_devtool/src/consts/theme_values.dart';
import 'package:debug_panel_devtool/src/utils/debug_utils.dart';
import 'package:debug_panel_devtool/src/utils/ff_icons.dart';
import 'package:debug_panel_devtool/src/utils/ff_utils.dart';
import 'package:debug_panel_devtool/src/widgets/filter_icon_button.dart';
import 'package:debug_panel_devtool/src/widgets/flutter_flow_progress_indicator.dart';
import 'package:debug_panel_devtool/src/widgets/narrow_modal.dart';
import 'package:debug_panel_devtool/src/widgets/panel_search.dart';
import 'package:debug_panel_devtool/themes/flutter_flow_default_theme.dart';
import 'package:debug_panel_proto/debug_panel_proto.dart';
import 'package:devtools_extensions/devtools_extensions.dart';
import 'package:easy_debounce/easy_debounce.dart';
import 'package:flutter/material.dart';
import 'package:flutterflow_tree_view/flutterflow_tree_view.dart';
import 'package:provider/provider.dart';
import 'package:recase/recase.dart';
import 'package:text_search/text_search.dart';
import 'package:vm_service/vm_service.dart';

/// A panel that displays debug variables.
class DebugVariablesPanel extends StatefulWidget {
  const DebugVariablesPanel({
    super.key,
    required this.onEvent,
  });

  final Function(String name, Map<String, dynamic>? params) onEvent;

  @override
  State<DebugVariablesPanel> createState() => _DebugVariablesPanelState();
}

class _DebugVariablesPanelState extends State<DebugVariablesPanel> {
  final _textController = TextEditingController();
  final _focusNode = FocusNode();
  late final TreeController _treeController;
  late final StreamSubscription extensionEventSubscription;
  late final VmService vmService;

  List<DebugDataField_ParamType> _selectedFilterDataTypes = [];
  bool _isShowOnlyNonNullableVariables = false;
  bool _isShowOnlyVariablesWithNullValues = false;

  /// Handles the application event.
  Future<void> _appEventHandler() async {
    vmService = await serviceManager.onServiceAvailable;
    extensionEventSubscription = vmService.onExtensionEvent.listen((event) {
      // Check whether it's a FlutterFlow debug data event.
      final isUpdateEvent =
          event.extensionKind == 'ext.debug_panel_devtool.updateDebugData';
      if (!isUpdateEvent) return;

      deserializeDebugEvent(event.extensionData!.data['data'] as String);
    });
  }

  @override
  void initState() {
    super.initState();
    _treeController = TreeController(
      onNodeToggled: (name) {
        if (mounted) {
          setState(() {});
        }
        logEvent(
          'debug-panel-toggle-section',
          {'name': name},
        );
      },
      onTreeEvent: (event) => widget.onEvent(event.name, event.params),
    );
    _appEventHandler();
  }

  @override
  void dispose() {
    extensionEventSubscription.cancel();
    vmService.dispose();
    super.dispose();
  }

  /// Logs an event with the given name and parameters.
  void logEvent(String name, Map<String, dynamic> params) =>
      _treeController.onEvent((name: name, params: params));

  @override
  Widget build(BuildContext context) {
    final shouldShowFilteredView = _textController.text.isNotEmpty ||
        _selectedFilterDataTypes.isNotEmpty ||
        _isShowOnlyNonNullableVariables ||
        _isShowOnlyVariablesWithNullValues;
    return Consumer<VariableDebugData>(
      builder: (context, debugData, child) {
        final variablesDebugTree =
            debugData.toTreeNode(context, _treeController);
        final originalDebugTree = variablesDebugTree
            .where((s) => s.children?.isNotEmpty ?? false)
            .toList();
        final filteredDebugTree = shouldShowFilteredView
            ? searchTreeNodes(
                variablesDebugTree,
                (data) {
                  if (_selectedFilterDataTypes.isNotEmpty) {
                    if (!_selectedFilterDataTypes.contains(data['type'])) {
                      return false;
                    }
                  }
                  if (_isShowOnlyNonNullableVariables) {
                    if (data['isNullable'] ?? false) {
                      return false;
                    }
                  }
                  if (_isShowOnlyVariablesWithNullValues) {
                    if (!(data['isValueNull'] ?? false)) {
                      return false;
                    }
                  }
                  final searchTerm = _textController.text;
                  final textSearch = TextSearch(
                    [
                      TextSearchItem.fromTerms(
                        data,
                        [data['name'].toString().sentenceCase, data['value']]
                            .where((e) => e != null)
                            .map((e) => e!),
                      )
                    ],
                  );
                  return textSearch.search(searchTerm).isNotEmpty;
                },
              )
            : originalDebugTree;
        return originalDebugTree.isNotEmpty
            ? Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  PanelSearchWidget(
                    controller: _textController,
                    focusNode: _focusNode,
                    onChanged: (val) {
                      setState(() {});
                      EasyDebounce.debounce(
                        'debug-panel-var-debounce',
                        1.seconds,
                        () => logEvent(
                            'debug-panel-variable-search', {'term': val}),
                      );
                    },
                    hintText: 'Search variables...',
                    suffixIcons: [
                      Padding(
                        padding: const EdgeInsets.only(right: 4.0),
                        child: FilterIconButton(
                          onDataTypeSelected: (val) {
                            logEvent('debug-panel-variable-filter', {
                              'type': 'data-type-selected',
                              'value': val.map((e) => e.toString()).toList(),
                            });
                            setState(() => _selectedFilterDataTypes = val);
                          },
                          onShowOnlyNonNullableVariables: (val) {
                            logEvent('debug-panel-variable-filter', {
                              'type': 'toggle-only-non-nullable-variables',
                              'value': val,
                            });
                            setState(
                                () => _isShowOnlyNonNullableVariables = val);
                          },
                          onShowOnlyVariablesWithNullValues: (val) {
                            logEvent('debug-panel-variable-filter', {
                              'type': 'toggle-variables-with-null',
                              'value': val,
                            });
                            setState(
                                () => _isShowOnlyVariablesWithNullValues = val);
                          },
                          onClearAll: () {
                            logEvent(
                              'debug-panel-variable-filter',
                              {'type': 'clear all'},
                            );
                            setState(() {
                              _selectedFilterDataTypes = [];
                              _isShowOnlyNonNullableVariables = false;
                              _isShowOnlyVariablesWithNullValues = false;
                            });
                          },
                        ),
                      ),
                    ],
                  ),
                  Expanded(
                    child: shouldShowFilteredView && filteredDebugTree.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisSize: MainAxisSize.min,
                              children: [
                                Icon(
                                  FFIcons.debug_icon,
                                  color: context.theme.secondaryText,
                                  size: kIconSize32px,
                                ),
                                const SizedBox(height: kPadding12px),
                                const SizedBox(width: kPadding8px),
                                Text(
                                  'No variables match your search',
                                  style: productSans(
                                    context,
                                    size: kFontSize16px,
                                    color: context.theme.secondaryText,
                                  ),
                                ),
                              ],
                            ),
                          )
                        : NarrowModal(
                            treeController: _treeController,
                            narrowModalSections: filteredDebugTree,
                          ),
                  ),
                ],
              )
            : Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Icon(
                      FFIcons.debug_icon,
                      color: context.theme.secondaryText,
                      size: kIconSize32px,
                    ),
                    const SizedBox(height: kPadding12px),
                    Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        FlutterFlowProgressIndicator(
                          size: 16,
                          strokeWidth: 2,
                          color: context.theme.secondaryText,
                        ),
                        const SizedBox(width: kPadding8px),
                        Text(
                          'Waiting for debug data',
                          style: productSans(
                            context,
                            size: kFontSize16px,
                            color: context.theme.secondaryText,
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              );
      },
    );
  }
}
