import 'package:flutter_test/flutter_test.dart';
import 'package:zpl_builder/zpl_builder.dart';

void main() {
  test('ZPL Builder compiles basic layout correctly', () {
    final zpl = ZplBuilder.build(
      ZplColumn(
        crossAxisAlignment: ZplCrossAxisAlignment.start,
        children: [
          ZplText("Carrier: UPS", font: ZplFont.helvetica(size: 35)),
          ZplPadding(
            padding: const ZplEdgeInsets.only(top: 10),
            child: ZplBarcode(
              "1Z9999999999999999",
              type: ZplBarcodeType.code128,
            ),
          ),
        ],
      ),
    );

    // Should include start and end tags
    expect(zpl.contains('^XA'), isTrue);
    expect(zpl.contains('^XZ'), isTrue);

    // Should contain the text field data
    expect(zpl.contains('^FDCarrier: UPS^FS'), isTrue);

    // Should contain the barcode field data
    expect(zpl.contains('^FD1Z9999999999999999^FS'), isTrue);

    // Expected coordinate calculations:
    // ZplColumn sets root at 0,0
    // ZplText is at 0,0
    // ZplText height with size 35 is 35.
    // ZplPadding has top padding 10. Offset Y should be 35 + 10 = 45.
    // ZplBarcode should be at Y=45. Let's check:
    expect(
      zpl.contains('^FO0,45'),
      isTrue,
      reason: 'Barcode should be shifted down by text height + padding',
    );
  });
}
