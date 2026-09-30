import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';

/// ⚡ مختبر امتدادات الـ Core (Extensions Playground)
/// شاشة تفاعلية لتجربة جميع الـ Extensions المنشأة مع فحص حي لخصائص الشاشة والتحقق من النصوص
class ExtensionsScreen extends StatefulWidget {
  const ExtensionsScreen({super.key});

  @override
  State<ExtensionsScreen> createState() => _ExtensionsScreenState();
}

class _ExtensionsScreenState extends State<ExtensionsScreen> {
  final TextEditingController _emailController = TextEditingController(text: 'flutter.dev@google.com');
  final TextEditingController _phoneController = TextEditingController(text: '+966501234567');
  final TextEditingController _urlController = TextEditingController(text: 'https://flutter.dev');

  @override
  void dispose() {
    _emailController.dispose();
    _phoneController.dispose();
    _urlController.dispose();
    super.dispose();
  }

  String _getExtensionsCode() {
    return '// التطبيق العملي للـ Extensions مع القيم المكتوبة حالياً:\n'
        'final email = "${_emailController.text}";\n'
        'final isEmailValid = email.isValidEmail; // النتيجة: ${_emailController.text.isValidEmail}\n\n'
        'final phone = "${_phoneController.text}";\n'
        'final isPhoneValid = phone.isValidPhone; // النتيجة: ${_phoneController.text.isValidPhone}\n\n'
        '// تبسيط الـ Spacing والـ Context:\n'
        '16.heightBox; // بدلاً من SizedBox(height: 16)\n'
        'context.width; // بدلاً من MediaQuery.sizeOf(context).width';
  }

