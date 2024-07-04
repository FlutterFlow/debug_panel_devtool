import 'package:flutter/material.dart';
import 'package:flutterflow_debug_panel/src/themes/flutter_flow_default_theme.dart';
import 'package:flutterflow_debug_panel/src/widgets/flutter_flow_hover.dart';
import 'package:flutterflow_debug_panel/src/widgets/flutter_flow_widgets.dart';
import 'package:flutterflow_tree_view/flutterflow_tree_view.dart';

/// Widget that displays a tree node.
class NodeWidget extends StatefulWidget {
  /// Constructs a widget that displays a tree node.
  const NodeWidget({
    super.key,
    required this.treeNode,
    required this.state,
    required this.style,
    this.level = 0,
  });

  /// The node to display.
  final TreeNode treeNode;

  /// Manages the state of the tree.
  final TreeController state;

  /// Style configuration for the node.
  final NodeStyle style;

  /// Level of the node in the tree hierarchy.
  final int level;

  @override
  State<NodeWidget> createState() => _NodeWidgetState();
}

class _NodeWidgetState extends State<NodeWidget> {
  bool get _isLeaf =>
      widget.treeNode.children == null || widget.treeNode.children!.isEmpty;

  bool get _isExpanded => widget.state.isNodeExpanded(widget.treeNode.key!);

  @override
  Widget build(BuildContext context) {
    final style = widget.style;
    final link = widget.treeNode.metaData == null
        ? null
        : widget.treeNode.metaData['link'];
    final searchReference = widget.treeNode.metaData == null
        ? null
        : widget.treeNode.metaData['searchReference'];
    return Padding(
      padding: EdgeInsets.only(left: style.levelIndent * widget.level),
      child: SizedBox(
        height: 38,
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 1.0),
          child: Material(
            color: widget.treeNode.isError
                ? style.backgroundErrorColor
                : style.backgroundColor,
            borderRadius: BorderRadius.circular(8),
            child: InkWell(
              borderRadius: BorderRadius.circular(8),
              // For allowing users to right click on the node when it has a link
              // or search reference.
              onSecondaryTapUp: link == null
                  ? null
                  : (details) async {
                      final position = details.globalPosition;
                      await showDialog(
                        barrierDismissible: true,
                        barrierColor: Colors.transparent,
                        context: context,
                        builder: (context) => Material(
                          color: Colors.transparent,
                          borderRadius: BorderRadius.circular(8.0),
                          elevation: 5.0,
                          child: InkWell(
                            onTap: () => Navigator.pop(context),
                            highlightColor: Colors.transparent,
                            splashColor: Colors.transparent,
                            mouseCursor: SystemMouseCursors.basic,
                            child: Stack(
                              children: [
                                Positioned(
                                  top: position.dy,
                                  left: position.dx,
                                  child: Container(
                                    width: 180,
                                    decoration: BoxDecoration(
                                      color: context.theme.navPanelColor,
                                      borderRadius: BorderRadius.circular(8.0),
                                      border: Border.all(
                                          color:
                                              context.theme.panelBorderColor),
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(7.0),
                                      child: Column(
                                        children: [
                                          ModalMenuItem(
                                            text: 'See definition',
                                            color: context.theme.primaryText,
                                            iconData: Icons.open_in_new_rounded,
                                            onTap: () {
                                              openUrl(link!);
                                              Navigator.pop(context);
                                            },
                                          ),
                                          if (searchReference != null)
                                            ModalMenuItem(
                                              text: 'See all instances',
                                              color: context.theme.primaryText,
                                              iconData:
                                                  Icons.open_in_new_rounded,
                                              onTap: () {
                                                openUrl(
                                                    '$link&$searchReference');
                                                Navigator.pop(context);
                                              },
                                            ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      );
                    },
              onTap: _isLeaf
                  ? null
                  : () => setState(
                        () => widget.state.toggleNodeExpanded(
                          widget.treeNode.key!,
                          widget.treeNode.name,
                        ),
                      ),
              child: Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 6,
                ),
                child: Row(
                  children: [
                    widget.treeNode.content,
                    if (!_isLeaf) ...[
                      const SizedBox(width: 12),
                      RotationTransition(
                        turns: _isExpanded
                            ? const AlwaysStoppedAnimation(0 / 360)
                            : const AlwaysStoppedAnimation(-90 / 360),
                        child: Icon(
                          style.arrowIcon,
                          color: widget.treeNode.isSubLevel
                              ? style.arrowIconSecondaryColor
                              : style.arrowIconPrimaryColor,
                          size: style.arrowIconSize,
                        ),
                      ),
                    ],
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ModalMenuItem extends StatelessWidget {
  const ModalMenuItem({
    super.key,
    required this.onTap,
    required this.text,
    required this.iconData,
    required this.color,
    this.isTop = false,
    this.isBottom = false,
    this.width,
    this.isProcess = false,
  });

  final Function() onTap;
  final String text;
  final IconData iconData;
  final Color color;
  final bool isTop;
  final bool isBottom;
  final double? width;
  final bool isProcess;

  @override
  Widget build(BuildContext context) => FlutterFlowHoverWidget(
        width: width,
        backgroundColor: context.theme.navPanelColor,
        hoverBackgroundColor: context.theme.dark400,
        borderRadius: BorderRadius.only(
          topLeft: isTop ? const Radius.circular(8.0) : Radius.zero,
          topRight: isTop ? const Radius.circular(8.0) : Radius.zero,
          bottomLeft: isBottom ? const Radius.circular(8.0) : Radius.zero,
          bottomRight: isBottom ? const Radius.circular(8.0) : Radius.zero,
        ),
        onTap: isProcess ? null : onTap,
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Row(
            children: [
              Icon(
                iconData,
                size: 18.0,
                color: color,
              ),
              const SizedBox(width: 10.0),
              Text(
                text,
                style: TextStyle(
                  fontFamily: 'Product Sans',
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      );
}
