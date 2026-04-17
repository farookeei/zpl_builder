/// An immutable set of offsets in each of the four cardinal directions.
class ZplEdgeInsets {
  /// The offset from the left.
  final double left;

  /// The offset from the top.
  final double top;

  /// The offset from the right.
  final double right;

  /// The offset from the bottom.
  final double bottom;

  /// Creates insets where all the offsets are [value].
  const ZplEdgeInsets.all(double value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  /// Creates insets with symmetrical vertical and horizontal offsets.
  const ZplEdgeInsets.symmetric({double vertical = 0, double horizontal = 0})
      : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;

  /// Creates insets with only the given values non-zero.
  const ZplEdgeInsets.only({
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
  });

  /// The total offset on the horizontal axis.
  double get horizontal => left + right;

  /// The total offset on the vertical axis.
  double get vertical => top + bottom;
}
