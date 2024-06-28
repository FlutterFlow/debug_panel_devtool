import 'package:auto_size_text/auto_size_text.dart';
import 'package:debug_panel_devtool/src/consts/theme_values.dart';
import 'package:debug_panel_devtool/src/utils/ff_utils.dart';
import 'package:debug_panel_devtool/src/widgets/styled_tooltip.dart';
import 'package:debug_panel_devtool/src/themes/flutter_flow_default_theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

class FlutterFlowButtonOptions {
  const FlutterFlowButtonOptions({
    this.textAlign,
    this.textStyle,
    this.elevation,
    this.height,
    this.width,
    this.padding,
    this.color,
    this.disabledColor,
    this.disabledTextColor,
    this.splashColor,
    this.iconSize,
    this.iconColor,
    this.iconPadding,
    this.borderRadius,
    this.borderSide,
    this.hoverColor,
    this.hoverBorderSide,
    this.hoverTextColor,
    this.hoverElevation,
    this.maxLines,
  });

  factory FlutterFlowButtonOptions.smallPrimary(
    BuildContext context, {
    double? width,
    Color? textColor,
  }) =>
      FlutterFlowButtonOptions(
        height: kHeight36px,
        width: width,
        color: context.theme.primary,
        disabledColor: context.theme.dark300,
        textStyle: productSans(
          context,
          size: kFontSize14px,
          color: textColor ?? Colors.white,
          weight: FontWeight.bold,
        ),
      );

  factory FlutterFlowButtonOptions.smallSecondary(
    BuildContext context, {
    double? width,
  }) =>
      FlutterFlowButtonOptions(
        height: kHeight36px,
        width: width,
        elevation: kElevation0,
        color: context.theme.panelColor,
        hoverColor: context.theme.isLightMode
            ? context.theme.panelColor.darken(5)
            : context.theme.panelColor.brighten(5),
        borderSide: BorderSide(
          color: context.theme.panelBorderColor,
        ),
        textStyle: productSans(
          context,
          size: kFontSize14px,
          weight: FontWeight.bold,
        ),
      );

  factory FlutterFlowButtonOptions.mediumPrimary(
    BuildContext context, {
    Color? color,
    double? width,
    double? iconSize,
    BorderRadius? borderRadius,
  }) =>
      FlutterFlowButtonOptions(
        height: kHeight40px,
        width: width,
        iconSize: iconSize,
        color: color ?? context.theme.primary,
        borderRadius: borderRadius,
        textStyle: productSans(
          context,
          color: Colors.white,
          weight: FontWeight.bold,
        ),
      );

  factory FlutterFlowButtonOptions.mediumSecondary(
    BuildContext context, {
    Color? color,
    double? width,
    double? iconSize,
    BorderRadius? borderRadius,
  }) =>
      FlutterFlowButtonOptions(
        height: kHeight40px,
        width: width,
        iconSize: iconSize,
        color: color ?? context.theme.primaryBackground,
        borderRadius: borderRadius,
        textStyle: productSans(
          context,
          color: context.theme.white,
          weight: FontWeight.bold,
        ),
      );

  factory FlutterFlowButtonOptions.largePrimary(
    BuildContext context, {
    Color? color,
    double? width,
    double? height,
    double? iconSize,
  }) =>
      FlutterFlowButtonOptions(
        disabledColor: context.theme.dark300,
        height: height ?? kHeight48px,
        width: width,
        iconSize: iconSize,
        color: color ?? context.theme.primary,
        disabledTextColor: context.theme.white.withOpacity(0.5),
        textStyle: productSans(
          context,
          color: Colors.white,
          size: kFontSize16px,
          weight: FontWeight.bold,
        ),
      );

  factory FlutterFlowButtonOptions.largeSecondary(
    BuildContext context, {
    Color? color,
    double? height,
    double? width,
    double? iconSize,
    BorderRadius? borderRadius,
  }) =>
      FlutterFlowButtonOptions(
        height: height ?? kHeight48px,
        width: width,
        iconSize: iconSize,
        color: color ?? context.theme.primaryBackground,
        borderRadius: borderRadius,
        textStyle: productSans(
          context,
          color: context.theme.white,
          weight: FontWeight.bold,
        ),
      );

