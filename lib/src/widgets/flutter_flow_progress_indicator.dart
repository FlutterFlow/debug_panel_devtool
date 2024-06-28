import 'package:debug_panel_devtool/src/themes/flutter_flow_default_theme.dart';
import 'package:flutter/material.dart';

class FlutterFlowProgressIndicator extends StatelessWidget {
  const FlutterFlowProgressIndicator({
    super.key,
    this.size,
    this.color,
    this.strokeWidth,
  });

  final double? size;
  final Color? color;
  final double? strokeWidth;

  @override
  Widget build(BuildContext context) {
    final indicator = CircularProgressIndicator(
      valueColor: AlwaysStoppedAnimation<Color>(color ?? context.theme.primary),
      strokeWidth: strokeWidth ?? 4.0,
    );
    if (size == null) {
      return indicator;
    }
    return SizedBox(width: size, height: size, child: indicator);
  }
}
