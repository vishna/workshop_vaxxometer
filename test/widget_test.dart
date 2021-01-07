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

const full_json =
    """{"lastUpdate": "2021-01-06T00:00:00", "states": {"Baden-W\u00fcrttemberg": {"total": 11069533, "rs": "08", "vaccinated": 42899, "difference_to_the_previous_day": 4971, "vaccinations_per_1000_inhabitants": 3.864637597548339, "quote": 0.39}, "Bayern": {"total": 13076721, "rs": "09", "vaccinated": 84349, "difference_to_the_previous_day": 1600, "vaccinations_per_1000_inhabitants": 6.426719255402984, "quote": 0.65}, "Berlin": {"total": 3644826, "rs": "11", "vaccinated": 24159, "difference_to_the_previous_day": 2204, "vaccinations_per_1000_inhabitants": 6.583746901136969, "quote": 0.66}, "Brandenburg": {"total": 2511917, "rs": "12", "vaccinated": 8182, "difference_to_the_previous_day": 2778, "vaccinations_per_1000_inhabitants": 3.2443882432759836, "quote": 0.33}, "Bremen": {"total": 682986, "rs": "04", "vaccinated": 3825, "difference_to_the_previous_day": 630, "vaccinations_per_1000_inhabitants": 5.615074530021932, "quote": 0.56}, "Hamburg": {"total": 1841179, "rs": "02", "vaccinated": 7079, "difference_to_the_previous_day": 1178, "vaccinations_per_1000_inhabitants": 3.832176751100147, "quote": 0.38}, "Hessen": {"total": 6265809, "rs": "06", "vaccinated": 44122, "difference_to_the_previous_day": 2824, "vaccinations_per_1000_inhabitants": 7.016768234500833, "quote": 0.7}, "Mecklenburg-Vorpommern": {"total": 1609675, "rs": "13", "vaccinated": 21713, "difference_to_the_previous_day": 2359, "vaccinations_per_1000_inhabitants": 13.501950703235668, "quote": 1.35}, "Niedersachsen": {"total": 7982448, "rs": "03", "vaccinated": 22608, "difference_to_the_previous_day": 7444, "vaccinations_per_1000_inhabitants": 2.8282597795638713, "quote": 0.28}, "Nordrhein-Westfalen": {"total": 17932651, "rs": "05", "vaccinated": 79578, "difference_to_the_previous_day": 8851, "vaccinations_per_1000_inhabitants": 4.43400123060835, "quote": 0.44}, "Rheinland-Pfalz": {"total": 4084844, "rs": "07", "vaccinated": 15984, "difference_to_the_previous_day": 3648, "vaccinations_per_1000_inhabitants": 3.904342628538097, "quote": 0.39}, "Saarland": {"total": 990509, "rs": "10", "vaccinated": 6511, "difference_to_the_previous_day": 878, "vaccinations_per_1000_inhabitants": 6.597513190466588, "quote": 0.66}, "Sachsen": {"total": 4077937, "rs": "14", "vaccinated": 13006, "difference_to_the_previous_day": 2239, "vaccinations_per_1000_inhabitants": 3.194030605817183, "quote": 0.32}, "Sachsen-Anhalt": {"total": 2208321, "rs": "15", "vaccinated": 17624, "difference_to_the_previous_day": 501, "vaccinations_per_1000_inhabitants": 8.029954683426418, "quote": 0.8}, "Schleswig-Holstein": {"total": 2896712, "rs": "01", "vaccinated": 20078, "difference_to_the_previous_day": 3062, "vaccinations_per_1000_inhabitants": 6.914452334944914, "quote": 0.69}, "Th\u00fcringen": {"total": 2143145, "rs": "16", "vaccinated": 5343, "difference_to_the_previous_day": 1165, "vaccinations_per_1000_inhabitants": 2.504478812474864, "quote": 0.25}}, "vaccinated": 417060, "difference_to_the_previous_day": 46332, "vaccinations_per_1000_inhabitants": 46332, "total": 83019213, "quote": 0.5}""";

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

  test('make a list from json', () {
    final states = parseResponse(full_json);
    expect(states.isNotEmpty, true);
  });
}
