import 'dart:isolate';
import 'dart:math';
import 'package:flutter/material.dart';
import '../../core/core.dart';

/// 🧪 مختبر الـ Isolates والـ Concurrency
/// يوضح الفرق الجوهري بين تشغيل العمليات الثقيلة على الـ Main Thread (UI Thread)
/// وبين تفويضها إلى Background Isolate عبر `Isolate.run()`.
class IsolatesScreen extends StatefulWidget {
  const IsolatesScreen({super.key});

  @override
  State<IsolatesScreen> createState() => _IsolatesScreenState();
}

class _IsolatesScreenState extends State<IsolatesScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _animationController;
  bool _isProcessing = false;
  String _statusMessage = 'جاهز للتجربة... انقر على أحد الأزرار للمقارنة';
  int _lastExecutionTimeMs = 0;
  int _totalProcessed = 0;
  String? _modeUsed;

  @override
  void initState() {
    super.initState();
    // أنيميشن مستمر لبيان سلاسة الواجهة أو تجمّدها
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    )..repeat();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  /// ❌ 1. تشغيل العملية الثقيلة مباشرة على الـ Main Thread
  /// النتيجة: تجمد كامل للشاشة (UI Freeze / Frame Drops) لأن الـ Event Loop أصبح مشغولاً بالحسابات
  void _runOnMainThread() {
    setState(() {
      _isProcessing = true;
      _modeUsed = 'Main Thread (تجميد الواجهة)';
      _statusMessage = 'جاري الحساب على الـ Main Thread... لاحظ تجمد المؤشر!';
    });

    // استخدام postFrameCallback لضمان تحديث الـ UI قبل بدء العملية المعطلة
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final stopwatch = Stopwatch()..start();

      // عملية ثقيلة متزامنة تعطل الـ Event Loop
      final result = _heavyTask(250000);

      stopwatch.stop();

      setState(() {
        _isProcessing = false;
        _lastExecutionTimeMs = stopwatch.elapsedMilliseconds;
        _totalProcessed = result;
        _statusMessage =
            '⚠️ تم الانتهاء! تجمّدت الواجهة تماماً لـ ${_lastExecutionTimeMs}ms لأن الـ Main Thread كان محجوزاً.';
      });

      context.showErrorSnackBar(
        'تم تنفيذ العملية على Main Thread وتسببت في تجمد الشاشة!',
        title: 'تنبيه الأداء',
      );
    });
  }

  /// ✅ 2. تشغيل العملية عبر Isolate.run()
  /// النتيجة: الواجهة تعمل بسلاسة فائقة (60/120 FPS) والعملية تتم في Thread مستقل
  Future<void> _runOnBackgroundIsolate() async {
    setState(() {
      _isProcessing = true;
      _modeUsed = 'Isolate.run() (سلاسة تامة)';
      _statusMessage = 'جاري الحساب في Isolate منفصل... لاحظ استمرار دوران المؤشر!';
    });

    final stopwatch = Stopwatch()..start();

    // Isolate.run ينشئ Worker Isolate، ينفذ الدالة، ويعيد النتيجة دون إيقاف الـ Main Isolate
    final result = await Isolate.run(() => _heavyTask(250000));

    stopwatch.stop();

    if (!mounted) return;

    setState(() {
      _isProcessing = false;
      _lastExecutionTimeMs = stopwatch.elapsedMilliseconds;
      _totalProcessed = result;
      _statusMessage =
          '⚡ تم الانتهاء بنجاح خلال ${_lastExecutionTimeMs}ms مع الحفاظ على دوران المؤشر وسلاسة الـ UI بنسبة 100%!';
    });

    context.showSuccessSnackBar(
      'تم تنفيذ العملية بسلاسة تامة دون إسقاط إطار واحد!',
      title: 'أداء فائق',
    );
  }

  /// دالة الحسابات الثقيلة: توليد أعداد أولية وحسابات معقدة
  /// ملحوظة: دوال الـ Isolate يجب أن تكون Static أو Top-level أو تقبل التمرير كـ Closure مستقل
  static int _heavyTask(int count) {
    int primeCount = 0;
    for (int i = 2; i <= count; i++) {
      bool isPrime = true;
      for (int j = 2; j <= sqrt(i).toInt(); j++) {
        if (i % j == 0) {
          isPrime = false;
          break;
        }
      }
      if (isPrime) primeCount++;
    }
    return primeCount;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('مختبر الـ Isolates والـ Concurrency'),
        backgroundColor: const Color(0xFF1E293B),
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // بطاقة الشرح النظري المباشر
            Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF1E293B), Color(0xFF334155)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: 16.circularRadius,
                border: Border.all(color: Colors.cyan.withValues(alpha: 0.3)),
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      const Icon(Icons.psychology_outlined, color: Colors.cyan, size: 24),
                      8.widthBox,
                      const Text(
                        'لماذا نحتاج الـ Isolates في Dart؟',
                        style: TextStyle(
                          color: Colors.cyan,
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                        ),
                      ),
                    ],
                  ),
                  8.heightBox,
                  const Text(
                    'لغة Dart تعمل بـ Single Thread وبنظام الـ Event Loop. العمليات الثقيلة (JSON كبير، معالجة صور، تشفير) تحجب الـ Main Thread وتتسبب في إسقاط الإطارات (UI Jank/Freeze). الـ Isolate هو خيط معالجة مستقل تماماً بذاكرته الخاصة.',
                    style: TextStyle(color: Colors.white70, height: 1.5, fontSize: 13),
                  ),
                ],
              ),
            ),
            20.heightBox,

            // مؤشر دوران تفاعلي لمراقبة سلاسة الواجهة (Visual FPS Indicator)
            Container(
              padding: const EdgeInsets.symmetric(vertical: 24, horizontal: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF1E293B),
                borderRadius: 20.circularRadius,
                border: Border.all(
                  color: _isProcessing
                      ? (_modeUsed?.contains('Main') == true ? Colors.red : Colors.green)
                      : Colors.white10,
                  width: 2,
                ),
              ),
              child: Column(
                children: [
                  const Text(
                    'مؤشر استجابة الواجهة (UI Responsiveness Indicator)',
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                  const Text(
                    'إذا كان يدور بسلاسة فالواجهة حية، إذا توقف فالـ Main Thread تجمّد!',
                    style: TextStyle(color: Colors.white54, fontSize: 12),
                  ),
                  20.heightBox,
                  RotationTransition(
                    turns: _animationController,
                    child: Container(
                      width: 90,
                      height: 90,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        gradient: SweepGradient(
                          colors: [
                            Colors.cyan,
                            Colors.purpleAccent,
                            Colors.amber,
                            Colors.cyan,
                          ],
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: Colors.cyan.withValues(alpha: 0.4),
                            blurRadius: 20,
                            spreadRadius: 2,
                          ),
                        ],
                      ),
                      child: Center(
                        child: Container(
                          width: 70,
                          height: 70,
                          decoration: const BoxDecoration(
                            color: Color(0xFF0F172A),
                            shape: BoxShape.circle,
                          ),
                          child: const Icon(Icons.bolt, color: Colors.cyan, size: 36),
                        ),
                      ),
                    ),
                  ),
                  16.heightBox,
                  Text(
                    _statusMessage,
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      color: _isProcessing
                          ? Colors.amberAccent
                          : (_modeUsed?.contains('Main') == true
                              ? Colors.redAccent
                              : Colors.greenAccent),
                      fontSize: 13,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ],
              ),
            ),
            24.heightBox,

            // أزرار المقارنة التفاعلية
            Row(
              children: [
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _runOnMainThread,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFFDC2626),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: 12.circularRadius,
                      ),
                    ),
                    icon: const Icon(Icons.block_rounded),
                    label: const Text(
                      'Main Thread\n(تجميد الواجهة)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
                12.widthBox,
                Expanded(
                  child: ElevatedButton.icon(
                    onPressed: _isProcessing ? null : _runOnBackgroundIsolate,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF10B981),
                      foregroundColor: Colors.white,
                      padding: const EdgeInsets.symmetric(vertical: 16),
                      shape: RoundedRectangleBorder(
                        borderRadius: 12.circularRadius,
                      ),
                    ),
                    icon: const Icon(Icons.rocket_launch_rounded),
                    label: const Text(
                      'Isolate.run()\n(سلاسة تامة)',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
                    ),
                  ),
                ),
              ],
            ),
            24.heightBox,

            // لوحة المقاييس والنتائج (Live Metrics Card)
            if (_lastExecutionTimeMs > 0) ...[
              Container(
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
                      '📊 إحصائيات المعالجة (Execution Metrics)',
                      style: TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 15,
                      ),
                    ),
                    12.heightBox,
                    _buildMetricRow('النمط المستخدم:', _modeUsed ?? 'غير محدد', Colors.white70),
                    _buildMetricRow('زمن التنفيذ الكلي:', '$_lastExecutionTimeMs ms', Colors.amber),
                    _buildMetricRow(
                      'عدد الأعداد الأولية المكتشفة:',
                      '$_totalProcessed عدد',
                      Colors.cyanAccent,
                    ),
                    _buildMetricRow('نطاق البحث:', '250,000 رقم', Colors.white70),
                  ],
                ),
              ),
            ],
          ],
        ),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white54, fontSize: 13)),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              value,
              style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 13),
            ),
          ),
        ],
      ),
    );
  }
}
