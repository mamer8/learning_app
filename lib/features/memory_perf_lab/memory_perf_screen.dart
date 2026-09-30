import 'dart:async';
import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';

/// شاشة مختبر تحسين الذاكرة وتفادي تسريبات RAM
class MemoryPerfScreen extends StatefulWidget {
  const MemoryPerfScreen({super.key});

  @override
  State<MemoryPerfScreen> createState() => _MemoryPerfScreenState();
}

class _MemoryPerfScreenState extends State<MemoryPerfScreen> {
  // محاكاة تسريب الذاكرة (Memory Leak Simulation)
  final List<StreamController> _leakedControllers = [];
  final List<List<int>> _allocatedMemoryChunks = [];
  double _simulatedRamMb = 18.5; // الحجم الأساسي للتطبيق

  // صورة مع أو بدون Downsampling
  bool _useDownsampling = true;

  void _openAiAssistant(bool isArabic) {
    ContextualAiSheet.show(
      context,
      topicTitle: isArabic ? 'مختبر تسريبات الذاكرة والأداء' : 'Memory Leaks & Profiling Lab',
      topicCode: _buildDynamicMemoryCode(isArabic),
      levelTitle: 'مستوى خبير (Senior Performance & Memory Profiling)',
      isArabic: isArabic,
    );
  }

  String _buildDynamicMemoryCode(bool isArabic) {
    return '// === 1. Proper Disposal & Memory Leak Prevention ===\n'
        'class SafeStatefulWidgetState extends State<SafeStatefulWidget> {\n'
        '  // عدد الـ Controllers النشطة الآن: ${_leakedControllers.length} (استهلاك RAM: ${_simulatedRamMb.toStringAsFixed(1)} MB)\n'
        '  late final StreamController<int> _controller;\n'
        '  late final TextEditingController _textController;\n\n'
        '  @override\n'
        '  void initState() {\n'
        '    super.initState();\n'
        '    _controller = StreamController<int>.broadcast();\n'
        '    _textController = TextEditingController();\n'
        '  }\n\n'
        '  @override\n'
        '  void dispose() {\n'
        '    // تنظيف جميع الكائنات المستهلكة للذاكرة لمنع التسريب\n'
        '    _controller.close();\n'
        '    _textController.dispose();\n'
        '    super.dispose();\n'
        '  }\n'
        '}\n\n'
        '// === 2. Image Downsampling (ResizeImage) ===\n'
        '// وضع Downsampling الحالي: ${_useDownsampling ? "مفعل (40 KB في GPU)" : "معطل (24 MB خطر تسريب OOM!)"}\n'
        'Widget buildOptimizedImage() {\n'
        '  return Image(\n'
        '${_useDownsampling ? "    image: ResizeImage(\n      NetworkImage('https://example.com/large_4k.png'),\n      width: 100,\n      height: 100,\n      allowUpscaling: false,\n    )," : "    image: NetworkImage('https://example.com/large_4k.png'), // فك تشفير 4K كامل!"}\n'
        '    width: 50,\n'
        '    height: 50,\n'
        '  );\n'
        '}';
  }

  void _createMemoryLeak() {
    setState(() {
      // إنشاء Controllers ومؤقتات مهملة لا يتم غلقها
      final controller = StreamController<String>.broadcast();
      _leakedControllers.add(controller);
      // تخصيص بايتات في الذاكرة لمحاكاة تسريب
      _allocatedMemoryChunks.add(List<int>.filled(500000, 1)); // ~2MB
      _simulatedRamMb += 4.0;
    });
  }

  void _runGarbageCollector() {
    setState(() {
      for (final c in _leakedControllers) {
        c.close();
      }
      _leakedControllers.clear();
      _allocatedMemoryChunks.clear();
      _simulatedRamMb = 18.5;
    });
  }