  factory FlutterFlowButtonOptions.dialogSmallPrimary(
    BuildContext context, {
    double? width,
    double? fontSize,
  }) =>
      FlutterFlowButtonOptions(
        height: kHeight36px,
        width: width,
        color: context.theme.primary,
        textStyle: productSans(
          context,
          size: fontSize ?? kFontSize16px,
          color: Colors.white,
          weight: FontWeight.bold,
        ),
        disabledColor: context.theme.primary.withOpacity(0.5),
        disabledTextColor: Colors.white54,
      );

  factory FlutterFlowButtonOptions.dialogSmallSecondary(
    BuildContext context, {
    double? width,
    double? fontSize,
    bool hover = false,
  }) =>
      FlutterFlowButtonOptions(
        height: kHeight36px,
        width: width,
        elevation: kElevation0,
        color: context.theme.panelColor,
        hoverColor: !hover
            ? context.theme.isLightMode
                ? context.theme.panelColor.darken(5)
                : context.theme.panelColor.brighten(5)
            : null,
        borderSide: BorderSide(
          color: context.theme.panelBorderColor,
        ),
        textStyle: productSans(
          context,
          size: fontSize ?? kFontSize16px,
          weight: FontWeight.bold,
        ),
      );

  factory FlutterFlowButtonOptions.dialogMediumSecondary(
    BuildContext context, {
    double? width,
  }) =>
      FlutterFlowButtonOptions(
        height: kHeight40px,
        width: width ?? kWidth80px,
        elevation: kElevation0,
        color: context.theme.panelColor,
        hoverColor: context.theme.isLightMode
            ? context.theme.panelColor.darken(5)
            : context.theme.panelColor.brighten(5),
        borderSide: BorderSide(
          color: context.theme.panelBorderColor,
        ),
        textStyle: productSans(
          context,
          weight: FontWeight.bold,
        ),
      );

  factory FlutterFlowButtonOptions.dialogMediumPrimary(
    BuildContext context, {
    double? width,
    Color? disabledColor,
    Color? disabledTextColor,
  }) =>
      FlutterFlowButtonOptions(
        height: kHeight40px,
        width: width ?? kWidth80px,
        elevation: kElevation0,
        color: context.theme.primary,
        disabledColor: disabledColor ?? context.theme.primary.withOpacity(0.5),
        disabledTextColor: disabledTextColor ?? Colors.white.withOpacity(0.5),
        textStyle: productSans(
          context,
          color: Colors.white,
          weight: FontWeight.bold,
        ),
      );

  factory FlutterFlowButtonOptions.dialogLargeBluePrimary(
    BuildContext context, {
    double? width,
    Color? disabledColor,
    Color? disabledTextColor,
  }) =>
      FlutterFlowButtonOptions(
        height: kHeight48px,
        width: width,
        elevation: kElevation0,
        color: context.theme.primary,
        disabledColor: disabledColor ?? context.theme.primary.withOpacity(0.5),
        disabledTextColor: disabledTextColor,
        textStyle: productSans(
          context,
          color: Colors.white,
          weight: FontWeight.bold,
        ),
      );

  factory FlutterFlowButtonOptions.dialogLargeOrangePrimary(
    BuildContext context, {
    double? width,
  }) =>
      FlutterFlowButtonOptions(
        height: kHeight48px,
        width: width,
        elevation: kElevation0,
        color: context.theme.tertiary.withOpacity(kOpacity0_4),
        hoverColor: context.theme.tertiary.withOpacity(kOpacity0_6),
        borderSide: BorderSide(
          color: context.theme.tertiary,
          width: kBorderWidth1_5px,
        ),
        hoverBorderSide: BorderSide(
          color: context.theme.tertiary,
          width: kBorderWidth2px,
        ),
        textStyle: productSans(
          context,
          color: context.theme.white,
          weight: FontWeight.bold,
        ),
      );

