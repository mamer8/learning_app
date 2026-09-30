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
      ar: 'الدليل الشامل لكل أسرار Dart 3: من Null Safety والـ OOP الحديث، إلى Records و Pattern Matching والـ Streams والـ Event Loop.',
      en: 'The definitive guide to Dart 3: Null Safety, Class Modifiers, Records, Pattern Matching, Generics, Streams, and Event Loop.',
    ),
    icon: Icons.code_rounded,
    color: Color(0xFF14B8A6),
    topics: [
      // 1. Records & Pattern Matching
      CurriculumTopic(
        title: LocalText(
          ar: '1. Dart 3: Records & Pattern Matching',
          en: '1. Dart 3: Records & Pattern Matching',
        ),
        summary: LocalText(
          ar: 'إرجاع أكثر من قيمة بدون كلاسات وهمية، وتفكيك البيانات ومطابقة الأنماط في switch و if-case.',
          en: 'Return multiple values cleanly without tuple classes, and match patterns in switch/if-case.',
        ),
        explain: LocalText(
          ar: 'الـ Records هي نوع بيانات خفيف وسريع في Dart 3 يسمح لك بإرجاع وتجميع قيم متعددة بأنواع مختلفة بسهولة. ومع Pattern Matching و Switch Expressions، تقدر تفكك الكائنات والـ JSON وتفحص الحالات المعقدة بشروط حراسة (when guards) في سطر واحد بدون أكواد مكررة.',
          en: 'Records allow grouping heterogeneous values into lightweight value types. Combined with Pattern Matching, you can destructure objects, validate JSON, and handle API responses cleanly.',
        ),
        whenToUse: [
          LocalText(
            ar: 'إرجاع (بيانات + إجمالي الصفحات) من دالة pagination بدون عمل كلاس DTO إضافي.',
            en: 'Returning (data + totalPages) from pagination methods without creating a dedicated DTO.',
          ),
          LocalText(
            ar: 'تفكيك استجابات الـ JSON وفحص بنية البيانات المعقدة وحالات السيرفر في سطر واحد.',
            en: 'Destructuring JSON responses and validating complex shapes in a single line.',
          ),
          LocalText(
            ar: 'استبدال جمل الـ switch الطويلة القديمة بـ Switch Expressions مختصرة ومضمونة.',
            en: 'Replacing lengthy old switch statements with concise and safe switch expressions.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'عرّف الـ Record بين أقواس مثل: `(User user, int count)` أو مع أسماء: `({String name, int age})`.',
            en: 'Define record return types in parentheses: `(User user, int count)`.',
          ),
          LocalText(
            ar: 'فكك النتيجة فوراً في مكان الاستدعاء: `final (user, count) = fetchUserData();`.',
            en: 'Destructure immediately: `final (user, count) = fetchUserData();`.',
          ),
          LocalText(
            ar: 'استخدم Switch Expression مع شروط `when` لتصنيف الحالات بدقة تامة.',
            en: 'Use Switch Expressions with `when` guard clauses to classify state exhaustively.',
          ),
        ],
        code:
            '// 1. دالة ترجع Record بقيم مسماة (Named Records)\n'
            '({String token, int expiresIn, bool isNewUser}) loginUser() {\n'
            '  return (token: "eyJh...", expiresIn: 3600, isNewUser: false);\n'
            '}\n\n'
            '// 2. تفكيك الـ Record واستخدامه فوراً\n'
            'void handleLogin() {\n'
            '  final (:token, :expiresIn, :isNewUser) = loginUser();\n'
            '  print("Token: \$token, Expires: \$expiresIn, New: \$isNewUser");\n'
            '}\n\n'
            '// 3. مطابقة الأنماط (Pattern Matching) مع شروط الحراسة (Guard Clauses)\n'
            'String formatServerResponse(Map<String, dynamic> json) {\n'
            '  return switch (json) {\n'
            '    {"status": 200, "data": {"name": String name}} => "مرحباً: \$name",\n'
            '    {"status": 401} => "انتهت الجلسة، سجّل دخولك مجدداً",\n'
            '    {"status": int code, "message": String msg} when code >= 500 => "خطأ في السيرفر: \$msg",\n'
            '    {"status": int code, "message": String msg} => "تنبيه [\$code]: \$msg",\n'
            '    _ => "استجابة غير معروفة"\n'
            '  };\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'الإفراط في استخدام Records الموضعية بدون أسماء في طبقات الـ Domain بدلاً من الـ Entities.',
            en: 'Overusing positional records instead of domain Entities in Clean Architecture.',
          ),
          LocalText(
            ar: 'نسيان حالة الـ fallback `_ =>` عند التعامل مع بيانات ديناميكية قادمة من الـ API.',
            en: 'Omitting the default fallback `_ =>` in Switch Expressions with external data.',
          ),
        ],
      ),

      // 2. Sound Null Safety & Immutability
      CurriculumTopic(
        title: LocalText(
          ar: '2. Sound Null Safety والـ Immutability',
          en: '2. Sound Null Safety & Immutability',
        ),
        summary: LocalText(
          ar: 'التعامل الاحترافي مع القيم الفارغة وبناء كائنات ثابتة غير قابلة للتعديل بـ const و final و copyWith.',
          en: 'Production-level null safety patterns and immutable object architectures with const.',
        ),
        explain: LocalText(
          ar: 'نظام Sound Null Safety في Dart يضمن أثناء كتابة الكود والترجمة (Compile Time) عدم حدوث كراش NoSuchMethodError بسبب كائن فارغ null. والكائنات الثابتة (Immutable) تمنع التعديلات العشوائية في الذاكرة وتجعل إدارة الحالة (Bloc / Riverpod) تعمل بدقة وسرعة فائقة.',
          en: 'Sound Null Safety guarantees at compile-time that non-nullable references never cause runtime null pointer crashes. Immutable models prevent side effects when sharing data across state managers.',
        ),
        whenToUse: [
          LocalText(
            ar: 'في كل كلاسات الـ Data Models والـ Entities والـ States في التطبيق.',
            en: 'In every domain Entity and data Model across the codebase.',
          ),
          LocalText(
            ar: 'عند بناء كلاسات الحالة لـ Bloc أو Riverpod لضمان عدم تعديل الحالة السابقة مباشرة.',
            en: 'When constructing Bloc or Riverpod state classes to guarantee state immutability.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'اجعل جميع متغيرات الكائن `final` ووفر `const constructor`.',
            en: 'Make all fields `final` and supply a `const constructor`.',
          ),
          LocalText(
            ar: 'أضف دالة `copyWith` لتوليد نسخة جديدة معدلة من الكائن بأمان.',
            en: 'Implement a `copyWith` method to produce updated copies without mutation.',
          ),
          LocalText(
            ar: 'تجنب علامة التعجب `!` (Force Unwrap) واستخدم بدلاً منها `??` أو `?.` أو الـ if-check.',
            en: 'Avoid force-unwrap `!` and prefer null-coalescing `??` and safe calls `?.`.',
          ),
        ],
        code:
            '@immutable\n'
            'class UserProfile {\n'
            '  final String id;\n'
            '  final String name;\n'
            '  final String? bio; // حقل اختياري يقبل null\n'
            '  final int followersCount;\n\n'
            '  const UserProfile({\n'
            '    required this.id,\n'
            '    required this.name,\n'
            '    this.bio,\n'
            '    this.followersCount = 0,\n'
            '  });\n\n'
            '  // طريقة التحديث الآمنة بدون تعديل الكائن الأصلي\n'
            '  UserProfile copyWith({\n'
            '    String? name,\n'
            '    String? bio,\n'
            '    int? followersCount,\n'
            '  }) {\n'
            '    return UserProfile(\n'
            '      id: id,\n'
            '      name: name ?? this.name,\n'
            '      bio: bio ?? this.bio,\n'
            '      followersCount: followersCount ?? this.followersCount,\n'
            '    );\n'
            '  }\n'
            '}\n\n'
            '// استخدام الـ Null-aware Operators:\n'
            'void displayBio(UserProfile? user) {\n'
            '  final text = user?.bio?.trim() ?? "لا توجد نبذة شخصية";\n'
            '  print(text);\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استخدام عامل `!` (Force Unwrap) مع متغيرات السيرفر أو الـ SharedPreferences مما يسبب انهيار التطبيق فجأة.',
            en: 'Using the force-unwrap `!` operator on remote data, crashing the application.',
          ),
          LocalText(
            ar: 'تعديل متغيرات الكائن مباشرة (Mutation) مما يمنع أدوات إدارة الحالة من معرفة أن البيانات تغيرت.',
            en: 'Mutating model properties directly, preventing state managers from detecting updates.',
          ),
        ],
      ),

      // 3. Class Modifiers in Dart 3 & OOP
      CurriculumTopic(
        title: LocalText(
          ar: '3. محددات الكلاسات والـ OOP المتقدم في Dart 3',
          en: '3. Dart 3 Class Modifiers & Advanced OOP',
        ),
        summary: LocalText(
          ar: 'التحكم الكامل في الوراثة والتنفيذ باستخدام sealed, base, interface, final, و mixins.',
          en: 'Fine-grained inheritance and interface control using sealed, base, interface, final, and mixins.',
        ),
        explain: LocalText(
          ar: 'أضافت Dart 3 محددات دقيقة للكلاسات لتنظيم المشاريع الكبيرة: كلاسات `sealed` تمنع الوراثة من خارج الملف وتجبر الـ switch على تغطية جميع الحالات، كلاسات `interface` تجبرك على تطبيق العقد فقط دون وراثة الكود، والـ `mixin` يتيح مشاركة الوظائف عبر كلاسات متعددة بدون وراثة شجرية معقدة.',
          en: 'Dart 3 introduces expressive class modifiers: sealed classes enforce exhaustive checking, interface classes permit implementation only, and mixins allow modular code reuse across classes.',
        ),
        whenToUse: [
          LocalText(
            ar: 'بناء حالات الـ State والـ Events في BLoC / Cubit لضمان تغطية كل الحالات (Sealed Classes).',
            en: 'Building exhaustive Bloc/Cubit States and Events without missing any scenario.',
          ),
          LocalText(
            ar: 'كتابة حزم (Packages) ومكتبات مشتركة لحماية الكلاسات من التعديل غير المقصود.',
            en: 'Writing public packages and enforcing strict contract rules across modules.',
          ),
          LocalText(
            ar: 'إضافة وظائف متكررة (مثل الـ Logging أو الـ Validation) للكلاسات عبر Mixins.',
            en: 'Attaching reusable behaviors like logging or validation via Mixins.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم `sealed class` للكلاس الأب الحاوي لحالات محددة مسبقاً.',
            en: 'Use `sealed class` for a root hierarchy with known exhaustive subtypes.',
          ),
          LocalText(
            ar: 'استخدم `mixin` مع كلمة `on` لتحديد الكلاسات المسموح لها باستخدام هذا الـ Mixin.',
            en: 'Define `mixin` using `on` to constrain which base classes can apply it.',
          ),
        ],
        code:
            '// 1. Sealed Class لإدارة حالات الشاشة بشكل شامل ومضمون\n'
            'sealed class ResultState<T> {}\n'
            'class InitialState<T> extends ResultState<T> {}\n'
            'class LoadingState<T> extends ResultState<T> {}\n'
            'class SuccessState<T> extends ResultState<T> { final T data; SuccessState(this.data); }\n'
            'class ErrorState<T> extends ResultState<T> { final String message; ErrorState(this.message); }\n\n'
            '// المترجم يضمن أنك غطيت كل حالة بدون الحاجة لـ default case\n'
            'String renderUi(ResultState<String> state) {\n'
            '  return switch (state) {\n'
            '    InitialState() => "اضغط للبدء",\n'
            '    LoadingState() => "جاري التحميل...",\n'
            '    SuccessState(:final data) => "النتيجة: \$data",\n'
            '    ErrorState(:final message) => "حدث خطأ: \$message",\n'
            '  };\n'
            '}\n\n'
            '// 2. Mixin لإضافة ميزة التسجيل وتتبع الأداء\n'
            'mixin AnalyticsTracker {\n'
            '  void logScreenView(String name) => print("📊 تم فتح الشاشة: \$name");\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'محاولة وراثة كلاس `sealed` من ملف خارجي مختلف (غير مسموح في Dart 3).',
            en: 'Attempting to extend a sealed class from another library/file.',
          ),
          LocalText(
            ar: 'استخدام `implements` مع كلاس عادي بدلاً من `interface class` أو `abstract class`.',
            en: 'Implementing concrete classes instead of using abstract interfaces.',
          ),
        ],
      ),

      // 4. Async: Futures, Streams & Generators
      CurriculumTopic(
        title: LocalText(
          ar: '4. البرمجة غير المتزامنة: Futures و Streams والـ Generators',
          en: '4. Asynchronous Dart: Futures, Streams & Generators',
        ),
        summary: LocalText(
          ar: 'كل ما تحتاجه للتعامل مع العمليات الزمنية: async/await، Future.wait، تدفقات Streams، ودوال yield.',
          en: 'Mastering async operations: async/await, Future.wait, StreamController, and yield generators.',
        ),
        explain: LocalText(
          ar: 'الـ `Future` يمثل قيمة واحدة ستصل في المستقبل (مثل طلب API). أما الـ `Stream` فيمثل تدفقاً مستمراً من القيم عبر الزمن (مثل الشات اللحظي أو حساسات GPS). وتتيح لك دوال `async*` و `yield` توليد تدفق بيانات لحظي خطوة بخطوة بكل سلاسة.',
          en: 'Futures handle single delayed results, while Streams emit continuous streams of data over time. Async generators (`async*` with `yield`) produce real-time data streams effortlessly.',
        ),
        whenToUse: [
          LocalText(
            ar: 'جلب بيانات متعددة بالتوازي في نفس الوقت عبر `Future.wait`.',
            en: 'Fetching multiple APIs in parallel using `Future.wait`.',
          ),
          LocalText(
            ar: 'الاستماع للبيانات اللحظية مثل Socket.io، Firebase Firestore، أو تغيرات الاتصال بالنت.',
            en: 'Listening to real-time events like WebSockets, Firebase, or network connectivity.',
          ),
          LocalText(
            ar: 'توليد عدادات تنازلية أو أشرطة تحميل تدريجية عبر `async*`.',
            en: 'Building countdown timers or progressive download streams using `async*`.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم `async`/`await` مع الـ `Future` وأحط العمليات بـ `try/catch`.',
            en: 'Use `async/await` with `Future` inside `try/catch` blocks.',
          ),
          LocalText(
            ar: 'استخدم `StreamController<T>.broadcast()` إذا كان هناك أكثر من مستمع للتدفق.',
            en: 'Use broadcast StreamControllers when multiple listeners subscribe to events.',
          ),
          LocalText(
            ar: 'لا تنس دائماً إغلاق التدفق في `dispose()` لمنع تسريب الذاكرة.',
            en: 'Always close StreamControllers in `dispose()` to prevent memory leaks.',
          ),
        ],
        code:
            '// 1. جلب بيانات متعددة في نفس الوقت بالتوازي (Parallel Execution)\n'
            'Future<({UserProfile user, List<String> orders})> fetchDashboardData() async {\n'
            '  final results = await Future.wait([\n'
            '    fetchUserProfileApi(), // Future 1\n'
            '    fetchUserOrdersApi(),  // Future 2\n'
            '  ]);\n'
            '  return (user: results[0] as UserProfile, orders: results[1] as List<String>);\n'
            '}\n\n'
            '// 2. دالة Generator تولد تدفق أرقام تنازلي لحظي (Stream Generator)\n'
            'Stream<int> countdownTimer(int start) async* {\n'
            '  for (int i = start; i >= 0; i--) {\n'
            '    await Future.delayed(const Duration(seconds: 1));\n'
            '    yield i; // بث القيمة الحالية للـ Stream فوراً\n'
            '  }\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استدعاء دالات الـ API المتعددة بـ `await` واحدة تلو الأخرى بشكل تسلسلي بدلاً من `Future.wait` المتوازي.',
            en: 'Awaiting independent API calls sequentially instead of concurrently via Future.wait.',
          ),
          LocalText(
            ar: 'نسيان عمل `cancel()` للـ `StreamSubscription` عند مغادرة الشاشة مما يسبب Memory Leaks.',
            en: 'Forgetting to cancel StreamSubscriptions on widget dispose, causing memory leaks.',
          ),
        ],
      ),

      // 5. Generics & Type System
      CurriculumTopic(
        title: LocalText(
          ar: '5. الدوال والكلاسات المعممة (Generics & Type System)',
          en: '5. Dart Generics & Advanced Type System',
        ),
        summary: LocalText(
          ar: 'كتابة كود مرن وقابل لإعادة الاستخدام مع أنواع غير محددة ومقيدة بـ Type Constraints.',
          en: 'Write flexible, reusable, and type-safe components using Generic Type constraints and bounds.',
        ),
        explain: LocalText(
          ar: 'تسمح لك الـ Generics (`<T>`) بكتابة كلاسات ودوال تعمل مع أي نوع بيانات مع الحفاظ على الأمان البرمجي الصارم (Type Safety). يمكنك وضع قيود مثل `<T extends BaseEntity>` لضمان أن النوع المرسل يمتلك دوال محددة كـ `toJson` أو `id`.',
          en: 'Generics let you write flexible components that work with any data type safely. Type bounds (`<T extends BaseEntity>`) ensure the generic type supports required interfaces.',
        ),
        whenToUse: [
          LocalText(
            ar: 'بناء كلاسات الاستجابة العامة للشبكة مثل `ApiResponse<T>` أو `PaginatedResult<T>`.',
            en: 'Building generic network wrappers like `ApiResponse<T>` and `PaginatedList<T>`.',
          ),
          LocalText(
            ar: 'بناء مخازن محلية عامة (Generic Cache / Local Database Repository).',
            en: 'Constructing generic local storage repositories and caching layers.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'عرّف الرمز العام بين أقواس زاوية: `class CacheRepository<T>`.',
            en: 'Declare the generic type parameter in angle brackets: `class CacheRepository<T>`.',
          ),
          LocalText(
            ar: 'ضع قيود على النوع عند الحاجة: `<T extends JsonSerializable>`.',
            en: 'Enforce type bounds when required: `<T extends JsonSerializable>`.',
          ),
        ],
        code:
            '// 1. كلاس استجابة شبكة عام ومرن\n'
            'class ApiResponse<T> {\n'
            '  final bool isSuccess;\n'
            '  final T? data;\n'
            '  final String? errorMessage;\n\n'
            '  const ApiResponse.success(this.data) : isSuccess = true, errorMessage = null;\n'
            '  const ApiResponse.error(this.errorMessage) : isSuccess = false, data = null;\n'
            '}\n\n'
            '// 2. دالة عامة لفلترة والبحث في أي قائمة بناءً على شرط مخصص\n'
            'List<T> filterItems<T>(List<T> list, bool Function(T item) predicate) {\n'
            '  return list.where(predicate).toList();\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استخدام `dynamic` بدلاً من `T` مما يلغي ميزات التحقق التلقائي من الأخطاء في Dart.',
            en: 'Using dynamic instead of generic T, losing all compile-time type safety benefits.',
          ),
          LocalText(
            ar: 'عمل `type cast` قسري عبر `as T` بدون فحص `is T` أولاً.',
            en: 'Force casting with `as T` without runtime verification with `is T`.',
          ),
        ],
      ),

      // 6. Extensions & Extension Types
      CurriculumTopic(
        title: LocalText(
          ar: '6. الامتدادات والأنواع الممتدة (Extensions & Extension Types)',
          en: '6. Extensions & Zero-Cost Extension Types',
        ),
        summary: LocalText(
          ar: 'إضافة وظائف جديدة للكلاسات الجاهزة، واستخدام Extension Types كأغلفة بدون استهلاك للذاكرة في Dart 3.',
          en: 'Extend existing classes with custom helpers and use Dart 3 Extension Types as zero-cost wrappers.',
        ),
        explain: LocalText(
          ar: 'تتيح لك `extension on` إضافة ميزات ودوال واختصارات لأي كلاس موجود (مثل `BuildContext` أو `String` أو `num`) بدون وراثة. وأضافت Dart 3 ميزة `extension type` كغلاف أمان برمجي للأنواع (مثل تمييز `UserId` عن `OrderId`) بدون استهلاك أي بايت إضافي في الرام (Zero-cost abstraction).',
          en: 'Extension methods add new methods and getters to existing classes. Dart 3 Extension Types provide zero-cost static type wrappers to prevent primitive obsession without runtime overhead.',
        ),
        whenToUse: [
          LocalText(
            ar: 'اختصارات المسافات والتحقق من النصوص وأبعاد الشاشة (`16.heightBox`, `context.width`).',
            en: 'Shorthand UI spacing, validation, and theme shortcuts (`16.heightBox`, `context.width`).',
          ),
          LocalText(
            ar: 'تمييز المعرفات الرقمية والنصوص الحساسة (مثل `UserId`, `OrderId`) لمنع تمريرها بالخطأ.',
            en: 'Creating type-safe IDs like `UserId(int)` to eliminate accidental parameter mix-ups.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'عرّف الامتداد: `extension ContextUtils on BuildContext { ... }`.',
            en: 'Define the extension: `extension ContextUtils on BuildContext { ... }`.',
          ),
          LocalText(
            ar: 'استخدم `extension type` لتغليف نوع بدائي بأمان: `extension type UserId(int id) { ... }`.',
            en: 'Use `extension type` for zero-cost primitive wrapping: `extension type UserId(int id)`.',
          ),
        ],
        code:
            '// 1. اختصارات عملية للواجهات على الأرقام والسياق\n'
            'extension SpacingUtils on num {\n'
            '  Widget get heightBox => SizedBox(height: toDouble());\n'
            '  Widget get widthBox => SizedBox(width: toDouble());\n'
            '}\n\n'
            'extension BuildContextUtils on BuildContext {\n'
            '  double get screenWidth => MediaQuery.sizeOf(this).width;\n'
            '  ThemeData get theme => Theme.of(this);\n'
            '}\n\n'
            '// 2. Extension Type في Dart 3 (أمان عالي بصفر استهلاك ذاكرة)\n'
            'extension type CustomerId(String id) {\n'
            '  bool get isValid => id.startsWith("CUST_");\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'كتابة منطق بيانات معقد (Business Logic) داخل الـ Extensions بدلاً من وضعه في الـ Services.',
            en: 'Placing heavy business logic inside UI extensions instead of dedicated services.',
          ),
          LocalText(
            ar: 'تسمية دوال الامتدادات بأسماء شائعة جداً مما يسبب تعارضاً مع مكتبات أخرى.',
            en: 'Using overly generic names for extensions, causing naming conflicts with libraries.',
          ),
        ],
      ),

      // 7. Collections & Functional Operators
      CurriculumTopic(
        title: LocalText(
          ar: '7. المصفوفات والعمليات الوظيفية (Collections & Functional Dart)',
          en: '7. Collections & Functional Programming in Dart',
        ),
        summary: LocalText(
          ar: 'احتراف التعامل مع Lists و Sets و Maps، وعوامل Collection-if و Collection-for و Spread Operators.',
          en: 'Mastering Lists, Sets, Maps, Collection-if, Collection-for, and functional chaining with fold/map/where.',
        ),
        explain: LocalText(
          ar: 'تحتوي لغة Dart على قدرات وظيفية فائقة للتعامل مع المجموعات. باستخدام Collection-if و Collection-for و Spread Operators (`...`)، يمكنك بناء واجهات وقوائم ديناميكية ومطورة داخل شجرة الـ Widgets مباشرة بدون متغيرات وسيطة.',
          en: 'Dart offers rich functional collection operators. Collection-if, collection-for, and spread operators enable expressive, declarative widget tree and list construction.',
        ),
        whenToUse: [
          LocalText(
            ar: 'إظهار أو إخفاء عناصر في شجرة الـ Widgets ديناميكياً بناءً على الصلاحيات أو الشروط.',
            en: 'Conditionally inserting widgets inside widget trees based on user roles.',
          ),
          LocalText(
            ar: 'تصفية وتجميع وتحويل قوائم البيانات من السيرفر (مثل حساب إجمالي السلة بـ `fold`).',
            en: 'Filtering and aggregating data lists (e.g., calculating shopping cart totals via `fold`).',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم `map` لتحويل العناصر، و `where` للفلترة، و `fold` لحساب مجموع أو تجميع البيانات.',
            en: 'Use `map` for transformations, `where` for filtering, and `fold` for aggregations.',
          ),
          LocalText(
            ar: 'استخدم `...[list]` لدمج قوائم متعددة، و `...?nullableList` للدمج الآمن من null.',
            en: 'Use spread `...` and null-aware spread `...?` to merge lists cleanly.',
          ),
        ],
        code:
            '// 1. حساب إجمالي سعر السلة باستخدام fold الوظيفية\n'
            'double calculateTotal(List<({String name, double price, int qty})> cart) {\n'
            '  return cart.fold(0.0, (sum, item) => sum + (item.price * item.qty));\n'
            '}\n\n'
            '// 2. بناء قائمة أزرار في الواجهة باستخدام Collection-if و Spread\n'
            'Widget buildActionButtons(bool isAdmin, List<Widget> extraActions) {\n'
            '  return Row(\n'
            '    children: [\n'
            '      const Text("لوحة التحكم"),\n'
            '      if (isAdmin) const Icon(Icons.admin_panel_settings_rounded),\n'
            '      ...extraActions, // دمج قائمة الأزرار الإضافية مباشرة\n'
            '    ],\n'
            '  );\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استخدام `forEach` لإرجاع قيم بدلاً من `map` أو `fold`.',
            en: 'Using `forEach` for data transformations instead of pure `map` or `fold`.',
          ),
          LocalText(
            ar: 'نسيان تحويل الـ Iterable إلى List عبر `.toList()` عند الحاجة لتعديل أو فهرسة العناصر.',
            en: 'Forgetting to call `.toList()` on lazy Iterables when indexed access is required.',
          ),
        ],
      ),

      // 8. Event Loop & Microtasks & Isolates Architecture
      CurriculumTopic(
        title: LocalText(
          ar: '8. معمارية الـ Event Loop و Microtasks والـ Isolates',
          en: '8. Event Loop, Microtasks & Isolates Architecture',
        ),
        summary: LocalText(
          ar: 'فهم كيف ينفذ محرك Dart المهام: طابور Microtask وطابور Event وكيف يعمل Isolate في مساحة ذاكرة مستقلة.',
          en: 'Deep dive into Dart Single-Threaded Event Loop, Microtask vs Event queue, and Isolates memory isolation.',
        ),
        explain: LocalText(
          ar: 'تعتمد لغة Dart على مسار أحادي (Single Threaded Event Loop) يدير طابورين: طابور Microtasks (أولوية قصوى) وطابور Events (لأحداث الـ UI والـ Timers و I/O). للعمليات الحسابية الضخمة (مثل ضغط الصور وتشفير الملفات)، نستخدم الـ `Isolate` الذي يمتلك مساحة رام وخيط معالجة مستقل تماماً لمنع تجميد الشاشة.',
          en: 'Dart runs on a single thread with an Event Loop managing two queues: Microtask Queue (highest priority) and Event Queue (UI, timers, I/O). For CPU-heavy tasks, Isolates execute in separate memory heaps without freezing the UI.',
        ),
        whenToUse: [
          LocalText(
            ar: 'عند تشفير وفك تشفير ملفات JSON ضخمة أو معالجة الصور والفيديوهات عبر `Isolate.run()`.',
            en: 'Parsing massive JSON payloads, heavy cryptography, or image processing via `Isolate.run()`.',
          ),
          LocalText(
            ar: 'تنفيذ مهمة فورية بأعلى أولوية قبل رسم الإطار القادم عبر `scheduleMicrotask`.',
            en: 'Executing urgent high-priority callbacks before the next frame via `scheduleMicrotask`.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'للعمليات القصيرة الثقيلة، استخدم دالة `Isolate.run(() => heavyCalculation())`.',
            en: 'For one-off heavy CPU tasks, use `Isolate.run(() => compute())`.',
          ),
          LocalText(
            ar: 'للعمليات المستمرة في الخلفية، استخدم `ReceivePort` و `SendPort` لتبادل الرسائل.',
            en: 'For long-running background workers, communicate via `ReceivePort` and `SendPort`.',
          ),
        ],
        code:
            '// 1. تشغيل عملية حسابية ثقيلة في Isolate منفصل لمنع تهنيج الشاشة\n'
            'Future<List<int>> processLargeDataInBackground(List<int> rawData) async {\n'
            '  return await Isolate.run(() {\n'
            '    // هذا الكود ينفذ في Thread منفصل وذاكرة مستقلة تماماً\n'
            '    rawData.sort();\n'
            '    return rawData.map((e) => e * 2).toList();\n'
            '  });\n'
            '}\n\n'
            '// 2. جدولة مهمة في طابور الـ Microtask (تنفذ قبل أي حدث UI قادم)\n'
            'void runHighPriorityTask() {\n'
            '  scheduleMicrotask(() {\n'
            '    print("⚡ تنفذ هذه المهمة فوراً بأعلى أولوية في الـ Event Loop");\n'
            '  });\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'تمرير كائنات مرتبطة بالـ UI (مثل BuildContext أو Widgets) إلى داخل الـ Isolate (غير مسموح).',
            en: 'Passing UI objects or BuildContext into Isolates across memory boundaries.',
          ),
          LocalText(
            ar: 'استخدام Isolates لعمليات الـ I/O البسيطة كالـ HTTP requests لأنها غير متزامنة بطبيعتها ولا تحتاج Isolate.',
            en: 'Spawning Isolates for simple I/O HTTP requests that already operate asynchronously.',
          ),
        ],
      ),

      // 9. Constructors Mastery
      CurriculumTopic(
        title: LocalText(
          ar: '9. احتراف أنواع البنائين (Factory, Const, Named & Redirecting)',
          en: '9. Dart Constructors Mastery: Factory, Const, Named & Redirecting',
        ),
        summary: LocalText(
          ar: 'إتقان كل أنواع البنائين: Factory للـ Caching والـ Singleton، و Const لتوفير الذاكرة، و Redirecting لتمرير القيم.',
          en: 'Master Factory constructors for singletons and caching, const constructors for memory reuse, and redirecting constructors.',
        ),
        explain: LocalText(
          ar: 'توفر لغة Dart نظام بنائين (Constructors) مرناً للغاية. الباني `const` يُنشئ كائناً ثابتاً يُعاد استخدامه في الذاكرة لجميع الشاشات. الباني `factory` لا يُجبرك على إنشاء كائن جديد في كل مرة، بل يتيح لك إرجاع نسخة قديمة مخبأة (Cache)، أو تطبيق نمط Singleton، أو إرجاع Subclass بناءً على شروط معينة.',
          en: 'Dart offers versatile constructor patterns. Const constructors canonicalize memory instances. Factory constructors allow returning cached instances, implementing singletons, or returning dynamic subclasses without direct instantiation.',
        ),
        whenToUse: [
          LocalText(
            ar: 'إنشاء كائن أحادي في كامل التطبيق (Singleton) مثل `ApiService.instance` أو `AuthManager()`.',
            en: 'Implementing application-wide Singletons like `ApiService.instance` or `ThemeManager()`.',
          ),
          LocalText(
            ar: 'توليد الكائنات من الـ JSON باستخدام Named Factory: `factory User.fromJson(Map json)`.',
            en: 'Parsing API responses using named factories: `factory User.fromJson(Map json)`.',
          ),
          LocalText(
            ar: 'تخزين الكائنات وإعادة استخدامها لتفادي إنشاء نسخ متطابقة (Instance Caching).',
            en: 'Caching and recycling instances based on unique keys.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم `factory ClassName()` عندما تحتاج منطقاً لاختيار الكائن المرجع.',
            en: 'Use `factory` when constructor logic determines instance creation.',
          ),
          LocalText(
            ar: 'استخدم `const ClassName(...)` مع الحقول الثابتة `final` لتحسين أداء شجرة الويدجت.',
            en: 'Use `const` constructors on immutable classes to optimize widget tree rebuilds.',
          ),
          LocalText(
            ar: 'استخدم Initializer List `: assert(...)` لفحص صحة البيانات قبل بناء الكائن.',
            en: 'Use initializer lists `: assert(...)` to validate preconditions before construction.',
          ),
        ],
        code:
            'class CacheService {\n'
            '  final String tag;\n'
            '  static final Map<String, CacheService> _cache = {};\n\n'
            '  // 1. Private Constructor\n'
            '  const CacheService._internal(this.tag);\n\n'
            '  // 2. Factory Constructor يقوم بتخزين الكائنات وإعادة استخدامها\n'
            '  factory CacheService(String tag) {\n'
            '    return _cache.putIfAbsent(tag, () => CacheService._internal(tag));\n'
            '  }\n\n'
            '  // 3. Named Redirecting Constructor\n'
            '  CacheService.defaultService() : this("DEFAULT_CACHE");\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'محاولة استخدام `this` داخل Initializer List قبل اكتمال بناء الكائن.',
            en: 'Attempting to access `this` inside the initializer list before instance creation.',
          ),
          LocalText(
            ar: 'نسيان كلمة `const` عند بناء الويدجتس الثابتة مما يفقد ميزة منع إعادة البناء (Rebuild Optimization).',
            en: 'Omitting `const` on static widgets, forcing unnecessary element tree rebuilds.',
          ),
        ],
      ),

      // 10. Equality, HashCode & Equatable Pattern
      CurriculumTopic(
        title: LocalText(
          ar: '10. مقارنة وتساوي الكائنات (Equality, HashCode & Equatable)',
          en: '10. Object Equality, HashCode & Identity',
        ),
        summary: LocalText(
          ar: 'فهم سر مقارنة المراجع vs القيم، وإعادة تعريف `==` و `hashCode` لضمان عمل Sets والـ Bloc بشكل صحيح.',
          en: 'Understand reference identity vs value equality, override `==` and `hashCode`, and master state comparison.',
        ),
        explain: LocalText(
          ar: 'بشكل افتراضي في Dart، يُقارن أي كائنين بمكان وجودهما في الذاكرة (Memory Identity عبر `identical`). يعني كائن `User(id: "1") == User(id: "1")` سيكون `false`! لكي يفهم Dart والـ Bloc أن الكائنين متطابقان لأن بياناتهما متطابقة، يجب إعادة تعريف مشغل `operator ==` وتوليد `hashCode` متطابق.',
          en: 'Dart compares objects by reference identity by default. Two instances with identical fields evaluate to false unless `operator ==` and `hashCode` are overridden to enforce value equality.',
        ),
        whenToUse: [
          LocalText(
            ar: 'في كلاسات الحالة لـ Bloc / Cubit / Riverpod لمنع إعادة بناء الشاشة إذا لم تتغير البيانات.',
            en: 'In Bloc/Cubit/Riverpod states to prevent redundant UI rebuilds on identical data.',
          ),
          LocalText(
            ar: 'عند استخدام الكائنات كمفاتيح في `Map<User, Data>` أو كعناصر في `Set<User>`.',
            en: 'When storing domain models inside HashMaps or HashSets.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'أعد تعريف دالة `operator ==` وتأكد من التحقق من النوع عبر `runtimeType` أو `identical`.',
            en: 'Override `operator ==` and verify type match and identical references.',
          ),
          LocalText(
            ar: 'أعد تعريف دالة `hashCode` لتجمع الـ hashCodes لجميع الحقول الأساسية عبر `Object.hash(...)`.',
            en: 'Override `hashCode` combining all fields via `Object.hash(field1, field2)`.',
          ),
        ],
        code:
            'class ProductItem {\n'
            '  final String id;\n'
            '  final String title;\n'
            '  final double price;\n\n'
            '  const ProductItem({required this.id, required this.title, required this.price});\n\n'
            '  // 1. مقارنة القيم بدلاً من مكان الذاكرة (Value Equality)\n'
            '  @override\n'
            '  bool operator ==(Object other) {\n'
            '    if (identical(this, other)) return true;\n'
            '    return other is ProductItem &&\n'
            '        other.id == id &&\n'
            '        other.title == title &&\n'
            '        other.price == price;\n'
            '  }\n\n'
            '  // 2. توليد HashCode متطابق للكائنات المتساوية\n'
            '  @override\n'
            '  int get hashCode => Object.hash(id, title, price);\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'إعادة تعريف `operator ==` بدون إعادة تعريف `hashCode`، مما يكسر عمل الـ Sets والـ Maps تماماً!',
            en: 'Overriding `operator ==` without `hashCode`, breaking HashSets and HashMaps.',
          ),
          LocalText(
            ar: 'تضمين حقول متغيرة (Mutable non-final fields) في حساب الـ `hashCode` مما يؤدي لضياع العنصر داخل الـ Set.',
            en: 'Using mutable fields in `hashCode` calculation, corrupting collection lookups.',
          ),
        ],
      ),

      // 11. Zones & Centralized Error Handling
      CurriculumTopic(
        title: LocalText(
          ar: '11. الـ Zones وإدارة الأخطاء الشاملة (runZonedGuarded)',
          en: '11. Dart Zones & Global Unhandled Error Trapping',
        ),
        summary: LocalText(
          ar: 'اصطياد أي خطأ غير متوقع في العمليات غير المتزامنة وإرسال تقارير الانهيار لـ Crashlytics.',
          en: 'Catch unhandled async exceptions globally, track zone-scoped values, and forward crashes to telemetry.',
        ),
        explain: LocalText(
          ar: 'الـ `Zone` في Dart تمثل سياق تنفيذ معزول للعمليات البرمجية (Execution Context). باستخدام `runZonedGuarded`، يمكنك إنشاء مصيدة مركزية تصطاد أي استثناء غير معالج (Unhandled Async Error) في التطبيق قبل أن يسبب كراش صامت، وإرساله فوراً لأدوات المراقبة كـ Firebase Crashlytics أو Sentry.',
          en: 'Zones create isolated execution contexts for async code. `runZonedGuarded` acts as an umbrella error boundary, trapping unhandled async crashes across all isolates and forwarding them to monitoring services.',
        ),
        whenToUse: [
          LocalText(
            ar: 'في نقطة انطلاق التطبيق `main()` لحماية التطبيق من أي كراش غير متوقع.',
            en: 'In `main()` entrypoint to trap all unhandled async errors in production.',
          ),
          LocalText(
            ar: 'تمرير متغيرات سياقية خاصة بالعملية (مثل RequestId أو TraceId) دون تمريرها في كل دالة.',
            en: 'Injecting ambient trace IDs or logging context without parameter drilling.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'غلّف دالة `runApp()` داخل `runZonedGuarded`.',
            en: 'Wrap `runApp()` call within `runZonedGuarded`.',
          ),
          LocalText(
            ar: 'في دالة `onError`، أرسل الخطأ والـ StackTrace لخدمة تسجيل الأخطاء.',
            en: 'In `onError` callback, log errors and forward stack traces to telemetry.',
          ),
        ],
        code:
            'void main() {\n'
            '  // تشغيل التطبيق داخل Zone آمنة لحماية الإنتاج\n'
            '  runZonedGuarded(\n'
            '    () async {\n'
            '      WidgetsFlutterBinding.ensureInitialized();\n'
            '      // ضبط معالج أخطاء فلاتر للواجهات\n'
            '      FlutterError.onError = (details) {\n'
            '        FlutterError.presentError(details);\n'
            '        logErrorToCrashlytics(details.exception, details.stack);\n'
            '      };\n'
            '      runApp(const MyApp());\n'
            '    },\n'
            '    (error, stackTrace) {\n'
            '      // اصطياد أي خطأ Async غير معالج على مستوى التطبيق بالكامل\n'
            '      print("🚨 خطأ غير متوقع تم التقاطه بالـ Zone: \$error");\n'
            '      logErrorToCrashlytics(error, stackTrace);\n'
            '    },\n'
            '  );\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استدعاء `WidgetsFlutterBinding.ensureInitialized()` خارج الـ Zone مما يسبب أخطاء في الـ Bindings.',
            en: 'Calling `WidgetsFlutterBinding.ensureInitialized()` outside the zone boundary.',
          ),
          LocalText(
            ar: 'كتم الأخطاء (Swallowing errors) في `onError` دون تسجيلها أو إبلاغ المطور.',
            en: 'Silently discarding errors without logging or reporting to analytics.',
          ),
        ],
      ),

      // 12. Dart FFI & Native C Interop
      CurriculumTopic(
        title: LocalText(
          ar: '12. الربط المباشر مع C/C++ بلغة Dart FFI (Native Interop)',
          en: '12. Dart FFI & Zero-Overhead C/C++ Interop',
        ),
        summary: LocalText(
          ar: 'استدعاء مكتبات C و Rust الأصلية بدون أي تأخير عبر Foreign Function Interface.',
          en: 'Directly invoke C and Rust native libraries with zero serialization overhead via Dart FFI.',
        ),
        explain: LocalText(
          ar: 'الـ FFI (Foreign Function Interface) يتيح لك استدعاء دوال ومكتبات مكتوبة بلغات مثل C أو C++ أو Rust مباشرة من كود Dart مع مشاركة مؤشرات الذاكرة (Pointers) وبدون استهلاك أي وقت في تشفير البيانات الثنائية كما في Platform Channels التقليدية.',
          en: 'Dart FFI allows Dart code to call native C/Rust APIs directly in-memory, bypassing platform channel binary serialization for ultra-high-performance workloads.',
        ),
        whenToUse: [
          LocalText(
            ar: 'معالجة الفيديو والصوت وضغط الصور بجودة عالية ومكتبات مثل OpenCV أو FFmpeg.',
            en: 'High-performance audio/video processing and computer vision with OpenCV or FFmpeg.',
          ),
          LocalText(
            ar: 'تشفير فائق السرعة أو محركات ألعاب ومحاكاة فيزيائية مبنية بـ C++.',
            en: 'High-speed native cryptography, ML inference, or custom game physics engines.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استورد مكتبة `dart:ffi` وحدد هياكل البيانات الأصلية بـ `Struct`.',
            en: 'Import `dart:ffi` and declare native C signatures and Structs.',
          ),
          LocalText(
            ar: 'افتح المكتبة عبر `DynamicLibrary.open(...)` وابحث عن عنوان الدالة.',
            en: 'Load shared native libraries via `DynamicLibrary.open(...)`.',
          ),
        ],
        code:
            'import "dart:ffi" as ffi;\n\n'
            '// 1. تعريف نوع الدالة في لغة C\n'
            'typedef NativeAddFunc = ffi.Int32 Function(ffi.Int32 a, ffi.Int32 b);\n\n'
            '// 2. تعريف نوع الدالة المقابل في Dart\n'
            'typedef DartAddFunc = int Function(int a, int b);\n\n'
            '// 3. فتح المكتبة وربط الدالة واستدعاؤها فوراً\n'
            'int addNumbersNative(int x, int y) {\n'
            '  final dylib = ffi.DynamicLibrary.process(); // أو open("libmath.so")\n'
            '  final DartAddFunc nativeAdd = dylib\n'
            '      .lookup<ffi.NativeFunction<NativeAddFunc>>("c_add")\n'
            '      .asFunction();\n'
            '  return nativeAdd(x, y);\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'نسيان تحرير الذاكرة المخصصة يدوياً عبر `calloc.free()` مما يسبب تسريب ذاكرة Native RAM.',
            en: 'Forgetting to free manually allocated native memory with `calloc.free()`.',
          ),
          LocalText(
            ar: 'عدم تطابق أنواع المتغيرات (مثل استخدام Int32 في C ومطابقته كـ Int64 في Dart).',
            en: 'Type mismatches between native C types and Dart FFI representations.',
          ),
        ],
      ),

      // 13. Annotations & Code Generation
      CurriculumTopic(
        title: LocalText(
          ar: '13. الملاحظات وتوليد الأكواد (Annotations & Code Generation)',
          en: '13. Dart Annotations & Automated Code Generation',
        ),
        summary: LocalText(
          ar: 'فهم كيف تعمل الملاحظات مثل @override و @immutable، وكيف تولد أدوات مثل build_runner و Freezed الأكواد.',
          en: 'Understand metadata annotations and learn how build_runner, Freezed, and JSON Serialization automate boilerplate.',
        ),
        explain: LocalText(
          ar: 'الـ Annotations في Dart هي بيانات وصفية (Metadata) تبدأ بعلامة `@` لتزويد المترجم وأدوات التحليل بمعلومات إضافية. تستخدم أدوات الـ Code Generation (مثل `build_runner`) هذه الملاحظات لقراءة الكلاسات وتوليد ملفات `.g.dart` أو `.freezed.dart` أوتوماتيكياً لتوفير مئات أسطر الـ Boilerplate.',
          en: 'Annotations attach metadata to declarations. Code generators (like build_runner, Freezed, and json_serializable) scan these annotations at build-time to emit robust boilerplate code automatically.',
        ),
        whenToUse: [
          LocalText(
            ar: 'توليد دوال `fromJson` و `toJson` المعقدة تلقائياً عبر `json_serializable`.',
            en: 'Automating JSON serialization and deserialization via `json_serializable`.',
          ),
          LocalText(
            ar: 'بناء نماذج بيانات غير قابلة للتعديل مع دعم الـ Unions و copyWith عبر `freezed`.',
            en: 'Generating immutable data classes and union types using `freezed`.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'أضف الملاحظة فوق الكلاس مثل: `@JsonSerializable()`.',
            en: 'Annotate target classes with annotations like `@JsonSerializable()`.',
          ),
          LocalText(
            ar: 'أضف سطر الـ part: `part "user.g.dart";`.',
            en: 'Include the generated part directive: `part "user.g.dart";`.',
          ),
          LocalText(
            ar: 'شغّل التوليد عبر التيرمينال: `dart run build_runner build --delete-conflicting-outputs`.',
            en: 'Execute code generation: `dart run build_runner build --delete-conflicting-outputs`.',
          ),
        ],
        code:
            '// تعريف Annotation مخصصة للاستخدام في تطبيقك\n'
            'class RouteInfo {\n'
            '  final String path;\n'
            '  final bool requiresAuth;\n'
            '  const RouteInfo({required this.path, this.requiresAuth = true});\n'
            '}\n\n'
            '// تطبيق الملاحظة على الشاشات\n'
            '@RouteInfo(path: "/profile", requiresAuth: true)\n'
            'class ProfileScreenState {\n'
            '  // ...\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'نسيان سطر `part "filename.g.dart";` مما يمنع الملف المولد من الوصول لمتغيرات الكلاس.',
            en: 'Omitting the `part "filename.g.dart";` directive in the source file.',
          ),
          LocalText(
            ar: 'تعديل الملفات المولدة `.g.dart` يدوياً لأنها تُحذف وتُبنى من جديد في كل تشغيل.',
            en: 'Manually editing generated `.g.dart` files, which get overwritten on rebuild.',
          ),
        ],
      ),

      // 14. Tree Shaking, Compilation & AOT vs JIT
      CurriculumTopic(
        title: LocalText(
          ar: '14. محرك الترجمة والـ Tree Shaking في Dart (AOT vs JIT)',
          en: '14. Dart Compilation Pipeline: AOT, JIT & Tree Shaking',
        ),
        summary: LocalText(
          ar: 'فهم سر سرعة Flutter: الـ JIT أثناء التطوير لـ Hot Reload، والـ AOT و Tree Shaking لإنتاج حزم مصغرة فائقة السرعة.',
          en: 'Discover how Dart JIT powers Hot Reload during development while AOT and Tree Shaking optimize release APK/IPA size and speed.',
        ),
        explain: LocalText(
          ar: 'تتميز Dart بدعم وضعي ترجمة فريدين: وضع JIT (Just-In-Time) للـ Debug مع الـ Hot Reload لتعديل الكود في أجزاء من الثانية، ووضع AOT (Ahead-Of-Time) للإنتاج لتحويل كودك إلى Machine Code مباشر للمعالج. وأثناء البناء، يقوم الـ Tree Shaking بحذف أي دالة أو أيقونة أو مكتبة غير مستخدمة لتقليص حجم التطبيق لأصغر حجم ممكن.',
          en: 'Dart combines JIT compilation for sub-second Hot Reload in development with AOT machine-code compilation and Tree Shaking in release mode to strip unused dead code and maximize runtime performance.',
        ),
        whenToUse: [
          LocalText(
            ar: 'فهم سبب منع الـ Reflection الديناميكية (`dart:mirrors`) في فلاتر (لأنها تعطل الـ Tree Shaking).',
            en: 'Understanding why runtime reflection is disabled to enable dead-code elimination.',
          ),
          LocalText(
            ar: 'تقليص حجم تطبيقك النهائي ليكون خفيفاً وسريع التحميل على أجهزة المستخدمين.',
            en: 'Optimizing final app bundle sizes by removing unused dependencies and fonts.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم دائماً `const` مع الكائنات الثابتة لتسمح للمترجم بحفظها مرة واحدة في الذاكرة.',
            en: 'Use `const` instances to enable compile-time canonicalization.',
          ),
          LocalText(
            ar: 'ابنِ التطبيق للإنتاج دائماً بـ `--release` لتفعيل الـ AOT والـ Tree Shaking بالكامل.',
            en: 'Always test production performance using `--release` mode.',
          ),
        ],
        code:
            '// 1. أمر بناء للإنتاج يفعل AOT + Tree Shaking + تشفير الرموز (Obfuscation)\n'
            '// flutter build appbundle --release --obfuscate --split-debug-info=./symbols\n\n'
            '// 2. التحقق برمجياً من وضع التشغيل (Debug vs Release vs Profile)\n'
            'void checkEnvironmentMode() {\n'
            '  assert(() {\n'
            '    print("🛠️ أنت الآن في وضع Debug (يعمل بمترجم JIT ويدعم Hot Reload)");\n'
            '    return true;\n'
            '  }());\n\n'
            '  if (const bool.fromEnvironment("dart.vm.product")) {\n'
            '    print("🚀 أنت في وضع الإنتاج Release (كود AOT مترجم ومضغوط بالكامل)");\n'
            '  }\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'قياس أداء وسرعة التطبيق ومعدل الـ FPS في وضع Debug بدلاً من وضع Profile أو Release.',
            en: 'Benchmarking performance and FPS in Debug JIT mode instead of Profile/Release.',
          ),
          LocalText(
            ar: 'استيراد مكتبات ضخمة واستخدام دالة واحدة منها بدون تفعيل إعدادات التحسين والـ Tree Shaking.',
            en: 'Adding bloated packages without verifying their tree-shaking dead code elimination.',
          ),
        ],
      ),

      // 15. Dart Macros & Static Metaprogramming
      CurriculumTopic(
        title: LocalText(
          ar: '15. تقنية Dart Macros والبرمجة التوليدية الفورية (Static Metaprogramming)',
          en: '15. Dart Macros & Static Metaprogramming',
        ),
        summary: LocalText(
          ar: 'مستقبل توليد الأكواد في Dart: توليد JSON Serialization و Data Classes وقت الترجمة بدون أداة build_runner أو ملفات .g.dart.',
          en: 'The future of Dart code generation: zero build_runner latency with direct in-compiler macro code augmentation.',
        ),
        explain: LocalText(
          ar: 'الـ Macros هي أحدث نقلة نوعية في لغة Dart للبرمجة التوليدية (Metaprogramming). بدلاً من الانتظار لدقائق لتشغيل أداة `build_runner` وتوليد ملفات وسيطة مثل `.g.dart` و `.freezed.dart`، يقوم مفسر ومترجم لغة Dart بتوليد وتوسيع الكود في الذاكرة لحظياً وقت كتابتك للكود (Compile-Time Augmentation).',
          en: 'Macros introduce compile-time metaprogramming directly into the Dart analyzer and compiler. Instead of external build_runner steps and disk file pollution, macros augment classes with serialization and boilerplate in-memory with zero build latency.',
        ),
        whenToUse: [
          LocalText(
            ar: 'إنشاء نماذج بيانات تتطلب تحويل JSON تلقائياً بأداء لحظي مع `@JsonCodable()`.',
            en: 'Creating self-serializing data models with instant IDE feedback using `@JsonCodable()`.',
          ),
          LocalText(
            ar: 'إلغاء الحاجة لملفات `.g.dart` المؤقتة التي تزحم مستودعات Git.',
            en: 'Eliminating bulky generated part files from version control and CI pipelines.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'أضف الـ Macro فوق الكلاس مباشرة مثل: `@JsonCodable()`.',
            en: 'Apply the macro annotation directly over the target class: `@JsonCodable()`.',
          ),
          LocalText(
            ar: 'استخدم دوال `fromJson` و `toJson` في كودك فوراً بدون الحاجة لكتابة `part` أو تشغيل build_runner.',
            en: 'Immediately call generated `fromJson` and `toJson` methods without part directives.',
          ),
        ],
        code:
            '// 1. استخدام Macro لتوليد دوال الـ JSON لحظياً بدون build_runner\n'
            '// ملاحظة: يتطلب تفعيل الـ experimental flag في Dart 3.5+\n'
            'import "package:json/json.dart";\n\n'
            '@JsonCodable()\n'
            'class UserAccount {\n'
            '  final String id;\n'
            '  final String username;\n'
            '  final String email;\n'
            '  final DateTime createdAt;\n\n'
            '  UserAccount({\n'
            '    required this.id,\n'
            '    required this.username,\n'
            '    required this.email,\n'
            '    required this.createdAt,\n'
            '  });\n'
            '}\n\n'
            '// الاستخدام الفوري المباشر:\n'
            'void testMacro() {\n'
            '  final jsonMap = {"id": "1", "username": "ahmed", "email": "a@test.com", "createdAt": "2026-01-01"};\n'
            '  // دالة fromJson تولدت تلقائياً في الذاكرة بواسطة الـ Macro!\n'
            '  final user = UserAccount.fromJson(jsonMap);\n'
            '  print(user.toJson());\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'البحث عن ملفات `.g.dart` على القرص الصلب؛ فالـ Macros تولد الأكواد في الذاكرة فقط (In-Memory).',
            en: 'Searching for physical `.g.dart` files on disk; macros augment code purely in memory.',
          ),
          LocalText(
            ar: 'محاولة استخدام الـ Macros في بيئات إنتاجية قديمة قبل اكتمال الاستقرار الرسمي للميزة.',
            en: 'Using early experimental macro flags in production pipelines without proper SDK locking.',
          ),
        ],
      ),

      // 16. Dart Web & WebAssembly (Wasm) Interop
      CurriculumTopic(
        title: LocalText(
          ar: '16. تجميع Dart لـ WebAssembly (WasmGC) والتخاطب مع JavaScript',
          en: '16. Dart Web & WebAssembly (Wasm) Interop with dart:js_interop',
        ),
        summary: LocalText(
          ar: 'تشغيل تطبيقات الويب بسرعة الكود الأصلي وتخطي بطء JavaScript عبر WasmGC والـ JS Interop الحديث.',
          en: 'Compile Dart web applications directly to native WebAssembly bytecode with high-speed JS Interop.',
        ),
        explain: LocalText(
          ar: 'تتيح لغة Dart ترجمة كود التطبيق مباشرة إلى ثنائيات WebAssembly (WasmGC) التي تُنفذ مباشرة في محرك المتصفح ككود آلة حقيقي مما يمنح التطبيق سرعة مضاعفة واستقرار 60fps كامل. كما تم استبدال مكتبة `dart:html` القديمة بحزمة `dart:js_interop` و `package:web` الحديثة لتبادل البيانات مع JS بدون أي تكلفة أداء.',
          en: 'Dart compiles directly into WebAssembly (WasmGC) binaries, executing in browser engines at near-native speed. Combined with `dart:js_interop` and `package:web`, you can seamlessly bind to browser APIs and JS libraries with zero overhead.',
        ),
        whenToUse: [
          LocalText(
            ar: 'بناء تطبيقات ويب فائقة السرعة، لوحات تحكم مالية، وتطبيقات رسم ومعالجة وسائط.',
            en: 'High-performance web apps, financial analytics dashboards, and interactive canvas tools.',
          ),
          LocalText(
            ar: 'استدعاء مكتبات JavaScript الأصلية (مثل Leaflet أو Chart.js أو Web Workers) بأمان.',
            en: 'Interoperating with native JS libraries (Leaflet, Stripe.js, Chart.js) safely.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم مكتبة `dart:js_interop` لتعريف الكائنات والدوال المشتركة مع JavaScript.',
            en: 'Import `dart:js_interop` and use extension types with `@JS()` annotations.',
          ),
          LocalText(
            ar: 'ابنِ التطبيق للويب بأمر: `flutter build web --wasm`.',
            en: 'Compile the application with: `flutter build web --wasm`.',
          ),
        ],
        code:
            'import "dart:js_interop";\n\n'
            '// 1. ربط دالة JavaScript عالمية مع كود Dart بأمان تام\n'
            '@JS("window.localStorage.setItem")\n'
            'external void setLocalItem(JSString key, JSString value);\n\n'
            '@JS("window.localStorage.getItem")\n'
            'external JSString? getLocalItem(JSString key);\n\n'
            '// 2. دالة Dart نظيفة تتعامل مع واجهة المتصفح\n'
            'void saveThemePreference(String themeName) {\n'
            '  setLocalItem(themeName.toJS, "dark".toJS);\n'
            '  final stored = getLocalItem(themeName.toJS)?.toDart;\n'
            '  print("Stored theme value: \$stored");\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استخدام مكتبة `dart:html` أو `dart:js` القديمة المهملة التي تمنع تجميع Wasm.',
            en: 'Using legacy `dart:html` or `dart:js` packages which break Wasm compilation.',
          ),
          LocalText(
            ar: 'نسيان ضبط ترويسات CORS (Cross-Origin-Opener-Policy و Embedder-Policy) على خادم استضافة الويب.',
            en: 'Forgetting to configure required CORS headers (COOP/COEP) on the web hosting server.',
          ),
        ],
      ),

      // 17. Advanced Streams: Buffering, Debouncing & Backpressure
      CurriculumTopic(
        title: LocalText(
          ar: '17. هندسة التدفقات المتقدمة وإدارة الضغط (Streams & Backpressure)',
          en: '17. Advanced Streams: Buffering, Debouncing & Backpressure',
        ),
        summary: LocalText(
          ar: 'السيطرة على تدفق البيانات السريعة بـ StreamTransformer، تفادي تجميد الواجهة بـ Debounce و Throttle، وإغلاق الموارد بأمان.',
          en: 'Master reactive stream pipelines, rate-limiting, buffering, and leak-free subscription lifecycles.',
        ),
        explain: LocalText(
          ar: 'في التطبيقات الحية (مثل أسعار البورصة، مستشعرات الحركة، أو البحث الفوري)، يمكن أن تصل مئات الأحداث في الثانية مما يغرق الـ Event Loop بالمهام ويجمد الشاشة. باستخدام `StreamTransformer` و `asyncMap` ومفاهيم التحكم في التدفق (Backpressure) كالـ Debouncing و Throttling، نضمن معالجة البيانات بمعدل آمن ومستقر.',
          en: 'In high-frequency apps (live chats, stock tickers, sensor events), unthrottled streams flood the Dart event loop. Applying custom StreamTransformers, Debounce, and Throttle operators ensures predictable UI performance and zero dropped frames.',
        ),
        whenToUse: [
          LocalText(
            ar: 'حقول البحث الفوري لتأخير استدعاء الـ API حتى يتوقف المستخدم عن الكتابة (Debounce).',
            en: 'Search fields to delay expensive API queries until the user stops typing.',
          ),
          LocalText(
            ar: 'تجميع أحداث الضغطات السريعة المتكررة (Throttling) لمنع إرسال طلبات متعددة للخادم.',
            en: 'Throttling button clicks and touch gestures to prevent duplicate network submissions.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'أنشئ `StreamController.broadcast()` أو استخدم `rxdart` للتحكم في الأحداث المتعددة.',
            en: 'Initialize a broadcast `StreamController` and configure reactive transformation operators.',
          ),
          LocalText(
            ar: 'احرص دائماً على تخزين الـ `StreamSubscription` وإلغائه في دالة `dispose()`.',
            en: 'Always retain the `StreamSubscription` and invoke `.cancel()` inside `dispose()`.',
          ),
        ],
        code:
            'import "dart:async";\n\n'
            '// 1. بناء StreamTransformer مخصص لعمل Debounce بدون مكاتب خارجية\n'
            'StreamTransformer<T, T> debounceTransformer<T>(Duration duration) {\n'
            '  Timer? timer;\n'
            '  return StreamTransformer<T, T>.fromHandlers(\n'
            '    handleData: (data, sink) {\n'
            '      timer?.cancel();\n'
            '      timer = Timer(duration, () => sink.add(data));\n'
            '    },\n'
            '    handleDone: (sink) {\n'
            '      timer?.cancel();\n'
            '      sink.close();\n'
            '    },\n'
            '  );\n'
            '}\n\n'
            '// 2. استخدام التدفق مع البحث الفوري\n'
            'void setupLiveSearch(Stream<String> searchStream) {\n'
            '  searchStream\n'
            '      .distinct() // تجاهل النصوص المتكررة\n'
            '      .transform(debounceTransformer(const Duration(milliseconds: 300)))\n'
            '      .listen((query) => print("🔎 جاري البحث عن: \$query"));\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'نسيان إغلاق `StreamController.close()` مما يسبب تسريب ذاكرة مستمر طوال تشغيل التطبيق.',
            en: 'Leaving unclosed StreamControllers, leading to lingering listeners and memory leaks.',
          ),
          LocalText(
            ar: 'الاستماع لـ Single-Subscription Stream أكثر من مرة واحدة مما يرمي `StateError`.',
            en: 'Listening to a single-subscription stream multiple times, triggering a StateError.',
          ),
        ],
      ),

      // 18. Memory Management, WeakReference & Finalizers
      CurriculumTopic(
        title: LocalText(
          ar: '18. إدارة الذاكرة، الـ Garbage Collection و WeakReference',
          en: '18. Dart Memory Architecture: Generational GC, WeakReference & Finalizer',
        ),
        summary: LocalText(
          ar: 'كيف يعمل مجمع القمامة (Generational GC) في Dart، وبناء كاش آمن بـ WeakReference وتنظيف الموارد بـ Finalizer.',
          en: 'Deep-dive into Dart Generational GC (Nursery vs Old Gen), leak prevention, WeakReferences, and Finalizers.',
        ),
        explain: LocalText(
          ar: 'يعتمد محرك Dart على مجمع قمامة جيلي (Generational Garbage Collector) مقسم إلى Nursery (للأشياء حديثة الإنشاء وسريعة الحذف) و Old Generation (للأشياء المستمرة). تتيح لك `WeakReference` الإشارة لكائن ضخم (مثل كاش الصور) دون منعه من الحذف إذا احتاج النظام للذاكرة، بينما تُنفذ `Finalizer` كود تنظيف الموارد الثقيلة بمجرد تدمير الكائن تلقائياً.',
          en: 'Dart utilizes a two-space generational garbage collector: Nursery for short-lived ephemeral allocations and Old Space for long-lived objects. `WeakReference` enables cache structures that allow GC reclamation on memory pressure, while `Finalizer` attaches cleanup callbacks upon object death.',
        ),
        whenToUse: [
          LocalText(
            ar: 'بناء نظام كاش للصور والبيانات الكبيرة في الذاكرة (Memory Cache) دون خطر حصول Crash.',
            en: 'Building in-memory image/data caches that yield memory automatically when needed.',
          ),
          LocalText(
            ar: 'تنظيف المؤشرات والمقابض الأصلية (Native Pointers) في مكتبات FFI و C++',
            en: 'Cleaning up native C/C++ memory pointers and file handles via Finalizers.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم `WeakReference(targetObject)` لتخزين كائن مؤقت لا يمنع عملية الـ GC.',
            en: 'Wrap targets with `WeakReference(targetObject)` to avoid retaining references.',
          ),
          LocalText(
            ar: 'أنشئ `Finalizer` وسجل الكائن مع القيمة المراد تنظيفها عند تدميره.',
            en: 'Instantiate a `Finalizer` and attach it to objects requiring automated teardown.',
          ),
        ],
        code:
            '// 1. نظام كاش ذكي لا يسبب Out-Of-Memory مطلقاً\n'
            'class SafeMemoryCache<K, V extends Object> {\n'
            '  final Map<K, WeakReference<V>> _cache = {};\n\n'
            '  void put(K key, V value) {\n'
            '    _cache[key] = WeakReference(value);\n'
            '  }\n\n'
            '  V? get(K key) {\n'
            '    final ref = _cache[key];\n'
            '    if (ref == null) return null;\n'
            '    final target = ref.target;\n'
            '    if (target == null) {\n'
            '      // قام الـ GC بتحرير الكائن عند الحاجة للذاكرة\n'
            '      _cache.remove(key);\n'
            '      return null;\n'
            '    }\n'
            '    return target;\n'
            '  }\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'حفظ مراجع الكائنات داخل Static List أو Long-lived Closures مما يسبب Retain Cycles مستمرة.',
            en: 'Capturing large object instances inside static lists or unclosed closures (Retain Cycles).',
          ),
          LocalText(
            ar: 'الاعتماد على Finalizer لتنفيذ عمليات هامة مثل حفظ ملفات؛ لأن توقيت الـ GC غير متزامن.',
            en: 'Relying on Finalizers for mission-critical operations due to non-deterministic GC timing.',
          ),
        ],
      ),

      // 19. TypedData, ByteData & Binary Protocols
      CurriculumTopic(
        title: LocalText(
          ar: '19. البيانات الثنائية والبروتوكولات فائقة السرعة (TypedData & ByteData)',
          en: '19. Binary Data & High-Speed Protocols: TypedData, ByteData & Endianness',
        ),
        summary: LocalText(
          ar: 'معالجة البايتات المباشرة بـ `Uint8List` و `ByteData` لنقل الملفات وفك حزم البلوتوث والشبكة بسرعة البرق.',
          en: 'Process raw binary bytes with zero boxing overhead using Uint8List, ByteData, and explicit Endianness.',
        ),
        explain: LocalText(
          ar: 'عند التعامل مع تشفير الوسائط، تسجيل الصوت، أو بروتوكولات البلوتوث (BLE) ومقابس الـ TCP/WebSocket، يكون استخدام نصوص JSON بطيئاً ومستهلكاً للمساحة. توفر حزمة `dart:typed_data` كائنات ثنائية ثابتة الحجم مثل `Uint8List` و `ByteData` للوصول المباشر للبايتات في الذاكرة دون أي عبء Boxed Object، مع دعم كامل للـ Big Endian و Little Endian.',
          en: 'For high-throughput I/O (audio buffers, Bluetooth Low Energy packets, raw WebSockets, and image processing), `dart:typed_data` provides unboxed memory arrays like `Uint8List` and `ByteData` with explicit Byte Order (Endianness) control.',
        ),
        whenToUse: [
          LocalText(
            ar: 'معالجة وتعديل الصور وملفات الصوت على مستوى البايتات بدون تأخير.',
            en: 'Low-latency byte manipulation for image cropping, audio DSP, and cryptographic hashing.',
          ),
          LocalText(
            ar: 'التواصل مع أجهزة إنترنت الأشياء (IoT) والبلوتوث التي ترسل حزم بيانات ثنائية مدمجة.',
            en: 'Interfacing with BLE sensors and embedded IoT microcontrollers sending binary packets.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استورد `dart:typed_data` واستخدم `Uint8List` للمصفوفات الثنائية.',
            en: 'Import `dart:typed_data` and use `Uint8List` for memory-dense arrays.',
          ),
          LocalText(
            ar: 'استخدم `ByteData.view()` لقراءة وكتابة الأرقام الصحيحة والعائمة بترتيب Endian محدد.',
            en: 'Use `ByteData.view()` to read and write integers and floats with explicit Endianness.',
          ),
        ],
        code:
            'import "dart:typed_data";\n\n'
            '// 1. قراءة ترويسة حزمة ثنائية من مقبس شبكة (Network Packet Header)\n'
            'class NetworkPacket {\n'
            '  final int packetId;   // 2 Bytes (Uint16)\n'
            '  final double speed;    // 4 Bytes (Float32)\n'
            '  final int timestamp;  // 8 Bytes (Uint64)\n\n'
            '  NetworkPacket({required this.packetId, required this.speed, required this.timestamp});\n\n'
            '  // فك التشفير فائق السرعة في الذاكرة مباشرة\n'
            '  factory NetworkPacket.fromBytes(Uint8List bytes) {\n'
            '    final byteData = ByteData.sublistView(bytes);\n'
            '    final id = byteData.getUint16(0, Endian.big);\n'
            '    final speed = byteData.getFloat32(2, Endian.big);\n'
            '    final time = byteData.getUint64(6, Endian.big);\n'
            '    return NetworkPacket(packetId: id, speed: speed, timestamp: time);\n'
            '  }\n\n'
            '  // تحويل الكائن إلى بايتات مضغوطة للإرسال عبر الشبكة\n'
            '  Uint8List toBytes() {\n'
            '    final data = ByteData(14);\n'
            '    data.setUint16(0, packetId, Endian.big);\n'
            '    data.setFloat32(2, speed, Endian.big);\n'
            '    data.setUint64(6, timestamp, Endian.big);\n'
            '    return data.buffer.asUint8List();\n'
            '  }\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استخدام `List<int>` العادية بدلاً من `Uint8List`، مما يرفع استهلاك الذاكرة بأكثر من 8 أضعاف!',
            en: 'Using generic `List<int>` instead of `Uint8List`, consuming 8x more memory due to object boxing.',
          ),
          LocalText(
            ar: 'تجاهل الـ Endianness (الخلط بين Big-Endian و Little-Endian) مما يؤدي لقراءة قيم تالفة تماماً.',
            en: 'Mismatching Endianness between sender and receiver, corrupting numerical values.',
          ),
        ],
      ),

      // 20. Operator Overloading & Callable Classes
      CurriculumTopic(
        title: LocalText(
          ar: '20. الكائنات القابلة للاستدعاء وتخصيص المعاملات (Operator Overloading & Callable Classes)',
          en: '20. Callable Classes & Custom Operator Overloading',
        ),
        summary: LocalText(
          ar: 'جعل الكلاس يُستدعى كدالة بـ `call()` (نمط UseCases في Clean Architecture) وتخصيص المعاملات مثل `+` و `==` و `[]`.',
          en: 'Transform classes into functions using `call()` and overload arithmetic/indexing operators like `+` and `[]`.',
        ),
        explain: LocalText(
          ar: 'في لغة Dart، يمكنك تحويل أي كلاس إلى كائن قابل للاستدعاء مباشرة كدالة بمجرد كتابة دالة باسم `call()`. هذا النمط هو الركيزة الأساسية لحالات الاستخدام (UseCases) في المعمارية النظيفة. كما تتيح لك Dart إعادة تعريف المعاملات (Operator Overloading) مثل جمع كائنات مالية بـ `+` أو مقارنتها بـ `>` أو الوصول بمؤشر المصفوفة `[]`.',
          en: 'Dart allows any class instance to be invoked like a first-class function by implementing the `call()` method. This is the cornerstone of Clean Architecture UseCases. You can also overload language operators (`+`, `-`, `>`, `[]`) to make domain models expressive and clean.',
        ),
        whenToUse: [
          LocalText(
            ar: 'كتابة طبقة الـ UseCases في Clean Architecture لاستدعاء `getUserUseCase(userId)` كدالة مباشرة.',
            en: 'Implementing Clean Architecture UseCases callable as single-purpose functions.',
          ),
          LocalText(
            ar: 'العمليات الحسابية والمالية والهندسية (مثل جمع المبالغ `Money(100) + Money(50)`).',
            en: 'Domain-specific math operations (Currency, Geometry Vectors, Matrix arithmetic).',
          ),
        ],
        steps: [
          LocalText(
            ar: 'أضف دالة `call(...)` داخل الكلاس مع النوع المرجوع المناسب.',
            en: 'Declare a `call(...)` method inside your class with parameters and return type.',
          ),
          LocalText(
            ar: 'أعد تعريف المعاملات عبر: `Money operator +(Money other) => ...`.',
            en: 'Overload operators using the `operator` keyword: `Type operator +(Type other)`.',
          ),
        ],
        code:
            '// 1. تخصيص المعاملات لكلاس مالي نقي (Domain Model)\n'
            'class Money {\n'
            '  final double amount;\n'
            '  final String currency;\n\n'
            '  const Money(this.amount, {this.currency = "USD"});\n\n'
            '  // إعادة تعريف معامل الجمع +\n'
            '  Money operator +(Money other) {\n'
            '    assert(currency == other.currency, "لا يمكن جمع عملتين مختلفتين!");\n'
            '    return Money(amount + other.amount, currency: currency);\n'
            '  }\n\n'
            '  // إعادة تعريف معامل المقارنة >\n'
            '  bool operator >(Money other) => amount > other.amount;\n\n'
            '  @override\n'
            '  String toString() => "\$amount \$currency";\n'
            '}\n\n'
            '// 2. كلاس UseCase قابل للاستدعاء مباشرة كدالة\n'
            'class CalculateCartTotalUseCase {\n'
            '  Money call(List<Money> items, {Money? discount}) {\n'
            '    var total = items.fold(const Money(0), (acc, item) => acc + item);\n'
            '    if (discount != null && total > discount) {\n'
            '      total = Money(total.amount - discount.amount, currency: total.currency);\n'
            '    }\n'
            '    return total;\n'
            '  }\n'
            '}\n\n'
            '// الاستخدام:\n'
            'void testCallable() {\n'
            '  final calculateTotal = CalculateCartTotalUseCase();\n'
            '  final cart = [const Money(120), const Money(80), const Money(50)];\n'
            '  final result = calculateTotal(cart, discount: const Money(30)); // استدعاء الكائن كدالة!\n'
            '  print("إجمالي السلة: \$result"); // 220.0 USD\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'إعادة تعريف المعاملات بمعانٍ غير منطقية أو تخالف التوقعات (مثل استخدام `+` لطرح القيم!).',
            en: 'Overloading operators with unintuitive side-effects that violate domain logic.',
          ),
          LocalText(
            ar: 'نسيان التحقق من شروط التوافق (مثل جمع عملات مختلفة دون تحويل أسعار الصرف).',
            en: 'Ignoring invariant validations such as currency mismatches before performing arithmetic.',
          ),
        ],
      ),
    ],
  ),

  // ===========================================================================
  // LEVEL 2: The Ultimate Flutter Widgets Encyclopedia
  // ===========================================================================
  CurriculumLevel(
    number: 2,
    title: LocalText(
      ar: 'موسوعة عناصر ويدجتس فلاتر الشاملة',
      en: 'The Ultimate Flutter Widgets Encyclopedia',
    ),
    subtitle: LocalText(
      ar: 'دليل كامل وشامل لكل ويدجتس Flutter بالكود: التخطيط، الصناديق، القوائم، النصوص، الإدخال، الأزرار، الحركة، والـ Builders.',
      en: 'Comprehensive reference for all Flutter widgets: Layout, Box Model, Lists, Typography, Forms, Gestures, Animations, and Reactive Builders.',
    ),
    icon: Icons.widgets_rounded,
    color: Color(0xFF38BDF8),
    topics: [
      // 1. Layout & Structural Widgets
      CurriculumTopic(
        title: LocalText(
          ar: '1. ويدجتس التخطيط والهيكلة (Layout & Structural Widgets)',
          en: '1. Layout & Structural Widgets (Scaffold, Stack, Column, Row & Wrap)',
        ),
        summary: LocalText(
          ar: 'بناء الهيكل العام للشاشة وترتيب العناصر رأسياً وأفقياً وفوق بعضها بـ Scaffold، Column، Row، Stack، Wrap، و Expanded.',
          en: 'Construct screen viewports and arrange widgets vertically, horizontally, or layered using Scaffold, Flex, Stack, and Wrap.',
        ),
        explain: LocalText(
          ar: 'ويدجتس التخطيط هي العمود الفقري لأي واجهة مستخدم. يمنحك `Scaffold` الهيكل المرجعي الأساسي (AppBar, Drawer, BottomNavigationBar, FloatingActionButton). بينما ترتب `Column` و `Row` العناصر في خط اتجاهي، وتسمح `Stack` برص العناصر فوق بعضها طبقات مع `Positioned`، وتعالج `Wrap` التفاف العناصر تلقائياً لسطر جديد عند امتلاء المساحة دون حدوث Overflow.',
          en: 'Layout widgets define the spatial geometry of Flutter UIs. `Scaffold` provides the Material layout skeleton. `Column` and `Row` align children linearly along main/cross axes, `Stack` layers widgets with `Positioned` coordinates, and `Wrap` flows children to the next line preventing layout overflow.',
        ),
        whenToUse: [
          LocalText(
            ar: 'استخدام `Scaffold` كأساس لكل شاشة جديدة في التطبيق.',
            en: 'Using `Scaffold` as the root scaffold for every top-level screen.',
          ),
          LocalText(
            ar: 'استخدام `Stack` مع `Positioned` لوضع شارات الإشعارات (Badges) أو الأزرار العائمة فوق الصور.',
            en: 'Layering badges or floating buttons over images with `Stack` and `Positioned`.',
          ),
          LocalText(
            ar: 'استخدام `Wrap` لعرض وسوم التصنيفات (Chips/Tags) متغيرة الطول.',
            en: 'Displaying dynamic-width category tags and chips using `Wrap`.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'ابدأ بـ `Scaffold` ثم اختر `SafeArea` لمنع تداخل المحتوى مع نوتش الشاشة وشريط الحالة.',
            en: 'Start with `Scaffold` and wrap body in `SafeArea` to respect notches.',
          ),
          LocalText(
            ar: 'استخدم `Expanded` أو `Flexible` داخل `Row/Column` لتوزيع المساحة المتبقية بنسب مرنة.',
            en: 'Distribute remaining space dynamically with `Expanded` and `Flexible`.',
          ),
        ],
        code:
            '// مثال يجمع الهيكلة، الطبقات، والالتفاف التلقائي\n'
            'Widget buildComprehensiveLayout(BuildContext context) {\n'
            '  return Scaffold(\n'
            '    appBar: AppBar(title: const Text("لوحة التحكم والهيكلة")),\n'
            '    body: SafeArea(\n'
            '      child: SingleChildScrollView(\n'
            '        padding: const EdgeInsets.all(16),\n'
            '        child: Column(\n'
            '          crossAxisAlignment: CrossAxisAlignment.start,\n'
            '          children: [\n'
            '            // 1. Stack مع Positioned لوضع شارة على صورة\n'
            '            Stack(\n'
            '              clipBehavior: Clip.none,\n'
            '              children: [\n'
            '                Container(\n'
            '                  height: 180,\n'
            '                  width: double.infinity,\n'
            '                  decoration: BoxDecoration(\n'
            '                    borderRadius: BorderRadius.circular(16),\n'
            '                    color: Colors.blueGrey.shade800,\n'
            '                  ),\n'
            '                  child: const Center(child: Icon(Icons.image, size: 64, color: Colors.white70)),\n'
            '                ),\n'
            '                Positioned(\n'
            '                  top: 12,\n'
            '                  right: 12,\n'
            '                  child: Container(\n'
            '                    padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),\n'
            '                    decoration: BoxDecoration(color: Colors.redAccent, borderRadius: BorderRadius.circular(20)),\n'
            '                    child: const Text("جديد 🔥", style: TextStyle(color: Colors.white, fontSize: 12, fontWeight: FontWeight.bold)),\n'
            '                  ),\n'
            '                ),\n'
            '              ],\n'
            '            ),\n'
            '            const SizedBox(height: 16),\n'
            '            // 2. Row مع Expanded و Spacer\n'
            '            Row(\n'
            '              children: [\n'
            '                const Icon(Icons.category, color: Colors.teal),\n'
            '                const SizedBox(width: 8),\n'
            '                const Text("التصنيفات المتاحة", style: TextStyle(fontWeight: FontWeight.bold)),\n'
            '                const Spacer(),\n'
            '                TextButton(onPressed: () {}, child: const Text("عرض الكل")),\n'
            '              ],\n'
            '            ),\n'
            '            // 3. Wrap للوسوم التفاعلية متغيرة الحجم\n'
            '            Wrap(\n'
            '              spacing: 8,\n'
            '              runSpacing: 8,\n'
            '              children: ["Flutter 3.24", "Dart 3", "Clean Arch", "Wasm", "Isolates", "Slivers"]\n'
            '                  .map((tag) => Chip(label: Text(tag)))\n'
            '                  .toList(),\n'
            '            ),\n'
            '          ],\n'
            '        ),\n'
            '      ),\n'
            '    ),\n'
            '  );\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'وضع `Expanded` خارج `Row` أو `Column` أو `Flex` مما يسبب كراش فوري (`ParentDataWidget Error`).',
            en: 'Placing `Expanded` outside a `Flex` container (Row/Column), throwing a ParentDataWidget error.',
          ),
          LocalText(
            ar: 'وضع عناصر غير محدودة الارتفاع داخل `Column` بداخل `SingleChildScrollView` دون ضبط قيود الأبعاد.',
            en: 'Unbounded vertical layouts inside scroll views triggering infinite height assertion crashes.',
          ),
        ],
      ),

      // 2. Box Model, Decoration & Glassmorphism
      CurriculumTopic(
        title: LocalText(
          ar: '2. ويدجتس الصناديق، الحواف والزجاج (Container, ClipRRect & BackdropFilter)',
          en: '2. Box Model, Borders & Glassmorphism (Container, SizedBox, ClipRRect & BackdropFilter)',
        ),
        summary: LocalText(
          ar: 'تزيين العناصر بالتدرجات والظلال، قص الحواف الدائرية، وصناعة تأثير الزجاج البلوري الفاخر (Glassmorphism).',
          en: 'Style widgets with gradients, box shadows, rounded clipping, and frosted glass blur effects.',
        ),
        explain: LocalText(
          ar: 'يجمع `Container` بين خصائص التوسيع والحشو `Padding` والحدود والتلوين `BoxDecoration`. مع `ClipRRect` يمكنك قص أي عنصر أو صورة بحواف دائرية ناعمة. وباستخدام `BackdropFilter` مع فلتر `ImageFilter.blur()` وتغليفه بـ `ClipRRect`، يمكنك بناء واجهات Glassmorphism عصرية وشفافة.',
          en: '`Container` serves as the primary canvas for padding, margins, and `BoxDecoration` styling. `ClipRRect` clips child widgets with rounded radii, while `BackdropFilter` applies Gaussian blurs for ultra-modern frosted glass aesthetics.',
        ),
        whenToUse: [
          LocalText(
            ar: 'بناء بطاقات أنيقة ذات تدرجات لونية وظلال عميقة (Elevation Shadows).',
            en: 'Building premium gradient cards with realistic drop shadows.',
          ),
          LocalText(
            ar: 'إنشاء أشرطة تنقل أو بطاقات حوارية بتأثير الزجاج البلوري الشفاف فوق الصور.',
            en: 'Crafting frosted-glass navigation bars or dialogue sheets over dynamic backgrounds.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم `SizedBox(width, height)` إذا كنت تحتاج فقط لتحديد أبعاد أو عمل تباعد فارغ لتوفير الأداء.',
            en: 'Prefer `SizedBox` over `Container` for simple sizing/spacing to save memory.',
          ),
          LocalText(
            ar: 'لتأثير الزجاج: غلف `BackdropFilter` داخل `ClipRRect` وضع تحته حاوية شبه شفافة `withValues(alpha: 0.2)`.',
            en: 'For Glassmorphism, clip a `BackdropFilter(filter: ImageFilter.blur(...))` over a translucent container.',
          ),
        ],
        code:
            'import "dart:ui";\n\n'
            '// صناعة كارت زجاجي بلوري فائق الفخامة (Glassmorphic Card)\n'
            'Widget buildGlassCard({\n'
            '  required Widget child,\n'
            '  double blur = 15.0,\n'
            '  double opacity = 0.15,\n'
            '}) {\n'
            '  return ClipRRect(\n'
            '    borderRadius: BorderRadius.circular(24),\n'
            '    child: BackdropFilter(\n'
            '      filter: ImageFilter.blur(sigmaX: blur, sigmaY: blur),\n'
            '      child: Container(\n'
            '        padding: const EdgeInsets.all(20),\n'
            '        decoration: BoxDecoration(\n'
            '          color: Colors.white.withValues(alpha: opacity),\n'
            '          borderRadius: BorderRadius.circular(24),\n'
            '          border: Border.all(\n'
            '            color: Colors.white.withValues(alpha: 0.25),\n'
            '            width: 1.5,\n'
            '          ),\n'
            '          boxShadow: [\n'
            '            BoxShadow(\n'
            '              color: Colors.black.withValues(alpha: 0.1),\n'
            '              blurRadius: 20,\n'
            '              spreadRadius: 2,\n'
            '            ),\n'
            '          ],\n'
            '        ),\n'
            '        child: child,\n'
            '      ),\n'
            '    ),\n'
            '  );\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'تحديد كل من `color` داخل `Container` و `color` داخل `BoxDecoration` معاً، مما يرمي استثناء في فلاتر.',
            en: 'Setting `color` on both `Container` and its `BoxDecoration`, throwing a runtime error.',
          ),
          LocalText(
            ar: 'نسيان تغليف `BackdropFilter` بـ `ClipRRect` مما يؤدي لتسرب تأثير الضبابية لكل الشاشة!',
            en: 'Omitting `ClipRRect` around `BackdropFilter`, causing the blur to bleed across the whole viewport.',
          ),
        ],
      ),

      // 3. Lists, Grids & Scrollables
      CurriculumTopic(
        title: LocalText(
          ar: '3. ويدجتس القوائم والشبكات والتمرير (ListView, GridView & PageView)',
          en: '3. Lists, Grids & Paging (ListView, GridView, PageView, Reorderable & Dismissible)',
        ),
        summary: LocalText(
          ar: 'عرض آلاف العناصر باستهلاك ذاكرة معدوم، سحب لحذف العناصر، السحب لإعادة الترتيب، وعمل سلايدر بـ PageView.',
          en: 'Render massive datasets lazily, swipe-to-dismiss items, drag-to-reorder lists, and build full-screen pagers.',
        ),
        explain: LocalText(
          ar: 'تعتمد `ListView.builder` و `GridView.builder` على مبدأ الـ Virtualization (Lazy Loading)؛ حيث تُنشئ الويدجتس المعروضة فقط على الشاشة وتُدمر ما يخرج من مساحة الرؤية لتوفير الذاكرة. ويوفر `PageView` إمكانية التقليب الأفقي بين الصفحات كالسلايدر، بينما يمنح `Dismissible` ميزة التمرير لحذف العنصر، و `ReorderableListView` لإعادة ترتيب العناصر بالسحب.',
          en: 'Flutter virtualization ensures high-speed 60/120fps scrolling by recycling render objects out of view. `PageView` handles snap-paging galleries, `Dismissible` handles swipe actions, and `ReorderableListView` enables interactive drag-and-drop sorting.',
        ),
        whenToUse: [
          LocalText(
            ar: 'عرض الخلاصات الإخبارية (Feeds) وسجلات العمليات الطويلة بكفاءة.',
            en: 'Rendering infinite scrolling feeds, transaction histories, and product catalogues.',
          ),
          LocalText(
            ar: 'شاشات الترحيب والـ Onboarding باستخدام `PageView`.',
            en: 'Creating onboarding walkthroughs and banner carousels with `PageView`.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم دائماً المُنشيء `.builder` أو `.separated` للقوائم الطويلة أو الديناميكية.',
            en: 'Always use `.builder` or `.separated` constructors for long dynamic lists.',
          ),
          LocalText(
            ar: 'أضف `RefreshIndicator` فوق القائمة لتفعيل ميزة السحب للتحديث (Pull-To-Refresh).',
            en: 'Wrap scroll views in `RefreshIndicator` for standard pull-to-refresh UX.',
          ),
        ],
        code:
            '// قائمة تفاعلية ذكية تدعم السحب للتحديث والحذف بالسحب\n'
            'Widget buildInteractiveProductList({\n'
            '  required List<String> products,\n'
            '  required Future<void> Function() onRefresh,\n'
            '  required void Function(int index) onDelete,\n'
            '}) {\n'
            '  return RefreshIndicator(\n'
            '    onRefresh: onRefresh,\n'
            '    child: ListView.separated(\n'
            '      itemCount: products.length,\n'
            '      separatorBuilder: (_, __) => const Divider(height: 1),\n'
            '      itemBuilder: (context, index) {\n'
            '        final item = products[index];\n'
            '        return Dismissible(\n'
            '          key: ValueKey(item),\n'
            '          direction: DismissDirection.endToStart,\n'
            '          background: Container(\n'
            '            alignment: Alignment.centerRight,\n'
            '            padding: const EdgeInsets.only(right: 20),\n'
            '            color: Colors.redAccent,\n'
            '            child: const Icon(Icons.delete_forever, color: Colors.white),\n'
            '          ),\n'
            '          onDismissed: (_) => onDelete(index),\n'
            '          child: ListTile(\n'
            '            leading: CircleAvatar(child: Text("\${index + 1}")),\n'
            '            title: Text(item),\n'
            '            subtitle: const Text("اسحب لليسار لحذف العنصر"),\n'
            '            trailing: const Icon(Icons.arrow_forward_ios, size: 14),\n'
            '          ),\n'
            '        );\n'
            '      },\n'
            '    ),\n'
            '  );\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استخدام `ListView(children: [...])` العادية مع مئات العناصر؛ لأنها تبني جميع العناصر في الذاكرة دفعة واحدة!',
            en: 'Using non-builder `ListView(children: [...])` for long lists, destroying memory and CPU frame budgets.',
          ),
          LocalText(
            ar: 'نسيان تمرير `Key` فريد لـ `Dismissible` مما يسبب أخطاء تصيير كارثية.',
            en: 'Forgetting unique keys on `Dismissible` widgets, breaking Flutter tree reconciliation.',
          ),
        ],
      ),

      // 4. Slivers Pipeline & Scroll Views
      CurriculumTopic(
        title: LocalText(
          ar: '4. عائلة الـ Slivers للمسارات التمريرية المعقدة (CustomScrollView & Slivers)',
          en: '4. Advanced Slivers & Collapsible Scroll Architecture',
        ),
        summary: LocalText(
          ar: 'دمج AppBar مطاطي مع صور هيدر تتقلص، وقوائم وشبكات متعددة داخل مسار تمرير واحد بـ CustomScrollView.',
          en: 'Combine collapsible stretchable headers, sticky pinned bars, and mixed grids inside a single scroll viewport.',
        ),
        explain: LocalText(
          ar: 'الـ Slivers هي عناصر التمرير المتخصصة داخل `CustomScrollView`. بخلاف الويدجتس الصندوقية العادية (Box Widgets)، تستجيب الـ Slivers مباشرة لنسب التمرير والإزاحة (Scroll Offset). يتيح لك `SliverAppBar` عمل هيدر يتمدد ويتقلص بسلاسة، بينما يسمح `SliverToBoxAdapter` بدمج أي ويدجت عادي داخل مسار الـ Slivers.',
          en: 'Slivers are viewport slices rendered lazily according to scroll offset constraints. `SliverAppBar` delivers collapsible and sticky header capabilities, while `SliverToBoxAdapter` integrates conventional box widgets smoothly.',
        ),
        whenToUse: [
          LocalText(
            ar: 'شاشات الحساب الشخصي (Profile) وتفاصيل المنتجات في المتاجر الإلكترونية.',
            en: 'Profile overviews, media details, and complex e-commerce catalog pages.',
          ),
          LocalText(
            ar: 'دمج شبكة Grid مع قائمة List داخل نفس مسار التمرير دون تضارب أو سكرول متداخل.',
            en: 'Mixing lists and grids into a unified scroll pipeline without nested scrollbar conflicts.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم `CustomScrollView` كحاوية رئيسية للشاشة.',
            en: 'Use `CustomScrollView` as the top-level viewport widget.',
          ),
          LocalText(
            ar: 'أضف `SliverAppBar(pinned: true, expandedHeight: 220, flexibleSpace: ...)` لهيدر متحرك.',
            en: 'Add a collapsible `SliverAppBar` configured with `pinned: true` and `flexibleSpace`.',
          ),
        ],
        code:
            'Widget buildSliverProfilePage() {\n'
            '  return CustomScrollView(\n'
            '    slivers: [\n'
            '      // 1. هيدر مطاطي يتقلص عند التمرير ويثبت بالأعلى\n'
            '      SliverAppBar(\n'
            '        expandedHeight: 220,\n'
            '        pinned: true,\n'
            '        stretch: true,\n'
            '        flexibleSpace: FlexibleSpaceBar(\n'
            '          title: const Text("الملف الشخصي والمشاريع"),\n'
            '          centerTitle: true,\n'
            '          background: Container(\n'
            '            decoration: const BoxDecoration(\n'
            '              gradient: LinearGradient(colors: [Colors.indigo, Colors.teal]),\n'
            '            ),\n'
            '            child: const Center(child: Icon(Icons.person, size: 72, color: Colors.white70)),\n'
            '          ),\n'
            '        ),\n'
            '      ),\n'
            '      // 2. محول للويدجتس العادية\n'
            '      SliverToBoxAdapter(\n'
            '        child: Padding(\n'
            '          padding: const EdgeInsets.all(16),\n'
            '          child: Text("المشاريع المنجزة", style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),\n'
            '        ),\n'
            '      ),\n'
            '      // 3. شبكة Slivers خفيفة وسريعة\n'
            '      SliverGrid.builder(\n'
            '        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(\n'
            '          crossAxisCount: 2,\n'
            '          childAspectRatio: 1.2,\n'
            '          mainAxisSpacing: 10,\n'
            '          crossAxisSpacing: 10,\n'
            '        ),\n'
            '        itemCount: 8,\n'
            '        itemBuilder: (context, index) => Card(\n'
            '          color: Colors.blueGrey.shade900,\n'
            '          child: Center(child: Text("مشروع #\${index + 1}", style: const TextStyle(color: Colors.white))),\n'
            '        ),\n'
            '      ),\n'
            '    ],\n'
            '  );\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'وضع `ListView` عادية مباشرة داخل `CustomScrollView` دون استخدام `SliverList` أو `SliverToBoxAdapter`.',
            en: 'Placing raw ListView directly into CustomScrollView without Sliver conversions.',
          ),
          LocalText(
            ar: 'نسيان `pinned: true` في حال أردت بقاء شريط التطبيق ثابتاً عند التمرير للأسفل.',
            en: 'Forgetting `pinned: true` when top navigation bar persistence is required.',
          ),
        ],
      ),

      // 5. Text, Typography & ShaderMask
      CurriculumTopic(
        title: LocalText(
          ar: '5. ويدجتس النصوص والطباعة المتقدمة (Text, RichText & ShaderMask)',
          en: '5. Typography, RichText & ShaderMask Text Gradients',
        ),
        summary: LocalText(
          ar: 'تنسيق النصوص الاحترافية، دمج أيقونات وروابط داخل النص بـ RichText، وتطبيق تدرجات الألوان اللامعة بـ ShaderMask.',
          en: 'Format rich paragraphs with inline widgets, selectable content, and metallic text gradients using ShaderMask.',
        ),
        explain: LocalText(
          ar: 'يقدم Flutter قدرات طباعية فائقة: `Text` للنصوص البسيطة مع التحكم في الحجم والـ `overflow`، و `RichText` لدمج فقرات متعددة بأنماط مختلفة مع روابط قابلة للنقر وأيقونات مدمجة عبر `WidgetSpan`. وباستخدام `ShaderMask`، يمكنك تطبيق تدرج لوني ساحر (Gradient) مباشرة على النص كأقنعة لونية.',
          en: '`Text` handles basic typography with truncation/overflow control. `RichText` with `TextSpan` and `WidgetSpan` embeds inline chips, icons, and tap gestures. `ShaderMask` maps linear/radial shaders over glyphs for brilliant metallic gradient typography.',
        ),
        whenToUse: [
          LocalText(
            ar: 'نصوص الشروط والأحكام التي تحتوي على كلمات زرقاء قابلة للنقر مثل "سياسة الخصوصية".',
            en: 'Terms & conditions paragraphs featuring inline clickable hyperlinks.',
          ),
          LocalText(
            ar: 'عناوين الشاشات الرئيسية الفاخرة ذات التدرجات الذهبية أو النيونية بـ ShaderMask.',
            en: 'Hero titles and pricing badges requiring luminous gradient typography.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم `SelectableText` بدلاً من `Text` إذا كنت تريد تمكين المستخدم من نسخ النص.',
            en: 'Use `SelectableText` whenever users need copyable code or article excerpts.',
          ),
          LocalText(
            ar: 'طبق `ShaderMask` مع `blendMode: BlendMode.srcIn` لتلوين النص بالتدرج اللوني.',
            en: 'Apply `ShaderMask` with `blendMode: BlendMode.srcIn` to tint glyphs with gradients.',
          ),
        ],
        code:
            '// 1. عنوان بتدرج لوني ذهبي فاخر عبر ShaderMask\n'
            'Widget buildGradientText(String text) {\n'
            '  return ShaderMask(\n'
            '    blendMode: BlendMode.srcIn,\n'
            '    shaderCallback: (bounds) => const LinearGradient(\n'
            '      colors: [Color(0xFFFFD700), Color(0xFFFF8C00), Color(0xFFFF0080)],\n'
            '    ).createShader(bounds),\n'
            '    child: Text(\n'
            '      text,\n'
            '      style: const TextStyle(fontSize: 28, fontWeight: FontWeight.w900),\n'
            '    ),\n'
            '  );\n'
            '}\n\n'
            '// 2. نص غني مدمج به أيقونة ورابط تفاعلي بـ RichText\n'
            'Widget buildRichPrivacyNotice(BuildContext context) {\n'
            '  return Text.rich(\n'
            '    TextSpan(\n'
            '      text: "بالتسجيل، أنت توافق على ",\n'
            '      style: TextStyle(color: Colors.grey.shade400, fontSize: 14),\n'
            '      children: [\n'
            '        const WidgetSpan(\n'
            '          alignment: PlaceholderAlignment.middle,\n'
            '          child: Icon(Icons.verified_user, size: 16, color: Colors.teal),\n'
            '        ),\n'
            '        const TextSpan(\n'
            '          text: " شروط الخدمة ",\n'
            '          style: TextStyle(color: Colors.teal, fontWeight: FontWeight.bold, decoration: TextDecoration.underline),\n'
            '        ),\n'
            '        const TextSpan(text: "و سياسة الخصوصية الخاصة بنا."),\n'
            '      ],\n'
            '    ),\n'
            '  );\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'عدم ضبط `overflow: TextOverflow.ellipsis` و `maxLines` للنصوص الديناميكية مما يسبب RenderFlex Overflow.',
            en: 'Omitting `maxLines` and `overflow: TextOverflow.ellipsis` on dynamic text nodes.',
          ),
          LocalText(
            ar: 'نسيان ضبط `BlendMode.srcIn` في `ShaderMask` مما يؤدي لتلوين الخلفية بالكامل بدلاً من النص فقط.',
            en: 'Forgetting `BlendMode.srcIn` on ShaderMask, flooding the rectangular bounding box with shader.',
          ),
        ],
      ),

      // 6. Form, Inputs & Selectors
      CurriculumTopic(
        title: LocalText(
          ar: '6. ويدجتس النماذج والإدخال (Form, TextFormField, Sliders & Switches)',
          en: '6. Forms, Text Fields, Sliders, Pickers & Segmented Buttons',
        ),
        summary: LocalText(
          ar: 'جمع البيانات والتحقق من صحتها بـ Form و TextFormField، وأزرار الاختيار، والـ Sliders والـ Autocomplete.',
          en: 'Capture, validate, and manage user inputs with Form validation, TextFields, Sliders, and Segmented controls.',
        ),
        explain: LocalText(
          ar: 'إدارة النماذج تتطلب التحقق من صحة المدخلات وإظهار رسائل الخطأ بدقة. يتيح لك `Form` مع `GlobalKey<FormState>` فحص جميع حقول `TextFormField` دفعة واحدة عبر `_formKey.currentState!.validate()`. كما تقدم فلاتر ويدجتس حديثة مثل `SegmentedButton` للأزرار المقسمة، و `Slider` للقيم الرقمية، و `Autocomplete` للاقتراحات الذكية أثناء الكتابة.',
          en: '`Form` orchestrates batch validation across multiple `TextFormField` instances using `FormState.validate()`. Combined with `SegmentedButton`, `SwitchListTile`, and `Autocomplete`, you can build accessible and responsive input forms.',
        ),
        whenToUse: [
          LocalText(
            ar: 'شاشات تسجيل الدخول، التسجيل، والدفع الإلكتروني.',
            en: 'Authentication forms, checkout flows, and user profile editors.',
          ),
          LocalText(
            ar: 'شاشات إعدادات التطبيق وتعديل التفضيلات والتنبيهات.',
            en: 'Settings preferences using SwitchListTiles and SegmentedButtons.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'أنشئ `final _formKey = GlobalKey<FormState>();` واحقنه في `Form(key: _formKey)`.',
            en: 'Instantiate a `GlobalKey<FormState>()` and bind it to the `Form`.',
          ),
          LocalText(
            ar: 'أضف دالة `validator: (value) => ...` في كل `TextFormField` لإرجاع نص الخطأ إذا كان الإدخال غير صالح.',
            en: 'Implement `validator` callbacks returning error strings upon validation failure.',
          ),
        ],
        code:
            '// نموذج إدخال متكامل مع تحقق فوري\n'
            'class ModernInputForm extends StatefulWidget {\n'
            '  const ModernInputForm({super.key});\n'
            '  @override\n'
            '  State<ModernInputForm> createState() => _ModernInputFormState();\n'
            '}\n\n'
            'class _ModernInputFormState extends State<ModernInputForm> {\n'
            '  final _formKey = GlobalKey<FormState>();\n'
            '  final _emailCtrl = TextEditingController();\n'
            '  bool _enableNotifications = true;\n'
            '  double _experienceYears = 3.0;\n'
            '  String _selectedRole = "developer";\n\n'
            '  @override\n'
            '  Widget build(BuildContext context) {\n'
            '    return Form(\n'
            '      key: _formKey,\n'
            '      child: Column(\n'
            '        children: [\n'
            '          // 1. حقل البريد مع التحقق\n'
            '          TextFormField(\n'
            '            controller: _emailCtrl,\n'
            '            decoration: const InputDecoration(labelText: "البريد الإلكتروني", prefixIcon: Icon(Icons.email)),\n'
            '            validator: (v) => (v == null || !v.contains("@")) ? "يرجى إدخال بريد صحيح" : null,\n'
            '          ),\n'
            '          const SizedBox(height: 16),\n'
            '          // 2. أزرار مقسمة SegmentedButton\n'
            '          SegmentedButton<String>(\n'
            '            segments: const [\n'
            '              ButtonSegment(value: "developer", label: Text("مطور")),\n'
            '              ButtonSegment(value: "designer", label: Text("مصمم")),\n'
            '            ],\n'
            '            selected: {_selectedRole},\n'
            '            onSelectionChanged: (s) => setState(() => _selectedRole = s.first),\n'
            '          ),\n'
            '          const SizedBox(height: 16),\n'
            '          // 3. شريط التمرير Slider\n'
            '          Slider(\n'
            '            value: _experienceYears,\n'
            '            min: 0,\n'
            '            max: 10,\n'
            '            divisions: 10,\n'
            '            label: "\${_experienceYears.toInt()} سنوات",\n'
            '            onChanged: (v) => setState(() => _experienceYears = v),\n'
            '          ),\n'
            '          // 4. زر الإرسال مع التحقق\n'
            '          ElevatedButton(\n'
            '            onPressed: () {\n'
            '              if (_formKey.currentState!.validate()) {\n'
            '                ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text("تم التحقق بنجاح!")));\n'
            '              }\n'
            '            },\n'
            '            child: const Text("حفظ البيانات"),\n'
            '          ),\n'
            '        ],\n'
            '      ),\n'
            '    );\n'
            '  }\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'نسيان عمل `dispose()` لـ `TextEditingController` مما يسبب تسريب ذاكرة مستمر.',
            en: 'Forgetting to dispose `TextEditingController` instances, leaking memory.',
          ),
          LocalText(
            ar: 'استخدام `TextField` بدلاً من `TextFormField` داخل `Form` مما يلغي قدرة الـ Form على التحقق التلقائي.',
            en: 'Using raw `TextField` instead of `TextFormField` inside a validating `Form`.',
          ),
        ],
      ),

      // 7. Buttons, Gestures & InteractiveViewer
      CurriculumTopic(
        title: LocalText(
          ar: '7. ويدجتس الأزرار والإيماءات والتقريب (All Buttons, GestureDetector, InkWell, Draggable & InteractiveViewer)',
          en: '7. Buttons, Gestures, Zooming & Drag-and-Drop (Buttons, GestureDetector, InkWell, Draggable & InteractiveViewer)',
        ),
        summary: LocalText(
          ar: 'دليل شامل لكل أنواع الأزرار (Elevated, Filled, Outlined, Text, FAB, Segmented, Popup)، ورصد الإيماءات بـ GestureDetector و InkWell، والسحب والإفلات بـ Draggable، والحذف بـ Dismissible، والتكبير بـ InteractiveViewer.',
          en: 'Complete guide to all Material 3 buttons, touch gestures with GestureDetector and InkWell, drag-and-drop mechanics, dismissible swipes, and pinch-to-zoom views.',
        ),
        explain: LocalText(
          ar: 'توفر Flutter منظومة تفاعلية متكاملة:\n'
              '1️⃣ **عائلة الأزرار (Buttons Suite)**:\n'
              '• `ElevatedButton`: زر بارز مرتفع بظل خفيف للإجراءات الواضحة.\n'
              '• `FilledButton` / `FilledButton.tonal`: أزرار Material 3 الحديثة للمهام الأساسية والثانوية بلون ممتلئ مريح.\n'
              '• `OutlinedButton`: زر بإطار شفاف للعمليات الثانوية وتأكيد الإلغاء.\n'
              '• `TextButton`: زر نصي شفاف بدون حدود للروابط والأفعال داخل الحوارات.\n'
              '• `IconButton`: زر أيقونة مدمج في أشرطة العناوين والقوائم السريعة.\n'
              '• `FloatingActionButton` (FAB): الزر العائم الرئيسي في أسفل الشاشة للإجراء الأهم.\n'
              '• `SegmentedButton`: أزرار الاختيار والتبديل المتعدد والمفرد (Material 3 Segmented Control).\n'
              '• `PopupMenuButton`: زر يفتح قائمة منسدلة بخيارات متعددة عند النقر.\n\n'
              '2️⃣ **رصد الإيماءات واللمس (Gestures & Touch)**:\n'
              '• `GestureDetector`: يرصد بدقة نقرات الأصابع، النقر المزدوج (DoubleTap)، الضغط المطول (LongPress)، السحب والتحريك (Pan/Drag)، وتكبير المنظور (Scale).\n'
              '• `InkWell` / `InkResponse`: يمنح أي ويدجت تموجات مائية مادية (Material Ripple Effect) عند الضغط، بشرط وجود `Material` في الشجرة.\n'
              '• `Listener`: للاستماع الخام المباشر لإحداثيات البوينتر (PointerDown, PointerMove, PointerUp).\n\n'
              '3️⃣ **السحب والإفلات والتكبير والحذف (Drag, Zoom & Dismiss)**:\n'
              '• `Draggable<T>` و `DragTarget<T>`: سحب العناصر ونقل كائنات البيانات بين أجزاء الشاشة مع ردود بصرية فورية (feedback و childWhenDragging).\n'
              '• `Dismissible`: سحب البطاقة يميناً أو يساراً للحذف أو الأرشفة مع خلفيات مخصصة وتأكيد.\n'
              '• `InteractiveViewer`: تحريك وتكبير وتصغير المحتوى والصور والخرائط بإصبعين (Pinch-to-zoom & Pan) بدون أي Controller.',
          en: 'Flutter provides a complete interaction suite:\n'
              '1. **Button Family**: `ElevatedButton`, `FilledButton`, `OutlinedButton`, `TextButton`, `IconButton`, `FloatingActionButton`, `SegmentedButton`, and `PopupMenuButton`.\n'
              '2. **Gestures**: `GestureDetector` (Tap, DoubleTap, LongPress, Pan, Scale), `InkWell` (Material Ripple), and raw `Listener`.\n'
              '3. **Drag, Zoom & Dismiss**: `Draggable<T>` with `DragTarget<T>`, `Dismissible` swipe-to-delete, and `InteractiveViewer` pinch-to-zoom.',
        ),
        whenToUse: [
          LocalText(
            ar: 'استخدام `FilledButton` للإجراء الرئيسي و `OutlinedButton` للإجراء الثانوي لمنح الواجهة تسلسلاً بصرياً متناسقاً.',
            en: 'Use `FilledButton` for primary CTAs and `OutlinedButton` for secondary cancel actions.',
          ),
          LocalText(
            ar: 'استخدام `GestureDetector` للتعامل مع السحب والرسم والتكبير، و `InkWell` للأزرار والقوائم التي تحتاج تموج مادي.',
            en: 'Use `GestureDetector` for complex gestures (pan, scale) and `InkWell` for Material ripple feedback on cards.',
          ),
          LocalText(
            ar: 'استخدام `InteractiveViewer` لمعارض الصور والمخططات والخرائط التي تحتاج إلى تكبير وتمرير سلس.',
            en: 'Wrap blueprints, photo galleries, and documents in `InteractiveViewer` for pinch-to-zoom.',
          ),
          LocalText(
            ar: 'استخدام `Draggable` و `DragTarget` في قوائم المهام (Kanban Boards) وألعاب السحب وإعادة الترتيب.',
            en: 'Use `Draggable` and `DragTarget` in drag-and-drop boards, card games, and shopping carts.',
          ),
          LocalText(
            ar: 'استخدام `Dismissible` في قوائم الرسائل والتنبيهات للسحب السريع للحذف أو الأرشفة.',
            en: 'Use `Dismissible` in inbox lists for intuitive swipe-to-delete and swipe-to-archive.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'اختر نوع الزر المناسب من عائلة Buttons (`FilledButton`, `ElevatedButton`, `OutlinedButton`, `TextButton`, `IconButton`).',
            en: 'Choose the appropriate button type matching the visual hierarchy.',
          ),
          LocalText(
            ar: 'لإضافة تموجات تفاعلية لأي كارد مخصص، غلفه بـ `Material(color: Colors.transparent, child: InkWell(onTap: ..., child: ...))`',
            en: 'Add tactile ripples to cards with `Material(color: Colors.transparent, child: InkWell(onTap: ...))`.',
          ),
          LocalText(
            ar: 'لتفعيل التكبير باللمس، غلف الويدجت بـ `InteractiveViewer(minScale: 0.8, maxScale: 4.0, child: ...)`',
            en: 'Wrap zoomable widgets in `InteractiveViewer` specifying min and max scale bounds.',
          ),
          LocalText(
            ar: 'لتنفيذ السحب والإفلات، عرّف `Draggable<T>(data: item, feedback: ..., child: ...)` واستقبله بـ `DragTarget<T>(onAcceptWithDetails: ...)`',
            en: 'Set up `Draggable<T>` with data payload and receive it in `DragTarget<T>`.',
          ),
          LocalText(
            ar: 'لحذف العناصر بالسحب، غلف العنصر بـ `Dismissible(key: Key(item.id), onDismissed: ..., background: ...)`',
            en: 'Wrap swipeable list items with `Dismissible` providing unique Keys and delete callbacks.',
          ),
        ],
        code:
            '// =========================================================================\n'
            '// 1. عائلة أزرار فلاتر الحديثة (Flutter Buttons Suite - Material 3)\n'
            '// =========================================================================\n'
            'Widget buildAllButtonsExample(BuildContext context) {\n'
            '  return Wrap(\n'
            '    spacing: 12,\n'
            '    runSpacing: 12,\n'
            '    crossAxisAlignment: WrapCrossAlignment.center,\n'
            '    children: [\n'
            '      // أ. زر Material 3 ممتلئ (FilledButton) - الأهم للإجراء الرئيسي\n'
            '      FilledButton.icon(\n'
            '        onPressed: () => print("Filled Clicked!"),\n'
            '        icon: const Icon(Icons.check_circle_outline),\n'
            '        label: const Text("FilledButton (رئيسي)"),\n'
            '      ),\n\n'
            '      // ب. زر بارز بظل خفيف (ElevatedButton)\n'
            '      ElevatedButton.icon(\n'
            '        onPressed: () => print("Elevated Clicked!"),\n'
            '        icon: const Icon(Icons.touch_app),\n'
            '        label: const Text("ElevatedButton"),\n'
            '      ),\n\n'
            '      // ج. زر بإطار شفاف (OutlinedButton) - للإجراءات الثانوية\n'
            '      OutlinedButton.icon(\n'
            '        onPressed: () => print("Outlined Clicked!"),\n'
            '        icon: const Icon(Icons.close),\n'
            '        label: const Text("OutlinedButton"),\n'
            '      ),\n\n'
            '      // د. زر نصي شفاف (TextButton) - للحوارات والروابط\n'
            '      TextButton(\n'
            '        onPressed: () => print("Text Clicked!"),\n'
            '        child: const Text("TextButton"),\n'
            '      ),\n\n'
            '      // هـ. زر أيقونة مستقل (IconButton)\n'
            '      IconButton.filledTonal(\n'
            '        onPressed: () => print("Icon Clicked!"),\n'
            '        icon: const Icon(Icons.favorite_rounded),\n'
            '        tooltip: "إضافة للمفضلة",\n'
            '      ),\n\n'
            '      // و. زر عائم صغير (FloatingActionButton Small)\n'
            '      FloatingActionButton.small(\n'
            '        onPressed: () => print("FAB Clicked!"),\n'
            '        child: const Icon(Icons.add),\n'
            '      ),\n\n'
            '      // ز. قائمة خيارات منسدلة (PopupMenuButton)\n'
            '      PopupMenuButton<String>(\n'
            '        icon: const Icon(Icons.more_vert),\n'
            '        onSelected: (val) => print("Selected: \$val"),\n'
            '        itemBuilder: (context) => [\n'
            '          const PopupMenuItem(value: "edit", child: Text("✏️ تعديل")),\n'
            '          const PopupMenuItem(value: "delete", child: Text("🗑️ حذف")),\n'
            '        ],\n'
            '      ),\n'
            '    ],\n'
            '  );\n'
            '}\n\n'
            '// =========================================================================\n'
            '// 2. التقاط الإيماءات بـ GestureDetector و تموجات InkWell\n'
            '// =========================================================================\n'
            'Widget buildGesturesAndInkWellExample() {\n'
            '  return Column(\n'
            '    children: [\n'
            '      // أ. كاشف الإيماءات متعدد الحركات (GestureDetector)\n'
            '      GestureDetector(\n'
            '        onTap: () => print("نقرة واحدة (Single Tap)"),\n'
            '        onDoubleTap: () => print("نقرة مزدوجة (Double Tap)"),\n'
            '        onLongPress: () => print("ضغط مطول (Long Press)"),\n'
            '        onPanUpdate: (details) => print("تحريك وسحب بالإصبع: \${details.delta}"),\n'
            '        child: Container(\n'
            '          padding: const EdgeInsets.all(16),\n'
            '          decoration: BoxDecoration(\n'
            '            color: Colors.indigo.shade900,\n'
            '            borderRadius: BorderRadius.circular(12),\n'
            '          ),\n'
            '          child: const Center(child: Text("المس، انقر مرتين، أو اضغط مطولاً هنا 👆")),\n'
            '        ),\n'
            '      ),\n'
            '      const SizedBox(height: 12),\n\n'
            '      // ب. تموجات مادية حقيقية (Material InkWell Ripple)\n'
            '      Material(\n'
            '        color: Colors.teal.shade800,\n'
            '        borderRadius: BorderRadius.circular(12),\n'
            '        child: InkWell(\n'
            '          onTap: () => print("InkWell Ripple Triggered!"),\n'
            '          borderRadius: BorderRadius.circular(12),\n'
            '          splashColor: Colors.tealAccent.withOpacity(0.4),\n'
            '          child: const Padding(\n'
            '            padding: EdgeInsets.all(16),\n'
            '            child: Center(child: Text("اضغط هنا لتجربة تموجات الماء المادية (InkWell) 🌊")),\n'
            '          ),\n'
            '        ),\n'
            '      ),\n'
            '    ],\n'
            '  );\n'
            '}\n\n'
            '// =========================================================================\n'
            '// 3. التكبير والتصغير باللمس عبر InteractiveViewer\n'
            '// =========================================================================\n'
            'Widget buildZoomablePhoto(String imageUrl) {\n'
            '  return InteractiveViewer(\n'
            '    boundaryMargin: const EdgeInsets.all(20),\n'
            '    minScale: 0.5,\n'
            '    maxScale: 4.0,\n'
            '    child: ClipRRect(\n'
            '      borderRadius: BorderRadius.circular(16),\n'
            '      child: Image.network(imageUrl, fit: BoxFit.cover),\n'
            '    ),\n'
            '  );\n'
            '}\n\n'
            '// =========================================================================\n'
            '// 4. السحب والإفلات Draggable & DragTarget\n'
            '// =========================================================================\n'
            'Widget buildDragAndDropSystem() {\n'
            '  return Row(\n'
            '    mainAxisAlignment: MainAxisAlignment.spaceEvenly,\n'
            '    children: [\n'
            '      // العنصر القابل للسحب (Draggable)\n'
            '      Draggable<String>(\n'
            '        data: "PRO_BADGE",\n'
            '        feedback: Material(\n'
            '          color: Colors.transparent,\n'
            '          child: Chip(backgroundColor: Colors.amber, label: const Text("🌟 PRO Badge (أثناء السحب)")),\n'
            '        ),\n'
            '        childWhenDragging: const Opacity(\n'
            '          opacity: 0.3,\n'
            '          child: Chip(label: Text("مكان العنصر المسحوب")),\n'
            '        ),\n'
            '        child: const Chip(backgroundColor: Colors.amber, label: Text("اسحبني إلى الهدف ⬅️")),\n'
            '      ),\n\n'
            '      // منطقة استقبال السحب (DragTarget)\n'
            '      DragTarget<String>(\n'
            '        onWillAcceptWithDetails: (details) => details.data == "PRO_BADGE",\n'
            '        onAcceptWithDetails: (details) => print("تم قبول واستلام: \${details.data}"),\n'
            '        builder: (context, candidateData, rejectedData) {\n'
            '          return Container(\n'
            '            width: 140,\n'
            '            height: 60,\n'
            '            decoration: BoxDecoration(\n'
            '              color: candidateData.isNotEmpty ? Colors.green.shade800 : Colors.grey.shade900,\n'
            '              borderRadius: BorderRadius.circular(10),\n'
            '              border: Border.all(color: Colors.greenAccent),\n'
            '            ),\n'
            '            child: const Center(child: Text("أفلت هنا (Drop Target) 📥")),\n'
            '          );\n'
            '        },\n'
            '      ),\n'
            '    ],\n'
            '  );\n'
            '}\n\n'
            '// =========================================================================\n'
            '// 5. السحب للحذف بـ Dismissible\n'
            '// =========================================================================\n'
            'Widget buildSwipeToDeleteItem(String itemId, String title, VoidCallback onDelete) {\n'
            '  return Dismissible(\n'
            '    key: Key(itemId),\n'
            '    direction: DismissDirection.endToStart,\n'
            '    background: Container(\n'
            '      alignment: Alignment.centerRight,\n'
            '      padding: const EdgeInsets.symmetric(horizontal: 20),\n'
            '      color: Colors.red,\n'
            '      child: const Icon(Icons.delete_forever, color: Colors.white),\n'
            '    ),\n'
            '    onDismissed: (direction) => onDelete(),\n'
            '    child: ListTile(\n'
            '      title: Text(title),\n'
            '      subtitle: const Text("اسحب العنصر لليسار لحذفه"),\n'
            '      leading: const Icon(Icons.drag_indicator),\n'
            '    ),\n'
            '  );\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استخدام `GestureDetector` وتوقع ظهور Ripple Effect مادي (الـ Ripple يتطلب `InkWell` داخل `Material`).',
            en: 'Expecting Material ripple animations from `GestureDetector` instead of `InkWell`.',
          ),
          LocalText(
            ar: 'نسيان تحديد `hitTestBehavior: HitTestBehavior.opaque` عند استخدام GestureDetector مع مساحات فارغة أو شفافة، مما يمنع استجابتها للنقر.',
            en: 'Leaving default hit test behavior on transparent gesture detector areas, missing clicks.',
          ),
          LocalText(
            ar: 'نسيان إعطاء `Key` فريد وثابت لكل عنصر `Dismissible` مما يؤدي لأخطاء أثناء حذف العناصر من القوائم.',
            en: 'Not providing unique immutable Keys to `Dismissible` widgets in dynamic lists.',
          ),
          LocalText(
            ar: 'الإفراط في استخدام `ElevatedButton` لكل الأزرار في نفس الصفحة بدلاً من توزيع الأهمية بين `FilledButton` للأساسي و `OutlinedButton` و `TextButton` للثانوي.',
            en: 'Overcrowding multiple primary ElevatedButtons instead of creating visual hierarchy with Text/Outlined variants.',
          ),
        ],
      ),

      // 8. Implicit & Explicit Animations
      CurriculumTopic(
        title: LocalText(
          ar: '8. ويدجتس الحركة والأنيميشن (AnimatedContainer, Hero & Transitions)',
          en: '8. Implicit & Explicit Animations (AnimatedContainer, Hero, AnimatedSwitcher & Transitions)',
        ),
        summary: LocalText(
          ar: 'تحريك الأبعاد والألوان تلقائياً بـ AnimatedContainer، انتقال العناصر الملحمي بين الشاشات بـ Hero، والتبديل السلس بـ AnimatedSwitcher.',
          en: 'Animate styles automatically with implicit widgets, seamlessly morph hero assets between screens, and switch states smoothly.',
        ),
        explain: LocalText(
          ar: 'توفر Flutter نوعين من الأنيميشن: الأنيميشن التلقائي (Implicit Animations) مثل `AnimatedContainer` و `AnimatedOpacity` و `AnimatedAlign` التي تتحرك تلقائياً بمجرد تغيير القيم وبدون الحاجة لـ AnimationController. والأنيميشن الملحمي عبر الشاشات بـ `Hero` الذي ينقل الصور بسلاسة بين صفحتين أثناء التنقل.',
          en: 'Flutter delivers two animation tiers: Implicit Animations (`AnimatedContainer`, `AnimatedOpacity`, `AnimatedSwitcher`) which animate property changes automatically without controllers, and Explicit/Hero transitions which coordinate continuous morphing across navigator routes.',
        ),
        whenToUse: [
          LocalText(
            ar: 'انتقال صورة المنتج المصغرة من القائمة لتصبح صورة الغلاف الكاملة في صفحة التفاصيل بـ `Hero`.',
            en: 'Morphing product thumbnails into full-screen covers across pages with `Hero`.',
          ),
          LocalText(
            ar: 'توسيع وتصغير البطاقات والأزرار بسلاسة 60fps عبر `AnimatedContainer`.',
            en: 'Expanding card accordions and pulsing notification icons with `AnimatedContainer`.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم `Hero(tag: item.id, child: ...)` بنفس الـ tag الفريد في كلتا الشاشتين.',
            en: 'Tag corresponding widgets with matching `Hero(tag: ...)` identifiers across routes.',
          ),
          LocalText(
            ar: 'استخدم `AnimatedSwitcher` لتبديل المحتوى (مثل التحميل 🔄 إلى أيقونة النجاح ✅) بحركة ناعمة.',
            en: 'Wrap dynamic child swaps in `AnimatedSwitcher` for automated fade/scale crossfades.',
          ),
        ],
        code:
            '// 1. تحريك الأبعاد واللون تلقائياً بدون Controller\n'
            'class AnimatedExpandableBox extends StatefulWidget {\n'
            '  const AnimatedExpandableBox({super.key});\n'
            '  @override\n'
            '  State<AnimatedExpandableBox> createState() => _AnimatedExpandableBoxState();\n'
            '}\n\n'
            'class _AnimatedExpandableBoxState extends State<AnimatedExpandableBox> {\n'
            '  bool _isExpanded = false;\n\n'
            '  @override\n'
            '  Widget build(BuildContext context) {\n'
            '    return GestureDetector(\n'
            '      onTap: () => setState(() => _isExpanded = !_isExpanded),\n'
            '      child: AnimatedContainer(\n'
            '        duration: const Duration(milliseconds: 350),\n'
            '        curve: Curves.easeOutBack,\n'
            '        width: _isExpanded ? 300 : 120,\n'
            '        height: _isExpanded ? 160 : 60,\n'
            '        decoration: BoxDecoration(\n'
            '          color: _isExpanded ? Colors.teal : Colors.indigo,\n'
            '          borderRadius: BorderRadius.circular(_isExpanded ? 24 : 12),\n'
            '        ),\n'
            '        child: Center(\n'
            '          child: Text(\n'
            '            _isExpanded ? "انقر للتصغير 🔽" : "انقر للتوسيع 🔼",\n'
            '            style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold),\n'
            '          ),\n'
            '        ),\n'
            '      ),\n'
            '    );\n'
            '  }\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'تكرار نفس الـ `Hero(tag: ...)` لأكثر من عنصرين على نفس الشاشة، مما يسبب كراش فوري.',
            en: 'Duplicating `Hero(tag: ...)` tags simultaneously in the same route tree.',
          ),
          LocalText(
            ar: 'استخدام `AnimationController` معقد لعمليات بسيطة يمكن لـ `AnimatedContainer` إنجازها في سطر واحد.',
            en: 'Overcomplicating simple state animations with explicit controllers instead of implicit widgets.',
          ),
        ],
      ),

      // 9. Dialogs, BottomSheets & Overlays
      CurriculumTopic(
        title: LocalText(
          ar: '9. ويدجتس الحوارات والنوافذ والـ Overlays (AlertDialog, BottomSheet & Tooltip)',
          en: '9. Modals, Dialogs, BottomSheets & Floating Overlays',
        ),
        summary: LocalText(
          ar: 'إظهار نوافذ التأكيد بـ AlertDialog، القوائم السفلية بـ showModalBottomSheet، والطبقات العائمة بـ OverlayEntry.',
          en: 'Display alert modals, modal bottom sheets, contextual tooltips, and custom floating overlay menus.',
        ),
        explain: LocalText(
          ar: 'تتيح فلاتر عرض النوافذ المؤقتة فوق الشاشة الحالية بسهولة: `AlertDialog` لتأكيد العمليات الحساسة، `showModalBottomSheet` لعرض الخيارات السفلية المنسدلة، و `OverlayEntry` لرسم عناصر عائمة في أي موضع فوق شجرة الويدجتس بالكامل (مثل القوائم المنسدلة المخصصة ومربعات الشرح التعليمية).',
          en: 'Overlay mechanisms render floating layers above normal route stacks. `AlertDialog` handles critical user prompts, `showModalBottomSheet` serves bottom menus, and raw `OverlayEntry` attaches floating badges and guides anywhere on the root viewport.',
        ),
        whenToUse: [
          LocalText(
            ar: 'تأكيد الحذف أو تسجيل الخروج عبر `AlertDialog`.',
            en: 'Confirming destructive actions (deletion/logout) with `AlertDialog`.',
          ),
          LocalText(
            ar: 'خيارات المشاركة واختيار الصور من الكاميرا/المعرض عبر `showModalBottomSheet`.',
            en: 'Presenting photo pickers and action sheets via `showModalBottomSheet`.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم `showModalBottomSheet(context: context, isScrollControlled: true, builder: ...)` لقوائم قابلة للتمرير.',
            en: 'Set `isScrollControlled: true` on bottom sheets containing text fields or scroll views.',
          ),
          LocalText(
            ar: 'استخدم `Navigator.pop(context)` لإغلاق النافذة وإرجاع النتيجة للشاشة السابقة.',
            en: 'Call `Navigator.pop(context, result)` to dismiss dialogues and return values.',
          ),
        ],
        code:
            '// 1. فتح نافذة سفلية حديثة بحواف دائرية\n'
            'Future<String?> showActionSheet(BuildContext context) {\n'
            '  return showModalBottomSheet<String>(\n'
            '    context: context,\n'
            '    shape: const RoundedRectangleBorder(\n'
            '      borderRadius: BorderRadius.vertical(top: Radius.circular(24)),\n'
            '    ),\n'
            '    builder: (context) => SafeArea(\n'
            '      child: Column(\n'
            '        mainAxisSize: MainAxisSize.min,\n'
            '        children: [\n'
            '          const SizedBox(height: 12),\n'
            '          Container(width: 40, height: 4, decoration: BoxDecoration(color: Colors.grey.shade600, borderRadius: BorderRadius.circular(2))),\n'
            '          ListTile(\n'
            '            leading: const Icon(Icons.camera_alt, color: Colors.teal),\n'
            '            title: const Text("التقاط صورة بالكاميرا"),\n'
            '            onTap: () => Navigator.pop(context, "camera"),\n'
            '          ),\n'
            '          ListTile(\n'
            '            leading: const Icon(Icons.photo_library, color: Colors.indigo),\n'
            '            title: const Text("اختيار من المعرض"),\n'
            '            onTap: () => Navigator.pop(context, "gallery"),\n'
            '          ),\n'
            '        ],\n'
            '      ),\n'
            '    ),\n'
            '  );\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استدعاء `showDialog` أو `showModalBottomSheet` بعد تدمير الـ Widget ودون فحص `if (mounted)`.',
            en: 'Invoking dialog methods across async gaps without checking `if (mounted)`.',
          ),
          LocalText(
            ar: 'نسيان إزالة `OverlayEntry.remove()` مما يترك طبقات عائمة تالفة في الذاكرة.',
            en: 'Forgetting to call `.remove()` on floating `OverlayEntry` instances.',
          ),
        ],
      ),

      // 10. Async & Reactive Builders
      CurriculumTopic(
        title: LocalText(
          ar: '10. ويدجتس البناء غير المتزامن والتحديث الشرطي (FutureBuilder, StreamBuilder & Builders)',
          en: '10. Async & Reactive Builders (FutureBuilder, StreamBuilder, ValueListenableBuilder & LayoutBuilder)',
        ),
        summary: LocalText(
          ar: 'ربط واجهة المستخدم بالبيانات غير المتزامنة بـ FutureBuilder و StreamBuilder، وتجاوب الشاشات بـ LayoutBuilder.',
          en: 'Bind UIs reactively to async Futures/Streams and adapt layouts responsively with LayoutBuilder.',
        ),
        explain: LocalText(
          ar: 'تمكنك عائلة الـ Builders من بناء الواجهات بناءً على حالة البيانات اللحظية: `FutureBuilder` لانتظار نتائج الـ API (Loading / Data / Error)، و `StreamBuilder` للاستماع للتحديثات الحية الفورية (WebSockets / Firebase)، و `ValueListenableBuilder` لتحديث جزء صغير جداً من الشاشة دون إعادة بناء الشاشة كلها، و `LayoutBuilder` لمعرفة أبعاد الشاشة وبناء واجهات متجاوبة.',
          en: 'Reactive builders bind UI rendering directly to async pipelines. `FutureBuilder` manages API lifecycles, `StreamBuilder` consumes real-time push streams, `ValueListenableBuilder` isolates micro-rebuilds, and `LayoutBuilder` facilitates responsive breakpoints based on parent constraints.',
        ),
        whenToUse: [
          LocalText(
            ar: 'جلب بيانات من الإنترنت وعرض شاشة تحميل ⏳ أو خطأ ⚠️ أو البيانات ✅ بـ FutureBuilder.',
            en: 'Handling async HTTP fetch states cleanly with loading and error fallbacks.',
          ),
          LocalText(
            ar: 'تحديث عداد أو حالة زر بدون استخدام `setState` لكامل الشاشة بـ `ValueListenableBuilder`.',
            en: 'Updating micro-states without triggering full widget tree rebuilds.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'احفظ دالة الـ Future دائماً في متغير داخل `initState` بدلاً من استدعائها مباشرة داخل `FutureBuilder`.',
            en: 'Always instantiate the Future inside `initState` to prevent refetching on every build.',
          ),
          LocalText(
            ar: 'افحص حالات `snapshot.connectionState == ConnectionState.waiting` ثم `snapshot.hasError`.',
            en: 'Check `ConnectionState.waiting`, verify `hasError`, then consume `snapshot.data`.',
          ),
        ],
        code:
            '// 1. بناء واجهة غير متزامنة ذكية لمعالجة التحميل والبيانات والخطأ\n'
            'Widget buildAsyncUserCard(Future<String> userFuture) {\n'
            '  return FutureBuilder<String>(\n'
            '    future: userFuture,\n'
            '    builder: (context, snapshot) {\n'
            '      if (snapshot.connectionState == ConnectionState.waiting) {\n'
            '        return const Center(child: CircularProgressIndicator());\n'
            '      } else if (snapshot.hasError) {\n'
            '        return Center(child: Text("⚠️ حدث خطأ: \${snapshot.error}"));\n'
            '      } else if (snapshot.hasData) {\n'
            '        return ListTile(\n'
            '          leading: const Icon(Icons.account_circle, color: Colors.teal, size: 36),\n'
            '          title: Text(snapshot.data!),\n'
            '          subtitle: const Text("تم جلب البيانات بنجاح"),\n'
            '        );\n'
            '      }\n'
            '      return const SizedBox.shrink();\n'
            '    },\n'
            '  );\n'
            '}\n\n'
            '// 2. تصميم متجاوب يعتمد على قياسات الأب عبر LayoutBuilder\n'
            'Widget buildResponsiveGrid() {\n'
            '  return LayoutBuilder(\n'
            '    builder: (context, constraints) {\n'
            '      final isWideScreen = constraints.maxWidth > 600;\n'
            '      return GridView.count(\n'
            '        crossAxisCount: isWideScreen ? 4 : 2,\n'
            '        shrinkWrap: true,\n'
            '        children: List.generate(4, (i) => Card(child: Center(child: Text("عنصر #\${i + 1}")))),\n'
            '      );\n'
            '    },\n'
            '  );\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استدعاء دالة الـ API مثل `future: fetchUserData()` مباشرة داخل دالة `build()` مما يسبب إعادة طلب الـ API في كل Frame!',
            en: 'Invoking the API method directly in `future: fetchApi()` inside `build()`, triggering endless network requests.',
          ),
          LocalText(
            ar: 'تجاهل فحص `snapshot.hasError` مما يسبب كراش عند انقطاع الإنترنت.',
            en: 'Ignoring error snapshots, leading to uncaught null assertions when offline.',
          ),
        ],
      ),
    ],
  ),

  // ===========================================================================
  // LEVEL 3: Advanced UI, Slivers & Performance Engineering
  // ===========================================================================
  CurriculumLevel(
    number: 3,
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
      CurriculumTopic(
        title: LocalText(
          ar: 'شجرة العناصر و InheritedWidget مع InheritedModel',
          en: 'InheritedWidget, InheritedModel & Element Tree Lifecycle',
        ),
        summary: LocalText(
          ar: 'فهم كيف ينقل Flutter البيانات للأسفل بدون مكاتب، والتحكم في إعادة بناء الأجزاء المحددة بـ aspect.',
          en: 'Propagate data down the widget tree natively and optimize partial widget rebuilds with InheritedModel aspects.',
        ),
        explain: LocalText(
          ar: 'في Flutter، الـ Widget هو مجرد إعدادات مؤقتة رخيصة، والـ Element هو الكائن المستمر الذي يمثل العقدة الحقيقية في الشجرة. يتيح لك `InheritedWidget` تمرير البيانات لأي سليل في الشجرة بكفاءة O(1). وباستخدام `InheritedModel`، يمكنك تحديد `aspect` دقيق بحيث لا تُعاد بناء الشاشات الفرعية إلا إذا تغير الحقل الذي تستمع إليه فقط (مثل الاستماع للون الثيم فقط دون حجم الخط).',
          en: 'InheritedWidget provides O(1) context dependency lookups down the Element tree. InheritedModel refines this by registering aspects, ensuring dependent widgets only rebuild when their subscribed sub-property changes.',
        ),
        whenToUse: [
          LocalText(
            ar: 'بناء نظام إدارة حالة مخصص أو مكتبة خاصة خفيفة دون الاعتماد على مكتبات خارجية.',
            en: 'Building custom lightweight design tokens or zero-dependency state containers.',
          ),
          LocalText(
            ar: 'مشاركة إعدادات التطبيق أو الثيم أو تفاصيل المستخدم المصادق عبر الشاشات بكفاءة.',
            en: 'Sharing global session profiles or theme palettes with granular partial rebuilds.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'أنشئ كلاس يرث من `InheritedModel<T>` وعرف دالة `updateShouldNotifyDependent`.',
            en: 'Subclass `InheritedModel<T>` and override `updateShouldNotifyDependent`.',
          ),
          LocalText(
            ar: 'استدعِ `InheritedModel.inheritFrom<T>(context, aspect: ...)` في الويدجت التابع.',
            en: 'Consume properties using `InheritedModel.inheritFrom<T>(context, aspect: ...)`.',
          ),
        ],
        code:
            'enum AppStyleAspect { themeColor, fontSize }\n\n'
            'class AppStyleScope extends InheritedModel<AppStyleAspect> {\n'
            '  final Color primaryColor;\n'
            '  final double baseFontSize;\n\n'
            '  const AppStyleScope({\n'
            '    super.key,\n'
            '    required this.primaryColor,\n'
            '    required this.baseFontSize,\n'
            '    required super.child,\n'
            '  });\n\n'
            '  static AppStyleScope of(BuildContext context, [AppStyleAspect? aspect]) {\n'
            '    return InheritedModel.inheritFrom<AppStyleScope>(context, aspect: aspect)!;\n'
            '  }\n\n'
            '  @override\n'
            '  bool updateShouldNotify(AppStyleScope oldWidget) =>\n'
            '      primaryColor != oldWidget.primaryColor || baseFontSize != oldWidget.baseFontSize;\n\n'
            '  @override\n'
            '  bool updateShouldNotifyDependent(AppStyleScope oldWidget, Set<AppStyleAspect> dependencies) {\n'
            '    if (dependencies.contains(AppStyleAspect.themeColor) && primaryColor != oldWidget.primaryColor) return true;\n'
            '    if (dependencies.contains(AppStyleAspect.fontSize) && baseFontSize != oldWidget.baseFontSize) return true;\n'
            '    return false;\n'
            '  }\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استدعاء `context.dependOnInheritedWidgetOfExactType` داخل دالة `initState` مما يرمي استثناء (يجب وضعه في `didChangeDependencies`).',
            en: 'Accessing inherited widgets in `initState` instead of `didChangeDependencies`.',
          ),
          LocalText(
            ar: 'استخدام InheritedWidget عادي مع كائنات معقدة مما يسبب إعادة بناء الشجرة بالكامل عند أي تعديل بسيط.',
            en: 'Using non-granular InheritedWidgets causing broad, wasteful subtree rebuild cascades.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(
          ar: 'استراتيجية المفاتيح (ValueKey, ObjectKey, UniqueKey, PageStorageKey & GlobalKey)',
          en: 'Flutter Keys Strategy & State Preservation',
        ),
        summary: LocalText(
          ar: 'التحكم في هوية الويدجت، الحفاظ على موضع التمرير بـ PageStorageKey، والوصول لحالة العناصر بـ GlobalKey.',
          en: 'Control widget identity across tree diffing, retain scroll positions, and access element state.',
        ),
        explain: LocalText(
          ar: 'المفاتيح (Keys) تخبر محرك فلاتر كيف يطابق الويدجت مع الـ Elements المقابلة أثناء المقارنة (Tree Diffing). بدون Keys، إذا حذفت أو رتبت عناصر قائمة ديناميكية تحتوي على State (مثل نصوص الإدخال أو مربعات الاختيار)، ستحتفظ العناصر الخاطئة بالحالة. يوفر Flutter أنواعاً متخصصة: `ValueKey` للقيم الفريدة، `ObjectKey` للهياكل المعقدة، `PageStorageKey` لحفظ موضع التمرير، و `GlobalKey` للوصول المباشر للـ State وأبعاد العنصر.',
          en: 'Keys preserve state when widgets move around the widget tree. Flutter uses key identity during element diffing. ValueKey handles unique primitives, ObjectKey binds to object instances, PageStorageKey persists scroll offsets across tabs, and GlobalKey allows cross-tree state manipulation and geometry measurements.',
        ),
        whenToUse: [
          LocalText(
            ar: 'القوائم القابلة للحذف والترتيب السحب والإفلات (Reorderable / Dismissible).',
            en: 'Reorderable and dismissible lists where items are inserted, deleted, or sorted.',
          ),
          LocalText(
            ar: 'حفظ موضع التمرير في الـ BottomNavigationBar والـ TabBar عبر `PageStorageKey`.',
            en: 'Retaining list scroll offsets when switching bottom navigation tabs.',
          ),
          LocalText(
            ar: 'التحقق من صحة النماذج (`FormState`) أو قياس حجم وموضع عنصر على الشاشة (`GlobalKey`).',
            en: 'Validating forms or measuring screen offsets/dimensions via `GlobalKey`.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'مرر `ValueKey(item.id)` لكل عنصر داخل قوائم الـ `ListView` الديناميكية.',
            en: 'Assign `ValueKey(item.id)` to each item in mutable dynamic lists.',
          ),
          LocalText(
            ar: 'استخدم `PageStorageKey("tab_feed_key")` على الـ ListView داخل التبويبات.',
            en: 'Add `PageStorageKey` to viewports that need persisted scroll offsets.',
          ),
        ],
        code:
            '// 1. استخدام ValueKey للحفاظ على حالة العناصر أثناء الحذف والترتيب\n'
            'ListView.builder(\n'
            '  itemCount: items.length,\n'
            '  itemBuilder: (context, index) {\n'
            '    final task = items[index];\n'
            '    return Dismissible(\n'
            '      key: ValueKey(task.id), // مفتاح فريد يمنع اختلاط الحالة\n'
            '      onDismissed: (_) => deleteTask(task.id),\n'
            '      child: TaskCheckboxTile(task: task),\n'
            '    );\n'
            '  },\n'
            ');\n\n'
            '// 2. استخدام GlobalKey لقياس أبعاد ويدجت برمجياً\n'
            'final GlobalKey buttonKey = GlobalKey();\n\n'
            'void measureButton() {\n'
            '  final renderBox = buttonKey.currentContext?.findRenderObject() as RenderBox?;\n'
            '  if (renderBox != null) {\n'
            '    final size = renderBox.size;\n'
            '    final position = renderBox.localToGlobal(Offset.zero);\n'
            '    print("زر العرض: \${size.width}x\${size.height} في الإحداثيات \$position");\n'
            '  }\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'إنشاء `UniqueKey()` داخل دالة `build()`، مما يجبر Flutter على تدمير وإعادة بناء الـ State في كل Frame!',
            en: 'Instantiating `UniqueKey()` inside `build()`, destroying and recreating State every frame.',
          ),
          LocalText(
            ar: 'الإفراط في استخدام `GlobalKey` في كل مكان، مما يرفع تكلفة البحث في الشجرة ويستهلك الذاكرة.',
            en: 'Overusing GlobalKey for local component state, degrading tree diff performance.',
          ),
        ],
      ),
    ],
  ),

  // ===========================================================================
  // LEVEL 4: Clean Architecture & State Management
  // ===========================================================================
  CurriculumLevel(
    number: 4,
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
  // LEVEL 5: Networking, Offline-First & Caching
  // ===========================================================================
  CurriculumLevel(
    number: 5,
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
  // LEVEL 6: Security, Performance & Concurrency
  // ===========================================================================
  CurriculumLevel(
    number: 6,
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
  // LEVEL 7: Testing, CI/CD & Deployment
  // ===========================================================================
  CurriculumLevel(
    number: 7,
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
