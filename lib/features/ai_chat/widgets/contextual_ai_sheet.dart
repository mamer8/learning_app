import 'package:flutter/material.dart';
import '../../../core/core.dart';
import '../../../core/services/ai_assistant_service.dart';

/// نافذة المساعد الذكي التفاعلية المنبثقة من أسفل الشاشة (Contextual AI Sheet)
class ContextualAiSheet extends StatefulWidget {
  const ContextualAiSheet({
    required this.topicTitle,
    required this.topicCode,
    this.levelTitle,
    this.isArabic = true,
    super.key,
  });

  final String topicTitle;
  final String topicCode;
  final String? levelTitle;
  final bool isArabic;

  static void show(
    BuildContext context, {
    required String topicTitle,
    required String topicCode,
    String? levelTitle,
    bool isArabic = true,
  }) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: const Color(0xFF0F172A),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (_) => ContextualAiSheet(
        topicTitle: topicTitle,
        topicCode: topicCode,
        levelTitle: levelTitle,
        isArabic: isArabic,
      ),
    );
  }

  @override
  State<ContextualAiSheet> createState() => _ContextualAiSheetState();
}

class _ContextualAiSheetState extends State<ContextualAiSheet> {
  final TextEditingController _promptController = TextEditingController();
  final AiAssistantService _aiService = AiAssistantService.instance;

  bool _isLoading = false;
  String _aiResponse = '';

  final List<String> _quickPrompts = [
    'اشرح لي هذا الكود بمثال وسيناريو عملي',
    'كيف أكتب Unit Tests لاختبار هذا المفهوم؟',
    'ما هي البدائل الشائعة ومقارنة الأداء؟',
    'ما هي أشهر الأخطاء الشائعة في بيئة الإنتاج؟',
  ];

  @override
  void initState() {
    super.initState();
    // إرسال طلب الشرح الافتراضي عند فتح النافذة
    _askAssistant('اشرح لي أهمية وتطبيق هذا المفهوم في بيئة الإنتاج');
  }

  @override
  void dispose() {
    _promptController.dispose();
    super.dispose();
  }

