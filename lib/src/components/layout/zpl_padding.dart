import 'package:flutter/material.dart';
import '../base/zpl_component.dart';
import '../../primitives/zpl_edge_insets.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

class ZplPadding extends ZplComponent {
  final ZplEdgeInsets padding;
  final ZplComponent child;

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
