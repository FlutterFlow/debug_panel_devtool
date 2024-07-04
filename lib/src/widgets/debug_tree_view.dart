import 'package:flutter/material.dart';
import 'package:flutterflow_debug_panel/src/widgets/flutterflow_gradient_scroll_view.dart';
import 'package:flutterflow_tree_view/flutterflow_tree_view.dart';

/// Tree view with collapsible and expandable nodes.
class DebugTreeView extends StatelessWidget {
  /// Constructs a tree view widget.
  ///
  /// - [nodes] parameter is a required list of [TreeNode] objects that represent the nodes in the tree.
  /// - [treeController] parameter is an optional [TreeController] object that controls the behavior of the tree view.
  /// - [nodeBuilder] parameter is a required function that builds a widget for each tree node.
  DebugTreeView({
    super.key,
    required List<TreeNode> nodes,
    required this.treeController,
    required this.nodeBuilder,
    this.listPadding,
    this.listGradientColor,
  }) : nodes = copyTreeNodes(nodes);

  /// List of root level tree nodes.
  final List<TreeNode> nodes;

  /// Builder function to create a widget for each tree node.
  final Widget Function(BuildContext context, FlattenTreeNode flattenedNode)
      nodeBuilder;

  /// Tree controller to manage the tree state.
  final TreeController treeController;

  /// Padding for the list view.
  final EdgeInsets? listPadding;

  /// Color for the gradient background of the list view.
  final Color? listGradientColor;

  @override
  Widget build(BuildContext context) {
    final flattenedTreeNode = FlattenTreeNode.getFlattenedTree(
      nodes,
      treeController,
    );
    return FlutterFlowGradientScrollView(
      gradientHeight: 100,
      gradientColor: listGradientColor,
      child: (controller) => ListView.builder(
        controller: controller,
        padding: listPadding ?? EdgeInsets.zero,
        itemCount: flattenedTreeNode.length,
        itemBuilder: (context, index) =>
            nodeBuilder(context, flattenedTreeNode[index]),
      ),
    );
  }
}
