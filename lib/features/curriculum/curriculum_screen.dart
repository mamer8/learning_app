import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
import 'curriculum_data.dart';
import 'topic_detail_screen.dart';

class CurriculumScreen extends StatefulWidget {
  const CurriculumScreen({super.key});

  @override
  State<CurriculumScreen> createState() => _CurriculumScreenState();
}

class _CurriculumScreenState extends State<CurriculumScreen> {
  String _query = '';

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final isArabic = locale.isArabic;
    final visibleLevels = _visibleLevels(isArabic);

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            isArabic ? 'منهج Flutter الكامل' : 'Complete Flutter Path',
          ),
          actions: [
            TextButton.icon(
              onPressed: locale.onToggleLanguage,
              icon: const Icon(Icons.language_rounded),
              label: Text(isArabic ? 'English' : 'العربية'),
            ),
            8.widthBox,
          ],
        ),
        body: ResponsiveContentWrapper(
          maxWidth: 1200,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
            children: [
              _Header(isArabic: isArabic),
              12.heightBox,
              TextField(
                onChanged: (value) => setState(() => _query = value.trim()),
                style: const TextStyle(color: Colors.white),
                decoration: InputDecoration(
                  filled: true,
                  fillColor: const Color(0xFF172033),
                  prefixIcon: const Icon(
                    Icons.search_rounded,
                    color: Color(0xFF14B8A6),
                  ),
                  hintText: isArabic
                      ? 'ابحث عن auth، api، payment، testing...'
                      : 'Search auth, api, payment, testing...',
                  hintStyle: const TextStyle(color: Color(0xFF64748B)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(8),
                    borderSide: BorderSide.none,
                  ),
                ),
              ),
              16.heightBox,
              if (visibleLevels.isEmpty)
                _EmptySearch(isArabic: isArabic)
              else
                for (final entry in visibleLevels) ...[
                  _LevelCard(level: entry.level, topics: entry.topics),
                  12.heightBox,
                ],
            ],
          ),
        ),
      ),
    );
  }

  List<_VisibleLevel> _visibleLevels(bool isArabic) {
    if (_query.isEmpty) {
      return [
        for (final level in curriculumLevels)
          _VisibleLevel(level: level, topics: level.topics),
      ];
    }

    final query = _query.toLowerCase();
    final result = <_VisibleLevel>[];

    for (final level in curriculumLevels) {
      final levelMatches =
          level.title.value(isArabic).toLowerCase().contains(query) ||
          level.subtitle.value(isArabic).toLowerCase().contains(query);

      final topics = levelMatches
          ? level.topics
          : level.topics.where((topic) {
              return topic.title
                      .value(isArabic)
                      .toLowerCase()
                      .contains(query) ||
                  topic.summary.value(isArabic).toLowerCase().contains(query) ||
                  topic.explain.value(isArabic).toLowerCase().contains(query);
            }).toList();

      if (topics.isNotEmpty) {
        result.add(_VisibleLevel(level: level, topics: topics));
      }
    }

    return result;
  }
}

class _VisibleLevel {
  const _VisibleLevel({required this.level, required this.topics});

  final CurriculumLevel level;
  final List<CurriculumTopic> topics;
}

class _EmptySearch extends StatelessWidget {
  const _EmptySearch({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF172033),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: Row(
        children: [
          const Icon(Icons.search_off_rounded, color: Color(0xFF94A3B8)),
          10.widthBox,
          Expanded(
            child: Text(
              isArabic
                  ? 'لا توجد نتائج مطابقة. جرب كلمة أبسط مثل api أو state.'
                  : 'No matching results. Try a simpler word like api or state.',
              style: const TextStyle(color: Color(0xFFCBD5E1)),
            ),
          ),
        ],
      ),
    );
  }
}

class _Header extends StatelessWidget {
  const _Header({required this.isArabic});

  final bool isArabic;

