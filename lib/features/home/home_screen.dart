import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
import '../curriculum/curriculum_data.dart';
import '../curriculum/curriculum_screen.dart';
import '../debouncer_lab/debouncer_screen.dart';
import '../error_handling_lab/presentation/screens/error_handling_screen.dart';
import '../extensions_lab/extensions_screen.dart';
import '../isolates_lab/isolates_screen.dart';
import '../keys_lab/keys_screen.dart';
import '../repaint_boundary_lab/repaint_boundary_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final isArabic = locale.isArabic;

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        body: Container(
          decoration: const BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Color(0xFF0A0F1D),
                Color(0xFF0B1220),
                Color(0xFF111827),
              ],
            ),
          ),
          child: SafeArea(
            child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                title: Text(isArabic ? 'مرجع Flutter' : 'Flutter Reference'),
                actions: [
                  TextButton.icon(
                    onPressed: locale.onToggleLanguage,
                    icon: const Icon(Icons.language_rounded),
                    label: Text(isArabic ? 'English' : 'العربية'),
                  ),
                  8.widthBox,
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 10, 16, 28),
                sliver: SliverList.list(
                  children: [
                    _Hero(isArabic: isArabic),
                    14.heightBox,
                    _PrimaryActions(isArabic: isArabic),
                    14.heightBox,
                    _Stats(isArabic: isArabic),
                    18.heightBox,
                    _SectionTitle(
                      icon: Icons.route_rounded,
                      title: isArabic ? 'المستويات' : 'Levels',
                      subtitle: isArabic
                          ? 'المسار مبني بالترتيب الطبيعي لتعلم وبناء تطبيقات Flutter.'
                          : 'The path follows the natural order of learning and building Flutter apps.',
                    ),
                    12.heightBox,
                    _LevelPreviewList(isArabic: isArabic),
                    18.heightBox,
                    _SectionTitle(
                      icon: Icons.science_rounded,
                      title: isArabic ? 'معامل تطبيقية' : 'Interactive labs',
                      subtitle: isArabic
                          ? 'تجارب عملية جاهزة لتثبيت المفاهيم الصعبة.'
                          : 'Hands-on labs for difficult concepts.',
                    ),
                    12.heightBox,
                    _LabsList(isArabic: isArabic),
                  ],
                ),
              ),
            ],
            ),
          ),
        ),
      ),
    );
  }
}

class _Hero extends StatelessWidget {
  const _Hero({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
          colors: [Color(0xFF12333A), Color(0xFF101828), Color(0xFF162033)],
        ),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: const Color(0xFF2DD4BF).withValues(alpha: 0.28),
        ),
        boxShadow: const [
          BoxShadow(
            color: Color(0x33000000),
            blurRadius: 22,
            offset: Offset(0, 12),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: const Color(0xFF5EEAD4).withValues(alpha: 0.13),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: const Icon(
                  Icons.school_rounded,
                  color: Color(0xFF5EEAD4),
                  size: 28,
                ),
              ),
              12.widthBox,
              const Expanded(
                child: Text(
                  'Flutter Developer Reference',
                  style: TextStyle(
                    color: Color(0xFF5EEAD4),
                    fontWeight: FontWeight.w900,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          14.heightBox,
          Text(
            isArabic
                ? 'مرجع عملي كامل لتعلم برمجة التطبيقات بـ Flutter'
                : 'A complete practical reference for Flutter app development',
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
              height: 1.15,
            ),
          ),
          10.heightBox,
          Text(
            isArabic
                ? 'التطبيق منظم كمستويات. كل موضوع يشرح الفكرة، متى تستخدمها، خطوات التطبيق، مثال كود، والأخطاء الشائعة.'
                : 'The app is organized into levels. Every topic explains the idea, when to use it, implementation steps, code, and common mistakes.',
            style: const TextStyle(color: Color(0xFFCBD5E1), height: 1.55),
          ),
          16.heightBox,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _HeroChip(text: isArabic ? 'مرجع شامل' : 'Main reference'),
              _HeroChip(text: isArabic ? 'كود قابل للنسخ' : 'Copyable code'),
              _HeroChip(text: isArabic ? 'بحث سريع' : 'Fast search'),
            ],
          ),
        ],
      ),
    );
  }
}

class _HeroChip extends StatelessWidget {
  const _HeroChip({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 7),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.08),
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: Colors.white.withValues(alpha: 0.08)),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFFE2E8F0),
          fontWeight: FontWeight.w800,
          fontSize: 11,
        ),
      ),
    );
  }
}

class _PrimaryActions extends StatelessWidget {
  const _PrimaryActions({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: FilledButton.icon(
            onPressed: () => context.push(const CurriculumScreen()),
            icon: const Icon(Icons.menu_book_rounded),
            label: Text(isArabic ? 'افتح المنهج الكامل' : 'Open full path'),
          ),
        ),
      ],
    );
  }
}

class _Stats extends StatelessWidget {
  const _Stats({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final topicsCount = curriculumLevels.fold<int>(
      0,
      (sum, level) => sum + level.topics.length,
    );

    return Row(
      children: [
        Expanded(
          child: _StatCard(
            value: '${curriculumLevels.length}',
            label: isArabic ? 'مستويات' : 'Levels',
          ),
        ),
        10.widthBox,
        Expanded(
          child: _StatCard(
            value: '$topicsCount',
            label: isArabic ? 'موضوع' : 'Topics',
          ),
        ),
        10.widthBox,
        Expanded(
          child: _StatCard(value: '6', label: isArabic ? 'معامل' : 'Labs'),
        ),
      ],
    );
  }
}

class _StatCard extends StatelessWidget {
  const _StatCard({required this.value, required this.label});

