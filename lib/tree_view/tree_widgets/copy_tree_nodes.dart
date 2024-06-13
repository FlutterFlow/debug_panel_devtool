import 'primitives/key_provider.dart';
import 'primitives/tree_node.dart';

/// Copies nodes to unmodifiable list, assigning missing keys and checking for duplicates.
List<TreeNode> copyTreeNodes(List<TreeNode>? nodes) {
  return _copyNodesRecursively(nodes, KeyProvider())!;
}

List<TreeNode>? _copyNodesRecursively(
  List<TreeNode>? nodes,
  KeyProvider keyProvider,
) {
  if (nodes == null) {
    return null;
  }
  return List.unmodifiable(nodes.map((n) {
    return TreeNode(
      name: n.name,
      key: keyProvider.key(n.key),
      content: n.content,
      children: _copyNodesRecursively(n.children, keyProvider),
      isError: n.isError,
      isSubLevel: n.isSubLevel,
    );
  }));
}
