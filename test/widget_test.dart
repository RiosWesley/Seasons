import 'package:flutter_test/flutter_test.dart';
import 'package:chat_wrapped/main.dart';

void main() {
  testWidgets('App root smoke test renders CHAT WRAPPED', (WidgetTester tester) async {
    await tester.pumpWidget(const MyApp());
    expect(find.text('CHAT WRAPPED'), findsOneWidget);
    expect(find.text('100% Offline'), findsOneWidget);
  });
}
