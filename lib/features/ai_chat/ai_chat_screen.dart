import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import '../../core/core.dart';
import '../../core/services/ai_assistant_service.dart';
import '../../core/services/text_to_speech_service.dart';
import 'widgets/ai_markdown_view.dart';
import 'widgets/ai_typing_indicator.dart';

/// نموذج رسالة المحادثة المطورة
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

/// شاشة المساعد الذكي الاحترافية لـ Flutter (Pro AI Copilot Screen)
class AiChatScreen extends StatefulWidget {
  const AiChatScreen({super.key});

  @override
  State<AiChatScreen> createState() => _AiChatScreenState();
}

class _AiChatScreenState extends State<AiChatScreen> {
  final TextEditingController _textController = TextEditingController();
  final ScrollController _scrollController = ScrollController();
  final AiAssistantService _aiService = AiAssistantService.instance;
  final TextToSpeechService _tts = TextToSpeechService.instance;

  final List<ChatMessage> _messages = [];
  bool _isLoading = false;

  final List<({String title, String prompt, IconData icon, Color color})> _suggestedTopics = [
    (
      title: '⚡ توليد كود لـ Isolates',
      prompt: 'أريد كود كامل ومحسّن لمعالجة قائمة ضخمة من بيانات JSON في الخلفية باستخدام Isolate.run() مع معالجة الأخطاء.',
      icon: Icons.bolt_rounded,
      color: const Color(0xFF0284C7),
    ),
    (
      title: '⚡ توليد كود لـ Cubit & State',
      prompt: 'اكتب لي مثال كود كامل يوضح إدارة الحالة بـ Cubit مع BlocSelector لعزل الـ Rebuilds بدقة.',
      icon: Icons.compare_arrows_rounded,
      color: const Color(0xFF10B981),
    ),
    (
      title: '⚡ توليد كود لـ Drift & SQLite',
      prompt: 'أعطني كود جدول Drift مع DAO واستعلامات Streams وترقية Schema Migration من v1 إلى v2.',
      icon: Icons.storage_rounded,
      color: const Color(0xFF38BDF8),
    ),
    (
      title: 'بنية Clean Architecture',
      prompt: 'كيف أصمم بنية Clean Architecture مع BLoC وإدارة الحالات في مشروع إنتاجي كبير؟',
      icon: Icons.account_tree_rounded,
      color: const Color(0xFF0284C7),
    ),
    (
      title: 'الأداء ومعدل 120 FPS',
      prompt: 'كيف أكتشف الـ Memory Leaks وأمنع الـ Jank في Flutter للوصول إلى 60/120 FPS ثابتة؟',
      icon: Icons.speed_rounded,
      color: const Color(0xFF10B981),
    ),
    (
      title: 'الـ Isolates والعمليات الثقيلة',
      prompt: 'ما الفرق بين Isolates و compute() ومتى أستخدم كل منهما لمعالجة JSON الضخم؟',
      icon: Icons.bolt_rounded,
      color: const Color(0xFFF59E0B),
    ),
    (
      title: 'أمان JWT و Interceptors',
      prompt: 'اشرح لي آلية عمل QueuedInterceptor لتحديث JWT Token تلقائياً في Dio.',
      icon: Icons.lock_person_rounded,
      color: const Color(0xFFEC4899),
    ),
    (
      title: 'كتابة الـ Unit & Bloc Tests',
      prompt: 'كيف أكتب Unit Tests و BlocTest احترافية مع Mocktail للـ UseCases والـ Repositories؟',
      icon: Icons.science_rounded,
      color: const Color(0xFF8B5CF6),
    ),
    (
      title: 'أتمتة CI/CD والنشر',
      prompt: 'ما هي أفضل خطوات إعداد GitHub Actions لعمل Build ورفع تلقائي لـ Google Play و App Store؟',
      icon: Icons.rocket_launch_rounded,
      color: const Color(0xFF14B8A6),
    ),
  ];

