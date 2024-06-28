import 'package:debug_panel_devtool/src/consts/theme_values.dart';
import 'package:debug_panel_devtool/src/widgets/styled_tooltip.dart';
import 'package:debug_panel_devtool/src/themes/flutter_flow_default_theme.dart';
import 'package:flutter/material.dart';

class CheckboxBooleanProperty extends StatefulWidget {
  const CheckboxBooleanProperty(
    this.callback, {
    Key? key,
    required this.labelText,
    required this.currentValue,
    this.labelPrefix,
    this.labelFontSize,
    this.tooltipText,
    this.warningTooltipText,
    this.tooltipOnText = false,
    this.tooltipDirection = AxisDirection.up,
    this.isToggleIcon = false,
    this.disabled = false,
    this.forVisibility = false,
    this.textStyle,
    this.tooltipIconSize = kIconSize14px,
    // required ProjectUpdateType projectUpdateType,
    this.checkboxPadding,
  });

  final bool? currentValue;
  final Function(bool val) callback;
  final String labelText;
  final String? labelPrefix;
  final double? labelFontSize;
  final String? tooltipText;
  final String? warningTooltipText;
  final bool tooltipOnText;
  final AxisDirection tooltipDirection;
  final bool isToggleIcon;
  final bool disabled;
  final bool forVisibility;
  final TextStyle? textStyle;
  final double tooltipIconSize;
  final EdgeInsets? checkboxPadding;

  @override
  State<CheckboxBooleanProperty> createState() =>
      _CheckboxBooleanPropertyState();
}

class _CheckboxBooleanPropertyState extends State<CheckboxBooleanProperty> {
  String get overrideLabel =>
      widget.labelPrefix != null && widget.labelPrefix!.isNotEmpty
          ? '${widget.labelPrefix} > ${widget.labelText}'
          : widget.labelText;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: const Color(0xFF323B45),
        disabledColor: const Color.fromARGB(255, 175, 180, 186),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisSize: MainAxisSize.min,
        children: [
          SizedBox(
            height: 32.0,
            child: LabeledCheckbox(
              title: widget.labelText.isNotEmpty
                  ? StyledTooltip(
                      message:
                          widget.tooltipText != null && widget.tooltipOnText
                              ? widget.tooltipText
                              : null,
                      child: Text(
                        widget.labelText,
                        style: widget.textStyle ??
                            TextStyle(
                              color: context.theme.panelTextColor1,
                              fontFamily: 'Product Sans',
                              fontWeight: FontWeight.bold,
                              fontSize: 13,
                            ),
                      ),
                    )
                  : null,
              padding: widget.checkboxPadding ?? EdgeInsets.zero,
              value: widget.currentValue,
              onChanged: widget.disabled
                  ? null
                  : (newValue) => widget.callback(newValue!),
              activeColor: context.theme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(15.0),
              ),
              checkColor: Colors.white,
              trailing: widget.tooltipText != null && !widget.tooltipOnText
                  ? StyledTooltip(
                      preferredDirection: widget.tooltipDirection,
                      message: widget.tooltipText,
                      child: Icon(
                        Icons.info_outline,
                        color: context.theme.tooltip,
                        size: widget.tooltipIconSize,
                      ),
                    )
                  : null,
            ),
          ),
        ],
      ),
    );
  }
}

class LabeledCheckbox extends StatelessWidget {
  const LabeledCheckbox({
    super.key,
    required this.title,
    required this.value,
    required this.onChanged,
    this.padding = const EdgeInsets.symmetric(vertical: kPadding8px),
    this.activeColor,
    this.checkColor,
    this.shape,
    this.trailing,
    this.autoFocus = false,
  });

  final Widget? title;
  final EdgeInsets padding;
  final bool? value;
  final Function(bool?)? onChanged;
  final Color? activeColor;
  final Color? checkColor;
  final OutlinedBorder? shape;
  final Widget? trailing;
  final bool autoFocus;

  @override
  Widget build(BuildContext context) {
    return Theme(
      data: Theme.of(context).copyWith(
        unselectedWidgetColor: const Color(0xFF323B45),
        checkboxTheme: CheckboxThemeData(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(3),
          ),
        ),
        hoverColor: Colors.transparent,
        splashColor: Colors.transparent,
      ),
      child: Padding(
        padding: const EdgeInsets.only(left: 2.0),
        child: Row(
          children: [
            InkWell(
              onTap: () => onChanged == null ? null : onChanged!(!value!),
              autofocus: autoFocus,
              child: Padding(
                padding: padding,
                child: Row(
                  children: [
                    SizedBox(
                      width: 16,
                      height: 16,
                      child: Checkbox(
                        value: value,
                        onChanged: onChanged,
                        activeColor: activeColor,
                        checkColor: checkColor,
                        side: BorderSide(
                          color: context.theme.panelBorderColor,
                          width: kBorderWidth1_5px,
                        ),
                      ),
                    ),
                    if (title != null) ...[
                      const SizedBox(width: kPadding8px),
                      title!
                    ],
                  ],
                ),
              ),
            ),
            if (trailing != null) ...[
              const SizedBox(width: kPadding4px),
              trailing!
            ]
          ],
        ),
      ),
    );
  }
}
