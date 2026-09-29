import 'package:flutter/material.dart';
import '../../../core/services/ai_assistant_service.dart';
import 'ai_markdown_view.dart';
import 'ai_typing_indicator.dart';

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
      backgroundColor: const Color(0xFF070B14),
      barrierColor: Colors.black.withValues(alpha: 0.7),
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
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
  final ScrollController _scrollController = ScrollController();
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
    _askAssistant('اشرح لي أهمية وتطبيق هذا المفهوم في بيئة الإنتاج الحقيقية');
  }

  @override
  void dispose() {
    _promptController.dispose();
    _scrollController.dispose();
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
          backgroundColor: const Color(0xFF0F172A),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
            side: const BorderSide(color: Color(0xFF1E293B)),
          ),
          title: const Row(
            children: [
              Icon(Icons.vpn_key_rounded, color: Color(0xFF5EEAD4), size: 20),
              SizedBox(width: 8),
              Text('إعدادات مفتاح المساعد (API Key)', style: TextStyle(color: Colors.white, fontSize: 15)),
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
                            'المفتاح مفعّل ومحمي بأمان 🔒',
                            style: TextStyle(color: Color(0xFFD1FAE5), fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 12),
                ],
                Text(
                  _aiService.hasApiKey
                      ? 'لتغيير المفتاح الحالي، الصق المفتاح الجديد هنا:'
                      : 'أدخل مفتاح الـ API الخاص بك للحصول على ردود حية فائقة السرعة:',
                  style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12),
                ),
                const SizedBox(height: 10),
                TextField(
                  controller: keyController,
                  obscureText: isObscured,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    hintText: _aiService.hasApiKey ? '••••••••••••••••••••••••' : 'AIzaSy...',
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
                const SizedBox(height: 10),
                const Text(
                  '💡 يمكنك الحصول على مفتاح مجاني من: aistudio.google.com',
                  style: TextStyle(color: Color(0xFF5EEAD4), fontSize: 11),
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء', style: TextStyle(color: Colors.white70)),
            ),
            ElevatedButton(
              onPressed: () async {
                if (keyController.text.trim().isNotEmpty) {
                  await _aiService.saveApiKey(keyController.text.trim());
                }
                if (ctx.mounted) Navigator.pop(ctx);
                setState(() {});
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
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: MediaQuery.of(context).size.height * 0.82,
        decoration: const BoxDecoration(
          color: Color(0xFF070B14),
          borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // مقبض السحب العلوي (Drag Handle)
            Center(
              child: Container(
                margin: const EdgeInsets.only(top: 10, bottom: 8),
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: const Color(0xFF334155),
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),

            // شريط العنوان والسياق
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF14B8A6), Color(0xFF0284C7)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                    ),
                    child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
                  ),
                  const SizedBox(width: 10),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          'Flutter AI Copilot (Contextual)',
                          style: TextStyle(color: Colors.white, fontWeight: FontWeight.w800, fontSize: 13.5),
                        ),
                        Text(
                          widget.topicTitle,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(color: Color(0xFF5EEAD4), fontSize: 11.5, fontWeight: FontWeight.w600),
                        ),
                      ],
                    ),
                  ),
                  IconButton(
                    tooltip: 'إعدادات API Key',
                    icon: Icon(
                      _aiService.hasApiKey ? Icons.vpn_key_rounded : Icons.vpn_key_outlined,
                      color: _aiService.hasApiKey ? const Color(0xFF34D399) : const Color(0xFFF59E0B),
                      size: 19,
                    ),
                    onPressed: _showApiKeyDialog,
                  ),
                  IconButton(
                    icon: const Icon(Icons.close_rounded, color: Color(0xFF94A3B8)),
                    onPressed: () => Navigator.pop(context),
                  ),
                ],
              ),
            ),
            const Divider(color: Color(0xFF1E293B), height: 1),

            // أزرار الاقتراحات السريعة
            Container(
              padding: const EdgeInsets.symmetric(vertical: 8),
              color: const Color(0xFF0B1220),
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(horizontal: 14),
                child: Row(
                  children: _quickPrompts.map((prompt) {
                    return Padding(
                      padding: const EdgeInsets.only(right: 8),
                      child: InkWell(
                        onTap: () => _askAssistant(prompt),
                        borderRadius: BorderRadius.circular(12),
                        child: Container(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                          decoration: BoxDecoration(
                            color: const Color(0xFF101828),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(color: const Color(0xFF14B8A6).withValues(alpha: 0.3)),
                          ),
                          child: Text(
                            prompt,
                            style: const TextStyle(
                              color: Color(0xFF5EEAD4),
                              fontSize: 11,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
            ),

            // مساحة عرض إجابة المساعد الذكي
            Expanded(
              child: Container(
                margin: const EdgeInsets.all(14),
                padding: const EdgeInsets.all(14),
                decoration: BoxDecoration(
                  color: const Color(0xFF0D1527),
                  borderRadius: BorderRadius.circular(14),
                  border: Border.all(color: const Color(0xFF1E293B)),
                ),
                child: _isLoading
                    ? const Center(
                        child: AiTypingIndicator(
                          statusText: 'المساعد الذكي يحلل الكود والموضوع في بيئة الإنتاج...',
                        ),
                      )
                    : SingleChildScrollView(
                        controller: _scrollController,
                        child: AiMarkdownView(data: _aiResponse),
                      ),
              ),
            ),

            // حقل كتابة سؤال مخصص
            Container(
              padding: const EdgeInsets.fromLTRB(14, 0, 14, 14),
              child: Row(
                children: [
                  Expanded(
                    child: Container(
                      decoration: BoxDecoration(
                        color: const Color(0xFF101828),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(color: const Color(0xFF24324A)),
                      ),
                      child: TextField(
                        controller: _promptController,
                        style: const TextStyle(color: Colors.white, fontSize: 12.5),
                        decoration: const InputDecoration(
                          hintText: 'اسأل عن أي تفصيل في هذا الموضوع...',
                          hintStyle: TextStyle(color: Color(0xFF64748B), fontSize: 11.5),
                          border: InputBorder.none,
                          enabledBorder: InputBorder.none,
                          focusedBorder: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(horizontal: 14, vertical: 10),
                        ),
                        onSubmitted: (val) {
                          if (val.trim().isNotEmpty) {
                            _askAssistant(val.trim());
                            _promptController.clear();
                          }
                        },
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    height: 40,
                    width: 40,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                      ),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: IconButton(
                      icon: const Icon(Icons.send_rounded, color: Color(0xFF04111C), size: 17),
                      onPressed: () {
                        final text = _promptController.text.trim();
                        if (text.isNotEmpty) {
                          _askAssistant(text);
                          _promptController.clear();
                        }
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
