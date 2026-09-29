import 'package:flutter/material.dart';
import '../../core/core.dart';

/// 🔍 مختبر الـ Debouncer والـ Throttler
/// شاشة تفاعلية تشرح كيفية ترشيد استهلاك الشبكة وحماية أزرار التطبيق
class DebouncerScreen extends StatefulWidget {
  const DebouncerScreen({super.key});

  @override
  State<DebouncerScreen> createState() => _DebouncerScreenState();
}

class _DebouncerScreenState extends State<DebouncerScreen> {
  // كائنات التحكم في معدل الاستدعاء
  late Debouncer _debouncer;
  late Throttler _throttler;

  final TextEditingController _searchController = TextEditingController();

  // إحصائيات البحث والـ Debouncer
  int _rawKeystrokeCount = 0;
  int _actualApiCallCount = 0;
  int _debounceDurationMs = 500;
  bool _isSearching = false;
  List<String> _searchResults = [];
  final List<String> _timelineLogs = [];

  // إحصائيات الـ Throttler
  int _rawButtonClickCount = 0;
  int _actualButtonExecutedCount = 0;
  int _throttledBlockedCount = 0;
  bool _isThrottlingActive = false;

  // قاعدة بيانات وهمية للبحث
  final List<String> _mockDatabase = [
    'Flutter State Management (Bloc / Cubit)',
    'Flutter RepaintBoundary Optimization',
    'Dart Isolates & Multi-threading',
    'Flutter 3 Trees: Widget, Element, RenderObject',
    'Clean Architecture in Flutter',
    'Functional Error Handling with dartz Either',
    'Equatable in Dart & Value Equality',
    'InheritedWidget & BuildContext Mechanics',
    'Custom Painters & Canvas in Flutter',
    'Flutter Slivers & High Performance Lists',
  ];

  @override
  void initState() {
    super.initState();
    _debouncer = Debouncer(delay: Duration(milliseconds: _debounceDurationMs));
    _throttler = Throttler(interval: const Duration(milliseconds: 1000));
  }

  @override
  void dispose() {
    _searchController.dispose();
    _debouncer.dispose();
    _throttler.dispose();
    super.dispose();
  }

  void _onSearchChanged(String query) {
    setState(() {
      _rawKeystrokeCount++;
      _addLog('⌨️ نقرة حرف جديدة: "$query" (طلب خام رقم $_rawKeystrokeCount)');
    });

    // استخدام الـ Debouncer لتأجيل استدعاء الـ API حتى يتوقف المستخدم عن الكتابة
    _debouncer.run(() {
      _performApiSearch(query);
    });
  }

