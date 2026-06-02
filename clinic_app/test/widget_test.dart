import 'package:flutter_test/flutter_test.dart';

import 'package:clinic_app/main.dart';
import 'package:clinic_app/screens/auth_screen.dart';

void main() {
  testWidgets('app shows authentication screen when no session exists', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const MyApp());
    await tester.pumpAndSettle();

    expect(find.byType(AuthScreen), findsOneWidget);
  });
}
