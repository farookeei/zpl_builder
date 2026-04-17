import 'dart:math';
import 'package:flutter/material.dart';
import '../base/zpl_component.dart';
import '../../primitives/zpl_align_type.dart';
import '../../primitives/zpl_font.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

/// A component that renders text using ZPL fonts.
class ZplText extends ZplComponent {
  /// The string of text to render.
  final String text;

  /// The font to use for rendering the text.
  final ZplFont font;

  /// How the text should be aligned horizontally.
  final ZplTextAlign textAlign;

  /// The maximum number of lines for the text block.
  final int maxLines;

  /// Creates a [ZplText] with the specified [text] and optional styling parameters.
  ZplText(
    this.text, {
    this.font = const ZplFont(),
    this.textAlign = ZplTextAlign.left,
    this.maxLines = 1,
  });

  @override
  void performLayout([ZplConstraints constraints = const ZplConstraints()]) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black,
          fontSize: font.height,
          fontFamily: 'monospace',
          height: 1.1,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: textAlign.toFlutter(),
      maxLines: maxLines,
    );

    double effectiveMaxWidth = constraints.hasBoundedWidth
        ? max(1.0, constraints.maxWidth)
        : double.infinity;

    textPainter.layout(
      minWidth: constraints.minWidth,
      maxWidth: effectiveMaxWidth,
    );

    setSize(ZplSize(textPainter.width, textPainter.height));
  }

  @override
  void finalizeLayout(ZplOffset absoluteOffset) {
    setOffset(absoluteOffset);
  }

  @override
  void compile(ZplContext context) {
    context.addCommand('^FO${offset.dx.toInt()},${offset.dy.toInt()}');
    context.addCommand(
        '^A${font.fontName}N,${font.height.toInt()},${font.width.toInt()}');

    if (maxLines > 1 || textAlign != ZplTextAlign.left) {
      context.addCommand(
          '^FB${size.width.toInt()},$maxLines,0,${textAlign.command},0');
    }

    context.addCommand('^FD$text^FS\n');
  }

  @override
  void paint(Canvas canvas, Offset offset) {
    final textPainter = TextPainter(
      text: TextSpan(
        text: text,
        style: TextStyle(
          color: Colors.black,
          fontSize: font.height,
          fontFamily: 'monospace',
          height: 1.1,
        ),
      ),
      textDirection: TextDirection.ltr,
      textAlign: textAlign.toFlutter(),
      maxLines: maxLines,
    );

    textPainter.layout(maxWidth: size.width);
    textPainter.paint(canvas, Offset(this.offset.dx, this.offset.dy));
  }
}
