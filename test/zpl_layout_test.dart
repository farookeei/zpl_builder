import 'package:flutter_test/flutter_test.dart';
import 'package:zpl_kit/zpl_kit.dart';

void main() {
  group('Advanced Layout Primitives (v0.0.3)', () {
    test('ZplExpanded divides space 50/50 in a Row', () {
      final labelSize = ZplLabelSize(800, 100);

      final label = ZplRow(
        children: [
          ZplExpanded(
            flex: 1,
            child: ZplText('Left Column'),
          ),
          ZplExpanded(
            flex: 1,
            child: ZplText('Right Column'),
          ),
        ],
      );

      final zpl = ZplKit.build(label, labelSize: labelSize);

      // Verify the first column is at 0,0
      expect(zpl.contains('^FO0,0'), isTrue);

      // Verify the second column starts exactly at 400 (half of 800)
      expect(zpl.contains('^FO400,0'), isTrue);
    });

    test('ZplCenter calculates middle coordinate', () {
      // Label width is 800. A barcode of width ~200 should be centered.
      // 800 / 2 = 400. 200 / 2 = 100. Base FO should be (400 - 100) = 300.
      final labelSize = ZplLabelSize(800, 200);

      final label = ZplCenter(
        child: ZplGraphicBox(width: 200, height: 50),
      );

      final zpl = ZplKit.build(label, labelSize: labelSize);

      // (800 - 200) / 2 = 300
      // (200 - 50) / 2 = 75
      expect(zpl.contains('^FO300,75'), isTrue);
    });

    test('ZplText generates ^FB when constrained', () {
      final labelSize = ZplLabelSize(500, 100);

      final label = ZplText(
        'Long Text Wrapping',
        textAlign: ZplTextAlign.center,
      );

      final zpl = ZplKit.build(label, labelSize: labelSize);

      // Should contain Field Block command with width 500 and 'C' alignment
      expect(zpl.contains('^FB500,1,0,C,0'), isTrue);
    });
  });
}
