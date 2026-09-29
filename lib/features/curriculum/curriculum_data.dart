import 'package:flutter/material.dart';

class LocalText {
  const LocalText({required this.ar, required this.en});

  final String ar;
  final String en;

  String value(bool isArabic) => isArabic ? ar : en;
}

class CurriculumLevel {
  const CurriculumLevel({
    required this.number,
    required this.title,
    required this.subtitle,
    required this.icon,
    required this.color,
    required this.topics,
  });

  final int number;
  final LocalText title;
  final LocalText subtitle;
  final IconData icon;
  final Color color;
  final List<CurriculumTopic> topics;
}

class CurriculumTopic {
  const CurriculumTopic({
    required this.title,
    required this.summary,
    required this.explain,
    required this.whenToUse,
    required this.steps,
    required this.code,
    required this.commonMistakes,
  });

  final LocalText title;
  final LocalText summary;
  final LocalText explain;
  final List<LocalText> whenToUse;
  final List<LocalText> steps;
  final String code;
  final List<LocalText> commonMistakes;
}

const curriculumLevels = [
  // ===========================================================================
  // LEVEL 1: Modern Dart & Solid Foundations
  // ===========================================================================
  CurriculumLevel(
    number: 1,
    title: LocalText(
      ar: 'أساسيات Dart الحديثة والمعمارية',
      en: 'Modern Dart & Architecture Foundations',
    ),
    subtitle: LocalText(
      ar: 'إتقان Null Safety، Records، Pattern Matching، والمفاهيم الكائنية المتقدمة في Dart 3.',
      en: 'Mastering Null Safety, Records, Pattern Matching, and advanced OOP in Dart 3.',
    ),
    icon: Icons.code_rounded,
    color: Color(0xFF14B8A6),
    topics: [
      CurriculumTopic(
        title: LocalText(
          ar: 'Dart 3: Records & Pattern Matching',
          en: 'Dart 3: Records & Pattern Matching',
        ),
        summary: LocalText(
          ar: 'إرجاع قيم متعددة بدون إنشاء كلاسات وهمية، ومطابقة الأنماط في switch و if-case.',
          en: 'Return multiple values cleanly without tuple classes, and match patterns in switch/if-case.',
        ),
        explain: LocalText(
          ar: 'تتيح ميزة Records في Dart 3 تجميع قيم غير متجانسة ككائن مجهول الاسم وخفيف الوزن (Value Type). مع Pattern Matching، يمكنك تفكيك الكائنات والـ JSON واختبار الأنواع وحالات السيرفر بدون boilerplate.',
          en: 'Records allow grouping heterogeneous values into lightweight value types. Combined with Pattern Matching, you can destructure objects, validate JSON, and handle API responses cleanly.',
        ),
        whenToUse: [
          LocalText(
            ar: 'إرجاع (بيانات + إجمالي الصفحات) من دالة pagination بدون إنشاء DTO إضافي.',
            en: 'Returning (data + totalPages) from pagination methods without creating a dedicated DTO.',
          ),
          LocalText(
            ar: 'تفكيك استجابات الـ JSON وفحص بنية البيانات المعقدة في سطر واحد.',
            en: 'Destructuring JSON responses and validating complex shapes in a single line.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'عرّف الـ Record بين أقواس مثل: `(User user, int count)`.',
            en: 'Define record return types in parentheses: `(User user, int count)`.',
          ),
          LocalText(
            ar: 'فكك النتيجة فوراً في مكان الاستدعاء: `final (user, count) = fetchUserData();`.',
            en: 'Destructure immediately: `final (user, count) = fetchUserData();`.',
          ),
          LocalText(
            ar: 'استخدم Switch Expression للتحقق من استجابات السيرفر وحالات التحميل.',
            en: 'Use Switch Expressions to exhaustively match API response shapes and states.',
          ),
        ],
        code:
            '// 1. دالة تعيد Record بقيم متعددة ذات أسماء\n'
            '({UserProfile user, int totalUnread}) getUserStats() {\n'
            '  return (user: const UserProfile(id: "1", name: "Ahmed"), totalUnread: 5);\n'
            '}\n\n'
            '// 2. استخدام Pattern Matching لتصنيف استجابات الـ API\n'
            'String handleApiResponse(Map<String, dynamic> json) {\n'
            '  return switch (json) {\n'
            '    {"status": 200, "data": Map user} => "مرحباً: \${user["name"]}",\n'
            '    {"status": 401} => "انتهت الجلسة، يرجى تسجيل الدخول",\n'
            '    {"status": int code, "message": String msg} => "خطأ [\$code]: \$msg",\n'
            '    _ => "استجابة غير معروفة"\n'
            '  };\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'الإفراط في استخدام Records غير المسماة بدلاً من Entities في طبقة الـ Domain.',
            en: 'Overusing positional records instead of domain Entities in Clean Architecture.',
          ),
          LocalText(
            ar: 'نسيان حالة الـ default `_ =>` في Switch Expressions عند التعامل مع بيانات ديناميكية.',
            en: 'Omitting the default fallback `_ =>` in Switch Expressions with external data.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(
          ar: 'Sound Null Safety والـ Immutability',
          en: 'Sound Null Safety & Immutability',
        ),
        summary: LocalText(
          ar: 'التعامل الاحترافي مع القيم الفارغة وبناء كائنات غير قابلة للتعديل بـ const و final.',
          en: 'Production-level null safety patterns and immutable object architectures with const.',
        ),
        explain: LocalText(
          ar: 'نظام Sound Null Safety في Dart يضمن في زمن الترجمة (Compile Time) عدم حدوث NoSuchMethodError على كائن null. الكائنات الثابتة (Immutable) تقلل استهلاك الذاكرة وتمنع الأخطاء الجانبية عند مشاركة البيانات عبر الشاشات والـ State Managers.',
          en: 'Sound Null Safety guarantees at compile-time that non-nullable references never cause runtime null pointer crashes. Immutable models prevent side effects when sharing data across state managers.',
        ),
        whenToUse: [
          LocalText(
            ar: 'في كل Domain Entity و Data Model في التطبيق.',
            en: 'In every domain Entity and data Model across the codebase.',
          ),
          LocalText(
            ar: 'عند بناء كلاسات الـ State لـ Bloc أو Riverpod لضمان عدم تعديل الحالة القديمة.',
            en: 'When constructing Bloc or Riverpod state classes to guarantee state immutability.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'اجعل كل الحقول `final` واعتمد الـ `const constructor`.',
            en: 'Make all fields `final` and supply a `const constructor`.',
          ),
          LocalText(
            ar: 'أضف دالة `copyWith` لتحديث الكائن بإنشاء نسخة معدلة جديدة منه.',
            en: 'Implement a `copyWith` method to produce updated copies without mutation.',
          ),
          LocalText(
            ar: 'تجنب عامل التعجب `!` (Force Unwrap) واستخدم بدلاً منه `??` أو `?.let`.',
            en: 'Avoid force-unwrap `!` and prefer null-coalescing `??` and safe calls `?.`.',
          ),
        ],
        code:
            '@immutable\n'
            'class UserState {\n'
            '  final String? email;\n'
            '  final bool isLoading;\n'
            '  final String? errorMessage;\n\n'
            '  const UserState({\n'
            '    this.email,\n'
            '    this.isLoading = false,\n'
            '    this.errorMessage,\n'
            '  });\n\n'
            '  UserState copyWith({\n'
            '    String? email,\n'
            '    bool? isLoading,\n'
            '    String? errorMessage,\n'
            '  }) {\n'
            '    return UserState(\n'
            '      email: email ?? this.email,\n'
            '      isLoading: isLoading ?? this.isLoading,\n'
            '      errorMessage: errorMessage ?? this.errorMessage,\n'
            '    );\n'
            '  }\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استخدام عامل `!` (Bang operator) الذي يفقدك أمان الـ Sound Null Safety ويسبب crash.',
            en: 'Using the force-unwrap `!` operator, which defeats null safety and crashes apps.',
          ),
          LocalText(
            ar: 'تعديل متغيرات الكائن مباشرة (Mutation) مما يمنع Bloc و Riverpod من اكتشاف التغيير.',
            en: 'Mutating model properties directly, preventing state managers from detecting updates.',
          ),
        ],
      ),
    ],
  ),

  // ===========================================================================
  // LEVEL 2: Advanced UI, Slivers & Performance Engineering
  // ===========================================================================
  CurriculumLevel(
    number: 2,
    title: LocalText(
      ar: 'هندسة الواجهات والأداء والرسوميات',
      en: 'Advanced UI, Slivers & Performance Engineering',
    ),
    subtitle: LocalText(
      ar: 'إتقان الـ Slivers، CustomPainter، RepaintBoundary، وإدارة مساحات العرض بكفاءة.',
      en: 'Mastering Slivers, CustomPainter, RepaintBoundary, and 60/120fps rendering pipelines.',
    ),
    icon: Icons.layers_rounded,
    color: Color(0xFF60A5FA),
    topics: [
      CurriculumTopic(
        title: LocalText(
          ar: 'التحكم المتقدم بـ Slivers و CustomScrollView',
          en: 'Advanced Slivers & CustomScrollView',
        ),
        summary: LocalText(
          ar: 'دمج عناصر متعددة كـ Header مطاطي، قوائم أفقية، وشبكات Grids داخل مسار تمرير واحد.',
          en: 'Combine collapsible headers, horizontal rails, and grids into a unified high-performance scroll pipeline.',
        ),
        explain: LocalText(
          ar: 'الـ Slivers هي أجزاء من مساحة التمرير (Viewport) تُحسب حسب الحاجة (Lazy Rendering). تتيح إنشاء شاشات غنية بمعمارية واحدة دون مشاكل `NestedScrollView` أو الـ Scroll Conflicts.',
          en: 'Slivers are portions of a scrollable area rendered lazily based on viewport offsets. They enable complex collapsible headers, sticky app bars, and responsive grids.',
        ),
        whenToUse: [
          LocalText(
            ar: 'شاشات المتجر أو الحساب الشخصي التي تحتوي على Header يتقلص وقوائم متعددة.',
            en: 'E-commerce or profile pages featuring collapsible hero headers and mixed grids.',
          ),
          LocalText(
            ar: 'القوائم الضخمة التي تحتاج Lazy Loading دون استهلاك الذاكرة.',
            en: 'Large content streams requiring lazy item layout and zero memory waste.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم `CustomScrollView` كحاوية رئيسية للشاشة.',
            en: 'Use `CustomScrollView` as the top-level viewport widget.',
          ),
          LocalText(
            ar: 'أضف `SliverAppBar` بخاصية `pinned: true` و `expandedHeight`.',
            en: 'Add a `SliverAppBar` configured with `pinned: true` and `expandedHeight`.',
          ),
          LocalText(
            ar: 'استخدم `SliverList.builder` أو `SliverGrid` لبناء العناصر بتكلفة ذاكرة منعدمة.',
            en: 'Use `SliverList.builder` or `SliverGrid` for infinite lazy rendering.',
          ),
        ],
        code:
            'CustomScrollView(\n'
            '  slivers: [\n'
            '    SliverAppBar(\n'
            '      expandedHeight: 200,\n'
            '      pinned: true,\n'
            '      flexibleSpace: FlexibleSpaceBar(\n'
            '        title: const Text("المتجر الشامل"),\n'
            '        background: Image.network("https://picsum.photos/600/300", fit: BoxFit.cover),\n'
            '      ),\n'
            '    ),\n'
            '    SliverToBoxAdapter(\n'
            '      child: Padding(\n'
            '        padding: const EdgeInsets.all(16),\n'
            '        child: Text("أحدث المنتجات", style: Theme.of(context).textTheme.titleLarge),\n'
            '      ),\n'
            '    ),\n'
            '    SliverList.builder(\n'
            '      itemCount: 100,\n'
            '      itemBuilder: (context, index) => ListTile(title: Text("منتج رقم #\$index")),\n'
            '    ),\n'
            '  ],\n'
            ');',
        commonMistakes: [
          LocalText(
            ar: 'وضع ListView داخل Column أو داخل CustomScrollView بدون SliverToBoxAdapter.',
            en: 'Placing raw ListView directly inside Column or CustomScrollView.',
          ),
          LocalText(
            ar: 'استخدام SliverList بدون builder للقوائم الطويلة مما يلغي ميزة الـ Lazy Loading.',
            en: 'Using non-builder SliverList for long lists, destroying memory performance.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(
          ar: 'عزل الرسوميات بـ RepaintBoundary والـ CustomPainter',
          en: 'RepaintBoundary & Custom Painting',
        ),
        summary: LocalText(
          ar: 'عزل الطبقات المتحركة ذات التردد العالي لتفادي إعادة رسم شجرة الويدجت بالكامل.',
          en: 'Isolating high-frequency animated layers to prevent rebuilding the entire render tree.',
        ),
        explain: LocalText(
          ar: 'عندما يتحرك أنيميشن في فلاتر، يقوم المحرك بوضع علامة Dirty على شجرة الـ RenderObject. باستخدام `RepaintBoundary`، نُنشئ طبقة مستقلة في الـ GPU (Layer Tree)، فيتم عزل الرسم وإيقاف تسربه للعناصر المجاورة.',
          en: 'When a widget animates, Flutter marks its render branch as dirty. RepaintBoundary creates an isolated GPU Layer, preventing repainting from propagating up to parent widgets.',
        ),
        whenToUse: [
          LocalText(
            ar: 'العدادات الرقمية السريعة، موجات الصوت، وخرائط التحميل المخصصة.',
            en: 'High-frequency counters, audio visualizers, and complex custom painters.',
          ),
          LocalText(
            ar: 'التقاط لقطة شاشة برمجية (Screenshot) لجزء محدد عبر `RenderRepaintBoundary.toImage()`.',
            en: 'Capturing programmatic screenshots via `RenderRepaintBoundary.toImage()`.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'غلّف العنصر دائم الحركة بـ `RepaintBoundary`.',
            en: 'Wrap the constantly animated widget with `RepaintBoundary`.',
          ),
          LocalText(
            ar: 'في الـ `CustomPainter`، تحقق من دالة `shouldRepaint` واجعلها تعيد `false` إذا لم تتغير البيانات.',
            en: 'In `CustomPainter`, ensure `shouldRepaint` returns `false` when data is unchanged.',
          ),
        ],
        code:
            '// 1. عزل الأنيميشن السريع في طبقة رسم منفصلة\n'
            'RepaintBoundary(\n'
            '  child: AnimatedBuilder(\n'
            '    animation: _controller,\n'
            '    builder: (context, child) => CustomPaint(\n'
            '      size: const Size(120, 120),\n'
            '      painter: RadarWavePainter(progress: _controller.value),\n'
            '    ),\n'
            '  ),\n'
            ');\n\n'
            '// 2. تطبيق CustomPainter مع تحسين shouldRepaint\n'
            'class RadarWavePainter extends CustomPainter {\n'
            '  final double progress;\n'
            '  RadarWavePainter({required this.progress});\n\n'
            '  @override\n'
            '  void paint(Canvas canvas, Size size) {\n'
            '    final paint = Paint()..color = Colors.cyan.withValues(alpha: 1.0 - progress);\n'
            '    canvas.drawCircle(Offset(size.width / 2, size.height / 2), size.width * progress, paint);\n'
            '  }\n\n'
            '  @override\n'
            '  bool shouldRepaint(covariant RadarWavePainter oldDelegate) => oldDelegate.progress != progress;\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'إرجاع `true` دائماً في `shouldRepaint` مما يهدر طاقة المعالج وبطارية الجهاز.',
            en: 'Always returning `true` from `shouldRepaint`, draining battery and GPU cycles.',
          ),
          LocalText(
            ar: 'تغليف كل ويدجت بسيط بـ RepaintBoundary مما يرفع استهلاك الذاكرة (Layer Overhead).',
            en: 'Overusing RepaintBoundary on tiny static widgets, increasing memory overhead.',
          ),
        ],
      ),
    ],
  ),

  // ===========================================================================
  // LEVEL 3: Clean Architecture & State Management
  // ===========================================================================
  CurriculumLevel(
    number: 3,
    title: LocalText(
      ar: 'المعمارية النظيفة وإدارة الحالة المتقدمة',
      en: 'Clean Architecture & Enterprise State Management',
    ),
    subtitle: LocalText(
      ar: 'بناء تطبيقات قابلة للتوسع والصيانة بـ Clean Architecture و Bloc/Cubit و Either.',
      en: 'Scalable production architectures with Clean Architecture, Bloc/Cubit, and Either pattern.',
    ),
    icon: Icons.shield_rounded,
    color: Color(0xFF10B981),
    topics: [
      CurriculumTopic(
        title: LocalText(
          ar: 'Clean Architecture: تقسيم الطبقات والمسؤوليات',
          en: 'Clean Architecture Layers & Contracts',
        ),
        summary: LocalText(
          ar: 'فصل التطبيق إلى 3 طبقات مستقلة: Domain (القلب)، Data (المصادر)، و Presentation (الواجهة).',
          en: 'Deconstruct apps into 3 decoupled layers: Domain (Core Rules), Data (Sources), and Presentation (UI).',
        ),
        explain: LocalText(
          ar: 'تعتمد Clean Architecture على مبدأ انعكاس التبعية (Dependency Inversion). طبقة الـ Domain نقية تماماً ولا تعرف شيئاً عن Flutter أو Dio أو SQLite. طبقة الـ Data تنفذ العقود (Repository Contracts) وتتعامل مع APIs، وطبقة الـ Presentation تتصل بالـ Cubit/Bloc لعرض البيانات.',
          en: 'Clean Architecture enforces Dependency Inversion. Domain holds pure business rules with zero framework dependencies. Data implements Repository interfaces and communicates with APIs/databases. Presentation listens to state managers.',
        ),
        whenToUse: [
          LocalText(
            ar: 'في التطبيقات المتوسطة والكبيرة أو التي يعمل عليها فريق تطوير متكامل.',
            en: 'In mid-to-large enterprise apps and multi-developer engineering teams.',
          ),
          LocalText(
            ar: 'عندما تحتاج لإجراء Unit Tests شاملة وسريعة دون تشغيل محاكي الجهاز.',
            en: 'When comprehensive, fast unit testing is required without device emulators.',
          ),
        ],
        steps: [
          LocalText(
            ar: '1. أنشئ الـ Entity والـ Repository Contract في طبقة `domain/`.',
            en: '1. Define pure Entities and Repository Contracts in `domain/`.',
          ),
          LocalText(
            ar: '2. أنشئ الـ DataSources والـ Model والـ Repository Implementation في `data/`.',
            en: '2. Implement DataSources, DTO Models, and Repositories in `data/`.',
          ),
          LocalText(
            ar: '3. أنشئ الـ Cubit أو الـ Bloc والـ UI Widgets في `presentation/`.',
            en: '3. Wire UI and State Managers in `presentation/`.',
          ),
        ],
        code:
            '// 1. DOMAIN: عقد نقي مستقل عن أي مكتبة خارجية\n'
            'abstract class AuthRepository {\n'
            '  Future<Either<Failure, UserProfile>> login(String email, String password);\n'
            '}\n\n'
            '// 2. DATA: تنفيذ العقد وتحويل الـ Exceptions إلى Failures\n'
            'class AuthRepositoryImpl implements AuthRepository {\n'
            '  final AuthRemoteDataSource remoteDataSource;\n'
            '  AuthRepositoryImpl({required this.remoteDataSource});\n\n'
            '  @override\n'
            '  Future<Either<Failure, UserProfile>> login(String email, String password) async {\n'
            '    try {\n'
            '      final userModel = await remoteDataSource.login(email, password);\n'
            '      return Right(userModel.toEntity());\n'
            '    } on ServerException catch (e) {\n'
            '      return Left(ServerFailure(message: e.message));\n'
            '    }\n'
            '  }\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استيراد حزم الـ UI مثل `material.dart` أو حزم الـ HTTP في طبقة الـ Domain.',
            en: 'Importing UI packages or network clients inside the pure Domain layer.',
          ),
          LocalText(
            ar: 'استخدام كائنات الـ DTO المباشرة القادمة من السيرفر كـ Entities في واجهة المستخدم.',
            en: 'Leaking backend DTO models directly into UI widgets without entity mapping.',
          ),
        ],
      ),
    ],
  ),

  // ===========================================================================
  // LEVEL 4: Networking, Offline-First & Caching
  // ===========================================================================
  CurriculumLevel(
    number: 4,
    title: LocalText(
      ar: 'الشبكات، التخزين المحلي والـ Offline-First',
      en: 'Networking, Offline-First & Caching Systems',
    ),
    subtitle: LocalText(
      ar: 'إتقان Dio، Interceptors، Token Refresh، وقواعد البيانات المحلية كـ Hive و Drift.',
      en: 'Mastering Dio, Interceptors, JWT Token Refresh, and offline databases like Hive and Drift.',
    ),
    icon: Icons.wifi_tethering_rounded,
    color: Color(0xFF8B5CF6),
    topics: [
      CurriculumTopic(
        title: LocalText(
          ar: 'Dio Interceptors وتجديد الـ JWT Token تلقائياً',
          en: 'Dio Interceptors & Automated JWT Token Refresh',
        ),
        summary: LocalText(
          ar: 'اعتراض الطلبات لإضافة Authorization Header، وتجديد الـ Token المنتهي وإعادة المحاولة بسلاسة.',
          en: 'Intercept HTTP requests to inject auth headers, refresh expired JWTs on 401, and replay requests.',
        ),
        explain: LocalText(
          ar: 'الـ Interceptors في Dio تعمل كوسيط (Middleware) بين تطبيقك والخادم. عند انتهاء صلاحية الـ Access Token وعودة خطأ 401، يقوم الـ Interceptor بتعليق الطلبات، طلب Token جديد عبر Refresh Token، ثم إعادة إرسال الطلب الأصلي دون أن يشعر المستخدم.',
          en: 'Dio Interceptors act as request/response middleware. Upon encountering a 401 error, the interceptor pauses the queue, fetches a fresh token using the refresh token, and replays failed requests transparently.',
        ),
        whenToUse: [
          LocalText(
            ar: 'في أي تطبيق يحتوي على نظام مصادقة JWT لمنع تسجيل خروج المستخدم المفاجئ.',
            en: 'In every production app with JWT auth to prevent unexpected user session logouts.',
          ),
          LocalText(
            ar: 'تسجيل السجلات (Logging) ومعالجة أخطاء الشبكة مركّزياً.',
            en: 'Centralized network logging, error formatting, and analytics telemetry.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'أنشئ كلاس يرث من `QueuedInterceptor` لمنع تكرار طلب الـ Token في نفس اللحظة.',
            en: 'Extend `QueuedInterceptor` to handle concurrent expired requests safely.',
          ),
          LocalText(
            ar: 'في دالة `onError`، تحقق من `err.response?.statusCode == 401`.',
            en: 'In `onError`, check for 401 Unauthorized status.',
          ),
          LocalText(
            ar: 'اطلب Token جديد وقم بتحديث `handler.resolve(await dio.fetch(err.requestOptions))`.',
            en: 'Fetch new token, update request header, and replay with `handler.resolve`.',
          ),
        ],
        code:
            'class AuthInterceptor extends QueuedInterceptor {\n'
            '  final Dio dio;\n'
            '  AuthInterceptor({required this.dio});\n\n'
            '  @override\n'
            '  void onRequest(RequestOptions options, RequestInterceptorHandler handler) async {\n'
            '    final token = await SecureStorageService.getAccessToken();\n'
            '    if (token != null) {\n'
            '      options.headers["Authorization"] = "Bearer \$token";\n'
            '    }\n'
            '    handler.next(options);\n'
            '  }\n\n'
            '  @override\n'
            '  void onError(DioException err, ErrorInterceptorHandler handler) async {\n'
            '    if (err.response?.statusCode == 401) {\n'
            '      final newToken = await refreshAccessToken();\n'
            '      if (newToken != null) {\n'
            '        final retryRequest = await dio.request(\n'
            '          err.requestOptions.path,\n'
            '          options: Options(\n'
            '            method: err.requestOptions.method,\n'
            '            headers: err.requestOptions.headers..["Authorization"] = "Bearer \$newToken",\n'
            '          ),\n'
            '          data: err.requestOptions.data,\n'
            '        );\n'
            '        return handler.resolve(retryRequest);\n'
            '      }\n'
            '    }\n'
            '    handler.next(err);\n'
            '  }\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استخدام `Interceptor` عادي بدلاً من `QueuedInterceptor` مما يسبب إرسال طلبات Refresh متعددة.',
            en: 'Using regular Interceptor instead of QueuedInterceptor, triggering race conditions.',
          ),
          LocalText(
            ar: 'تخزين الـ Tokens في SharedPreferences غير المشفر بدلاً من FlutterSecureStorage.',
            en: 'Storing authentication tokens in unencrypted plain SharedPreferences.',
          ),
        ],
      ),
    ],
  ),

  // ===========================================================================
  // LEVEL 5: Security, Performance & Concurrency
  // ===========================================================================
  CurriculumLevel(
    number: 5,
    title: LocalText(
      ar: 'الأمان المتقدم، التوازي والـ Isolates',
      en: 'Security, Concurrency & High Performance',
    ),
    subtitle: LocalText(
      ar: 'تطبيق SSL Pinning، التشفير، وحسابات الـ Background Isolates الضخمة.',
      en: 'Implementing SSL Pinning, Biometrics, Obfuscation, and Worker Isolates.',
    ),
    icon: Icons.lock_person_rounded,
    color: Color(0xFFEC4899),
    topics: [
      CurriculumTopic(
        title: LocalText(
          ar: 'حماية الاتصال بالـ SSL Pinning',
          en: 'SSL/TLS Certificate Pinning',
        ),
        summary: LocalText(
          ar: 'منع هجمات Man-In-The-Middle (MITM) واعتراض البيانات عبر فحص بصمة شهادة السيرفر.',
          en: 'Prevent Man-In-The-Middle proxy inspection by enforcing server SHA-256 fingerprint matching.',
        ),
        explain: LocalText(
          ar: 'الـ SSL Pinning يمنع المهاجمين وبرامج التنصت (مثل Charles Proxy أو Proxyman) من اعتراض الترافيك بإنشاء شهادات وهمية على الجهاز. يتحقق التطبيق برمجياً من صحة الـ SHA-256 Fingerprint لشهادة الخادم قبل إرسال أي بيانات حساسة.',
          en: 'SSL Pinning ensures the client only trusts a predefined server certificate fingerprint, neutralizing MITM attacks and unauthorized SSL proxy sniffing.',
        ),
        whenToUse: [
          LocalText(
            ar: 'في التطبيقات المالية، البنوك، والمحافظ الإلكترونية وتطبيقات الدفع.',
            en: 'In banking, fintech, wallets, healthcare, and payment applications.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخرج بصمة الـ SHA-256 لشهادة الخادم (Public Key Hash).',
            en: 'Extract the SHA-256 Public Key Hash from your server certificate.',
          ),
          LocalText(
            ar: 'قم بتهيئة الـ `HttpClient` أو `Dio` للتحقق من تطابق البصمة قبل فتح أي اتصال.',
            en: 'Configure `SecurityContext` or `Dio` adapter to validate certificate fingerprints.',
          ),
        ],
        code:
            '// تطبيق SSL Pinning عبر تخصيص HttpClientAdapter في Dio\n'
            'Dio createPinnedDioClient() {\n'
            '  final dio = Dio();\n'
            '  const serverFingerprint = "1A2B3C4D5E6F..."; // SHA-256 Fingerprint\n\n'
            '  (dio.httpClientAdapter as IOHttpClientAdapter).createHttpClient = () {\n'
            '    final client = HttpClient();\n'
            '    client.badCertificateCallback = (X509Certificate cert, String host, int port) {\n'
            '      // التحقق من أن بصمة الشهادة مطابقة للبصمة المحفوظة في التطبيق\n'
            '      final certFingerprint = sha256.convert(cert.der).toString();\n'
            '      return certFingerprint == serverFingerprint;\n'
            '    };\n'
            '    return client;\n'
            '  };\n'
            '  return dio;\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'إرجاع `true` في `badCertificateCallback` في بيئة الإنتاج مما يعطل حماية SSL بالكامل!',
            en: 'Returning `true` unconditionally in `badCertificateCallback` in production.',
          ),
          LocalText(
            ar: 'نسيان تحديث البصمة في التطبيق قبل انتهاء صلاحية شهادة الخادم.',
            en: 'Forgetting to update pinned fingerprints before the server certificate renews.',
          ),
        ],
      ),
    ],
  ),

  // ===========================================================================
  // LEVEL 6: Testing, CI/CD & Deployment
  // ===========================================================================
  CurriculumLevel(
    number: 6,
    title: LocalText(
      ar: 'الاختبارات، CI/CD والنشر على المتاجر',
      en: 'Testing, CI/CD & App Store Publishing',
    ),
    subtitle: LocalText(
      ar: 'دليل شامل لرفع التطبيقات على Google Play Console و Apple App Store وأتمتة النشر.',
      en: 'Complete guide for Google Play, Apple App Store, Fastlane, and automated CI/CD pipelines.',
    ),
    icon: Icons.rocket_launch_rounded,
    color: Color(0xFFF59E0B),
    topics: [
      CurriculumTopic(
        title: LocalText(
          ar: 'نشر التطبيق على Google Play Console',
          en: 'Google Play Store Release & Keystore Signing',
        ),
        summary: LocalText(
          ar: 'إنشاء مفتاح التوقيع (Upload Key)، إعداد gradle، وتوليد حزمة App Bundle (.aab).',
          en: 'Generate Keystores, configure signing configs in gradle, and build optimized .aab bundles.',
        ),
        explain: LocalText(
          ar: 'نشر تطبيق Android يتطلب توقيع الحزمة بمفتاح مشفر خاص (Keystore)، وتوليد حزمة Android App Bundle (.aab) التي تسمح لـ Google Play بتقديم نسخ مخصصة لكل جهاز مع تقليص حجم التحميل بنسبة تصل إلى 50%.',
          en: 'Publishing to Google Play requires creating a secure upload keystore and generating an Android App Bundle (.aab), allowing Google Play to optimize APK sizes for end devices.',
        ),
        whenToUse: [
          LocalText(
            ar: 'عند تجهيز النسخة النهائية للنشر (Production Release).',
            en: 'When preparing final production releases for Google Play Store review.',
          ),
        ],
        steps: [
          LocalText(
            ar: '1. ولد مفتاح التوقيع عبر أداة `keytool` واحفظه بأمان.',
            en: '1. Generate signing keystore using `keytool` and store it securely.',
          ),
          LocalText(
            ar: '2. أنشئ ملف `android/key.properties` وضعه في الـ `.gitignore`.',
            en: '2. Create `android/key.properties` and add it to `.gitignore`.',
          ),
          LocalText(
            ar: '3. شغّل أمر البناء النهائي: `flutter build appbundle --release --obfuscate --split-debug-info=symbols/`.',
            en: '3. Build optimized release bundle: `flutter build appbundle --release --obfuscate --split-debug-info=symbols/`.',
          ),
        ],
        code:
            '# 1. أمر توليد الـ Keystore عبر التيرمينال:\n'
            'keytool -genkey -v -keystore upload-keystore.jks \\\n'
            '  -storetype JKS -keyalg RSA -keysize 2048 -validity 10000 \\\n'
            '  -alias upload\n\n'
            '# 2. إعداد android/key.properties:\n'
            'storePassword=your_secret_password\n'
            'keyPassword=your_secret_password\n'
            'keyAlias=upload\n'
            'storeFile=../upload-keystore.jks\n\n'
            '# 3. أمر البناء للإنتاج مع تشفير الكود (Obfuscation):\n'
            'flutter build appbundle --release --obfuscate --split-debug-info=./build/symbols',
        commonMistakes: [
          LocalText(
            ar: 'رفع ملف الـ `upload-keystore.jks` أو كلمات السر إلى GitHub العام!',
            en: 'Committing keystores or passwords directly into public GitHub repositories!',
          ),
          LocalText(
            ar: 'فقدان ملف الـ Keystore؛ فبدونه لن تتمكن من تحديث التطبيق على Google Play نهائياً.',
            en: 'Losing the keystore file, which permanently locks you out from updating the app.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(
          ar: 'نشر التطبيق على Apple App Store Connect',
          en: 'Apple App Store Connect & iOS Distribution',
        ),
        summary: LocalText(
          ar: 'إعداد الـ Certificates، الـ Provisioning Profiles، وبناء ملف الـ .ipa والرفع عبر Transporter.',
          en: 'Configure Distribution Certificates, Provisioning Profiles, and build signed .ipa archives.',
        ),
        explain: LocalText(
          ar: 'نشر تطبيقات iOS يتطلب حساب مطور آبل (Apple Developer Account)، إنشاء شهادة توزيع (Distribution Certificate)، وربط معرّف التطبيق (App ID) بـ Provisioning Profile للتوزيع على متجر التطبيقات وTestFlight.',
          en: 'Publishing on iOS requires an Apple Developer Account, a Distribution Certificate, App IDs, and Provisioning Profiles to submit builds to App Store Connect and TestFlight.',
        ),
        whenToUse: [
          LocalText(
            ar: 'لإطلاق النسخ التجريبية على TestFlight والنسخ النهائية على App Store.',
            en: 'When submitting builds to TestFlight for beta testing and App Store review.',
          ),
        ],
        steps: [
          LocalText(
            ar: '1. اضبط الـ Bundle Identifier في Xcode ليكون فريداً عالمياً (مثل `com.company.app`).',
            en: '1. Set a globally unique Bundle Identifier in Xcode.',
          ),
          LocalText(
            ar: '2. في حساب Apple Developer، اختر "Apple Distribution" و "App Store Profile".',
            en: '2. Create Apple Distribution certificate and App Store provisioning profile.',
          ),
          LocalText(
            ar: '3. ابنِ الأرشيف: `flutter build ipa --release --obfuscate --split-debug-info=symbols/`.',
            en: '3. Build the release archive: `flutter build ipa --release --obfuscate --split-debug-info=symbols/`.',
          ),
        ],
        code:
            '# 1. أمر بناء حزمة الـ iOS للإنتاج:\n'
            'flutter build ipa --release --obfuscate --split-debug-info=./build/ios_symbols\n\n'
            '# 2. الرفع المباشر عبر سطر الأوامر (باستخدام App-Specific Password):\n'
            'xcrun altool --upload-app -f build/ios/ipa/*.ipa \\\n'
            '  -t ios -u "your_apple_id@company.com" -p "xxxx-xxxx-xxxx-xxxx"',
        commonMistakes: [
          LocalText(
            ar: 'نسيان إضافة نصوص وصف الصلاحيات في `Info.plist` (مثل الكاميرا والموقع)، مما يسبب رفض المتجر الفوري.',
            en: 'Missing privacy permission descriptions in `Info.plist`, leading to immediate rejection.',
          ),
          LocalText(
            ar: 'رفع إصدار له نفس رقم الـ `build number` السابق على App Store Connect.',
            en: 'Uploading a build with the exact same build number as an existing upload.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(
          ar: 'أتمتة النشر عبر GitHub Actions & Fastlane',
          en: 'Automated CI/CD with GitHub Actions & Fastlane',
        ),
        summary: LocalText(
          ar: 'تشغيل الاختبارات وفحص الكود وبناء النسخ ورفعها للمتاجر تلقائياً عند دمج الكود في main.',
          en: 'Run tests, lint analysis, build releases, and deploy automatically upon merging to main.',
        ),
        explain: LocalText(
          ar: 'الـ CI/CD (التكامل والنشر المستمر) يرفع جودة البرمجيات إلى أعلى المستويات. بمجرد قيام المطور بعمل Push، يقوم الـ Pipeline بفحص الكود عبر `flutter analyze`، تشغيل الـ Unit Tests، وبناء النسخ وتوزيعها للمختبرين بدون أي تدخل يدوي.',
          en: 'CI/CD automation guarantees software quality. Whenever code is pushed, the pipeline executes `flutter analyze`, runs unit tests, and deploys release builds to testers automatically.',
        ),
        whenToUse: [
          LocalText(
            ar: 'في جميع المشاريع الاحترافية لضمان عدم وصول أي كود معطوب للإنتاج.',
            en: 'In all professional codebases to eliminate manual deployment errors.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'أنشئ ملف `.github/workflows/deploy.yml`.',
            en: 'Create `.github/workflows/deploy.yml`.',
          ),
          LocalText(
            ar: 'اضبط خطوات فحص الكود والـ Tests والبناء.',
            en: 'Configure linting, tests, and automated build steps.',
          ),
        ],
        code:
            '# .github/workflows/flutter_ci.yml\n'
            'name: Flutter CI/CD Pipeline\n\n'
            'on:\n'
            '  push:\n'
            '    branches: [ main ]\n'
            '  pull_request:\n'
            '    branches: [ main ]\n\n'
            'jobs:\n'
            '  test_and_build:\n'
            '    runs-on: ubuntu-latest\n'
            '    steps:\n'
            '      - uses: actions/checkout@v4\n'
            '      - uses: subosito/flutter-action@v2\n'
            '        with:\n'
            '          flutter-version: "3.24.x"\n'
            '          channel: "stable"\n'
            '      - name: Install Dependencies\n'
            '        run: flutter pub get\n'
            '      - name: Analyze Code\n'
            '        run: flutter analyze\n'
            '      - name: Run Unit Tests\n'
            '        run: flutter test --coverage\n'
            '      - name: Build Android Bundle\n'
            '        run: flutter build appbundle --release',
        commonMistakes: [
          LocalText(
            ar: 'تخطي تشغيل الاختبارات في الـ Pipeline قبل البناء النهائي.',
            en: 'Skipping test execution before triggering the production build step.',
          ),
        ],
      ),
    ],
  ),
];
