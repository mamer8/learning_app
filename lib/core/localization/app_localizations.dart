import 'package:flutter/material.dart';

class AppLocaleScope extends InheritedWidget {
  const AppLocaleScope({
    required this.locale,
    required this.onToggleLanguage,
    required super.child,
    super.key,
  });

  final Locale locale;
  final VoidCallback onToggleLanguage;

  bool get isArabic => locale.languageCode == 'ar';

  TextDirection get textDirection =>
      isArabic ? TextDirection.rtl : TextDirection.ltr;

  AppStrings get strings => AppStrings(isArabic: isArabic);

  static AppLocaleScope of(BuildContext context) {
    final scope = context.dependOnInheritedWidgetOfExactType<AppLocaleScope>();
    assert(scope != null, 'AppLocaleScope was not found in the widget tree.');
    return scope!;
  }

  @override
  bool updateShouldNotify(AppLocaleScope oldWidget) {
    return locale != oldWidget.locale;
  }
}

class AppStrings {
  const AppStrings({required this.isArabic});

  final bool isArabic;

  String t(String key) {
    final value = _values[key];
    if (value == null) return key;
    return isArabic ? value.ar : value.en;
  }
}

class _LocalizedValue {
  const _LocalizedValue({required this.ar, required this.en});

  final String ar;
  final String en;
}

const Map<String, _LocalizedValue> _values = {
  'appTitle': _LocalizedValue(
    ar: 'أكاديمية Flutter الاحترافية',
    en: 'Flutter Pro Academy',
  ),
  'appSubtitle': _LocalizedValue(
    ar: 'منهج تفاعلي بمستويات، تجارب عملية، وأمثلة كود واضحة.',
    en: 'A practical learning track with levels, labs, and clear code examples.',
  ),
  'language': _LocalizedValue(ar: 'English', en: 'العربية'),
  'dashboard': _LocalizedValue(ar: 'لوحة التعلم', en: 'Learning Dashboard'),
  'level': _LocalizedValue(ar: 'المستوى', en: 'Level'),
  'progress': _LocalizedValue(ar: 'التقدم', en: 'Progress'),
  'lessons': _LocalizedValue(ar: 'دروس', en: 'Lessons'),
  'labs': _LocalizedValue(ar: 'تجارب', en: 'Labs'),
  'code': _LocalizedValue(ar: 'كود', en: 'Code'),
  'startLearning': _LocalizedValue(ar: 'ابدأ التعلم', en: 'Start learning'),
  'continueLab': _LocalizedValue(ar: 'افتح التجربة', en: 'Open lab'),
  'trackTitle': _LocalizedValue(ar: 'مسار المستويات', en: 'Level Path'),
  'trackSubtitle': _LocalizedValue(
    ar: 'ابدأ من الأساسيات ثم انتقل للأداء والمعمارية ومعالجة الأخطاء.',
    en: 'Move from foundations to performance, architecture, and error handling.',
  ),
  'foundations': _LocalizedValue(
    ar: 'الأساسيات العملية',
    en: 'Practical Foundations',
  ),
  'performance': _LocalizedValue(ar: 'الأداء والتوازي', en: 'Performance'),
  'architecture': _LocalizedValue(ar: 'المعمارية النظيفة', en: 'Architecture'),
  'mastery': _LocalizedValue(ar: 'الإتقان', en: 'Mastery'),
  'overview': _LocalizedValue(ar: 'نظرة عامة', en: 'Overview'),
  'overviewBody': _LocalizedValue(
    ar: 'كل سكشن مصمم كدرس صغير: فكرة واضحة، تجربة عملية، وكود مختصر تقدر ترجعله بسرعة.',
    en: 'Every section works like a compact lesson: concept, live practice, and a short code reference.',
  ),
  'availableLabs': _LocalizedValue(ar: 'المعامل المتاحة', en: 'Available Labs'),
  'studyPlan': _LocalizedValue(ar: 'خطة سريعة', en: 'Quick Plan'),
  'studyPlanBody': _LocalizedValue(
    ar: 'خصص 20 دقيقة لكل معمل: اقرأ الفكرة، شغل التجربة، ثم راجع الكود وغيّر قيمة صغيرة لترى التأثير.',
    en: 'Spend 20 minutes per lab: read the idea, run the experiment, then tweak one value in the code.',
  ),
  'about': _LocalizedValue(ar: 'عن التطبيق', en: 'About app'),
  'aboutBody': _LocalizedValue(
    ar: 'التطبيق ده معمول كمنصة تعليمية مصغرة لتعلم مفاهيم Flutter المتقدمة بشكل عملي ومنظم.',
    en: 'This app is a compact academy for learning advanced Flutter concepts in a practical, organized way.',
  ),
  'close': _LocalizedValue(ar: 'إغلاق', en: 'Close'),
  'isolateTitle': _LocalizedValue(
    ar: 'Isolates والتوازي',
    en: 'Isolates & Concurrency',
  ),
  'isolateBody': _LocalizedValue(
    ar: 'افهم متى تنقل الشغل الثقيل خارج الـ UI thread.',
    en: 'Learn when to move heavy work away from the UI thread.',
  ),
  'debounceTitle': _LocalizedValue(
    ar: 'Debouncer و Throttler',
    en: 'Debouncer & Throttler',
  ),
  'debounceBody': _LocalizedValue(
    ar: 'قلل طلبات الشبكة واحم الأزرار من الضغط المتكرر.',
    en: 'Reduce network calls and protect actions from repeated taps.',
  ),
  'repaintTitle': _LocalizedValue(
    ar: 'RepaintBoundary والأداء',
    en: 'RepaintBoundary & Performance',
  ),
  'repaintBody': _LocalizedValue(
    ar: 'اعزل مناطق الرسم لتحسين سلاسة الواجهة.',
    en: 'Isolate paint work to keep the interface smooth.',
  ),
  'keysTitle': _LocalizedValue(
    ar: 'Keys و Flutter Trees',
    en: 'Keys & Flutter Trees',
  ),
  'keysBody': _LocalizedValue(
    ar: 'افهم علاقة Widget و Element و RenderObject وحل مشاكل الـ state.',
    en: 'Understand Widget, Element, RenderObject, and state identity.',
  ),
  'errorsTitle': _LocalizedValue(ar: 'معالجة الأخطاء', en: 'Error Handling'),
  'errorsBody': _LocalizedValue(
    ar: 'استخدم Either و Cubit لبناء تدفق أخطاء واضح.',
    en: 'Use Either and Cubit to build predictable error flows.',
  ),
  'extensionsTitle': _LocalizedValue(
    ar: 'Extensions وأدوات مساعدة',
    en: 'Extensions & Utilities',
  ),
  'extensionsBody': _LocalizedValue(
    ar: 'اكتب كود واجهات أسرع وأنظف بامتدادات قابلة لإعادة الاستخدام.',
    en: 'Write cleaner UI code with reusable extensions.',
  ),
};
