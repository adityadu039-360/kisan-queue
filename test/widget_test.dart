import 'package:flutter_test/flutter_test.dart';

import 'package:kisan_queue/main.dart';

void main() {
  testWidgets(
    'Kisan Queue app starts successfully',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        const KisanQueueApp(),
      );

      await tester.pump();

      expect(
        find.text('Kisan Queue'),
        findsOneWidget,
      );

      expect(
        find.text('Farmer Login'),
        findsOneWidget,
      );
    },
  );
}