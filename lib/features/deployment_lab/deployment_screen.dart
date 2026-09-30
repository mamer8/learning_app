import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';

/// 🚀 مختبر النشر على المتاجر وهندسة الإصدارات (App Stores & CI/CD)
class DeploymentScreen extends StatefulWidget {
  const DeploymentScreen({super.key});

  @override
  State<DeploymentScreen> createState() => _DeploymentScreenState();
}

class _DeploymentScreenState extends State<DeploymentScreen> {
  final Map<String, bool> _checklist = {
    'تم إنشاء upload-keystore.jks وضبط key.properties بأمان': true,
    'تفعيل تشفير الكود (Code Obfuscation & R8/ProGuard)': true,
    'ضبط نصوص أذونات الصلاحيات في Info.plist لـ iOS': false,
    'ربط معرّف التطبيق بـ Apple Distribution Certificate': false,
    'اجتياز جميع اختبارات الـ Unit & Widget Tests': true,
    'زيادة رقم الإصدار (Version Code & Build Number)': true,
  };

  int _selectedCommandIndex = 0;
  bool _isRunningPipeline = false;
  int _pipelineStep = 0;

  final List<({String title, String desc, String command})> _commands = [
    (
      title: 'Google Play Bundle (.aab)',
      desc: 'بناء الحزمة المحسنة للمتجر مع تشفير الرموز',
      command:
          'flutter build appbundle --release \\\n'
          '  --obfuscate \\\n'
          '  --split-debug-info=./build/app/outputs/symbols',
    ),
    (
      title: 'Apple App Store (.ipa)',
      desc: 'بناء أرشيف iOS للرفع إلى TestFlight و App Store Connect',
      command:
          'flutter build ipa --release \\\n'
          '  --obfuscate \\\n'
          '  --split-debug-info=./build/ios/symbols',
    ),
    (
      title: 'Universal Split APKs',
      desc: 'توليد ملفات APK منفصلة لكل معمارية (arm64, armeabi) لتقليص الحجم 60%',
      command: 'flutter build apk --release --split-per-abi',
    ),
  ];

  void _openAiAssistant() {
    ContextualAiSheet.show(
      context,
      topicTitle: 'مختبر النشر على المتاجر وهندسة الإصدارات CI/CD',
      topicCode: _buildDynamicCiCdCode(),
      levelTitle: 'مستوى خبير (DevOps & Mobile Release Engineering)',
      isArabic: true,
    );
  }

  String _buildDynamicCiCdCode() {
    final activeCommand = _commands[_selectedCommandIndex].command;
    final completedCount = _checklist.values.where((v) => v).length;
    return '# === GitHub Actions Workflow (.github/workflows/deploy.yml) ===\n'
        '# حالة الجاهزية الحالية: $completedCount من ${_checklist.length} متطلبات مكتملة\n'
        '# مرحلة الـ Pipeline الحالية: Step $_pipelineStep / 4 (${_isRunningPipeline ? "Running..." : "Idle"})\n\n'
        'name: Production Release Pipeline\n'
        'on:\n'
        '  push:\n'
        '    branches: [ main ]\n'
        'jobs:\n'
        '  build:\n'
        '    runs-on: ubuntu-latest\n'
        '    steps:\n'
        '      - uses: actions/checkout@v4\n'
        '      - uses: subosito/flutter-action@v2\n'
        '        with:\n'
        '          channel: "stable"\n'
        '      - name: Analyze & Test\n'
        '        run: |\n'
        '          flutter analyze\n'
        '          flutter test\n'
        '      - name: Build Target Artifact (${_commands[_selectedCommandIndex].title})\n'
        '        run: |\n'
        '          ${activeCommand.replaceAll("\n", "\n          ")}';
  }

  Future<void> _runPipelineSimulation() async {
    setState(() {
      _isRunningPipeline = true;
      _pipelineStep = 1;
    });

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _pipelineStep = 2);

    await Future.delayed(const Duration(milliseconds: 700));
    if (!mounted) return;
    setState(() => _pipelineStep = 3);