  final String value;
  final String label;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF24324A)),
        boxShadow: const [
          BoxShadow(
            color: Color(0x22000000),
            blurRadius: 12,
            offset: Offset(0, 6),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            value,
            style: const TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.w900,
            ),
          ),
          4.heightBox,
          Text(
            label,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Icon(icon, color: const Color(0xFF14B8A6)),
        10.widthBox,
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title,
                style: const TextStyle(
                  color: Colors.white,
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
              4.heightBox,
              Text(
                subtitle,
                style: const TextStyle(color: Color(0xFF94A3B8), height: 1.4),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LevelPreviewList extends StatelessWidget {
  const _LevelPreviewList({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        for (final level in curriculumLevels) ...[
          InkWell(
            onTap: () => context.push(const CurriculumScreen()),
            borderRadius: BorderRadius.circular(8),
            child: Ink(
              padding: const EdgeInsets.all(14),
              decoration: BoxDecoration(
                color: const Color(0xFF101828),
                borderRadius: BorderRadius.circular(8),
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
                          fontWeight: FontWeight.w900,
                        ),
                      ),
                    ),
                  ),
                  12.widthBox,
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          level.title.value(isArabic),
                          style: const TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.w900,
                          ),
                        ),
                        4.heightBox,
                        Text(
                          level.subtitle.value(isArabic),
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: Color(0xFF94A3B8),
                            fontSize: 12,
                            height: 1.35,
                          ),
                        ),
                      ],
                    ),
                  ),
                  const Icon(
                    Icons.arrow_forward_ios_rounded,
                    color: Color(0xFF64748B),
                    size: 16,
                  ),
                ],
              ),
            ),
          ),
          if (level != curriculumLevels.last) 10.heightBox,
        ],
      ],
    );
  }
}

class _LabsList extends StatelessWidget {
  const _LabsList({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final labs = [
      _LabLink(
        title: isArabic ? 'Isolates والتوازي' : 'Isolates and concurrency',
        subtitle: isArabic
            ? 'انقل الحسابات الثقيلة بعيدًا عن الواجهة.'
            : 'Move heavy work away from the UI.',
        icon: Icons.memory_rounded,
        color: const Color(0xFF22D3EE),
        page: const IsolatesScreen(),
      ),
      _LabLink(
        title: isArabic ? 'Debouncer و Throttler' : 'Debouncer and throttler',
        subtitle: isArabic
            ? 'تحكم في طلبات البحث والضغط المتكرر.'
            : 'Control search calls and repeated taps.',
        icon: Icons.speed_rounded,
        color: const Color(0xFFF59E0B),
        page: const DebouncerScreen(),
      ),
      _LabLink(
        title: isArabic ? 'RepaintBoundary' : 'RepaintBoundary',
        subtitle: isArabic
            ? 'حسن أداء الرسم والأنيميشن.'
            : 'Improve paint and animation performance.',
        icon: Icons.layers_rounded,
        color: const Color(0xFF34D399),
        page: const RepaintBoundaryScreen(),
      ),
      _LabLink(
        title: isArabic ? 'Keys و Trees' : 'Keys and trees',
        subtitle: isArabic
            ? 'افهم هوية الـ Widget والـ State.'
            : 'Understand widget identity and state.',
        icon: Icons.account_tree_rounded,
        color: const Color(0xFFA78BFA),
        page: const KeysScreen(),
      ),
      _LabLink(
        title: isArabic ? 'Error Handling' : 'Error handling',
        subtitle: isArabic
            ? 'اعرض الفشل والنجاح بشكل متوقع.'
            : 'Represent success and failure predictably.',
        icon: Icons.verified_user_rounded,
        color: const Color(0xFF60A5FA),
        page: const ErrorHandlingScreen(),
      ),
      _LabLink(
        title: isArabic ? 'Extensions' : 'Extensions',
        subtitle: isArabic
            ? 'اكتب كود واجهات أسرع وأنظف.'
            : 'Write cleaner and faster UI code.',
        icon: Icons.extension_rounded,
        color: const Color(0xFFFB7185),
        page: const ExtensionsScreen(),
      ),
    ];

    return Column(
      children: [
        for (final lab in labs) ...[
          _LabTile(lab: lab),
          if (lab != labs.last) 10.heightBox,
        ],
      ],
    );
  }
}

class _LabTile extends StatelessWidget {
  const _LabTile({required this.lab});

  final _LabLink lab;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () => context.push(lab.page),
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: const Color(0xFF101828),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF24324A)),
        ),
        child: Row(
          children: [
            Container(
              width: 42,
              height: 42,
              decoration: BoxDecoration(
                color: lab.color.withValues(alpha: 0.14),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(lab.icon, color: lab.color),
            ),
            12.widthBox,
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    lab.title,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w900,
                    ),
                  ),
                  4.heightBox,
                  Text(
                    lab.subtitle,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ),
            const Icon(
              Icons.arrow_forward_ios_rounded,
              color: Color(0xFF64748B),
              size: 16,
            ),
          ],
        ),
      ),
    );
  }
}

class _LabLink {
  const _LabLink({
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.page,
  });

  final String title;
  final String subtitle;
  final IconData icon;
  final Color color;
  final Widget page;
}
