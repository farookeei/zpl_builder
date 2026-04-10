import 'package:flutter/material.dart';
import 'package:barcode/barcode.dart' as bc;
import '../base/zpl_component.dart';
import '../../primitives/zpl_barcode_type.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

/// A barcode component that supports various ZPL barcode types.
class ZplBarcode extends ZplComponent {
  /// The raw data of the barcode.
  final String data;

  /// The type of barcode to generate (e.g., Code 128, QR).
  final ZplBarcodeType type;

  /// The height of the barcode (in dots).
  final double height;

  /// The width ratio for the barcode modules.
  final double widthRatio;

  /// Whether to print the interpretation line (text) below the barcode.
  final bool printText;

  /// Creates a new `ZplBarcode` with the specified [data].
  ZplBarcode(
    this.data, {
    this.type = ZplBarcodeType.code128,
    this.height = 50.0,
    this.widthRatio = 2.0,
    this.printText = false,
  });

  @override
  void performLayout([ZplConstraints constraints = const ZplConstraints()]) {
    // Exact ZPL calculation for barcode width
    // Code 128: 11 modules per character + 11 (start) + 11 (check) + 13 (stop)
    // Code 39: Each char is 13 or 16 modules depending on narrow/wide ratio

    double modules = 0;
    switch (type) {
      case ZplBarcodeType.code128:
        // (Data + Start + Check) * 11 modules + 2 extra for stop bar
        modules = (data.length + 3) * 11 + 2;
        break;
      case ZplBarcodeType.code39:
        // Basic Code 39 math (approximate but much closer than before)
        modules = (data.length + 2) * 16;
        break;
      default:
        modules = data.length * 12;
    }

    final double calculatedWidth = modules * widthRatio;
    // Human readable text adds some height
    final double extraHeight = printText ? (widthRatio * 5 + 20) : 0;

    setSize(ZplSize(calculatedWidth, height + extraHeight));
  }

  @override
  void finalizeLayout(ZplOffset absoluteOffset) {
    setOffset(absoluteOffset);
  }

  /// Appends the ZPL commands for this barcode to the provided [context].
  @override
  void compile(ZplContext context) {
    context.addCommand('^FO${offset.dx.toInt()},${offset.dy.toInt()}');
    context.addCommand('^BY${widthRatio.toInt()}');

    // N: normal orientation, Y/N: print interpretation line, N: print interpretation line above barcode
    String printInterpretation = printText ? 'Y' : 'N';
    context.addCommand(
      '^${type.command}N,${height.toInt()},$printInterpretation,N,N',
    );
    context.addCommand('^FD$data^FS\n');
  }

  @override
  void paint(Canvas canvas, Offset offset) {
    bc.Barcode? barcode;
    switch (type) {
      case ZplBarcodeType.code39:
        barcode = bc.Barcode.code39();
        break;
      case ZplBarcodeType.code128:
        barcode = bc.Barcode.code128();
        break;
      case ZplBarcodeType.upcA:
        barcode = bc.Barcode.upcA();
        break;
      case ZplBarcodeType.ean8:
        barcode = bc.Barcode.ean8();
        break;
      case ZplBarcodeType.ean13:
        barcode = bc.Barcode.ean13();
        break;
    }

    try {
      final double textFontSize = (widthRatio * 6).clamp(12, 40);

      final elements = barcode.make(
        data,
        width: size.width,
        height: height,
        drawText: printText,
        fontHeight: printText ? textFontSize : null,
      );

      final paint = Paint()..style = PaintingStyle.fill;
      for (final el in elements) {
        if (el is bc.BarcodeBar) {
          paint.color = el.black ? Colors.black : Colors.white;
          canvas.drawRect(
            Rect.fromLTWH(
              this.offset.dx + el.left,
              this.offset.dy + el.top,
              el.width,
              el.height,
            ),
            paint,
          );
        } else if (el is bc.BarcodeText) {
          final tp = TextPainter(
            text: TextSpan(
              text: el.text,
              style: TextStyle(
                  color: Colors.black,
                  fontSize: textFontSize,
                  fontFamily: 'monospace',
                  fontWeight: FontWeight.bold),
            ),
            textDirection: TextDirection.ltr,
          );
          tp.layout();

          // Center the text under the barcode
          final centerX = this.offset.dx + (size.width / 2) - (tp.width / 2);
          tp.paint(canvas, Offset(centerX, this.offset.dy + el.top));
        }
      }
    } catch (e) {
      // Fallback for invalid data
      canvas.drawRect(
        Rect.fromLTWH(this.offset.dx, this.offset.dy, size.width, size.height),
        // ignore: deprecated_member_use
        Paint()..color = Colors.red.withOpacity(0.3),
      );
    }
  }
}
