import 'primitives/tree_node.dart';

/// Copies nodes to unmodifiable list, assigning missing keys and checking for duplicates.
List<TreeNode> searchTreeNodes(
  List<TreeNode>? nodes,
  bool Function(dynamic) searchFunction,
) =>
    _searchNodesRecursively(nodes, searchFunction)!;

List<TreeNode>? _searchNodesRecursively(
  List<TreeNode>? nodes,
  bool Function(dynamic) searchFunction,
) {
  if (nodes == null) {
    return null;
  }
  return nodes
      .map((node) {
        bool selfMatch =
            node.metaData != null && searchFunction(node.metaData!);
        var children = _searchNodesRecursively(node.children, searchFunction);
        if (selfMatch || (children?.isNotEmpty ?? false)) {
          return TreeNode(
            key: node.key,
            name: node.name,
            content: node.content,
            children: children,
            isSubLevel: node.isSubLevel,
            isError: node.isError,
            metaData: node.metaData,
          );
        }
        return null;
      })
      .where((s) => s != null)
      .map((e) => e!)
      .toList();
}
