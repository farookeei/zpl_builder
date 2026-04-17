import 'package:flutter/material.dart';
import '../base/zpl_component.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

/// A component that renders a graphic box or line.
class ZplGraphicBox extends ZplComponent {
  /// The width of the graphic box in dots.
  final double width;

  /// The height of the graphic box in dots.
  final double height;

  /// The line thickness of the box.
  final int thickness;

  /// The degree of rounding of the corners (0 to 8).
  final int rounding;

  /// Whether to print the box in reverse (white on black).
  final bool reversePrint;

  /// Creates a [ZplGraphicBox] with the given dimensions and styling.
  ZplGraphicBox({
    this.width = 100,
    this.height = 100,
    this.thickness = 1,
    this.rounding = 0,
    this.reversePrint = false,
  });

  @override
  void performLayout([ZplConstraints constraints = const ZplConstraints()]) {
    setSize(ZplSize(width, height));
  }

  @override
  void finalizeLayout(ZplOffset absoluteOffset) {
    setOffset(absoluteOffset);
  }

  @override
  void compile(ZplContext context) {
    context.addCommand('^FO${offset.dx.toInt()},${offset.dy.toInt()}');
    if (reversePrint) {
      context.addCommand('^FR');
    }
    context.addCommand(
        '^GB${width.toInt()},${height.toInt()},$thickness,,$rounding^FS\n');
  }

  @override
  void paint(Canvas canvas, Offset offset) {
    final paint = Paint()
      ..color = reversePrint ? Colors.white : Colors.black
      ..blendMode = reversePrint ? BlendMode.difference : BlendMode.srcOver
      ..style = thickness >= width / 2 && thickness >= height / 2
          ? PaintingStyle.fill
          : PaintingStyle.stroke
      ..strokeWidth = thickness.toDouble();

    // In ZPL ^GB,thickness is inwards.
    final rect = Rect.fromLTWH(
      this.offset.dx +
          (paint.style == PaintingStyle.stroke ? thickness / 2 : 0),
      this.offset.dy +
          (paint.style == PaintingStyle.stroke ? thickness / 2 : 0),
      (width - (paint.style == PaintingStyle.stroke ? thickness : 0))
          .clamp(0, double.infinity),
      (height - (paint.style == PaintingStyle.stroke ? thickness : 0))
          .clamp(0, double.infinity),
    );

    if (rounding > 0) {
      // ZPL rounding is 0-8, where 8 is a circle.
      final radius = Radius.circular((rounding / 8) * (min(width, height) / 2));
      canvas.drawRRect(RRect.fromRectAndRadius(rect, radius), paint);
    } else {
      canvas.drawRect(rect, paint);
    }
  }

  double min(double a, double b) => a < b ? a : b;
}
