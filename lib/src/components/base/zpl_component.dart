import 'package:flutter/material.dart';
import '../../layout/geometry.dart';
import '../../compiler/zpl_context.dart';

/// The base class for all UI components in the ZPL layout engine.
abstract class ZplComponent {
  /// Default constructor for [ZplComponent].
  ZplComponent();


  ZplSize? _size;
  ZplOffset? _offset;

  /// The calculated size of the component.
  ZplSize get size => _size ?? ZplSize.zero;

  /// The absolute offset of the component from the label origin.
  ZplOffset get offset => _offset ?? ZplOffset.zero;

  /// Sets the size of the component. Typically called during `performLayout`.
  void setSize(ZplSize newSize) {
    _size = newSize;
  }

  /// Sets the absolute offset of the component. Typically called during `finalizeLayout`.
  void setOffset(ZplOffset newOffset) {
    _offset = newOffset;
  }

  /// PASS 1: Calculates the size of this component and its children based on constraints.
  void performLayout([ZplConstraints constraints = const ZplConstraints()]);

  /// PASS 2: Calculates the absolute X and Y coordinates for this component and its children.
  void finalizeLayout(ZplOffset absoluteOffset);

  /// PASS 3 (ZPL): Generates the ZPL commands for this component.
  void compile(ZplContext context);

  /// PASS 3 (Screen): Renders this component on a Flutter [Canvas].
  void paint(Canvas canvas, Offset offset);
}
