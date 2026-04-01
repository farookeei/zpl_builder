import 'dart:math';
import '../base/zpl_component.dart';
import '../../primitives/zpl_align_type.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';
import 'zpl_expanded.dart';
import 'zpl_spacer.dart';

/// A layout component that arranges its children in a vertical array.
class ZplColumn extends ZplComponent {
  /// The children components to arrange vertically.
  final List<ZplComponent> children;

  /// How the children should be placed along the cross (horizontal) axis.
  final ZplCrossAxisAlignment crossAxisAlignment;

  /// The space to place between each child.
  final double spacing;

  /// Creates a [ZplColumn] with the given [children].
  ZplColumn({
    required this.children,
    this.crossAxisAlignment = ZplCrossAxisAlignment.start,
    this.spacing = 0.0,
  });

  @override
  void performLayout([ZplConstraints constraints = const ZplConstraints()]) {
    // PASS 1: Measure all "Fixed" children (those that aren't flexible)
    double totalUnflexedHeight = 0;
    double maxChildWidth = 0;
    int totalFlex = 0;

    for (var child in children) {
      if (child is ZplExpanded) {
        totalFlex += child.flex;
      } else if (child is ZplSpacer) {
        totalFlex += child.flex;
      } else {
        // This is a fixed-size child (like a standard Text or Barcode)
        // We pass the parent's width constraints so the child knows how wide it can be
        child.performLayout(constraints.copyWith(minHeight: 0));
        totalUnflexedHeight += child.size.height;
        maxChildWidth = max(maxChildWidth, child.size.width);
      }
    }

    // Calculate how much space is left for the Flexible children
    double totalSpacing =
        spacing * (children.isNotEmpty ? children.length - 1 : 0);
    double remainingHeight = 0;

    if (constraints.hasBoundedHeight) {
      remainingHeight =
          max(0.0, constraints.maxHeight - totalUnflexedHeight - totalSpacing);
    }

    // PASS 2: Tell Flexible children how much of the "Remaining Height" they get
    for (var child in children) {
      if (child is ZplExpanded) {
        double flexHeight =
            totalFlex > 0 ? (child.flex / totalFlex) * remainingHeight : 0;
        // Force the child to take its share of the flex height
        child.performLayout(
            ZplConstraints(maxHeight: flexHeight, minHeight: flexHeight));
        maxChildWidth = max(maxChildWidth, child.size.width);
      } else if (child is ZplSpacer) {
        double flexHeight =
            totalFlex > 0 ? (child.flex / totalFlex) * remainingHeight : 0;
        child.performLayout(
            ZplConstraints(maxHeight: flexHeight, minHeight: flexHeight));
      }
    }

    // Final total height of the Column
    double finalHeight = constraints.hasBoundedHeight
        ? constraints.maxHeight
        : totalUnflexedHeight + totalSpacing;
    setSize(ZplSize(maxChildWidth, finalHeight));
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
