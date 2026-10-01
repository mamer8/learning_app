import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
import '../../core/services/lab_progress_service.dart';
import '../ai_chat/ai_chat_screen.dart';
import '../animations_lab/animations_screen.dart';
import '../clean_arch_lab/clean_arch_screen.dart';
import '../curriculum/curriculum_data.dart';
import '../curriculum/level_detail_screen.dart';
import '../dart3_lab/dart3_screen.dart';
import '../debouncer_lab/debouncer_screen.dart';
import '../deployment_lab/deployment_screen.dart';
import '../error_handling_lab/presentation/screens/error_handling_screen.dart';
import '../extensions_lab/extensions_screen.dart';
import '../isolates_lab/isolates_screen.dart';
import '../keys_lab/keys_screen.dart';
import '../memory_perf_lab/memory_perf_screen.dart';
import '../offline_sync_lab/offline_sync_screen.dart';
import '../physics_lab/physics_painter_screen.dart';
import '../platform_channels_lab/platform_channels_screen.dart';
import '../repaint_boundary_lab/repaint_boundary_screen.dart';
import '../security_lab/security_screen.dart';
import '../slivers_lab/slivers_screen.dart';
import '../state_comparison_lab/state_comparison_screen.dart';
import '../state_inherited_lab/state_inherited_screen.dart';
import '../streams_rx_lab/streams_rx_screen.dart';

typedef _Lab = ({
  String id,
  String category,
  String title,
  String subtitle,
  IconData icon,
  Color color,
  Widget page,
});

