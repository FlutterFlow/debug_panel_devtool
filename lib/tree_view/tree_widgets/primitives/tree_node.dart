import 'package:flutter/material.dart';

/// One node of a tree.
class TreeNode {
  TreeNode({
    this.key,
    required this.name,
    this.children,
    Widget? content,
    this.metaData,
    this.isError = false,
    this.isSubLevel = false,
  }) : content = content ?? const SizedBox();

  final String name;
  final List<TreeNode>? children;
  final Widget content;
  final Key? key;
  final dynamic metaData;
  final bool isError;
  final bool isSubLevel;
}
