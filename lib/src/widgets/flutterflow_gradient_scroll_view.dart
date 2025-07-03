import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutterflow_debug_panel/src/themes/flutter_flow_default_theme.dart';
import 'package:flutterflow_debug_panel/src/utils/ff_utils.dart';

/// A scrollable widget that displays a gradient at the top and bottom.
class FlutterFlowGradientScrollView extends StatefulWidget {
  /// Creates a scrollable widget that displays a gradient at the top and bottom
  /// based on the scroll position.
  ///
  /// * [child] parameter is the child widget that will be scrolled.
  ///
  /// * [gradientColor] parameter is the color of the gradient. If not provided,
  /// it will use the panel color.
  ///
  /// * [gradientHeight] parameter is the height of the gradient. Default is 50.0.
  ///
  /// * [scrollController] parameter is the scroll controller for the scroll view.
  const FlutterFlowGradientScrollView({
    super.key,
    required this.child,
    this.gradientColor,
    this.gradientHeight = 50.0,
    this.scrollController,
  });

  /// The child widget that will be scrolled.
  final ScrollView Function(ScrollController controller) child;

  /// The color of the gradient. If not provided, it will use the panel color.
  final Color? gradientColor;

  /// The height of the gradient. Default is 50.0.
  final double gradientHeight;

  /// The scroll controller for the scroll view.
  final ScrollController? scrollController;

  @override
  State<FlutterFlowGradientScrollView> createState() =>
      _FlutterFlowGradientScrollViewState();
}

class _FlutterFlowGradientScrollViewState
    extends State<FlutterFlowGradientScrollView> {
  var _showStartGradient = false;
  var _showEndGradient = false;
  double? _maxScrollExtent;

  late final ScrollController _scrollController;

  @override
  void initState() {
    super.initState();
    _scrollController = widget.scrollController ?? ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    // This is a workaround to get the max scroll extent after the first frame
    // to set the initial state of the gradients, and to update the state when
    // the scroll length changes.
    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.positions.isNotEmpty &&
          _scrollController.hasClients) {
        if (_maxScrollExtent == null ||
            _maxScrollExtent != _scrollController.position.maxScrollExtent) {
          _maxScrollExtent = _scrollController.position.maxScrollExtent;
          _showEndGradient = _showStartGradient =
              _scrollController.position.maxScrollExtent > 0;
          setState(() {});
        }
      }
    });

    final gradientColor = widget.gradientColor ?? context.theme.panelColor;
    return Stack(
      children: [
        NotificationListener<ScrollNotification>(
          onNotification: (scrollInfo) {
            final extentBefore = scrollInfo.metrics.extentBefore;
            final extentAfter = scrollInfo.metrics.extentAfter;
            var updatedShowStartGradient = false;
            var updatedShowEndGradient = false;
            if (extentBefore > 0) {
              updatedShowStartGradient = true;
            } else {
              updatedShowStartGradient = false;
            }
            if (extentAfter > 0) {
              updatedShowEndGradient = true;
            } else {
              updatedShowEndGradient = false;
            }
            if (updatedShowStartGradient != _showStartGradient ||
                updatedShowEndGradient != _showEndGradient) {
              setState(() {
                _showStartGradient = updatedShowStartGradient;
                _showEndGradient = updatedShowEndGradient;
              });
            }
            return true;
          },
          child: widget.child(_scrollController),
        ),
        IgnorePointer(
          child: Column(
            children: [
              AnimatedOpacity(
                duration: 300.millis,
                opacity: _scrollController.positions.isNotEmpty &&
                        _scrollController.offset > 0 &&
                        _showStartGradient
                    ? 1
                    : 0,
                child: Container(
                  height: widget.gradientHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        gradientColor,
                        gradientColor.withOpacity(0),
                      ],
                    ),
                  ),
                ),
              ),
              const Spacer(),
              AnimatedOpacity(
                duration: 300.millis,
                opacity: _showEndGradient ? 1 : 0,
                child: Container(
                  height: widget.gradientHeight,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                      colors: [
                        gradientColor.withOpacity(0),
                        gradientColor,
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
