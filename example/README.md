# ZPL Kit Example

This project demonstrates how to use the `zpl_kit` package to generate ZPL (Zebra Programming Language) strings using a declarative layout engine.


## Features Shown

- **ZplColumn & ZplRow**: Flexbox-like layout for ZPL components.
- **ZplPadding**: Standard padding support.
- **ZplText**: Easily placed text with font control.
- **ZplBarcode**: Barcode generation with various types.
- **ZplBuilder**: The core compiler that transforms the component tree into raw ZPL.

## How to Run

1. Navigate to the example directory:
   ```bash
   cd example
   ```

2. Get dependencies:
   ```bash
   flutter pub get
   ```

3. Run the application:
   ```bash
   flutter run
   ```

## Example Code snippet

```dart
final root = ZplPadding(
  padding: ZplEdgeInsets.all(20),
  child: ZplColumn(
    spacing: 10,
    children: [
      ZplText('SHIPPING LABEL', font: ZplFont(fontName: '0', height: 40, width: 40)),
      ZplText('To: John Doe'),
      ZplBarcode('123456789', type: ZplBarcodeType.code128, height: 100),
    ],
  ),
);

String rawZpl = ZplBuilder.build(root);
```
