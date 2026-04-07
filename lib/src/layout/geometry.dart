import '../primitives/zpl_edge_insets.dart';

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

/// Constraints to pass down available dimensions to children components
class ZplConstraints {
  final double minWidth;
  final double maxWidth;
  final double minHeight;
  final double maxHeight;

  const ZplConstraints({
    this.minWidth = 0.0,
    this.maxWidth = double.infinity,
    this.minHeight = 0.0,
    this.maxHeight = double.infinity,
  });

  bool get hasBoundedWidth => maxWidth < double.infinity;
  bool get hasBoundedHeight => maxHeight < double.infinity;

  ZplConstraints copyWith({
    double? minWidth,
    double? maxWidth,
    double? minHeight,
    double? maxHeight,
  }) {
    return ZplConstraints(
      minWidth: minWidth ?? this.minWidth,
      maxWidth: maxWidth ?? this.maxWidth,
      minHeight: minHeight ?? this.minHeight,
      maxHeight: maxHeight ?? this.maxHeight,
    );
  }

  ZplConstraints deflate(ZplEdgeInsets padding) {
    return ZplConstraints(
      minWidth: (minWidth - padding.horizontal).clamp(0, double.infinity),
      maxWidth: (maxWidth - padding.horizontal).clamp(0, double.infinity),
      minHeight: (minHeight - padding.vertical).clamp(0, double.infinity),
      maxHeight: (maxHeight - padding.vertical).clamp(0, double.infinity),
    );
  }
}
