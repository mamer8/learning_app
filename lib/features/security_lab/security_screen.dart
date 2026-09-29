import 'dart:async';
import 'dart:convert';
import 'package:flutter/material.dart';
import '../../core/core.dart';

/// 🔒 مختبر الأمان وتجديد الـ JWT Token والتشفير
/// يوضح كيفية عمل الـ QueuedInterceptor وتشفير البيانات الحساسة برمجياً
class SecurityScreen extends StatefulWidget {
  const SecurityScreen({super.key});

  @override
  State<SecurityScreen> createState() => _SecurityScreenState();
}

class _SecurityScreenState extends State<SecurityScreen> {
  // تشفير النصوص
  final TextEditingController _plainTextController =
      TextEditingController(text: 'Password#Secret_2026');
  String _encryptedText = '';
  String _decryptedText = '';

  // محاكي الـ JWT Token والـ Interceptor
  static const int _tokenLifespan = 8;
  int _secondsRemaining = 8;
  Timer? _tokenTimer;
  bool _isRefreshingToken = false;
  String _apiStatus = 'جاهز للتجربة... انتظر انتهاء التوكن ثم اضغط إرسال طلب.';
  Color _statusColor = Colors.white70;

  @override
  void initState() {
    super.initState();
    _startTokenCountdown();
    _encryptSample();
  }

  @override
  void dispose() {
    _tokenTimer?.cancel();
    _plainTextController.dispose();
    super.dispose();
  }

  void _startTokenCountdown() {
    _secondsRemaining = _tokenLifespan;
    _tokenTimer?.cancel();
    _tokenTimer = Timer.periodic(const Duration(seconds: 1), (timer) {
      if (_secondsRemaining > 0) {
        setState(() => _secondsRemaining--);
      } else {
        setState(() {});
      }
    });
  }

  void _encryptSample() {
    final bytes = utf8.encode(_plainTextController.text);
    // محاكاة تشفير وتوليد Base64 Hash مع Salt
    final base64String = base64.encode(bytes);
    setState(() {
      _encryptedText = 'ENC_AES256_\$${base64String}_IV_9A8F';
      _decryptedText = '';
    });
  }

  void _decryptSample() {
    try {
      final rawBase64 = _encryptedText
          .replaceAll('ENC_AES256_\$', '')
          .replaceAll('_IV_9A8F', '');
      final decodedBytes = base64.decode(rawBase64);
      setState(() {
        _decryptedText = utf8.decode(decodedBytes);
      });
      context.showSuccessSnackBar('تم فك التشفير واستعادة النص الأصلي بنجاح!');
    } catch (_) {
      context.showErrorSnackBar('فشل فك التشفير!');
    }
  }

