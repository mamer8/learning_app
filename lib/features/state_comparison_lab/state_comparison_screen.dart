import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';
import '../quiz/lab_quiz_action.dart';
import 'cubit/comparison_cubit.dart';
import 'cubit/comparison_state.dart';

/// الشاشة الرئيسية لمختبر مقارنة وتقويم أساليب إدارة الحالة
/// State Management Comparison & Rebuild Benchmark Lab
class StateComparisonScreen extends StatefulWidget {
  const StateComparisonScreen({super.key});

  @override
  State<StateComparisonScreen> createState() => _StateComparisonScreenState();
}

class _StateComparisonScreenState extends State<StateComparisonScreen> {
  // Mode: 0 -> setState, 1 -> Cubit (BlocSelector), 2 -> ValueNotifier
  int _selectedMode = 0;

  // setState local states
  int _localCounter = 0;
  String _localStatus = 'Idle';
  Color _localColor = const Color(0xFF14B8A6);

  // ValueNotifiers
  final ValueNotifier<int> _vnCounter = ValueNotifier<int>(0);
  final ValueNotifier<String> _vnStatus = ValueNotifier<String>('Idle');
  final ValueNotifier<Color> _vnColor =
      ValueNotifier<Color>(const Color(0xFF14B8A6));

  // Rebuild telemetry counters for setState mode
  int _setStateParentRebuilds = 0;
  int _setStateCounterRebuilds = 0;
  int _setStateStatusRebuilds = 0;
  int _setStateStaticRebuilds = 0;

  // Rebuild telemetry counters for Cubit mode
  int _cubitParentRebuilds = 0;
  int _cubitCounterRebuilds = 0;
  int _cubitStatusRebuilds = 0;
  int _cubitStaticRebuilds = 0;

  // Rebuild telemetry counters for ValueNotifier mode
  int _vnParentRebuilds = 0;
  int _vnCounterRebuilds = 0;
  int _vnStatusRebuilds = 0;
  int _vnStaticRebuilds = 0;

  bool _isStressTesting = false;

  @override
  void dispose() {
    _vnCounter.dispose();
    _vnStatus.dispose();
    _vnColor.dispose();
    super.dispose();
  }

  void _resetMetrics() {
    setState(() {
      _setStateParentRebuilds = 0;
      _setStateCounterRebuilds = 0;
      _setStateStatusRebuilds = 0;
      _setStateStaticRebuilds = 0;

      _cubitParentRebuilds = 0;
      _cubitCounterRebuilds = 0;
      _cubitStatusRebuilds = 0;
      _cubitStaticRebuilds = 0;

      _vnParentRebuilds = 0;
      _vnCounterRebuilds = 0;
      _vnStatusRebuilds = 0;
      _vnStaticRebuilds = 0;

      _localCounter = 0;
      _localStatus = 'Idle';
      _localColor = const Color(0xFF14B8A6);

      _vnCounter.value = 0;
      _vnStatus.value = 'Idle';
      _vnColor.value = const Color(0xFF14B8A6);
    });
  }

  Future<void> _runStressTest(BuildContext context) async {
    if (_isStressTesting) return;
    setState(() => _isStressTesting = true);

    final cubit = context.read<ComparisonCubit>();
    for (int i = 0; i < 15; i++) {
      await Future.delayed(const Duration(milliseconds: 40));
      if (!mounted) break;

      if (_selectedMode == 0) {
        setState(() {
          _localCounter++;
          if (i % 3 == 0) _localStatus = 'Processing #$i';
        });
      } else if (_selectedMode == 1) {
        cubit.incrementCounter();
        if (i % 3 == 0) cubit.updateStatus('Processing #$i');
      } else {
        _vnCounter.value++;
        if (i % 3 == 0) _vnStatus.value = 'Processing #$i';
      }
    }

    if (mounted) {
      setState(() => _isStressTesting = false);
    }
  }

