class QuizText {
  const QuizText({required this.ar, required this.en});

  final String ar;
  final String en;

  String value(bool isArabic) => isArabic ? ar : en;
}

class LabQuizQuestion {
  const LabQuizQuestion({
    required this.question,
    required this.options,
    required this.correctIndex,
    required this.explanation,
  });

  final QuizText question;
  final List<QuizText> options;
  final int correctIndex;
  final QuizText explanation;
}

const Map<String, QuizText> labQuizTitles = {
  'isolates': QuizText(ar: 'مختبر Isolates', en: 'Isolates Lab'),
  'repaint-boundary': QuizText(
    ar: 'مختبر RepaintBoundary',
    en: 'RepaintBoundary Lab',
  ),
  'animations': QuizText(ar: 'مختبر الحركات', en: 'Animations Lab'),
  'memory-performance': QuizText(
    ar: 'مختبر الذاكرة والأداء',
    en: 'Memory & Performance Lab',
  ),
  'slivers': QuizText(ar: 'مختبر Slivers', en: 'Slivers Lab'),
  'physics-painter': QuizText(
    ar: 'مختبر الرسم والفيزياء',
    en: 'CustomPainter & Physics Lab',
  ),
  'debouncer': QuizText(ar: 'مختبر Debouncer', en: 'Debouncer Lab'),
  'streams-rx': QuizText(ar: 'مختبر Streams', en: 'Streams Lab'),
  'error-handling': QuizText(
    ar: 'مختبر معالجة الأخطاء',
    en: 'Error Handling Lab',
  ),
  'offline-sync': QuizText(ar: 'مختبر العمل دون اتصال', en: 'Offline Sync Lab'),
  'dart3': QuizText(ar: 'مختبر Dart 3', en: 'Dart 3 Lab'),
  'state-inherited': QuizText(
    ar: 'مختبر إدارة الحالة',
    en: 'State Management Lab',
  ),
  'state-comparison': QuizText(
    ar: 'مختبر مقارنة إدارة الحالة (Cubit vs setState)',
    en: 'State Comparison Lab (Cubit vs setState)',
  ),
  'clean-architecture': QuizText(
    ar: 'مختبر المعمارية النظيفة',
    en: 'Clean Architecture Lab',
  ),
  'platform-channels': QuizText(
    ar: 'مختبر Platform Channels',
    en: 'Platform Channels Lab',
  ),
  'keys': QuizText(ar: 'مختبر المفاتيح', en: 'Keys Lab'),
  'security': QuizText(ar: 'مختبر الأمان', en: 'Security Lab'),
  'deployment': QuizText(ar: 'مختبر النشر', en: 'Deployment Lab'),
  'extensions': QuizText(ar: 'مختبر Extensions', en: 'Extensions Lab'),
};

