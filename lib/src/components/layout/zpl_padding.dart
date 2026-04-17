import 'package:flutter/material.dart';
import '../base/zpl_component.dart';
import '../../primitives/zpl_edge_insets.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

/// A component that insets its child by the given padding.
class ZplPadding extends ZplComponent {
  /// The amount of space by which to inset the child.
  final ZplEdgeInsets padding;

  /// The child component to add padding around.
  final ZplComponent child;

  /// Creates a [ZplPadding] component that insets the [child] by [padding].
  ZplPadding({required this.padding, required this.child});

  @override
  void performLayout([ZplConstraints constraints = const ZplConstraints()]) {
    child.performLayout(constraints.deflate(padding));
    setSize(
      ZplSize(
        child.size.width + padding.horizontal,
        child.size.height + padding.vertical,
      ),
    );
  }

  @override
  void finalizeLayout(ZplOffset absoluteOffset) {
    setOffset(absoluteOffset);
    child.finalizeLayout(absoluteOffset.translate(padding.left, padding.top));
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