  String _getCodeSnippet(int mode) {
    if (mode == 0) {
      return '''// 1. setState: يعيد بناء الشجرة بالكامل عند أي تغيير
setState(() {
  _counter++; // يسبب إعادة بناء الـ Parent وجميع الـ Child Widgets
});

// UI Widget:
Text('Counter: \$_counter'); // يعاد بناؤه
StaticCard(); // يعاد بناؤه أيضاً رغم عدم اعتماده على الـ Counter!''';
    } else if (mode == 1) {
      return '''// 2. Cubit + BlocSelector: يعيد بناء فقط الويدجت المعتمد على الجزئية المحددة
class CounterCubit extends Cubit<CounterState> {
  CounterCubit() : super(const CounterState());
  void increment() => emit(state.copyWith(counter: state.counter + 1));
}

// UI Widget مع اشتراك دقيق (Fine-grained subscription):
BlocSelector<CounterCubit, CounterState, int>(
  selector: (state) => state.counter,
  builder: (context, counter) {
    // يُعاد بناؤه فقط عندما تتغير قيمة counter دون التأثير على باقي الشاشة!
    return Text('Counter: \$counter');
  },
);''';
    } else {
      return '''// 3. ValueNotifier + ValueListenableBuilder: إدارة خفيفة ومحددة بدون حزم خارجية
final ValueNotifier<int> counterNotifier = ValueNotifier<int>(0);

// تحديث القيمة:
counterNotifier.value++;

// UI Widget:
ValueListenableBuilder<int>(
  valueListenable: counterNotifier,
  builder: (context, value, child) {
    // يُعاد بناء ما بداخل البيلدر فقط!
    return Text('Counter: \$value');
  },
);''';
    }
  }

