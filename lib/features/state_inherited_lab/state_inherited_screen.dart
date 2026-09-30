import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';

enum DemoAspect { counter, color, theme }

/// نموذج InheritedModel المتقدم مع تصفية المظاهر (Aspects)
class AppConfigModel extends InheritedModel<DemoAspect> {
  final int counter;
  final Color activeColor;
  final String themeName;

  const AppConfigModel({
    super.key,
    required this.counter,
    required this.activeColor,
    required this.themeName,
    required super.child,
  });

  static AppConfigModel? of(BuildContext context, [DemoAspect? aspect]) {
    return InheritedModel.inheritFrom<AppConfigModel>(context, aspect: aspect);
  }

  @override
  bool updateShouldNotify(AppConfigModel oldWidget) {
    return counter != oldWidget.counter ||
        activeColor != oldWidget.activeColor ||
        themeName != oldWidget.themeName;
  }

  @override
  bool updateShouldNotifyDependent(
    AppConfigModel oldWidget,
    Set<DemoAspect> dependencies,
  ) {
    if (dependencies.contains(DemoAspect.counter) && counter != oldWidget.counter) {
      return true;
    }
    if (dependencies.contains(DemoAspect.color) && activeColor != oldWidget.activeColor) {
      return true;
    }
    if (dependencies.contains(DemoAspect.theme) && themeName != oldWidget.themeName) {
      return true;
    }
    return false;
  }
}

/// شاشة مختبر إدارة الحالة المعمارية و InheritedModel
class StateInheritedScreen extends StatefulWidget {
  const StateInheritedScreen({super.key});

  @override
  State<StateInheritedScreen> createState() => _StateInheritedScreenState();
}

class _StateInheritedScreenState extends State<StateInheritedScreen> {
  int _counter = 0;
  Color _color = const Color(0xFF14B8A6);
  final String _themeName = 'Cyber Dark';

  String _getInheritedCode() {
    return '// 1. اشتراك حبيبي (Granular Subscription) للعداد فقط:\n'
        'final config = InheritedModel.inheritFrom<AppConfigModel>(context, aspect: DemoAspect.counter);\n'
        '// العداد الحالي: $_counter (تغيير اللون لا يسبب إعادة بناء هذا الويدجت!)\n\n'
        '// 2. اشتراك حبيبي للون فقط:\n'
        'final color = InheritedModel.inheritFrom<AppConfigModel>(context, aspect: DemoAspect.color)?.activeColor;\n\n'
        '// 3. فحص التبعيات الذكي داخل updateShouldNotifyDependent:\n'
        'if (dependencies.contains(DemoAspect.counter) && counter != oldWidget.counter) return true;\n'
        'if (dependencies.contains(DemoAspect.color) && activeColor != oldWidget.activeColor) return true;';
  }

  void _openAiCopilot(BuildContext context, bool isArabic) {
    ContextualAiSheet.show(
      context,
      topicTitle: isArabic ? 'مختبر InheritedModel وإدارة الحالة المعمارية' : 'InheritedModel & Architectural State Lab',
      topicCode: _getInheritedCode(),
      levelTitle: isArabic ? 'إدارة الحالة المتقدمة وهندسة شجرة الـ Elements' : 'Advanced State Management & Element Tree',
      isArabic: isArabic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final isArabic = locale.isArabic;

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isArabic ? 'مختبر InheritedModel وإدارة الحالة' : 'InheritedModel & State Lab'),
          actions: [
            IconButton(
              tooltip: isArabic ? 'اسأل المساعد الذكي' : 'Ask AI Copilot',
              icon: const Icon(Icons.psychology_rounded, color: Color(0xFF14B8A6)),
              onPressed: () => _openAiCopilot(context, isArabic),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openAiCopilot(context, isArabic),
          icon: const Icon(Icons.psychology_rounded, color: Color(0xFF04111C)),
          label: Text(
            isArabic ? 'اسأل المساعد الذكي عن هذا الكود' : 'Ask AI About This Code',
            style: const TextStyle(color: Color(0xFF04111C), fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF14B8A6),
        ),
        body: AppConfigModel(
          counter: _counter,
          activeColor: _color,
          themeName: _themeName,
          child: ResponsiveContentWrapper(
            maxWidth: 1200,
            child: ListView(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
              children: [
                _buildIntroCard(isArabic),
                16.heightBox,

                // أزرار التحكم في الـ State الأعلى
                _buildControlPanel(isArabic),
                16.heightBox,

                // فحص الـ Rebuilds للأبناء
                Text(
                  isArabic ? '📊 اختبار إعادة البناء الحبيبي (Granular Rebuilds):' : '📊 Granular Rebuild Test Watcher:',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
                ),
                8.heightBox,

                // ويدجت مهتمة فقط بالعداد
                const CounterConsumerCard(),
                10.heightBox,

                // ويدجت مهتمة فقط باللون
                const ColorConsumerCard(),
                10.heightBox,

                // ويدجت مهتمة بجميع التغييرات (InheritedWidget تقليدي)
                const AllChangesConsumerCard(),
                16.heightBox,

                // كود الـ InheritedModel الحي
                _buildCodeSection(isArabic),
                24.heightBox,
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF14B8A6).withValues(alpha: 0.4)),
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
            child: const Icon(Icons.account_tree_rounded, color: Color(0xFF5EEAD4), size: 24),
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'سر أداء O(1) في Flutter Framework' : 'The Secret of O(1) in Flutter',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                ),
                4.heightBox,
                Text(
                  isArabic
                      ? 'يعتمد Provider و Riverpod داخلياً على InheritedElement للوصول السريع بـ O(1). يتيح لك InheritedModel تحديد Aspect خاص، لكي لا تُعاد إعادة بناء الويدجت إلا إذا تغيّر الحقل المشتركة فيه فقط!'
                      : 'InheritedModel provides granular rebuild subscriptions based on aspects, eliminating unnecessary widget re-renders.',
                  style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildControlPanel(bool isArabic) {
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
            isArabic ? 'لوحة تحكم الـ State في قمة الشجرة (Root):' : 'Root State Controls:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
          ),
          12.heightBox,
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0284C7)),
                  onPressed: () => setState(() => _counter++),
                  icon: const Icon(Icons.add_rounded, color: Colors.white, size: 16),
                  label: Text(
                    isArabic ? 'زيادة العداد ($_counter)' : 'Inc Counter ($_counter)',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
              8.widthBox,
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFD97706)),
                  onPressed: () {
                    final colors = [
                      const Color(0xFF14B8A6),
                      const Color(0xFFEC4899),
                      const Color(0xFF8B5CF6),
                      const Color(0xFFF59E0B),
                    ];
                    setState(() {
                      _color = colors[(_counter + DateTime.now().millisecond) % colors.length];
                    });
                  },
                  icon: const Icon(Icons.palette_rounded, color: Colors.white, size: 16),
                  label: Text(
                    isArabic ? 'تغيير اللون' : 'Change Color',
                    style: const TextStyle(color: Colors.white, fontSize: 12),
                  ),
                ),
              ),
            ],
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
          Text(
            isArabic ? '💻 كود الاشتراك الحبيبي في InheritedModel (يتغير مع العداد واللون):' : '💻 Live InheritedModel Code:',
            style: const TextStyle(color: Color(0xFF5EEAD4), fontWeight: FontWeight.bold, fontSize: 13),
          ),
          10.heightBox,
          CopyableCodeBlock(
            code: _getInheritedCode(),
            copiedMessage: isArabic ? 'تم نسخ كود InheritedModel' : 'InheritedModel code copied',
          ),
        ],
      ),
    );
  }
}

