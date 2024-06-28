import 'package:debug_panel_devtool/src/consts/theme_values.dart';
import 'package:debug_panel_devtool/src/utils/debug_utils.dart';
import 'package:debug_panel_devtool/src/utils/ff_icons.dart';
import 'package:debug_panel_devtool/src/widgets/flutter_flow_button.dart';
import 'package:debug_panel_devtool/src/widgets/flutter_flow_checkbox.dart';
import 'package:debug_panel_devtool/src/widgets/flutter_flow_multiselect_dropdown.dart';
import 'package:debug_panel_devtool/src/widgets/model_menu_button.dart';
import 'package:debug_panel_devtool/src/widgets/styled_tooltip.dart';
import 'package:debug_panel_devtool/src/themes/flutter_flow_default_theme.dart';
import 'package:debug_panel_proto/debug_panel_proto.dart';
import 'package:flutter/material.dart';

/// A button widget that represents a debug filter icon.
class FilterIconButton extends StatefulWidget {
  /// Debug Filter Icon Button.
  ///
  /// * [onDataTypeSelected] callback is called when a data type is selected.
  /// * [onShowOnlyNonNullableVariables] callback is called when the option to show only nullable variables is toggled.
  /// * [onShowOnlyVariablesWithNullValues] callback is called when the option to show only variables with null values is toggled.
  /// * [onClearAll] callback is called when the "Clear All" button is pressed.
  const FilterIconButton({
    super.key,
    required this.onDataTypeSelected,
    required this.onShowOnlyNonNullableVariables,
    required this.onShowOnlyVariablesWithNullValues,
    required this.onClearAll,
  });

  /// A callback function that is called when a data type is selected.
  final Function(List<DebugDataField_ParamType>) onDataTypeSelected;

  /// A callback function that is called when the option to show only nullable variables is toggled.
  final Function(bool) onShowOnlyNonNullableVariables;

  /// A callback function that is called when the option to show only variables with null values is toggled.
  final Function(bool) onShowOnlyVariablesWithNullValues;

  /// A callback function that is called when the "Clear All" button is pressed.
  final VoidCallback onClearAll;

  @override
  State<FilterIconButton> createState() => _FilterIconButtonState();
}

class _FilterIconButtonState extends State<FilterIconButton> {
  List<DebugDataField_ParamType> _selectedFilterDataTypes = [];
  bool _isShowOnlyNonNullableVariables = false;
  bool _isShowOnlyVariablesWithNullValues = false;

  @override
  Widget build(BuildContext context) {
    return ModalMenuButton(
      buttonBuilder: (toggleMenuFn) => StyledTooltip(
        message: 'Filters',
        preferredDirection: AxisDirection.up,
        child: InkWell(
          onTap: () => toggleMenuFn(eventName: 'toggle-filters-menu'),
          child: Icon(
            FFIcons.filter,
            color: context.theme.panelTextColor2,
            size: kIconSize16px,
          ),
        ),
      ),
      menuBuilder: (removeMenuFn) =>
          StatefulBuilder(builder: (context, setState) {
        return Container(
          width: 300,
          decoration: BoxDecoration(
            color: context.theme.panelColor,
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: context.theme.panelBorderColor,
            ),
          ),
          child: Padding(
            padding: const EdgeInsets.all(kPadding16px),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      'Variable Filters',
                      style: productSans(
                        context,
                        size: kFontSize16px,
                        weight: FontWeight.bold,
                      ),
                    ),
                    const Spacer(),
                    FlutterFlowButton(
                      onPressed: () {
                        _selectedFilterDataTypes.clear();
                        _isShowOnlyNonNullableVariables = false;
                        _isShowOnlyVariablesWithNullValues = false;
                        setState(() {});
                        widget.onClearAll();
                        removeMenuFn();
                      },
                      text: 'CLEAR ALL',
                      options: FlutterFlowButtonOptions(
                        height: kHeight24px,
                        color: context.theme.dark400,
                        elevation: 0,
                        borderRadius: BorderRadius.circular(30),
                        textStyle: productSans(
                          context,
                          color: context.theme.panelTextColor2,
                          size: kFontSize12px,
                        ),
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: kPadding8px),
                SearchableMultiselectDropdownProperty<DebugDataField_ParamType>(
                  (val) {
                    setState(() => _selectedFilterDataTypes =
                        List<DebugDataField_ParamType>.from(val));
                    widget.onDataTypeSelected(_selectedFilterDataTypes);
                  },
                  currentValue: _selectedFilterDataTypes,
                  nameToValue: kDebugDataTypeNames,
                  propertyLabel: 'Data Type',
                  noItemSelectedText: 'Select Data Type...',
                  noItemsFoundText: 'Data type not found',
                ),
                const SizedBox(height: kPadding8px),
                CheckboxBooleanProperty(
                  (val) {
                    setState(() => _isShowOnlyNonNullableVariables = val);
                    widget.onShowOnlyNonNullableVariables(val);
                  },
                  labelText: 'Show only non-nullable variables',
                  currentValue: _isShowOnlyNonNullableVariables,
                  textStyle: productSans(
                    context,
                    size: kFontSize14px,
                    weight: FontWeight.normal,
                    color: context.theme.secondaryText,
                  ),
                  tooltipIconSize: 16,
                ),
                CheckboxBooleanProperty(
                  (val) {
                    setState(() => _isShowOnlyVariablesWithNullValues = val);
                    widget.onShowOnlyVariablesWithNullValues(val);
                  },
                  labelText: 'Show only variables with null values',
                  currentValue: _isShowOnlyVariablesWithNullValues,
                  textStyle: productSans(
                    context,
                    size: kFontSize14px,
                    weight: FontWeight.normal,
                    color: context.theme.secondaryText,
                  ),
                  tooltipIconSize: 16,
                ),
              ],
            ),
          ),
        );
      }),
    );
  }
}