  factory FlutterFlowButtonOptions.dialogLargeSecondary(
    BuildContext context, {
    double? width,
  }) =>
      FlutterFlowButtonOptions(
        height: kHeight48px,
        width: width ?? kWidth80px,
        elevation: kElevation0,
        color: context.theme.panelColor,
        hoverColor: context.theme.isLightMode
            ? context.theme.panelColor.darken(5)
            : context.theme.panelColor.brighten(5),
        borderSide: BorderSide(
          color: context.theme.panelBorderColor,
        ),
        textStyle: productSans(
          context,
          weight: FontWeight.bold,
        ),
      );

  factory FlutterFlowButtonOptions.largeHollow(
    BuildContext context, {
    double? width,
    double? height,
    Color? color,
    Color? textColor,
    FontWeight? fontWeight,
    double? opacity,
    double? hoverOpacity,
    EdgeInsetsGeometry? padding,
  }) {
    final buttonColor = color ?? context.theme.tertiary;
    final colorOpacity = opacity ?? kOpacity0_4;
    final hoverColorOpacity = hoverOpacity ?? kOpacity0_6;
    return FlutterFlowButtonOptions(
      height: height ?? kHeight48px,
      width: width,
      elevation: kElevation0,
      iconSize: kIconSize22px,
      padding: padding,
      color: buttonColor.withOpacity(colorOpacity),
      hoverColor: buttonColor.withOpacity(hoverColorOpacity),
      borderSide: BorderSide(
        color: buttonColor,
        width: kBorderWidth1_5px,
      ),
      hoverBorderSide: BorderSide(
        color: buttonColor,
        width: kBorderWidth2px,
      ),
      textStyle: productSans(
        context,
        color: textColor ?? context.theme.white,
        weight: fontWeight ?? FontWeight.bold,
      ),
    );
  }

  factory FlutterFlowButtonOptions.smallHollow(
    BuildContext context, {
    double? width,
    double? height,
    Color? color,
    Color? textColor,
    FontWeight? fontWeight,
    double? opacity,
    double? hoverOpacity,
    double? borderWidth,
    double? hoverBorderWidth,
    Color? borderColor,
    Color? hoverBorderColor,
    EdgeInsetsGeometry? padding,
  }) {
    final buttonColor = color ?? context.theme.tertiary;
    final colorOpacity = opacity ?? kOpacity0_4;
    final hoverColorOpacity = hoverOpacity ?? kOpacity0_6;
    return FlutterFlowButtonOptions(
      height: height ?? kHeight36px,
      width: width,
      elevation: kElevation0,
      iconSize: kIconSize20px,
      padding: padding,
      color: buttonColor.withOpacity(colorOpacity),
      hoverColor: buttonColor.withOpacity(hoverColorOpacity),
      borderSide: BorderSide(
        color: borderColor ?? buttonColor,
        width: borderWidth ?? kBorderWidth1px,
      ),
      hoverBorderSide: BorderSide(
        color: hoverBorderColor ?? buttonColor,
        width: hoverBorderWidth ?? kBorderWidth2px,
      ),
      textStyle: productSans(
        context,
        color: textColor ?? context.theme.white,
        weight: fontWeight ?? FontWeight.bold,
        size: kFontSize14px,
      ),
    );
  }

  factory FlutterFlowButtonOptions.mediumHollow(
    BuildContext context, {
    double? width,
    double? height,
    Color? color,
    double? opacity,
    double? hoverOpacity,
    EdgeInsetsGeometry? padding,
    Color? textColor,
  }) {
    final buttonColor = color ?? context.theme.tertiary;
    final colorOpacity = opacity ?? kOpacity0_4;
    final hoverColorOpacity = hoverOpacity ?? kOpacity0_6;
    return FlutterFlowButtonOptions(
      height: height ?? kHeight40px,
      width: width,
      elevation: kElevation0,
      iconSize: kIconSize20px,
      padding: padding,
      color: buttonColor.withOpacity(colorOpacity),
      hoverColor: buttonColor.withOpacity(hoverColorOpacity),
      borderSide: BorderSide(
        color: buttonColor,
        width: kBorderWidth1px,
      ),
      hoverBorderSide: BorderSide(
        color: buttonColor,
        width: kBorderWidth2px,
      ),
      textStyle: productSans(
        context,
        color: textColor ?? context.theme.white,
        weight: FontWeight.bold,
        size: kFontSize14px,
      ),
    );
  }