  Future<void> _performApiSearch(String query) async {
    if (!mounted) return;

    setState(() {
      _actualApiCallCount++;
      _isSearching = true;
      _addLog('🚀 تم إرسال طلب API الفعلي للبحث عن: "$query" (طلب رقم $_actualApiCallCount)');
    });

    // محاكاة تأخير الشبكة (Network Latency)
    await Future.delayed(const Duration(milliseconds: 400));

    if (!mounted) return;

    setState(() {
      _isSearching = false;
      if (query.trim().isEmpty) {
        _searchResults = [];
      } else {
        _searchResults = _mockDatabase
            .where((item) => item.toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  void _onThrottleButtonClicked() {
    setState(() {
      _rawButtonClickCount++;
    });

    // محاولة تنفيذ العملية عبر Throttler
    final executed = _throttler.run(() {
      setState(() {
        _actualButtonExecutedCount++;
        _isThrottlingActive = true;
      });

      context.showSuccessSnackBar(
        'تم تنفيذ العملية رقم $_actualButtonExecutedCount بنجاح!',
        title: 'Throttler Executed',
      );

      // إعادة حالة المؤشر البصري بعد ثانية
      Future.delayed(const Duration(milliseconds: 1000), () {
        if (mounted) {
          setState(() {
            _isThrottlingActive = false;
          });
        }
      });
    });

    if (!executed) {
      setState(() {
        _throttledBlockedCount++;
      });
      context.showInfoSnackBar(
        'تم حجب النقرة السريعة بواسطة الـ Throttler لمنع السبام!',
        title: 'Throttler Blocked',
      );
    }
  }

  void _addLog(String message) {
    final now = DateTime.now();
    final timeStr = '${now.hour}:${now.minute}:${now.second}.${now.millisecond}';
    _timelineLogs.insert(0, '[$timeStr] $message');
    if (_timelineLogs.length > 20) {
      _timelineLogs.removeLast();
    }
  }

  void _resetCounters() {
    setState(() {
      _rawKeystrokeCount = 0;
      _actualApiCallCount = 0;
      _rawButtonClickCount = 0;
      _actualButtonExecutedCount = 0;
      _throttledBlockedCount = 0;
      _searchResults.clear();
      _searchController.clear();
      _timelineLogs.clear();
    });
  }

  @override
  Widget build(BuildContext context) {
    final savingsPercent = _rawKeystrokeCount > 0
        ? (((_rawKeystrokeCount - _actualApiCallCount) / _rawKeystrokeCount) * 100).clamp(0, 100).toInt()
        : 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('مختبر Debouncer & Throttler'),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            tooltip: 'إعادة تصفير العدادات',
            onPressed: _resetCounters,
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. بطاقة الشرح المفصل (Educational Explanations Card)
            _buildEducationalCard(),
            16.heightBox,

            // 2. بطاقة مقارنة وفورات الـ Debouncer المباشرة
            _buildDebouncerStatsCard(savingsPercent),
            16.heightBox,

            // 3. حقل البحث التفاعلي
            _buildSearchInputSection(),
            16.heightBox,

            // 4. نتائج البحث الحية
            _buildSearchResultsList(),
            20.heightBox,

            // 5. قسم الـ Throttler التجريبي
            _buildThrottlerSection(),
            20.heightBox,

            // 6. سجل الأحداث التفاعلي (Timeline Logs)
            _buildTimelineSection(),
            16.heightBox,

            // 7. الأكواد القابلة للنسخ
            _buildCodeSnippetsSection(),
          ],
        ),
      ),
    );
  }

  Widget _buildEducationalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(color: Colors.amber.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.menu_book_rounded, color: Colors.amber, size: 24),
              8.widthBox,
              const Text(
                'الفرق بين Debouncer و Throttler',
                style: TextStyle(
                  color: Colors.amber,
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          8.heightBox,
          const Text(
            '🔹 Debouncer: يؤجل التنفيذ حتى يتوقف المستخدم عن النشاط لفترة محددة (مثل حقول البحث لمنع إرسال طلب مع كل حرف مكتوب).\n'
            '🔹 Throttler: ينفذ الطلب الأول فوراً، ثم يقفل الباب ويتجاهل أي نقرات إضافية حتى تنقضي المهلة المحددة (مثل أزرار الدفع والتسجيل والإعجاب).',
            style: TextStyle(color: Colors.white70, fontSize: 13, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildDebouncerStatsCard(int savingsPercent) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF1E293B), Color(0xFF2D3748)],
        ),
        borderRadius: 16.circularRadius,
        border: Border.all(color: Colors.blueAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          const Text(
            '📊 لوحة مقارنة استهلاك الطلبات الحية',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 15),
          ),
          16.heightBox,
          Row(
            children: [
              Expanded(
                child: _buildMetricTile(
                  title: 'الطلبات بدون Debounce\n(ضربات المفاتيح)',
                  value: '$_rawKeystrokeCount',
                  color: Colors.redAccent,
                  icon: Icons.keyboard_rounded,
                ),
              ),
              8.widthBox,
              Expanded(
                child: _buildMetricTile(
                  title: 'طلبات الـ API الفعلية\n(بعد الفلترة)',
                  value: '$_actualApiCallCount',
                  color: Colors.greenAccent,
                  icon: Icons.cloud_done_rounded,
                ),
              ),
              8.widthBox,
              Expanded(
                child: _buildMetricTile(
                  title: 'نسبة التوفير\n(Bandwidth Saved)',
                  value: '$savingsPercent%',
                  color: Colors.cyanAccent,
                  icon: Icons.savings_rounded,
                ),
              ),
            ],
          ),
          12.heightBox,
          // شريط ضبط وقت الـ Debounce
          Row(
            children: [
              Text(
                'مهلة التأخير: $_debounceDurationMs ms',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Expanded(
                child: Slider(
                  value: _debounceDurationMs.toDouble(),
                  min: 200,
                  max: 1500,
                  divisions: 13,
                  activeColor: Colors.blueAccent,
                  onChanged: (val) {
                    setState(() {
                      _debounceDurationMs = val.toInt();
                      _debouncer = Debouncer(delay: Duration(milliseconds: _debounceDurationMs));
                    });
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMetricTile({
    required String title,
    required String value,
    required Color color,
    required IconData icon,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
      decoration: BoxDecoration(
        color: const Color(0xFF0F172A),
        borderRadius: 12.circularRadius,
        border: Border.all(color: color.withValues(alpha: 0.3)),
      ),
      child: Column(
        children: [
          Icon(icon, color: color, size: 22),
          6.heightBox,
          Text(
            value,
            style: TextStyle(color: color, fontSize: 20, fontWeight: FontWeight.bold),
          ),
          4.heightBox,
          Text(
            title,
            textAlign: TextAlign.center,
            style: const TextStyle(color: Colors.white54, fontSize: 10, height: 1.2),
          ),
        ],
      ),
    );
  }

  Widget _buildSearchInputSection() {
    return TextField(
      controller: _searchController,
      onChanged: _onSearchChanged,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        filled: true,
        fillColor: const Color(0xFF1E293B),
        hintText: 'اكتب للبحث الفوري (مثال: flutter, isolate, keys)...',
        hintStyle: const TextStyle(color: Colors.white38, fontSize: 13),
        prefixIcon: const Icon(Icons.search_rounded, color: Colors.blueAccent),
        suffixIcon: _isSearching
            ? const Padding(
                padding: EdgeInsets.all(12.0),
                child: SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Colors.blueAccent),
                ),
              )
            : (_searchController.text.isNotEmpty
                ? IconButton(
                    icon: const Icon(Icons.clear, color: Colors.white54),
                    onPressed: () {
                      _searchController.clear();
                      _onSearchChanged('');
                    },
                  )
                : null),
        border: OutlineInputBorder(
          borderRadius: 14.circularRadius,
          borderSide: BorderSide.none,
        ),
      ),
    );
  }

  Widget _buildSearchResultsList() {
    if (_searchController.text.trim().isEmpty) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 14.circularRadius,
        border: Border.all(color: Colors.white10),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            'نتائج البحث الفعلي (${_searchResults.length}):',
            style: const TextStyle(color: Colors.white70, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          8.heightBox,
          if (_searchResults.isEmpty && !_isSearching)
            const Padding(
              padding: EdgeInsets.symmetric(vertical: 12),
              child: Center(
                child: Text('لا توجد نتائج مطابقة', style: TextStyle(color: Colors.white38)),
              ),
            )
          else
            ..._searchResults.map(
              (item) => Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  children: [
                    const Icon(Icons.check_circle_outline, color: Colors.greenAccent, size: 16),
                    8.widthBox,
                    Expanded(
                      child: Text(
                        item,
                        style: const TextStyle(color: Colors.white, fontSize: 13),
                      ),
                    ),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildThrottlerSection() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(color: Colors.purpleAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.touch_app_rounded, color: Colors.purpleAccent),
              8.widthBox,
              const Text(
                'تجربة الـ Throttler (حماية الضغطات المتتالية السريعة)',
                style: TextStyle(
                  color: Colors.purpleAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 14,
                ),
              ),
            ],
          ),
          8.heightBox,
          const Text(
            'حاول الضغط بسرعة متكررة على الزر أدناه (Spam Clicking). ستلاحظ أن الـ Throttler ينفذ النقرة الأولى فوراً ثم يحجب باقي النقرات لمدة 1 ثانية.',
            style: TextStyle(color: Colors.white60, fontSize: 12),
          ),
          16.heightBox,
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: _onThrottleButtonClicked,
                  style: ElevatedButton.styleFrom(
                    backgroundColor:
                        _isThrottlingActive ? Colors.deepPurple : const Color(0xFF8B5CF6),
                    foregroundColor: Colors.white,
                    padding: const EdgeInsets.symmetric(vertical: 14),
                    shape: RoundedRectangleBorder(borderRadius: 12.circularRadius),
                  ),
                  icon: Icon(
                    _isThrottlingActive ? Icons.lock_clock_rounded : Icons.thumb_up_rounded,
                  ),
                  label: Text(
                    _isThrottlingActive ? 'Throttling (محجوب)...' : 'اضغط للتجربة (Spam Me!)',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                ),
              ),
            ],
          ),
          12.heightBox,
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(
                'النقرات الكلية: $_rawButtonClickCount',
                style: const TextStyle(color: Colors.white70, fontSize: 12),
              ),
              Text(
                'المنفذة فعلياً: $_actualButtonExecutedCount',
                style: const TextStyle(color: Colors.greenAccent, fontSize: 12, fontWeight: FontWeight.bold),
              ),
              Text(
                'المحجوبة (Blocked): $_throttledBlockedCount',
                style: const TextStyle(color: Colors.redAccent, fontSize: 12, fontWeight: FontWeight.bold),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildTimelineSection() {
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
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '⏱️ سجل الأحداث الحي (Live Event Stream)',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              if (_timelineLogs.isNotEmpty)
                Text(
                  '${_timelineLogs.length} أحداث',
                  style: const TextStyle(color: Colors.white38, fontSize: 11),
                ),
            ],
          ),
          10.heightBox,
          if (_timelineLogs.isEmpty)
            const Center(
              child: Padding(
                padding: EdgeInsets.all(16.0),
                child: Text('لا توجد أحداث بعد. ابدأ بالكتابة أو النقر أعلاه.', style: TextStyle(color: Colors.white38, fontSize: 12)),
              ),
            )
          else
            Directionality(
              textDirection: TextDirection.ltr,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const NeverScrollableScrollPhysics(),
                itemCount: _timelineLogs.length,
                itemBuilder: (context, index) {
                  final log = _timelineLogs[index];
                  final isApi = log.contains('🚀');
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 3),
                    child: Text(
                      log,
                      style: TextStyle(
                        fontFamily: 'monospace',
                        color: isApi ? Colors.greenAccent : Colors.white70,
                        fontSize: 11,
                      ),
                    ),
                  );
                },
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildCodeSnippetsSection() {
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
            '💻 الأكواد التطبيقية الجاهزة للنسخ:',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 14,
            ),
          ),
          12.heightBox,
          const Text(
            '1. كود استخدام الـ Debouncer في البحث الفوري:',
            style: TextStyle(color: Colors.amberAccent, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          8.heightBox,
          const CopyableCodeBlock(
            code:
                'final debouncer = Debouncer(delay: const Duration(milliseconds: 500));\n\n'
                'void onSearchChanged(String query) {\n'
                '  debouncer.run(() {\n'
                '    // يُستدعى فقط بعد توقف المستخدم عن الكتابة لـ 500ms\n'
                '    fetchSearchResults(query);\n'
                '  });\n'
                '}',
            copiedMessage: 'تم نسخ كود Debouncer',
            copyTooltip: 'نسخ الكود',
          ),
          16.heightBox,
          const Text(
            '2. كود استخدام الـ Throttler لحماية أزرار الدفع والتفاعل:',
            style: TextStyle(color: Colors.purpleAccent, fontSize: 12, fontWeight: FontWeight.bold),
          ),
          8.heightBox,
          const CopyableCodeBlock(
            code:
                'final throttler = Throttler(interval: const Duration(seconds: 1));\n\n'
                'void onPayButtonClicked() {\n'
                '  throttler.run(() {\n'
                '    // يُنفذ فوراً ثم يتجاهل أي نقرات إضافية لمدة 1 ثانية\n'
                '    processPayment();\n'
                '  });\n'
                '}',
            copiedMessage: 'تم نسخ كود Throttler',
            copyTooltip: 'نسخ الكود',
          ),
        ],
      ),
    );
  }
}
