import 'zpl_context.dart';
import '../components/base/zpl_component.dart';
import '../layout/geometry.dart';

class ZplKit {

  static String build(ZplComponent root) {
    // 1. Layout Pass
    root.performLayout();

    // Root starts at origin
    root.setOffset(ZplOffset.zero);

    // 2. Compilation Pass
    final context = ZplContext();
    context.addCommand('^XA\n'); // Start Format

    root.compile(context);

    context.addCommand('^XZ'); // End Format
    return context.zplData;
  }
}
