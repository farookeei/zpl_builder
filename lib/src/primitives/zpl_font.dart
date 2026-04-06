/// Represents a ZPL font definition.
class ZplFont {
  /// The ZPL font name (e.g., '0' for CG Triumvirate, 'A' to 'Z' for bitmapped fonts).
  final String fontName;

  /// The width of the font in dots.
  final double width;

  /// The height of the font in dots.
  final double height;

  const ZplFont({
    this.fontName = '0',
    this.width = 30.0,
    this.height = 30.0,
  });

  /// A helper for the standard scalable font ('0') that mimics Helvetica.
  ///
  /// [size] is the height in dots. Width is automatically calculated at 0.8 ratio.
  static ZplFont helvetica({double size = 35}) {
    return ZplFont(
      fontName: '0',
      width: (size * 0.8),
      height: size,
    );
  }

  /// Default font settings for common labels.
  static const ZplFont defaultFont = ZplFont(
    fontName: '0',
    width: 20.0,
    height: 30.0,
  );
}
