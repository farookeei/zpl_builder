import 'package:flutter_test/flutter_test.dart';
import 'package:zpl_kit/zpl_kit.dart';

void main() {
  group('v0.0.3 Internal Layout Validation', () {
    test('Shipping Label matches production logic dimensions', () {
      final zpl = ZplInternalTest.generate();

      // 1. Verify Start/End and Label Dimensions
      expect(zpl.contains('^XA'), isTrue);
      expect(zpl.contains('^PW812'), isTrue);
      expect(zpl.contains('^LL1218'), isTrue);
      expect(zpl.contains('^XZ'), isTrue);

      // 2. Verify Headers (Ship From & To columns) 
      // Calculated: (812-60 margin-30 spacer)/2 = ~361 dots per col
      // The "To:" column should be at X ~ 30+361+30 = 421 or similar
      expect(zpl.contains('^FO30,30^A0N,25,20'), isTrue, reason: 'Ship From: FO');
      // The FB width for the columns is flexible based on space sharing.
      expect(zpl.contains('^FB'), isTrue, reason: 'Should use Field Blocks for all text');

      // 3. Verify Divider spans the label (width is 812 - 30 margin*2 = 752)
      expect(zpl.contains('^GB752,2,2^FS'), isTrue, reason: 'Divider should respect padding');

      // 4. Verify PO section split
      expect(zpl.contains('^FDPO#: PO-88229911^FS'), isTrue);
      expect(zpl.contains('^FDContainer: 1 / 4^FS'), isTrue);

      // 5. Verify Centered Main Barcode
      // 812 dots label, barcode widthRatio 3. (HU9988776655 is 12 chars * modules)
      expect(zpl.contains('^BY3^BCN,200,Y,N,N^FDHU9988776655^FS'), isTrue);
    });
  });
}

class ZplInternalTest {
  static String generate() {
    // Mock Data
    const warehouseName = "MAIN DISTRIBUTION CENTER";
    const warehouseAddr = "123 LOGISTICS WAY, SUITE 500";
    const warehouseCityStateZip = "MEMPHIS, TN, 38101";

    const customerName = "ALICE SMITH";
    const customerAddr1 = "789 RESIDENTIAL BLVD";
    const customerCityStateZip = "NASHVILLE, TN, 37201";

    const orderNumber = "PO-88229911";
    const container = "1 / 4";
    const carrierVal = "FEDEX-GRND";
    const weight = "12.5 KG";
    const barcode = "HU9988776655";

    final root = ZplPadding(
      padding: ZplEdgeInsets.all(30),
      child: ZplColumn(
        children: [
          // ROW 1 & 2: Headers and Addresses using Flexible Columns
          ZplRow(
            children: [
              // LEFT COLUMN: SHIP FROM
              ZplExpanded(
                flex: 1,
                child: ZplColumn(
                  crossAxisAlignment: ZplCrossAxisAlignment.start,
                  children: [
                    ZplText('Ship From:', font: ZplFont.helvetica(size: 25)),
                    ZplText(warehouseName, font: ZplFont.helvetica(size: 30), maxLines: 1),
                    ZplText(warehouseAddr, font: ZplFont.helvetica(size: 30), maxLines: 2),
                    ZplText(warehouseCityStateZip, font: ZplFont.helvetica(size: 30)),
                  ],
                ),
              ),

              ZplSpacer(flex: 1), // Optional spacer for gap

              // RIGHT COLUMN: TO
              ZplExpanded(
                flex: 1,
                child: ZplColumn(
                  crossAxisAlignment: ZplCrossAxisAlignment.start,
                  children: [
                    ZplText('To:', font: ZplFont.helvetica(size: 25)),
                    ZplText(customerName, font: ZplFont.helvetica(size: 30)),
                    ZplText(customerAddr1, font: ZplFont.helvetica(size: 30), maxLines: 2),
                    ZplText(customerCityStateZip, font: ZplFont.helvetica(size: 30)),
                  ],
                ),
              ),
            ],
          ),

          ZplPadding(
            padding: ZplEdgeInsets.only(top: 20),
            child: ZplRow(
              children: [
                  ZplExpanded(
                    child: ZplColumn(
                      crossAxisAlignment: ZplCrossAxisAlignment.start,
                      children: [
                        ZplText('Ship to Postal Code', font: ZplFont.helvetica(size: 25)),
                        ZplPadding(
                          padding: ZplEdgeInsets.only(top: 10),
                          child: ZplBarcode('38101', height: 40, widthRatio: 2),
                        ),
                      ],
                    ),
                  ),
                  ZplExpanded(
                    child: ZplColumn(
                      crossAxisAlignment: ZplCrossAxisAlignment.start,
                      children: [
                        ZplText('Carrier:', font: ZplFont.helvetica(size: 35)),
                        ZplText(carrierVal, font: ZplFont.helvetica(size: 25), textAlign: ZplTextAlign.left),
                      ],
                    ),
                  ),
              ],
            ),
          ),

          // FULL WIDTH DIVIDER
          ZplPadding(
            padding: ZplEdgeInsets.symmetric(vertical: 20),
            child: ZplDivider(thickness: 2),
          ),

          // ROW 4: PO & CONTAINER
          ZplRow(
            children: [
              ZplExpanded(child: ZplText('PO#: $orderNumber', font: ZplFont.helvetica(size: 40))),
              ZplExpanded(child: ZplText('Container: $container', font: ZplFont.helvetica(size: 40), textAlign: ZplTextAlign.right)),
            ],
          ),

          ZplDivider(thickness: 2),

          // ROW 5: WEIGHT (Right Aligned)
          ZplRow(
            children: [
              ZplSpacer(flex: 1),
              ZplText('Weight: $weight', font: ZplFont.helvetica(size: 40)),
            ],
          ),

          ZplSpacer(flex: 1), // Push barcode to the very bottom

          // MAIN BARCODE: Perfectly Centered
          ZplCenter(
            child: ZplBarcode(
              barcode,
              height: 200,
              widthRatio: 3,
              printText: true,
            ),
          ),
        ],
      ),
    );

    // Shipping labels are typically 4x6 (812x1218 dots @ 203dpi)
    return ZplKit.build(root, labelSize: ZplLabelSize(812, 1218));
  }
}

