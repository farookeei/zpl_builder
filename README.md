# ZPL Kit

A powerful, declarative layout engine for generating Zebra Programming Language (ZPL) strings in Flutter.

## Features

- **Flexbox-like Layouts**: Use `ZplColumn` and `ZplRow` to manage alignment and spacing without worrying about coordinates.
- **Declarative Style**: Define your label's structure once; the compiler calculates all `^FO` (Field Origin) tags automatically.
- **Rich Components**: Includes `ZplText`, `ZplBarcode`, `ZplPadding`, and more.
- **Easy Compilation**: One-step build process from component tree to ZPL string.

## Getting started

Add `zpl_kit` to your `pubspec.yaml`:

```yaml
dependencies:
  zpl_kit: ^0.0.1
```

## Usage

```dart
final root = ZplColumn(
  crossAxisAlignment: ZplCrossAxisAlignment.center,
  children: [
    ZplText('HELLO WORLD'),
    ZplBarcode('987654321', type: ZplBarcodeType.code128),
  ],
);

final String zpl = ZplBuilder.build(root);
```

## Example Application

Check out the [example](/example) folder for a full Flutter application demonstrating how to use the layout engine interactively.

## Additional information

This package aims to simplify label design for Zebra printers by abstracting away the coordinate-based system of raw ZPL.
