import 'package:flutter/material.dart';
import 'package:flutter/physics.dart';
import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';
import '../quiz/lab_quiz_action.dart';

/// شاشة مختبر الحركات المتقدمة (Advanced Animations & Physics)
class AnimationsScreen extends StatefulWidget {
  const AnimationsScreen({super.key});

  @override
  State<AnimationsScreen> createState() => _AnimationsScreenState();
}

class _AnimationsScreenState extends State<AnimationsScreen> with TickerProviderStateMixin {
  late final AnimationController _staggerController;
  late final Animation<double> _slideAnimation;
  late final Animation<double> _scaleAnimation;
  late final Animation<double> _rotateAnimation;
  late final Animation<double> _fadeAnimation;

  // Spring Physics Controller
  late final AnimationController _springController;
  final double _mass = 1.0;
  double _stiffness = 180.0;
  double _damping = 12.0;

  @override
  void initState() {
    super.initState();

    // 1. Staggered Controller
    _staggerController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1400),
    );

    _slideAnimation = Tween<double>(begin: -80, end: 0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic),
      ),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.1, 0.5, curve: Curves.easeIn),
      ),
    );

    _scaleAnimation = Tween<double>(begin: 0.4, end: 1.0).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.4, 0.75, curve: Curves.elasticOut),
      ),
    );

    _rotateAnimation = Tween<double>(begin: 0.0, end: 6.28318).animate(
      CurvedAnimation(
        parent: _staggerController,
        curve: const Interval(0.7, 1.0, curve: Curves.easeInOutBack),
      ),
    );

    // 2. Spring Physics Controller
    _springController = AnimationController.unbounded(vsync: this);
  }

  void _runSpringSimulation() {
    final spring = SpringDescription(
      mass: _mass,
      stiffness: _stiffness,
      damping: _damping,
    );

    final simulation = SpringSimulation(spring, 0, 150, -500);
    _springController.animateWith(simulation);
  }

  String _getSpringCode() {
    return '// 1. تعريف خصائص النابض الفيزيائي (تتغير القيم تلقائياً مع السلايدر)\n'
        'final spring = SpringDescription(\n'
        '  mass: ${_mass.toStringAsFixed(1)},        // الكتلة بالكيلوغرام\n'
        '  stiffness: ${_stiffness.toStringAsFixed(1)}, // صلابة وقوة ارتداد النابض (Stiffness)\n'
        '  damping: ${_damping.toStringAsFixed(1)},   // مقاومة وتخميد الحركة (Damping)\n'
        ');\n\n'
        '// 2. إنشاء المحاكاة الفيزيائية وتمرير الموضع والسرعة الابتدائية\n'
        'final simulation = SpringSimulation(\n'
        '  spring,\n'
        '  0.0,    // نقطة البداية (Start position)\n'
        '  150.0,  // نقطة الاستقرار والهدف (End position)\n'
        '  -500.0, // سرعة الانطلاق الابتدائية (Initial velocity)\n'
        ');\n\n'
        '// 3. تشغيل المحاكاة على AnimationController غير مقيد بـ Duration محدد\n'
        'springController.animateWith(simulation);';
  }

  String _getStaggeredCode() {
    return '// تقسيم AnimationController واحد إلى مراحل زمنية متسلسلة عبر Interval\n'
        'final controller = AnimationController(\n'
        '  duration: const Duration(milliseconds: 1400),\n'
        '  vsync: this,\n'
        ');\n\n'
        '// 1. مرحلة الإزاحة (من 0% إلى 40% من الوقت الكلي)\n'
        'final slide = Tween<double>(begin: -80, end: 0).animate(\n'
        '  CurvedAnimation(parent: controller, curve: const Interval(0.0, 0.4, curve: Curves.easeOutCubic)),\n'
        ');\n\n'
        '// 2. مرحلة الظهور والتلاشي (من 10% إلى 50%)\n'
        'final fade = Tween<double>(begin: 0.0, end: 1.0).animate(\n'
        '  CurvedAnimation(parent: controller, curve: const Interval(0.1, 0.5, curve: Curves.easeIn)),\n'
        ');\n\n'
        '// 3. مرحلة التكبير المرن (من 40% إلى 75%)\n'
        'final scale = Tween<double>(begin: 0.4, end: 1.0).animate(\n'
        '  CurvedAnimation(parent: controller, curve: const Interval(0.4, 0.75, curve: Curves.elasticOut)),\n'
        ');\n\n'
        '// 4. مرحلة الدوران الكامل (من 70% إلى 100%)\n'
        'final rotate = Tween<double>(begin: 0.0, end: 6.28).animate(\n'
        '  CurvedAnimation(parent: controller, curve: const Interval(0.7, 1.0, curve: Curves.easeInOutBack)),\n'
        ');';
  }

  void _openAiCopilot(BuildContext context, bool isArabic) {
    ContextualAiSheet.show(
      context,
      topicTitle: isArabic ? 'مختبر الأنيميشن المتقدم والنوابض الفيزيائية' : 'Advanced Animations & Physics Lab',
      topicCode: '${_getStaggeredCode()}\n\n${_getSpringCode()}',
      levelTitle: isArabic ? 'هندسة الأنيميشن والفيزياء (Animations & SpringSimulation)' : 'Animation & Physics Engineering',
      isArabic: isArabic,
    );
  }

  @override
  void dispose() {
    _staggerController.dispose();
    _springController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final isArabic = locale.isArabic;

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isArabic ? 'مختبر الحركات والفيزياء (Animations)' : 'Advanced Animations Lab'),
          actions: [
          const LabQuizAction(labId: 'animations'),
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
        body: ResponsiveContentWrapper(
          maxWidth: 1200,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            children: [
              _buildIntroCard(isArabic),
              16.heightBox,

              // 1. Staggered Animations Section
              _buildStaggeredSection(isArabic),
              16.heightBox,

              // 2. Spring Physics Simulation Section
              _buildSpringSection(isArabic),
              24.heightBox,
            ],
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
        border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF8B5CF6).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.animation_rounded, color: Color(0xFFA78BFA), size: 24),
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'هندسة الأنيميشن المتقدمة في Flutter' : 'Advanced Motion Engineering',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                ),
                4.heightBox,
                Text(
                  isArabic
                      ? 'الأنيميشن الاحترافي يعتمد على الحركات المتتالية (Staggered Intervals) والمحاكاة الفيزيائية (Physics Springs) بدلاً من الحركات الخطية البسيطة.'
                      : 'Master Interval-based staggered motion and real-time physics spring simulations for 60/120 FPS buttery smooth UI.',
                  style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStaggeredSection(bool isArabic) {
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
            children: [
              const Icon(Icons.stacked_line_chart_rounded, color: Color(0xFFA78BFA), size: 18),
              8.widthBox,
              Text(
                isArabic ? '1. الحركات المتسلسلة (Staggered Animation Intervals)' : '1. Staggered Animation Intervals',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
              ),
            ],
          ),
          8.heightBox,
          Text(
            isArabic
                ? 'استخدام Interval(start, end) لتقسيم جدول تحكم الـ AnimationController إلى مراحل متعاقبة (إزاحة ➔ تلاشي ➔ تكبير مرن ➔ دوران).'
                : 'Dividing single AnimationController into sequential timeline stages using Interval slices.',
            style: const TextStyle(fontSize: 11.5, color: Colors.white70),
          ),
          16.heightBox,

          // مساحة العرض الحي
          Container(
            height: 140,
            width: double.infinity,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF080D1A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: AnimatedBuilder(
              animation: _staggerController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value.clamp(0.0, 1.0),
                    child: Transform.rotate(
                      angle: _rotateAnimation.value,
                      child: Transform.scale(
                        scale: _scaleAnimation.value.clamp(0.0, 2.0),
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [Color(0xFF8B5CF6), Color(0xFFEC4899)],
                            ),
                            borderRadius: BorderRadius.circular(16),
                            boxShadow: [
                              BoxShadow(
                                color: const Color(0xFF8B5CF6).withValues(alpha: 0.5),
                                blurRadius: 16,
                              ),
                            ],
                          ),
                          child: const Icon(Icons.auto_awesome_rounded, color: Colors.white, size: 36),
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          12.heightBox,

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF7C3AED)),
                  onPressed: () {
                    _staggerController.reset();
                    _staggerController.forward();
                  },
                  icon: const Icon(Icons.play_arrow_rounded, color: Colors.white, size: 18),
                  label: Text(isArabic ? 'تشغيل التسلسل الكامل' : 'Play Stagger Sequence', style: const TextStyle(color: Colors.white)),
                ),
              ),
              8.widthBox,
              IconButton(
                style: IconButton.styleFrom(backgroundColor: const Color(0xFF1E293B)),
                icon: const Icon(Icons.refresh_rounded, color: Colors.white),
                onPressed: () => _staggerController.reverse(),
              ),
            ],
          ),
          16.heightBox,

          // الكود الفعلي الحي المعبر عن الشرح
          Text(
            isArabic ? '💻 الكود البرمجي الدقيق لتقسيم المراحل:' : '💻 Exact Staggered Code:',
            style: const TextStyle(color: Color(0xFFA78BFA), fontWeight: FontWeight.bold, fontSize: 12),
          ),
          6.heightBox,
          CopyableCodeBlock(
            code: _getStaggeredCode(),
            copiedMessage: isArabic ? 'تم نسخ كود Staggered Animation' : 'Staggered animation code copied',
          ),
        ],
      ),
    );
  }

  Widget _buildSpringSection(bool isArabic) {
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
            children: [
              const Icon(Icons.waves_rounded, color: Color(0xFF14B8A6), size: 18),
              8.widthBox,
              Text(
                isArabic ? '2. محاكاة النوابض الفيزيائية (SpringSimulation)' : '2. Spring Physics Simulation',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
              ),
            ],
          ),
          8.heightBox,
          Text(
            isArabic
                ? 'الحركات الطبيعية في أنظمة iOS و Android تحسب بالمعادلات الفيزيائية (الكتلة، الصلابة، التخميد) وليس بمدد زمنية محددة.'
                : 'Physics-based animations feel natural by respecting velocity, mass, stiffness and damping ratios.',
            style: const TextStyle(fontSize: 11.5, color: Colors.white70),
          ),
          16.heightBox,

          // مسار حركة النابض
          Container(
            height: 80,
            width: double.infinity,
            padding: const EdgeInsets.symmetric(horizontal: 16),
            alignment: Alignment.centerLeft,
            decoration: BoxDecoration(
              color: const Color(0xFF080D1A),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: AnimatedBuilder(
              animation: _springController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(_springController.value, 0),
                  child: Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: const Color(0xFF14B8A6),
                      borderRadius: BorderRadius.circular(10),
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFF14B8A6).withValues(alpha: 0.5),
                          blurRadius: 12,
                        ),
                      ],
                    ),
                    child: const Icon(Icons.bolt_rounded, color: Colors.white, size: 24),
                  ),
                );
              },
            ),
          ),
          12.heightBox,

          // سلايدرز التحكم بالفيزياء
          _buildSlider(
            label: isArabic ? 'الصلابة (Stiffness: ${_stiffness.toInt()})' : 'Stiffness: ${_stiffness.toInt()}',
            value: _stiffness,
            min: 50.0,
            max: 500.0,
            activeColor: const Color(0xFF14B8A6),
            onChanged: (v) => setState(() => _stiffness = v),
          ),
          _buildSlider(
            label: isArabic ? 'التخميد (Damping: ${_damping.toInt()})' : 'Damping: ${_damping.toInt()}',
            value: _damping,
            min: 2.0,
            max: 40.0,
            activeColor: const Color(0xFF38BDF8),
            onChanged: (v) => setState(() => _damping = v),
          ),
          12.heightBox,

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E)),
            onPressed: _runSpringSimulation,
            icon: const Icon(Icons.play_circle_fill_rounded, color: Colors.white, size: 18),
            label: Text(isArabic ? 'إطلاق النابض الفيزيائي' : 'Release Spring Impulse', style: const TextStyle(color: Colors.white)),
          ),
          16.heightBox,

          // الكود التفاعلي المباشر الذي يتغير مع قيم التخميد والصلابة
          Text(
            isArabic ? '💻 الكود الفعلي الحي (يتغير فوراً مع تغيير قيم التخميد والصلابة أعلاه):' : '💻 Live Reactive Code (Updates instantly with damping/stiffness values):',
            style: const TextStyle(color: Color(0xFF5EEAD4), fontWeight: FontWeight.bold, fontSize: 12),
          ),
          6.heightBox,
          CopyableCodeBlock(
            code: _getSpringCode(),
            copiedMessage: isArabic ? 'تم نسخ كود SpringSimulation الحي' : 'Live SpringSimulation code copied',
          ),
        ],
      ),
    );
  }

  Widget _buildSlider({
    required String label,
    required double value,
    required double min,
    required double max,
    required Color activeColor,
    required ValueChanged<double> onChanged,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontSize: 11.5, color: Colors.white70)),
        Slider(
          value: value,
          min: min,
          max: max,
          activeColor: activeColor,
          inactiveColor: const Color(0xFF1E293B),
          onChanged: onChanged,
        ),
      ],
    );
  }
}
