enum ZplBarcodeType {
  code39('B3'),
  code128('BC'),
  upcA('BU'),
  ean8('B8'),
  ean13('BE');

  final String command;
  const ZplBarcodeType(this.command);
}
