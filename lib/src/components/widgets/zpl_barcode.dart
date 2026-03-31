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
  void performLayout() {
    // Basic heuristic for estimating barcode bounds
    double estimatedWidth = data.length * 11 * widthRatio;
    setSize(ZplSize(estimatedWidth, height + (printText ? 20 : 0)));
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
}