  Future<void> _askAssistant(String query) async {
    setState(() {
      _isLoading = true;
      _aiResponse = '';
    });

    final response = await _aiService.askAi(
      userPrompt: query,
      topicTitle: widget.topicTitle,
      topicCode: widget.topicCode,
      levelTitle: widget.levelTitle,
      isArabic: widget.isArabic,
    );

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _aiResponse = response;
    });
  }

  void _showApiKeyDialog() {
    final keyController = TextEditingController();
    bool isObscured = true;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          backgroundColor: const Color(0xFF1E293B),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          title: const Row(
            children: [
              Icon(Icons.vpn_key_rounded, color: Color(0xFF14B8A6)),
              SizedBox(width: 8),
              Text('إعدادات مفتاح الذكاء الاصطناعي', style: TextStyle(color: Colors.white, fontSize: 15)),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_aiService.hasApiKey) ...[
                  Container(
                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 8),
                    decoration: BoxDecoration(
                      color: const Color(0xFF064E3B),
                      borderRadius: BorderRadius.circular(8),
                      border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.4)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified_user_rounded, color: Color(0xFF34D399), size: 18),
                        SizedBox(width: 8),
                        Expanded(
                          child: Text(
                            'المفتاح مفعّل ومحمي بأمان 🔒 (Gemini Live)',
                            style: TextStyle(color: Color(0xFFD1FAE5), fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  12.heightBox,
                ],
                Text(
                  _aiService.hasApiKey
                      ? 'لتغيير المفتاح الحالي، الصق المفتاح الجديد هنا:'
                      : 'أدخل مفتاح Gemini API الخاص بك للحصول على ردود حية ومباشرة:',
                  style: const TextStyle(color: Colors.white70, fontSize: 12),
                ),
                10.heightBox,
                TextField(
                  controller: keyController,
                  obscureText: isObscured,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF0F172A),
                    hintText: _aiService.hasApiKey ? '••••••••••••••••••••••••' : 'الصق المفتاح هنا...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: Colors.white38,
                        size: 18,
                      ),
                      onPressed: () {
                        setDialogState(() {
                          isObscured = !isObscured;
                        });
                      },
                    ),
                  ),
                ),
                8.heightBox,
                const Text(
                  '💡 يمكنك الحصول عليه مجاناً من: aistudio.google.com',
                  style: TextStyle(color: Colors.cyanAccent, fontSize: 11),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (keyController.text.trim().isNotEmpty) {
                  await _aiService.saveApiKey(keyController.text.trim());
                }
                if (ctx.mounted) Navigator.pop(ctx);
                _askAssistant('مرحباً، تم ضبط وتفعيل المفتاح بنجاح!');
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF14B8A6),
                foregroundColor: const Color(0xFF04111C),
              ),
              child: const Text('حفظ المفتاح'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: 16,
        right: 16,
        top: 16,
        bottom: MediaQuery.of(context).viewInsets.bottom + 16,
      ),
      child: SizedBox(
        height: MediaQuery.of(context).size.height * 0.75,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // شريط السحب والإغلاق
            Row(
              children: [
                Container(
                  padding: const EdgeInsets.all(8),
                  decoration: BoxDecoration(
                    color: const Color(0xFF14B8A6).withValues(alpha: 0.15),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Icon(Icons.psychology_rounded, color: Color(0xFF14B8A6), size: 22),
                ),
                10.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        'مساعد Flutter الذكي (AI Copilot)',
                        style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
                      ),
                      Text(
                        'سياق الموضوع: ${widget.topicTitle}',
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11.5),
                      ),
                    ],
                  ),
                ),
                IconButton(
                  tooltip: 'إعدادات API Key',
                  icon: Icon(
                    _aiService.hasApiKey ? Icons.key_rounded : Icons.key_off_rounded,
                    color: _aiService.hasApiKey ? Colors.greenAccent : Colors.amberAccent,
                    size: 20,
                  ),
                  onPressed: _showApiKeyDialog,
                ),
                IconButton(
                  icon: const Icon(Icons.close_rounded, color: Colors.white60),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            12.heightBox,

            // أزرار الاقتراحات السريعة
            SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _quickPrompts.map((prompt) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: ActionChip(
                      label: Text(prompt),
                      backgroundColor: const Color(0xFF1E293B),
                      side: const BorderSide(color: Color(0xFF24324A)),
                      labelStyle: const TextStyle(color: Color(0xFF5EEAD4), fontSize: 11),
                      onPressed: () => _askAssistant(prompt),
                    ),
                  );
                }).toList(),
              ),
            ),
            12.heightBox,

            // مساحة عرض إجابة المساعد الذكي
            Expanded(
              child: Container(
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF101828),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: const Color(0xFF24324A)),
                ),
                child: _isLoading
                    ? const Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            CircularProgressIndicator(color: Color(0xFF14B8A6)),
                            SizedBox(height: 12),
                            Text('المساعد الذكي يحلل الكود والموضوع...', style: TextStyle(color: Colors.white70, fontSize: 12)),
                          ],
                        ),
                      )
                    : SingleChildScrollView(
                        child: Text(
                          _aiResponse,
                          style: const TextStyle(color: Color(0xFFE2E8F0), height: 1.55, fontSize: 12.5),
                        ),
                      ),
              ),
            ),
            12.heightBox,

            // حقل كتابة سؤال مخصص
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _promptController,
                    style: const TextStyle(color: Colors.white, fontSize: 12.5),
                    decoration: InputDecoration(
                      filled: true,
                      fillColor: const Color(0xFF1E293B),
                      hintText: 'اسأل عن أي شيء يخص هذا الموضوع...',
                      hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                      border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
                    ),
                    onSubmitted: (val) {
                      if (val.trim().isNotEmpty) {
                        _askAssistant(val.trim());
                        _promptController.clear();
                      }
                    },
                  ),
                ),
                8.widthBox,
                IconButton(
                  icon: const Icon(Icons.send_rounded, color: Color(0xFF14B8A6)),
                  onPressed: () {
                    final text = _promptController.text.trim();
                    if (text.isNotEmpty) {
                      _askAssistant(text);
                      _promptController.clear();
                    }
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
