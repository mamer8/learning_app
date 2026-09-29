import 'package:flutter_test/flutter_test.dart';
import 'package:learning/main.dart';

void main() {
  testWidgets('Flutter reference home smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterLearningLabApp());

    expect(find.text('مرجع Flutter'), findsOneWidget);
    expect(find.text('افتح المنهج الكامل'), findsOneWidget);
  });
}