  final TextAlign? textAlign;
  final TextStyle? textStyle;
  final double? elevation;
  final double? height;
  final double? width;
  final EdgeInsetsGeometry? padding;
  final Color? color;
  final Color? disabledColor;
  final Color? disabledTextColor;
  final int? maxLines;

  final Color? splashColor;
  final double? iconSize;
  final Color? iconColor;
  final EdgeInsetsGeometry? iconPadding;
  final BorderRadius? borderRadius;
  final BorderSide? borderSide;
  final Color? hoverColor;
  final BorderSide? hoverBorderSide;
  final Color? hoverTextColor;

  final double? hoverElevation;

  FlutterFlowButtonOptions copyWith({
    TextStyle? textStyle,
    double? elevation,
    double? height,
    double? width,
    EdgeInsetsGeometry? padding,
    Color? color,
    Color? disabledColor,
    Color? disabledTextColor,
    int? maxLines,
    Color? splashColor,
    double? iconSize,
    Color? iconColor,
    EdgeInsetsGeometry? iconPadding,
    BorderRadius? borderRadius,
    BorderSide? borderSide,
    Color? hoverColor,
    BorderSide? hoverBorderSide,
    Color? hoverTextColor,
    double? hoverElevation,
  }) =>
      FlutterFlowButtonOptions(
        textStyle: textStyle ?? this.textStyle,
        elevation: elevation ?? this.elevation,
        height: height ?? this.height,
        width: width ?? this.width,
        padding: padding ?? this.padding,
        color: color ?? this.color,
        disabledColor: disabledColor ?? this.disabledColor,
        disabledTextColor: disabledTextColor ?? this.disabledTextColor,
        maxLines: maxLines ?? this.maxLines,
        splashColor: splashColor ?? this.splashColor,
        iconSize: iconSize ?? this.iconSize,
        iconColor: iconColor ?? this.iconColor,
        iconPadding: iconPadding ?? this.iconPadding,
        borderRadius: borderRadius ?? this.borderRadius,
        borderSide: borderSide ?? this.borderSide,
        hoverColor: hoverColor ?? this.hoverColor,
        hoverBorderSide: hoverBorderSide ?? this.hoverBorderSide,
        hoverTextColor: hoverTextColor ?? this.hoverTextColor,
        hoverElevation: hoverElevation ?? this.hoverElevation,
      );
}

FlutterFlowButtonOptions simpleButtonOptions(BuildContext context) =>
    FlutterFlowButtonOptions(
      color: context.theme.white,
      textStyle: TextStyle(
        color: context.theme.panelBorderColor,
        fontWeight: FontWeight.bold,
        fontSize: 15,
      ),
      iconSize: 18,
      elevation: 0,
      iconPadding: EdgeInsets.zero,
      borderSide: BorderSide(
        color: context.theme.workspaceButtonColor,
        width: 2.0,
      ),
    );

class FlutterFlowButton extends StatefulWidget {
  const FlutterFlowButton({
    super.key,
    required this.text,
    required this.onPressed,
    this.onHover,
    this.icon,
    this.iconData,
    required this.options,
    this.textWidget,
    this.autoFocus = false,
    this.loading,
    this.showLoadingIndicator = false,
    this.loadingText,
    this.useAutoSizeText = true,
    this.tooltipText,
    this.tooltipTextWidget,
  });

  final String? text;
  final Widget? textWidget;
  final Widget? icon;
  final IconData? iconData;
  final Function()? onPressed;
  final Function(bool)? onHover;
  final FlutterFlowButtonOptions options;
  final bool? loading;
  final bool showLoadingIndicator;
  final String? loadingText;
  final bool autoFocus;
  final bool useAutoSizeText;
  final String? tooltipText;
  final Widget? tooltipTextWidget;

  @override
  State<FlutterFlowButton> createState() => _FlutterFlowButtonState();
}

class _FlutterFlowButtonState extends State<FlutterFlowButton> {
  late bool loading;

  int get maxLines => widget.options.maxLines ?? 1;
  String? get text =>
      widget.options.textStyle?.fontSize == 0 ? null : widget.text;

