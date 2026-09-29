import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../core/core.dart';
import '../../core/services/ai_assistant_service.dart';

/// نموذج رسالة المحادثة
class ChatMessage {
  final String text;
  final bool isUser;
  final DateTime timestamp;

  ChatMessage({
    required this.text,
    required this.isUser,
    DateTime? timestamp,
  }) : timestamp = timestamp ?? DateTime.now();
}

/// شاشة المساعد الذكي الكاملة لـ Flutter (Dedicated AI Copilot Screen)
class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiAssistantService _aiService = AiAssistantService.instance;

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  final List<String> _suggestedTopics = [
    'كيف أصمم بنية Clean Architecture مع BLoC في مشروع حقيقي؟',
    'ما الفرق بين Isolates و compute() ومتى أستخدم كل منهما؟',
    'كيف أمنع الـ Memory Leaks وأحسن معدل الإطارات (60/120 FPS)؟',
    'اشرح لي آلية عمل QueuedInterceptor لتحديث JWT Token تلقائياً',
    'كيف أقوم بإعداد CI/CD مع GitHub Actions لرفع التطبيق للـ Stores؟',
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        isUser: false,
        text: 'أهلاً بك يا بطل! 👋\n'
            'أنا مساعد Flutter الذكي (AI Architect Copilot).\n'
            'يمكنك سؤالي عن أي استفسار في بنية المشاريع، إدارة الحالة، الأداء والذاكرة، كتابة الـ Tests، أو حل الأخطاء المعقدة.',
      ),
    );
  }

  @override
  void dispose() {
    _textController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  void _scrollToBottom() {
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (_scrollController.hasClients) {
        _scrollController.animateTo(
          _scrollController.position.maxScrollExtent,
          duration: const Duration(milliseconds: 300),
          curve: Curves.easeOut,
        );
      }
    });
  }

  Future<void> _sendMessage(String query) async {
    final text = query.trim();
    if (text.isEmpty || _isLoading) return;

    _textController.clear();
    setState(() {
      _messages.add(ChatMessage(text: text, isUser: true));
      _isLoading = true;
    });
    _scrollToBottom();

    try {
      final response = await _aiService.askAi(
        userPrompt: text,
        topicTitle: 'Flutter Engineering & Architecture',
        isArabic: true,
      );

      if (!mounted) return;
      setState(() {
        _messages.add(ChatMessage(text: response, isUser: false));
        _isLoading = false;
      });
      _scrollToBottom();
    } catch (e) {
      if (!mounted) return;
      setState(() {
        _messages.add(
          ChatMessage(
            text: '⚠️ حدث خطأ أثناء معالجة الرد: $e',
            isUser: false,
          ),
        );
        _isLoading = false;
      });
      _scrollToBottom();
    }
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
              Icon(Icons.vpn_key_rounded, color: Color(0xFF14B8A6), size: 22),
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
                      : 'أدخل مفتاح Gemini API الخاص بك لتفعيل الاتصال الحي:',
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
                12.heightBox,
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: const Color(0xFF0F172A),
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: const Color(0xFF14B8A6).withValues(alpha: 0.3)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text('📌 خطوات الحصول على المفتاح المجاني:', style: TextStyle(color: Color(0xFF5EEAD4), fontSize: 11.5, fontWeight: FontWeight.bold)),
                      4.heightBox,
                      const Text('1. ادخل على موقع: aistudio.google.com\n2. سجل بحساب Google الخاص بك\n3. اضغط زر "Get API key" ثم "Create API key"\n4. انسخ الكود والصقه هنا', style: TextStyle(color: Colors.white70, fontSize: 10.5, height: 1.4)),
                    ],
                  ),
                ),
              ],
            ),
          ),
          actions: [
            if (_aiService.hasApiKey)
              TextButton(
                onPressed: () async {
                  final messenger = ScaffoldMessenger.of(context);
                  await _aiService.removeApiKey();
                  if (ctx.mounted) Navigator.pop(ctx);
                  setState(() {});
                  messenger.showSnackBar(
                    const SnackBar(content: Text('تم حذف المفتاح والعودة للوضع التجريبي الذكي')),
                  );
                },
                child: const Text('حذف المفتاح', style: TextStyle(color: Colors.redAccent)),
              ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء'),
            ),
            ElevatedButton(
              onPressed: () async {
                final messenger = ScaffoldMessenger.of(context);
                if (keyController.text.trim().isNotEmpty) {
                  await _aiService.saveApiKey(keyController.text.trim());
                }
                if (ctx.mounted) Navigator.pop(ctx);
                setState(() {});
                messenger.showSnackBar(
                  const SnackBar(content: Text('✅ تم حفظ مفتاح API بنجاح ومزامنة Gemini AI!')),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF14B8A6),
                foregroundColor: const Color(0xFF04111C),
              ),
              child: const Text('حفظ وتفعيل'),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0B1120),
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: const Color(0xFF14B8A6).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.psychology_rounded, color: Color(0xFF14B8A6), size: 20),
            ),
            10.widthBox,
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text('Flutter AI Copilot', style: TextStyle(fontSize: 14.5, fontWeight: FontWeight.bold)),
                Row(
                  children: [
                    Container(
                      width: 6,
                      height: 6,
                      decoration: BoxDecoration(
                        color: _aiService.hasApiKey ? Colors.greenAccent : Colors.amberAccent,
                        shape: BoxShape.circle,
                      ),
                    ),
                    4.widthBox,
                    Text(
                      _aiService.hasApiKey ? 'Gemini 1.5 Live' : 'Smart Offline Mode',
                      style: TextStyle(
                        fontSize: 10,
                        color: _aiService.hasApiKey ? Colors.greenAccent : Colors.amberAccent,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ],
        ),
        actions: [
          IconButton(
            tooltip: 'إعدادات API Key',
            icon: Icon(
              _aiService.hasApiKey ? Icons.vpn_key_rounded : Icons.vpn_key_outlined,
              color: _aiService.hasApiKey ? const Color(0xFF14B8A6) : Colors.amberAccent,
              size: 21,
            ),
            onPressed: _showApiKeyDialog,
          ),
          IconButton(
            tooltip: 'مسح المحادثة',
            icon: const Icon(Icons.refresh_rounded, size: 20),
            onPressed: () {
              setState(() {
                _messages.clear();
                _messages.add(
                  ChatMessage(
                    isUser: false,
                    text: 'تمت إعادة تهيئة المحادثة. تفضل بسؤالك الجديد!',
                  ),
                );
              });
            },
          ),
        ],
      ),
      body: Column(
        children: [
          // شريط الاقتراحات السريعة
          Container(
            padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
            decoration: const BoxDecoration(
              color: Color(0xFF0F172A),
              border: Border(bottom: BorderSide(color: Color(0xFF1E293B))),
            ),
            child: SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              child: Row(
                children: _suggestedTopics.map((topic) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 8),
                    child: InkWell(
                      onTap: () => _sendMessage(topic),
                      borderRadius: BorderRadius.circular(16),
                      child: Container(
                        padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                        decoration: BoxDecoration(
                          color: const Color(0xFF1E293B),
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(color: const Color(0xFF334155)),
                        ),
                        child: Text(
                          topic,
                          style: const TextStyle(color: Color(0xFF94A3B8), fontSize: 11),
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),

          // قائمة الرسائل
          Expanded(
            child: ListView.builder(
              controller: _scrollController,
              padding: const EdgeInsets.all(14),
              itemCount: _messages.length,
              itemBuilder: (context, index) {
                final msg = _messages[index];
                return _buildMessageBubble(msg);
              },
            ),
          ),

          // مؤشر التحميل والتفكير
          if (_isLoading)
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
              alignment: Alignment.centerRight,
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                decoration: BoxDecoration(
                  color: const Color(0xFF1E293B),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: 14,
                      height: 14,
                      child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF14B8A6)),
                    ),
                    SizedBox(width: 8),
                    Text('الذكاء الاصطناعي يقوم بالتحليل والصياغة...', style: TextStyle(color: Colors.white70, fontSize: 11.5)),
                  ],
                ),
              ),
            ),

          // صندوق الإدخال
          _buildInputArea(),
        ],
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    return Align(
      alignment: message.isUser ? Alignment.centerLeft : Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 12),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.88),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: message.isUser ? const Color(0xFF0284C7) : const Color(0xFF1E293B),
          borderRadius: BorderRadius.only(
            topLeft: const Radius.circular(12),
            topRight: const Radius.circular(12),
            bottomLeft: Radius.circular(message.isUser ? 0 : 12),
            bottomRight: Radius.circular(message.isUser ? 12 : 0),
          ),
          border: Border.all(
            color: message.isUser ? const Color(0xFF38BDF8) : const Color(0xFF334155),
            width: 0.8,
          ),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Icon(
                  message.isUser ? Icons.person_rounded : Icons.psychology_rounded,
                  size: 14,
                  color: message.isUser ? Colors.white70 : const Color(0xFF14B8A6),
                ),
                4.widthBox,
                Text(
                  message.isUser ? 'أنت' : 'Flutter Architect Copilot',
                  style: TextStyle(
                    fontSize: 10.5,
                    fontWeight: FontWeight.bold,
                    color: message.isUser ? Colors.white70 : const Color(0xFF5EEAD4),
                  ),
                ),
                const Spacer(),
                IconButton(
                  padding: EdgeInsets.zero,
                  constraints: const BoxConstraints(),
                  icon: const Icon(Icons.copy_rounded, size: 14, color: Colors.white38),
                  tooltip: 'نسخ الإجابة',
                  onPressed: () {
                    Clipboard.setData(ClipboardData(text: message.text));
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('تم نسخ النص إلى الحافظة!'), duration: Duration(seconds: 1)),
                    );
                  },
                ),
              ],
            ),
            6.heightBox,
            SelectableText(
              message.text,
              style: const TextStyle(
                color: Colors.white,
                fontSize: 12.5,
                height: 1.5,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildInputArea() {
    return Container(
      padding: EdgeInsets.only(
        left: 12,
        right: 12,
        top: 8,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 8 : 16,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0F172A),
        border: Border(top: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: _textController,
              style: const TextStyle(color: Colors.white, fontSize: 12.5),
              decoration: InputDecoration(
                filled: true,
                fillColor: const Color(0xFF1E293B),
                hintText: 'اكتب سؤالك لمهندس Flutter...',
                hintStyle: const TextStyle(color: Colors.white38, fontSize: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(12),
                  borderSide: BorderSide.none,
                ),
                contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
              ),
              onSubmitted: _sendMessage,
            ),
          ),
          8.widthBox,
          Container(
            decoration: const BoxDecoration(
              color: Color(0xFF14B8A6),
              shape: BoxShape.circle,
            ),
            child: IconButton(
              icon: const Icon(Icons.send_rounded, color: Color(0xFF04111C), size: 18),
              onPressed: () => _sendMessage(_textController.text),
            ),
          ),
        ],
      ),
    );
  }
}
