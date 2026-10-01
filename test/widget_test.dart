import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning/core/localization/app_localizations.dart';
import 'package:learning/core/services/lab_progress_service.dart';
import 'package:learning/core/widgets/copyable_code_block.dart';
import 'package:learning/features/quiz/lab_quiz_data.dart';
import 'package:learning/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('Flutter reference home smoke test', (WidgetTester tester) async {
    await tester.pumpWidget(const FlutterLearningLabApp());
    await tester.pumpAndSettle();

    expect(find.text('أكاديمية ومختبرات Flutter'), findsOneWidget);
    expect(find.text('أكملت 0 من 21 مختبر'), findsOneWidget);
  });

  testWidgets('lab code opens the interactive editor with its snippet', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      AppLocaleScope(
        locale: const Locale('ar', 'EG'),
        onToggleLanguage: () {},
        child: MaterialApp(
          home: const Scaffold(
            body: CopyableCodeBlock(code: 'final answer = 42;'),
          ),
        ),
      ),
    );

    await tester.tap(find.text('جرب بنفسك'));
    await tester.pumpAndSettle();

    expect(find.text('محرر التجربة'), findsOneWidget);
    final editor = tester.widget<TextField>(find.byType(TextField));
    expect(editor.controller?.text, 'final answer = 42;');
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

  testWidgets('lab details open their interactive quiz', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(const FlutterLearningLabApp());
    await tester.pumpAndSettle();

    expect(find.byKey(const ValueKey('quiz-isolates')), findsNothing);

    await tester.tap(find.text('1. العمليات في الخلفية (Isolates)'));
    await tester.pump();
    await tester.pump(const Duration(milliseconds: 500));

    expect(
      find.byKey(const ValueKey('lab-quiz-action-isolates')),
      findsOneWidget,
    );
    await tester.tap(find.byKey(const ValueKey('lab-quiz-action-isolates')));
    await tester.pumpAndSettle();

    expect(
      find.text('ما الفائدة الأساسية من Isolate.run() في تطبيق Flutter؟'),
      findsOneWidget,
    );

    await tester.tap(find.byKey(const ValueKey('quiz-option-0')));
    await tester.pump();
    await tester.tap(find.byKey(const ValueKey('check-quiz-answer')));
    await tester.pumpAndSettle();

    expect(find.text('إجابة صحيحة'), findsOneWidget);

    final answerButton = find.byKey(const ValueKey('check-quiz-answer'));
    await tester.ensureVisible(answerButton);
    await tester.pumpAndSettle();
    await tester.tap(answerButton);
    await tester.pumpAndSettle();
    await tester.ensureVisible(find.byKey(const ValueKey('quiz-option-0')));
    await tester.pumpAndSettle();
    await tester.tap(find.byKey(const ValueKey('quiz-option-0')));
    await tester.pump();
    await tester.ensureVisible(answerButton);
    await tester.pumpAndSettle();
    await tester.tap(answerButton);
    await tester.pumpAndSettle();
    await tester.ensureVisible(answerButton);
    await tester.pumpAndSettle();
    await tester.tap(answerButton);
    await tester.pumpAndSettle();

    expect(find.text('نتيجتك 1 من 2 (50٪)'), findsOneWidget);
  });

  test('every lab has two valid quiz questions', () {
    expect(
      labQuizzes.keys,
      unorderedEquals([
        'isolates',
        'repaint-boundary',
        'animations',
        'memory-performance',
        'slivers',
        'physics-painter',
        'debouncer',
        'streams-rx',
        'error-handling',
        'offline-sync',
        'local-database',
        'dart3',
        'state-inherited',
        'state-comparison',
        'clean-architecture',
        'platform-channels',
        'keys',
        'security',
        'deployment',
        'testing',
        'extensions',
      ]),
    );
    expect(labQuizTitles.keys, unorderedEquals(labQuizzes.keys));
    for (final questions in labQuizzes.values) {
      expect(questions, hasLength(2));
      for (final question in questions) {
        expect(question.options, hasLength(4));
        expect(question.correctIndex, inInclusiveRange(0, 3));
      }
    }
  });

  test('opening a lab marks it complete and retains progress', () async {
    final service = LabProgressService();

    await service.markOpened('isolates');

    final progress = await service.load();
    expect(progress.isOpened('isolates'), isTrue);
    expect(progress.isCompleted('isolates'), isTrue);
  });
}
