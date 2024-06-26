import 'package:auto_size_text/auto_size_text.dart';
import 'package:debug_panel_devtool/src/consts/theme_values.dart';
import 'package:debug_panel_devtool/src/widgets/styled_tooltip.dart';
import 'package:debug_panel_devtool/themes/flutter_flow_default_theme.dart';
import 'package:flutter/material.dart';

class PropertyNameWidget extends StatelessWidget {
  const PropertyNameWidget({
    super.key,
    this.name,
    this.bottomPadding = kPadding4px,
    this.fontSize,
    this.highlight = false,
    this.fontWeight = FontWeight.normal,
    this.fontStyle,
    this.tooltipText,
    this.warningTooltipText,
    this.tooltipDirection,
  });

  final String? name;
  final double? fontSize;
  final double bottomPadding;
  final bool? highlight;
  final FontWeight? fontWeight;
  final FontStyle? fontStyle;
  final String? tooltipText;
  final String? warningTooltipText;
  final AxisDirection? tooltipDirection;

  @override
  Widget build(BuildContext context) => Column(
        children: [
          Row(
            children: [
              AutoSizeText(
                name!,
                style: context.theme.propertyName.copyWith(
                  color: highlight!
                      ? context.theme.primaryText
                      : context.theme.secondaryText,
                  fontWeight: fontWeight,
                  fontSize: fontSize,
                  fontStyle: fontStyle,
                ),
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
              ),
              if (warningTooltipText != null || tooltipText != null) ...[
                const SizedBox(width: kPadding4px),
                StyledTooltip(
                  message: warningTooltipText ?? tooltipText,
                  preferredDirection: tooltipDirection ?? AxisDirection.down,
                  child: Icon(
                    warningTooltipText != null
                        ? Icons.warning_amber_rounded
                        : Icons.info_outline,
                    color: warningTooltipText != null
                        ? context.theme.tertiary
                        : context.theme.tooltip,
                    size: kIconSize14px,
                  ),
                ),
              ],
            ],
          ),
          SizedBox(height: bottomPadding),
        ],
      );
}
