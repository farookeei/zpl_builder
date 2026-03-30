class ZplSize {
  final double width;
  final double height;
  const ZplSize(this.width, this.height);
  static const ZplSize zero = ZplSize(0, 0);
}

class ZplOffset {
  final double dx;
  final double dy;
  const ZplOffset(this.dx, this.dy);
  static const ZplOffset zero = ZplOffset(0, 0);

  ZplOffset translate(double translateX, double translateY) =>
      ZplOffset(dx + translateX, dy + translateY);
}