/// ويدجت تستمع فقط للعداد
class CounterConsumerCard extends StatefulWidget {
  const CounterConsumerCard({super.key});

  @override
  State<CounterConsumerCard> createState() => _CounterConsumerCardState();
}

class _CounterConsumerCardState extends State<CounterConsumerCard> {
  int _buildCount = 0;

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    // الاستماع فقط لـ DemoAspect.counter
    final model = AppConfigModel.of(context, DemoAspect.counter);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.timer_rounded, color: Color(0xFF38BDF8), size: 28),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Counter Consumer (Aspect: counter)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: Colors.white),
                ),
                Text(
                  'قيمة العداد: ${model?.counter}',
                  style: const TextStyle(fontSize: 12, color: Color(0xFF38BDF8)),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Builds: $_buildCount',
              style: const TextStyle(color: Color(0xFF38BDF8), fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

/// ويدجت تستمع فقط للون
class ColorConsumerCard extends StatefulWidget {
  const ColorConsumerCard({super.key});

  @override
  State<ColorConsumerCard> createState() => _ColorConsumerCardState();
}

class _ColorConsumerCardState extends State<ColorConsumerCard> {
  int _buildCount = 0;

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    // الاستماع فقط لـ DemoAspect.color
    final model = AppConfigModel.of(context, DemoAspect.color);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: model?.activeColor.withValues(alpha: 0.6) ?? const Color(0xFF24324A)),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            height: 28,
            decoration: BoxDecoration(
              color: model?.activeColor,
              shape: BoxShape.circle,
            ),
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Color Consumer (Aspect: color)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: Colors.white),
                ),
                Text(
                  'لا يعاد بناؤه عند زيادة العداد!',
                  style: TextStyle(fontSize: 11, color: model?.activeColor),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: model?.activeColor.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Builds: $_buildCount',
              style: TextStyle(color: model?.activeColor, fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}

/// ويدجت تستمع لكل شيء بدون Aspect
class AllChangesConsumerCard extends StatefulWidget {
  const AllChangesConsumerCard({super.key});

  @override
  State<AllChangesConsumerCard> createState() => _AllChangesConsumerCardState();
}

class _AllChangesConsumerCardState extends State<AllChangesConsumerCard> {
  int _buildCount = 0;

  @override
  Widget build(BuildContext context) {
    _buildCount++;
    // الاستماع لكل شيء (Aspect = null)
    final model = AppConfigModel.of(context);

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFFE11D48).withValues(alpha: 0.5)),
      ),
      child: Row(
        children: [
          const Icon(Icons.sync_problem_rounded, color: Color(0xFFFB7185), size: 28),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Full InheritedWidget Consumer (No Aspect)',
                  style: TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: Colors.white),
                ),
                Text(
                  'يعاد بناؤه مع أي تغيير (عداد: ${model?.counter})',
                  style: const TextStyle(fontSize: 11, color: Colors.white60),
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFE11D48).withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: Text(
              'Builds: $_buildCount',
              style: const TextStyle(color: Color(0xFFFB7185), fontSize: 11, fontWeight: FontWeight.bold),
            ),
          ),
        ],
      ),
    );
  }
}
