import '../base/zpl_component.dart';
import '../../primitives/zpl_barcode_type.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

class ZplBarcode extends ZplComponent {
  final String data;
  final ZplBarcodeType type;
  final double height;
  final double widthRatio;
  final bool printText;

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
