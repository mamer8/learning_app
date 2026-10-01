import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';
import '../quiz/lab_quiz_action.dart';

/// نماذج حالات Dart 3 Sealed Classes
sealed class AuthState {
  const AuthState();
}

class AuthInitial extends AuthState {
  const AuthInitial();
}

class AuthLoading extends AuthState {
  final String message;
  const AuthLoading({this.message = 'جاري التحقق...'});
}

class AuthSuccess extends AuthState {
  final ({String name, String role, int level}) user;
  const AuthSuccess(this.user);
}

class AuthFailure extends AuthState {
  final String error;
  final int code;
  const AuthFailure(this.error, {this.code = 400});
}

/// شاشة مختبر Dart 3 الحديث
class Dart3Screen extends StatefulWidget {
  const Dart3Screen({super.key});

  @override
  State<Dart3Screen> createState() => _Dart3ScreenState();
}

class _Dart3ScreenState extends State<Dart3Screen> {
  AuthState _currentState = const AuthInitial();

  // Records & Destructuring Demo state
  ({String name, int age, double score, bool isPro}) _userRecord =
      (name: 'أحمد علي', age: 24, score: 98.5, isPro: true);

  // Pattern Matching JSON Demo
  String _jsonInput = '{"type": "admin", "permissions": ["read", "write", "delete"], "quota": 1000}';
  String _patternResult = '';

  @override
  void initState() {
    super.initState();
    _evaluateJsonPattern(_jsonInput);
  }

  void _evaluateJsonPattern(String raw) {
    try {
      // محاكاة تحليل كائن بصيغة Dart Map ومطابقته بأنماط Dart 3
      final Map<String, dynamic> data = raw.contains('admin')
          ? {'type': 'admin', 'permissions': ['read', 'write', 'delete'], 'quota': 1000}
          : {'type': 'guest', 'permissions': ['read'], 'quota': 50};

      final result = switch (data) {
        {'type': 'admin', 'permissions': List p, 'quota': int q} when q >= 1000 =>
          '👑 مدير بصلاحيات كاملة (${p.length} أذونات) وحصة غير محدودة ($q)',
        {'type': 'admin', 'permissions': List p} =>
          '⚡ مدير عادي بعدد أذونات: ${p.join(', ')}',
        {'type': 'guest', 'permissions': ['read']} =>
          '👀 زائر بصلاحية قراءة فقط',
        {'type': String t} => '👤 مستخدم عادي من نوع: $t',
        _ => '❓ نوع غير معروف أو غير متطابق',
      };

      setState(() => _patternResult = result);
    } catch (e) {
      setState(() => _patternResult = 'خطأ في التحليل: $e');
    }
  }

  String _getSealedClassCode() {
    final stateType = _currentState.runtimeType.toString();
    return '// 1. تعريف الهيكل المغلق (Exhaustive Sealed Hierarchy)\n'
        'sealed class AuthState {}\n'
        'class AuthInitial extends AuthState {}\n'
        'class AuthLoading extends AuthState { final String message; ... }\n'
        'class AuthSuccess extends AuthState { final ({String name, String role, int level}) user; ... }\n'
        'class AuthFailure extends AuthState { final String error; final int code; ... }\n\n'
        '// 2. مطابقة شاملة بالحالة الحالية ($stateType) دون الحاجة لـ default:\n'
        'final (icon, color, text) = switch (state) {\n'
        '  AuthInitial() => (Icons.lock, Colors.grey, "Initial"),\n'
        '  AuthLoading(:final message) => (Icons.hourglass_top, Colors.amber, "Loading: \$message"),\n'
        '  AuthSuccess(:final user) => (Icons.verified, Colors.green, "User: \${user.name}"),\n'
        '  AuthFailure(:final error, :final code) => (Icons.error, Colors.red, "Error \$code: \$error"),\n'
        '};';
  }

  String _getRecordsCode() {
    return '// 1. تعريف سجل بالأنواع والحقول المسماة (Record):\n'
        '({String name, int age, double score, bool isPro}) user = (\n'
        '  name: "${_userRecord.name}",\n'
        '  age: ${_userRecord.age},\n'
        '  score: ${_userRecord.score},\n'
        '  isPro: ${_userRecord.isPro},\n'
        ');\n\n'
        '// 2. تفكيك السجل (Pattern Destructuring):\n'
        'final (:name, :age, :score, :isPro) = user;\n'
        'print("User: \$name, Age: \$age, Pro: \$isPro");';
  }

