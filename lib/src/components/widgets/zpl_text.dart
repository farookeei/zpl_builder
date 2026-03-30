import '../base/zpl_component.dart';
import '../../primitives/zpl_font.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

class ZplText extends ZplComponent {
  final String text;
  final ZplFont font;

  ZplText(this.text, {ZplFont? font}) : font = font ?? ZplFont.defaultFont;

  @override
  void performLayout() {
    double charWidth = font.width;
    double measuredWidth = text.length * charWidth;
    setSize(ZplSize(measuredWidth, font.height));
  }

  @override
  void compile(ZplContext context) {
    context.addCommand('^FO${offset.dx.toInt()},${offset.dy.toInt()}');
    context.addCommand(
      '^A${font.fontName}N,${font.height.toInt()},${font.width.toInt()}',
    );
    context.addCommand('^FD$text^FS\n');
  }
}
