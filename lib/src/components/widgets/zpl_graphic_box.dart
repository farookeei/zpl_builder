import '../base/zpl_component.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

/// A component that renders a graphic box or line.
class ZplGraphicBox extends ZplComponent {
  final double width;
  final double height;
  final int thickness;
  final int rounding;
  final bool reversePrint; // ^FR

  ZplGraphicBox({
    this.width = 100,
    this.height = 100,
    this.thickness = 1,
    this.rounding = 0,
    this.reversePrint = false,
  });

  @override
  void performLayout() {
    setSize(ZplSize(width, height));
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
}