  @override
  void initState() {
    super.initState();
    _messages.add(
      ChatMessage(
        isUser: false,
        text: '### أهلاً بك يا بطل! 👋\n'
            'أنا **مساعدك الذكي لمعمارية وهندسة Flutter** (*Senior AI Copilot*).\n\n'
            'جاهز للإجابة على استفساراتك المتقدمة في:\n'
            '- 🏗️ **Clean Architecture & Design Patterns**\n'
            '- ⚡ **High Performance, Isolates & Memory Profiling**\n'
            '- 🔒 **Security, JWT Interceptors & Cryptography**\n'
            '- 🧪 **Unit, Widget & Integration Testing**\n\n'
            'جرّب اختيار أحد المواضيع المقترحة في الأعلى أو اكتب سؤالك بالأسفل مباشرة.',
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
          duration: const Duration(milliseconds: 350),
          curve: Curves.easeOutCubic,
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
            text: '⚠️ **حدث خطأ أثناء معالجة الرد:**\n`$e`\n\nتأكد من اتصال الإنترنت أو صحة مفتاح الـ API.',
            isUser: false,
          ),
        );
        _isLoading = false;
      });
      _scrollToBottom();
    }
  }

  void _showClearConfirmDialog() {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        backgroundColor: const Color(0xFF0F172A),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16),
          side: const BorderSide(color: Color(0xFF1E293B)),
        ),
        title: const Row(
          children: [
            Icon(Icons.delete_sweep_rounded, color: Color(0xFFEF4444), size: 22),
            SizedBox(width: 8),
            Text('مسح المحادثة', style: TextStyle(color: Colors.white, fontSize: 15)),
          ],
        ),
        content: const Text(
          'هل أنت متأكد من رغبتك في مسح سجل المحادثة بالكامل؟',
          style: TextStyle(color: Color(0xFF94A3B8), fontSize: 12.5),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('إلغاء', style: TextStyle(color: Colors.white70)),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              setState(() {
                _messages.clear();
                _messages.add(
                  ChatMessage(
                    isUser: false,
                    text: '✨ تمت إعادة تهيئة جلسة المحادثة بنجاح. تفضل بسؤالك الجديد!',
                  ),
                );
              });
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFFEF4444),
              foregroundColor: Colors.white,
            ),
            child: const Text('مسح الآن'),
          ),
        ],
      ),
    );
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
          title: Row(
            children: [
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: const Color(0xFF14B8A6).withValues(alpha: 0.15),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.vpn_key_rounded, color: Color(0xFF5EEAD4), size: 20),
              ),
              const SizedBox(width: 10),
              const Text(
                'إعدادات مفتاح المساعد (API Key)',
                style: TextStyle(color: Colors.white, fontSize: 15, fontWeight: FontWeight.bold),
              ),
            ],
          ),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (_aiService.hasApiKey) ...[
                  Container(
                    padding: const EdgeInsets.all(12),
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [Color(0xFF064E3B), Color(0xFF065F46)],
                      ),
                      borderRadius: BorderRadius.circular(10),
                      border: Border.all(color: const Color(0xFF10B981).withValues(alpha: 0.5)),
                    ),
                    child: const Row(
                      children: [
                        Icon(Icons.verified_user_rounded, color: Color(0xFF34D399), size: 20),
                        SizedBox(width: 10),
                        Expanded(
                          child: Text(
                            'المفتاح مفعّل ومحمي بأمان 🔒',
                            style: TextStyle(
                              color: Color(0xFFD1FAE5),
                              fontSize: 11.5,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(height: 14),
                ],
                Text(
                  _aiService.hasApiKey
                      ? 'لتحديث المفتاح الحالي، الصق المفتاح الجديد:'
                      : 'أدخل مفتاح الـ API الخاص بك لتفعيل الاتصال المباشر الفوري:',
                  style: const TextStyle(color: Color(0xFFCBD5E1), fontSize: 12, height: 1.4),
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: keyController,
                  obscureText: isObscured,
                  style: const TextStyle(color: Colors.white, fontSize: 12),
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: const Color(0xFF1E293B),
                    hintText: _aiService.hasApiKey ? '••••••••••••••••••••••••••••••••' : 'AIzaSy...',
                    hintStyle: const TextStyle(color: Colors.white38),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF334155)),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10),
                      borderSide: const BorderSide(color: Color(0xFF14B8A6), width: 1.4),
                    ),
                    contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
                    suffixIcon: IconButton(
                      icon: Icon(
                        isObscured ? Icons.visibility_off_rounded : Icons.visibility_rounded,
                        color: Colors.white54,
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
                const SizedBox(height: 14),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: const Color(0xFF172033),
                    borderRadius: BorderRadius.circular(10),
                    border: Border.all(color: const Color(0xFF24324A)),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Row(
                        children: [
                          Icon(Icons.help_outline_rounded, color: Color(0xFF38BDF8), size: 16),
                          SizedBox(width: 6),
                          Text(
                            'كيف أحصل على المفتاح مجاناً؟',
                            style: TextStyle(color: Color(0xFF38BDF8), fontSize: 11.5, fontWeight: FontWeight.bold),
                          ),
                        ],
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        '1. توجه إلى: aistudio.google.com\n'
                        '2. سجل الدخول بحساب Google\n'
                        '3. اضغط زر "Get API key" ثم "Create API key"\n'
                        '4. انسخ المفتاح والصقه في هذا الصندوق',
                        style: TextStyle(color: Color(0xFF94A3B8), fontSize: 11, height: 1.5),
                      ),
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
                    const SnackBar(
                      content: Text('تم حذف المفتاح والعودة للنمط المدمج'),
                      behavior: SnackBarBehavior.floating,
                    ),
                  );
                },
                child: const Text('حذف المفتاح', style: TextStyle(color: Color(0xFFEF4444))),
              ),
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('إلغاء', style: TextStyle(color: Colors.white70)),
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
                  const SnackBar(
                    content: Text('✅ تم حفظ وتفعيل مفتاح API بنجاح!'),
                    backgroundColor: Color(0xFF0F172A),
                    behavior: SnackBarBehavior.floating,
                  ),
                );
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF14B8A6),
                foregroundColor: const Color(0xFF04111C),
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
              ),
              child: const Text('حفظ وتفعيل', style: TextStyle(fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF070B14),
      appBar: AppBar(
        backgroundColor: const Color(0xFF0B1220),
        elevation: 0,
        titleSpacing: 0,
        title: Row(
          children: [
            // أيقونة المساعد بتدرج لوني أنيق
            Container(
              padding: const EdgeInsets.all(7),
              decoration: BoxDecoration(
                gradient: const LinearGradient(
                  colors: [Color(0xFF14B8A6), Color(0xFF0284C7)],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(10),
                boxShadow: const [
                  BoxShadow(color: Color(0x3314B8A6), blurRadius: 8, offset: Offset(0, 2)),
                ],
              ),
              child: const Icon(Icons.psychology_rounded, color: Colors.white, size: 20),
            ),
            const SizedBox(width: 10),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  'Flutter AI Architect Copilot',
                  style: TextStyle(fontSize: 13.5, fontWeight: FontWeight.w800, color: Colors.white),
                ),
                const SizedBox(height: 2),
                Row(
                  children: [
                    Container(
                      width: 7,
                      height: 7,
                      decoration: BoxDecoration(
                        color: _aiService.hasApiKey ? const Color(0xFF34D399) : const Color(0xFFF59E0B),
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            color: _aiService.hasApiKey
                                ? const Color(0x6634D399)
                                : const Color(0x66F59E0B),
                            blurRadius: 4,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                    ),
                    const SizedBox(width: 5),
                    Text(
                      _aiService.hasApiKey ? 'متصل ومفعّل' : 'النمط التجريبي',
                      style: TextStyle(
                        fontSize: 10,
                        fontWeight: FontWeight.w600,
                        color: _aiService.hasApiKey ? const Color(0xFF34D399) : const Color(0xFFF59E0B),
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
            tooltip: 'إعدادات المفتاح',
            icon: Container(
              padding: const EdgeInsets.all(6),
              decoration: BoxDecoration(
                color: _aiService.hasApiKey
                    ? const Color(0xFF064E3B)
                    : const Color(0xFF1E293B),
                borderRadius: BorderRadius.circular(8),
                border: Border.all(
                  color: _aiService.hasApiKey ? const Color(0xFF10B981) : const Color(0xFF334155),
                  width: 0.8,
                ),
              ),
              child: Icon(
                _aiService.hasApiKey ? Icons.vpn_key_rounded : Icons.vpn_key_outlined,
                color: _aiService.hasApiKey ? const Color(0xFF34D399) : const Color(0xFFF59E0B),
                size: 16,
              ),
            ),
            onPressed: _showApiKeyDialog,
          ),
          IconButton(
            tooltip: 'مسح الجلسة',
            icon: const Icon(Icons.refresh_rounded, size: 20, color: Color(0xFF94A3B8)),
            onPressed: _showClearConfirmDialog,
          ),
          const SizedBox(width: 6),
        ],
      ),
      body: ResponsiveContentWrapper(
        maxWidth: 1000,
        child: Column(
          children: [
            // شريط الاقتراحات التفاعلي السريع
            _buildQuickTopicsCarousel(),

            // قائمة الرسائل
            Expanded(
              child: ListView.builder(
                controller: _scrollController,
                padding: const EdgeInsets.fromLTRB(14, 12, 14, 12),
                itemCount: _messages.length,
                itemBuilder: (context, index) {
                  final msg = _messages[index];
                  return _buildMessageBubble(msg);
                },
              ),
            ),

            // مؤشر التحميل والتحليل
            if (_isLoading) const AiTypingIndicator(),

            // صندوق الإدخال الحديث
            _buildModernInputArea(),
          ],
        ),
      ),
    );
  }

  Widget _buildQuickTopicsCarousel() {
    return Container(
      padding: const EdgeInsets.symmetric(vertical: 8),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1220),
        border: Border(bottom: BorderSide(color: Color(0xFF172236))),
      ),
      child: SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        padding: const EdgeInsets.symmetric(horizontal: 12),
        child: Row(
          children: _suggestedTopics.map((topic) {
            return Padding(
              padding: const EdgeInsets.only(right: 8),
              child: InkWell(
                onTap: () => _sendMessage(topic.prompt),
                borderRadius: BorderRadius.circular(12),
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  decoration: BoxDecoration(
                    color: const Color(0xFF101828),
                    borderRadius: BorderRadius.circular(12),
                    border: Border.all(color: topic.color.withValues(alpha: 0.35)),
                  ),
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(topic.icon, color: topic.color, size: 14),
                      const SizedBox(width: 6),
                      Text(
                        topic.title,
                        style: const TextStyle(
                          color: Color(0xFFE2E8F0),
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _buildMessageBubble(ChatMessage message) {
    final timeStr = DateFormat('hh:mm a').format(message.timestamp);

    if (message.isUser) {
      return Align(
        alignment: Alignment.centerLeft,
        child: Container(
          margin: const EdgeInsets.only(bottom: 14, right: 32),
          constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.85),
          padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 12),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [Color(0xFF0284C7), Color(0xFF0369A1)],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: const BorderRadius.only(
              topLeft: Radius.circular(16),
              topRight: Radius.circular(16),
              bottomLeft: Radius.circular(4),
              bottomRight: Radius.circular(16),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color(0x330284C7),
                blurRadius: 8,
                offset: Offset(0, 3),
              ),
            ],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(Icons.person_rounded, size: 13, color: Colors.white70),
                  const SizedBox(width: 4),
                  const Text(
                    'أنت',
                    style: TextStyle(color: Colors.white, fontSize: 10.5, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  Text(
                    timeStr,
                    style: const TextStyle(color: Colors.white60, fontSize: 9.5),
                  ),
                ],
              ),
              const SizedBox(height: 6),
              SelectableText(
                message.text,
                style: const TextStyle(
                  color: Colors.white,
                  fontSize: 12.5,
                  height: 1.45,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // فقاعة المساعد الذكي
    return Align(
      alignment: Alignment.centerRight,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16, left: 16),
        constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width * 0.94),
        decoration: BoxDecoration(
          color: const Color(0xFF0D1527),
          borderRadius: const BorderRadius.only(
            topLeft: Radius.circular(16),
            topRight: Radius.circular(16),
            bottomLeft: Radius.circular(16),
            bottomRight: Radius.circular(4),
          ),
          border: Border.all(color: const Color(0xFF1E293B)),
          boxShadow: const [
            BoxShadow(
              color: Color(0x22000000),
              blurRadius: 10,
              offset: Offset(0, 4),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // رأس رسالة المساعد
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
              decoration: const BoxDecoration(
                color: Color(0xFF111C33),
                borderRadius: BorderRadius.vertical(top: Radius.circular(15)),
                border: Border(bottom: BorderSide(color: Color(0xFF1E293B), width: 0.8)),
              ),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(4),
                    decoration: BoxDecoration(
                      color: const Color(0xFF14B8A6).withValues(alpha: 0.2),
                      borderRadius: BorderRadius.circular(6),
                    ),
                    child: const Icon(Icons.psychology_rounded, color: Color(0xFF5EEAD4), size: 14),
                  ),
                  const SizedBox(width: 8),
                  const Text(
                    'Flutter Architect Copilot',
                    style: TextStyle(
                      color: Color(0xFF5EEAD4),
                      fontWeight: FontWeight.w800,
                      fontSize: 11,
                    ),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    timeStr,
                    style: const TextStyle(color: Color(0xFF64748B), fontSize: 9.5),
                  ),
                  const Spacer(),
                  // زر نسخ الكود فقط
                  InkWell(
                    onTap: () {
                      final codeOnly =
                          TextToSpeechService.extractOnlyCode(message.text);
                      Clipboard.setData(ClipboardData(text: codeOnly));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle_rounded,
                                  color: Color(0xFF38BDF8), size: 16),
                              SizedBox(width: 8),
                              Text('تم نسخ الأكواد البرمجية فقط إلى الحافظة!'),
                            ],
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color(0xFF0F172A),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.code_rounded,
                              size: 12, color: Color(0xFF38BDF8)),
                          SizedBox(width: 4),
                          Text('نسخ الكود فقط',
                              style: TextStyle(
                                  color: Color(0xFF38BDF8),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // زر نسخ الإجابة بالكامل
                  InkWell(
                    onTap: () {
                      Clipboard.setData(ClipboardData(text: message.text));
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Row(
                            children: [
                              Icon(Icons.check_circle_rounded,
                                  color: Color(0xFF34D399), size: 16),
                              SizedBox(width: 8),
                              Text('تم نسخ الإجابة بالكامل إلى الحافظة!'),
                            ],
                          ),
                          behavior: SnackBarBehavior.floating,
                          backgroundColor: Color(0xFF0F172A),
                          duration: Duration(seconds: 1),
                        ),
                      );
                    },
                    borderRadius: BorderRadius.circular(6),
                    child: Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 6, vertical: 3),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.copy_rounded,
                              size: 12, color: Color(0xFF94A3B8)),
                          SizedBox(width: 4),
                          Text('نسخ الرد',
                              style: TextStyle(
                                  color: Color(0xFF94A3B8), fontSize: 9.5)),
                        ],
                      ),
                    ),
                  ),
                  const SizedBox(width: 6),
                  // زر القراءة الصوتية
                  ListenableBuilder(
                    listenable: _tts,
                    builder: (context, _) {
                      final isSpeakingThis = _tts.isSpeaking &&
                          _tts.currentSpeakingText ==
                              TextToSpeechService.cleanMarkdownForSpeech(
                                  message.text);
                      return InkWell(
                        onTap: () {
                          _tts.toggleSpeak(message.text, isArabic: true);
                        },
                        borderRadius: BorderRadius.circular(6),
                        child: Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 6, vertical: 3),
                          decoration: BoxDecoration(
                            color: isSpeakingThis
                                ? const Color(0x3310B981)
                                : const Color(0xFF1E293B),
                            borderRadius: BorderRadius.circular(6),
                            border: isSpeakingThis
                                ? Border.all(
                                    color: const Color(0xFF10B981), width: 0.8)
                                : null,
                          ),
                          child: Row(
                            mainAxisSize: MainAxisSize.min,
                            children: [
                              Icon(
                                isSpeakingThis
                                    ? Icons.volume_up_rounded
                                    : Icons.volume_up_outlined,
                                size: 12,
                                color: isSpeakingThis
                                    ? const Color(0xFF34D399)
                                    : const Color(0xFF14B8A6),
                              ),
                              const SizedBox(width: 4),
                              Text(
                                isSpeakingThis ? 'إيقاف' : 'صوت',
                                style: TextStyle(
                                  color: isSpeakingThis
                                      ? const Color(0xFF34D399)
                                      : const Color(0xFF14B8A6),
                                  fontSize: 9.5,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  ),
                ],
              ),
            ),

            // محتوى الرسالة بصيغة Markdown الغنية
            Padding(
              padding: const EdgeInsets.all(14),
              child: AiMarkdownView(data: message.text),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildModernInputArea() {
    return Container(
      padding: EdgeInsets.only(
        left: 14,
        right: 14,
        top: 10,
        bottom: MediaQuery.of(context).viewInsets.bottom > 0 ? 10 : 18,
      ),
      decoration: const BoxDecoration(
        color: Color(0xFF0B1220),
        border: Border(top: BorderSide(color: Color(0xFF1E293B))),
      ),
      child: SafeArea(
        top: false,
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Expanded(
              child: TextField(
                controller: _textController,
                maxLines: 4,
                minLines: 1,
                style: const TextStyle(color: Colors.white, fontSize: 13),
                textInputAction: TextInputAction.send,
                decoration: InputDecoration(
                  isDense: true,
                  filled: true,
                  fillColor: const Color(0xFF101828),
                  hintText: 'اسأل عن بنية الأكواد، الأداء، الأمان، أو حل المشاكل...',
                  hintStyle: const TextStyle(color: Color(0xFF64748B), fontSize: 12),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Color(0xFF24324A)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Color(0xFF24324A)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(24),
                    borderSide: const BorderSide(color: Color(0xFF14B8A6), width: 1.5),
                  ),
                ),
                onSubmitted: _sendMessage,
              ),
            ),
            const SizedBox(width: 8),
            Material(
              color: Colors.transparent,
              child: Ink(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  gradient: const LinearGradient(
                    colors: [Color(0xFF14B8A6), Color(0xFF0D9488)],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(22),
                  boxShadow: const [
                    BoxShadow(
                      color: Color(0x3314B8A6),
                      blurRadius: 8,
                      offset: Offset(0, 2),
                    ),
                  ],
                ),
                child: InkWell(
                  borderRadius: BorderRadius.circular(22),
                  onTap: () => _sendMessage(_textController.text),
                  child: const Center(
                    child: Icon(
                      Icons.arrow_upward_rounded,
                      color: Color(0xFF04111C),
                      size: 20,
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
