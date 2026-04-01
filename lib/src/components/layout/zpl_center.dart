import '../base/zpl_component.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

/// A component that perfectly centers its child within the available constraints.
class ZplCenter extends ZplComponent {
  final ZplComponent? child;

  ZplCenter({this.child});

  @override
  void performLayout([ZplConstraints constraints = const ZplConstraints()]) {
    if (child != null) {
      child!.performLayout(constraints.copyWith(minWidth: 0, minHeight: 0));
      double width = constraints.hasBoundedWidth ? constraints.maxWidth : child!.size.width;
      double height = constraints.hasBoundedHeight ? constraints.maxHeight : child!.size.height;
      setSize(ZplSize(width, height));
    } else {
      setSize(ZplSize(
          constraints.hasBoundedWidth ? constraints.maxWidth : 0, 
          constraints.hasBoundedHeight ? constraints.maxHeight : 0));
    }
  }

  @override
  void compile(ZplContext context) {
    if (child != null) {
      double dx = offset.dx + (size.width - child!.size.width) / 2;
      double dy = offset.dy + (size.height - child!.size.height) / 2;
      child!.setOffset(ZplOffset(dx, dy));
      child!.compile(context);
    }
  }
}
