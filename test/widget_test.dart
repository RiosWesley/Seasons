import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/main.dart';

void main() {
  testWidgets('App root smoke test renders Seasons brand', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('seasons'), findsOneWidget);
  });
}