  @override
  void dispose() {
    for (final c in _leakedControllers) {
      c.close();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final isArabic = locale.isArabic;

    final isHighMemory = _simulatedRamMb > 35;

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isArabic ? 'مختبر تسريبات الذاكرة والأداء' : 'Memory Leaks & Profiling Lab'),
          actions: [
            IconButton(
              icon: const Icon(Icons.auto_awesome, color: Color(0xFFF87171)),
              tooltip: isArabic ? 'اسأل الذكاء الاصطناعي عن إدارة الذاكرة' : 'Ask AI Copilot',
              onPressed: () => _openAiAssistant(isArabic),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          backgroundColor: const Color(0xFFDC2626),
          foregroundColor: Colors.white,
          icon: const Icon(Icons.auto_awesome),
          label: Text(
            isArabic ? 'اسأل الـ AI عن الذاكرة' : 'Ask Memory AI',
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          onPressed: () => _openAiAssistant(isArabic),
        ),
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          children: [
            _buildIntroCard(isArabic),
            16.heightBox,

            // مقياس الذاكرة الحي (RAM Gauge)
            _buildRamGauge(isArabic, isHighMemory),
            16.heightBox,

            // محاكي التسريب والتحكم
            _buildLeakSimulator(isArabic),
            16.heightBox,

            // فحص الصور وتحجيم الذاكرة (Image Downsampling)
            _buildImageOptimizationSection(isArabic),
            16.heightBox,

            // الكود الجاهز للنسخ والتفاعل
            _buildCodeSnippetCard(isArabic),
            24.heightBox,
          ],
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
        border: Border.all(color: const Color(0xFFEF4444).withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFEF4444).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.memory_rounded, color: Color(0xFFF87171), size: 24),
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'إدارة الذاكرة ومنع Out-Of-Memory' : 'Memory Profiling & Leaks Prevention',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                ),
                4.heightBox,
                Text(
                  isArabic
                      ? 'النسيان في إغلاق StreamSubscription أو TextEditingController أو تحميل صور 4K بدون ResizeImage يؤدي لامتلاء RAM وانهيار التطبيق فجأة.'
                      : 'Unclosed streams and full-resolution image decoding cause severe memory leaks and OOM crashes.',
                  style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildRamGauge(bool isArabic, bool isHighMemory) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: isHighMemory ? const Color(0xFFEF4444) : const Color(0xFF10B981)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic ? 'مؤشر استهلاك الـ Heap Memory (RAM):' : 'Heap RAM Footprint:',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
              ),
              Text(
                '${_simulatedRamMb.toStringAsFixed(1)} MB',
                style: TextStyle(
                  color: isHighMemory ? const Color(0xFFF87171) : const Color(0xFF34D399),
                  fontWeight: FontWeight.w900,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          12.heightBox,

          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: (_simulatedRamMb / 60.0).clamp(0.0, 1.0),
              minHeight: 12,
              backgroundColor: const Color(0xFF1E293B),
              valueColor: AlwaysStoppedAnimation(
                isHighMemory ? const Color(0xFFEF4444) : const Color(0xFF10B981),
              ),
            ),
          ),
          8.heightBox,

          if (isHighMemory)
            Row(
              children: [
                const Icon(Icons.warning_amber_rounded, color: Color(0xFFF87171), size: 16),
                6.widthBox,
                Expanded(
                  child: Text(
                    isArabic
                        ? 'تحذير: استهلاك غير طبيعي للذاكرة بسبب StreamControllers غير مغلقة!'
                        : 'Warning: Abnormal memory footprint detected due to unclosed streams!',
                    style: const TextStyle(color: Color(0xFFF87171), fontSize: 11, fontWeight: FontWeight.bold),
                  ),
                ),
              ],
            ),
        ],
      ),
    );
  }

  Widget _buildLeakSimulator(bool isArabic) {
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
            isArabic ? '1. محاكاة إنشاء تسريبات (Memory Leaks Sim):' : '1. Memory Leaks Simulator:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
          ),
          8.heightBox,
          Text(
            isArabic
                ? 'عدد الـ Listeners العالقة في الذاكرة دون dispose(): ${_leakedControllers.length}'
                : 'Undisposed StreamControllers leaking in heap: ${_leakedControllers.length}',
            style: const TextStyle(fontSize: 12, color: Colors.white70),
          ),
          12.heightBox,

          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
                  onPressed: _createMemoryLeak,
                  icon: const Icon(Icons.leak_add_rounded, color: Colors.white, size: 16),
                  label: Text(isArabic ? 'تسريب +4MB كائنات' : 'Simulate +4MB Leak', style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
              8.widthBox,
              Expanded(
                child: ElevatedButton.icon(
                  style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669)),
                  onPressed: _runGarbageCollector,
                  icon: const Icon(Icons.cleaning_services_rounded, color: Colors.white, size: 16),
                  label: Text(isArabic ? 'تنظيف الذاكرة (GC)' : 'Dispose All & GC', style: const TextStyle(color: Colors.white, fontSize: 12)),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildImageOptimizationSection(bool isArabic) {
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
            isArabic ? '2. تقنية ResizeImage لتحجيم فك تشفير الصور:' : '2. ResizeImage GPU Downsampling:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
          ),
          8.heightBox,
          Text(
            isArabic
                ? 'عند عرض صورة بحجم 50x50 من خادم بجودة 4K، يؤدي تحميلها الخام لاستهلاك 32MB لكل صورة في GPU! استخدام ResizeImage يقلل الحجم لـ 50KB فقط.'
                : 'Decoding 4K raw images for thumbnail widgets consumes massive GPU buffer memory. ResizeImage scales bitmap decode size.',
            style: const TextStyle(fontSize: 11.5, color: Colors.white70),
          ),
          12.heightBox,

          SwitchListTile(
            dense: true,
            contentPadding: EdgeInsets.zero,
            title: Text(
              isArabic ? 'تفعيل ResizeImage(cacheWidth: 100)' : 'Enable ResizeImage Downsampling',
              style: const TextStyle(fontSize: 12, color: Colors.white),
            ),
            subtitle: Text(
              _useDownsampling
                  ? (isArabic ? 'حجم البايتات في الذاكرة: 40 KB' : 'Decoded GPU Memory: ~40 KB')
                  : (isArabic ? 'حجم البايتات في الذاكرة: 24 MB (خطر!)' : 'Decoded GPU Memory: ~24 MB (High)'),
              style: TextStyle(
                color: _useDownsampling ? const Color(0xFF34D399) : const Color(0xFFF87171),
                fontSize: 11,
                fontWeight: FontWeight.bold,
              ),
            ),
            value: _useDownsampling,
            onChanged: (val) => setState(() => _useDownsampling = val),
          ),
        ],
      ),
    );
  }

  Widget _buildCodeSnippetCard(bool isArabic) {
    final code = _buildDynamicMemoryCode(isArabic);

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
                isArabic ? '💻 كود إدارة الذاكرة وتفادي التسريبات الحي:' : '💻 Dynamic Memory & Disposal Code:',
                style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFEF4444).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Dynamic Live Code', style: TextStyle(color: Color(0xFFF87171), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          10.heightBox,
          CopyableCodeBlock(
            code: code,
            copiedMessage: isArabic ? 'تم نسخ كود الذاكرة المحدث' : 'Memory code copied',
            copyTooltip: isArabic ? 'نسخ الكود' : 'Copy Code',
          ),
        ],
      ),
    );
  }
}
