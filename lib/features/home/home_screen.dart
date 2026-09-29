import 'package:flutter/material.dart';

import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
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
    final s = locale.strings;
    final labs = _buildLabs(context, s);

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        body: SafeArea(
          child: CustomScrollView(
            slivers: [
              SliverAppBar(
                pinned: true,
                title: Text(s.t('dashboard')),
                actions: [
                  TextButton.icon(
                    onPressed: locale.onToggleLanguage,
                    icon: const Icon(Icons.language_rounded),
                    label: Text(s.t('language')),
                  ),
                  IconButton(
                    tooltip: s.t('about'),
                    onPressed: () => _showAbout(context),
                    icon: const Icon(Icons.info_outline_rounded),
                  ),
                  8.widthBox,
                ],
              ),
              SliverPadding(
                padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                sliver: SliverList.list(
                  children: [
                    _HeroPanel(strings: s),
                    16.heightBox,
                    _StatsRow(strings: s),
                    16.heightBox,
                    _LevelPath(strings: s),
                    16.heightBox,
                    _SectionIntro(
                      icon: Icons.grid_view_rounded,
                      title: s.t('availableLabs'),
                      subtitle: s.t('overviewBody'),
                    ),
                    12.heightBox,
                    _LabsGrid(labs: labs),
                    16.heightBox,
                    _StudyPlan(strings: s),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<_LearningLab> _buildLabs(BuildContext context, AppStrings s) {
    return [
      _LearningLab(
        level: '01',
        title: s.t('isolateTitle'),
        description: s.t('isolateBody'),
        badge: s.t('performance'),
        icon: Icons.memory_rounded,
        color: const Color(0xFF22D3EE),
        code:
            'final result = await Isolate.run(() {\n'
            '  return parseLargeJson(payload);\n'
            '});',
        onTap: () => context.push(const IsolatesScreen()),
      ),
      _LearningLab(
        level: '02',
        title: s.t('debounceTitle'),
        description: s.t('debounceBody'),
        badge: s.t('foundations'),
        icon: Icons.speed_rounded,
        color: const Color(0xFFF59E0B),
        code:
            'debouncer.run(() {\n'
            '  searchRepository.query(text);\n'
            '});',
        onTap: () => context.push(const DebouncerScreen()),
      ),
      _LearningLab(
        level: '03',
        title: s.t('repaintTitle'),
        description: s.t('repaintBody'),
        badge: s.t('performance'),
        icon: Icons.layers_rounded,
        color: const Color(0xFF34D399),
        code:
            'RepaintBoundary(\n'
            '  child: AnimatedChart(data: data),\n'
            ');',
        onTap: () => context.push(const RepaintBoundaryScreen()),
      ),
      _LearningLab(
        level: '04',
        title: s.t('keysTitle'),
        description: s.t('keysBody'),
        badge: s.t('mastery'),
        icon: Icons.account_tree_rounded,
        color: const Color(0xFFA78BFA),
        code:
            'ListTile(\n'
            '  key: ValueKey(user.id),\n'
            '  title: Text(user.name),\n'
            ');',
        onTap: () => context.push(const KeysScreen()),
      ),
      _LearningLab(
        level: '05',
        title: s.t('errorsTitle'),
        description: s.t('errorsBody'),
        badge: s.t('architecture'),
        icon: Icons.verified_user_rounded,
        color: const Color(0xFF60A5FA),
        code:
            'final result = await repo.getUser();\n'
            'result.fold(emitFailure, emitUser);',
        onTap: () => context.push(const ErrorHandlingScreen()),
      ),
      _LearningLab(
        level: '06',
        title: s.t('extensionsTitle'),
        description: s.t('extensionsBody'),
        badge: s.t('foundations'),
        icon: Icons.extension_rounded,
        color: const Color(0xFFFB7185),
        code:
            'context.showSuccessSnackBar(\n'
            '  "Saved successfully",\n'
            ');',
        onTap: () => context.push(const ExtensionsScreen()),
      ),
    ];
  }

  void _showAbout(BuildContext context) {
    final s = AppLocaleScope.of(context).strings;

    showModalBottomSheet<void>(
      context: context,
      showDragHandle: true,
      backgroundColor: const Color(0xFF172033),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (context) {
        return Padding(
          padding: const EdgeInsets.fromLTRB(20, 8, 20, 24),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Row(
                children: [
                  const Icon(Icons.school_rounded, color: Color(0xFF14B8A6)),
                  10.widthBox,
                  Expanded(
                    child: Text(
                      s.t('about'),
                      style: Theme.of(context).textTheme.titleMedium,
                    ),
                  ),
                ],
              ),
              12.heightBox,
              Text(
                s.t('aboutBody'),
                style: const TextStyle(color: Color(0xFFCBD5E1)),
              ),
              20.heightBox,
              FilledButton(
                onPressed: () => Navigator.of(context).pop(),
                child: Text(s.t('close')),
              ),
            ],
          ),
        );
      },
    );
  }
}

class _HeroPanel extends StatelessWidget {
  const _HeroPanel({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(8),
        color: const Color(0xFF101828),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
            decoration: BoxDecoration(
              color: const Color(0xFF14B8A6).withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(999),
            ),
            child: Text(
              strings.t('level'),
              style: const TextStyle(
                color: Color(0xFF5EEAD4),
                fontWeight: FontWeight.w700,
                fontSize: 12,
              ),
            ),
          ),
          12.heightBox,
          Text(
            strings.t('appTitle'),
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontWeight: FontWeight.w900,
              color: Colors.white,
            ),
          ),
          8.heightBox,
          Text(
            strings.t('appSubtitle'),
            style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 14),
          ),
          18.heightBox,
          Wrap(
            spacing: 10,
            runSpacing: 10,
            children: [
              FilledButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.play_arrow_rounded),
                label: Text(strings.t('startLearning')),
              ),
              OutlinedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.code_rounded),
                label: Text(strings.t('code')),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _StatsRow extends StatelessWidget {
  const _StatsRow({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: _StatTile(label: strings.t('progress'), value: '68%'),
        ),
        10.widthBox,
        Expanded(
          child: _StatTile(label: strings.t('lessons'), value: '24'),
        ),
        10.widthBox,
        Expanded(
          child: _StatTile(label: strings.t('labs'), value: '6'),
        ),
      ],
    );
  }
}

