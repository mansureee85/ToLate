import 'package:flutter_test/flutter_test.dart';
import 'package:tolate/app/app.dart';

void main() {
  testWidgets('ToLateApp smoke and launch test', (WidgetTester tester) async {
    await tester.pumpWidget(const ToLateApp());
    await tester.pump();
    expect(find.byType(ToLateApp), findsOneWidget);
  });
}
