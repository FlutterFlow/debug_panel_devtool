import 'package:debug_panel_devtool/src/utils/ff_utils.dart';
import 'package:debug_panel_devtool/src/themes/flutter_flow_default_theme.dart';
import 'package:flutter/material.dart';

/// Wrap a widget with [FlutterFlowHoverWidget] to define hover behaviors.
/// Note that exactly one of the [child] and [builder] arguments must be set.
/// Use the [builder] argument, if the child depends on the hover state.
class FlutterFlowHoverWidget extends StatefulWidget {
  const FlutterFlowHoverWidget({
    super.key,
    this.width,
    this.height,
    this.backgroundColor,
    this.hoverBackgroundColor,
    this.borderColor,
    this.hoverBorderColor,
    this.borderRadius,
    this.borderWidth,
    this.child,
    this.builder,
    this.onHover,
    this.onTap,
    this.showInkEffect = false,
    this.boxShadow,
    this.canRequestFocus = true,
  });

  final double? width;
  final double? height;
  final Color? backgroundColor;
  final Color? hoverBackgroundColor;
  final Color? borderColor;
  final Color? hoverBorderColor;
  final BorderRadius? borderRadius;
  final double? borderWidth;
  final Widget? child;
  final Widget Function(BuildContext, bool)? builder;
  final Function(bool isHovering)? onHover;
  final Function()? onTap;
  final bool showInkEffect;
  final List<BoxShadow>? boxShadow;
  final bool canRequestFocus;

  @override
  State<FlutterFlowHoverWidget> createState() => _FlutterFlowHoverWidgetState();
}

class _FlutterFlowHoverWidgetState extends State<FlutterFlowHoverWidget> {
  bool _isHovering = false;

  Function(bool) get onHover => widget.onHover ?? (_) {};
  Color? get inkColor => widget.showInkEffect ? null : Colors.transparent;

  Widget _child(BuildContext context) =>
      widget.child ?? widget.builder!(context, _isHovering);

  @override
  Widget build(BuildContext context) {
    assert(
      (widget.child == null) != (widget.builder == null),
      'Exactly one of the child and builder arguments must be set',
    );

    return InkWell(
      splashColor: inkColor,
      hoverColor: inkColor,
      highlightColor: inkColor,
      focusColor: inkColor,
      borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
      canRequestFocus: widget.canRequestFocus,
      onTap: widget.onTap,
      onHover: (value) {
        setState(() => _isHovering = value);
        onHover(value);
      },
      child: AnimatedContainer(
        duration: 200.millis,
        curve: Curves.easeInOut,
        width: widget.width,
        height: widget.height,
        decoration: BoxDecoration(
          color: _isHovering
              ? widget.hoverBackgroundColor ?? context.theme.panelBorderColor
              : widget.backgroundColor ?? context.theme.dark200,
          borderRadius: widget.borderRadius ?? BorderRadius.circular(8.0),
          border: widget.borderColor == null && widget.borderWidth == null
              ? null
              : Border.all(
                  color: _isHovering
                      ? widget.hoverBorderColor ??
                          widget.borderColor ??
                          context.theme.panelBorderColor
                      : widget.borderColor ?? context.theme.dark200,
                  width: widget.borderWidth ?? 1.0,
                ),
          boxShadow: widget.boxShadow,
        ),
        child: _child(context),
      ),
    );
  }
}