  String _getPatternMatchingCode() {
    return '// مطابقة الأنماط داخل Maps و Json مع شرط الحراسة (Guard Clause):\n'
        'final data = $_jsonInput;\n\n'
        'final message = switch (data) {\n'
        '  {"type": "admin", "permissions": List p, "quota": int q} when q >= 1000 =>\n'
        '    "👑 Super Admin with \${p.length} permissions & \$q quota",\n'
        '  {"type": "admin", "permissions": List p} => "⚡ Normal Admin",\n'
        '  {"type": "guest", "permissions": ["read"]} => "👀 Read-only Guest",\n'
        '  _ => "❓ Unknown"\n'
        '};';
  }

  void _openAiCopilot(BuildContext context, bool isArabic) {
    ContextualAiSheet.show(
      context,
      topicTitle: isArabic ? 'مختبر ميزات Dart 3 الحديثة' : 'Dart 3 Modern Features Lab',
      topicCode: '${_getSealedClassCode()}\n\n${_getRecordsCode()}\n\n${_getPatternMatchingCode()}',
      levelTitle: isArabic ? 'ميزات لغة Dart 3 ومطابقة الأنماط' : 'Dart 3 Language Features',
      isArabic: isArabic,
    );
  }

  @override
  Widget build(BuildContext context) {
    final locale = AppLocaleScope.of(context);
    final isArabic = locale.isArabic;

    return Directionality(
      textDirection: locale.textDirection,
      child: Scaffold(
        appBar: AppBar(
          title: Text(isArabic ? 'مختبر ميزات Dart 3 الحديثة' : 'Dart 3 Modern Features Lab'),
          actions: [
          const LabQuizAction(labId: 'dart3'),
            IconButton(
              tooltip: isArabic ? 'اسأل المساعد الذكي' : 'Ask AI Copilot',
              icon: const Icon(Icons.psychology_rounded, color: Color(0xFF14B8A6)),
              onPressed: () => _openAiCopilot(context, isArabic),
            ),
          ],
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () => _openAiCopilot(context, isArabic),
          icon: const Icon(Icons.psychology_rounded, color: Color(0xFF04111C)),
          label: Text(
            isArabic ? 'اسأل المساعد الذكي عن هذا الكود' : 'Ask AI About This Code',
            style: const TextStyle(color: Color(0xFF04111C), fontWeight: FontWeight.bold),
          ),
          backgroundColor: const Color(0xFF14B8A6),
        ),
        body: ResponsiveContentWrapper(
          maxWidth: 1200,
          child: ListView(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
            children: [
              // بطاقة التقديم
              _buildIntroCard(isArabic),
              16.heightBox,

              // 1. Sealed Classes & Exhaustive Switch
              _buildSealedClassesSection(isArabic),
              16.heightBox,

              // 2. Records & Destructuring
              _buildRecordsSection(isArabic),
              16.heightBox,

              // 3. Pattern Matching & Guard Clauses
              _buildPatternMatchingSection(isArabic),
              24.heightBox,
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildIntroCard(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF101828),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF0284C7).withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFF0284C7).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.code_rounded, color: Color(0xFF38BDF8), size: 24),
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'ثورة Dart 3 في بناء التطبيقات' : 'Dart 3 Revolution in App Building',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                ),
                4.heightBox,
                Text(
                  isArabic
                      ? 'تقدم Dart 3 أماناً كاملاً للأنماط (Type-Safety) ومطابقة شاملة (Exhaustiveness) تمنع أخطاء وقت التشغيل كلياً مع السجلات (Records) والأنماط المعزولة (Sealed Classes).'
                      : 'Dart 3 brings 100% sound exhaustiveness checking, pattern matching, guard clauses and records for cleaner code.',
                  style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSealedClassesSection(bool isArabic) {
    // استخدام Switch Expression مع Destructuring على Sealed Class
    final (uiIcon, uiColor, uiText) = switch (_currentState) {
      AuthInitial() => (Icons.lock_outline_rounded, Colors.grey, isArabic ? 'حالة أولية: لم يبدأ الدخول' : 'Initial State: Idle'),
      AuthLoading(:final message) => (Icons.hourglass_top_rounded, Colors.amber, isArabic ? 'تحميل: $message' : 'Loading: $message'),
      AuthSuccess(:final user) => (
          Icons.verified_user_rounded,
          const Color(0xFF10B981),
          isArabic
              ? 'نجاح! المستخدم: ${user.name} (${user.role}) - المستوى: ${user.level}'
              : 'Success! User: ${user.name} (${user.role}) - Lvl: ${user.level}'
        ),
      AuthFailure(:final error, :final code) => (
          Icons.error_outline_rounded,
          const Color(0xFFEF4444),
          isArabic ? 'فشل (#$code): $error' : 'Failed (#$code): $error'
        ),
    };

    return Container(
      padding: const EdgeInsets.all(16),
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
              const Icon(Icons.category_rounded, color: Color(0xFF38BDF8), size: 18),
              8.widthBox,
              Text(
                isArabic ? '1. فئات Sealed و Switch Expressions الشاملة' : '1. Sealed Classes & Exhaustive Switches',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
              ),
            ],
          ),
          8.heightBox,
          Text(
            isArabic
                ? 'فئات sealed تضمن للمترجم معرفة جميع الحالات الفرعية الممكنة. إذا نسيت حالة واحدة، يعطي خطأ أثناء الـ Compilation!'
                : 'Sealed classes enforce exhaustive switch matching at compile time. No default case required.',
            style: const TextStyle(fontSize: 11.5, color: Colors.white70),
          ),
          12.heightBox,

          // شاشة عرض الحالة الحالية
          AnimatedContainer(
            duration: const Duration(milliseconds: 250),
            padding: const EdgeInsets.all(14),
            decoration: BoxDecoration(
              color: uiColor.withValues(alpha: 0.12),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: uiColor.withValues(alpha: 0.4)),
            ),
            child: Row(
              children: [
                Icon(uiIcon, color: uiColor, size: 28),
                12.widthBox,
                Expanded(
                  child: Text(
                    uiText,
                    style: TextStyle(color: uiColor, fontWeight: FontWeight.bold, fontSize: 12.5),
                  ),
                ),
              ],
            ),
          ),
          12.heightBox,

          // أزرار تبديل الحالات
          Wrap(
            spacing: 8,
            runSpacing: 8,
            children: [
              OutlinedButton.icon(
                onPressed: () => setState(() => _currentState = const AuthInitial()),
                icon: const Icon(Icons.refresh_rounded, size: 14),
                label: Text(isArabic ? 'Initial' : 'Initial'),
              ),
              OutlinedButton.icon(
                onPressed: () => setState(() => _currentState = const AuthLoading(message: 'جاري فحص التوكن...')),
                icon: const Icon(Icons.sync_rounded, size: 14),
                label: Text(isArabic ? 'Loading' : 'Loading'),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF059669)),
                onPressed: () => setState(() => _currentState = const AuthSuccess((name: 'سارة خالد', role: 'Flutter Architect', level: 99))),
                icon: const Icon(Icons.check_circle_rounded, size: 14, color: Colors.white),
                label: Text(isArabic ? 'Success (Record)' : 'Success (Record)', style: const TextStyle(color: Colors.white)),
              ),
              ElevatedButton.icon(
                style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFFDC2626)),
                onPressed: () => setState(() => _currentState = const AuthFailure('انتهت صلاحية الجلسة Token Expired', code: 401)),
                icon: const Icon(Icons.cancel_rounded, size: 14, color: Colors.white),
                label: Text(isArabic ? 'Failure (401)' : 'Failure (401)', style: const TextStyle(color: Colors.white)),
              ),
            ],
          ),
          14.heightBox,

          CopyableCodeBlock(
            code: _getSealedClassCode(),
            copiedMessage: isArabic ? 'تم نسخ كود Sealed Class' : 'Sealed Class code copied',
          ),
        ],
      ),
    );
  }

  Widget _buildRecordsSection(bool isArabic) {
    // تفكيك السجل (Record Destructuring)
    final (:name, :age, :score, :isPro) = _userRecord;

    return Container(
      padding: const EdgeInsets.all(16),
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
              const Icon(Icons.data_object_rounded, color: Color(0xFF14B8A6), size: 18),
              8.widthBox,
              Text(
                isArabic ? '2. السجلات والتفكيك (Records & Destructuring)' : '2. Records & Destructuring',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
              ),
            ],
          ),
          8.heightBox,
          Text(
            isArabic
                ? 'السجلات (Records) هي كائنات مجمعة مجهولة وخفيفة الوزن تتيح إرجاع عدة قيم من دالة واحدة بدون إنشاء كلاس مخصص DTO.'
                : 'Records provide anonymous, strongly typed tuples with named and positional fields.',
            style: const TextStyle(fontSize: 11.5, color: Colors.white70),
          ),
          12.heightBox,

          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF080D1A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF1E293B)),
            ),
            child: Column(
              children: [
                _buildDataRow(isArabic ? 'الاسم:' : 'Name:', name, const Color(0xFF38BDF8)),
                _buildDataRow(isArabic ? 'العمر:' : 'Age:', '$age سنة', Colors.amber),
                _buildDataRow(isArabic ? 'التقييم:' : 'Score:', '$score %', const Color(0xFF10B981)),
                _buildDataRow(isArabic ? 'عضوية احترافية:' : 'Pro Member:', isPro ? 'نعم (VIP)' : 'لا', const Color(0xFFEC4899)),
              ],
            ),
          ),
          12.heightBox,

          ElevatedButton.icon(
            style: ElevatedButton.styleFrom(backgroundColor: const Color(0xFF0F766E)),
            onPressed: () {
              setState(() {
                _userRecord = _userRecord.isPro
                    ? (name: 'محمد رضوان', age: 29, score: 99.8, isPro: false)
                    : (name: 'أحمد علي', age: 24, score: 98.5, isPro: true);
              });
            },
            icon: const Icon(Icons.shuffle_rounded, size: 16, color: Colors.white),
            label: Text(isArabic ? 'تحديث السجل بمطابقة جديدة' : 'Mutate Record Values', style: const TextStyle(color: Colors.white)),
          ),
          14.heightBox,

          CopyableCodeBlock(
            code: _getRecordsCode(),
            copiedMessage: isArabic ? 'تم نسخ كود السجلات' : 'Records code copied',
          ),
        ],
      ),
    );
  }

  Widget _buildPatternMatchingSection(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
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
              const Icon(Icons.rule_folder_rounded, color: Color(0xFF8B5CF6), size: 18),
              8.widthBox,
              Text(
                isArabic ? '3. مطابقة الأنماط وشروط الحراسة (Guard Clauses)' : '3. Pattern Matching & Guard Clauses',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
              ),
            ],
          ),
          8.heightBox,
          Text(
            isArabic
                ? 'استخدم شرط `when` داخل الـ Pattern لتصفية الحالات بدقة مذهلة دون الحاجة لـ if-else المتداخلة.'
                : 'Use `when` guard clauses inside switch cases for precise, declarative validation.',
            style: const TextStyle(fontSize: 11.5, color: Colors.white70),
          ),
          12.heightBox,

          Row(
            children: [
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _jsonInput = '{"type": "admin", "permissions": ["read", "write", "delete"], "quota": 1000}';
                    _evaluateJsonPattern(_jsonInput);
                  },
                  child: Text(isArabic ? 'نمط: مدير فائق (Admin)' : 'Admin Match'),
                ),
              ),
              8.widthBox,
              Expanded(
                child: OutlinedButton(
                  onPressed: () {
                    _jsonInput = '{"type": "guest", "permissions": ["read"], "quota": 50}';
                    _evaluateJsonPattern(_jsonInput);
                  },
                  child: Text(isArabic ? 'نمط: زائر (Guest)' : 'Guest Match'),
                ),
              ),
            ],
          ),
          12.heightBox,

          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFF080D1A),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: const Color(0xFF8B5CF6).withValues(alpha: 0.4)),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'نتيجة المطابقة الفورية:' : 'Pattern Evaluation Result:',
                  style: const TextStyle(fontSize: 11, color: Colors.white54),
                ),
                6.heightBox,
                Text(
                  _patternResult,
                  style: const TextStyle(color: Color(0xFFA78BFA), fontWeight: FontWeight.bold, fontSize: 12.5),
                ),
              ],
            ),
          ),
          14.heightBox,

          CopyableCodeBlock(
            code: _getPatternMatchingCode(),
            copiedMessage: isArabic ? 'تم نسخ كود Pattern Matching' : 'Pattern Matching code copied',
          ),
        ],
      ),
    );
  }

  Widget _buildDataRow(String label, String value, Color valueColor) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label, style: const TextStyle(color: Colors.white60, fontSize: 12)),
          Text(value, style: TextStyle(color: valueColor, fontWeight: FontWeight.bold, fontSize: 12)),
        ],
      ),
    );
  }
}
