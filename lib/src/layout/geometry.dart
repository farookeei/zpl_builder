import '../primitives/zpl_edge_insets.dart';

/// Represents a 2D size with [width] and [height].
class ZplSize {
  /// The width component of the size.
  final double width;

  /// The height component of the size.
  final double height;

  /// Creates a [ZplSize] with the given [width] and [height].
  const ZplSize(this.width, this.height);

  /// An empty size of zero width and zero height.
  static const ZplSize zero = ZplSize(0, 0);
}

/// Represents a 2D offset with [dx] (x-axis) and [dy] (y-axis) coordinates.
class ZplOffset {
  /// The x-axis coordinate in dots.
  final double dx;

  /// The y-axis coordinate in dots.
  final double dy;

  /// Creates a [ZplOffset] with the given [dx] and [dy].
  const ZplOffset(this.dx, this.dy);

  /// An offset positioned at the origin (0, 0).
  static const ZplOffset zero = ZplOffset(0, 0);

  /// Returns a new [ZplOffset] translated by [translateX] and [translateY].
  ZplOffset translate(double translateX, double translateY) =>
      ZplOffset(dx + translateX, dy + translateY);
}

/// Constraints to pass down available dimensions to children components
class ZplConstraints {
  /// The minimum width constraint.
  final double minWidth;

  /// The maximum width constraint.
  final double maxWidth;

  /// The minimum height constraint.
  final double minHeight;

  /// The maximum height constraint.
  final double maxHeight;

  /// Creates a [ZplConstraints] with optional constraints.
  const ZplConstraints({
    this.minWidth = 0.0,
    this.maxWidth = double.infinity,
    this.minHeight = 0.0,
    this.maxHeight = double.infinity,
  });

  /// Whether there is an upper bound on the maximum width.
  bool get hasBoundedWidth => maxWidth < double.infinity;

  /// Whether there is an upper bound on the maximum height.
  bool get hasBoundedHeight => maxHeight < double.infinity;

  /// Creates a copy of this [ZplConstraints] but with the given fields replaced with the new values.
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

  /// Returns new constraints with the given [padding] removed from the available space.
  ZplConstraints deflate(ZplEdgeInsets padding) {
    return ZplConstraints(
      minWidth: (minWidth - padding.horizontal).clamp(0, double.infinity),
      maxWidth: (maxWidth - padding.horizontal).clamp(0, double.infinity),
      minHeight: (minHeight - padding.vertical).clamp(0, double.infinity),
      maxHeight: (maxHeight - padding.vertical).clamp(0, double.infinity),
    );
  }
}