  @override
  void initState() {
    super.initState();
    loading = widget.loading ?? false;
  }

  @override
  Widget build(BuildContext context) {
    final hasTooltip =
        widget.tooltipText != null || widget.tooltipTextWidget != null;
    final createLoadingWidget = () => SizedBox(
          width: widget.loadingText == null && widget.options.width == null
              ? _getTextWidth(text, widget.options.textStyle, maxLines)
              : null,
          child: Center(
            child: Container(
              width: 23,
              height: 23,
              padding: const EdgeInsets.all(4),
              child: CircularProgressIndicator(
                strokeWidth: 3,
                valueColor: AlwaysStoppedAnimation<Color>(
                  widget.options.textStyle?.color ?? context.theme.white,
                ),
              ),
            ),
          ),
        );
    Widget textWidget = (widget.loading ?? loading)
        ? widget.loadingText != null
            ? Row(
                mainAxisAlignment: MainAxisAlignment.center,
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (widget.loadingText != null) ...[
                    MaybeAutoSizeText(
                      widget.loadingText!,
                      autoSize: widget.useAutoSizeText && !hasTooltip,
                      textAlign: widget.options.textAlign,
                      style: text == null
                          ? null
                          : widget.options.textStyle?.withoutColor(),
                      maxLines: maxLines,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(width: 12.0),
                    createLoadingWidget(),
                  ],
                ],
              )
            : Center(child: createLoadingWidget())
        : widget.textWidget ??
            MaybeAutoSizeText(
              text ?? '',
              autoSize: widget.useAutoSizeText && !hasTooltip,
              textAlign: widget.options.textAlign,
              style: text == null
                  ? null
                  : widget.options.textStyle?.withoutColor(),
              maxLines: maxLines,
              overflow: TextOverflow.ellipsis,
            );

    final onPressed = widget.onPressed == null
        ? null
        : widget.showLoadingIndicator && widget.loading == null
            ? () async {
                final onPressed = widget.onPressed;
                if (onPressed == null || loading) {
                  return;
                }
                setState(() => loading = true);
                try {
                  await onPressed();
                } finally {
                  setState(() => loading = false);
                }
              }
            : widget.onPressed;

    ButtonStyle style = ButtonStyle(
      shape: WidgetStateProperty.resolveWith<OutlinedBorder>(
        (states) {
          if (states.contains(WidgetState.hovered) &&
              widget.options.hoverBorderSide != null) {
            return RoundedRectangleBorder(
              borderRadius:
                  widget.options.borderRadius ?? BorderRadius.circular(8),
              side: widget.options.hoverBorderSide!,
            );
          }
          return RoundedRectangleBorder(
            borderRadius:
                widget.options.borderRadius ?? BorderRadius.circular(8),
            side: widget.options.borderSide ?? BorderSide.none,
          );
        },
      ),
      foregroundColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.disabled) &&
              widget.options.disabledTextColor != null) {
            return widget.options.disabledTextColor;
          }
          if (states.contains(WidgetState.hovered) &&
              widget.options.hoverTextColor != null) {
            return widget.options.hoverTextColor;
          }
          return widget.options.textStyle?.color ?? Colors.white;
        },
      ),
      backgroundColor: WidgetStateProperty.resolveWith<Color?>(
        (states) {
          if (states.contains(WidgetState.disabled) &&
              widget.options.disabledColor != null) {
            return widget.options.disabledColor;
          }
          if (states.contains(WidgetState.hovered) &&
              widget.options.hoverColor != null) {
            return widget.options.hoverColor;
          }
          return widget.options.color ?? context.theme.buttonColor;
        },
      ),
      overlayColor: WidgetStateProperty.resolveWith<Color?>((states) {
        if (states.contains(WidgetState.pressed)) {
          return widget.options.splashColor;
        }
        return widget.options.hoverColor == null ? null : Colors.transparent;
      }),
      padding: WidgetStateProperty.all(widget.options.padding ??
          const EdgeInsets.symmetric(horizontal: 12.0, vertical: 4.0)),
      elevation: WidgetStateProperty.resolveWith<double?>(
        (states) {
          if (states.contains(WidgetState.hovered) &&
              widget.options.hoverElevation != null) {
            return widget.options.hoverElevation!;
          }
          return widget.options.elevation ?? 2.0;
        },
      ),
    );

    if ((widget.icon != null || widget.iconData != null) && !loading) {
      Widget icon = widget.icon ??
          FaIcon(
            widget.iconData!,
            size: widget.options.iconSize,
            color: widget.options.iconColor,
          );

      if (text == null) {
        return StyledTooltip(
          textWidget: widget.tooltipTextWidget,
          message: widget.tooltipText,
          child: Container(
            height: widget.options.height,
            width: widget.options.width,
            decoration: BoxDecoration(
              border: Border.fromBorderSide(
                widget.options.borderSide ?? BorderSide.none,
              ),
              borderRadius:
                  widget.options.borderRadius ?? BorderRadius.circular(8),
            ),
            child: IconButton(
              autofocus: widget.autoFocus,
              splashRadius: 1.0,
              icon: Padding(
                padding: widget.options.iconPadding ?? EdgeInsets.zero,
                child: icon,
              ),
              onPressed: onPressed,
              style: style,
            ),
          ),
        );
      }
      return StyledTooltip(
        textWidget: widget.tooltipTextWidget,
        message: widget.tooltipText,
        child: SizedBox(
          height: widget.options.height,
          width: widget.options.width,
          child: ElevatedButton.icon(
            autofocus: widget.autoFocus,
            icon: Padding(
              padding: widget.options.iconPadding ?? EdgeInsets.zero,
              child: icon,
            ),
            label: textWidget,
            onPressed: onPressed,
            onHover: widget.onHover,
            style: style,
          ),
        ),
      );
    }
    return StyledTooltip(
      textWidget: widget.tooltipTextWidget,
      message: widget.tooltipText,
      child: SizedBox(
        height: widget.options.height,
        width: widget.options.width,
        child: ElevatedButton(
          autofocus: widget.autoFocus,
          onPressed: onPressed,
          onHover: widget.onHover,
          style: style,
          child: textWidget,
        ),
      ),
    );
  }
}

