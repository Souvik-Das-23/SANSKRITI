// test/widget_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:sanskriti/main.dart'; // Make sure ye import ho

void main() {
  testWidgets('Counter increments smoke test', (WidgetTester tester) async {
    // Yahan par MyApp() ki jagah SanskritiApp() likhna hai
    await tester.pumpWidget(const SanskritiApp());

    // Baki test code waise hi rehne dein
    expect(find.text('0'), findsOneWidget);
    expect(find.text('1'), findsNothing);

    await tester.tap(find.byIcon(Icons.add));
    await tester.pump();

    expect(find.text('0'), findsNothing);
    expect(find.text('1'), findsOneWidget);
  });
}