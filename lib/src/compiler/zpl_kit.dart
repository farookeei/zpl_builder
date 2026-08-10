import 'zpl_context.dart';
import '../components/base/zpl_component.dart';
import '../layout/geometry.dart';
import '../primitives/zpl_label_size.dart';

/// The entry point for the ZPL layout engine.
class ZplKit {
  /// Private constructor to prevent instantiation.
  ZplKit._();

  /// Builds a complete ZPL label from the provided [root] component tree.
  ///
  /// This method performs two passes:
  /// 1. A layout pass to calculate relative and absolute coordinates.
  /// 2. A compilation pass to generate the final ZPL string.
  ///
  /// Optional [labelSize] allows setting fixed dimensions for the label.
  /// Optional [printQuantity] adds a `^PQ` command to specify how many copies to print (default 1).
  static String build(ZplComponent root,
      {ZplLabelSize? labelSize, int printQuantity = 1}) {
    // 1. Layout Pass
    ZplConstraints constraints = labelSize != null
        ? ZplConstraints(
            maxWidth: labelSize.width.toDouble(),
            maxHeight: labelSize.height.toDouble())
        : const ZplConstraints();

    root.performLayout(constraints);

    // 2. Finalize Pass (Assign absolute offsets)
    root.finalizeLayout(ZplOffset.zero);

    // 3. Compilation Pass
    final context = ZplContext();
    context.addCommand('^XA\n'); // Start Format

    if (labelSize != null) {
      context.addCommand('^PW${labelSize.width}\n'); // Set Width
      context.addCommand('^LL${labelSize.height}\n'); // Set Length
    }

    root.compile(context);

    if (printQuantity > 1) {
      context.addCommand('^PQ$printQuantity\n');
    }

    context.addCommand('^XZ'); // End Format
    return context.zplData;
  }

  /// Builds a batch of ZPL labels by generating ZPL for each component in [labels]
  /// and concatenating them into a single string.
  ///
  /// This is useful for printing multiple different labels in a single network request.
  static String buildBatch(List<ZplComponent> labels,
      {ZplLabelSize? labelSize}) {
    final buffer = StringBuffer();
    for (var label in labels) {
      buffer.write(build(label, labelSize: labelSize));
    }
    return buffer.toString();
  }
}