class _StatTile extends StatelessWidget {
  const _StatTile({required this.label, required this.value});

  final String label;
  final String value;

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
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 12),
          ),
        ],
      ),
    );
  }
}

class _LevelPath extends StatelessWidget {
  const _LevelPath({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    final levels = [
      strings.t('foundations'),
      strings.t('performance'),
      strings.t('architecture'),
      strings.t('mastery'),
    ];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF172033),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionIntro(
            icon: Icons.route_rounded,
            title: strings.t('trackTitle'),
            subtitle: strings.t('trackSubtitle'),
          ),
          14.heightBox,
          ...levels.indexed.map((entry) {
            final index = entry.$1;
            final title = entry.$2;
            final active = index < 2;
            return Padding(
              padding: EdgeInsets.only(
                bottom: index == levels.length - 1 ? 0 : 12,
              ),
              child: Row(
                children: [
                  CircleAvatar(
                    radius: 15,
                    backgroundColor: active
                        ? const Color(0xFF14B8A6)
                        : const Color(0xFF334155),
                    child: Text(
                      '${index + 1}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.w800,
                        fontSize: 12,
                      ),
                    ),
                  ),
                  10.widthBox,
                  Expanded(
                    child: Text(
                      title,
                      style: TextStyle(
                        color: active ? Colors.white : const Color(0xFF94A3B8),
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                  Icon(
                    active
                        ? Icons.check_circle_rounded
                        : Icons.radio_button_unchecked_rounded,
                    color: active
                        ? const Color(0xFF34D399)
                        : const Color(0xFF64748B),
                    size: 20,
                  ),
                ],
              ),
            );
          }),
        ],
      ),
    );
  }
}

