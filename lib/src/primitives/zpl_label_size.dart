/// Represents common label dimensions in dots (203 DPI default).
class ZplLabelSize {
  /// Width in dots.
  final int width;

  /// Height in dots.
  final int height;

  /// Label name (e.g., 'Shipping 4x6').
  final String name;

  /// Creates a [ZplLabelSize] with the given [width], [height], and an optional [name].
  const ZplLabelSize(this.width, this.height, {this.name = ''});

  /// Standard 4x6 inch shipping label (812x1218 dots @ 203 DPI).
  static const shipping4x6 = ZplLabelSize(812, 1218, name: 'Shipping (4x6)');

  /// Standard 4x2 inch label (812x406 dots @ 203 DPI).
  static const standard4x2 = ZplLabelSize(812, 406, name: 'Label (4x2)');

  /// Small 2x1 inch label (406x203 dots @ 203 DPI).
  static const standard2x1 = ZplLabelSize(406, 203, name: 'Small (2x1)');

  /// Common label sizes for selecting in UI.
  static const List<ZplLabelSize> commonSizes = [
    shipping4x6,
    standard4x2,
    standard2x1,
  ];

  @override
  String toString() => name.isNotEmpty ? name : '$width x $height';
}