const Map<String, List<LabQuizQuestion>> labQuizzes = {
  'isolates': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما الفائدة الأساسية من Isolate.run() في تطبيق Flutter؟',
        en: 'What is the main benefit of Isolate.run() in a Flutter app?',
      ),
      options: [
        QuizText(
          ar: 'تشغيل الحسابات الثقيلة خارج واجهة المستخدم',
          en: 'Run CPU-heavy work away from the UI isolate',
        ),
        QuizText(
          ar: 'تحديث الواجهة من أي خيط مباشرة',
          en: 'Update the UI directly from any thread',
        ),
        QuizText(
          ar: 'تحويل كل طلبات الشبكة إلى متزامنة',
          en: 'Make every network request synchronous',
        ),
        QuizText(
          ar: 'تخزين البيانات بين مرات تشغيل التطبيق',
          en: 'Persist data between app launches',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'العزل ينقل الحسابات المكلفة إلى Isolate منفصل، فيظل Isolate الواجهة قادرًا على رسم الإطارات والاستجابة للمستخدم.',
        en: 'A worker isolate handles expensive computation so the UI isolate can keep rendering frames and responding to input.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'أي عبارة تصف compute في Flutter على الويب بشكل صحيح؟',
        en: 'Which statement correctly describes compute in Flutter on the web?',
      ),
      options: [
        QuizText(
          ar: 'يبدأ دائمًا عملية نظام تشغيل جديدة',
          en: 'It always starts a new operating-system process',
        ),
        QuizText(
          ar: 'ينفذ الدالة على Isolate الواجهة لأن الويب لا يدعم Isolates بالطريقة نفسها',
          en: 'It runs the function on the UI isolate because web does not support isolates the same way',
        ),
        QuizText(
          ar: 'لا يقبل إلا الدوال التي ترجع String',
          en: 'It only accepts functions returning String',
        ),
        QuizText(
          ar: 'يمنع استخدام async و await',
          en: 'It prevents using async and await',
        ),
      ],
      correctIndex: 1,
      explanation: QuizText(
        ar: 'على منصات الويب، compute يشغّل الدالة على Isolate الواجهة؛ لذلك لا يعزل عمل CPU كما يفعل على المنصات الأصلية.',
        en: 'On web, compute runs the callback on the current event loop rather than moving CPU work to a separate isolate.',
      ),
    ),
  ],
  'repaint-boundary': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما الذي يساعد RepaintBoundary على عزله؟',
        en: 'What does RepaintBoundary help isolate?',
      ),
      options: [
        QuizText(
          ar: 'إعادة رسم جزء من الشجرة عن الأجزاء الأخرى',
          en: 'Repainting a subtree separately from surrounding content',
        ),
        QuizText(
          ar: 'إعادة بناء كل Widgets في التطبيق',
          en: 'Rebuilding every widget in the app',
        ),
        QuizText(
          ar: 'طلبات HTTP عن واجهة المستخدم',
          en: 'HTTP requests from the user interface',
        ),
        QuizText(
          ar: 'إدارة الذاكرة عن جامع القمامة',
          en: 'Memory management from the garbage collector',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'ينشئ RepaintBoundary حدًا للرسم يمكن أن يقلل إعادة رسم المناطق الثابتة عند تغير جزء مجاور.',
        en: 'A RepaintBoundary creates a paint boundary that can prevent unchanged neighboring content from being repainted.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'هل RepaintBoundary يمنع إعادة بناء Widget تلقائيًا؟',
        en: 'Does RepaintBoundary automatically prevent a widget rebuild?',
      ),
      options: [
        QuizText(
          ar: 'نعم، يمنع كل عمليات rebuild',
          en: 'Yes, it prevents every rebuild',
        ),
        QuizText(
          ar: 'لا، هو حد للرسم وليس أداة لإيقاف rebuild',
          en: 'No, it is a paint boundary, not a rebuild-prevention tool',
        ),
        QuizText(
          ar: 'نعم، لكنه يعمل على Android فقط',
          en: 'Yes, but only on Android',
        ),
        QuizText(
          ar: 'لا، لأنه يعطل الرسم بالكامل',
          en: 'No, because it disables painting entirely',
        ),
      ],
      correctIndex: 1,
      explanation: QuizText(
        ar: 'إعادة البناء والرسم مرحلتان مختلفتان. RepaintBoundary يؤثر في الرسم، ولا يمنع إعادة بناء شجرة Widgets.',
        en: 'Build and paint are different phases. RepaintBoundary affects painting; it does not stop the widget tree from rebuilding.',
      ),
    ),
  ],
  'animations': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما مسؤولية TickerProvider عند إنشاء AnimationController؟',
        en: 'What does a TickerProvider provide to an AnimationController?',
      ),
      options: [
        QuizText(
          ar: 'تحديثات الإطارات (ticks) المتزامنة مع الشاشة',
          en: 'Frame-synchronized tick updates',
        ),
        QuizText(
          ar: 'حفظ قيمة الحركة على القرص',
          en: 'Persistence for the animation value',
        ),
        QuizText(
          ar: 'توليد Widgets تلقائيًا',
          en: 'Automatic widget generation',
        ),
        QuizText(
          ar: 'تشغيل الحركة على خادم بعيد',
          en: 'Running the animation on a remote server',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'يستخدم AnimationController الـ ticker لتلقي نبضات متزامنة مع الإطارات، عادة عبر vsync الخاص بالـ State.',
        en: 'The controller uses a ticker for frame-synchronized updates, commonly through the State object’s vsync.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما الإجراء المطلوب عند انتهاء State تملك AnimationController؟',
        en: 'What should a State do when it owns an AnimationController?',
      ),
      options: [
        QuizText(
          ar: 'استدعاء dispose على الـ controller',
          en: 'Dispose the controller',
        ),
        QuizText(
          ar: 'تركه يعمل بعد إزالة الشاشة',
          en: 'Let it continue after the screen is removed',
        ),
        QuizText(
          ar: 'تحويله إلى متغير static',
          en: 'Convert it to a static variable',
        ),
        QuizText(
          ar: 'استدعاء setState داخل dispose',
          en: 'Call setState inside dispose',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'يجب التخلص من AnimationController في dispose لتحرير الـ ticker والموارد المرتبطة به.',
        en: 'Dispose the AnimationController in dispose to release its ticker and associated resources.',
      ),
    ),
  ],
  'memory-performance': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'لماذا قد تحتاج إلى تصغير أبعاد صورة كبيرة قبل عرضها؟',
        en: 'Why might you decode a large image at smaller dimensions before displaying it?',
      ),
      options: [
        QuizText(
          ar: 'لتقليل استهلاك الذاكرة وحجم الصورة المفكوكة',
          en: 'To reduce memory used by the decoded bitmap',
        ),
        QuizText(
          ar: 'لزيادة عدد Widgets في الشجرة',
          en: 'To increase the number of widgets in the tree',
        ),
        QuizText(
          ar: 'لمنع استدعاء build',
          en: 'To prevent build from being called',
        ),
        QuizText(ar: 'لتعطيل cache الصور', en: 'To disable image caching'),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'الصورة المفكوكة تستهلك ذاكرة تتناسب مع عدد البكسلات؛ فكّها بالحجم المعروض يقلل استخدام الذاكرة.',
        en: 'Decoded bitmap memory scales with pixel count, so decoding near the display size can save memory.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما التصرف الصحيح مع Timer تملكه شاشة يتم التخلص منها؟',
        en: 'What should a screen do with a Timer it owns when disposed?',
      ),
      options: [
        QuizText(
          ar: 'إلغاء الـ Timer في dispose',
          en: 'Cancel the timer in dispose',
        ),
        QuizText(
          ar: 'تركه يستدعي setState بعد إزالة الشاشة',
          en: 'Let it call setState after the screen is removed',
        ),
        QuizText(
          ar: 'إخفاءه داخل متغير محلي',
          en: 'Hide it in a local variable',
        ),
        QuizText(
          ar: 'إنشاء Timer آخر داخل dispose',
          en: 'Create another timer in dispose',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'ألغِ المؤقتات والاشتراكات التي تملكها الشاشة لتجنب callbacks بعد dispose وتسرب الموارد.',
        en: 'Cancel owned timers and subscriptions to avoid callbacks after dispose and resource leaks.',
      ),
    ),
  ],
  'slivers': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما ميزة SliverList داخل CustomScrollView؟',
        en: 'What is an advantage of SliverList inside CustomScrollView?',
      ),
      options: [
        QuizText(
          ar: 'دمج القائمة مع أجزاء تمرير أخرى في viewport واحد',
          en: 'Combining a list with other scrollable sections in one viewport',
        ),
        QuizText(
          ar: 'منع التمرير على الأجهزة الصغيرة',
          en: 'Disabling scrolling on small devices',
        ),
        QuizText(
          ar: 'استبدال كل عناصر القائمة بـ صور',
          en: 'Replacing every list item with an image',
        ),
        QuizText(
          ar: 'إيقاف إنشاء العناصر عند التمرير',
          en: 'Stopping items from being built while scrolling',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'SliverList يعمل داخل CustomScrollView، فيمكنه مشاركة التمرير مع SliverAppBar وأجزاء sliver أخرى.',
        en: 'SliverList participates in a CustomScrollView, sharing one scroll position with SliverAppBar and other slivers.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'كيف تجعل SliverAppBar يظل ظاهرًا أعلى الشاشة أثناء التمرير؟',
        en: 'How can a SliverAppBar remain visible at the top while scrolling?',
      ),
      options: [
        QuizText(ar: 'استخدام pinned: true', en: 'Set pinned: true'),
        QuizText(ar: 'استخدام shrinkWrap: true', en: 'Set shrinkWrap: true'),
        QuizText(ar: 'تعطيل scrollDirection', en: 'Disable scrollDirection'),
        QuizText(ar: 'لفه داخل ListTile', en: 'Wrap it in a ListTile'),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'خاصية pinned تثبت الـ SliverAppBar بعد وصوله إلى أعلى viewport.',
        en: 'The pinned property keeps the SliverAppBar at the viewport’s leading edge after it reaches the top.',
      ),
    ),
  ],
  'physics-painter': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما الغرض من CustomPainter.shouldRepaint؟',
        en: 'What is the purpose of CustomPainter.shouldRepaint?',
      ),
      options: [
        QuizText(
          ar: 'تحديد ما إذا كانت بيانات الرسام الجديدة تستلزم إعادة الرسم',
          en: 'Decide whether new painter data requires repainting',
        ),
        QuizText(
          ar: 'تحديد اتجاه تمرير الصفحة',
          en: 'Choose the page scroll direction',
        ),
        QuizText(
          ar: 'إدارة التنقل بين الشاشات',
          en: 'Manage navigation between screens',
        ),
        QuizText(
          ar: 'تحويل الرسم إلى صورة على القرص',
          en: 'Save the drawing as an image on disk',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'يقارن shouldRepaint حالة الرسام القديم بالجديد ليحدد إذا كان يجب إعادة رسم اللوحة.',
        en: 'shouldRepaint compares the old and new painter state to decide whether the canvas needs repainting.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'كيف يمكن للوحة رسم أن تستمع إلى Animation وتعيد الرسم مع كل إطار؟',
        en: 'How can a custom painter repaint on each animation frame?',
      ),
      options: [
        QuizText(
          ar: 'تمرير Listenable إلى repaint في CustomPainter',
          en: 'Pass a Listenable to CustomPainter’s repaint parameter',
        ),
        QuizText(
          ar: 'استدعاء Navigator في paint',
          en: 'Call Navigator from paint',
        ),
        QuizText(
          ar: 'تخزين Canvas في SharedPreferences',
          en: 'Store Canvas in SharedPreferences',
        ),
        QuizText(
          ar: 'تعطيل shouldRepaint دائمًا',
          en: 'Always disable shouldRepaint',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'يمكن تمرير Animation أو Listenable إلى repaint كي يستمع RenderCustomPaint لتغيراته ويعيد الرسم.',
        en: 'Passing an Animation or Listenable to repaint lets RenderCustomPaint listen for changes and repaint.',
      ),
    ),
  ],
  'debouncer': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'متى ينفذ Debouncer الإجراء عادةً؟',
        en: 'When does a debouncer usually run an action?',
      ),
      options: [
        QuizText(
          ar: 'بعد توقف الأحداث للمدة المحددة',
          en: 'After events stop for the configured duration',
        ),
        QuizText(
          ar: 'عند أول حدث فقط ودون انتظار',
          en: 'Immediately on the first event and never waits',
        ),
        QuizText(
          ar: 'مرة واحدة عند بدء التطبيق',
          en: 'Once when the app starts',
        ),
        QuizText(ar: 'بعد كل إطار رسوم', en: 'After every rendered frame'),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'الـ Debouncer يؤجل الإجراء ويعيد ضبط المؤقت مع كل حدث جديد، مثل كتابة المستخدم في البحث.',
        en: 'A debouncer delays the action and resets its timer for each new event, such as a search keystroke.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما الفرق العملي الشائع بين Debounce و Throttle؟',
        en: 'What is a common practical difference between debounce and throttle?',
      ),
      options: [
        QuizText(
          ar: 'Debounce ينتظر هدوء الأحداث، وThrottle يحد معدل التنفيذ خلال فترة',
          en: 'Debounce waits for events to settle; throttle limits execution rate over time',
        ),
        QuizText(
          ar: 'كلاهما يمنع تنفيذ الإجراء نهائيًا',
          en: 'Both permanently prevent the action',
        ),
        QuizText(
          ar: 'Throttle يعمل مع الصور فقط',
          en: 'Throttle only works with images',
        ),
        QuizText(
          ar: 'Debounce يحول Future إلى Stream',
          en: 'Debounce converts a Future into a Stream',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'Debounce يناسب تنفيذ البحث بعد توقف الكتابة، وThrottle يناسب تحديد معدل أحداث متكررة مثل التمرير.',
        en: 'Debounce suits search after typing pauses; throttle suits limiting repeated events such as scroll updates.',
      ),
    ),
  ],
  'streams-rx': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما الإجراء المهم عند انتهاء State تملك StreamSubscription؟',
        en: 'What should a State do when it owns a StreamSubscription?',
      ),
      options: [
        QuizText(
          ar: 'إلغاء الاشتراك في dispose',
          en: 'Cancel the subscription in dispose',
        ),
        QuizText(
          ar: 'إنشاء اشتراك جديد داخل dispose',
          en: 'Create a new subscription in dispose',
        ),
        QuizText(
          ar: 'تحويل كل الأحداث إلى Widgets',
          en: 'Convert every event into a widget',
        ),
        QuizText(ar: 'إغلاق التطبيق', en: 'Close the app'),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'إلغاء الاشتراك يوقف استقبال الأحداث ويمنع بقاء مستمع غير مطلوب بعد إزالة الشاشة.',
        en: 'Canceling stops events and avoids leaving an unnecessary listener after the screen is removed.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'أي عملية Stream تُبقي فقط القيم التي تحقق شرطًا؟',
        en: 'Which stream operation keeps only values matching a condition?',
      ),
      options: [
        QuizText(ar: 'where', en: 'where'),
        QuizText(ar: 'map', en: 'map'),
        QuizText(ar: 'listen', en: 'listen'),
        QuizText(ar: 'toString', en: 'toString'),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'where يرشح الأحداث بشرط، بينما map يحول كل حدث إلى قيمة أخرى.',
        en: 'where filters events using a predicate, while map transforms each event into another value.',
      ),
    ),
  ],
  'error-handling': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'في Either<Failure, Data>، أين توضع نتيجة الخطأ عادةً؟',
        en: 'In Either<Failure, Data>, which side usually holds the error?',
      ),
      options: [
        QuizText(ar: 'Left', en: 'Left'),
        QuizText(ar: 'Right', en: 'Right'),
        QuizText(ar: 'كلا الجانبين معًا', en: 'Both sides at once'),
        QuizText(
          ar: 'لا يمكن تمثيل الأخطاء بـ Either',
          en: 'Either cannot represent errors',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'النمط الشائع في dartz هو Left للـ Failure وRight للنتيجة الناجحة.',
        en: 'A common dartz convention is Left for Failure and Right for a successful value.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'أين يُفضّل تحويل استثناءات مصدر البيانات إلى Failure في Clean Architecture؟',
        en: 'Where should data-source exceptions usually be converted into Failure values?',
      ),
      options: [
        QuizText(ar: 'في طبقة Repository', en: 'In the repository layer'),
        QuizText(ar: 'داخل كل Text widget', en: 'Inside every Text widget'),
        QuizText(ar: 'في ThemeData', en: 'In ThemeData'),
        QuizText(ar: 'في ملف pubspec.yaml', en: 'In pubspec.yaml'),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'تتعامل طبقة Repository مع مصادر البيانات وتحول أخطاءها إلى نتيجة Failure يفهمها منطق التطبيق.',
        en: 'The repository handles data sources and maps their exceptions to Failure values understood by application logic.',
      ),
    ),
  ],
  'offline-sync': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما المقصود بتحديث Optimistic UI؟',
        en: 'What is an optimistic UI update?',
      ),
      options: [
        QuizText(
          ar: 'عرض التغيير للمستخدم قبل تأكيد الخادم ثم معالجة الفشل لاحقًا',
          en: 'Show a change before server confirmation, then handle failure if needed',
        ),
        QuizText(
          ar: 'إخفاء كل التغييرات حتى إغلاق التطبيق',
          en: 'Hide every change until the app closes',
        ),
        QuizText(
          ar: 'إرسال كلمة المرور في كل طلب',
          en: 'Send the password with every request',
        ),
        QuizText(
          ar: 'منع الكتابة عندما لا يوجد اتصال',
          en: 'Prevent writes whenever the device is offline',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'تحدّث الواجهة فورًا لتحسين الاستجابة، مع حفظ العملية محليًا أو التراجع عنها إذا فشل المزامنة.',
        en: 'The UI responds immediately while the operation is queued locally or rolled back if synchronization fails.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'لماذا تستخدم Sync Queue في تطبيق Offline-first؟',
        en: 'Why use a sync queue in an offline-first app?',
      ),
      options: [
        QuizText(
          ar: 'لحفظ العمليات غير المرسلة وإعادة المحاولة عند عودة الاتصال',
          en: 'To retain unsent operations and retry when connectivity returns',
        ),
        QuizText(
          ar: 'لحذف بيانات المستخدم عند انقطاع الإنترنت',
          en: 'To delete user data when the internet disconnects',
        ),
        QuizText(
          ar: 'لمنع التطبيق من العمل محليًا',
          en: 'To prevent the app from working locally',
        ),
        QuizText(
          ar: 'لاستبدال قاعدة البيانات بالشبكة',
          en: 'To replace the local database with the network',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'تحتفظ قائمة المزامنة بالعمليات المعلقة لتُرسل لاحقًا وتُعاد محاولتها وفق سياسة مناسبة.',
        en: 'A sync queue retains pending operations so they can be sent and retried according to an appropriate policy.',
      ),
    ),
  ],
  'dart3': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما الفائدة من sealed class مع switch في Dart؟',
        en: 'What is a benefit of using a sealed class with switch in Dart?',
      ),
      options: [
        QuizText(
          ar: 'تمكين التحقق الشامل من الحالات المعروفة',
          en: 'Enable exhaustive checks over the known cases',
        ),
        QuizText(
          ar: 'حفظ الكائنات تلقائيًا على القرص',
          en: 'Automatically persist objects to disk',
        ),
        QuizText(
          ar: 'إلغاء الحاجة إلى أنواع البيانات',
          en: 'Remove the need for data types',
        ),
        QuizText(
          ar: 'تحويل كل الحالات إلى null',
          en: 'Turn every case into null',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'تحدد sealed class مجموعة الحالات الفرعية، ويمكن للمترجم تنبيهك عند عدم تغطية حالة في switch.',
        en: 'A sealed class constrains its subtypes so the compiler can detect missing cases in a switch.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'كيف تصل إلى حقل مسمى في Named Record مثل (name: "Ali", age: 20)؟',
        en: 'How do you access a named field in a record like (name: "Ali", age: 20)?',
      ),
      options: [
        QuizText(ar: 'record.name', en: 'record.name'),
        QuizText(ar: 'record[0]', en: 'record[0]'),
        QuizText(ar: 'record["name"]', en: 'record["name"]'),
        QuizText(ar: 'record->name', en: 'record->name'),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'حقول الـ Named Record تُقرأ باسم الحقل باستخدام الصيغة record.name.',
        en: 'Named record fields are accessed by name using the record.name syntax.',
      ),
    ),
  ],
  'state-inherited': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما ميزة InheritedModel مقارنةً بـ InheritedWidget في هذا المختبر؟',
        en: 'What benefit does InheritedModel provide over InheritedWidget in this lab?',
      ),
      options: [
        QuizText(
          ar: 'إشعار المستهلكين المهتمين بالـ aspect الذي تغيّر فقط',
          en: 'Notify only dependents interested in the changed aspect',
        ),
        QuizText(
          ar: 'حفظ الحالة تلقائيًا على الجهاز',
          en: 'Automatically persist state on the device',
        ),
        QuizText(
          ar: 'إنشاء صفحات التطبيق تلقائيًا',
          en: 'Automatically create app pages',
        ),
        QuizText(
          ar: 'إلغاء الحاجة إلى BuildContext',
          en: 'Remove the need for BuildContext',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'يسمح InheritedModel بتحديد aspects حتى لا يُعاد بناء المستهلك إلا عند تغير الجزء الذي يعتمد عليه.',
        en: 'InheritedModel supports aspects so a dependent rebuilds only when the aspect it uses changes.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'ماذا ينبغي أن يفعل updateShouldNotify في InheritedWidget؟',
        en: 'What should updateShouldNotify do in an InheritedWidget?',
      ),
      options: [
        QuizText(
          ar: 'إرجاع true عندما تتغير البيانات التي يعتمد عليها الأبناء',
          en: 'Return true when data used by dependents changes',
        ),
        QuizText(
          ar: 'إرجاع true في كل استدعاء بلا مقارنة',
          en: 'Always return true without comparing values',
        ),
        QuizText(ar: 'فتح صفحة جديدة', en: 'Open a new page'),
        QuizText(
          ar: 'حفظ البيانات في ملف JSON',
          en: 'Save data to a JSON file',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'يحدد updateShouldNotify ما إذا كان يجب إشعار العناصر التابعة عند استبدال Widget الموروث.',
        en: 'updateShouldNotify decides whether dependents should be notified when the inherited widget is replaced.',
      ),
    ),
  ],
  'clean-architecture': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'في Clean Architecture، إلى أين يجب أن تشير اعتمادات طبقة Domain؟',
        en: 'In Clean Architecture, where should dependencies of the Domain layer point?',
      ),
      options: [
        QuizText(
          ar: 'نحو قواعد العمل والتجريدات، لا نحو تفاصيل Flutter أو قاعدة البيانات',
          en: 'Toward business rules and abstractions, not Flutter or database details',
        ),
        QuizText(ar: 'مباشرةً نحو Widgets', en: 'Directly toward widgets'),
        QuizText(
          ar: 'دائمًا نحو طبقة قاعدة البيانات',
          en: 'Always toward the database layer',
        ),
        QuizText(ar: 'نحو ملفات الأصول فقط', en: 'Only toward asset files'),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'طبقة Domain مستقلة عن التفاصيل الخارجية؛ تعتمد الطبقات الخارجية عليها وتنفذ التجريدات التي تعرفها.',
        en: 'The Domain stays independent of external details; outer layers depend on it and implement its abstractions.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما الدور المعتاد لـ Repository interface في Domain؟',
        en: 'What is the usual role of a repository interface in the Domain layer?',
      ),
      options: [
        QuizText(
          ar: 'تعريف عمليات البيانات دون ربطها بمصدر تخزين محدد',
          en: 'Define data operations without coupling to a specific storage source',
        ),
        QuizText(ar: 'رسم واجهة المستخدم', en: 'Render the user interface'),
        QuizText(ar: 'إدارة ألوان التطبيق', en: 'Manage app colors'),
        QuizText(
          ar: 'تنفيذ HTTP داخل Widget',
          en: 'Perform HTTP inside a widget',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'التجريد يحدد ما يحتاجه منطق التطبيق، ويمكن لطبقة Data توفير تنفيذ باستخدام API أو قاعدة بيانات.',
        en: 'The abstraction states what application logic needs; the Data layer can implement it with an API or database.',
      ),
    ),
  ],
  'platform-channels': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'متى يكون MethodChannel اختيارًا مناسبًا؟',
        en: 'When is a MethodChannel an appropriate choice?',
      ),
      options: [
        QuizText(
          ar: 'لطلب عملية من كود المنصة واستلام نتيجة واحدة',
          en: 'To request a platform operation and receive a single result',
        ),
        QuizText(
          ar: 'لبث أحداث مستمرة فقط',
          en: 'Only to emit continuous events',
        ),
        QuizText(ar: 'لتحديث ThemeData', en: 'To update ThemeData'),
        QuizText(ar: 'لتخزين بيانات JSON محليًا', en: 'To store JSON locally'),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'MethodChannel مناسب لاستدعاء method على Android أو iOS وإرجاع نتيجة؛ أما تدفق الأحداث فيناسبه EventChannel.',
        en: 'MethodChannel calls a method on Android or iOS and returns a result; EventChannel is suited to event streams.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'أي قناة تناسب استقبال تدفق مستمر مثل قراءات الحساس؟',
        en: 'Which channel suits receiving a continuous stream such as sensor readings?',
      ),
      options: [
        QuizText(ar: 'EventChannel', en: 'EventChannel'),
        QuizText(ar: 'MethodChannel فقط', en: 'MethodChannel only'),
        QuizText(ar: 'BuildContext', en: 'BuildContext'),
        QuizText(ar: 'SharedPreferences', en: 'SharedPreferences'),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'EventChannel مصمم لبث تدفق أحداث من كود المنصة إلى Dart.',
        en: 'EventChannel is designed to stream events from platform code to Dart.',
      ),
    ),
  ],
  'keys': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'لماذا تستخدم ValueKey ثابتًا لعناصر القائمة؟',
        en: 'Why use a stable ValueKey for list items?',
      ),
      options: [
        QuizText(
          ar: 'لمساعدة Flutter على مطابقة العنصر وحالته عند تغير ترتيب القائمة',
          en: 'Help Flutter match an item and its state when list order changes',
        ),
        QuizText(
          ar: 'لمنع إعادة رسم الشاشة بالكامل دائمًا',
          en: 'Always prevent the whole screen from repainting',
        ),
        QuizText(
          ar: 'لتخزين بيانات العنصر في الشبكة',
          en: 'Store the item data on the network',
        ),
        QuizText(
          ar: 'لإلغاء الحاجة إلى نوع العنصر',
          en: 'Remove the need for an item type',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'المفتاح المستقر يميز هوية العنصر، فيساعد Flutter على ربط الـ Element والـ State بالعنصر الصحيح بعد إعادة الترتيب.',
        en: 'A stable key identifies an item so Flutter can associate its Element and State with the correct item after reordering.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما المشكلة المحتملة عند استخدام فهرس القائمة كمفتاح لعناصر قابلة لإعادة الترتيب؟',
        en: 'What can go wrong when using a list index as the key for reorderable items?',
      ),
      options: [
        QuizText(
          ar: 'قد تبقى الحالة مرتبطة بالموقع بدل هوية العنصر',
          en: 'State may follow the position instead of the item identity',
        ),
        QuizText(
          ar: 'يتحول الفهرس تلقائيًا إلى GlobalKey',
          en: 'The index automatically becomes a GlobalKey',
        ),
        QuizText(
          ar: 'تتوقف القائمة عن استقبال عناصر',
          en: 'The list stops accepting items',
        ),
        QuizText(ar: 'تصبح كل العناصر const', en: 'Every item becomes const'),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'عند تحرك العناصر تتغير الفهارس؛ مفتاح مبني على هوية ثابتة للعنصر يمنع انتقال الحالة إلى عنصر آخر.',
        en: 'Indexes change as items move; a key based on stable item identity prevents state from following the wrong item.',
      ),
    ),
  ],
  'security': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'أين ينبغي تخزين refresh token على الجهاز؟',
        en: 'Where should a refresh token be stored on a device?',
      ),
      options: [
        QuizText(
          ar: 'في تخزين آمن يستخدم Keychain/Keystore',
          en: 'In secure storage backed by Keychain/Keystore',
        ),
        QuizText(ar: 'داخل كود المصدر', en: 'Inside source code'),
        QuizText(
          ar: 'في نص ظاهر داخل واجهة المستخدم',
          en: 'As visible text in the user interface',
        ),
        QuizText(ar: 'داخل اسم ملف الصورة', en: 'Inside an image file name'),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'التخزين الآمن يستفيد من مخزن النظام المحمي؛ SharedPreferences العادي غير مناسب للأسرار الحساسة.',
        en: 'Secure storage uses the platform’s protected credential store; plain SharedPreferences is not suitable for sensitive secrets.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما التصرف الآمن عند انتهاء access token؟',
        en: 'What is a safer response when an access token expires?',
      ),
      options: [
        QuizText(
          ar: 'تجديده وفق آلية موثوقة مع حماية refresh token',
          en: 'Refresh it through a trusted flow while protecting the refresh token',
        ),
        QuizText(
          ar: 'تسجيل كلمة المرور في سجل التطبيق',
          en: 'Write the password to the app log',
        ),
        QuizText(
          ar: 'إرسال كل بيانات المستخدم إلى سجل التحليلات',
          en: 'Send all user data to analytics logs',
        ),
        QuizText(
          ar: 'تضمين token ثابت في التطبيق',
          en: 'Bundle a permanent token in the app',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'استخدم تدفق تجديد محدودًا وآمنًا، ولا تضع الأسرار في السجلات أو داخل التطبيق.',
        en: 'Use a bounded, secure refresh flow and never put secrets in logs or bundle them in the app.',
      ),
    ),
  ],
  'deployment': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما الذي يجب فعله بمفتاح توقيع إصدار التطبيق؟',
        en: 'What should you do with a production app signing key?',
      ),
      options: [
        QuizText(
          ar: 'حفظه بسرية خارج مستودع المصدر وتأمين نسخة احتياطية',
          en: 'Keep it secret outside source control and secure a backup',
        ),
        QuizText(
          ar: 'إضافته إلى مستودع عام',
          en: 'Commit it to a public repository',
        ),
        QuizText(
          ar: 'إرساله ضمن رسائل الخطأ',
          en: 'Include it in error messages',
        ),
        QuizText(
          ar: 'إعادة توليده عند كل تثبيت للمستخدم',
          en: 'Regenerate it for every user installation',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'فقدان مفتاح التوقيع أو تسريبه يهدد تحديث التطبيق؛ أدره بأمان واحتفظ بنسخة احتياطية محمية.',
        en: 'Losing or exposing a signing key threatens app updates; manage it securely and keep a protected backup.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'لماذا يُستخدم build flavor؟',
        en: 'Why use a build flavor?',
      ),
      options: [
        QuizText(
          ar: 'لفصل إعدادات وموارد نسخ مثل dev وstaging وprod',
          en: 'To separate configuration and resources for dev, staging, and prod builds',
        ),
        QuizText(
          ar: 'لتغيير اتجاه الجهاز تلقائيًا',
          en: 'To automatically change device orientation',
        ),
        QuizText(ar: 'لاستبدال اختبارات الوحدة', en: 'To replace unit tests'),
        QuizText(
          ar: 'لتشغيل التطبيق بلا ملف manifest',
          en: 'To run the app without a manifest',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'تسمح الـ flavors ببناء نسخ منفصلة بإعدادات ومعرّفات وموارد تناسب كل بيئة.',
        en: 'Flavors build separate app variants with environment-specific settings, identifiers, and resources.',
      ),
    ),
  ],
  'extensions': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'هل Extension method تضيف حالة جديدة إلى الكائن الأصلي؟',
        en: 'Does an extension method add new state to the original object?',
      ),
      options: [
        QuizText(
          ar: 'لا، تضيف واجهة استخدام دون تغيير نوع الكائن أو حالته',
          en: 'No, it adds a call-site API without changing the object type or state',
        ),
        QuizText(
          ar: 'نعم، تضيف حقولًا مخزنة إلى كل نسخة',
          en: 'Yes, it adds stored fields to every instance',
        ),
        QuizText(
          ar: 'نعم، وتعدل كود الحزمة الأصلية',
          en: 'Yes, and it rewrites the original package',
        ),
        QuizText(
          ar: 'لا، لأنها تنشئ Widget دائمًا',
          en: 'No, because it always creates a widget',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'الامتدادات توفر استدعاءات إضافية وقت الترجمة ولا تضيف حقولًا مخزنة أو تعدل تعريف النوع الأصلي.',
        en: 'Extensions provide additional compile-time call-site APIs; they do not add stored fields or modify the original type.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما الأنسب لعملية تحقق لا تحتاج إلى حالة أو اعتماد على BuildContext؟',
        en: 'What suits a validation helper that needs no state or BuildContext?',
      ),
      options: [
        QuizText(
          ar: 'دالة أو Extension method بسيطة',
          en: 'A simple function or extension method',
        ),
        QuizText(
          ar: 'StatefulWidget لكل عملية تحقق',
          en: 'A StatefulWidget for each validation',
        ),
        QuizText(ar: 'GlobalKey لكل نص', en: 'A GlobalKey for every string'),
        QuizText(ar: 'AnimationController', en: 'An AnimationController'),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'الدوال والامتدادات البسيطة مناسبة لإعادة استخدام منطق صغير مستقل دون إدخال تعقيد الواجهة.',
        en: 'Simple functions and extensions reuse small independent logic without introducing UI complexity.',
      ),
    ),
  ],
  'state-comparison': [
    LabQuizQuestion(
      question: QuizText(
        ar: 'لماذا يُفضل استخدام BlocSelector بدل BlocBuilder عند التعامل مع حالات تحتوي على حقول متعددة؟',
        en: 'Why is BlocSelector preferred over BlocBuilder when dealing with multi-field states?',
      ),
      options: [
        QuizText(
          ar: 'لأنه يعزل إعادة البناء ليحدث فقط عندما يتغير الحقل المحدد (Selected value)',
          en: 'Because it isolates widget rebuilds to trigger only when the selected value changes',
        ),
        QuizText(
          ar: 'لأنه يمنع إنشاء Cubit جديد',
          en: 'Because it prevents creating a new Cubit',
        ),
        QuizText(
          ar: 'لأنه يحذف الـ State من الذاكرة تلقائياً',
          en: 'Because it automatically clears state from memory',
        ),
        QuizText(
          ar: 'لأنه يعمل بدون BuildContext',
          en: 'Because it works without BuildContext',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'يقوم BlocSelector بفلترة التحديثات بحيث لا يعيد بناء الويدجت إلا إذا تغيرت القيمة الناتجة عن دالة الـ selector فقط، مما يوفر أداءً فائقاً ويمنع إعادة البناء غير الضرورية.',
        en: 'BlocSelector filters updates so the widget only rebuilds when the selected slice of state actually changes, preventing unnecessary rebuilds.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'ما العيب الأساسي في الاعتماد الحصري على setState في التطبيقات الكبيرة؟',
        en: 'What is the main drawback of relying exclusively on setState in large-scale apps?',
      ),
      options: [
        QuizText(
          ar: 'إعادة بناء شجرة الويدجت بالكامل وصعوبة فصل منطق الأعمال عن الواجهة وصعوبة كتابة Unit Tests',
          en: 'Full subtree rebuilds, tight UI coupling, and difficulty writing unit tests',
        ),
        QuizText(
          ar: 'عدم توافق setState مع لغة Dart 3',
          en: 'setState is incompatible with Dart 3',
        ),
        QuizText(
          ar: 'عدم إمكانية تغيير الألوان عبر setState',
          en: 'Inability to mutate colors using setState',
        ),
        QuizText(
          ar: 'استهلاك الإنترنت بشكل متكرر',
          en: 'Excessive network bandwidth consumption',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'استدعاء setState يعيد بناء كامل الـ State الحالية ومكوناتها التابعة، ويدمج منطق البيانات داخل كود الواجهة مما يعقد الاختبارات المعمارية.',
        en: 'setState triggers a full rebuild of the StatefulWidget subtree and tightly couples business logic with UI rendering.',
      ),
    ),
    LabQuizQuestion(
      question: QuizText(
        ar: 'متى يعتبر ValueNotifier خياراً مثالياً؟',
        en: 'When is ValueNotifier an ideal state management choice?',
      ),
      options: [
        QuizText(
          ar: 'عند الحاجة لتحديث تفاعلي محدد وخفيف لقيمة واحدة دون الحاجة لحزم إضافية',
          en: 'When needing lightweight reactive updates for single values without external packages',
        ),
        QuizText(
          ar: 'عند بناء نظام دفع بنكي كامل ومعقد',
          en: 'When building a full complex banking transaction flow',
        ),
        QuizText(
          ar: 'عند الرغبة في إيقاف رسم الإطارات بالكامل',
          en: 'When wanting to halt frame rendering completely',
        ),
        QuizText(
          ar: 'فقط داخل الـ Isolates',
          en: 'Only inside background Isolates',
        ),
      ],
      correctIndex: 0,
      explanation: QuizText(
        ar: 'يوفر ValueNotifier مع ValueListenableBuilder أسلوباً بسيطاً ومدمجاً في Flutter Framework لتحديث جزئيات محددة بدون إضافة أي حزم خارجية.',
        en: 'ValueNotifier with ValueListenableBuilder offers a clean, zero-dependency reactive approach for scoped micro-state.',
      ),
    ),
  ],
};