// Slightly hacky method of getting the layout width of the provided text.
double? _getTextWidth(String? text, TextStyle? style, int maxLines) =>
    text != null
        ? (TextPainter(
            text: TextSpan(text: text, style: style),
            textDirection: TextDirection.ltr,
            maxLines: maxLines,
          )..layout())
            .size
            .width
        : null;

class MaybeAutoSizeText extends StatelessWidget {
  const MaybeAutoSizeText(
    this.text, {
    super.key,
    required this.autoSize,
    required this.style,
    this.textAlign,
    this.maxLines,
    this.overflow,
  });

  final String text;
  final bool autoSize;
  final TextStyle? style;
  final TextAlign? textAlign;
  final int? maxLines;
  final TextOverflow? overflow;

  @override
  Widget build(BuildContext context) {
    return autoSize
        ? AutoSizeText(
            text,
            maxLines: maxLines,
            style: style,
            textAlign: textAlign,
            overflow: overflow,
          )
        : Text(
            text,
            maxLines: maxLines,
            style: style,
            textAlign: textAlign,
            overflow: overflow,
          );
  }
}

extension _WithoutColorExtension on TextStyle {
  TextStyle withoutColor() => TextStyle(
        inherit: inherit,
        color: null,
        backgroundColor: backgroundColor,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontStyle: fontStyle,
        letterSpacing: letterSpacing,
        wordSpacing: wordSpacing,
        textBaseline: textBaseline,
        height: height,
        leadingDistribution: leadingDistribution,
        locale: locale,
        foreground: foreground,
        background: background,
        shadows: shadows,
        fontFeatures: fontFeatures,
        decoration: decoration,
        decorationColor: decorationColor,
        decorationStyle: decorationStyle,
        decorationThickness: decorationThickness,
        debugLabel: debugLabel,
        fontFamily: fontFamily,
        fontFamilyFallback: fontFamilyFallback,
        // The _package field is private so unfortunately we can't set it here,
        // but it's almost always unset anyway.
        // package: _package,
        overflow: overflow,
      );
}
