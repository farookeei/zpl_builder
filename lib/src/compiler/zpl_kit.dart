import 'zpl_context.dart';
import '../components/base/zpl_component.dart';
import '../layout/geometry.dart';
import '../primitives/zpl_label_size.dart';

/// The entry point for the ZPL layout engine.
class ZplKit {
  /// Builds a complete ZPL label from the provided [root] component tree.
  ///
  /// This method performs two passes:
  /// 1. A layout pass to calculate relative and absolute coordinates.
  /// 2. A compilation pass to generate the final ZPL string.
  ///
  /// Optional [labelSize] allows setting fixed dimensions for the label.
  static String build(ZplComponent root, {ZplLabelSize? labelSize}) {
    // 1. Layout Pass
    ZplConstraints constraints = labelSize != null
        ? ZplConstraints(maxWidth: labelSize.width.toDouble(), maxHeight: labelSize.height.toDouble())
        : const ZplConstraints();
    
    root.performLayout(constraints);

    // Root starts at origin
    root.setOffset(ZplOffset.zero);

    // 2. Compilation Pass
    final context = ZplContext();
    context.addCommand('^XA\n'); // Start Format

    if (labelSize != null) {
      context.addCommand('^PW${labelSize.width}\n'); // Set Width
      context.addCommand('^LL${labelSize.height}\n'); // Set Length
    }

    root.compile(context);

    context.addCommand('^XZ'); // End Format
    return context.zplData;
  }
}
