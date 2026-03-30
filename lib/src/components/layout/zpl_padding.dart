import '../base/zpl_component.dart';
import '../../primitives/zpl_edge_insets.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

class ZplPadding extends ZplComponent {
  final ZplEdgeInsets padding;
  final ZplComponent child;

  ZplPadding({required this.padding, required this.child});

  @override
  void performLayout() {
    child.performLayout();
    setSize(
      ZplSize(
        child.size.width + padding.horizontal,
        child.size.height + padding.vertical,
      ),
    );
  }

  @override
  void compile(ZplContext context) {
    child.setOffset(offset.translate(padding.left, padding.top));
    child.compile(context);
  }
}
