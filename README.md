# ZPL Kit

A powerful, declarative layout engine for generating Zebra Programming Language (ZPL) strings in Flutter. Stop manually calculating absolute coordinates and start building labels with a modern, Flexbox-like API—now with built-in support for **Network and Web-based printing.**

[![pub package](https://img.shields.io/pub/v/zpl_kit.svg)](https://pub.dev/packages/zpl_kit)
[![License: MIT](https://img.shields.io/badge/License-MIT-yellow.svg)](https://opensource.org/licenses/MIT)

---

## Why ZplKit?

Traditional ZPL generation involves constant string concatenation and error-prone absolute `^FO` (Field Origin) math. `zpl_kit` solves this by introducing a **three-pass layout engine** that automatically calculates positions based on parent constraints.

- **Declarative UI**: Build labels just like you build Flutter widgets.
- **Flexbox Power**: Use `Expanded`, `Spacer`, and flex-ratios to divide label space.
- **Precision Centering**: Automatically center barcodes and text with `ZplCenter`.
- **Smart Text**: Support for multi-line wrapping and text alignment using native ZPL `^FB` blocks.

---

## Before & After

Designing labels shouldn't feel like math class. See how much cleaner your code becomes with `zpl_kit`.

### The Old Way (Manual String Building)
Manual math to align elements. If you move one thing, you have to recalculate every coordinate below it.

```dart
// Manual, Error-prone, hard to maintain
String generateZpl(String shipFrom, String carrier) {
  return "^XA" +
         "^FO50,50^A0N,40,40^FD$shipFrom^FS" +
         "^FO420,50^A0N,40,40^FD$carrier^FS" + // Manual math to align!
         "^FO50,100^GB700,2,2^FS" +
         "^FO200,250^BY3^BCN,150,Y,N,N^FD123456^FS" +
         "^XZ";
}
```

### The `zpl_kit` Way (Declarative)
Define the **structural relationships** and let the engine handle the math.

```dart
// Declarative, Flexible, and Readable
final label = ZplColumn(
  children: [
    ZplRow(
      children: [
        ZplExpanded(child: ZplText('SHIP FROM: $shipFrom')),
        ZplExpanded(child: ZplText('CARRIER: $carrier', textAlign: ZplTextAlign.right)),
      ],
    ),
    ZplDivider(),
    ZplCenter(child: ZplBarcode('123456', height: 150)),
  ],
);
```

---

## Live Previews

`zpl_kit` includes two distinct preview widgets to supercharge your label development without needing a physical printer next to your desk.

| Native Preview (`ZplPreview`) | Cloud Preview (`ZplLabelaryPreview`) |
| :--- | :--- |
| **Speed:** Instant / Offline | **Speed:** Requires Network Call |
| **Accuracy:** High | **Accuracy:** 100% True-to-Printer (Labelary API) |
| **Use Case:** Rapid iterative development | **Use Case:** Final layout verifications before printing |

### The Proof

Our rendering engine uses exact ISO-standard math for barcode scaling and text constraints, ensuring that what you see in the preview is **exactly** what you get on the physical Zebra thermal printer.

| Labelary Preview | Physical Printed Label |
| :---: | :---: |
| <img src="https://raw.githubusercontent.com/farookeei/zpl_kit/main/doc/images/labelarypreview.webp" width="200" alt="Labelary Preview Screenshot" /> | <img src="https://raw.githubusercontent.com/farookeei/zpl_kit/main/doc/images/printed_label.webp" width="200" alt="Physical Printed Label Photo" /> |

---

## Installation

Add `zpl_kit` to your `pubspec.yaml`:

```yaml
dependencies:
  zpl_kit: ^0.0.7
```

---

## Usage

Import the package and use the `ZplKit.build()` method to generate your code.

```dart
import 'package:zpl_kit/zpl_kit.dart';

void main() {
  final label = ZplColumn(
    children: [
      // A Row that splits space 50/50
      ZplRow(
        children: [
          ZplExpanded(
            flex: 1,
            child: ZplText('SHIP FROM:', textAlign: ZplTextAlign.left),
          ),
          ZplExpanded(
            flex: 1,
            child: ZplText('CARRIER: UPS', textAlign: ZplTextAlign.right),
          ),
        ],
      ),

      ZplDivider(thickness: 2), // Spans full width automatically

      ZplSpacer(flex: 1), // Pushes content apart

      // Perfectly centered barcode
      ZplCenter(
        child: ZplBarcode(
          '1Z9999999999999999',
          type: ZplBarcodeType.code128,
          height: 150,
        ),
      ),
    ],
  );

  // Compile to ZPL string for a standard 4x6 label (800x1200 dots @ 203dpi)
  final String zpl = ZplKit.build(
    label, 
    labelSize: ZplLabelSize.shipping4x6,
  );
  
  print(zpl);
}
```

---

## Printing Support

`zpl_kit` makes it easy to send your generated ZPL strings to physical printers. It provides an extensible OOP architecture to support different connection types.

### 1. Network Printing (TCP/IP)
Best for Mobile and Desktop apps connecting directly to Zebra printers on the local network (usually port 9100).

```dart
// Connect, send, and disconnect automatically
final success = await TcpZplPrinter.printOnce(
  host: '192.168.1.100',
  zpl: zplCode,
);

// OR handle the connection manually for multiple labels
final printer = TcpZplPrinter(host: '192.168.1.100');
await printer.connect();
await printer.send(zplCode);
await printer.disconnect();
```

### 2. Web & REST Printing (HTTP)
Perfect for Web apps or environments using a REST bridge. This works on all platforms (Mobile, Desktop, and Web).

```dart
final success = await HttpZplPrinter.printOnce(
  baseUrl: Uri.parse('http://your-printer-ip'),
  zpl: zplCode,
);
```

### 3. Custom Connectors
Need Bluetooth or USB support? You can easily create your own connector by extending `ZplPrinterConnector`.

```dart
class BluetoothZplPrinter extends ZplPrinterConnector {
  @override
  Future<bool> send(String zpl) async {
    // Your bluetooth implementation here
  }
  // ... implement other methods
}
```

---

## Layout Primitives

| Component | Description |
| :--- | :--- |
| **`ZplColumn`** | Arranges children vertically. Supports `crossAxisAlignment`. |
| **`ZplRow`** | Arranges children horizontally. Supports `crossAxisAlignment`. |
| **`ZplExpanded`** | Tells a child to fill the remaining available space in a Row/Column. |
| **`ZplSpacer`** | An empty flexible space used to push components apart. |
| **`ZplCenter`** | Automatically calculates offsets to center its child within the parent. |
| **`ZplStack`** | Allows layering components on top of each other (Absolute positioning). |
| **`ZplPadding`** | Adds space around its child using `ZplEdgeInsets`. |

---

## Component Widgets

| Widget | Description |
| :--- | :--- |
| **`ZplText`** | Standard text. Supports custom fonts, alignment (`textAlign`), and wrapping (`maxLines`). |
| **`ZplBarcode`** | Generates barcodes (Code 128, QR, etc.) with configurable height and ratio. |
| **`ZplDivider`** | A convenience widget for drawing horizontal separator lines. |
| **`ZplGraphicBox`** | Draws squares, rectangles, or lines with optional rounding. |

---

## Technical Details: The Layout Engine

`zpl_kit` uses a logic inspired by Flutter's layout protocol:
1. **Pass 1: Constraints Down**: The parent sends `ZplConstraints` (max width/height) to its children.
2. **Pass 2: Sizes Up**: Children calculate their size based on those constraints and report back.
3. **Pass 3: Compilation**: Once sizes are locked, the engine performs a final pass to generate the ZPL string, injecting the calculated `^FO` coordinates.

This allows for complex nesting like a `ZplRow` inside a `ZplExpanded` child of a `ZplColumn`.

---

## Tested Hardware

This package is actively tested on industrial Zebra printers to ensure physical print accuracy:
- **Zebra GK420T**: Verified for high-speed shipping label generation (4x6).
- **Zebra ZD series**: General compatibility with ZPLII standard.

---

## License

This project is licensed under the MIT License - see the [LICENSE](LICENSE) file for details.
