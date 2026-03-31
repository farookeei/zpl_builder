/// Supported ZPL barcode types.
enum ZplBarcodeType {
  /// Code 39 barcode.
  code39('B3'),

  /// Code 128 barcode.
  code128('BC'),

  /// UPC-A barcode.
  upcA('BU'),

  /// EAN-8 barcode.
  ean8('B8'),

  /// EAN-13 barcode.
  ean13('BE');

  /// The raw ZPL command for this barcode type.
  final String command;

  /// Creates a new `ZplBarcodeType` with the specified [command].
  const ZplBarcodeType(this.command);
}
