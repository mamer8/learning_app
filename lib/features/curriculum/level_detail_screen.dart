import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
import 'curriculum_data.dart';
import 'topic_detail_screen.dart';

/// شاشة تفاصيل المستوى المحدد
class LevelDetailScreen extends StatefulWidget {
  const LevelDetailScreen({required this.level, super.key});

  final CurriculumLevel level;

  @override
  State<LevelDetailScreen> createState() => _LevelDetailScreenState();
}

class _LevelDetailScreenState extends State<LevelDetailScreen> {
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocaleScope.of(context).isArabic;
    final level = widget.level;

    final filteredTopics = widget.level.topics.where((topic) {
      if (_searchQuery.isEmpty) return true;
      final q = _searchQuery.toLowerCase();
      return topic.title.value(isArabic).toLowerCase().contains(q) ||
          topic.summary.value(isArabic).toLowerCase().contains(q) ||
          topic.explain.value(isArabic).toLowerCase().contains(q);
    }).toList();

    return Scaffold(
      backgroundColor: const Color(0xFF0B1220),
      appBar: AppBar(
        title: Text(
          isArabic
              ? 'المستوى ${level.number}: ${level.title.value(true)}'
              : 'Level ${level.number}: ${level.title.value(false)}',
        ),
      ),
      body: ListView(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 28),
        children: [
          // بنر تفاصيل المستوى
          Container(
            padding: const EdgeInsets.all(18),
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
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: level.color.withValues(alpha: 0.16),
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Icon(level.icon, color: level.color, size: 28),
                    ),
                    12.widthBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                            decoration: BoxDecoration(
                              color: level.color.withValues(alpha: 0.15),
                              borderRadius: BorderRadius.circular(6),
                            ),
                            child: Text(
                              isArabic ? 'المستوى ${level.number}' : 'Level ${level.number}',
                              style: TextStyle(
                                color: level.color,
                                fontWeight: FontWeight.w900,
                                fontSize: 11,
                              ),
                            ),
                          ),
                          4.heightBox,
                          Text(
                            level.title.value(isArabic),
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w900,
                              fontSize: 16,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
                12.heightBox,
                Text(
                  level.subtitle.value(isArabic),
                  style: const TextStyle(color: Color(0xFFCBD5E1), height: 1.5, fontSize: 13),
                ),
                12.heightBox,
                Row(
                  children: [
                    Icon(Icons.menu_book_rounded, color: level.color, size: 16),
                    6.widthBox,
                    Text(
                      isArabic
                          ? '${level.topics.length} مواضيع تعليمية كاملة بالكود'
                          : '${level.topics.length} complete learning topics with code',
                      style: TextStyle(
                        color: level.color,
                        fontWeight: FontWeight.bold,
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          14.heightBox,

          // حقل بحث داخل مواضيع المستوى
          TextField(
            onChanged: (val) => setState(() => _searchQuery = val.trim()),
            style: const TextStyle(color: Colors.white, fontSize: 13),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF172033),
              prefixIcon: Icon(Icons.search_rounded, color: level.color, size: 20),
              hintText: isArabic ? 'ابحث في مواضيع هذا المستوى...' : 'Search topics in this level...',
              hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
          ),
          14.heightBox,

          // قائمة المواضيع
          if (filteredTopics.isEmpty)
            Container(
              padding: const EdgeInsets.all(20),
              decoration: BoxDecoration(
                color: const Color(0xFF172033),
                borderRadius: BorderRadius.circular(8),
              ),
              child: Center(
                child: Text(
                  isArabic ? 'لا توجد مواضيع مطابقة للبحث' : 'No matching topics found',
                  style: const TextStyle(color: Color(0xFF94A3B8)),
                ),
              ),
            )
          else
            ...filteredTopics.map((topic) {
              return Padding(
                padding: const EdgeInsets.only(bottom: 10),
                child: InkWell(
                  onTap: () => context.push(TopicDetailScreen(level: level, topic: topic)),
                  borderRadius: BorderRadius.circular(10),
                  child: Ink(
                    padding: const EdgeInsets.all(14),
                    decoration: BoxDecoration(
                      color: const Color(0xFF172033),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF24324A)),
                    ),
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.all(10),
                          decoration: BoxDecoration(
                            color: level.color.withValues(alpha: 0.12),
                            shape: BoxShape.circle,
                          ),
                          child: Icon(Icons.article_rounded, color: level.color, size: 20),
                        ),
                        12.widthBox,
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text(
                                topic.title.value(isArabic),
                                style: const TextStyle(
                                  color: Colors.white,
                                  fontWeight: FontWeight.w800,
                                  fontSize: 14,
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
              );
            }),
        ],
      ),
    );
  }
}
