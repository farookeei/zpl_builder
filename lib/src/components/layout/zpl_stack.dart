import 'dart:math';
import '../base/zpl_component.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

/// A component that overlays its children on top of each other.
class ZplStack extends ZplComponent {
  final List<ZplComponent> children;

  ZplStack({required this.children});

  @override
  void performLayout() {
    double maxWidth = 0;
    double maxHeight = 0;

    for (var child in children) {
      child.performLayout();
      maxWidth = max(maxWidth, child.size.width);
      maxHeight = max(maxHeight, child.size.height);
    }

    setSize(ZplSize(maxWidth, maxHeight));
  }

  @override
  void compile(ZplContext context) {
    for (var child in children) {
      // Stacked components all share the base offset
      child.setOffset(offset);
      child.compile(context);
    }
  }
}
