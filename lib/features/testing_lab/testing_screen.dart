import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';
import '../quiz/lab_quiz_action.dart';
import 'models/test_case_model.dart';

/// مختبر اختبارات الوحدة والويدجت والـ Bloc (Unit & Widget Testing Lab)
class TestingScreen extends StatefulWidget {
  const TestingScreen({super.key});

  @override
  State<TestingScreen> createState() => _TestingScreenState();
}

class _TestingScreenState extends State<TestingScreen> {
  TestCategory _selectedCategory = TestCategory.unit;
  int _selectedCaseIndex = 0;
  TestStatus _currentStatus = TestStatus.idle;
  int _executionDurationMs = 0;
  int _activeAssertionStep = 0;

  final List<TestCaseItem> _testCases = [
    // 1. Unit Testing
    const TestCaseItem(
      id: 'unit_pure_logic',
      category: TestCategory.unit,
      titleAr: '1. اختبار منطق نموذج البيانات وحسابات الحالة (Unit Test)',
      titleEn: '1. Pure Business Logic & Model Unit Test',
      descAr:
          'اختبار دوال Dart الخالصة ونماذج البيانات دون الحاجة لتشغيل Flutter UI أو إطارات الرسم.',
      descEn:
          'Test pure Dart domain logic, models, and calculation functions without widget overhead.',
      targetComponent: 'ComparisonState.copyWith()',
      codeSnippet: '''import 'package:flutter_test/flutter_test.dart';
import 'package:learning/features/state_comparison_lab/cubit/comparison_state.dart';

void main() {
  group('ComparisonState Unit Tests', () {
    test('initial state should have zero counter and Idle status', () {
      // 1. Arrange & Act
      const state = ComparisonState();

      // 2. Assert
      expect(state.counter, equals(0));
      expect(state.status, equals('Idle'));
      expect(state.activeColorHex, equals('14B8A6'));
    });

    test('copyWith should only update specified properties and keep others intact', () {
      // 1. Arrange
      const state = ComparisonState(counter: 5, status: 'Idle');

      // 2. Act
      final updated = state.copyWith(counter: 6);

      // 3. Assert
      expect(updated.counter, equals(6));
      expect(updated.status, equals('Idle')); // لم يتغير
    });
  });
}''',
      stepsAr: [
        'Arrange: إنشاء كائن الحالة الابتدائية ComparisonState()',
        'Act: استدعاء دالة copyWith(counter: 6)',
        'Assert: التأكد من أن العداد أصبح 6 والحالة بقيت Idle دون تغيير',
      ],
      stepsEn: [
        'Arrange: Instantiate initial ComparisonState()',
        'Act: Call copyWith(counter: 6)',
        'Assert: Verify counter is 6 while status remained intact',
      ],
      assertions: [
        TestAssertion(
          title: 'Initial Counter Value',
          expected: '0',
          actual: '0',
          isPassed: true,
        ),
        TestAssertion(
          title: 'copyWith(counter: 6)',
          expected: '6',
          actual: '6',
          isPassed: true,
        ),
        TestAssertion(
          title: 'State Immutability & Equatable Equality',
          expected: 'identical status',
          actual: 'identical status',
          isPassed: true,
        ),
      ],
    ),

    // 2. Bloc / Cubit Testing
    const TestCaseItem(
      id: 'bloc_cubit_test',
      category: TestCategory.bloc,
      titleAr: '2. اختبار تدفق الحالات مع bloc_test (Cubit Stream)',
      titleEn: '2. State Emission Pipeline with bloc_test',
      descAr:
          'اختبار تسلسل الحالات التي يصدرها الـ Cubit والتأكد من انبعاثها بالترتيب الدقيق عند استدعاء الدوال.',
      descEn:
          'Test state stream emission sequence and emissions order using the official bloc_test package.',
      targetComponent: 'ComparisonCubit',
      codeSnippet: '''import 'package:bloc_test/bloc_test.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning/features/state_comparison_lab/cubit/comparison_cubit.dart';
import 'package:learning/features/state_comparison_lab/cubit/comparison_state.dart';

void main() {
  group('ComparisonCubit bloc_test', () {
    late ComparisonCubit cubit;

    setUp(() {
      cubit = ComparisonCubit();
    });

    tearDown(() {
      cubit.close();
    });

    blocTest<ComparisonCubit, ComparisonState>(
      'emits updated counter when incrementCounter is called',
      build: () => cubit,
      act: (cubit) => cubit.incrementCounter(),
      expect: () => [
        isA<ComparisonState>().having((s) => s.counter, 'counter', 1),
      ],
    );

    blocTest<ComparisonCubit, ComparisonState>(
      'emits correct status string when updateStatus is called',
      build: () => cubit,
      act: (cubit) => cubit.updateStatus('Synced'),
      expect: () => [
        isA<ComparisonState>().having((s) => s.status, 'status', 'Synced'),
      ],
    );
  });
}''',
      stepsAr: [
        'build: تجهيز نسخة جديدة من الـ Cubit',
        'act: تنفيذ دالة cubit.incrementCounter()',
        'expect: التأكد من انبعاث حالة جديدة counter == 1 فوراً',
      ],
      stepsEn: [
        'build: Instantiate fresh ComparisonCubit instance',
        'act: Trigger cubit.incrementCounter()',
        'expect: Assert single state emitted with counter == 1',
      ],
      assertions: [
        TestAssertion(
          title: 'build() lifecycle hook',
          expected: 'ComparisonCubit instance',
          actual: 'ComparisonCubit instance',
          isPassed: true,
        ),
        TestAssertion(
          title: 'act: incrementCounter()',
          expected: 'emits [ComparisonState(counter: 1)]',
          actual: 'emits [ComparisonState(counter: 1)]',
          isPassed: true,
        ),
        TestAssertion(
          title: 'act: updateStatus("Synced")',
          expected: 'emits [ComparisonState(status: "Synced")]',
          actual: 'emits [ComparisonState(status: "Synced")]',
          isPassed: true,
        ),
      ],
    ),

    // 3. Mocktail Mocking
    const TestCaseItem(
      id: 'mocktail_repository',
      category: TestCategory.mocking,
      titleAr: '3. محاكاة السيرفر واستجابات الشبكة (Mocktail Mocking)',
      titleEn: '3. Mocking Dependencies & Repositories with Mocktail',
      descAr:
          'محاكاة الـ API والـ Repository لاختبار الحالات الإيجابية والسلبية (Error Scenarios) دون اتصال حقيقي بالسيرفر.',
      descEn:
          'Mock network calls and repositories to test success and failure branches safely without live backend.',
      targetComponent: 'UserRepository & UserCubit',
      codeSnippet: '''import 'package:mocktail/mocktail.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning/core/errors/failures.dart';
import 'package:learning/features/error_handling_lab/domain/repositories/user_repository.dart';
import 'package:learning/features/error_handling_lab/presentation/cubit/user_cubit.dart';

class MockUserRepository extends Mock implements UserRepository {}

void main() {
  late MockUserRepository mockRepo;
  late UserCubit userCubit;

  setUp(() {
    mockRepo = MockUserRepository();
    userCubit = UserCubit(repository: mockRepo);
  });

  test('emits UserError when repository returns ServerFailure', () async {
    // 1. Arrange: تجهيز الرد الوهمي
    when(() => mockRepo.getUserProfile(scenario: any(named: 'scenario')))
        .thenAnswer((_) async => const Left(ServerFailure('Server Error 500')));

    // 2. Act
    await userCubit.fetchUser(MockScenario.serverError);

    // 3. Assert & Verify
    expect(userCubit.state, isA<UserError>());
    verify(() => mockRepo.getUserProfile(scenario: MockScenario.serverError)).called(1);
  });
}''',
      stepsAr: [
        'Arrange: استخدام when(...) لتحديد رد Repository وهمي (Mock Failure)',
        'Act: استدعاء userCubit.fetchUser(...)',
        'Assert: التأكد من تحول الحالة إلى UserError والتحقق من verify() استدعاء الميثود مرة واحدة فقط',
      ],
      stepsEn: [
        'Arrange: Setup mock repository response with when(...)',
        'Act: Trigger userCubit.fetchUser(...)',
        'Assert: Verify UserError emitted and repository method called exactly once',
      ],
      assertions: [
        TestAssertion(
          title: 'when(() => mock.getUserProfile()).thenAnswer()',
          expected: 'Left(ServerFailure)',
          actual: 'Left(ServerFailure)',
          isPassed: true,
        ),
        TestAssertion(
          title: 'Cubit State Transition',
          expected: 'UserError(failure.message == "Server Error 500")',
          actual: 'UserError(failure.message == "Server Error 500")',
          isPassed: true,
        ),
        TestAssertion(
          title: 'verify(...).called(1)',
          expected: 'Invoked exactly 1 time',
          actual: 'Invoked exactly 1 time',
          isPassed: true,
        ),
      ],
    ),

    // 4. Widget Testing
    const TestCaseItem(
      id: 'widget_interaction_test',
      category: TestCategory.widget,
      titleAr: '4. اختبار تفاعل الأزرار ورسم الشاشة (Widget Tester)',
      titleEn: '4. UI Interaction & Render Tree (WidgetTester)',
      descAr:
          'اختبار الضغط على الأزرار وكتابة النصوص والتأكد من ظهور العناصر الصحيحة في شجرة الواجهة باستخدام WidgetTester.',
      descEn:
          'Test user taps, typing, pump frames, and element tree verification using Flutter WidgetTester.',
      targetComponent: 'HomeScreen & FloatingActionButton',
      codeSnippet: '''import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:learning/main.dart';
import 'package:shared_preferences/shared_preferences.dart';

void main() {
  setUp(() {
    SharedPreferences.setMockInitialValues({});
  });

  testWidgets('verify lab list loads and AI Copilot button exists', (WidgetTester tester) async {
    // 1. Arrange & Pump Widget
    await tester.pumpWidget(const FlutterLearningLabApp());
    await tester.pumpAndSettle(); // ينتظر انتهاء كافة الأنيميشن والفيوتشرز

    // 2. Assert Header UI
    expect(find.text('أكاديمية ومختبرات Flutter'), findsOneWidget);
    expect(find.byIcon(Icons.psychology_rounded), findsWidgets);

    // 3. Act: الضغط على زر التبديل
    await tester.tap(find.text('English'));
    await tester.pumpAndSettle();

    // 4. Assert Localization Change
    expect(find.text('Flutter Master Academy'), findsOneWidget);
  });
}''',
      stepsAr: [
        'pumpWidget: رسم تطبيق Flutter بالكامل في بيئة الاختبار الوهمية',
        'pumpAndSettle: انتظار استقرار الرسوم المتحركة وعمليات الـ Async',
        'find & expect: التحقق من وجود نصوص وأيقونات الشاشة، ثم محاكاة الضغط tester.tap()',
      ],
      stepsEn: [
        'pumpWidget: Render complete widget hierarchy in headless test environment',
        'pumpAndSettle: Wait for all animation frames and futures to resolve',
        'find & expect: Locate widgets by text or icon, simulate tap interactions',
      ],
      assertions: [
        TestAssertion(
          title: 'find.text("أكاديمية ومختبرات Flutter")',
          expected: 'findsOneWidget',
          actual: 'findsOneWidget',
          isPassed: true,
        ),
        TestAssertion(
          title: 'tester.tap(find.text("English"))',
          expected: 'Toggled Locale to EN',
          actual: 'Toggled Locale to EN',
          isPassed: true,
        ),
        TestAssertion(
          title: 'find.text("Flutter Master Academy")',
          expected: 'findsOneWidget on re-render',
          actual: 'findsOneWidget on re-render',
          isPassed: true,
        ),
      ],
    ),
  ];

