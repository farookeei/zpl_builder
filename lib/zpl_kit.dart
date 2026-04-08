/// A library for building ZPL (Zebra Programming Language) labels using a declarative, Flexbox-like layout engine.
///
/// This package allows you to design labels with components like `ZplColumn`, `ZplRow`,
/// `ZplText`, and `ZplBarcode` without manually calculating absolute coordinates.
library;

// Base
export 'src/components/base/zpl_component.dart';

// Layout Engine & Geometry
export 'src/layout/geometry.dart';

// Compiled & Context
export 'src/compiler/zpl_kit.dart';

export 'src/compiler/zpl_context.dart';

// Primitives
export 'src/primitives/zpl_align_type.dart';
export 'src/primitives/zpl_barcode_type.dart';
export 'src/primitives/zpl_edge_insets.dart';
export 'src/primitives/zpl_font.dart';
export 'src/primitives/zpl_label_size.dart';

// Components - Layout
export 'src/components/layout/zpl_column.dart';
export 'src/components/layout/zpl_row.dart';
export 'src/components/layout/zpl_padding.dart';
export 'src/components/layout/zpl_stack.dart';
export 'src/components/layout/zpl_expanded.dart';
export 'src/components/layout/zpl_spacer.dart';
export 'src/components/layout/zpl_center.dart';

// Components - Widgets
export 'src/components/widgets/zpl_barcode.dart';
export 'src/components/widgets/zpl_text.dart';
export 'src/components/widgets/zpl_graphic_box.dart';
export 'src/components/widgets/zpl_divider.dart';

// Preview Widget
export 'src/widgets/zpl_preview.dart';
export 'src/widgets/zpl_labelary_preview.dart';

// Services
export 'src/services/labelary_service.dart';

