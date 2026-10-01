import 'package:flutter/material.dart';

class AppLocaleScope extends InheritedWidget {
  const AppLocaleScope({
    required this.locale,
    required this.onToggleLanguage,
    this.isDarkMode = true,
    this.onToggleTheme,
    required super.child,
    super.key,
  });

  final Locale locale;
  final VoidCallback onToggleLanguage;
  final bool isDarkMode;
  final VoidCallback? onToggleTheme;

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
    return locale != oldWidget.locale ||
        isDarkMode != oldWidget.isDarkMode;
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
    ar: 'تعلم Flutter ببساطة وعملي',
    en: 'Flutter Pro Academy',
  ),
  'appSubtitle': _LocalizedValue(
    ar: 'تجارب عملية سهلة وكود واضح يوضح لك كل فكرة بإيدك.',
    en: 'A practical learning track with levels, labs, and clear code examples.',
  ),
  'language': _LocalizedValue(ar: 'English', en: 'العربية'),
  'dashboard': _LocalizedValue(ar: 'لوحة التجارب', en: 'Learning Dashboard'),
  'level': _LocalizedValue(ar: 'المستوى', en: 'Level'),
  'progress': _LocalizedValue(ar: 'نسبة إنجازك', en: 'Progress'),
  'progressTitle': _LocalizedValue(
    ar: 'تقدمك في المختبرات',
    en: 'Your lab progress',
  ),
  'completed': _LocalizedValue(ar: 'أكملت', en: 'Completed'),
  'of': _LocalizedValue(ar: 'من', en: 'of'),
  'labsCount': _LocalizedValue(ar: 'مختبر', en: 'labs'),
  'openLab': _LocalizedValue(ar: 'افتح المختبر', en: 'Open lab'),
  'takeQuiz': _LocalizedValue(ar: 'اختبر نفسك', en: 'Take the quiz'),
  'checkAnswer': _LocalizedValue(ar: 'تحقق من الإجابة', en: 'Check answer'),
  'progressLoadError': _LocalizedValue(
    ar: 'تعذر تحميل تقدم المختبرات.',
    en: 'Could not load lab progress.',
  ),
  'progressSaveError': _LocalizedValue(
    ar: 'تعذر حفظ تقدم المختبر.',
    en: 'Could not save lab progress.',
  ),
  'retry': _LocalizedValue(ar: 'إعادة المحاولة', en: 'Retry'),
  'lessons': _LocalizedValue(ar: 'دروس', en: 'Lessons'),
  'labs': _LocalizedValue(ar: 'تجارب', en: 'Labs'),
  'code': _LocalizedValue(ar: 'كود', en: 'Code'),
  'playgroundTry': _LocalizedValue(ar: 'جرب بنفسك', en: 'Try it yourself'),
  'playgroundTitle': _LocalizedValue(
    ar: 'محرر التجربة',
    en: 'Interactive editor',
  ),
  'playgroundInstructions': _LocalizedValue(
    ar: 'عدّل الكود هنا واضغط الزر لفتح DartPad داخل التطبيق؛ الكود هيظهر تلقائيًا في المحرر. اضغط Run للتجربة. بعض الأمثلة قد تحتاج إلى استكمال.',
    en: 'Edit the code here and open DartPad inside the app; your code will appear in the editor automatically. Select Run to try it. Some examples may need completion.',
  ),
  'playgroundOpenDartPad': _LocalizedValue(
    ar: 'افتح الكود في DartPad وجربه',
    en: 'Open code in DartPad and try it',
  ),
  'playgroundDartPadTitle': _LocalizedValue(
    ar: 'DartPad داخل التطبيق',
    en: 'DartPad in the app',
  ),
  'playgroundCopyCode': _LocalizedValue(
    ar: 'نسخ الكود المعدّل',
    en: 'Copy edited code',
  ),
  'playgroundCodeCopied': _LocalizedValue(
    ar: 'تم نسخ الكود المعدّل.',
    en: 'Edited code copied.',
  ),
  'playgroundPasteInDartPad': _LocalizedValue(
    ar: 'تم نسخ الكود.',
    en: 'Code copied.',
  ),
  'playgroundDartPadInstructions': _LocalizedValue(
    ar: 'الكود بيتحمّل تلقائيًا في محرر DartPad. اضغط Run لعرض النتيجة.',
    en: 'Your code loads automatically in the DartPad editor. Select Run to see the result.',
  ),
  'playgroundLoadFailed': _LocalizedValue(
    ar: 'تعذر تحميل DartPad. تحقق من الاتصال بالإنترنت وحاول مرة أخرى.',
    en: 'DartPad did not finish loading. Check your internet connection and try again.',
  ),
  'playgroundUnsupportedPlatform': _LocalizedValue(
    ar: 'تشغيل DartPad داخل التطبيق متاح على Android و iOS و macOS فقط.',
    en: 'Embedded DartPad is supported on Android, iOS, and macOS only.',
  ),
  'startLearning': _LocalizedValue(ar: 'ابدأ التجربة', en: 'Start learning'),
  'continueLab': _LocalizedValue(ar: 'افتح التجربة', en: 'Open lab'),
  'trackTitle': _LocalizedValue(ar: 'مسار الدروس', en: 'Level Path'),
  'trackSubtitle': _LocalizedValue(
    ar: 'ابدأ بالأساسيات السهلة وتدرج خطوة بخطوة لحد النشر على المتاجر.',
    en: 'Move from foundations to performance, architecture, and error handling.',
  ),
  'foundations': _LocalizedValue(
    ar: 'الأساسيات العملية',
    en: 'Practical Foundations',
  ),
  'performance': _LocalizedValue(ar: 'السرعة والأداء', en: 'Performance'),
  'architecture': _LocalizedValue(ar: 'تنظيم الكود', en: 'Architecture'),
  'mastery': _LocalizedValue(ar: 'مستويات متقدمة', en: 'Mastery'),
  'overview': _LocalizedValue(ar: 'فكرة التطبيق', en: 'Overview'),
  'overviewBody': _LocalizedValue(
    ar: 'كل موضوع معمول كتجربة صغيرة: فكرة سهلة، زرار تجربه بإيدك، وكود حقيقي تشوفه بيتغير قدامك.',
    en: 'Every section works like a compact lesson: concept, live practice, and a short code reference.',
  ),
  'availableLabs': _LocalizedValue(ar: 'التجارب المتاحة', en: 'Available Labs'),
  'studyPlan': _LocalizedValue(ar: 'نصيحة للمذاكرة', en: 'Quick Plan'),
  'studyPlanBody': _LocalizedValue(
    ar: 'جرّب كل موضوع في 10 دقائق: افهم الفكرة وجرب الأزرار وشوف الكود واتعلم إزاي تطبقه في مشروعك.',
    en: 'Spend 20 minutes per lab: read the idea, run the experiment, then tweak one value in the code.',
  ),
  'about': _LocalizedValue(ar: 'عن التطبيق', en: 'About app'),
  'aboutBody': _LocalizedValue(
    ar: 'تطبيق عملي بسيط يشرح لك أفكار Flutter المهمة بالتجربة المباشرة وبدون تعقيد.',
    en: 'This app is a compact academy for learning advanced Flutter concepts in a practical, organized way.',
  ),
  'close': _LocalizedValue(ar: 'إغلاق', en: 'Close'),
  'isolateTitle': _LocalizedValue(
    ar: 'العمليات في الخلفية (Isolates)',
    en: 'Isolates & Concurrency',
  ),
  'isolateBody': _LocalizedValue(
    ar: 'شغل العمليات الثقيلة في الخلفية عشان الشاشة تفضل سريعة وسلسة وما تهنجش.',
    en: 'Learn when to move heavy work away from the UI thread.',
  ),
  'debounceTitle': _LocalizedValue(
    ar: 'مؤقت البحث وتكرار الضغط',
    en: 'Debouncer & Throttler',
  ),
  'debounceBody': _LocalizedValue(
    ar: 'وفّر استهلاك الإنترنت في البحث وامنع تكرار الضغط السريع على الأزرار.',
    en: 'Reduce network calls and protect actions from repeated taps.',
  ),
  'repaintTitle': _LocalizedValue(
    ar: 'تسريع الرسم (RepaintBoundary)',
    en: 'RepaintBoundary & Performance',
  ),
  'repaintBody': _LocalizedValue(
    ar: 'اعزل الأجزاء المتحركة عشان ما ترسمش باقي الشاشة الثابتة على الفاضي.',
    en: 'Isolate paint work to keep the interface smooth.',
  ),
  'keysTitle': _LocalizedValue(
    ar: 'ترتيب العناصر والمفاتيح (Keys)',
    en: 'Keys & Flutter Trees',
  ),
  'keysBody': _LocalizedValue(
    ar: 'امنع لخبطة العناصر في القوائم وحافظ على مكان وقيمة كل عنصر صح.',
    en: 'Understand Widget, Element, RenderObject, and state identity.',
  ),
  'errorsTitle': _LocalizedValue(
    ar: 'معالجة الأخطاء الذكية',
    en: 'Error Handling',
  ),
  'errorsBody': _LocalizedValue(
    ar: 'اتعامل مع مشاكل النت والسيرفر بهدوء بدون ما التطبيق يقفل فجأة.',
    en: 'Use Either and Cubit to build predictable error flows.',
  ),
  'extensionsTitle': _LocalizedValue(
    ar: 'اختصارات الكود (Extensions)',
    en: 'Extensions & Utilities',
  ),
  'extensionsBody': _LocalizedValue(
    ar: 'اكتب كود مختصر ونظيف يوفر وقتك زي فحص الإيميل وتحديد المسافات.',
    en: 'Write cleaner UI code with reusable extensions.',
  ),
};
