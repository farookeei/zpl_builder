class ZplEdgeInsets {
  final double left;
  final double top;
  final double right;
  final double bottom;

  const ZplEdgeInsets.all(double value)
      : left = value,
        top = value,
        right = value,
        bottom = value;

  const ZplEdgeInsets.symmetric({double vertical = 0, double horizontal = 0})
      : left = horizontal,
        top = vertical,
        right = horizontal,
        bottom = vertical;

  const ZplEdgeInsets.only({
    this.left = 0,
    this.top = 0,
    this.right = 0,
    this.bottom = 0,
  });

  double get horizontal => left + right;
  double get vertical => top + bottom;
}
