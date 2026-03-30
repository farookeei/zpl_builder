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

## Phase 1: Core Layout Engine & Primitives
1. **Geometry & Constraints**: Define `Size`, `Offset`, and `BoxConstraints`.
2. **Component Interface**: Create `ZplComponent` interface with a flutter-like uncoupled `layout` phase and `paint` (ZPL compilation) phase.
3. **Primitives**: `ZplFont`, `ZplBarcodeType`, `ZplEdgeInsets`, `ZplCrossAxisAlignment`.

## Phase 2: Compiler & Basic Components
1. **ZplBuilder**: Takes a root `ZplComponent`, applies an initial constraint, triggers layout, then outputs the raw ZPL string (`^XA...^XZ`).
2. **Text & Padding**: Build `ZplText` (measuring strings based on font constants) and `ZplPadding`.
3. **Flex Layout**: Build `ZplColumn` and `ZplRow` using main axis/cross axis traversal similar to `Flex` in Flutter.

## Phase 3: Networking & Preview
1. **TCP Network Printing**: Create `ZebraPrinter.printZPL(...)` util method.
2. **Labelary API**: Take generated ZPL and request an image preview.
