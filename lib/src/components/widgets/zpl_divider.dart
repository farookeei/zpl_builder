import 'package:flutter/material.dart';
import '../base/zpl_component.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

/// A divider widget that spans the width of its parent container.
class ZplDivider extends ZplComponent {
  final double thickness;

  ZplDivider({this.thickness = 1.0});

  @override
  void performLayout([ZplConstraints constraints = const ZplConstraints()]) {
    double width = constraints.hasBoundedWidth ? constraints.maxWidth : 0;
    setSize(ZplSize(width, thickness));
  }

  @override
  void finalizeLayout(ZplOffset absoluteOffset) {
    setOffset(absoluteOffset);
  }

  @override
  void compile(ZplContext context) {
    context.addCommand('^FO${offset.dx.toInt()},${offset.dy.toInt()}');
    context.addCommand('^GB${size.width.toInt()},${thickness.toInt()},${thickness.toInt()}^FS\n');
  }

  @override
  void paint(Canvas canvas, Offset offset) {
    canvas.drawRect(
      Rect.fromLTWH(this.offset.dx, this.offset.dy, size.width, thickness),
      Paint()..color = Colors.black,
    );
  }
}
