import 'package:flutter_test/flutter_test.dart';
import 'package:learning/main.dart';

void main() {
  testWidgets('Flutter academy home smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterLearningLabApp());

    expect(find.text('أكاديمية Flutter الاحترافية'), findsOneWidget);
    expect(find.text('لوحة التعلم'), findsOneWidget);
  });
}