class _LabsGrid extends StatelessWidget {
  const _LabsGrid({required this.labs});

  final List<_LearningLab> labs;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        final isWide = constraints.maxWidth >= 760;
        if (!isWide) {
          return Column(
            children: [
              for (final lab in labs) ...[
                _LabCard(lab: lab),
                if (lab != labs.last) 12.heightBox,
              ],
            ],
          );
        }

        return GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: labs.length,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisCount: 2,
            mainAxisSpacing: 12,
            crossAxisSpacing: 12,
            childAspectRatio: 1.35,
          ),
          itemBuilder: (context, index) => _LabCard(lab: labs[index]),
        );
      },
    );
  }
}

class _LabCard extends StatelessWidget {
  const _LabCard({required this.lab});

  final _LearningLab lab;

  @override
  Widget build(BuildContext context) {
    final s = AppLocaleScope.of(context).strings;

    return InkWell(
      onTap: lab.onTap,
      borderRadius: BorderRadius.circular(8),
      child: Ink(
        padding: const EdgeInsets.all(16),
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
                Container(
                  width: 42,
                  height: 42,
                  decoration: BoxDecoration(
                    color: lab.color.withValues(alpha: 0.14),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(lab.icon, color: lab.color),
                ),
                10.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '${s.t('level')} ${lab.level}',
                        style: TextStyle(
                          color: lab.color,
                          fontWeight: FontWeight.w800,
                          fontSize: 11,
                        ),
                      ),
                      Text(
                        lab.title,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            12.heightBox,
            Text(
              lab.description,
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 13),
            ),
            12.heightBox,
            _CodeBlock(code: lab.code),
            12.heightBox,
            Row(
              children: [
                Expanded(
                  child: Text(
                    lab.badge,
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      color: Color(0xFF94A3B8),
                      fontWeight: FontWeight.w700,
                      fontSize: 12,
                    ),
                  ),
                ),
                Text(
                  s.t('continueLab'),
                  style: TextStyle(
                    color: lab.color,
                    fontWeight: FontWeight.w800,
                    fontSize: 12,
                  ),
                ),
                6.widthBox,
                Icon(Icons.arrow_forward_rounded, color: lab.color, size: 16),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _CodeBlock extends StatelessWidget {
  const _CodeBlock({required this.code});

  final String code;

  @override
  Widget build(BuildContext context) {
    return Directionality(
      textDirection: TextDirection.ltr,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: const Color(0xFF0B1220),
          borderRadius: BorderRadius.circular(8),
          border: Border.all(color: const Color(0xFF334155)),
        ),
        child: Text(
          code,
          maxLines: 3,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(
            color: Color(0xFFE2E8F0),
            fontFamily: 'monospace',
            fontSize: 12,
            height: 1.35,
          ),
        ),
      ),
    );
  }
}

class _StudyPlan extends StatelessWidget {
  const _StudyPlan({required this.strings});

  final AppStrings strings;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: const Color(0xFF24324A)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _SectionIntro(
            icon: Icons.task_alt_rounded,
            title: strings.t('studyPlan'),
            subtitle: strings.t('studyPlanBody'),
          ),
          12.heightBox,
          const _CodeBlock(
            code:
                '1. Read the concept\n'
                '2. Run the lab\n'
                '3. Change one value\n'
                '4. Observe the result',
          ),
        ],
      ),
    );
  }
}

class _SectionIntro extends StatelessWidget {
  const _SectionIntro({
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
        Icon(icon, color: const Color(0xFF14B8A6), size: 22),
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
                style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 13),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _LearningLab {
  const _LearningLab({
    required this.level,
    required this.title,
    required this.description,
    required this.badge,
    required this.icon,
    required this.color,
    required this.code,
    required this.onTap,
  });

  final String level;
  final String title;
  final String description;
  final String badge;
  final IconData icon;
  final Color color;
  final String code;
  final VoidCallback onTap;
}
