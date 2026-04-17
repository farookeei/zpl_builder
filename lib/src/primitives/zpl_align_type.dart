import 'package:flutter/material.dart';

/// Alignment on the cross axis.
enum ZplCrossAxisAlignment {
  /// Aligns to the start of the cross axis.
  start,

  /// Aligns to the center of the cross axis.
  center,

  /// Aligns to the end of the cross axis.
  end
}

/// Alignment on the main axis.
enum ZplMainAxisAlignment {
  /// Aligns to the start of the main axis.
  start,

  /// Aligns to the center of the main axis.
  center,

  /// Aligns to the end of the main axis.
  end,

  /// Spaces children out equally across the main axis with space between.
  spaceBetween,

  /// Spaces children out equally across the main axis with space around.
  spaceAround
}

/// Alignment for text blocks in ZPL.
enum ZplTextAlign {
  /// Aligns text to the left.
  left,

  /// Aligns text to the center.
  center,

  /// Aligns text to the right.
  right,

  /// Justifies the text.
  justified;

  /// Converts the text alignment to a Flutter equivalent.
  TextAlign toFlutter() {
    switch (this) {
      case ZplTextAlign.left:
        return TextAlign.left;
      case ZplTextAlign.center:
        return TextAlign.center;
      case ZplTextAlign.right:
        return TextAlign.right;
      case ZplTextAlign.justified:
        return TextAlign.justify;
    }
  }

  /// Retrieves the ZPL command character equivalent for this text alignment.
  String get command {
    switch (this) {
      case ZplTextAlign.left:
        return 'L';
      case ZplTextAlign.center:
        return 'C';
      case ZplTextAlign.right:
        return 'R';
      case ZplTextAlign.justified:
        return 'J';
    }
  }
}
