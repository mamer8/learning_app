import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';

/// 🎨 مختبر الـ RepaintBoundary وتحسين أداء الرسوميات
/// يوضح كيف يعزل Flutter عمليات الرسم (Painting) لمنع إعادة رسم العناصر الثابتة المجاورة
class RepaintBoundaryScreen extends StatefulWidget {
  const RepaintBoundaryScreen({super.key});

  @override
  State<RepaintBoundaryScreen> createState() => _RepaintBoundaryScreenState();
}

class _RepaintBoundaryScreenState extends State<RepaintBoundaryScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isRepaintBoundaryEnabled = true;

  // عدادات لمحاكاة عدد مرات الرسم
  int _animatedRepaintCount = 0;
  int _staticRepaintCount = 0;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 3),
    )..repeat();

    _animationController.addListener(() {
      setState(() {
        _animatedRepaintCount++;
        // إذا كان الـ RepaintBoundary معطلاً، فإن إعادة رسم العنصر المتحرك يجر معه العنصر الثابت
        if (!_isRepaintBoundaryEnabled) {
          _staticRepaintCount++;
        }
      });
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  void _resetCounters() {
    setState(() {
      _animatedRepaintCount = 0;
      _staticRepaintCount = 0;
    });
  }

  String _getRepaintCode() {
    return '// هيكل شجرة الرسم الحالية (${_isRepaintBoundaryEnabled ? "✅ العزل مفعل" : "❌ العزل معطل"})\n'
        'Row(\n'
        '  children: [\n'
        '    ${_isRepaintBoundaryEnabled ? "RepaintBoundary(\n      child: HeavyPulseAnimationWidget(), // طبقة منفصلة في GPU\n    )" : "HeavyPulseAnimationWidget(), // ⚠️ يسبب إعادة رسم الـ StaticWidget المجاورة معه"},\n'
        '    StaticCardWidget(), // عداد إعادة رسمه: ${_isRepaintBoundaryEnabled ? "0 (محمي)" : "$_staticRepaintCount (إهدار معالجة!)"}\n'
        '  ],\n'
        ');';
  }

  void _openAiCopilot(BuildContext context) {
    ContextualAiSheet.show(
      context,
      topicTitle: 'مختبر الـ RepaintBoundary وتحسين الرسوميات',
      topicCode: _getRepaintCode(),
      levelTitle: 'تحسين الرسوميات وعزل طبقات الـ GPU',
      isArabic: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('مختبر RepaintBoundary والأداء'),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            tooltip: 'اسأل المساعد الذكي',
            icon: const Icon(Icons.psychology_rounded, color: Color(0xFF14B8A6)),
            onPressed: () => _openAiCopilot(context),
          ),
          IconButton(
            tooltip: 'تصفير العدادات',
            onPressed: _resetCounters,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAiCopilot(context),
        icon: const Icon(Icons.psychology_rounded, color: Color(0xFF04111C)),
        label: const Text(
          'اسأل المساعد الذكي عن هذا الكود',
          style: TextStyle(color: Color(0xFF04111C), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF14B8A6),
      ),
      body: ResponsiveContentWrapper(
        maxWidth: 1200,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. بطاقة الشرح النظري المتقدم
              _buildConceptExplanationCard(),
              16.heightBox,

              // 2. مفتاح التحكم التفاعلي (Toggle Switch)
              _buildToggleControlCard(),
              16.heightBox,

              // 3. مساحة المقارنة البصرية الحية (Live Visual Benchmark)
              _buildInteractiveBenchmarkingArea(),
              16.heightBox,

              // 4. بطاقة شرح طبقات المعالجة في Flutter (Pipeline Stages)
              _buildPipelineExplanationCard(),
              16.heightBox,

              // 5. نصائح وتوصيات متقدمة (Best Practices)
              _buildBestPracticesCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildConceptExplanationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(color: Colors.tealAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.speed_rounded, color: Colors.tealAccent, size: 24),
              8.widthBox,
              const Text(
                'ما هو الـ RepaintBoundary وكيف يعمل؟',
                style: TextStyle(
                  color: Colors.tealAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          8.heightBox,
          const Text(
            'في Flutter، عندما يتغير ويدجت متحرك، يقوم المحرك بوضع علامة "Dirty" على شجرة الرسم (Render Tree). إذا لم يكن هناك حاجز عزل (RepaintBoundary)، قد يعيد Flutter رسم كامل الشاشة والشاشات المجاورة!\n'
            '🔹 RepaintBoundary يُنشئ طبقة رسومية مستقلة (RenderRepaintBoundary Layer) في الـ Layer Tree، مما يمنع انتشار إعادة الرسم خارج حدوده.',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildToggleControlCard() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(
          color: _isRepaintBoundaryEnabled ? Colors.greenAccent : Colors.redAccent,
          width: 1.5,
        ),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  _isRepaintBoundaryEnabled
                      ? '✅ عزل الرسم مُفعل (RepaintBoundary Active)'
                      : '❌ عزل الرسم مُعطل (Full Subtree Repainting)',
                  style: TextStyle(
                    color: _isRepaintBoundaryEnabled ? Colors.greenAccent : Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 13,
                  ),
                ),
                4.heightBox,
                Text(
                  _isRepaintBoundaryEnabled
                      ? 'العنصر المتحرك معزول تماماً في طبقة مستقلة ولن يزعج العناصر المجاورة.'
                      : 'إعادة رسم الأنيميشن تتسرب وتعيد رسم البطاقة المجاورة بدون داعٍ!',
                  style: const TextStyle(color: Colors.white54, fontSize: 11),
                ),
              ],
            ),
          ),
          Switch(
            value: _isRepaintBoundaryEnabled,
            activeThumbColor: Colors.greenAccent,
            onChanged: (val) {
              setState(() {
                _isRepaintBoundaryEnabled = val;
              });
              if (val) {
                context.showSuccessSnackBar(
                  'تم تفعيل RepaintBoundary! العناصر الثابتة معزولة الآن عن الرسم.',
                  title: 'تحسين الأداء',
                );
              } else {
                context.showErrorSnackBar(
                  'تم تعطيل RepaintBoundary! الرسم يتسرب الآن للعناصر المجاورة.',
                  title: 'تسرب الرسم',
                );
              }
            },
          ),
        ],
      ),
    );
  }

  Widget _buildInteractiveBenchmarkingArea() {
    return Column(
      children: [
        Row(
          children: [
            // العنصر المتحرك باستمرار
            Expanded(
              child: _isRepaintBoundaryEnabled
                  ? RepaintBoundary(child: _buildAnimatedComplexWidget())
                  : _buildAnimatedComplexWidget(),
            ),
            12.widthBox,
            // العنصر الثابت المجاور
            Expanded(
              child: _buildStaticHeavyWidget(),
            ),
          ],
        ),
      ],
    );
  }

  Widget _buildAnimatedComplexWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(
          color: _isRepaintBoundaryEnabled ? Colors.greenAccent.withValues(alpha: 0.5) : Colors.redAccent.withValues(alpha: 0.5),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '💫 عنصر دائم الحركة\n(High Frequency Animation)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          12.heightBox,
          AnimatedBuilder(
            animation: _animationController,
            builder: (context, child) {
              return Transform.rotate(
                angle: _animationController.value * 2 * pi,
                child: Container(
                  width: 65,
                  height: 65,
                  decoration: BoxDecoration(
                    gradient: const SweepGradient(
                      colors: [Colors.purpleAccent, Colors.cyanAccent, Colors.amberAccent, Colors.purpleAccent],
                    ),
                    borderRadius: 20.circularRadius,
                  ),
                  child: const Center(
                    child: Icon(Icons.palette_rounded, color: Colors.white, size: 30),
                  ),
                ),
              );
            },
          ),
          12.heightBox,
          Text(
            'عدد دورات الرسم:\n$_animatedRepaintCount Paint ticks',
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.cyanAccent, fontSize: 11, fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }

  Widget _buildStaticHeavyWidget() {
    return Container(
      padding: const EdgeInsets.all(16),
      height: 220,
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(
          color: _isRepaintBoundaryEnabled ? Colors.white12 : Colors.redAccent.withValues(alpha: 0.8),
        ),
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            '🏛️ بطاقة ثابتة معقدة\n(Static Heavy Card)',
            textAlign: TextAlign.center,
            style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          12.heightBox,
          Icon(
            Icons.dashboard_customize_rounded,
            color: _isRepaintBoundaryEnabled ? Colors.blueAccent : Colors.redAccent,
            size: 40,
          ),
          12.heightBox,
          Text(
            _isRepaintBoundaryEnabled
                ? 'عدد مرات إعادة رسمها:\n0 (معزولة ومحفوظة)'
                : 'عدد مرات إعادة رسمها:\n$_staticRepaintCount (مهدورة!)',
            textAlign: TextAlign.center,
            style: TextStyle(
              color: _isRepaintBoundaryEnabled ? Colors.greenAccent : Colors.redAccent,
              fontSize: 11,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineExplanationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📐 مراحل خط إنتاج الرسوميات في Flutter (Rendering Pipeline)',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          12.heightBox,
          _buildStageRow('1. مرحلة البناء (Build)', 'إنشاء شجرة الـ Widgets والـ Elements', Colors.amberAccent),
          _buildStageRow('2. مرحلة القياس والموضع (Layout)', 'حساب أحجام الـ RenderBoxes ومواقعها', Colors.blueAccent),
          _buildStageRow('3. مرحلة الرسم (Paint)', 'تسجيل أوامر الرسم على الـ Canvas إلى PaintingContext', Colors.purpleAccent),
          _buildStageRow('4. مرحلة التجميع (Composite)', 'دمج الطبقات (Layers) وإرسالها لـ GPU / Skia / Impeller', Colors.greenAccent),
        ],
      ),
    );
  }

  Widget _buildStageRow(String stage, String desc, Color color) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            width: 10,
            height: 10,
            margin: const EdgeInsets.only(top: 4, left: 8),
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          8.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(stage, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                Text(desc, style: const TextStyle(color: Colors.white60, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBestPracticesCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💡 متى تستخدم RepaintBoundary ومتى تتجنبه؟',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          8.heightBox,
          const Text(
            '✅ استخدمه عندما:\n'
            '  • لديك ويدجت يعيد الرسم بمعدل 60fps (مثل عداد رقمي، موجات صوتية، أو رادار) ومحاط بويدجتس ثابتة.\n'
            '  • لديك عناصر مخصصة بالـ CustomPainter تأخذ وقتاً طويلاً في حسابات الرسم.\n'
            '  • ترغب في التقاط صورة (Screenshot) لجزء معين من الشاشة عبر `RenderRepaintBoundary.toImage()`.\n\n'
            '❌ تجنبه عندما:\n'
            '  • يكون الويدجت بسيطاً جداً (مثل أيقونة أو نص عادي)؛ لأن إنشاء طبقة مستقلة في الـ GPU يستهلك ذاكرة إضافية (Overhead) أكبر من تكلفة إعادة رسمها!',
            style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
          ),
          14.heightBox,
          const Text(
            '💻 كود الاستخدام وعزل الرسم (يتغير ديناميكياً مع التبديل):',
            style: TextStyle(color: Colors.tealAccent, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          8.heightBox,
          CopyableCodeBlock(
            code: _getRepaintCode(),
            copiedMessage: 'تم نسخ كود RepaintBoundary',
            copyTooltip: 'نسخ الكود',
          ),
        ],
      ),
    );
  }
}
