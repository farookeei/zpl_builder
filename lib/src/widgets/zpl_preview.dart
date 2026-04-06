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
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the scale based on the available width
        final double screenWidthSize = constraints.maxWidth;
        final double logicalHeight = (screenWidthSize / labelSize.width) * labelSize.height;

        return Center(
          child: Container(
            width: screenWidthSize,
            height: logicalHeight,
            clipBehavior: Clip.hardEdge, // Ensure content doesn't leak onto the desk
            decoration: BoxDecoration(
              color: backgroundColor,
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.2),
                  blurRadius: 15,
                  offset: const Offset(0, 5),
                ),
              ],
            ),
            child: CustomPaint(
              painter: _ZplPainter(root, labelSize),
            ),
          ),
        );
      },
    );
  }
}

class _ZplPainter extends CustomPainter {
  final ZplComponent root;
  final ZplLabelSize labelSize;

  _ZplPainter(this.root, this.labelSize);

  @override
  void paint(Canvas canvas, Size size) {
    // 1. Calculate scale factor to fit dots into pixels
    // We want to fit 'labelSize.width' dots into 'size.width' pixels
    final double scaleX = size.width / labelSize.width;
    final double scaleY = size.height / labelSize.height;
    
    // Use the same scale for both axes to maintain aspect ratio
    final double scale = scaleX < scaleY ? scaleX : scaleY;

    canvas.save();
    canvas.scale(scale);

    // 2. Perform layout with fixed constraints matching the physical label size in dots
    root.performLayout(ZplConstraints(
      maxWidth: labelSize.width.toDouble(),
      maxHeight: labelSize.height.toDouble(),
      minWidth: labelSize.width.toDouble(),
      minHeight: labelSize.height.toDouble(),
    ));

    // 3. Assign absolute offsets in dots
    root.finalizeLayout(ZplOffset.zero);

    // 4. Render the tree
    root.paint(canvas, Offset.zero);
    
    canvas.restore();
  }

  @override
  bool shouldRepaint(covariant _ZplPainter oldDelegate) => 
    oldDelegate.root != root || oldDelegate.labelSize != labelSize;
}
