import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
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
import '../state_inherited_lab/state_inherited_screen.dart';
import '../streams_rx_lab/streams_rx_screen.dart';

/// الشاشة الرئيسية المطورة لأكاديمية ومختبرات Flutter
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _selectedTabIndex = 0; // 0: المعامل التفاعلية (Labs), 1: المسار التعليمي (Roadmap)
  String _labCategoryFilter = 'all'; // all, performance, network, architecture

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final isArabic = locale.isArabic;

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
            icon: const Icon(Icons.psychology_rounded, color: Colors.white, size: 22),
            label: Text(
              isArabic ? 'مساعد Flutter الذكي' : 'Flutter AI Copilot',
              style: const TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13),
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
                  title: Text(isArabic ? 'أكاديمية ومختبرات Flutter' : 'Flutter Master Academy'),
                  actions: [
                    IconButton(
                      tooltip: isArabic ? 'مساعد Flutter الذكي' : 'Flutter AI Copilot',
                      icon: const Icon(Icons.psychology_rounded, color: Color(0xFF14B8A6)),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (_) => const AiChatScreen()),
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

                        // أزرار التبديل الرئيسية (Segmented Tab Bar)
                        _buildMainSegmentedSwitch(isArabic),
                        16.heightBox,

                        // عرض المحتوى بحسب التبويب المختار
                        if (_selectedTabIndex == 0) ...[
                          _buildLabCategoryChips(isArabic),
                          14.heightBox,
                          _buildLabsGrid(isArabic),
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
        border: Border.all(color: const Color(0xFF14B8A6).withValues(alpha: 0.3)),
        boxShadow: const [
          BoxShadow(color: Color(0x33000000), blurRadius: 16, offset: Offset(0, 8)),
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
                child: const Icon(Icons.touch_app_rounded, color: Color(0xFF5EEAD4), size: 24),
              ),
              10.widthBox,
              Expanded(
                child: Text(
                  isArabic ? 'تجارب تفاعلية بسيطة لتطوير Flutter' : 'Interactive Flutter Master Reference',
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
            style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12, height: 1.45),
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
                border: Border.all(color: const Color(0xFF14B8A6).withValues(alpha: 0.5)),
              ),
              child: Row(
                children: [
                  const Icon(Icons.auto_awesome_rounded, color: Color(0xFF5EEAD4), size: 16),
                  8.widthBox,
                  Expanded(
                    child: Text(
                      isArabic
                          ? 'اسأل المساعد الذكي (AI) بالعامية عن أي كود أو شرح...'
                          : 'Ask AI Copilot for architecture advice & code review...',
                      style: const TextStyle(color: Color(0xFF5EEAD4), fontSize: 11.5, fontWeight: FontWeight.bold),
                    ),
                  ),
                  const Icon(Icons.arrow_forward_rounded, color: Color(0xFF5EEAD4), size: 16),
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
              label: isArabic ? 'التجارب العملية (18 فكرة)' : 'Interactive Labs (18 Labs)',
            ),
          ),
          Expanded(
            child: _buildSegmentButton(
              index: 1,
              icon: Icons.menu_book_rounded,
              label: isArabic ? 'خطة المنهج (6 مستويات)' : 'Curriculum Path (6 Levels)',
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSegmentButton({required int index, required IconData icon, required String label}) {
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
            Icon(icon, size: 16, color: isSelected ? const Color(0xFF04111C) : Colors.white60),
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
      (id: 'performance', label: isArabic ? '⚡ السرعة والحركات' : '⚡ Performance & Motion'),
      (id: 'network', label: isArabic ? '🌐 النت والبيانات' : '🌐 Network & Streams'),
      (id: 'architecture', label: isArabic ? '🔒 تنظيم الكود' : '🔒 Architecture & Dart 3'),
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
                color: isSelected ? const Color(0xFF14B8A6) : const Color(0xFF24324A),
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

  Widget _buildLabsGrid(bool isArabic) {
    final allLabs = [
      // 1. Performance & Motion Category
      (
        category: 'performance',
        title: isArabic ? '1. العمليات في الخلفية (Isolates)' : '1. Isolates & Concurrency',
        subtitle: isArabic ? 'شغل الحسابات الثقيلة في الخلفية عشان الشاشة ما تهنجش وتفضل سريعة.' : 'Main Thread freeze vs Isolate.run() smoothness.',
        icon: Icons.bolt_rounded,
        color: const Color(0xFF0284C7),
        page: const IsolatesScreen(),
      ),
      (
        category: 'performance',
        title: isArabic ? '2. تسريع الرسم (Repaint Boundary)' : '2. RepaintBoundary & GPU',
        subtitle: isArabic ? 'اعزل الأجزاء اللي بتتحرك عشان كارت الشاشة ما يرسمش باقي الشاشة عالفاضي.' : 'Isolate render layers to prevent full repaint jank.',
        icon: Icons.layers_rounded,
        color: const Color(0xFF0D9488),
        page: const RepaintBoundaryScreen(),
      ),
      (
        category: 'performance',
        title: isArabic ? '3. حركات وفيزياء ناعمة (Animations)' : '3. Staggered & Physics Animations',
        subtitle: isArabic ? 'حركات تتابع خطوة بخطوة ومحاكاة السوستة الطبيعية بتغير الصلابة والتخميد.' : 'Chained Interval timelines and physics spring simulation.',
        icon: Icons.animation_rounded,
        color: const Color(0xFF8B5CF6),
        page: const AnimationsScreen(),
      ),
      (
        category: 'performance',
        title: isArabic ? '4. تنظيف الرام والصور (Memory & Images)' : '4. Memory Profiling & Image Resize',
        subtitle: isArabic ? 'اكتشف تسريب الذاكرة واقفل المؤقتات وصغر حجم الصور الكبيرة قبل عرضها.' : 'Memory leaks detector and GPU bitmap downsampling.',
        icon: Icons.memory_rounded,
        color: const Color(0xFFEF4444),
        page: const MemoryPerfScreen(),
      ),
      (
        category: 'performance',
        title: isArabic ? '5. القوائم المنزلقة المرنة (Slivers)' : '5. Slivers & Scroll Geometry',
        subtitle: isArabic ? 'تحكم في حركة التمرير وتثبيت الهيدر في أعلى الشاشة بمرونة.' : 'Live scroll offset & viewport geometry inspector.',
        icon: Icons.view_quilt_rounded,
        color: const Color(0xFF06B6D4),
        page: const SliversScreen(),
      ),
      (
        category: 'performance',
        title: isArabic ? '6. الرسم الحر والفيزياء (Canvas Painter)' : '6. CustomPainter & Physics',
        subtitle: isArabic ? 'ارسم نقاط وجزيئات حرة بتتحرك وتتفاعل مع الجاذبية ولمساتك مباشرة.' : 'Particle physics engine and direct GPU canvas draw.',
        icon: Icons.auto_awesome_motion_rounded,
        color: const Color(0xFF14B8A6),
        page: const PhysicsPainterScreen(),
      ),

      // 2. Network & Async Category
      (
        category: 'network',
        title: isArabic ? '7. مؤقت البحث والضغطات (Debounce)' : '7. Debouncer & Throttler',
        subtitle: isArabic ? 'استنى لما المستخدم يخلص كتابة قبل ما تبحث وامنع تكرار الضغط ع الأزرار.' : 'Search keystrokes optimizer and anti-spam protection.',
        icon: Icons.filter_alt_rounded,
        color: const Color(0xFF6366F1),
        page: const DebouncerScreen(),
      ),
      (
        category: 'network',
        title: isArabic ? '8. تدفق البيانات والرسائل (Streams)' : '8. Reactive Streams & Pipelines',
        subtitle: isArabic ? 'استقبل التحديثات اللحظية وفلتر الأرقام الزوجية والمكررة خطوة بخطوة.' : 'Reactive streams event emitter and pipeline operators.',
        icon: Icons.water_drop_rounded,
        color: const Color(0xFF10B981),
        page: const StreamsRxScreen(),
      ),
      (
        category: 'network',
        title: isArabic ? '9. معالجة الأخطاء الذكية (Either)' : '9. Functional Error Handling',
        subtitle: isArabic ? 'اتعامل مع أخطاء السيرفر والإنترنت بأمان وطلع رسايل واضحة بدون كراش.' : 'Safe functional error handling with Either and Cubit.',
        icon: Icons.shield_rounded,
        color: const Color(0xFF34D399),
        page: const ErrorHandlingScreen(),
      ),
      (
        category: 'network',
        title: isArabic ? '10. العمل بدون إنترنت (Offline First)' : '10. Offline-First & Sync Engine',
        subtitle: isArabic ? 'ضيف بياناتك حتى والنت فاصل والتطبيق هيرفعها للسيرفر لوحده أول ما يتصل.' : 'Optimistic UI updates and offline cache sync queue.',
        icon: Icons.cloud_sync_rounded,
        color: const Color(0xFF38BDF8),
        page: const OfflineSyncScreen(),
      ),

      // 3. Architecture, Language & Native Category
      (
        category: 'architecture',
        title: isArabic ? '11. أسرار لغة Dart 3 الجديدة' : '11. Dart 3: Sealed Classes & Records',
        subtitle: isArabic ? 'قسم الحالات واجمع أكتر من قيمة في متغير واحد بكود مختصر وسهل.' : 'Records, exhaustive switch patterns and guard clauses.',
        icon: Icons.code_rounded,
        color: const Color(0xFF0284C7),
        page: const Dart3Screen(),
      ),
      (
        category: 'architecture',
        title: isArabic ? '12. مشاركة البيانات السريعة (State)' : '12. InheritedModel & O(1) Rebuilds',
        subtitle: isArabic ? 'شارك الداتا بين الشاشات وحدّث الجزء اللي اتغير بس بدون إعادة بناء الشاشة.' : 'O(1) tree lookup and granular aspect-filtered rebuilds.',
        icon: Icons.hub_rounded,
        color: const Color(0xFF14B8A6),
        page: const StateInheritedScreen(),
      ),
      (
        category: 'architecture',
        title: isArabic ? '13. تنظيم وهندسة الكود (Clean Arch)' : '13. Clean Architecture & SOLID',
        subtitle: isArabic ? 'افصل كود التصميم عن منطق البيانات عشان التطبيق يبقى سهل في الصيانة.' : 'Layer separation and live Dependency Inversion switcher.',
        icon: Icons.architecture_rounded,
        color: const Color(0xFFF59E0B),
        page: const CleanArchScreen(),
      ),
      (
        category: 'architecture',
        title: isArabic ? '14. ربط الموبايل ونظام التشغيل (Native)' : '14. Platform Channels & Native Bridge',
        subtitle: isArabic ? 'اطلب نسبة البطارية ومعلومات الجهاز وحساسات الموبايل من أندرويد و iOS.' : 'BinaryMessenger bridge, method calls and sensor streams.',
        icon: Icons.settings_input_component_rounded,
        color: const Color(0xFF06B6D4),
        page: const PlatformChannelsScreen(),
      ),
      (
        category: 'architecture',
        title: isArabic ? '15. ترتيب عناصر القوائم (Keys)' : '15. 3 Trees & Widget Keys',
        subtitle: isArabic ? 'افهم سبب لخبطة الألوان والقيم في القائمة وإزاي تثبت كل عنصر بمفتاح Key.' : 'Widget vs Element matching and state identity.',
        icon: Icons.account_tree_rounded,
        color: const Color(0xFFD97706),
        page: const KeysScreen(),
      ),
      (
        category: 'architecture',
        title: isArabic ? '16. الأمان وتجديد تسجيل الدخول (JWT)' : '16. Security & Token Interceptors',
        subtitle: isArabic ? 'شفر كلمات السر وجدد جلسة الدخول في الخلفية بدون ما تخرج المستخدم.' : 'AES-256 encryption and auto JWT refresh queue.',
        icon: Icons.lock_person_rounded,
        color: const Color(0xFFEC4899),
        page: const SecurityScreen(),
      ),
      (
        category: 'architecture',
        title: isArabic ? '17. تجهيز التطبيق للمتاجر (CI/CD)' : '17. App Stores & CI/CD Release',
        subtitle: isArabic ? 'قائمة الفحص قبل رفع التطبيق وأوامر البناء المشفرة لـ Google Play و iOS.' : 'Keystore generator, store checklist & CI/CD pipeline.',
        icon: Icons.rocket_launch_rounded,
        color: const Color(0xFFF59E0B),
        page: const DeploymentScreen(),
      ),
      (
        category: 'architecture',
        title: isArabic ? '18. اختصارات الكود الذكية (Extensions)' : '18. Core Extensions Playground',
        subtitle: isArabic ? 'اختصارات سهلة لفحص الإيميل ورقم الموبايل وتحديد مسافات الشاشة بسرعة.' : 'Live context dimensions, floating snackbars and validators.',
        icon: Icons.auto_awesome_rounded,
        color: const Color(0xFFE11D48),
        page: const ExtensionsScreen(),
      ),
    ];

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
        return InkWell(
          onTap: () => context.push(lab.page),
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
                    border: Border.all(color: lab.color.withValues(alpha: 0.35)),
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
                8.widthBox,
                const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF64748B), size: 14),
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
                      border: Border.all(color: level.color.withValues(alpha: 0.35)),
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
                  const Icon(Icons.arrow_forward_ios_rounded, color: Color(0xFF64748B), size: 14),
                ],
              ),
            ),
          ),
      ],
    );
  }
}
