import 'dart:math';
import 'package:flutter/material.dart';
import '../base/zpl_component.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

/// A component that overlays its children on top of each other.
class ZplStack extends ZplComponent {
  final List<ZplComponent> children;

  ZplStack({required this.children});

  @override
  void performLayout([ZplConstraints constraints = const ZplConstraints()]) {
    double maxWidth = 0;
    double maxHeight = 0;

    for (var child in children) {
      child.performLayout();
      maxWidth = max(maxWidth, child.size.width);
      maxHeight = max(maxHeight, child.size.height);
    }

    setSize(ZplSize(maxWidth, maxHeight));
  }

  @override
  void finalizeLayout(ZplOffset absoluteOffset) {
    setOffset(absoluteOffset);
    for (var child in children) {
      child.finalizeLayout(absoluteOffset);
    }
  }

  @override
  void compile(ZplContext context) {
    for (var child in children) {
      child.compile(context);
    }
  }

  @override
  void paint(Canvas canvas, Offset offset) {
    for (var child in children) {
      child.paint(canvas, offset);
    }
  }
}
