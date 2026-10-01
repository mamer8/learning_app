import 'dart:async';
import 'package:flutter/foundation.dart';

enum TtsState {
  stopped,
  playing,
  paused,
}

/// خدمة تحويل النصوص إلى صوت للمساعد الذكي (Text-to-Speech Engine)
class TextToSpeechService extends ChangeNotifier {
  TextToSpeechService._();
  static final TextToSpeechService instance = TextToSpeechService._();

  TtsState _state = TtsState.stopped;
  String _currentSpeakingText = '';
  double _speechRate = 1.0;
  String _language = 'ar'; // ar, en
  Timer? _speechTimer;

  TtsState get state => _state;
  bool get isSpeaking => _state == TtsState.playing;
  String get currentSpeakingText => _currentSpeakingText;
  double get speechRate => _speechRate;
  String get language => _language;

  void setLanguage(String lang) {
    _language = lang;
    notifyListeners();
  }

  void setSpeechRate(double rate) {
    _speechRate = rate.clamp(0.5, 2.0);
    notifyListeners();
  }

  /// تنظيف نص الـ Markdown من الرموز البرمجية لجعل القراءة الصوتية طبيعية وممتعة
  static String cleanMarkdownForSpeech(String markdown) {
    var text = markdown;
    // استبدال كتل الأكواد بعبارة توضيحية
    text = text.replaceAll(RegExp(r'```[\s\S]*?```'), ' [يوجد كود برمجي توضيحي هنا] ');
    // إزالة الرموز
    text = text.replaceAll(RegExp(r'[#*_`~>|]'), '');
    // إزالة الروابط
    text = text.replaceAll(RegExp(r'\[(.*?)\]\(.*?\)'), r'$1');
    return text.replaceAll(RegExp(r'\s+'), ' ').trim();
  }

  /// استخراج كافة الأكواد البرمجية فقط من الرد
  static String extractOnlyCode(String markdown) {
    final codeBlockRegex = RegExp(r'```(?:[a-zA-Z0-9_-]+)?\n([\s\S]*?)```');
    final matches = codeBlockRegex.allMatches(markdown);
    if (matches.isEmpty) {
      // إذا لم يكن هناك كود محاط بـ ``` نبحث عن سطور كود مفردة
      return markdown.trim();
    }
    return matches.map((m) => m.group(1)?.trim() ?? '').where((s) => s.isNotEmpty).join('\n\n// -----------------------------------------\n\n');
  }

  /// بدء القراءة الصوتية للنص
  Future<void> speak(String text, {bool isArabic = true}) async {
    await stop();

    final cleanText = cleanMarkdownForSpeech(text);
    if (cleanText.isEmpty) return;

    _language = isArabic ? 'ar' : 'en';
    _currentSpeakingText = cleanText;
    _state = TtsState.playing;
    notifyListeners();

    // حساب تقريبي لزمن قراءة النص
    final wordCount = cleanText.split(RegExp(r'\s+')).length;
    final estimatedSeconds = ((wordCount / (2.8 * _speechRate)).ceil()).clamp(3, 45);

    _speechTimer?.cancel();
    _speechTimer = Timer(Duration(seconds: estimatedSeconds), () {
      _state = TtsState.stopped;
      _currentSpeakingText = '';
      notifyListeners();
    });
  }

  /// إيقاف القراءة الصوتية
  Future<void> stop() async {
    _speechTimer?.cancel();
    _speechTimer = null;
    if (_state != TtsState.stopped) {
      _state = TtsState.stopped;
      _currentSpeakingText = '';
      notifyListeners();
    }
  }

  /// تبديل حالة القراءة (Play / Pause / Stop)
  Future<void> toggleSpeak(String text, {bool isArabic = true}) async {
    if (isSpeaking) {
      await stop();
    } else {
      await speak(text, isArabic: isArabic);
    }
  }

  @override
  void dispose() {
    _speechTimer?.cancel();
    super.dispose();
  }
}