/// الشاشة الرئيسية المطورة لأكاديمية ومختبرات Flutter
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex =
      0; // 0: المعامل التفاعلية (Labs), 1: المسار التعليمي (Roadmap)
  String _labCategoryFilter = 'all'; // all, performance, network, architecture
  final _labProgressService = LabProgressService();
  LabProgress _labProgress = LabProgress.empty();
  bool _isProgressLoading = true;
  String? _progressError;
  late Future<void> _progressReady;

  @override
  void initState() {
    super.initState();
    _progressReady = _loadProgress();
  }

  Future<void> _loadProgress() async {
    setState(() {
      _isProgressLoading = true;
      _progressError = null;
    });
    try {
      final progress = await _labProgressService.load();
      if (!mounted) return;
      setState(() {
        _labProgress = progress;
        _isProgressLoading = false;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _progressError = error.toString();
        _isProgressLoading = false;
      });
    }
  }

  Future<void> _openLab(_Lab lab) async {
    await _progressReady;
    try {
      final progress = await _labProgressService.markOpened(lab.id);
      if (mounted) {
        setState(() {
          _labProgress = progress;
          _progressError = null;
        });
      }
    } catch (_) {
      _showProgressError();
    }
    if (mounted) context.push(lab.page);
  }

  void _showProgressError() {
    if (!mounted) return;
    final strings = AppLocaleScope.of(context).strings;
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(SnackBar(content: Text(strings.t('progressSaveError'))));
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final isArabic = locale.isArabic;
    final labs = _buildLabs(isArabic);

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        floatingActionButton: Container(
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF14B8A6), Color(0xFF0284C7)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(28),
            boxShadow: const [
              BoxShadow(
                color: Color(0x5514B8A6),
                blurRadius: 16,
                offset: Offset(0, 6),
              ),
            ],
          ),
          child: FloatingActionButton.extended(
            elevation: 0,
            highlightElevation: 0,
            backgroundColor: Colors.transparent,
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AiChatScreen()),
              );
            },
            icon: const Icon(
              Icons.psychology_rounded,
              color: Colors.white,
              size: 22,
            ),
            label: Text(
              isArabic ? 'مساعد Flutter الذكي' : 'Flutter AI Copilot',
              style: const TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.w800,
                fontSize: 13,
              ),
            ),
          ),
        ),
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [Color(0xFF0A0F1D), Color(0xFF0B1220), Color(0xFF111827)],
            ),
          ),
          child: SafeArea(
            child: CustomScrollView(
              slivers: [
                // 1. شريط العنوان واللغة
                SliverAppBar(
                  pinned: true,
                  title: Text(
                    isArabic
                        ? 'أكاديمية ومختبرات Flutter'
                        : 'Flutter Master Academy',
                  ),
                  actions: [
                    IconButton(
                      tooltip: isArabic
                          ? 'مساعد Flutter الذكي'
                          : 'Flutter AI Copilot',
                      icon: const Icon(
                        Icons.psychology_rounded,
                        color: Color(0xFF14B8A6),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (_) => const AiChatScreen(),
                          ),
                        );
                      },
                    ),
                    TextButton.icon(
                      onPressed: locale.onToggleLanguage,
                      icon: const Icon(Icons.language_rounded, size: 18),
                      label: Text(isArabic ? 'English' : 'العربية'),
                    ),
                    8.widthBox,
                  ],
                ),

                // 2. المحتوى الرئيسي
                SliverToBoxAdapter(
                  child: ResponsiveContentWrapper(
                    maxWidth: 1240,
                    padding: const EdgeInsets.fromLTRB(16, 10, 16, 32),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        // بنر الترحيب المصغر الأنيق
                        _buildHeaderBanner(isArabic),
                        14.heightBox,
                        _buildProgressCard(locale, labs.length),
                        14.heightBox,

                        // أزرار التبديل الرئيسية (Segmented Tab Bar)
                        _buildMainSegmentedSwitch(isArabic),
                        16.heightBox,

                        // عرض المحتوى بحسب التبويب المختار
                        if (_selectedTabIndex == 0) ...[
                          _buildLabCategoryChips(isArabic),
                          14.heightBox,
                          _buildLabsGrid(isArabic, labs),
                        ] else ...[
                          _buildRoadmapSection(isArabic),
                        ],
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildProgressCard(AppLocaleScope locale, int totalLabs) {
    final strings = locale.strings;
    final completedCount = _labProgress.completedLabIds.length;
    final progress = totalLabs == 0 ? 0.0 : completedCount / totalLabs;

    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF122B35), Color(0xFF101828)],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: const Color(0xFF14B8A6).withValues(alpha: 0.22),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 42,
                height: 42,
                decoration: BoxDecoration(
                  color: const Color(0xFF14B8A6).withValues(alpha: 0.12),
                  borderRadius: BorderRadius.circular(9),
                ),
                child: const Icon(
                  Icons.trending_up_rounded,
                  color: Color(0xFF5EEAD4),
                  size: 23,
                ),
              ),
              12.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      strings.t('progressTitle'),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 13,
                      ),
                    ),
                    4.heightBox,
                    Text(
                      '${strings.t('completed')} $completedCount '
                      '${strings.t('of')} $totalLabs ${strings.t('labsCount')}',
                      style: const TextStyle(
                        color: Color(0xFFCBD5E1),
                        fontSize: 11.5,
                      ),
                    ),
                  ],
                ),
              ),
              12.widthBox,
              if (_isProgressLoading)
                const SizedBox(
                  width: 18,
                  height: 18,
                  child: CircularProgressIndicator(strokeWidth: 2),
                )
              else
                Text(
                  '${(progress * 100).round()}%',
                  style: const TextStyle(
                    color: Color(0xFF5EEAD4),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
            ],
          ),
          12.heightBox,
          ClipRRect(
            borderRadius: BorderRadius.circular(8),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 5,
              backgroundColor: const Color(0xFF24324A),
              valueColor: const AlwaysStoppedAnimation(Color(0xFF14B8A6)),
            ),
          ),
          if (_progressError != null) ...[
            8.heightBox,
            Row(
              children: [
                Expanded(
                  child: Text(
                    strings.t('progressLoadError'),
                    style: const TextStyle(
                      color: Color(0xFFFCA5A5),
                      fontSize: 11,
                    ),
                  ),
                ),
                TextButton(
                  onPressed: () {
                    _progressReady = _loadProgress();
                  },
                  child: Text(strings.t('retry')),
                ),
              ],
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildHeaderBanner(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF133E47), Color(0xFF101828), Color(0xFF19253B)],
        ),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: const Color(0xFF14B8A6).withValues(alpha: 0.3),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 16,
            offset: Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF14B8A6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.touch_app_rounded,
                  color: Color(0xFF5EEAD4),
                  size: 24,
                ),
              ),
              10.widthBox,
              Expanded(
                child: Text(
                  isArabic
                      ? 'تجارب تفاعلية بسيطة لتطوير Flutter'
                      : 'Interactive Flutter Master Reference',
                  style: const TextStyle(
                    color: Color(0xFF5EEAD4),
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          10.heightBox,
          Text(
            isArabic
                ? 'جرّب كل ميزة بإيدك: غيّر القيم وشوف الحركة وسرعة التطبيق والكود بيتعدل قدامك لحظة بلحظة.'
                : 'Live interactive labs for performance, concurrency, clean architecture, security, and store releases.',
            style: const TextStyle(
              color: Color(0xFFCBD5E1),
              fontSize: 12,
              height: 1.45,
            ),
          ),
          12.heightBox,
          InkWell(
            onTap: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (_) => const AiChatScreen()),
              );
            },
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: BoxDecoration(
                color: const Color(0xFF0F172A).withValues(alpha: 0.9),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(
                  color: const Color(0xFF14B8A6).withValues(alpha: 0.5),
                ),
              ),
              child: Row(
                children: [
                  const Icon(
                    Icons.auto_awesome_rounded,
                    color: Color(0xFF5EEAD4),
                    size: 16,
                  ),
                  8.widthBox,
                  Expanded(
                    child: Text(
                      isArabic
                          ? 'اسأل المساعد الذكي (AI) بالعامية عن أي كود أو شرح...'
                          : 'Ask AI Copilot for architecture advice & code review...',
                      style: const TextStyle(
                        color: Color(0xFF5EEAD4),
                        fontSize: 11.5,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_rounded,
                    color: Color(0xFF5EEAD4),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildMainSegmentedSwitch(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(4),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: Row(
        children: [
          Expanded(
            child: _buildSegmentButton(
              index: 0,
              icon: Icons.touch_app_rounded,
              label: isArabic
                  ? 'التجارب العملية (18 فكرة)'
                  : 'Interactive Labs (18 Labs)',
            ),
          ),
          Expanded(
            child: _buildSegmentButton(
              index: 1,
              icon: Icons.menu_book_rounded,
              label: isArabic
                  ? 'خطة المنهج (6 مستويات)'
                  : 'Curriculum Path (6 Levels)',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({
    required int index,
    required IconData icon,
    required String label,
  }) {
    final isSelected = _selectedTabIndex == index;
    return InkWell(
      onTap: () => setState(() => _selectedTabIndex = index),
      borderRadius: BorderRadius.circular(8),
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 200),
        padding: const EdgeInsets.symmetric(vertical: 10),
        decoration: BoxDecoration(
          color: isSelected ? const Color(0xFF14B8A6) : Colors.transparent,
          borderRadius: BorderRadius.circular(8),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 16,
              color: isSelected ? const Color(0xFF04111C) : Colors.white60,
            ),
            6.widthBox,
            Text(
              label,
              style: TextStyle(
                color: isSelected ? const Color(0xFF04111C) : Colors.white70,
                fontWeight: FontWeight.w800,
                fontSize: 11.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLabCategoryChips(bool isArabic) {
    final categories = [
      (id: 'all', label: isArabic ? 'كل التجارب (18)' : 'All (18)'),
      (
        id: 'performance',
        label: isArabic ? '⚡ السرعة والحركات' : '⚡ Performance & Motion',
      ),
      (
        id: 'network',
        label: isArabic ? '🌐 النت والبيانات' : '🌐 Network & Streams',
      ),
      (
        id: 'architecture',
        label: isArabic ? '🔒 تنظيم الكود' : '🔒 Architecture & Dart 3',
      ),
    ];

    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: categories.map((cat) {
          final isSelected = _labCategoryFilter == cat.id;
          return Padding(
            padding: const EdgeInsets.only(right: 8),
            child: FilterChip(
              label: Text(cat.label),
              selected: isSelected,
              selectedColor: const Color(0xFF14B8A6).withValues(alpha: 0.25),
              backgroundColor: const Color(0xFF101828),
              side: BorderSide(
                color: isSelected
                    ? const Color(0xFF14B8A6)
                    : const Color(0xFF24324A),
              ),
              labelStyle: TextStyle(
                color: isSelected ? const Color(0xFF5EEAD4) : Colors.white70,
                fontWeight: isSelected ? FontWeight.w800 : FontWeight.normal,
                fontSize: 11.5,
              ),
              onSelected: (val) => setState(() => _labCategoryFilter = cat.id),
            ),
          );
        }).toList(),
      ),
    );
  }

  List<_Lab> _buildLabs(bool isArabic) {
    return [
      // 1. Performance & Motion Category
      (
        id: 'isolates',
        category: 'performance',
        title: isArabic
            ? '1. العمليات في الخلفية (Isolates)'
            : '1. Isolates & Concurrency',
        subtitle: isArabic
            ? 'شغل الحسابات الثقيلة في الخلفية عشان الشاشة ما تهنجش وتفضل سريعة.'
            : 'Main Thread freeze vs Isolate.run() smoothness.',
        icon: Icons.bolt_rounded,
        color: const Color(0xFF0284C7),
        page: const IsolatesScreen(),
      ),
      (
        id: 'repaint-boundary',
        category: 'performance',
        title: isArabic
            ? '2. تسريع الرسم (Repaint Boundary)'
            : '2. RepaintBoundary & GPU',
        subtitle: isArabic
            ? 'اعزل الأجزاء اللي بتتحرك عشان كارت الشاشة ما يرسمش باقي الشاشة عالفاضي.'
            : 'Isolate render layers to prevent full repaint jank.',
        icon: Icons.layers_rounded,
        color: const Color(0xFF0D9488),
        page: const RepaintBoundaryScreen(),
      ),
      (
        id: 'animations',
        category: 'performance',
        title: isArabic
            ? '3. حركات وفيزياء ناعمة (Animations)'
            : '3. Staggered & Physics Animations',
        subtitle: isArabic
            ? 'حركات تتابع خطوة بخطوة ومحاكاة السوستة الطبيعية بتغير الصلابة والتخميد.'
            : 'Chained Interval timelines and physics spring simulation.',
        icon: Icons.animation_rounded,
        color: const Color(0xFF8B5CF6),
        page: const AnimationsScreen(),
      ),
      (
        id: 'memory-performance',
        category: 'performance',
        title: isArabic
            ? '4. تنظيف الرام والصور (Memory & Images)'
            : '4. Memory Profiling & Image Resize',
        subtitle: isArabic
            ? 'اكتشف تسريب الذاكرة واقفل المؤقتات وصغر حجم الصور الكبيرة قبل عرضها.'
            : 'Memory leaks detector and GPU bitmap downsampling.',
        icon: Icons.memory_rounded,
        color: const Color(0xFFEF4444),
        page: const MemoryPerfScreen(),
      ),
      (
        id: 'slivers',
        category: 'performance',
        title: isArabic
            ? '5. القوائم المنزلقة المرنة (Slivers)'
            : '5. Slivers & Scroll Geometry',
        subtitle: isArabic
            ? 'تحكم في حركة التمرير وتثبيت الهيدر في أعلى الشاشة بمرونة.'
            : 'Live scroll offset & viewport geometry inspector.',
        icon: Icons.view_quilt_rounded,
        color: const Color(0xFF06B6D4),
        page: const SliversScreen(),
      ),
      (
        id: 'physics-painter',
        category: 'performance',
        title: isArabic
            ? '6. الرسم الحر والفيزياء (Canvas Painter)'
            : '6. CustomPainter & Physics',
        subtitle: isArabic
            ? 'ارسم نقاط وجزيئات حرة بتتحرك وتتفاعل مع الجاذبية ولمساتك مباشرة.'
            : 'Particle physics engine and direct GPU canvas draw.',
        icon: Icons.auto_awesome_motion_rounded,
        color: const Color(0xFF14B8A6),
        page: const PhysicsPainterScreen(),
      ),

      // 2. Network & Async Category
      (
        id: 'debouncer',
        category: 'network',
        title: isArabic
            ? '7. مؤقت البحث والضغطات (Debounce)'
            : '7. Debouncer & Throttler',
        subtitle: isArabic
            ? 'استنى لما المستخدم يخلص كتابة قبل ما تبحث وامنع تكرار الضغط ع الأزرار.'
            : 'Search keystrokes optimizer and anti-spam protection.',
        icon: Icons.filter_alt_rounded,
        color: const Color(0xFF6366F1),
        page: const DebouncerScreen(),
      ),
      (
        id: 'streams-rx',
        category: 'network',
        title: isArabic
            ? '8. تدفق البيانات والرسائل (Streams)'
            : '8. Reactive Streams & Pipelines',
        subtitle: isArabic
            ? 'استقبل التحديثات اللحظية وفلتر الأرقام الزوجية والمكررة خطوة بخطوة.'
            : 'Reactive streams event emitter and pipeline operators.',
        icon: Icons.water_drop_rounded,
        color: const Color(0xFF10B981),
        page: const StreamsRxScreen(),
      ),
      (
        id: 'error-handling',
        category: 'network',
        title: isArabic
            ? '9. معالجة الأخطاء الذكية (Either)'
            : '9. Functional Error Handling',
        subtitle: isArabic
            ? 'اتعامل مع أخطاء السيرفر والإنترنت بأمان وطلع رسايل واضحة بدون كراش.'
            : 'Safe functional error handling with Either and Cubit.',
        icon: Icons.shield_rounded,
        color: const Color(0xFF34D399),
        page: const ErrorHandlingScreen(),
      ),
      (
        id: 'offline-sync',
        category: 'network',
        title: isArabic
            ? '10. العمل بدون إنترنت (Offline First)'
            : '10. Offline-First & Sync Engine',
        subtitle: isArabic
            ? 'ضيف بياناتك حتى والنت فاصل والتطبيق هيرفعها للسيرفر لوحده أول ما يتصل.'
            : 'Optimistic UI updates and offline cache sync queue.',
        icon: Icons.cloud_sync_rounded,
        color: const Color(0xFF38BDF8),
        page: const OfflineSyncScreen(),
      ),

      // 3. Architecture, Language & Native Category
      (
        id: 'dart3',
        category: 'architecture',
        title: isArabic
            ? '11. أسرار لغة Dart 3 الجديدة'
            : '11. Dart 3: Sealed Classes & Records',
        subtitle: isArabic
            ? 'قسم الحالات واجمع أكتر من قيمة في متغير واحد بكود مختصر وسهل.'
            : 'Records, exhaustive switch patterns and guard clauses.',
        icon: Icons.code_rounded,
        color: const Color(0xFF0284C7),
        page: const Dart3Screen(),
      ),
      (
        id: 'state-inherited',
        category: 'architecture',
        title: isArabic
            ? '12. مشاركة البيانات السريعة (State)'
            : '12. InheritedModel & O(1) Rebuilds',
        subtitle: isArabic
            ? 'شارك الداتا بين الشاشات وحدّث الجزء اللي اتغير بس بدون إعادة بناء الشاشة.'
            : 'O(1) tree lookup and granular aspect-filtered rebuilds.',
        icon: Icons.hub_rounded,
        color: const Color(0xFF14B8A6),
        page: const StateInheritedScreen(),
      ),
      (
        id: 'state-comparison',
        category: 'architecture',
        title: isArabic
            ? '13. مقارنة وتقويم إدارة الحالة (Cubit)'
            : '13. State Management & Cubit Benchmark',
        subtitle: isArabic
            ? 'قارن بين setState و Cubit و ValueNotifier مع رسوم بيانية حية لعدد الـ Rebuilds.'
            : 'Live rebuild telemetry & benchmark: setState vs Cubit vs ValueNotifier.',
        icon: Icons.compare_arrows_rounded,
        color: const Color(0xFF10B981),
        page: const StateComparisonScreen(),
      ),
      (
        id: 'clean-architecture',
        category: 'architecture',
        title: isArabic
            ? '14. تنظيم وهندسة الكود (Clean Arch)'
            : '14. Clean Architecture & SOLID',
        subtitle: isArabic
            ? 'افصل كود التصميم عن منطق البيانات عشان التطبيق يبقى سهل في الصيانة.'
            : 'Layer separation and live Dependency Inversion switcher.',
        icon: Icons.architecture_rounded,
        color: const Color(0xFFF59E0B),
        page: const CleanArchScreen(),
      ),
      (
        id: 'platform-channels',
        category: 'architecture',
        title: isArabic
            ? '15. ربط الموبايل ونظام التشغيل (Native)'
            : '15. Platform Channels & Native Bridge',
        subtitle: isArabic
            ? 'اطلب نسبة البطارية ومعلومات الجهاز وحساسات الموبايل من أندرويد و iOS.'
            : 'BinaryMessenger bridge, method calls and sensor streams.',
        icon: Icons.settings_input_component_rounded,
        color: const Color(0xFF06B6D4),
        page: const PlatformChannelsScreen(),
      ),
      (
        id: 'keys',
        category: 'architecture',
        title: isArabic
            ? '16. ترتيب عناصر القوائم (Keys)'
            : '16. 3 Trees & Widget Keys',
        subtitle: isArabic
            ? 'افهم سبب لخبطة الألوان والقيم في القائمة وإزاي تثبت كل عنصر بمفتاح Key.'
            : 'Widget vs Element matching and state identity.',
        icon: Icons.account_tree_rounded,
        color: const Color(0xFFD97706),
        page: const KeysScreen(),
      ),
      (
        id: 'security',
        category: 'architecture',
        title: isArabic
            ? '17. الأمان وتجديد تسجيل الدخول (JWT)'
            : '17. Security & Token Interceptors',
        subtitle: isArabic
            ? 'شفر كلمات السر وجدد جلسة الدخول في الخلفية بدون ما تخرج المستخدم.'
            : 'AES-256 encryption and auto JWT refresh queue.',
        icon: Icons.lock_person_rounded,
        color: const Color(0xFFEC4899),
        page: const SecurityScreen(),
      ),
      (
        id: 'deployment',
        category: 'architecture',
        title: isArabic
            ? '18. تجهيز التطبيق للمتاجر (CI/CD)'
            : '18. App Stores & CI/CD Release',
        subtitle: isArabic
            ? 'قائمة الفحص قبل رفع التطبيق وأوامر البناء المشفرة لـ Google Play و iOS.'
            : 'Keystore generator, store checklist & CI/CD pipeline.',
        icon: Icons.rocket_launch_rounded,
        color: const Color(0xFFF59E0B),
        page: const DeploymentScreen(),
      ),
      (
        id: 'extensions',
        category: 'architecture',
        title: isArabic
            ? '19. اختصارات الكود الذكية (Extensions)'
            : '19. Core Extensions Playground',
        subtitle: isArabic
            ? 'اختصارات سهلة لفحص الإيميل ورقم الموبايل وتحديد مسافات الشاشة بسرعة.'
            : 'Live context dimensions, floating snackbars and validators.',
        icon: Icons.auto_awesome_rounded,
        color: const Color(0xFFE11D48),
        page: const ExtensionsScreen(),
      ),
    ];
  }

  Widget _buildLabsGrid(bool isArabic, List<_Lab> allLabs) {
    final filteredLabs = allLabs.where((lab) {
      if (_labCategoryFilter == 'all') return true;
      return lab.category == _labCategoryFilter;
    }).toList();

    return AdaptiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 3,
      spacing: 12,
      runSpacing: 12,
      children: filteredLabs.map((lab) {
        final isCompleted = _labProgress.isCompleted(lab.id);
        return InkWell(
          onTap: () => _openLab(lab),
          borderRadius: BorderRadius.circular(10),
          child: Ink(
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: const Color(0xFF101828),
              borderRadius: BorderRadius.circular(10),
              border: Border.all(color: const Color(0xFF24324A)),
            ),
            child: Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: lab.color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(
                      color: lab.color.withValues(alpha: 0.35),
                    ),
                  ),
                  child: Icon(lab.icon, color: lab.color, size: 22),
                ),
                12.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        lab.title,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 13.5,
                        ),
                      ),
                      3.heightBox,
                      Text(
                        lab.subtitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Color(0xFF94A3B8),
                          fontSize: 11.5,
                          height: 1.35,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 8),
                Tooltip(
                  message: AppLocaleScope.of(
                    context,
                  ).strings.t(isCompleted ? 'completed' : 'openLab'),
                  child: Icon(
                    isCompleted
                        ? Icons.check_circle_rounded
                        : Icons.arrow_forward_ios_rounded,
                    color: isCompleted
                        ? const Color(0xFF5EEAD4)
                        : const Color(0xFF64748B),
                    size: isCompleted ? 20 : 14,
                  ),
                ),
              ],
            ),
          ),
        );
      }).toList(),
    );
  }

  Widget _buildRoadmapSection(bool isArabic) {
    return AdaptiveGrid(
      mobileColumns: 1,
      tabletColumns: 2,
      desktopColumns: 2,
      spacing: 12,
      runSpacing: 12,
      children: [
        for (final level in curriculumLevels)
          InkWell(
            onTap: () => context.push(LevelDetailScreen(level: level)),
            borderRadius: BorderRadius.circular(10),
            child: Ink(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF101828),
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: const Color(0xFF24324A)),
              ),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: level.color.withValues(alpha: 0.14),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(
                        color: level.color.withValues(alpha: 0.35),
                      ),
                    ),
                    child: Center(
                      child: Text(
                        '${level.number}',
                        style: TextStyle(
                          color: level.color,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ),
                  ),
                  12.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text(
                          level.title.value(isArabic),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w800,
                            fontSize: 13.5,
                          ),
                        ),
                        3.heightBox,
                        Text(
                          '${level.topics.length} ${isArabic ? 'مواضيع كود وشروحات' : 'topics with code'} | ${level.subtitle.value(isArabic)}',
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 11.5,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  8.widthBox,
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF64748B),
                    size: 14,
                  ),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
