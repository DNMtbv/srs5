import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'package:srsp5/main.dart';

void main() {
  testWidgets('Registration form renders', (WidgetTester tester) async {
    SharedPreferences.setMockInitialValues({});
    await tester.pumpWidget(const MyApp());
    expect(find.text('Register Form'), findsOneWidget);
    await tester.scrollUntilVisible(
      find.text('Submit Form'),
      200,
      scrollable: find.byType(Scrollable).first,
    );
    expect(find.text('Submit Form'), findsOneWidget);
  });
}
