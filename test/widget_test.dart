import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning/main.dart';
import 'package:learning/core/services/lab_progress_service.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Flutter reference home smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterLearningLabApp());
    await tester.pumpAndSettle();

    expect(find.text('أكاديمية ومختبرات Flutter'), findsOneWidget);
    expect(find.text('أكملت 0 من 18 مختبر'), findsOneWidget);
  });

  testWidgets('opening a lab completes it automatically', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FlutterLearningLabApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('complete-isolates')), findsNothing);

    await tester.tap(find.text('1. العمليات في الخلفية (Isolates)'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    final progress = await LabProgressService().load();
    expect(progress.isCompleted('isolates'), isTrue);
  });

  test('opening a lab marks it complete and retains progress', () async {
    final service = LabProgressService();

    await service.markOpened('isolates');

    final progress = await service.load();
    expect(progress.isOpened('isolates'), isTrue);
    expect(progress.isCompleted('isolates'), isTrue);
  });
}
