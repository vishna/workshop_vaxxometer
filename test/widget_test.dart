// This is a basic Flutter widget test.
//
// To perform an interaction with a widget in your test, use the WidgetTester
// utility that Flutter provides. For example, you can send tap and scroll
// gestures. You can also use WidgetTester to find child widgets in the widget
// tree, read text, and verify that the values of widget properties are correct.

import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';

import 'package:vaxxometer/main.dart';

const mock_data_berlin =
    """{"total": 3644826, "rs": "11", "vaccinated": 24159, "difference_to_the_previous_day": 2204, "vaccinations_per_1000_inhabitants": 6.583746901136969, "quote": 0.66}""";

void main() {
  // don't need this now
  // testWidgets('Counter increments smoke test', (WidgetTester tester) async {
  //   // Build our app and trigger a frame.
  //   await tester.pumpWidget(MyApp());

  //   // Verify that our counter starts at 0.
  //   expect(find.text('0'), findsOneWidget);
  //   expect(find.text('1'), findsNothing);

  //   // Tap the '+' icon and trigger a frame.
  //   await tester.tap(find.byIcon(Icons.add));
  //   await tester.pump();

  //   // Verify that our counter has incremented.
  //   expect(find.text('0'), findsNothing);
  //   expect(find.text('1'), findsOneWidget);
  // });

  test('json parsing Berlin', () {
    final mock_data_berlin_decoded = jsonDecode(mock_data_berlin);
    final berlinStatus = VaccineStatus.fromJson(mock_data_berlin_decoded);
    expect(berlinStatus.total, 3644826);
    expect(berlinStatus.vaccinated, 24159);
    expect(berlinStatus.quote, 0.66);
  });
}
