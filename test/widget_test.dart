import 'package:flutter_test/flutter_test.dart';
import 'package:smart_greenhouse/main.dart';

void main() {
  testWidgets('App starts', (tester) async {
    await tester.pumpWidget(const SmartGreenhouseApp());
    expect(find.text('Smart Greenhouse'), findsOneWidget);
  });
}
