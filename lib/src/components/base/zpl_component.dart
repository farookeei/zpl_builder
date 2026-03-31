import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

/// The base class for all UI components in the ZPL layout engine.
abstract class ZplComponent {
  ZplSize? _size;
  ZplOffset? _offset;

  /// The calculated size of the component.
  ZplSize get size => _size ?? ZplSize.zero;

  /// The relative offset of the component from its parent.
  ZplOffset get offset => _offset ?? ZplOffset.zero;

  /// Sets the size of the component. Typically called during `performLayout`.
  void setSize(ZplSize newSize) {
    _size = newSize;
  }

  /// Sets the absolute offset of the component. Typically called during layout propagation.
  void setOffset(ZplOffset newOffset) {
    _offset = newOffset;
  }

  /// Calculates the size of this component and its children.
  void performLayout();

  /// Generates the ZPL commands for this component.
  void compile(ZplContext context);
}
