import 'dart:math';
import '../base/zpl_component.dart';
import '../../primitives/zpl_align_type.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

class ZplRow extends ZplComponent {
  final List<ZplComponent> children;
  final ZplCrossAxisAlignment crossAxisAlignment;
  final double spacing;

  ZplRow({
    required this.children,
    this.crossAxisAlignment = ZplCrossAxisAlignment.start,
    this.spacing = 0.0,
  });

  @override
  void performLayout() {
    double totalWidth = 0;
    double maxChildHeight = 0;

    for (var child in children) {
      child.performLayout();
      totalWidth += child.size.width;
      maxChildHeight = max(maxChildHeight, child.size.height);
    }

    if (children.isNotEmpty) {
      totalWidth += spacing * (children.length - 1);
    }

    setSize(ZplSize(totalWidth, maxChildHeight));
  }

  @override
  void compile(ZplContext context) {
    double currentDx = offset.dx;

    for (var child in children) {
      double childDy = offset.dy;

      switch (crossAxisAlignment) {
        case ZplCrossAxisAlignment.start:
          childDy = offset.dy;
          break;
        case ZplCrossAxisAlignment.center:
          childDy = offset.dy + (size.height - child.size.height) / 2;
          break;
        case ZplCrossAxisAlignment.end:
          childDy = offset.dy + (size.height - child.size.height);
          break;
      }

      child.setOffset(ZplOffset(currentDx, childDy));
      child.compile(context);

      currentDx += child.size.width + spacing;
    }
  }
}
