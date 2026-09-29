import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:google_generative_ai/google_generative_ai.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// خدمة المساعد الذكي لـ Flutter (Gemini AI Service)
class AiAssistantService {
  AiAssistantService._();
  static final AiAssistantService instance = AiAssistantService._();

  static const String _apiKeyStorageKey = 'gemini_api_key_custom';

  /// المفتاح الافتراضي المدمج (يمكن تمريره عبر --dart-define=GEMINI_API_KEY=your_key)
  static const String _defaultApiKey = String.fromEnvironment(
    'GEMINI_API_KEY',
    defaultValue: '',
  );

  String? _cachedApiKey;

  /// تهيئة وقراءة المفتاح المحفوظ
  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _cachedApiKey = prefs.getString(_apiKeyStorageKey);
  }

  /// المفتاح الفعلي المستخدم (المفتاح المحفوظ في التطبيق أو ملف .env أو المفتاح الافتراضي)
  String? get currentApiKey {
    if (_cachedApiKey != null && _cachedApiKey!.trim().isNotEmpty) {
      return _cachedApiKey!.trim();
    }
    final envKey = dotenv.maybeGet('GEMINI_API_KEY');
    if (envKey != null && envKey.trim().isNotEmpty) {
      return envKey.trim();
    }
    if (_defaultApiKey.trim().isNotEmpty) {
      return _defaultApiKey.trim();
    }
    return null;
  }

  /// هل يمتلك المستخدم مفتاح API صالح؟
  bool get hasApiKey =>
      currentApiKey != null && currentApiKey!.trim().isNotEmpty;

  /// حفظ مفتاح API جديد من واجهة المستخدم
  Future<void> saveApiKey(String apiKey) async {
    final prefs = await SharedPreferences.getInstance();
    _cachedApiKey = apiKey.trim();
    if (_cachedApiKey!.isEmpty) {
      await prefs.remove(_apiKeyStorageKey);
    } else {
      await prefs.setString(_apiKeyStorageKey, _cachedApiKey!);
    }
  }

  /// حذف المفتاح المخصص
  Future<void> removeApiKey() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_apiKeyStorageKey);
    _cachedApiKey = null;
  }

  /// إرسال سؤال للمساعد الذكي مع توفير سياق الموضوع
  Future<String> askAi({
    required String userPrompt,
    String? topicTitle,
    String? topicCode,
    String? levelTitle,
    bool isArabic = true,
  }) async {
    // 1. إذا كان المستخدم قد أدخل مفتاح API لـ Gemini
    if (hasApiKey) {
      final modelCandidates = [
        'gemini-flash-lite-latest',
        'gemini-3.5-flash-lite',
        'gemini-3.1-flash-lite',
        'gemini-2.5-flash-lite',
        'gemini-flash-latest',
        'gemini-3.8-flash',
        'gemini-3.5-flash',
      ];

      final fullPromptBuffer = StringBuffer();
      if (topicTitle != null) {
        fullPromptBuffer.writeln('Context Topic: $topicTitle');
      }
      if (levelTitle != null) {
        fullPromptBuffer.writeln('Level: $levelTitle');
      }
      if (topicCode != null && topicCode.isNotEmpty) {
        fullPromptBuffer.writeln('Reference Code:\n```dart\n$topicCode\n```\n');
      }
      fullPromptBuffer.writeln('User Question:\n$userPrompt');

      final promptText = fullPromptBuffer.toString();
      final systemPrompt =
          'You are a world-class Senior Staff Flutter & Dart Architect. '
          'You provide clean, deeply accurate, highly structured explanations. '
          'Always format code cleanly with comments. '
          'Language: ${isArabic ? "Arabic with English technical terms" : "English"}.';

      for (final modelName in modelCandidates) {
        // نحاول حتى مرتين لكل نموذج لتفادي ضغط الخوادم اللحظي (503 High Demand)
        for (int attempt = 0; attempt < 2; attempt++) {
          try {
            final model = GenerativeModel(
              model: modelName,
              apiKey: currentApiKey!,
              systemInstruction: Content.text(systemPrompt),
            );

            final response = await model.generateContent([
              Content.text(promptText),
            ]);

            final responseText = response.text;
            if (responseText != null && responseText.trim().isNotEmpty) {
              return responseText;
            }
          } catch (_) {
            if (attempt == 0) {
              await Future.delayed(const Duration(milliseconds: 600));
            }
          }
        }
      }

      // إذا تعذر الاتصال الحي، نستخدم المحرك الذكي المدمج
      final smartFallback = _generateSmartOfflineResponse(
        userPrompt: userPrompt,
        topicTitle: topicTitle,
        topicCode: topicCode,
        isArabic: isArabic,
      );

      return smartFallback;
    }

    // 2. النمط التجريبي الذكي في حال عدم إدخال مفتاح بعد (Smart Fallback Engine)
    await Future.delayed(const Duration(milliseconds: 900));
    return _generateSmartOfflineResponse(
      userPrompt: userPrompt,
      topicTitle: topicTitle,
      topicCode: topicCode,
      isArabic: isArabic,
    );
  }

  /// محرك الردود الذكية في النمط التجريبي
  String _generateSmartOfflineResponse({
    required String userPrompt,
    String? topicTitle,
    String? topicCode,
    required bool isArabic,
  }) {
    final title = topicTitle ?? 'هذا الموضوع';

    if (userPrompt.contains('اختبار') ||
        userPrompt.contains('test') ||
        userPrompt.contains('Unit')) {
      return isArabic
          ? '🧪 **كيفية كتابة Unit Test احترافي لـ $title:**\n\n'
                '1. نقوم بعمل Mock للـ Dependencies باستخدام حزمة `mocktail`.\n'
                '2. نستخدم نمط `blocTest` أو `test()` القياسي:\n\n'
                '```dart\n'
                'test("يجب أن يعيد نتيجة ناجحة عند استدعاء البيانات", () async {\n'
                '  // 1. Arrange\n'
                '  when(() => mockRepo.fetchData()).thenAnswer((_) async => Right(tData));\n\n'
                '  // 2. Act\n'
                '  final result = await useCase();\n\n'
                '  // 3. Assert\n'
                '  expect(result, equals(Right(tData)));\n'
                '  verify(() => mockRepo.fetchData()).called(1);\n'
                '});\n'
                '```\n\n'
                '💡 *نصيحة:* تأكد دائماً من اختبار حالتي النجاح (Right) والفشل (Left) بشكل منفصل.'
          : '🧪 **Unit Testing Guide for $title:**\n\n'
                '```dart\n'
                'test("should return success data when repository succeeds", () async {\n'
                '  when(() => mockRepo.fetchData()).thenAnswer((_) async => Right(tData));\n'
                '  final result = await useCase();\n'
                '  expect(result, equals(Right(tData)));\n'
                '});\n'
                '```';
    }

    if (userPrompt.contains('بدائل') ||
        userPrompt.contains('مقارنة') ||
        userPrompt.contains('alternative')) {
      return isArabic
          ? '⚖️ **البدائل ومقارنة الأداء لـ $title:**\n\n'
                '| التقنية | متى تختارها؟ | الأثر على الذاكرة والـ UI |\n'
                '| :--- | :--- | :--- |\n'
                '| **التقنية الحالية ($title)** | المشاريع المتوسطة والكبيرة | عزل تام للأداء وسهولة في الاختبارات |\n'
                '| **الحلول البديلة المباشرة** | الشاشات الصغيرة الفردية | كود أقصر لكن يصعب مشاركة حالته |\n\n'
                '🎯 **القاعدة الذهبية:** اختر دائماً الحل الذي يحافظ على Immutability ويفصل المنطق عن شجرة الرسوميات.'
          : '⚖️ **Alternatives & Performance Comparison for $title:**\n\n'
                'Always prefer immutable patterns that separate business logic from the widget tree.';
    }

    // الرد الافتراضي الشامل
    return isArabic
        ? '🤖 **تحليل المساعد الذكي لـ $title:**\n\n'
              'في بيئة الإنتاج الحقيقية (Production)، يتم تطبيق هذا المفهوم بالشكل التالي:\n\n'
              '1. **الفكرة الأساسية:** تفادي العمليات الثقيلة على الـ Main Thread وعزل منطق الأعمال تماماً عن الـ Widgets.\n'
              '2. **أفضل الممارسات (Best Practice):**\n'
              '   - التعامل دائماً مع كائنات `final` غير قابلة للتعديل.\n'
              '   - حماية التطبيق من الـ Memory Leaks بإلغاء المؤقتات والاشتراكات في دالة `dispose()`.\n'
              '   - استخدام `Either<Failure, T>` لمعالجة الأخطاء دون الحاجة لـ try/catch في الواجهة.\n\n'
              '```dart\n'
              '// مثال تطبيقي احترافي\n'
              'Future<void> executeBestPractice() async {\n'
              '  final result = await safeOperation();\n'
              '  result.fold(\n'
              '    (failure) => logError(failure.message),\n'
              '    (data) => updateUi(data),\n'
              '  );\n'
              '}\n'
              '```'
        : '🤖 **AI Architecture Analysis for $title:**\n\n'
              'In production Flutter apps, always isolate heavy computation, enforce sound null safety, and handle errors functionally.';
  }
}
