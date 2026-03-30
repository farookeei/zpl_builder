import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

abstract class ZplComponent {
  ZplSize? _size;
  ZplOffset? _offset;

  ZplSize get size => _size ?? ZplSize.zero;
  ZplOffset get offset => _offset ?? ZplOffset.zero;

  void setSize(ZplSize newSize) {
    _size = newSize;
  }

  void setOffset(ZplOffset newOffset) {
    _offset = newOffset;
  }

  void performLayout();
  void compile(ZplContext context);
}