  void _openAiCopilot(BuildContext context) {
    ContextualAiSheet.show(
      context,
      topicTitle: 'مختبر الـ Dart Extensions والـ Utilities',
      topicCode: _getExtensionsCode(),
      levelTitle: 'إنتاجية الكود وامتدادات لغة Dart',
      isArabic: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('مختبر Extensions & Utilities'),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            tooltip: 'اسأل المساعد الذكي',
            icon: const Icon(Icons.psychology_rounded, color: Color(0xFF14B8A6)),
            onPressed: () => _openAiCopilot(context),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAiCopilot(context),
        icon: const Icon(Icons.psychology_rounded, color: Color(0xFF04111C)),
        label: const Text(
          'اسأل المساعد الذكي عن هذا الكود',
          style: TextStyle(color: Color(0xFF04111C), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF14B8A6),
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // 1. بطاقة الشرح
            _buildExplanationCard(),
            16.heightBox,

            // 2. فحص أبعاد الشاشة ومميزات context_extensions.dart
            _buildContextDimensionsCard(context),
            16.heightBox,

            // 3. تجربة رسائل الـ Snackbars العصرية
            _buildSnackBarsCard(context),
            16.heightBox,

            // 4. مختبر التحقق من النصوص (String Validation Extensions)
            _buildStringValidatorsCard(),
            16.heightBox,

            // 5. كود الـ Extensions الحي
            _buildCodeCard(),
          ],
        ),
      ),
    );
  }

  Widget _buildExplanationCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(color: Colors.pinkAccent.withValues(alpha: 0.3)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(Icons.extension_rounded, color: Colors.pinkAccent, size: 24),
              8.widthBox,
              const Text(
                'قوة الـ Dart Extensions في تبسيط الكود',
                style: TextStyle(
                  color: Colors.pinkAccent,
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          8.heightBox,
          const Text(
            'تسمح امتدادات Dart بإضافة دوال وممتلكات جديدة للكلاسات الجاهزة دون وراثة.\n'
            '🔹 بدلاً من كتابة `MediaQuery.sizeOf(context).width` نكتب `context.width`.\n'
            '🔹 بدلاً من `SizedBox(height: 16)` نكتب `16.heightBox`.\n'
            '🔹 بدلاً من دوال التحقق الخارجية المعقدة نكتب `email.isValidEmail`.',
            style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildContextDimensionsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '📐 قراءات حية لأبعاد الشاشة (Context Extensions)',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          12.heightBox,
          _buildInfoRow('عرض الشاشة (context.width):', '${context.width.toStringAsFixed(1)} dp'),
          _buildInfoRow('ارتفاع الشاشة (context.height):', '${context.height.toStringAsFixed(1)} dp'),
          _buildInfoRow('نسبة الأبعاد (context.aspectRatio):', context.aspectRatio.toStringAsFixed(2)),
          _buildInfoRow('هل الجهاز هاتف؟ (context.isMobile):', context.isMobile ? 'نعم (Mobile)' : 'لا (Tablet/Desktop)'),
          _buildInfoRow('الاتجاه (context.isPortrait):', context.isPortrait ? 'عمودي (Portrait)' : 'أفقي (Landscape)'),
          _buildInfoRow('الوضع الليلي (context.isDarkMode):', context.isDarkMode ? 'نعم (Dark)' : 'فاتح (Light)'),
        ],
      ),
    );
  }

  Widget _buildInfoRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
          Directionality(
            textDirection: TextDirection.ltr,
            child: Text(
              value,
              style: const TextStyle(color: Colors.cyanAccent, fontWeight: FontWeight.bold, fontSize: 12),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSnackBarsCard(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔔 رسائل التنبيه العصرية (Custom Floating Snackbars)',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          12.heightBox,
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.showSuccessSnackBar('تمت العملية بنجاح!'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF10B981),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: 10.circularRadius),
                  ),
                  icon: const Icon(Icons.check_circle_outline, size: 18),
                  label: const Text('Success SnackBar', style: TextStyle(fontSize: 11)),
                ),
              ),
              8.widthBox,
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () => context.showErrorSnackBar('حدث خطأ أثناء معالجة الطلب!'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFFEF4444),
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(borderRadius: 10.circularRadius),
                  ),
                  icon: const Icon(Icons.error_outline, size: 18),
                  label: const Text('Error SnackBar', style: TextStyle(fontSize: 11)),
                ),
              ),
            ],
          ),
          8.heightBox,
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: () => context.showInfoSnackBar('هذه رسالة معلومات وتنبيه إرشادية.'),
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFF3B82F6),
                foregroundColor: Colors.white,
                shape: RoundedRectangleBorder(borderRadius: 10.circularRadius),
              ),
              icon: const Icon(Icons.info_outline, size: 18),
              label: const Text('Info SnackBar', style: TextStyle(fontSize: 11)),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildStringValidatorsCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '🔍 تجربة التحقق من صحة النصوص (String Validations)',
            style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 14),
          ),
          12.heightBox,
          _buildValidatorField(
            controller: _emailController,
            label: 'فحص البريد (text.isValidEmail)',
            isValid: _emailController.text.isValidEmail,
          ),
          12.heightBox,
          _buildValidatorField(
            controller: _phoneController,
            label: 'فحص الهاتف (text.isValidPhone)',
            isValid: _phoneController.text.isValidPhone,
          ),
          12.heightBox,
          _buildValidatorField(
            controller: _urlController,
            label: 'فحص الرابط (text.isValidUrl)',
            isValid: _urlController.text.isValidUrl,
          ),
        ],
      ),
    );
  }

  Widget _buildValidatorField({
    required TextEditingController controller,
    required String label,
    required bool isValid,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(label, style: const TextStyle(color: Colors.white70, fontSize: 11)),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 2),
              decoration: BoxDecoration(
                color: isValid ? Colors.green.withValues(alpha: 0.2) : Colors.red.withValues(alpha: 0.2),
                borderRadius: 6.circularRadius,
              ),
              child: Text(
                isValid ? 'صحيح ✅' : 'غير صالح ❌',
                style: TextStyle(
                  color: isValid ? Colors.greenAccent : Colors.redAccent,
                  fontSize: 11,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ],
        ),
        6.heightBox,
        Directionality(
          textDirection: TextDirection.ltr,
          child: TextField(
            controller: controller,
            textDirection: TextDirection.ltr,
            onChanged: (_) => setState(() {}),
            style: const TextStyle(color: Colors.white, fontSize: 12),
            decoration: InputDecoration(
              filled: true,
              fillColor: const Color(0xFF0F172A),
              isDense: true,
              border: OutlineInputBorder(
                borderRadius: 10.circularRadius,
                borderSide: BorderSide.none,
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildCodeCard() {
    final code = _getExtensionsCode();

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                '💻 كود الـ Extensions الحي التفاعلي:',
                style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 13),
              ),
              Container(
                padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 3),
                decoration: BoxDecoration(
                  color: const Color(0xFF14B8A6).withValues(alpha: 0.2),
                  borderRadius: 6.circularRadius,
                ),
                child: const Text('Dynamic Live Code', style: TextStyle(color: Color(0xFF14B8A6), fontSize: 10, fontWeight: FontWeight.bold)),
              ),
            ],
          ),
          10.heightBox,
          CopyableCodeBlock(
            code: code,
            copiedMessage: 'تم نسخ كود الـ Extensions',
            copyTooltip: 'نسخ الكود',
          ),
        ],
      ),
    );
  }
}
