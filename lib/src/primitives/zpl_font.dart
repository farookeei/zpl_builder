class ZplFont {
  final String fontName;
  final double width;
  final double height;

  const ZplFont({
    required this.fontName,
    required this.width,
    required this.height,
  });

  static const ZplFont defaultFont = ZplFont(
    fontName: '0',
    width: 20,
    height: 30,
  );

  // ZPL font '0' is scalable and proportional
  static ZplFont helvetica({double size = 35}) {
    return ZplFont(fontName: '0', width: size * 0.6, height: size);
  }
}
