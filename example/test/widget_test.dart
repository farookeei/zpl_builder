import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart';

void main() {
  testWidgets('ZPL Builder Example smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is present.
    expect(find.text('ZPL Kit Example'), findsAtLeast(1));

    // Verify that the 'Refresh' button exists.
    expect(find.text('Refresh'), findsOneWidget);

    // Verify that some ZPL code is generated (starts with ^XA).
    // The ZPL code view has selectable text starting with the built ZPL.
    expect(find.textContaining('^XA'), findsAtLeast(1));
  });
}