  Future<void> _simulateProtectedApiCall() async {
    if (_secondsRemaining > 0) {
      // التوكن لا يزال صالحاً
      setState(() {
        _apiStatus = '🟢 تم تنفيذ الطلب بنجاح 200 OK (التوكن صالح ومصرح).';
        _statusColor = Colors.greenAccent;
      });
      context.showSuccessSnackBar('تم قبول الطلب بفضل التوكن النشط!');
    } else {
      // التوكن منتهي الصلاحية -> محاكاة QueuedInterceptor
      setState(() {
        _isRefreshingToken = true;
        _apiStatus = '⚠️ انتهت صلاحية التوكن (401)! يتم الآن طلب Token جديد عبر QueuedInterceptor...';
        _statusColor = Colors.amberAccent;
      });

      await Future.delayed(const Duration(milliseconds: 1400));

      if (!mounted) return;

      setState(() {
        _isRefreshingToken = false;
        _startTokenCountdown();
        _apiStatus = '⚡ تم استلام Token جديد وإعادة إرسال الطلب المعلق بنجاح 200 OK دون تسجيل خروج!';
        _statusColor = Colors.cyanAccent;
      });

      context.showSuccessSnackBar(
        'تم تجديد الجلسة تلقائياً وإعادة الطلب الأصلي بنجاح!',
        title: 'Interceptor Auto-Refresh',
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isTokenValid = _secondsRemaining > 0;

    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('مختبر الأمان والـ Token Interceptors'),
        backgroundColor: const Color(0xFF1E293B),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // بطاقة الشرح
            _buildConceptCard(),
            16.heightBox,

            // محاكي دورة حياة التوكن
            _buildTokenSimulatorCard(isTokenValid),
            16.heightBox,

            // محاكي تشفير وفك تشفير البيانات
            _buildEncryptionPlayground(),
            16.heightBox,

            // الكود الجاهز للنسخ
            _buildCodeSnippetCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildConceptCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(color: const Color(0xFFEC4899).withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.security_rounded, color: Color(0xFFEC4899), size: 22),
              8.widthBox,
              const Text(
                'سر الأمان في تطبيقات الإنتاج الاحترافية',
                style: TextStyle(color: Color(0xFFEC4899), fontWeight: FontWeight.bold, fontSize: 14),
              ),
            ],
          ),
          8.heightBox,
          const Text(
            '1. تجديد الـ Token: استخدام `QueuedInterceptor` لتعليق الطلبات المتزامنة وتجديد التوكن في الخلفية دون طرد المستخدم.\n'
            '2. التخزين المشفر: عدم حفظ كلمات المرور أو التوكن في SharedPreferences بل في KeyStore/Keychain عبر `flutter_secure_storage`.\n'
            '3. SSL Pinning: منع اعتراض وتعديل البيانات عبر الـ Proxies والتنصت.',
            style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildTokenSimulatorCard(bool isTokenValid) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: BorderRadius.circular(14),
        border: Border.all(
          color: isTokenValid ? Colors.greenAccent.withValues(alpha: 0.4) : Colors.redAccent.withValues(alpha: 0.4),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '⏱️ محاكي صلاحية الـ Access Token:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
                decoration: BoxDecoration(
                  color: isTokenValid
                      ? Colors.green.withValues(alpha: 0.2)
                      : Colors.red.withValues(alpha: 0.2),
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  isTokenValid ? 'نشط: $_secondsRemaining ثواني' : 'منتهي الصلاحية 🔒',
                  style: TextStyle(
                    color: isTokenValid ? Colors.greenAccent : Colors.redAccent,
                    fontWeight: FontWeight.bold,
                    fontSize: 11,
                  ),
                ),
              ),
            ],
          ),
          14.heightBox,
          ElevatedButton.icon(
            onPressed: _isRefreshingToken ? null : _simulateProtectedApiCall,
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF3B82F6),
              foregroundColor: Colors.white,
              padding: const EdgeInsets.symmetric(vertical: 12),
              shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
            ),
            icon: _isRefreshingToken
                ? const SizedBox(
                    width: 16,
                    height: 16,
                    child: CircularProgressIndicator(strokeWidth: 2, color: Colors.white),
                  )
                : const Icon(Icons.send_rounded, size: 18),
            label: Text(
              _isRefreshingToken ? 'جاري تجديد الـ Token...' : 'إرسال طلب محمي (Fetch User Profile)',
              style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
          12.heightBox,
          Text(
            _apiStatus,
            style: TextStyle(color: _statusColor, fontSize: 12, height: 1.4),
          ),
        ],
      ),
    );
  }

  Widget _buildEncryptionPlayground() {
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
            '🔐 تجربة تشفير وفك تشفير البيانات الحساسة:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          12.heightBox,
          TextField(
            controller: _plainTextController,
            onChanged: (_) => _encryptSample(),
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF0F172A),
              labelText: 'النص الأصلي (Plaintext Password/PIN)',
              labelStyle: const TextStyle(color: Colors.white60, fontSize: 11),
              border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
            ),
          ),
          10.heightBox,
          Text(
            'النص المشفر بالـ AES-256:\n$_encryptedText',
            style: const TextStyle(
              fontFamily: 'monospace',
              color: Colors.cyanAccent,
              fontSize: 11,
            ),
          ),
          12.heightBox,
          Row(
            children: [
              ElevatedButton.icon(
                onPressed: _decryptSample,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFF10B981),
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
                ),
                icon: const Icon(Icons.lock_open_rounded, size: 16),
                label: const Text('فك التشفير الآن', style: TextStyle(fontSize: 11)),
              ),
              12.widthBox,
              if (_decryptedText.isNotEmpty)
                Text(
                  'المستعاد: $_decryptedText',
                  style: const TextStyle(color: Colors.greenAccent, fontWeight: FontWeight.bold, fontSize: 12),
                ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildCodeSnippetCard() {
    const code =
        'class AuthInterceptor extends QueuedInterceptor {\n'
        '  final Dio dio;\n'
        '  AuthInterceptor({required this.dio});\n\n'
        '  @override\n'
        '  void onError(DioException err, ErrorInterceptorHandler handler) async {\n'
        '    if (err.response?.statusCode == 401) {\n'
        '      final newToken = await refreshJwtToken();\n'
        '      if (newToken != null) {\n'
        '        // إعادة إرسال الطلب الأصلي بتوكن جديد\n'
        '        final retry = await dio.request(\n'
        '          err.requestOptions.path,\n'
        '          options: Options(headers: {"Authorization": "Bearer \$newToken"}),\n'
        '        );\n'
        '        return handler.resolve(retry);\n'
        '      }\n'
        '    }\n'
        '    handler.next(err);\n'
        '  }\n'
        '}';

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
            '💻 كود الـ QueuedInterceptor لتجديد التوكن التلقائي:',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
          ),
          10.heightBox,
          const CopyableCodeBlock(
            code: code,
            copiedMessage: 'تم نسخ كود AuthInterceptor',
            copyTooltip: 'نسخ الكود',
          ),
        ],
      ),
    );
  }
}
