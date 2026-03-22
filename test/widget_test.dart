// File: test/widget_test.dart

import 'package:flutter_test/flutter_test.dart';
import 'package:lexicon/main.dart';

void main() {
  testWidgets('App boots smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(const LexiconApp());

    // Verify that the app loads the main menu by looking for the title
    expect(find.text('LEXICON'), findsOneWidget);
  });
}