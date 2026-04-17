import 'package:flutter/material.dart';
import '../base/zpl_component.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

/// A component that expands a child of a [ZplRow] or [ZplColumn] to fill the available space.
class ZplExpanded extends ZplComponent {
  /// The flex factor to use for this expanded component.
  final int flex;

  /// The child component to expand.
  final ZplComponent child;

  /// Creates a [ZplExpanded] with the given [child] and optional [flex] factor.
  ZplExpanded({
    this.flex = 1,
    required this.child,
  });

  @override
  void performLayout([ZplConstraints constraints = const ZplConstraints()]) {
    // Child is given constraints dictated by the parent Row/Column
    child.performLayout(constraints);
    setSize(child.size);
  }

  @override
  void finalizeLayout(ZplOffset absoluteOffset) {
    setOffset(absoluteOffset);
    child.finalizeLayout(absoluteOffset);
  }

  @override
  void compile(ZplContext context) {
    child.compile(context);
  }

  @override
  void paint(Canvas canvas, Offset offset) {
    child.paint(canvas, offset);
  }
}
