import 'package:flutter/material.dart';
import '../base/zpl_component.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

/// An empty flexible space component for [ZplRow] or [ZplColumn].
class ZplSpacer extends ZplComponent {
  final int flex;

  ZplSpacer({
    this.flex = 1,
  });

  @override
  void performLayout([ZplConstraints constraints = const ZplConstraints()]) {
    // Spacer simply takes up whatever size the parent Row/Column forces upon it
    double width = constraints.hasBoundedWidth ? constraints.maxWidth : 0;
    double height = constraints.hasBoundedHeight ? constraints.maxHeight : 0;
    setSize(ZplSize(width, height));
  }

  @override
  void finalizeLayout(ZplOffset absoluteOffset) {
    setOffset(absoluteOffset);
  }

  @override
  void compile(ZplContext context) {
    // Spacer renders nothing
  }

  @override
  void paint(Canvas canvas, Offset offset) {
    // Spacer renders nothing
  }
}
