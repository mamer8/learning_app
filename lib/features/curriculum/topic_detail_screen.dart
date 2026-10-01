import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';
import 'curriculum_data.dart';
import 'widgets/topic_live_preview.dart';

class TopicDetailScreen extends StatelessWidget {
  const TopicDetailScreen({
    required this.level,
    required this.topic,
    super.key,
  });

  final CurriculumLevel level;
  final CurriculumTopic topic;

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final isArabic = locale.isArabic;

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(topic.title.value(isArabic)),
          actions: [
            IconButton(
              tooltip: isArabic ? 'اسأل المساعد الذكي' : 'Ask AI Copilot',
              icon: const Icon(Icons.psychology_rounded, color: Color(0xFF14B8A6)),
              onPressed: () {
                ContextualAiSheet.show(
                  context,
                  topicTitle: topic.title.value(isArabic),
                  topicCode: topic.code,
                  levelTitle: level.title.value(isArabic),
                  isArabic: isArabic,
                );
              },
            ),
            TextButton.icon(
              onPressed: locale.onToggleLanguage,
              icon: const Icon(Icons.language_rounded),
              label: Text(isArabic ? 'English' : 'العربية'),
            ),
            8.widthBox,
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          heroTag: 'topic_detail_ai_fab',
          onPressed: () {
            ContextualAiSheet.show(
              context,
              topicTitle: topic.title.value(isArabic),
              topicCode: topic.code,
              levelTitle: level.title.value(isArabic),
              isArabic: isArabic,
            );
          },
          icon: const Icon(Icons.psychology_rounded, color: Color(0xFF04111C)),
          label: Text(
            isArabic ? 'اسأل المساعد الذكي' : 'Ask AI Copilot',
            style: const TextStyle(color: Color(0xFF04111C), fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF14B8A6),
        ),
        body: ResponsiveContentWrapper(
          maxWidth: 1280,
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 80),
          child: ListView(
            children: [
              _TopicHeader(level: level, topic: topic),
              14.heightBox,
              AdaptiveSplitView(
                breakpoint: 940,
                primaryFlex: 5,
                secondaryFlex: 5,
                spacing: 16,
                primary: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ExplainCard(
                      icon: Icons.lightbulb_rounded,
                      title: isArabic ? 'الفكرة ببساطة' : 'Simple idea',
                      child: Text(
                        topic.explain.value(isArabic),
                        style: const TextStyle(color: Color(0xFFCBD5E1), height: 1.6),
                      ),
                    ),
                    12.heightBox,
                    _ExplainCard(
                      icon: Icons.rule_rounded,
                      title: isArabic ? 'تستخدمه إمتى؟' : 'When to use it',
                      child: _BulletList(items: topic.whenToUse),
                    ),
                    12.heightBox,
                    _ExplainCard(
                      icon: Icons.format_list_numbered_rounded,
                      title: isArabic ? 'خطوات التطبيق' : 'Implementation steps',
                      child: _NumberedList(items: topic.steps),
                    ),
                    12.heightBox,
                    _ExplainCard(
                      icon: Icons.warning_amber_rounded,
                      title: isArabic ? 'أخطاء شائعة' : 'Common mistakes',
                      child: _BulletList(items: topic.commonMistakes),
                    ),
                  ],
                ),
                secondary: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    _ExplainCard(
                      icon: Icons.play_circle_filled_rounded,
                      title: isArabic ? 'المعاينة الحية والنتيجة التفاعلية' : 'Live Output & Interactive Sandbox',
                      child: TopicLivePreview(
                        level: level,
                        topic: topic,
                        isArabic: isArabic,
                      ),
                    ),
                    12.heightBox,
                    _ExplainCard(
                      icon: Icons.code_rounded,
                      title: isArabic ? 'مثال كود واضح' : 'Clear code example',
                      child: _CodeBlock(code: topic.code),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class _TopicHeader extends StatelessWidget {
  const _TopicHeader({required this.level, required this.topic});

  final CurriculumLevel level;
  final CurriculumTopic topic;

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocaleScope.of(context).isArabic;

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
          Row(
            children: [
              Container(
                width: 46,
                height: 46,
                decoration: BoxDecoration(
                  color: level.color.withValues(alpha: 0.16),
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(level.icon, color: level.color),
              ),
              12.widthBox,
              Expanded(
                child: Text(
                  isArabic
                      ? 'المستوى ${level.number}: ${level.title.value(true)}'
                      : 'Level ${level.number}: ${level.title.value(false)}',
                  style: TextStyle(
                    color: level.color,
                    fontWeight: FontWeight.w800,
                    fontSize: 13,
                  ),
                ),
              ),
            ],
          ),
          12.heightBox,
          Text(
            topic.title.value(isArabic),
            style: const TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.w800,
              fontSize: 16,
              height: 1.25,
            ),
          ),
          6.heightBox,
          Text(
            topic.summary.value(isArabic),
            style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12, height: 1.45),
          ),
        ],
      ),
    );
  }
}

class _ExplainCard extends StatelessWidget {
  const _ExplainCard({
    required this.icon,
    required this.title,
    required this.child,
  });

  final IconData icon;
  final String title;
  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: const Color(0xFF172033),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: const Color(0xFF14B8A6), size: 19),
              8.widthBox,
              Expanded(
                child: Text(
                  title,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w800,
                    fontSize: 13.5,
                  ),
                ),
              ),
            ],
          ),
          10.heightBox,
          child,
        ],
      ),
    );
  }
}

class _BulletList extends StatelessWidget {
  const _BulletList({required this.items});

  final List<LocalText> items;

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocaleScope.of(context).isArabic;

    return Column(
      children: [
        for (final item in items)
          Padding(
            padding: const EdgeInsets.only(bottom: 8),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Icon(
                  Icons.check_circle_rounded,
                  color: Color(0xFF34D399),
                  size: 18,
                ),
                8.widthBox,
                Expanded(
                  child: Text(
                    item.value(isArabic),
                    style: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _NumberedList extends StatelessWidget {
  const _NumberedList({required this.items});

  final List<LocalText> items;

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocaleScope.of(context).isArabic;

    return Column(
      children: [
        for (final entry in items.indexed)
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CircleAvatar(
                  radius: 13,
                  backgroundColor: const Color(0xFF14B8A6),
                  child: Text(
                    '${entry.$1 + 1}',
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                ),
                10.widthBox,
                Expanded(
                  child: Text(
                    entry.$2.value(isArabic),
                    style: const TextStyle(
                      color: Color(0xFFCBD5E1),
                      height: 1.45,
                    ),
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    final isArabic = AppLocaleScope.of(context).isArabic;

    return CopyableCodeBlock(
      code: code,
      copiedMessage: isArabic ? 'تم نسخ الكود' : 'Code copied',
      copyTooltip: isArabic ? 'نسخ الكود' : 'Copy code',
      showPlaygroundAction: false,
    );
  }
}
