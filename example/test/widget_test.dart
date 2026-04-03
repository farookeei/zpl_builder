import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import '../lib/main.dart';

void main() {
  testWidgets('ZPL Builder Example smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const MyApp());

    // Verify that the app title is present.
    expect(find.text('ZPL Builder Example'), findsAtLeast(1));

    // Verify that the 'Regenerate ZPL' button exists.
    expect(find.text('Regenerate ZPL'), findsOneWidget);

    // Verify that some ZPL code is generated (starts with ^XA).
    expect(find.textContaining('^XA'), findsOneWidget);
  });
}
