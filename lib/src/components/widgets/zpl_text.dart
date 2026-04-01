import 'dart:math';
import '../base/zpl_component.dart';
import '../../primitives/zpl_font.dart';
import '../../primitives/zpl_align_type.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

class ZplText extends ZplComponent {
  final String text;
  final ZplFont font;
  final ZplTextAlign textAlign;
  final int maxLines;

  double? _layoutWidth;

  ZplText(
    this.text, {
    ZplFont? font,
    this.textAlign = ZplTextAlign.left,
    this.maxLines = 1,
  }) : font = font ?? ZplFont.defaultFont;

  @override
  void performLayout([ZplConstraints constraints = const ZplConstraints()]) {
    double charWidth = font.width;
    double measuredWidth = text.length * charWidth;
    
    if (constraints.hasBoundedWidth &&
        constraints.maxWidth > 0 &&
        measuredWidth > constraints.maxWidth) {
      _layoutWidth = constraints.maxWidth;
      int lines = (measuredWidth / constraints.maxWidth).ceil();
      lines = min(lines, maxLines);
      setSize(ZplSize(constraints.maxWidth, font.height * lines));
    } else {
      _layoutWidth =
          constraints.hasBoundedWidth ? constraints.maxWidth : measuredWidth;
      setSize(ZplSize(_layoutWidth!, font.height));
    }
  }

  @override
  void compile(ZplContext context) {
    context.addCommand('^FO${offset.dx.toInt()},${offset.dy.toInt()}');
    context.addCommand(
      '^A${font.fontName}N,${font.height.toInt()},${font.width.toInt()}',
    );
    
    if (_layoutWidth != null && _layoutWidth! > 0) {
      String alignFlag = 'L';
      switch(textAlign) {
        case ZplTextAlign.left: alignFlag = 'L'; break;
        case ZplTextAlign.center: alignFlag = 'C'; break;
        case ZplTextAlign.right: alignFlag = 'R'; break;
        case ZplTextAlign.justified: alignFlag = 'J'; break;
      }
      context.addCommand('^FB${_layoutWidth!.toInt()},$maxLines,0,$alignFlag,0');
    }

    context.addCommand('^FD$text^FS\n');
  }
}