    await Future.delayed(const Duration(milliseconds: 800));
    if (!mounted) return;
    setState(() {
      _pipelineStep = 4;
      _isRunningPipeline = false;
    });

    context.showSuccessSnackBar(
      'اكتمل خط إنتاج CI/CD وتم بناء الحزم واجتياز الفحص بنجاح!',
      title: 'Pipeline Passed ✅',
    );
  }

  @override
  Widget build(BuildContext context) {
    final completedCount = _checklist.values.where((v) => v).length;
    final progress = completedCount / _checklist.length;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('مختبر النشر على المتاجر و CI/CD'),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            icon: const Icon(Icons.auto_awesome, color: Color(0xFFF59E0B)),
            tooltip: 'اسأل الذكاء الاصطناعي عن CI/CD والنشر',
            onPressed: _openAiAssistant,
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        backgroundColor: const Color(0xFFF59E0B),
        foregroundColor: const Color(0xFF04111C),
        icon: const Icon(Icons.auto_awesome),
        label: const Text('اسأل الـ AI عن النشر', style: TextStyle(fontWeight: FontWeight.bold)),
        onPressed: _openAiAssistant,
      ),
      body: ResponsiveContentWrapper(
        maxWidth: 1200,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // بطاقة الشرح
              _buildExplanationCard(),
              16.heightBox,

              // مقياس الجاهزية للإنتاج
              _buildReadinessCard(completedCount, progress),
              16.heightBox,

              // قائمة الفحص التفاعلية (Checklist)
              _buildChecklistCard(),
              16.heightBox,

              // مولد أوامر البناء
              _buildCommandGeneratorCard(),
              16.heightBox,

              // محاكي CI/CD Pipeline
              _buildPipelineSimulatorCard(),
              16.heightBox,

              // كود GitHub Actions التفاعلي الحي
              _buildCiCdYamlCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildExplanationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.verified_rounded, color: Color(0xFFF59E0B), size: 22),
              8.widthBox,
              const Text(
                'قواعد النشر الاحترافي للإنتاج (Production Release)',
                style: TextStyle(color: Color(0xFFF59E0B), fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          8.heightBox,
          const Text(
            '1. Google Play: لا ترفع ملف APK بل ارفع .aab لتقليص الحجم 50% وتوليد حزم مخصصة لكل جهاز.\n'
            '2. App Store: تأكد من إضافة نصوص الـ Usage Descriptions في Info.plist لتفادي الرفض التلقائي.\n'
            '3. Obfuscation: تشفير أسماء الكلاسات والدوال في الحزمة لمنع فك الكود وهندسته عكسياً.',
            style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.45),
          ),
        ],
      ),
    );
  }

  Widget _buildReadinessCard(int completedCount, double progress) {
    final isReady = progress == 1.0;

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isReady ? Colors.greenAccent : const Color(0xFFF59E0B).withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '📊 مقياس جاهزية التطبيق للإطلاق:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Text(
                '${(progress * 100).toInt()}%',
                style: TextStyle(
                  color: isReady ? Colors.greenAccent : const Color(0xFFF59E0B),
                  fontWeight: FontWeight.w900,
                  fontSize: 16,
                ),
              ),
            ],
          ),
          10.heightBox,
          ClipRRect(
            borderRadius: BorderRadius.circular(999),
            child: LinearProgressIndicator(
              value: progress,
              minHeight: 8,
              backgroundColor: const Color(0xFF0F172A),
              valueColor: AlwaysStoppedAnimation(
                isReady ? Colors.greenAccent : const Color(0xFFF59E0B),
              ),
            ),
          ),
          8.heightBox,
          Text(
            isReady
                ? 'جاهز تماماً للإطلاق على المتاجر بدون أي معوقات! 🚀'
                : 'اكتمل $completedCount من ${_checklist.length} متطلبات أساسية.',
            style: TextStyle(
              color: isReady ? Colors.greenAccent : Colors.white60,
              fontSize: 11.5,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildChecklistCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📝 قائمة المتطلبات الأساسية قبل الرفع:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          8.heightBox,
          ..._checklist.entries.map((entry) {
            return CheckboxListTile(
              title: Text(entry.key, style: const TextStyle(color: Colors.white70, fontSize: 12)),
              value: entry.value,
              activeColor: Colors.greenAccent,
              checkColor: const Color(0xFF04111C),
              contentPadding: EdgeInsets.zero,
              dense: true,
              onChanged: (val) {
                setState(() => _checklist[entry.key] = val ?? false);
              },
            );
          }),
        ],
      ),
    );
  }

  Widget _buildCommandGeneratorCard() {
    final cmd = _commands[_selectedCommandIndex];

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '⚡ مولد أوامر البناء للإنتاج (Production Build Generator):',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          12.heightBox,
          Wrap(
            spacing: 8,
            children: List.generate(_commands.length, (i) {
              final isSelected = _selectedCommandIndex == i;
              return ChoiceChip(
                label: Text(_commands[i].title),
                selected: isSelected,
                selectedColor: const Color(0xFFF59E0B).withValues(alpha: 0.25),
                backgroundColor: const Color(0xFF0F172A),
                labelStyle: TextStyle(
                  color: isSelected ? const Color(0xFFF59E0B) : Colors.white70,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
                onSelected: (val) {
                  if (val) setState(() => _selectedCommandIndex = i);
                },
              );
            }),
          ),
          10.heightBox,
          Text(cmd.desc, style: const TextStyle(color: Colors.white60, fontSize: 11.5)),
          10.heightBox,
          CopyableCodeBlock(
            code: cmd.command,
            language: 'Terminal / Bash',
            copiedMessage: 'تم نسخ أمر البناء',
            copyTooltip: 'نسخ الأمر',
          ),
        ],
      ),
    );
  }

  Widget _buildPipelineSimulatorCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFF38BDF8).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🤖 محاكي خط إنتاج GitHub Actions CI/CD:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              ElevatedButton.icon(
                onPressed: _isRunningPipeline ? null : _runPipelineSimulation,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF38BDF8),
                  foregroundColor: const Color(0xFF04111C),
                  padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: _isRunningPipeline
                    ? const SizedBox(
                        width: 14,
                        height: 14,
                        child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF04111C)),
                      )
                    : const Icon(Icons.play_arrow_rounded, size: 18),
                label: const Text('تشغيل الـ Pipeline', style: TextStyle(fontSize: 11, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          14.heightBox,
          _buildPipelineStep(1, 'فحص الكود (flutter analyze)', _pipelineStep >= 1, _pipelineStep == 1),
          _buildPipelineStep(2, 'تشغيل الاختبارات (flutter test)', _pipelineStep >= 2, _pipelineStep == 2),
          _buildPipelineStep(3, 'بناء الحزمة المشفرة (flutter build appbundle)', _pipelineStep >= 3, _pipelineStep == 3),
          _buildPipelineStep(4, 'رفع الحزمة للـ Artifacts والمتجر (Upload to Store)', _pipelineStep >= 4, false),
        ],
      ),
    );
  }

  Widget _buildPipelineStep(int step, String title, bool isDone, bool isCurrent) {
    Color color = Colors.white38;
    IconData icon = Icons.circle_outlined;

    if (isCurrent) {
      color = Colors.cyanAccent;
      icon = Icons.autorenew_rounded;
    } else if (isDone) {
      color = Colors.greenAccent;
      icon = Icons.check_circle_rounded;
    }

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        children: [
          Icon(icon, color: color, size: 18),
          10.widthBox,
          Expanded(
            child: Text(
              title,
              style: TextStyle(color: color, fontSize: 12, fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCiCdYamlCard() {
    final yamlCode = _buildDynamicCiCdCode();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '🤖 كود الـ CI/CD Pipeline الحي (.github/workflows):',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFFF59E0B).withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: const Text('Dynamic Live Code', style: TextStyle(color: Color(0xFFF59E0B), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          10.heightBox,
          CopyableCodeBlock(
            code: yamlCode,
            language: 'YAML / GitHub Actions',
            copiedMessage: 'تم نسخ ملف الـ CI/CD المحدث',
            copyTooltip: 'نسخ ملف الـ CI/CD',
          ),
        ],
      ),
    );
  }
}
