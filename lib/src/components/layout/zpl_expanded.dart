import '../base/zpl_component.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

/// A component that expands a child of a [ZplRow] or [ZplColumn] to fill the available space.
class ZplExpanded extends ZplComponent {
  final int flex;
  final ZplComponent child;

  ZplExpanded({
    this.flex = 1,
    required this.child,
  });

  @override
  void performLayout([ZplConstraints constraints = const ZplConstraints()]) {
    // Child is given constraints dictated by the parent Row/Column
    child.performLayout(constraints);
    setSize(child.size);
  }

  @override
  void compile(ZplContext context) {
    child.setOffset(offset);
    child.compile(context);
  }
}
