import 'package:flutter/foundation.dart';

/// A controller for a tree state.
///
/// Allows to modify the state of the tree.
class TreeController {
  TreeController({
    allNodesExpanded = true,
    this.onNodeToggled,
  }) : _allNodesExpanded = allNodesExpanded;

  bool _allNodesExpanded;
  final Map<Key, bool> _expanded = <Key, bool>{};
  final Function(String name)? onNodeToggled;

  bool get allNodesExpanded => _allNodesExpanded;

  bool isNodeExpanded(Key key) {
    return _expanded[key] ?? _allNodesExpanded;
  }

  void toggleNodeExpanded(Key key, String name) {
    _expanded[key] = !isNodeExpanded(key);
    if (onNodeToggled != null) {
      onNodeToggled!(name);
    }
  }

  void expandAll() {
    _allNodesExpanded = true;
    _expanded.clear();
  }

  void collapseAll() {
    _allNodesExpanded = false;
    _expanded.clear();
  }

  void expandNode(Key key) {
    _expanded[key] = true;
  }

  void collapseNode(Key key) {
    _expanded[key] = false;
  }
}
