import 'dart:math';
import '../base/zpl_component.dart';
import '../../primitives/zpl_align_type.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

class ZplColumn extends ZplComponent {
  final List<ZplComponent> children;
  final ZplCrossAxisAlignment crossAxisAlignment;
  final double spacing;

  ZplColumn({
    required this.children,
    this.crossAxisAlignment = ZplCrossAxisAlignment.start,
    this.spacing = 0.0,
  });

  @override
  void performLayout() {
    double totalHeight = 0;
    double maxChildWidth = 0;

    for (var child in children) {
      child.performLayout();
      totalHeight += child.size.height;
      maxChildWidth = max(maxChildWidth, child.size.width);
    }

    if (children.isNotEmpty) {
      totalHeight += spacing * (children.length - 1);
    }

    setSize(ZplSize(maxChildWidth, totalHeight));
  }

  @override
  void compile(ZplContext context) {
    double currentDy = offset.dy;

    for (var child in children) {
      double childDx = offset.dx;

      switch (crossAxisAlignment) {
        case ZplCrossAxisAlignment.start:
          childDx = offset.dx;
          break;
        case ZplCrossAxisAlignment.center:
          childDx = offset.dx + (size.width - child.size.width) / 2;
          break;
        case ZplCrossAxisAlignment.end:
          childDx = offset.dx + (size.width - child.size.width);
          break;
      }

      child.setOffset(ZplOffset(childDx, currentDy));
      child.compile(context);

      currentDy += child.size.height + spacing;
    }
  }
}
