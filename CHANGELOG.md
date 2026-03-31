## 0.0.2

* **Advanced Layout**: Added `ZplStack` for overlapping elements and `ZplGraphicBox` for lines and boxes.
* **Label Dimensions**: Introduced `ZplLabelSize` with pre-defined standards like Shipping (4x6).
* **Improved API**: Added `ZplFont.helvetica()` helper for simpler scalable font management.
* **Printing Support**: Added `ZebraPrinterService` in the example app for direct socket-based network printing.
* **Example Enhancements**: Updated the example app with a full professional shipping label layout and printer settings.

## 0.0.1+1

* Added comprehensive DartDoc documentation for core API elements.
* Fixed class names in the README example.
* Improved library-level documentation for pub.dev scoring.

## 0.0.1

* **Initial Release**: Core declarative layout engine for Zebra Programming Language (ZPL).
* **Layout Components**: Added `ZplColumn`, `ZplRow`, and `ZplPadding` for coordinate-free design.
* **Basic Widgets**: Implemented `ZplText` and `ZplBarcode` (supporting Code 128 and other common types).
* **Compiler**: Integrated `ZplBuilder` to transform the component tree into raw ZPL strings.
* **Example Project**: Added a full Flutter example app for interactive testing and demonstration.
