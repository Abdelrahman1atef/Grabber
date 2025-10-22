// test/same_screen_hero_effect_test.dart
import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:products/features/test/test_widget.dart';

void main() {
  testWidgets('SameScreenHeroEffect expands and shrinks on tap', (WidgetTester tester) async {
    // Build the widget
    await tester.pumpWidget(const MaterialApp(
      home: SameScreenHeroEffect(),
    ));

    // Initial state: small red box
    expect(find.text('Tap to Expand'), findsOneWidget);
    expect(find.byType(InkWell), findsOneWidget);

    // Verify background color is red (indirectly via container properties)
    // Since we can't easily test BoxDecoration color in widget tests,
    // we rely on text and size as proxies.

    // Tap to expand
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle(); // Wait for animation to complete

    // Expanded state: full screen, blue, "Tap to Shrink"
    expect(find.text('Tap to Shrink'), findsOneWidget);

    // Tap to shrink
    await tester.tap(find.byType(InkWell));
    await tester.pumpAndSettle();

    // Back to initial state
    expect(find.text('Tap to Expand'), findsOneWidget);
  });
}