  Future<void> _runSelectedTest() async {
    if (_currentStatus == TestStatus.running) return;

    setState(() {
      _currentStatus = TestStatus.running;
      _activeAssertionStep = 0;
      _executionDurationMs = 0;
    });

    final stopwatch = Stopwatch()..start();

    for (int i = 0; i < 3; i++) {
      await Future.delayed(const Duration(milliseconds: 250));
      if (!mounted) return;
      setState(() {
        _activeAssertionStep = i + 1;
      });
    }

    stopwatch.stop();

    if (mounted) {
      setState(() {
        _currentStatus = TestStatus.passed;
        _executionDurationMs = stopwatch.elapsedMilliseconds + 12;
      });
    }
  }

  void _openAiCopilot(BuildContext context, bool isArabic) {
    final activeCase = _testCases[_selectedCaseIndex];
    ContextualAiSheet.show(
      context,
      topicTitle: isArabic
          ? 'مختبر اختبارات البرمجيات (Unit & Widget Testing)'
          : 'Unit, Widget & Bloc Testing Lab',
      topicCode: activeCase.codeSnippet,
      levelTitle: isArabic
          ? 'اختبارات الوحدة، Bloc Test، Mocktail، و CI/CD'
          : 'Unit Tests, bloc_test, Mocktail, and CI/CD Quality Assurance',
      isArabic: isArabic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final isArabic = locale.isArabic;
    final activeCase = _testCases[_selectedCaseIndex];

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isArabic
                ? 'مختبر اختبارات الوحدة والواجهة'
                : 'Unit & Widget Testing Lab',
          ),
          actions: [
            const LabQuizAction(labId: 'testing'),
            IconButton(
              tooltip: isArabic ? 'اسأل المساعد الذكي' : 'Ask AI Copilot',
              icon: const Icon(Icons.psychology_rounded,
                  color: Color(0xFF14B8A6)),
              onPressed: () => _openAiCopilot(context, isArabic),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openAiCopilot(context, isArabic),
          icon: const Icon(Icons.psychology_rounded, color: Color(0xFF04111C)),
          label: Text(
            isArabic
                ? 'اسأل الذكاء الاصطناعي لتوليد Unit Test'
                : 'Ask AI To Generate Unit Tests',
            style: const TextStyle(
                color: Color(0xFF04111C), fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF14B8A6),
        ),
        body: ResponsiveContentWrapper(
          maxWidth: 1200,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 90),
            children: [
              // 1. بنر المقدمة وهرم الاختبارات
              _buildIntroBanner(isArabic),
              14.heightBox,

              // 2. شريط اختيار فئة الاختبار
              _buildCategoryTabs(isArabic),
              14.heightBox,

              // 3. شاشة تشغيل الاختبار الحية (Test Runner Visualizer)
              _buildLiveTestRunner(activeCase, isArabic),
              16.heightBox,

              // 4. استعراض الكود المصدري للاختبار
              _buildCodeInspector(activeCase, isArabic),
              16.heightBox,

              // 5. بطاقة ربط الاختبارات بـ CI/CD (GitHub Actions)
              _buildCiCdIntegrationCard(isArabic),
              24.heightBox,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroBanner(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF10B981).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.fact_check_rounded,
                color: Color(0xFF34D399), size: 26),
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic
                      ? 'هرم الاختبارات وجودة البرمجيات (Testing Pyramid)'
                      : 'Testing Pyramid & Automated Quality Assurance',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white),
                ),
                4.heightBox,
                Text(
                  isArabic
                      ? 'تضمن الاختبارات الأوتوماتيكية عدم كسر أي ميزة سابقة (Regression-free) وتسمح لك برفع التحديثات بثقة تامة. ينقسم الهرم إلى: Unit Tests (70%)، Widget Tests (20%)، و Integration Tests (10%).'
                      : 'Automated tests ensure zero regressions. The testing pyramid consists of fast Unit Tests (70%), Widget Tests (20%), and end-to-end Integration Tests (10%).',
                  style: const TextStyle(
                      fontSize: 12, color: Colors.white70, height: 1.45),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabs(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(6),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildCategoryTabItem(
              title: isArabic ? 'Unit Logic' : 'Unit Logic',
              icon: Icons.functions_rounded,
              index: 0,
              category: TestCategory.unit,
              color: const Color(0xFF38BDF8),
            ),
          ),
          4.widthBox,
          Expanded(
            child: _buildCategoryTabItem(
              title: isArabic ? 'bloc_test' : 'bloc_test',
              icon: Icons.stream_rounded,
              index: 1,
              category: TestCategory.bloc,
              color: const Color(0xFF10B981),
            ),
          ),
          4.widthBox,
          Expanded(
            child: _buildCategoryTabItem(
              title: isArabic ? 'Mocktail' : 'Mocktail',
              icon: Icons.theater_comedy_rounded,
              index: 2,
              category: TestCategory.mocking,
              color: const Color(0xFFF59E0B),
            ),
          ),
          4.widthBox,
          Expanded(
            child: _buildCategoryTabItem(
              title: isArabic ? 'Widget Test' : 'Widget Test',
              icon: Icons.widgets_rounded,
              index: 3,
              category: TestCategory.widget,
              color: const Color(0xFFEC4899),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryTabItem({
    required String title,
    required IconData icon,
    required int index,
    required TestCategory category,
    required Color color,
  }) {
    final isSelected = _selectedCategory == category;
    return InkWell(
      onTap: () {
        setState(() {
          _selectedCategory = category;
          _selectedCaseIndex = index;
          _currentStatus = TestStatus.idle;
          _activeAssertionStep = 0;
        });
      },
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E293B) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: color, width: 1.5) : null,
        ),
        child: Column(
          children: [
            Icon(icon,
                size: 18, color: isSelected ? color : Colors.white54),
            4.heightBox,
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 11,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                color: isSelected ? Colors.white : Colors.white60,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLiveTestRunner(TestCaseItem testCase, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      isArabic ? testCase.titleAr : testCase.titleEn,
                      style: const TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                          color: Colors.white),
                    ),
                    2.heightBox,
                    Text(
                      'Target: ${testCase.targetComponent}',
                      style: const TextStyle(
                          color: Color(0xFF14B8A6), fontSize: 11),
                    ),
                  ],
                ),
              ),
              _buildStatusBadge(isArabic),
            ],
          ),
          12.heightBox,
          Text(
            isArabic ? testCase.descAr : testCase.descEn,
            style: const TextStyle(
                color: Colors.white70, fontSize: 12, height: 1.4),
          ),
          14.heightBox,

          // خطوات Arrange - Act - Assert
          Text(
            isArabic
                ? 'نمط التنظيم المعتمد (Arrange - Act - Assert):'
                : 'AAA Execution Pattern:',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: Color(0xFF94A3B8)),
          ),
          8.heightBox,
          ...List.generate(
            isArabic ? testCase.stepsAr.length : testCase.stepsEn.length,
            (index) {
              final stepText = isArabic
                  ? testCase.stepsAr[index]
                  : testCase.stepsEn[index];
              final isCompleted = _activeAssertionStep > index;
              return Container(
                margin: const EdgeInsets.only(bottom: 6),
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                decoration: BoxDecoration(
                  color: isCompleted
                      ? const Color(0x1A10B981)
                      : const Color(0xFF0F172A),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(
                    color: isCompleted
                        ? const Color(0xFF10B981).withValues(alpha: 0.4)
                        : const Color(0xFF1E293B),
                  ),
                ),
                child: Row(
                  children: [
                    Icon(
                      isCompleted
                          ? Icons.check_circle_rounded
                          : Icons.radio_button_unchecked_rounded,
                      size: 16,
                      color: isCompleted
                          ? const Color(0xFF10B981)
                          : Colors.white38,
                    ),
                    8.widthBox,
                    Expanded(
                      child: Text(
                        stepText,
                        style: TextStyle(
                          fontSize: 11,
                          color: isCompleted ? Colors.white : Colors.white60,
                        ),
                      ),
                    ),
                  ],
                ),
              );
            },
          ),
          12.heightBox,

          // زر تشغيل الاختبار
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    padding: const EdgeInsets.symmetric(vertical: 12),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8)),
                  ),
                  onPressed: _currentStatus == TestStatus.running
                      ? null
                      : _runSelectedTest,
                  icon: _currentStatus == TestStatus.running
                      ? const SizedBox(
                          width: 16,
                          height: 16,
                          child: CircularProgressIndicator(
                              strokeWidth: 2, color: Colors.white),
                        )
                      : const Icon(Icons.play_arrow_rounded,
                          color: Colors.white, size: 20),
                  label: Text(
                    _currentStatus == TestStatus.running
                        ? (isArabic
                            ? 'جاري تشغيل الاختبار...'
                            : 'Running Test Assertions...')
                        : (isArabic
                            ? '▶️ تشغيل الاختبار الآن (Run Test)'
                            : '▶️ Execute Test Suite'),
                    style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ),
              if (_executionDurationMs > 0) ...[
                10.widthBox,
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF1E293B),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Text(
                    '⚡ ${_executionDurationMs}ms',
                    style: const TextStyle(
                        color: Color(0xFF38BDF8),
                        fontWeight: FontWeight.bold,
                        fontSize: 12),
                  ),
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildStatusBadge(bool isArabic) {
    Color bg;
    Color border;
    Color text;
    String label;

    switch (_currentStatus) {
      case TestStatus.idle:
        bg = const Color(0x3364748B);
        border = const Color(0xFF64748B);
        text = const Color(0xFFCBD5E1);
        label = isArabic ? 'في الانتظار' : 'Idle';
        break;
      case TestStatus.running:
        bg = const Color(0x330284C7);
        border = const Color(0xFF0284C7);
        text = const Color(0xFF7DD3FC);
        label = isArabic ? 'قيد التنفيذ...' : 'Running...';
        break;
      case TestStatus.passed:
        bg = const Color(0x3310B981);
        border = const Color(0xFF10B981);
        text = const Color(0xFF6EE7B7);
        label = isArabic ? 'ناجح 100% ✅' : 'Passed 100% ✅';
        break;
      case TestStatus.failed:
        bg = const Color(0x33EF4444);
        border = const Color(0xFFEF4444);
        text = const Color(0xFFFCA5A5);
        label = isArabic ? 'فشل الاختبار ❌' : 'Failed ❌';
        break;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(6),
        border: Border.all(color: border),
      ),
      child: Text(
        label,
        style: TextStyle(
            color: text, fontWeight: FontWeight.bold, fontSize: 11),
      ),
    );
  }

  Widget _buildCodeInspector(TestCaseItem testCase, bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic
                    ? '💻 كود الاختبار الفعلي (Test Source File):'
                    : '💻 Test Implementation Source:',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white),
              ),
              const Text(
                'test/..._test.dart',
                style: TextStyle(
                    color: Color(0xFF14B8A6),
                    fontWeight: FontWeight.bold,
                    fontSize: 11),
              ),
            ],
          ),
          10.heightBox,
          CopyableCodeBlock(
            code: testCase.codeSnippet,
          ),
        ],
      ),
    );
  }

  Widget _buildCiCdIntegrationCard(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
            color: const Color(0xFF6366F1).withValues(alpha: 0.4)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF6366F1).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(Icons.rocket_launch_rounded,
                    color: Color(0xFF818CF8), size: 22),
              ),
              10.widthBox,
              Expanded(
                child: Text(
                  isArabic
                      ? 'الربط مع GitHub Actions و CI/CD'
                      : 'GitHub Actions & CI/CD Integration',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                      color: Colors.white),
                ),
              ),
            ],
          ),
          8.heightBox,
          Text(
            isArabic
                ? 'يتم تشغيل أمر `flutter test --coverage` أوتوماتيكياً مع كل Pull Request أو Push على GitHub لمنع دمج أي كود يكسر الاختبارات.'
                : 'Automated CI/CD runs `flutter test --coverage` on every PR & push to reject broken code before reaching production.',
            style: const TextStyle(
                color: Colors.white70, fontSize: 12, height: 1.4),
          ),
          10.heightBox,
          CopyableCodeBlock(
            code: '''# .github/workflows/test.yml
name: Flutter Automated Testing
on: [push, pull_request]

jobs:
  test:
    runs-on: ubuntu-latest
    steps:
      - uses: actions/checkout@v4
      - uses: subosito/flutter-action@v2
        with:
          channel: 'stable'
      - name: Install dependencies
        run: flutter pub get
      - name: Run Static Analysis
        run: flutter analyze
      - name: Run Unit & Widget Tests with Coverage
        run: flutter test --coverage''',
          ),
        ],
      ),
    );
  }
}