  void _openAiCopilot(BuildContext context, bool isArabic) {
    ContextualAiSheet.show(
      context,
      topicTitle: isArabic
          ? 'مقارنة أساليب إدارة الحالة في Flutter'
          : 'Flutter State Management Comparison Lab',
      topicCode: _getCodeSnippet(_selectedMode),
      levelTitle: isArabic
          ? 'مقارنة الأداء، عزل الـ Rebuilds، ومعمارية Cubit'
          : 'State Architecture, Rebuild Isolation & Cubit Benchmark',
      isArabic: isArabic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final isArabic = locale.isArabic;

    return BlocProvider(
      create: (_) => ComparisonCubit(),
      child: Builder(
        builder: (screenContext) {
          return Directionality(
            textDirection: locale.textDirection,
            child: Scaffold(
              appBar: AppBar(
                title: Text(
                  isArabic
                      ? 'مختبر مقارنة إدارة الحالة'
                      : 'State Management Comparison',
                ),
                actions: [
                  const LabQuizAction(labId: 'state-comparison'),
                  IconButton(
                    tooltip:
                        isArabic ? 'إعادة ضبط العدادات' : 'Reset Metrics',
                    icon: const Icon(Icons.refresh_rounded),
                    onPressed: _resetMetrics,
                  ),
                  IconButton(
                    tooltip: isArabic ? 'اسأل المساعد الذكي' : 'Ask AI Copilot',
                    icon: const Icon(Icons.psychology_rounded,
                        color: Color(0xFF14B8A6)),
                    onPressed: () => _openAiCopilot(screenContext, isArabic),
                  ),
                ],
              ),
              floatingActionButton: FloatingActionButton.extended(
                onPressed: () => _openAiCopilot(screenContext, isArabic),
                icon: const Icon(Icons.psychology_rounded,
                    color: Color(0xFF04111C)),
                label: Text(
                  isArabic
                      ? 'استشر AI حول أفضل خيار لمشروعك'
                      : 'Ask AI Best Choice For Your App',
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
                    _buildIntroCard(isArabic),
                    14.heightBox,

                    // شريط اختيار أسلوب إدارة الحالة
                    _buildApproachSelector(isArabic),
                    14.heightBox,

                    // لوحة التحكم وتوليد الأحداث
                    _buildControlPanel(screenContext, isArabic),
                    16.heightBox,

                    // لوحة فحص الـ Rebuilds الحية
                    _buildLiveRebuildWatcher(screenContext, isArabic),
                    16.heightBox,

                    // رسم بياني لمقارنة كفاءة الـ Rebuilds
                    _buildRebuildComparisonChart(isArabic),
                    16.heightBox,

                    // جدول المقارنة الشاملة والمعايير المعمارية
                    _buildComparisonMatrix(isArabic),
                    16.heightBox,

                    // استعراض الكود المصدري التفاعلي
                    _buildCodeSection(isArabic),
                    24.heightBox,
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildIntroCard(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(12),
        border:
            Border.all(color: const Color(0xFF14B8A6).withValues(alpha: 0.35)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF14B8A6).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.compare_arrows_rounded,
                color: Color(0xFF5EEAD4), size: 26),
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic
                      ? 'مقارنة الأداء وعزل إعادة البناء (Rebuild Isolation)'
                      : 'Rebuild Isolation & State Management Benchmark',
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 14,
                      color: Colors.white),
                ),
                4.heightBox,
                Text(
                  isArabic
                      ? 'اختبر كيف يختلف سلوك الشاشة بين setState (الذي يعيد بناء الشجرة بالكامل) وبين Cubit + BlocSelector و ValueNotifier (التي تعزل التحديثات بدقة فائقة لتحقيق أقصى درجات السلاسة 60/120 FPS).'
                      : 'Compare setState full widget subtree rebuilds vs granular isolated rebuilds using Cubit with BlocSelector and ValueNotifier.',
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

  Widget _buildApproachSelector(bool isArabic) {
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
            child: _buildApproachTab(
              title: 'setState',
              subtitle: isArabic ? 'إعادة بناء كاملة' : 'Full Rebuild',
              index: 0,
              badgeColor: const Color(0xFFEF4444),
            ),
          ),
          4.widthBox,
          Expanded(
            child: _buildApproachTab(
              title: 'Cubit (BlocSelector)',
              subtitle: isArabic ? 'عزل دقيق ومعماري' : 'Isolated Granular',
              index: 1,
              badgeColor: const Color(0xFF10B981),
            ),
          ),
          4.widthBox,
          Expanded(
            child: _buildApproachTab(
              title: 'ValueNotifier',
              subtitle: isArabic ? 'تفاعلية خفيفة' : 'Lightweight',
              index: 2,
              badgeColor: const Color(0xFF38BDF8),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildApproachTab({
    required String title,
    required String subtitle,
    required int index,
    required Color badgeColor,
  }) {
    final isSelected = _selectedMode == index;
    return InkWell(
      onTap: () => setState(() => _selectedMode = index),
      borderRadius: BorderRadius.circular(8),
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 8),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF1E293B) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
          border: isSelected ? Border.all(color: badgeColor, width: 1.5) : null,
        ),
        child: Column(
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 12,
                color: isSelected ? Colors.white : Colors.white60,
              ),
            ),
            2.heightBox,
            Text(
              subtitle,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 10,
                color: isSelected ? badgeColor : Colors.white38,
                fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildControlPanel(BuildContext screenContext, bool isArabic) {
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
                isArabic ? '🎮 لوحة توليد الأحداث والعمليات:' : '🎮 Event & Mutation Controls:',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white),
              ),
              if (_isStressTesting)
                Row(
                  children: [
                    const SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(
                          strokeWidth: 2, color: Color(0xFF14B8A6)),
                    ),
                    6.widthBox,
                    Text(
                      isArabic ? 'جاري الفحص السريع...' : 'Benchmarking...',
                      style: const TextStyle(
                          color: Color(0xFF14B8A6), fontSize: 11),
                    ),
                  ],
                ),
            ],
          ),
          12.heightBox,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF0284C7),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onPressed: () {
                  if (_selectedMode == 0) {
                    setState(() {
                      _localCounter++;
                    });
                  } else if (_selectedMode == 1) {
                    screenContext.read<ComparisonCubit>().incrementCounter();
                  } else {
                    _vnCounter.value++;
                  }
                },
                icon:
                    const Icon(Icons.add_rounded, size: 16, color: Colors.white),
                label: Text(
                  isArabic ? 'تحديث العداد فقط' : 'Mutate Counter Only',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF8B5CF6),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onPressed: () {
                  final statuses = ['Idle', 'Loading...', 'Synced', 'Active', 'Cached'];
                  final nextStatus =
                      statuses[(DateTime.now().second) % statuses.length];
                  if (_selectedMode == 0) {
                    setState(() {
                      _localStatus = nextStatus;
                    });
                  } else if (_selectedMode == 1) {
                    screenContext.read<ComparisonCubit>().updateStatus(nextStatus);
                  } else {
                    _vnStatus.value = nextStatus;
                  }
                },
                icon: const Icon(Icons.sync_alt_rounded,
                    size: 16, color: Colors.white),
                label: Text(
                  isArabic ? 'تحديث الحالة النصية' : 'Mutate Status Text',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFD97706),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onPressed: () {
                  final colors = [
                    const Color(0xFF14B8A6),
                    const Color(0xFFEC4899),
                    const Color(0xFFF59E0B),
                    const Color(0xFF6366F1),
                  ];
                  final nextColor =
                      colors[(DateTime.now().millisecond) % colors.length];
                  if (_selectedMode == 0) {
                    setState(() {
                      _localColor = nextColor;
                    });
                  } else if (_selectedMode == 1) {
                    final hex = nextColor.value.toRadixString(16).substring(2);
                    screenContext.read<ComparisonCubit>().changeColor(hex);
                  } else {
                    _vnColor.value = nextColor;
                  }
                },
                icon: const Icon(Icons.palette_rounded,
                    size: 16, color: Colors.white),
                label: Text(
                  isArabic ? 'تغيير اللون' : 'Mutate Theme Color',
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                ),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFDC2626),
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                ),
                onPressed: _isStressTesting
                    ? null
                    : () => _runStressTest(screenContext),
                icon: const Icon(Icons.speed_rounded,
                    size: 16, color: Colors.white),
                label: Text(
                  isArabic
                      ? '⚡ اختبار ضغط (15 حدث متتالي)'
                      : '⚡ Stress Test (15 Events)',
                  style: const TextStyle(
                      color: Colors.white,
                      fontSize: 12,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildLiveRebuildWatcher(BuildContext screenContext, bool isArabic) {
    if (_selectedMode == 0) {
      _setStateParentRebuilds++;
    } else if (_selectedMode == 1) {
      _cubitParentRebuilds++;
    } else {
      _vnParentRebuilds++;
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              isArabic
                  ? '🔍 مراقب إعادة البناء للويدجتس (Live Rebuild Telemetry):'
                  : '🔍 Live Widget Rebuild Telemetry:',
              style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                  color: Colors.white),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
              decoration: BoxDecoration(
                color: _selectedMode == 0
                    ? const Color(0x33EF4444)
                    : const Color(0x3310B981),
                borderRadius: BorderRadius.circular(6),
                border: Border.all(
                  color: _selectedMode == 0
                      ? const Color(0xFFEF4444)
                      : const Color(0xFF10B981),
                ),
              ),
              child: Text(
                _selectedMode == 0
                    ? (isArabic ? 'إعادة بناء كاملة ❌' : 'Full Tree Rebuild ❌')
                    : (isArabic ? 'عزل مثالي ✅' : 'Isolated Rebuild ✅'),
                style: TextStyle(
                  color: _selectedMode == 0
                      ? const Color(0xFFFCA5A5)
                      : const Color(0xFF6EE7B7),
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        8.heightBox,

        // ويدجت الـ Parent
        _buildTelemetryCard(
          title: isArabic
              ? 'Parent Scaffold / Screen Root'
              : 'Parent Scaffold / Screen Root',
          subtitle: isArabic
              ? 'الحاوية الرئيسية للشاشة'
              : 'Main screen wrapper container',
          rebuildCount: _selectedMode == 0
              ? _setStateParentRebuilds
              : (_selectedMode == 1 ? _cubitParentRebuilds : _vnParentRebuilds),
          icon: Icons.dashboard_rounded,
          accentColor: const Color(0xFF94A3B8),
          highlight: _selectedMode == 0,
        ),
        8.heightBox,

        // ويدجت العداد
        if (_selectedMode == 0)
          Builder(builder: (ctx) {
            _setStateCounterRebuilds++;
            return _buildTelemetryCard(
              title: isArabic
                  ? 'Counter Widget (قيمة: $_localCounter)'
                  : 'Counter Widget (Value: $_localCounter)',
              subtitle: isArabic
                  ? 'يعاد بناؤه مع كل تغيير في الشاشة'
                  : 'Rebuilds on every state mutation in screen',
              rebuildCount: _setStateCounterRebuilds,
              icon: Icons.pin_rounded,
              accentColor: const Color(0xFF0284C7),
              highlight: true,
            );
          })
        else if (_selectedMode == 1)
          BlocSelector<ComparisonCubit, ComparisonState, int>(
            selector: (state) => state.counter,
            builder: (context, counter) {
              _cubitCounterRebuilds++;
              return _buildTelemetryCard(
                title: isArabic
                    ? 'Counter Widget via BlocSelector (قيمة: $counter)'
                    : 'Counter Widget via BlocSelector (Value: $counter)',
                subtitle: isArabic
                    ? 'يُعاد بناؤه فقط عندما يتغير العداد حصراً!'
                    : 'Rebuilds ONLY when counter value changes!',
                rebuildCount: _cubitCounterRebuilds,
                icon: Icons.pin_rounded,
                accentColor: const Color(0xFF0284C7),
                highlight: true,
              );
            },
          )
        else
          ValueListenableBuilder<int>(
            valueListenable: _vnCounter,
            builder: (context, counter, _) {
              _vnCounterRebuilds++;
              return _buildTelemetryCard(
                title: isArabic
                    ? 'Counter Widget via ValueNotifier (قيمة: $counter)'
                    : 'Counter Widget via ValueNotifier (Value: $counter)',
                subtitle: isArabic
                    ? 'يُعاد بناؤه فقط عندما يتغير العداد'
                    : 'Rebuilds ONLY when ValueNotifier triggers',
                rebuildCount: _vnCounterRebuilds,
                icon: Icons.pin_rounded,
                accentColor: const Color(0xFF0284C7),
                highlight: true,
              );
            },
          ),
        8.heightBox,

        // ويدجت الحالة النصية
        if (_selectedMode == 0)
          Builder(builder: (ctx) {
            _setStateStatusRebuilds++;
            return _buildTelemetryCard(
              title: isArabic
                  ? 'Status Widget (الحالة: $_localStatus)'
                  : 'Status Widget (Status: $_localStatus)',
              subtitle: isArabic
                  ? 'يعاد بناؤه حتى لو تم تغيير العداد فقط!'
                  : 'Rebuilt even if only counter was mutated!',
              rebuildCount: _setStateStatusRebuilds,
              icon: Icons.info_outline_rounded,
              accentColor: const Color(0xFF8B5CF6),
              highlight: true,
            );
          })
        else if (_selectedMode == 1)
          BlocSelector<ComparisonCubit, ComparisonState, String>(
            selector: (state) => state.status,
            builder: (context, status) {
              _cubitStatusRebuilds++;
              return _buildTelemetryCard(
                title: isArabic
                    ? 'Status Widget via BlocSelector (الحالة: $status)'
                    : 'Status Widget via BlocSelector (Status: $status)',
                subtitle: isArabic
                    ? 'لا يتأثر نهائياً بتغيير العداد أو الألوان!'
                    : 'Completely immune to counter & color mutations!',
                rebuildCount: _cubitStatusRebuilds,
                icon: Icons.info_outline_rounded,
                accentColor: const Color(0xFF8B5CF6),
                highlight: true,
              );
            },
          )
        else
          ValueListenableBuilder<String>(
            valueListenable: _vnStatus,
            builder: (context, status, _) {
              _vnStatusRebuilds++;
              return _buildTelemetryCard(
                title: isArabic
                    ? 'Status Widget via ValueNotifier (الحالة: $status)'
                    : 'Status Widget via ValueNotifier (Status: $status)',
                subtitle: isArabic
                    ? 'يُعاد بناؤه عند تغيير الحالة النصية فقط'
                    : 'Rebuilt only when status notifier fires',
                rebuildCount: _vnStatusRebuilds,
                icon: Icons.info_outline_rounded,
                accentColor: const Color(0xFF8B5CF6),
                highlight: true,
              );
            },
          ),
        8.heightBox,

        // ويدجت ثابت غير متصل بالحالة (Static Widget)
        if (_selectedMode == 0)
          Builder(builder: (ctx) {
            _setStateStaticRebuilds++;
            return _buildTelemetryCard(
              title: isArabic
                  ? 'Static Card (عنصر ثابت بدون داتا)'
                  : 'Static Card (No State Dependency)',
              subtitle: isArabic
                  ? '⚠️ مشكلة شائعة: يُعاد بناؤه بالرغم من عدم اعتماده على أي داتا!'
                  : '⚠️ Anti-Pattern: Rebuilds wastefully on every setState!',
              rebuildCount: _setStateStaticRebuilds,
              icon: Icons.do_not_disturb_on_rounded,
              accentColor: const Color(0xFFEF4444),
              isStaticWasted: true,
            );
          })
        else if (_selectedMode == 1)
          Builder(builder: (ctx) {
            _cubitStaticRebuilds++;
            return _buildTelemetryCard(
              title: isArabic
                  ? 'Static Card (عنصر ثابت محمي)'
                  : 'Static Card (Isolated & Protected)',
              subtitle: isArabic
                  ? '✅ محمي تماماً: ثابت ولا يعاد بناؤه عند تحديث الـ Cubit'
                  : '✅ 100% Protected: Zero wasteful rebuilds during Cubit state emits',
              rebuildCount: _cubitStaticRebuilds,
              icon: Icons.verified_rounded,
              accentColor: const Color(0xFF10B981),
              isStaticWasted: false,
            );
          })
        else
          Builder(builder: (ctx) {
            _vnStaticRebuilds++;
            return _buildTelemetryCard(
              title: isArabic
                  ? 'Static Card (عنصر ثابت محمي)'
                  : 'Static Card (Isolated & Protected)',
              subtitle: isArabic
                  ? '✅ محمي تماماً: لا يعاد بناؤه عند تحديث الـ Notifiers'
                  : '✅ 100% Protected: Isolated outside ValueListenableBuilder',
              rebuildCount: _vnStaticRebuilds,
              icon: Icons.verified_rounded,
              accentColor: const Color(0xFF10B981),
              isStaticWasted: false,
            );
          }),
      ],
    );
  }

  Widget _buildTelemetryCard({
    required String title,
    required String subtitle,
    required int rebuildCount,
    required IconData icon,
    required Color accentColor,
    bool highlight = false,
    bool isStaticWasted = false,
  }) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: isStaticWasted
              ? const Color(0xFFEF4444).withValues(alpha: 0.6)
              : (highlight
                  ? accentColor.withValues(alpha: 0.3)
                  : const Color(0xFF1E293B)),
        ),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: accentColor, size: 20),
          ),
          10.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 12,
                      color: Colors.white),
                ),
                2.heightBox,
                Text(
                  subtitle,
                  style: TextStyle(
                    fontSize: 11,
                    color: isStaticWasted
                        ? const Color(0xFFFCA5A5)
                        : Colors.white60,
                  ),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: isStaticWasted
                  ? const Color(0xFFEF4444).withValues(alpha: 0.2)
                  : accentColor.withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(20),
              border: Border.all(
                color: isStaticWasted
                    ? const Color(0xFFEF4444)
                    : accentColor.withValues(alpha: 0.5),
              ),
            ),
            child: Text(
              'Rebuilds: $rebuildCount',
              style: TextStyle(
                color: isStaticWasted
                    ? const Color(0xFFF87171)
                    : (accentColor == const Color(0xFF94A3B8)
                        ? Colors.white
                        : accentColor),
                fontWeight: FontWeight.bold,
                fontSize: 11,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRebuildComparisonChart(bool isArabic) {
    final totalSetState = _setStateParentRebuilds +
        _setStateCounterRebuilds +
        _setStateStatusRebuilds +
        _setStateStaticRebuilds;

    final totalCubit = _cubitParentRebuilds +
        _cubitCounterRebuilds +
        _cubitStatusRebuilds +
        _cubitStaticRebuilds;

    final totalVn = _vnParentRebuilds +
        _vnCounterRebuilds +
        _vnStatusRebuilds +
        _vnStaticRebuilds;

    final maxVal = [totalSetState, totalCubit, totalVn, 10]
        .reduce((curr, next) => curr > next ? curr : next)
        .toDouble();

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
                    ? '📊 مقارنة إجمالي الهدر في الـ Rebuilds:'
                    : '📊 Total Rebuilds Overhead Benchmark:',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white),
              ),
              Text(
                isArabic ? '(الأقل هو الأفضل ⚡)' : '(Lower is Better ⚡)',
                style: const TextStyle(color: Color(0xFF10B981), fontSize: 11),
              ),
            ],
          ),
          14.heightBox,
          _buildBarMeter(
            label: 'setState (Non-isolated)',
            count: totalSetState,
            maxVal: maxVal,
            color: const Color(0xFFEF4444),
          ),
          8.heightBox,
          _buildBarMeter(
            label: 'Cubit (BlocSelector)',
            count: totalCubit,
            maxVal: maxVal,
            color: const Color(0xFF10B981),
          ),
          8.heightBox,
          _buildBarMeter(
            label: 'ValueNotifier / Listener',
            count: totalVn,
            maxVal: maxVal,
            color: const Color(0xFF38BDF8),
          ),
        ],
      ),
    );
  }

  Widget _buildBarMeter({
    required String label,
    required int count,
    required double maxVal,
    required Color color,
  }) {
    final ratio = (count / (maxVal == 0 ? 1 : maxVal)).clamp(0.04, 1.0);

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label,
                style: const TextStyle(color: Colors.white70, fontSize: 11)),
            Text(
              '$count Rebuilds',
              style: TextStyle(
                  color: color, fontWeight: FontWeight.bold, fontSize: 11),
            ),
          ],
        ),
        4.heightBox,
        Stack(
          children: [
            Container(
              height: 10,
              width: double.infinity,
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(5),
              ),
            ),
            FractionallySizedBox(
              widthFactor: ratio,
              child: Container(
                height: 10,
                decoration: BoxDecoration(
                  color: color,
                  borderRadius: BorderRadius.circular(5),
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildComparisonMatrix(bool isArabic) {
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
          Text(
            isArabic
                ? '🧭 جدول المفاضلة المعمارية لاختيار حزمة الحالة:'
                : '🧭 Architectural State Management Matrix:',
            style: const TextStyle(
                fontWeight: FontWeight.bold,
                fontSize: 13,
                color: Colors.white),
          ),
          12.heightBox,
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: DataTable(
              headingRowColor: WidgetStateProperty.all(const Color(0xFF1E293B)),
              dataRowColor: WidgetStateProperty.all(const Color(0xFF0F172A)),
              border: TableBorder.all(
                  color: const Color(0xFF334155), borderRadius: BorderRadius.circular(8)),
              columns: [
                DataColumn(
                    label: Text(isArabic ? 'التقنية' : 'Pattern',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                DataColumn(
                    label: Text(isArabic ? 'عزل الـ Rebuild' : 'Rebuild Isolation',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                DataColumn(
                    label: Text(isArabic ? 'قابلية الاختبار (Testing)' : 'Testability',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                DataColumn(
                    label: Text(isArabic ? 'التعقيد والكود' : 'Boilerplate',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
                DataColumn(
                    label: Text(isArabic ? 'الاستخدام الأنسب' : 'Best For',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, color: Colors.white))),
              ],
              rows: [
                DataRow(cells: [
                  const DataCell(Text('setState',
                      style: TextStyle(
                          color: Color(0xFFEF4444), fontWeight: FontWeight.bold))),
                  DataCell(Text(isArabic ? 'ضعيف (كامل الشجرة)' : 'Low (Tree wide)',
                      style: const TextStyle(color: Colors.white70))),
                  DataCell(Text(isArabic ? 'صعب (مرتبط بالـ UI)' : 'Hard (UI coupled)',
                      style: const TextStyle(color: Colors.white70))),
                  DataCell(Text(isArabic ? 'شبه معدوم' : 'Minimal',
                      style: const TextStyle(color: Colors.white70))),
                  DataCell(Text(isArabic ? 'النماذج البسيطة جداً والتجارب' : 'Micro UI interactions',
                      style: const TextStyle(color: Colors.white70))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('Cubit / BLoC',
                      style: TextStyle(
                          color: Color(0xFF10B981), fontWeight: FontWeight.bold))),
                  DataCell(Text(isArabic ? 'ممتاز (عبر BlocSelector)' : 'High (BlocSelector)',
                      style: const TextStyle(color: Colors.white70))),
                  DataCell(Text(isArabic ? '100% ممتاز مع bloc_test' : 'Perfect (bloc_test)',
                      style: const TextStyle(color: Colors.white70))),
                  DataCell(Text(isArabic ? 'متوسط ومنظم' : 'Structured',
                      style: const TextStyle(color: Colors.white70))),
                  DataCell(Text(isArabic ? 'التطبيقات الكبيرة والمعمارية النظيفة' : 'Enterprise & Clean Arch',
                      style: const TextStyle(color: Colors.white70))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('ValueNotifier',
                      style: TextStyle(
                          color: Color(0xFF38BDF8), fontWeight: FontWeight.bold))),
                  DataCell(Text(isArabic ? 'جيد جداً (ValueListenable)' : 'High (Scoped)',
                      style: const TextStyle(color: Colors.white70))),
                  DataCell(Text(isArabic ? 'جيد' : 'Moderate',
                      style: const TextStyle(color: Colors.white70))),
                  DataCell(Text(isArabic ? 'بسيط جداً' : 'Low',
                      style: const TextStyle(color: Colors.white70))),
                  DataCell(Text(isArabic ? 'حالات وسيطة بدون باكدجات' : 'Zero-dependency reactive UI',
                      style: const TextStyle(color: Colors.white70))),
                ]),
                DataRow(cells: [
                  const DataCell(Text('InheritedModel',
                      style: TextStyle(
                          color: Color(0xFFF59E0B), fontWeight: FontWeight.bold))),
                  DataCell(Text(isArabic ? 'ممتاز عبر الـ Aspects' : 'Aspect-Filtered O(1)',
                      style: const TextStyle(color: Colors.white70))),
                  DataCell(Text(isArabic ? 'متوسط' : 'Moderate',
                      style: const TextStyle(color: Colors.white70))),
                  DataCell(Text(isArabic ? 'يحتاج كلاسات مخصصة' : 'Manual Boilerplate',
                      style: const TextStyle(color: Colors.white70))),
                  DataCell(Text(isArabic ? 'حزم Flutter الداخلية والـ Themes' : 'Framework internals & Themes',
                      style: const TextStyle(color: Colors.white70))),
                ]),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeSection(bool isArabic) {
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
                    ? '💻 الكود البرمجي للأسلوب المختار حالياً:'
                    : '💻 Active State Implementation Code:',
                style: const TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                    color: Colors.white),
              ),
              Text(
                _selectedMode == 0
                    ? 'setState'
                    : (_selectedMode == 1 ? 'Cubit' : 'ValueNotifier'),
                style: const TextStyle(
                    color: Color(0xFF14B8A6),
                    fontWeight: FontWeight.bold,
                    fontSize: 12),
              ),
            ],
          ),
          10.heightBox,
          CopyableCodeBlock(
            code: _getCodeSnippet(_selectedMode),
          ),
        ],
      ),
    );
  }
}
