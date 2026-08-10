# ZPL Builder Package - Implementation Plan

## The Vision
An industry-leading ZPL package providing a **Flexbox-like Layout Engine for ZPL**. It eliminates the need to manually manage `X` and `Y` coordinates by measuring the virtual sizes of declarative elements and generating the corresponding ZPL commands (`^FOx,y`).

## Architecture & Folder Structure

```
lib/
├── src/
│   ├── components/
│   │   ├── base/
│   │   │   └── zpl_component.dart      # Base interface for all ZPL components
│   │   ├── layout/
│   │   │   ├── zpl_column.dart         # Vertical flex layout
│   │   │   ├── zpl_row.dart            # Horizontal flex layout
│   │   │   ├── zpl_padding.dart        # Adds space around a child
│   │   │   └── zpl_align.dart          # Aligns child within parent bounds
│   │   └── widgets/
│   │       ├── zpl_text.dart           # Renders text with fonts
│   │       └── zpl_barcode.dart        # Renders barcodes (e.g. Code 128)
│   ├── layout/
│   │   ├── engine.dart                 # Core measurement & layout calculation
│   │   ├── geometry.dart               # Size, Offset, Rect definitions (analogous to Flutter's)
│   │   └── constraints.dart            # BoxConstraints implementation
│   ├── primitives/
│   │   ├── zpl_font.dart               # Font enum and size configuration
│   │   ├── zpl_barcode_type.dart       # Barcode definitions
│   │   └── zpl_edge_insets.dart        # Padding config
│   └── compiler/
│       ├── zpl_kit.dart                # The main compiler rendering components to ^XA...^XZ
│       └── zpl_context.dart            # State-holder for ZPL command building during compilation
├── test
│   └── zpl_kit_test.dart               # Unit tests verifying layout math and compilation
└── zpl_kit.dart                        # Main package export file
```

## Phase 1: Core Layout Engine & Primitives (Completed)
- [x] 1. **Geometry & Constraints**: Define `Size`, `Offset`, and `BoxConstraints`.
- [x] 2. **Component Interface**: Create `ZplComponent` interface with a flutter-like uncoupled `layout` phase and `paint` (ZPL compilation) phase.
- [x] 3. **Primitives**: `ZplFont`, `ZplBarcodeType`, `ZplEdgeInsets`, `ZplCrossAxisAlignment`.

## Phase 2: Compiler & Basic Components (Completed)
- [x] 1. **ZplBuilder**: Takes a root `ZplComponent`, applies an initial constraint, triggers layout, then outputs the raw ZPL string (`^XA...^XZ`).
- [x] 2. **Text & Padding**: Build `ZplText` (measuring strings based on font constants) and `ZplPadding`.
- [x] 3. **Flex Layout**: Build `ZplColumn` and `ZplRow` using main axis/cross axis traversal similar to `Flex` in Flutter.

## Phase 3: Networking & Preview (Completed)
- [x] 1. **Network Printing**: `TcpZplPrinter` (Socket) and `HttpZplPrinter` (REST) implementations.
- [x] 2. **Previews**: Offline `ZplPreview` canvas rendering and `ZplLabelaryPreview` (Labelary API cloud rendering).

## Phase 4: Layout Polish, QR Codes & Batching (v0.0.8 - Completed)
- [x] 1. **2D Barcode Support**: `QR Code (^BQ)` in `ZplBarcodeType`.
- [x] 2. **Flexbox Consolidation**: Enable full `MainAxisAlignment` (Center, SpaceBetween, SpaceAround) in `ZplRow` and `ZplColumn`.
- [x] 3. **Batch Printing**: Grouping multiple labels into a single print job (`ZplKit.buildBatch` and `^PQ` print quantity).

## Phase 5: Rich Content & Advanced UI
- [ ] 1. **2D Barcode Expansion**: Support `Data Matrix (^BX)` in `ZplBarcodeType`.
- [ ] 2. **Graphic Field Support**: Add `ZplImage` for converting bitmaps/logos to `^GF` ZPL commands.
- [ ] 3. **Inversion & Underlining**: Support `^FR` (Field Reverse) and `^FW` (Field Orientation) for rotated text.
- [ ] 4. **Enhanced Typography**: Support custom font downloading (`^CW`) and scaling styles.

## Phase 6: Developer Experience (DX) & Professional Features
- [ ] 1. **Physical Units**: Allow dimensions in `mm`, `cm`, and `inch` with auto-conversion to dots based on DPI (203/300/600).
- [ ] 2. **ZPL Variables & Template Support**: Implement placeholders for dynamic data binding and `^DF`/`^XF` template workflows.
- [ ] 3. **Serialization**: Support for JSON serialization of label layouts.

## Phase 7: Declarative Layout Enhancements
- [ ] 1. **Vertical Dividers**: Implement `ZplVerticalDivider` that automatically spans parent height using constraints.
- [ ] 2. **Intrinsic Sizing**: Support `IntrinsicWidth` and `IntrinsicHeight` for components that need to size themselves based on children before layout.

## Additional Plans
- [ ] 1. **Separate all the zebra commands in a single page and map them to the corresponding ZPL components.**
- [ ] 2. **Implement Platform-specific Printing (BLE/USB) for Flutter Mobile apps.**
- [ ] 3. **Native Direct-to-Device Printing support for Android/iOS (Zebra SDK Bridge).**