  @override
  Widget build(BuildContext context) {
    final topicsCount = curriculumLevels.fold<int>(
      0,
      (sum, level) => sum + level.topics.length,
    );

    return Container(
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isArabic
                ? 'خريطة طريق واضحة من الصفر للاحتراف'
                : 'A clear roadmap from zero to professional',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
              color: Colors.white,
              fontWeight: FontWeight.w900,
            ),
          ),
          8.heightBox,
          Text(
            isArabic
                ? 'اتبع المستويات بالترتيب. كل موضوع فيه شرح، استخدامات، خطوات تطبيق، كود، وأخطاء شائعة.'
                : 'Follow the levels in order. Every topic includes the idea, use cases, steps, code, and common mistakes.',
            style: const TextStyle(color: Color(0xFFCBD5E1), height: 1.5),
          ),
          14.heightBox,
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              _Tag(
                text: isArabic ? '$topicsCount موضوع' : '$topicsCount topics',
              ),
              _Tag(
                text: isArabic
                    ? '${curriculumLevels.length} مستويات'
                    : '${curriculumLevels.length} levels',
              ),
              _Tag(text: isArabic ? 'أمثلة كود' : 'Code examples'),
              _Tag(text: isArabic ? 'أخطاء شائعة' : 'Common mistakes'),
            ],
          ),
        ],
      ),
    );
  }
}

class _Tag extends StatelessWidget {
  const _Tag({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: const Color(0xFF14B8A6).withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(999),
      ),
      child: Text(
        text,
        style: const TextStyle(
          color: Color(0xFF5EEAD4),
          fontWeight: FontWeight.w800,
          fontSize: 12,
        ),
      ),
    );
  }
}

class _LevelCard extends StatelessWidget {
  const _LevelCard({required this.level, required this.topics});

  final CurriculumLevel level;
  final List<CurriculumTopic> topics;

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocaleScope.of(context).isArabic;

    return Container(
      decoration: BoxDecoration(
        color: const Color(0xFF172033),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: ExpansionTile(
        initiallyExpanded: level.number <= 2,
        tilePadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
        childrenPadding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
        iconColor: level.color,
        collapsedIconColor: const Color(0xFF94A3B8),
        leading: Container(
          width: 42,
          height: 42,
          decoration: BoxDecoration(
            color: level.color.withValues(alpha: 0.14),
            borderRadius: BorderRadius.circular(8),
          ),
          child: Icon(level.icon, color: level.color),
        ),
        title: Text(
          isArabic
              ? 'المستوى ${level.number}: ${level.title.value(true)}'
              : 'Level ${level.number}: ${level.title.value(false)}',
          style: const TextStyle(
            color: Colors.white,
            fontWeight: FontWeight.w900,
          ),
        ),
        subtitle: Padding(
          padding: const EdgeInsets.only(top: 5),
          child: Text(
            level.subtitle.value(isArabic),
            style: const TextStyle(color: Color(0xFF94A3B8), height: 1.35),
          ),
        ),
        children: [
          for (final topic in topics) _TopicRow(level: level, topic: topic),
        ],
      ),
    );
  }
}

class _TopicRow extends StatelessWidget {
  const _TopicRow({required this.level, required this.topic});

  final CurriculumLevel level;
  final CurriculumTopic topic;

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocaleScope.of(context).isArabic;

    return Padding(
      padding: const EdgeInsets.only(top: 10),
      child: InkWell(
        onTap: () =>
            context.push(TopicDetailScreen(level: level, topic: topic)),
        borderRadius: BorderRadius.circular(8),
        child: Ink(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: const Color(0xFF101828),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(color: const Color(0xFF24324A)),
          ),
          child: Row(
            children: [
              Icon(Icons.article_rounded, color: level.color, size: 22),
              10.widthBox,
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      topic.title.value(isArabic),
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                      ),
                    ),
                    4.heightBox,
                    Text(
                      topic.summary.value(isArabic),
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
              10.widthBox,
              const Icon(
                Icons.arrow_forward_ios_rounded,
                color: Color(0xFF64748B),
                size: 16,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
