import 'dart:async';

import 'package:flutterflow_debug_panel/src/utils/ff_utils.dart';
import 'package:flutterflow_debug_panel/src/themes/flutter_flow_default_theme.dart';
import 'package:flutter/material.dart';
import 'package:just_the_tooltip/just_the_tooltip.dart';

// New StyledTooltip using FlutterFlowTooltip Widget
// You can either pass in message if you just have a String,
// or you can pass in a widget (e.g. TextSpan) if you need to include links
class StyledTooltip extends StatefulWidget {
  const StyledTooltip({
    required this.child,
    this.onTap,
    this.message,
    this.textWidget,
    this.offset = const Offset(0, 0),
    this.margin,
    this.padding,
    this.textColor,
    this.waitDuration,
    this.preferredDirection = AxisDirection.down,
    super.key,
  });

  final String? message;
  final Widget? textWidget;
  final void Function()? onTap;
  final Widget child;
  final Offset offset;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;
  final Color? textColor;
  final Duration? waitDuration;
  final AxisDirection preferredDirection;

  @override
  State<StyledTooltip> createState() => _StyledTooltipState();
}

class _StyledTooltipState extends State<StyledTooltip> {
  @override
  Widget build(BuildContext context) {
    if ((widget.message == null || widget.message!.trim().isEmpty) &&
        widget.textWidget == null) {
      return widget.child;
    }
    return FlutterFlowTooltip(
      key: widget.message != null
          ? Key('TooltipWithMessage_${widget.message}')
          : null,
      preferredDirection: widget.preferredDirection,
      elevation: 15.0,
      waitDuration: widget.waitDuration,
      tooltipWidget: Padding(
        padding: widget.padding ??
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
        child: widget.textWidget ??
            SelectableText(
              widget.message ?? '',
              style: TextStyle(
                color: widget.textColor ??
                    (context.theme.isLightMode
                        ? context.theme.panelTextColor1
                        : Colors.white),
                fontSize: 14.0,
                fontFamily: 'Product Sans',
              ),
            ),
      ),
      child: widget.child,
    );
  }
}

extension TooltipWidgetExtensions on Widget {
  Widget withTooltip(String? message) => StyledTooltip(
        message: message,
        child: this,
      );
}

class FlutterFlowTooltip extends StatefulWidget {
  const FlutterFlowTooltip({
    required this.child,
    required this.tooltipWidget,
    required this.preferredDirection,
    this.offset = const Offset(0, 0),
    this.waitDuration,
    this.elevation,
    this.backgroundColor,
    super.key,
  });

  final Widget child;
  final Widget tooltipWidget;
  final AxisDirection preferredDirection;
  final Offset offset;
  final Duration? waitDuration;
  final double? elevation;
  final Color? backgroundColor;

  @override
  State<FlutterFlowTooltip> createState() => _FlutterFlowTooltipState();
}

class _FlutterFlowTooltipState extends State<FlutterFlowTooltip> {
  final controller = JustTheController();
  Timer? removeTimer;

  Widget get child => widget.child;
  Widget get tooltipWidget => widget.tooltipWidget;
  Duration get waitDuration => 500.millis;

  @override
  void dispose() {
    removeTimer?.cancel();
    super.dispose();
  }

  void startRemoveTimer() {
    removeTimer = Timer(200.millis, () => controller.hideTooltip());
  }

  @override
  Widget build(BuildContext context) {
    Color tooltipColor;
    if (widget.backgroundColor != null) {
      tooltipColor = widget.backgroundColor!;
    } else {
      tooltipColor = context.theme.isLightMode
          ? context.theme.panelColor
          : context.theme.dark200;
    }
    return GestureDetector(
      onLongPress: null,
      child: MouseRegion(
        cursor: SystemMouseCursors.click,
        onExit: (event) => startRemoveTimer(),
        onEnter: (event) => controller.showTooltip(),
        child: JustTheTooltip(
          controller: controller,
          tailBuilder: pointerPathBuilder,
          margin: const EdgeInsets.all(10.0),
          preferredDirection: widget.preferredDirection,
          tailBaseWidth: 20.0,
          tailLength: 10.0,
          elevation: widget.elevation ?? 4.0,
          backgroundColor: tooltipColor,
          borderRadius: const BorderRadius.all(Radius.circular(8.0)),
          triggerMode: TooltipTriggerMode.manual,
          isModal: true,
          barrierDismissible: false,
          content: MouseRegion(
            onExit: (event) => controller.hideTooltip(),
            onEnter: (event) => removeTimer?.cancel(),
            child: tooltipWidget,
          ),
          waitDuration: waitDuration,
          child: widget.child,
        ),
      ),
    );
  }
}

class TwoLineTooltip extends StatelessWidget {
  const TwoLineTooltip({
    required this.child,
    this.line1,
    this.line2,
    this.preferredDirection = AxisDirection.up,
    this.offset = const Offset(5, 5),
    this.margin,
    this.padding,
    super.key,
  });

  final Widget? line1;
  final Widget? line2;
  final Widget child;
  final AxisDirection preferredDirection;
  final Offset offset;
  final EdgeInsetsGeometry? margin;
  final EdgeInsetsGeometry? padding;

  @override
  Widget build(BuildContext context) {
    return FlutterFlowTooltip(
      offset: offset,
      waitDuration: Duration.zero,
      elevation: 15.0,
      preferredDirection: preferredDirection,
      tooltipWidget: Padding(
        padding: padding ??
            const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 10,
            ),
        child: SelectionArea(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              if (line1 != null) line1!,
              if (line1 != null && line2 != null) const SizedBox(height: 2.0),
              if (line2 != null) line2!,
            ],
          ),
        ),
      ),
      child: child,
    );
  }
}

Path pointerPathBuilder(
  Offset tip,
  Offset point2,
  Offset point3, {
  double pointerCurve = 3.0,
}) {
  final tipPoint2 = tip - point2;
  final tipPoint3 = tip - point3;

  return Path()
    ..moveTo(point2.dx, point2.dy)
    ..lineTo(tip.dx - pointerCurve * tipPoint2.dx.sign,
        tip.dy - pointerCurve * tipPoint2.dy.sign)
    ..quadraticBezierTo(
      tip.dx,
      tip.dy,
      tip.dx - pointerCurve * tipPoint3.dx.sign,
      tip.dy - pointerCurve * tipPoint3.dy.sign,
    )
    ..lineTo(point3.dx, point3.dy)
    ..close();
}
