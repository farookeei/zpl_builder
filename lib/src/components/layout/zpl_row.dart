import 'dart:math';
import 'package:flutter/material.dart';
import '../base/zpl_component.dart';
import '../../primitives/zpl_align_type.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';
import 'zpl_expanded.dart';
import 'zpl_spacer.dart';

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
  void performLayout([ZplConstraints constraints = const ZplConstraints()]) {
    // PASS 1: Measure all "Fixed" children (those that aren't flexible)
    double totalUnflexedWidth = 0;
    double maxChildHeight = 0;
    int totalFlex = 0;

    for (var child in children) {
      if (child is ZplExpanded) {
        totalFlex += child.flex;
      } else if (child is ZplSpacer) {
        totalFlex += child.flex;
      } else {
        // This is a fixed-size child (like a standard Text or Barcode)
        // We pass the parent's height constraints so the child knows how tall it can be
        child.performLayout(constraints.copyWith(minWidth: 0));
        totalUnflexedWidth += child.size.width;
        maxChildHeight = max(maxChildHeight, child.size.height);
      }
    }

    // Calculate how much space is left for the Flexible children (Expanded/Spacer)
    double totalSpacing =
        spacing * (children.isNotEmpty ? children.length - 1 : 0);
    double remainingWidth = 0;

    if (constraints.hasBoundedWidth) {
      remainingWidth =
          max(0.0, constraints.maxWidth - totalUnflexedWidth - totalSpacing);
    }

    // PASS 2: Tell Flexible children how much of the "Remaining Width" they get
    for (var child in children) {
      if (child is ZplExpanded) {
        double flexWidth =
            totalFlex > 0 ? (child.flex / totalFlex) * remainingWidth : 0;
        // Force the child to take its share of the flex width
        child.performLayout(
            ZplConstraints(maxWidth: flexWidth, minWidth: flexWidth));
        maxChildHeight = max(maxChildHeight, child.size.height);
      } else if (child is ZplSpacer) {
        double flexWidth =
            totalFlex > 0 ? (child.flex / totalFlex) * remainingWidth : 0;
        child.performLayout(
            ZplConstraints(maxWidth: flexWidth, minWidth: flexWidth));
      }
    }

    // Final total width of the Row
    double finalWidth = constraints.hasBoundedWidth
        ? constraints.maxWidth
        : totalUnflexedWidth + totalSpacing;
    setSize(ZplSize(finalWidth, maxChildHeight));
  }

  @override
  void finalizeLayout(ZplOffset absoluteOffset) {
    setOffset(absoluteOffset);
    double currentDx = absoluteOffset.dx;

    for (var child in children) {
      double childDy = absoluteOffset.dy;

      switch (crossAxisAlignment) {
        case ZplCrossAxisAlignment.start:
          childDy = absoluteOffset.dy;
          break;
        case ZplCrossAxisAlignment.center:
          childDy = absoluteOffset.dy + (size.height - child.size.height) / 2;
          break;
        case ZplCrossAxisAlignment.end:
          childDy = absoluteOffset.dy + (size.height - child.size.height);
          break;
      }

      child.finalizeLayout(ZplOffset(currentDx, childDy));
      currentDx += child.size.width + spacing;
    }
  }

  @override
  void compile(ZplContext context) {
    for (var child in children) {
      child.compile(context);
    }
  }

  @override
  void paint(Canvas canvas, Offset offset) {
    for (var child in children) {
      child.paint(canvas, offset);
    }
  }
}
