import 'package:flutter_test/flutter_test.dart';
import 'package:lilac_machine_test/main.dart';

void main() {
  testWidgets('Expenzia app starts successfully', (WidgetTester tester) async {
    await tester.pumpWidget(const ExpenziaApp());

    // Verify the splash screen is displayed.
    expect(find.text('Expenzia'), findsOneWidget);

    // Advance the fake clock so the splash timer completes.
    await tester.pump(const Duration(seconds: 2));

    // Render the navigation to the next screen.
    await tester.pumpAndSettle();

    // Verify the app continues running after the splash screen.
    expect(tester.takeException(), isNull);
  });
}
