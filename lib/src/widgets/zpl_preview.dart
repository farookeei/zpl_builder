import 'package:flutter/material.dart';
import '../components/base/zpl_component.dart';
import '../primitives/zpl_label_size.dart';
import '../layout/geometry.dart';

/// A widget that renders a visual preview of a [ZplComponent] tree.
///
/// This provides a native, off-line alternative to the Labelary API.
class ZplPreview extends StatelessWidget {
  /// The root component of the label to preview.
  final ZplComponent root;

  /// The physical size of the label.
  final ZplLabelSize labelSize;

  /// The color of the label background (usually white).
  final Color backgroundColor;

  /// Creates a new `ZplPreview`.
  const ZplPreview({
    super.key,
    required this.root,
    required this.labelSize,
    this.backgroundColor = Colors.white,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: labelSize.width.toDouble(),
      height: labelSize.height.toDouble(),
      decoration: BoxDecoration(
        color: backgroundColor,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.1),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: CustomPaint(
        painter: _ZplPainter(root, labelSize),
      ),
    );
  }
}

class _ZplPainter extends CustomPainter {
  final ZplComponent root;
  final ZplLabelSize labelSize;

  _ZplPainter(this.root, this.labelSize);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Perform layout with fixed constraints matching the label size
    root.performLayout(ZplConstraints(
      maxWidth: labelSize.width.toDouble(),
      maxHeight: labelSize.height.toDouble(),
      minWidth: labelSize.width.toDouble(),
      minHeight: labelSize.height.toDouble(),
    ));

    // 2. Assign absolute offsets
    root.finalizeLayout(ZplOffset.zero);

    // 3. Render the tree
    root.paint(canvas, Offset.zero);
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}
