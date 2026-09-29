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
  CurriculumLevel(
    number: 1,
    title: LocalText(ar: 'الأساسيات وبناء الشاشة', en: 'Foundations and UI'),
    subtitle: LocalText(
      ar: 'ابدأ من Dart و Widgets وافهم كيف تتحول الفكرة إلى شاشة واضحة.',
      en: 'Start with Dart and widgets, then turn ideas into clear screens.',
    ),
    icon: Icons.widgets_rounded,
    color: Color(0xFF14B8A6),
    topics: [
      CurriculumTopic(
        title: LocalText(ar: 'Dart بسرعة للمطور', en: 'Dart essentials'),
        summary: LocalText(
          ar: 'المتغيرات، null safety، الدوال، الكلاسات، والقوائم.',
          en: 'Variables, null safety, functions, classes, and collections.',
        ),
        explain: LocalText(
          ar: 'Dart هي لغة التطبيق. أهم نقطة تفهمها هي أن النوع nullable مختلف عن النوع العادي، وأن async/await جزء أساسي في أي تطبيق يتعامل مع شبكة أو تخزين.',
          en: 'Dart is the application language. The key ideas are null safety, typed data, and async/await for network or storage work.',
        ),
        whenToUse: [
          LocalText(
            ar: 'عند تعريف models للبيانات القادمة من API.',
            en: 'When defining models for API data.',
          ),
          LocalText(
            ar: 'عند كتابة helpers أو services قابلة لإعادة الاستخدام.',
            en: 'When writing reusable helpers and services.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'حدد نوع كل قيمة بوضوح.',
            en: 'Give every value a clear type.',
          ),
          LocalText(
            ar: 'استخدم final لأي قيمة لا تتغير.',
            en: 'Use final for values that do not change.',
          ),
          LocalText(
            ar: 'تعامل مع null قبل عرض البيانات.',
            en: 'Handle null before rendering data.',
          ),
        ],
        code:
            'class Course {\n'
            '  const Course({required this.id, required this.title});\n'
            '\n'
            '  final int id;\n'
            '  final String title;\n'
            '\n'
            '  factory Course.fromJson(Map<String, dynamic> json) {\n'
            '    return Course(id: json["id"], title: json["title"]);\n'
            '  }\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استخدام dynamic في كل مكان فيصعب اكتشاف الأخطاء.',
            en: 'Using dynamic everywhere, which hides errors.',
          ),
          LocalText(
            ar: 'تجاهل null ثم حدوث crash وقت التشغيل.',
            en: 'Ignoring null and crashing at runtime.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'Widgets و Layout', en: 'Widgets and layout'),
        summary: LocalText(
          ar: 'افهم Scaffold و Row و Column و Stack و ListView.',
          en: 'Understand Scaffold, Row, Column, Stack, and ListView.',
        ),
        explain: LocalText(
          ar: 'كل واجهة في Flutter عبارة عن شجرة Widgets. الهدف ليس حفظ كل Widget، بل معرفة كيف تختار Widget مناسب للمساحة والحركة والتفاعل.',
          en: 'Every Flutter screen is a widget tree. The goal is not memorizing widgets, but choosing the right widget for space, movement, and interaction.',
        ),
        whenToUse: [
          LocalText(
            ar: 'Column للمحتوى الرأسي المحدود.',
            en: 'Column for limited vertical content.',
          ),
          LocalText(
            ar: 'ListView للمحتوى الطويل القابل للتمرير.',
            en: 'ListView for long scrollable content.',
          ),
          LocalText(
            ar: 'Stack للعناصر المتراكبة مثل badge فوق صورة.',
            en: 'Stack for layered elements like a badge over an image.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'ابدأ بـ Scaffold ثم قسم الصفحة لمناطق.',
            en: 'Start with Scaffold, then split the page into regions.',
          ),
          LocalText(
            ar: 'استخدم Expanded عند وجود مساحة مشتركة في Row أو Column.',
            en: 'Use Expanded when Row or Column children share space.',
          ),
          LocalText(
            ar: 'اختبر الشاشة على عرض صغير وكبير.',
            en: 'Test on small and large widths.',
          ),
        ],
        code:
            'Scaffold(\n'
            '  appBar: AppBar(title: const Text("Courses")),\n'
            '  body: ListView.separated(\n'
            '    itemCount: courses.length,\n'
            '    separatorBuilder: (_, __) => const Divider(),\n'
            '    itemBuilder: (_, index) => CourseTile(course: courses[index]),\n'
            '  ),\n'
            ');',
        commonMistakes: [
          LocalText(
            ar: 'وضع ListView داخل Column بدون Expanded.',
            en: 'Putting ListView inside Column without Expanded.',
          ),
          LocalText(
            ar: 'استخدام أحجام ثابتة كثيرة تسبب overflow.',
            en: 'Using too many fixed sizes that cause overflow.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'التنقل بين الشاشات', en: 'Navigation'),
        summary: LocalText(
          ar: 'انتقال، رجوع، تمرير بيانات، وتنظيم routes.',
          en: 'Push, pop, pass data, and organize routes.',
        ),
        explain: LocalText(
          ar: 'التنقل هو تجربة المستخدم داخل التطبيق. الشاشة الجديدة يجب أن تعرف أقل قدر ممكن من الشاشة السابقة، وتأخذ فقط البيانات التي تحتاجها.',
          en: 'Navigation is how users move through the app. A new screen should know as little as possible about the previous screen and receive only what it needs.',
        ),
        whenToUse: [
          LocalText(
            ar: 'عند فتح تفاصيل كورس من قائمة.',
            en: 'When opening course details from a list.',
          ),
          LocalText(
            ar: 'عند تنفيذ flow مثل تسجيل الدخول ثم الصفحة الرئيسية.',
            en: 'When building a flow like login then home.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'اجعل كل شاشة Widget مستقلة.',
            en: 'Make every screen an independent widget.',
          ),
          LocalText(
            ar: 'مرر id أو object صغير عند الحاجة.',
            en: 'Pass an id or small object when needed.',
          ),
          LocalText(
            ar: 'استخدم pop لإرجاع نتيجة عند اللزوم.',
            en: 'Use pop to return a result when needed.',
          ),
        ],
        code:
            'final saved = await Navigator.push<bool>(\n'
            '  context,\n'
            '  MaterialPageRoute(\n'
            '    builder: (_) => CourseDetailsScreen(courseId: course.id),\n'
            '  ),\n'
            ');',
        commonMistakes: [
          LocalText(
            ar: 'تمرير BuildContext لطبقات بعيدة عن الواجهة.',
            en: 'Passing BuildContext into layers far from UI.',
          ),
          LocalText(
            ar: 'تكرار routes بدون نظام واضح.',
            en: 'Duplicating routes without a clear system.',
          ),
        ],
      ),
    ],
  ),
  CurriculumLevel(
    number: 2,
    title: LocalText(ar: 'التفاعل وإدارة الحالة', en: 'Interaction and State'),
    subtitle: LocalText(
      ar: 'تعلم كيف تتغير الشاشة نتيجة إدخال المستخدم أو البيانات.',
      en: 'Learn how screens react to user input and data changes.',
    ),
    icon: Icons.touch_app_rounded,
    color: Color(0xFFF59E0B),
    topics: [
      CurriculumTopic(
        title: LocalText(
          ar: 'StatefulWidget ومتى يكفي',
          en: 'StatefulWidget basics',
        ),
        summary: LocalText(
          ar: 'استخدمه للحالة المحلية البسيطة مثل tab أو loading مؤقت.',
          en: 'Use it for simple local state like a tab or temporary loading.',
        ),
        explain: LocalText(
          ar: 'StatefulWidget مناسب عندما تكون الحالة تخص نفس الشاشة فقط. لو الحالة مطلوبة في شاشات متعددة أو مرتبطة بدومين التطبيق، انقلها لمدير حالة.',
          en: 'StatefulWidget is great when state belongs only to one screen. If state is shared or domain-related, move it to a state manager.',
        ),
        whenToUse: [
          LocalText(
            ar: 'تبديل selected tab داخل شاشة واحدة.',
            en: 'Switching a selected tab inside one screen.',
          ),
          LocalText(
            ar: 'إظهار وإخفاء password.',
            en: 'Showing or hiding a password.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'عرّف state داخل State class.',
            en: 'Define state inside the State class.',
          ),
          LocalText(
            ar: 'استخدم setState لتحديث الجزء المتغير.',
            en: 'Use setState to update changed values.',
          ),
          LocalText(
            ar: 'تخلص من controllers داخل dispose.',
            en: 'Dispose controllers in dispose.',
          ),
        ],
        code:
            'class CounterScreen extends StatefulWidget {\n'
            '  const CounterScreen({super.key});\n'
            '  @override\n'
            '  State<CounterScreen> createState() => _CounterScreenState();\n'
            '}\n'
            '\n'
            'class _CounterScreenState extends State<CounterScreen> {\n'
            '  int count = 0;\n'
            '  @override\n'
            '  Widget build(BuildContext context) => TextButton(\n'
            '    onPressed: () => setState(() => count++),\n'
            '    child: Text("\$count"),\n'
            '  );\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'وضع كل حالة التطبيق في StatefulWidget واحد.',
            en: 'Putting the whole app state in one StatefulWidget.',
          ),
          LocalText(
            ar: 'نسيان dispose للـ TextEditingController.',
            en: 'Forgetting to dispose TextEditingController.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(
          ar: 'Forms والتحقق من الإدخال',
          en: 'Forms and validation',
        ),
        summary: LocalText(
          ar: 'ابنِ فورم واضح برسائل خطأ مفيدة وتجربة سلسة.',
          en: 'Build clear forms with useful errors and smooth UX.',
        ),
        explain: LocalText(
          ar: 'الفورم الجيد لا ينتظر السيرفر ليخبر المستخدم بكل الأخطاء. تحقق من المدخلات محليًا، ثم أرسل بيانات نظيفة.',
          en: 'A good form does not wait for the server to report every error. Validate locally, then submit clean data.',
        ),
        whenToUse: [
          LocalText(ar: 'تسجيل الدخول والتسجيل.', en: 'Login and signup.'),
          LocalText(
            ar: 'إنشاء طلب أو حجز أو كورس.',
            en: 'Creating an order, booking, or course.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم GlobalKey<FormState>.',
            en: 'Use GlobalKey<FormState>.',
          ),
          LocalText(
            ar: 'ضع validator لكل حقل مهم.',
            en: 'Add validator for each important field.',
          ),
          LocalText(
            ar: 'لا ترسل الطلب إلا لو validate رجعت true.',
            en: 'Submit only when validate returns true.',
          ),
        ],
        code:
            'final formKey = GlobalKey<FormState>();\n'
            '\n'
            'Form(\n'
            '  key: formKey,\n'
            '  child: TextFormField(\n'
            '    validator: (value) => value == null || value.isEmpty\n'
            '      ? "Required"\n'
            '      : null,\n'
            '  ),\n'
            ');',
        commonMistakes: [
          LocalText(
            ar: 'رسائل خطأ عامة لا توضح المطلوب.',
            en: 'Generic error messages that do not explain the fix.',
          ),
          LocalText(
            ar: 'تنفيذ API قبل التأكد من صحة الفورم.',
            en: 'Calling the API before validating the form.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'Bloc و Cubit', en: 'Bloc and Cubit'),
        summary: LocalText(
          ar: 'افصل منطق الشاشة عن الواجهة واجعل الحالات واضحة.',
          en: 'Separate screen logic from UI and make states explicit.',
        ),
        explain: LocalText(
          ar: 'Cubit مناسب لمعظم الشاشات: loading, success, failure. الواجهة تستمع للحالة وتعرض المناسب، والمنطق يظل قابلًا للاختبار.',
          en: 'Cubit fits most screens: loading, success, failure. UI listens to state, while logic remains testable.',
        ),
        whenToUse: [
          LocalText(ar: 'بيانات تأتي من API.', en: 'Data loaded from an API.'),
          LocalText(
            ar: 'شاشة لها حالات متعددة وواضحة.',
            en: 'A screen with multiple clear states.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'عرّف states بأسماء واضحة.',
            en: 'Define states with clear names.',
          ),
          LocalText(
            ar: 'اجعل Cubit يستدعي repository وليس UI.',
            en: 'Let Cubit call repository, not the UI.',
          ),
          LocalText(
            ar: 'استخدم BlocBuilder للعرض و BlocListener للأحداث.',
            en: 'Use BlocBuilder for rendering and BlocListener for one-off events.',
          ),
        ],
        code:
            'class CoursesCubit extends Cubit<CoursesState> {\n'
            '  CoursesCubit(this.repo) : super(CoursesInitial());\n'
            '  final CoursesRepository repo;\n'
            '\n'
            '  Future<void> load() async {\n'
            '    emit(CoursesLoading());\n'
            '    final result = await repo.getCourses();\n'
            '    result.fold(\n'
            '      (failure) => emit(CoursesFailure(failure.message)),\n'
            '      (courses) => emit(CoursesLoaded(courses)),\n'
            '    );\n'
            '  }\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'وضع BuildContext داخل Cubit.',
            en: 'Putting BuildContext inside Cubit.',
          ),
          LocalText(
            ar: 'State واحدة تحمل كل شيء بدل حالات واضحة.',
            en: 'Using one huge state instead of clear states.',
          ),
        ],
      ),
    ],
  ),
  CurriculumLevel(
    number: 3,
    title: LocalText(
      ar: 'البيانات والشبكة والتخزين',
      en: 'Data, Network, Storage',
    ),
    subtitle: LocalText(
      ar: 'أي تطبيق حقيقي يحتاج API، تخزين، وتحويل بيانات بشكل آمن.',
      en: 'Real apps need APIs, storage, and safe data mapping.',
    ),
    icon: Icons.cloud_sync_rounded,
    color: Color(0xFF60A5FA),
    topics: [
      CurriculumTopic(
        title: LocalText(ar: 'REST API منظم', en: 'Organized REST API'),
        summary: LocalText(
          ar: 'افصل HTTP client عن repository عن الواجهة.',
          en: 'Separate HTTP client, repository, and UI.',
        ),
        explain: LocalText(
          ar: 'الشاشة لا يجب أن تعرف تفاصيل endpoint أو status code. اجعل طبقة الشبكة ترجع نتيجة واضحة للطبقات الأعلى.',
          en: 'The screen should not know endpoint or status code details. The network layer should return a clear result to higher layers.',
        ),
        whenToUse: [
          LocalText(
            ar: 'تحميل قوائم ومستخدمين ومنتجات.',
            en: 'Loading lists, users, and products.',
          ),
          LocalText(
            ar: 'إرسال فورم أو عملية شراء.',
            en: 'Submitting forms or purchase actions.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'اكتب service مسؤول عن request.',
            en: 'Write a service responsible for requests.',
          ),
          LocalText(ar: 'حوّل JSON إلى model.', en: 'Map JSON into a model.'),
          LocalText(
            ar: 'ارجع success أو failure بدل رمي أخطاء للواجهة.',
            en: 'Return success or failure instead of throwing into UI.',
          ),
        ],
        code:
            'Future<List<Course>> getCourses() async {\n'
            '  final response = await client.get(Uri.parse("\$baseUrl/courses"));\n'
            '  if (response.statusCode != 200) throw ServerException();\n'
            '\n'
            '  final list = jsonDecode(response.body) as List<dynamic>;\n'
            '  return list.map((item) => Course.fromJson(item)).toList();\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'كتابة request داخل Widget مباشرة.',
            en: 'Writing requests directly inside widgets.',
          ),
          LocalText(
            ar: 'عدم معالجة timeout أو offline.',
            en: 'Not handling timeout or offline cases.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'التخزين المحلي', en: 'Local storage'),
        summary: LocalText(
          ar: 'اختيار التخزين المناسب: settings، cache، database.',
          en: 'Choose the right storage: settings, cache, or database.',
        ),
        explain: LocalText(
          ar: 'ليس كل شيء يحتاج database. الإعدادات البسيطة تناسب SharedPreferences، والبيانات الكبيرة أو المترابطة تحتاج database محلية.',
          en: 'Not everything needs a database. Simple settings fit SharedPreferences, while large relational data needs a local database.',
        ),
        whenToUse: [
          LocalText(
            ar: 'حفظ اللغة والثيم والتوكن.',
            en: 'Saving language, theme, and token.',
          ),
          LocalText(
            ar: 'تشغيل التطبيق بدون إنترنت لبعض البيانات.',
            en: 'Keeping some data available offline.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'حدد هل البيانات حساسة أم لا.',
            en: 'Decide whether the data is sensitive.',
          ),
          LocalText(
            ar: 'استخدم secure storage للتوكن.',
            en: 'Use secure storage for tokens.',
          ),
          LocalText(
            ar: 'ضع مدة صلاحية للـ cache.',
            en: 'Give cache an expiry time.',
          ),
        ],
        code:
            'abstract class SettingsStore {\n'
            '  Future<void> saveLanguage(String code);\n'
            '  Future<String?> readLanguage();\n'
            '}\n'
            '\n'
            'class SettingsRepository {\n'
            '  SettingsRepository(this.store);\n'
            '  final SettingsStore store;\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'حفظ بيانات حساسة في تخزين غير آمن.',
            en: 'Saving sensitive data in insecure storage.',
          ),
          LocalText(
            ar: 'عدم تحديث cache بعد تغيير البيانات.',
            en: 'Not refreshing cache after data changes.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'Offline و Sync', en: 'Offline and sync'),
        summary: LocalText(
          ar: 'صمم التطبيق ليشرح للمستخدم ما يحدث عند انقطاع الإنترنت.',
          en: 'Design the app to explain what happens when internet is unavailable.',
        ),
        explain: LocalText(
          ar: 'التطبيق المحترف لا ينهار عند انقطاع الشبكة. يعرض بيانات محفوظة إن وجدت، ويوضح هل العملية محفوظة للرفع لاحقًا أم فشلت.',
          en: 'A professional app does not collapse offline. It shows cached data when possible and explains whether an action is queued or failed.',
        ),
        whenToUse: [
          LocalText(
            ar: 'تطبيقات التعليم والمحتوى.',
            en: 'Learning and content apps.',
          ),
          LocalText(
            ar: 'النماذج التي يمكن إرسالها لاحقًا.',
            en: 'Forms that can be submitted later.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'اقرأ من cache أولًا للعرض السريع.',
            en: 'Read cache first for fast rendering.',
          ),
          LocalText(
            ar: 'حدث البيانات من الشبكة في الخلفية.',
            en: 'Refresh from network in the background.',
          ),
          LocalText(
            ar: 'ضع queue للعمليات المؤجلة.',
            en: 'Use a queue for delayed actions.',
          ),
        ],
        code:
            'Future<CoursesView> loadCourses() async {\n'
            '  final cached = await local.readCourses();\n'
            '  try {\n'
            '    final fresh = await remote.getCourses();\n'
            '    await local.saveCourses(fresh);\n'
            '    return CoursesView(fresh, isOffline: false);\n'
            '  } catch (_) {\n'
            '    return CoursesView(cached, isOffline: true);\n'
            '  }\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'إخفاء سبب المشكلة عن المستخدم.',
            en: 'Hiding the reason from the user.',
          ),
          LocalText(
            ar: 'اعتبار كل فشل شبكة خطأ نهائي.',
            en: 'Treating every network failure as final.',
          ),
        ],
      ),
    ],
  ),
  CurriculumLevel(
    number: 4,
    title: LocalText(
      ar: 'المعمارية وجودة الكود',
      en: 'Architecture and Quality',
    ),
    subtitle: LocalText(
      ar: 'رتب المشروع ليكبر بدون فوضى ويظل سهل الاختبار.',
      en: 'Structure the project so it can grow without chaos and remain testable.',
    ),
    icon: Icons.schema_rounded,
    color: Color(0xFFA78BFA),
    topics: [
      CurriculumTopic(
        title: LocalText(
          ar: 'Feature-first structure',
          en: 'Feature-first structure',
        ),
        summary: LocalText(
          ar: 'قسم المشروع حسب الميزة وليس حسب نوع الملف فقط.',
          en: 'Organize by feature, not only by file type.',
        ),
        explain: LocalText(
          ar: 'كل ميزة لها data و domain و presentation. هذا يجعل التنقل أسهل ويقلل تضارب الفرق عند كبر المشروع.',
          en: 'Each feature owns data, domain, and presentation. This makes navigation easier and reduces team conflicts as the project grows.',
        ),
        whenToUse: [
          LocalText(
            ar: 'أي تطبيق متوسط أو كبير.',
            en: 'Any medium or large app.',
          ),
          LocalText(
            ar: 'عند وجود أكثر من مطور في نفس المشروع.',
            en: 'When multiple developers work on the same project.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'ضع shared code داخل core.',
            en: 'Put shared code inside core.',
          ),
          LocalText(
            ar: 'ضع شاشات كل ميزة داخل features/name.',
            en: 'Put each feature screens under features/name.',
          ),
          LocalText(
            ar: 'لا تجعل features تعتمد على بعضها إلا عند الضرورة.',
            en: 'Avoid feature-to-feature dependencies unless needed.',
          ),
        ],
        code:
            'lib/\n'
            '  core/\n'
            '    errors/ network/ theme/\n'
            '  features/\n'
            '    auth/\n'
            '      data/ domain/ presentation/\n'
            '    courses/\n'
            '      data/ domain/ presentation/',
        commonMistakes: [
          LocalText(
            ar: 'ملف helpers ضخم يحمل كل شيء.',
            en: 'A giant helpers file that contains everything.',
          ),
          LocalText(
            ar: 'خلط API و UI في نفس Widget.',
            en: 'Mixing API and UI in the same widget.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(
          ar: 'Clean Architecture ببساطة',
          en: 'Clean Architecture simply',
        ),
        summary: LocalText(
          ar: 'افصل قواعد التطبيق عن تفاصيل الشبكة والواجهة.',
          en: 'Separate app rules from network and UI details.',
        ),
        explain: LocalText(
          ar: 'الفكرة ليست زيادة ملفات بلا سبب. الهدف أن domain لا يعرف HTTP ولا Flutter، و data تنفذ التفاصيل، و presentation تعرض الحالة.',
          en: 'The point is not adding files for no reason. Domain should not know HTTP or Flutter; data handles details; presentation renders state.',
        ),
        whenToUse: [
          LocalText(
            ar: 'عند وجود business rules واضحة.',
            en: 'When clear business rules exist.',
          ),
          LocalText(
            ar: 'عند الحاجة لاختبارات منطقية قوية.',
            en: 'When strong logic tests are needed.',
          ),
        ],
        steps: [
          LocalText(ar: 'Entity في domain.', en: 'Entity in domain.'),
          LocalText(
            ar: 'Repository contract في domain.',
            en: 'Repository contract in domain.',
          ),
          LocalText(
            ar: 'Repository implementation في data.',
            en: 'Repository implementation in data.',
          ),
        ],
        code:
            'abstract class CoursesRepository {\n'
            '  Future<Either<Failure, List<Course>>> getCourses();\n'
            '}\n'
            '\n'
            'class CoursesRepositoryImpl implements CoursesRepository {\n'
            '  CoursesRepositoryImpl(this.remote);\n'
            '  final CoursesRemoteDataSource remote;\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'تطبيق المعمارية كاملة على شاشة بسيطة جدًا.',
            en: 'Applying full architecture to a tiny simple screen.',
          ),
          LocalText(
            ar: 'جعل domain يعتمد على Flutter أو Dio.',
            en: 'Making domain depend on Flutter or Dio.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'Testing', en: 'Testing'),
        summary: LocalText(
          ar: 'اختبر المنطق المهم والواجهات الحرجة قبل النشر.',
          en: 'Test important logic and critical UI before release.',
        ),
        explain: LocalText(
          ar: 'الاختبارات لا تعني اختبار كل pixel. ابدأ بالمنطق الذي يكسر التطبيق لو فشل: validation، repositories، cubits، وflows المهمة.',
          en: 'Testing does not mean testing every pixel. Start with logic that breaks the app if wrong: validation, repositories, cubits, and critical flows.',
        ),
        whenToUse: [
          LocalText(
            ar: 'حساب أسعار أو صلاحيات أو نتائج.',
            en: 'Calculating prices, permissions, or results.',
          ),
          LocalText(
            ar: 'شاشات تسجيل ودفع وطلبات.',
            en: 'Login, payment, and order screens.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'اختبر pure functions أولًا.',
            en: 'Test pure functions first.',
          ),
          LocalText(
            ar: 'استخدم mocks للـ repositories.',
            en: 'Use mocks for repositories.',
          ),
          LocalText(
            ar: 'اكتب smoke test للشاشة الأساسية.',
            en: 'Write a smoke test for the main screen.',
          ),
        ],
        code:
            'test("email validator rejects invalid email", () {\n'
            '  final result = validateEmail("wrong");\n'
            '  expect(result, "Invalid email");\n'
            '});',
        commonMistakes: [
          LocalText(
            ar: 'اختبار تفاصيل تصميم بدل السلوك.',
            en: 'Testing design details instead of behavior.',
          ),
          LocalText(
            ar: 'ترك الاختبارات بطيئة وغير مستقرة.',
            en: 'Leaving tests slow and flaky.',
          ),
        ],
      ),
    ],
  ),
  CurriculumLevel(
    number: 5,
    title: LocalText(
      ar: 'الأداء والنشر والاحتراف',
      en: 'Performance and Release',
    ),
    subtitle: LocalText(
      ar: 'اجعل التطبيق سريعًا، قابلًا للمراقبة، وجاهزًا للمستخدمين.',
      en: 'Make the app fast, observable, and ready for users.',
    ),
    icon: Icons.rocket_launch_rounded,
    color: Color(0xFFFB7185),
    topics: [
      CurriculumTopic(
        title: LocalText(ar: 'Performance basics', en: 'Performance basics'),
        summary: LocalText(
          ar: 'قلل rebuilds، اعزل الرسم، وانقل العمل الثقيل.',
          en: 'Reduce rebuilds, isolate painting, and move heavy work away.',
        ),
        explain: LocalText(
          ar: 'الأداء في Flutter غالبًا يتأثر بثلاثة أشياء: build كثير بلا داعي، paint مكلف، أو computation على main isolate.',
          en: 'Flutter performance is usually affected by three things: unnecessary builds, expensive paint, or computation on the main isolate.',
        ),
        whenToUse: [
          LocalText(
            ar: 'قوائم طويلة وصور كثيرة.',
            en: 'Long lists and many images.',
          ),
          LocalText(ar: 'رسوم متحركة أو charts.', en: 'Animations or charts.'),
        ],
        steps: [
          LocalText(
            ar: 'استخدم const قدر الإمكان.',
            en: 'Use const where possible.',
          ),
          LocalText(
            ar: 'استخدم ListView.builder للقوائم الطويلة.',
            en: 'Use ListView.builder for long lists.',
          ),
          LocalText(
            ar: 'استخدم Isolate للعمليات الثقيلة.',
            en: 'Use Isolate for heavy operations.',
          ),
        ],
        code:
            'ListView.builder(\n'
            '  itemCount: items.length,\n'
            '  itemBuilder: (_, index) => ItemTile(item: items[index]),\n'
            ');',
        commonMistakes: [
          LocalText(
            ar: 'تحميل كل العناصر مرة واحدة.',
            en: 'Loading all items at once.',
          ),
          LocalText(
            ar: 'استخدام setState على صفحة ضخمة لتغيير بسيط.',
            en: 'Calling setState on a huge page for a tiny change.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'Security essentials', en: 'Security essentials'),
        summary: LocalText(
          ar: 'احم التوكن، المدخلات، والبيانات الحساسة.',
          en: 'Protect tokens, inputs, and sensitive data.',
        ),
        explain: LocalText(
          ar: 'أمان تطبيق الموبايل يبدأ من عدم تخزين أسرار في الكود، وعدم الثقة في المدخلات، وحماية بيانات المستخدم الحساسة.',
          en: 'Mobile app security starts by not hardcoding secrets, not trusting input, and protecting sensitive user data.',
        ),
        whenToUse: [
          LocalText(ar: 'أي تطبيق به تسجيل دخول.', en: 'Any app with login.'),
          LocalText(
            ar: 'تطبيقات مالية أو طبية أو بيانات شخصية.',
            en: 'Financial, medical, or personal-data apps.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'لا تضع API secrets داخل التطبيق.',
            en: 'Do not put API secrets inside the app.',
          ),
          LocalText(ar: 'استخدم HTTPS فقط.', en: 'Use HTTPS only.'),
          LocalText(
            ar: 'احفظ tokens في secure storage.',
            en: 'Store tokens in secure storage.',
          ),
        ],
        code:
            'class AuthHeaders {\n'
            '  const AuthHeaders(this.token);\n'
            '  final String token;\n'
            '\n'
            '  Map<String, String> get value => {\n'
            '    "Authorization": "Bearer \$token",\n'
            '  };\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'وضع مفاتيح سرية داخل Git.',
            en: 'Committing secrets into Git.',
          ),
          LocalText(
            ar: 'الاعتماد على إخفاء زر بدل حماية API.',
            en: 'Relying on hiding a button instead of protecting the API.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'Release checklist', en: 'Release checklist'),
        summary: LocalText(
          ar: 'قبل النشر: اختبارات، صلاحيات، أيقونة، اسم، مراقبة أخطاء.',
          en: 'Before release: tests, permissions, icon, name, and crash monitoring.',
        ),
        explain: LocalText(
          ar: 'النشر ليس build فقط. يجب أن تتأكد من تجربة أول تشغيل، الصلاحيات، الأداء، رسائل الأخطاء، وسياسة الخصوصية.',
          en: 'Release is not just a build. Verify first-run experience, permissions, performance, error messages, and privacy policy.',
        ),
        whenToUse: [
          LocalText(
            ar: 'قبل رفع التطبيق للمتجر.',
            en: 'Before submitting to the store.',
          ),
          LocalText(
            ar: 'قبل تسليم نسخة للعميل.',
            en: 'Before handing a build to a client.',
          ),
        ],
        steps: [
          LocalText(ar: 'شغل analyze و tests.', en: 'Run analyze and tests.'),
          LocalText(
            ar: 'راجع Android permissions و iOS plist.',
            en: 'Review Android permissions and iOS plist.',
          ),
          LocalText(
            ar: 'اختبر release mode على جهاز حقيقي.',
            en: 'Test release mode on a real device.',
          ),
        ],
        code:
            'flutter analyze\n'
            'flutter test\n'
            'flutter build apk --release\n'
            'flutter build appbundle --release',
        commonMistakes: [
          LocalText(ar: 'اختبار debug فقط.', en: 'Testing debug only.'),
          LocalText(
            ar: 'طلب صلاحيات غير مستخدمة.',
            en: 'Requesting permissions you do not use.',
          ),
        ],
      ),
    ],
  ),
  CurriculumLevel(
    number: 6,
    title: LocalText(
      ar: 'تجربة المستخدم والواجهات الاحترافية',
      en: 'Professional UI and UX',
    ),
    subtitle: LocalText(
      ar: 'ابنِ واجهات مفهومة، متجاوبة، قابلة للوصول، وسهلة الاستخدام.',
      en: 'Build clear, responsive, accessible, and easy to use interfaces.',
    ),
    icon: Icons.design_services_rounded,
    color: Color(0xFF38BDF8),
    topics: [
      CurriculumTopic(
        title: LocalText(
          ar: 'Design system داخل Flutter',
          en: 'Design system in Flutter',
        ),
        summary: LocalText(
          ar: 'ثيم، ألوان، مسافات، TextTheme، ومكونات موحدة.',
          en: 'Theme, colors, spacing, TextTheme, and reusable components.',
        ),
        explain: LocalText(
          ar: 'التطبيق الاحترافي لا يكرر الألوان والأحجام في كل شاشة. اجعل الهوية البصرية في مكان واحد، واستخدم مكونات ثابتة للأزرار والكروت والحقول.',
          en: 'A professional app does not repeat colors and sizes in every screen. Keep visual identity in one place and reuse stable buttons, cards, and fields.',
        ),
        whenToUse: [
          LocalText(
            ar: 'عند بداية أي مشروع متوسط أو كبير.',
            en: 'At the start of any medium or large project.',
          ),
          LocalText(
            ar: 'عند وجود أكثر من شاشة لها نفس شكل الأزرار والحقول.',
            en: 'When many screens share the same buttons and inputs.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'حدد ColorScheme و TextTheme.',
            en: 'Define ColorScheme and TextTheme.',
          ),
          LocalText(
            ar: 'اكتب AppButton و AppTextField بدل تكرار التصميم.',
            en: 'Create AppButton and AppTextField instead of repeating design.',
          ),
          LocalText(
            ar: 'اجعل المسافات والأحجام constants واضحة.',
            en: 'Keep spacing and sizes as clear constants.',
          ),
        ],
        code:
            'final appTheme = ThemeData(\n'
            '  useMaterial3: true,\n'
            '  colorScheme: ColorScheme.fromSeed(seedColor: Colors.teal),\n'
            '  textTheme: const TextTheme(\n'
            '    titleLarge: TextStyle(fontWeight: FontWeight.w800),\n'
            '  ),\n'
            ');',
        commonMistakes: [
          LocalText(
            ar: 'تكرار نفس اللون في عشرات الملفات.',
            en: 'Repeating the same color in many files.',
          ),
          LocalText(
            ar: 'تغيير التصميم من شاشة وترك باقي الشاشات مختلفة.',
            en: 'Changing one screen and leaving the rest inconsistent.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'Responsive UI', en: 'Responsive UI'),
        summary: LocalText(
          ar: 'تعامل مع الموبايل والتابلت والشاشات الكبيرة بدون overflow.',
          en: 'Handle phones, tablets, and wide screens without overflow.',
        ),
        explain: LocalText(
          ar: 'الواجهة المتجاوبة لا تعني تكبير كل شيء. هي تعني إعادة توزيع المحتوى حسب المساحة: عمود في الموبايل، وgrid أو two panes في الشاشات الكبيرة.',
          en: 'Responsive UI does not mean scaling everything. It means redistributing content: column on phones, grid or two panes on wide screens.',
        ),
        whenToUse: [
          LocalText(
            ar: 'صفحات dashboard أو قوائم طويلة.',
            en: 'Dashboard pages or long lists.',
          ),
          LocalText(
            ar: 'تطبيق يعمل على web أو tablet بجانب الموبايل.',
            en: 'Apps that run on web or tablet in addition to mobile.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'استخدم LayoutBuilder لمعرفة المساحة المتاحة.',
            en: 'Use LayoutBuilder to read available width.',
          ),
          LocalText(
            ar: 'بدل Column إلى Grid عند العرض الكبير.',
            en: 'Switch Column to Grid on wide widths.',
          ),
          LocalText(
            ar: 'تجنب font size مبني على عرض الشاشة.',
            en: 'Avoid font size based on screen width.',
          ),
        ],
        code:
            'LayoutBuilder(\n'
            '  builder: (context, constraints) {\n'
            '    final wide = constraints.maxWidth >= 700;\n'
            '    return wide ? CoursesGrid() : CoursesList();\n'
            '  },\n'
            ');',
        commonMistakes: [
          LocalText(
            ar: 'وضع width ثابت لكل العناصر.',
            en: 'Using fixed width for everything.',
          ),
          LocalText(
            ar: 'نسيان اختبار النصوص الطويلة واللغة العربية.',
            en: 'Forgetting long text and Arabic layouts.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'Accessibility', en: 'Accessibility'),
        summary: LocalText(
          ar: 'اجعل التطبيق مفهومًا لقارئ الشاشة ومناسبًا لتكبير الخط.',
          en: 'Make the app readable by screen readers and usable with larger text.',
        ),
        explain: LocalText(
          ar: 'الوصولية ليست إضافة فاخرة. المستخدم قد يستخدم قارئ شاشة أو خط كبير. Flutter يدعم Semantics، لكن عليك تسمية الأزرار والأيقونات غير الواضحة.',
          en: 'Accessibility is not a luxury. Users may use screen readers or large text. Flutter supports Semantics, but you must label unclear buttons and icons.',
        ),
        whenToUse: [
          LocalText(
            ar: 'كل زر أيقونة بدون نص ظاهر.',
            en: 'Every icon button without visible text.',
          ),
          LocalText(
            ar: 'الشاشات المهمة مثل الدفع والتسجيل.',
            en: 'Important screens like payment and signup.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'اكتب tooltip لكل IconButton.',
            en: 'Add tooltip to every IconButton.',
          ),
          LocalText(
            ar: 'استخدم Semantics عند الحاجة.',
            en: 'Use Semantics when needed.',
          ),
          LocalText(
            ar: 'اختبر زيادة حجم الخط من إعدادات الجهاز.',
            en: 'Test larger text from device settings.',
          ),
        ],
        code:
            'Semantics(\n'
            '  label: "Submit payment",\n'
            '  button: true,\n'
            '  child: IconButton(\n'
            '    tooltip: "Pay",\n'
            '    onPressed: pay,\n'
            '    icon: const Icon(Icons.payment),\n'
            '  ),\n'
            ');',
        commonMistakes: [
          LocalText(
            ar: 'أيقونات بلا معنى لقارئ الشاشة.',
            en: 'Icons with no meaning for screen readers.',
          ),
          LocalText(
            ar: 'تصميم ينكسر عند تكبير الخط.',
            en: 'Layouts that break when text is enlarged.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'Localization و RTL', en: 'Localization and RTL'),
        summary: LocalText(
          ar: 'نظم النصوص والاتجاهات بدل hard coded strings.',
          en: 'Organize strings and direction instead of hard coded text.',
        ),
        explain: LocalText(
          ar: 'دعم اللغات يبدأ من أول المشروع. النصوص يجب أن تكون مفصولة، والتواريخ والأرقام والاتجاه يجب أن يتغيروا حسب اللغة.',
          en: 'Language support starts early. Text must be separated, and dates, numbers, and direction should change with locale.',
        ),
        whenToUse: [
          LocalText(
            ar: 'أي تطبيق يستهدف جمهور عربي وإنجليزي.',
            en: 'Any app targeting Arabic and English users.',
          ),
          LocalText(
            ar: 'لو عندك محتوى أو رسائل أخطاء كثيرة.',
            en: 'When you have many labels or error messages.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'اجعل locale في مستوى التطبيق.',
            en: 'Keep locale at app level.',
          ),
          LocalText(
            ar: 'استخدم Directionality أو Material localization.',
            en: 'Use Directionality or Material localization.',
          ),
          LocalText(
            ar: 'لا تضع النص مباشرة داخل widgets الكبيرة.',
            en: 'Do not place text directly inside large widgets.',
          ),
        ],
        code:
            'MaterialApp(\n'
            '  locale: const Locale("ar"),\n'
            '  supportedLocales: const [Locale("ar"), Locale("en")],\n'
            '  localizationsDelegates: GlobalMaterialLocalizations.delegates,\n'
            ');',
        commonMistakes: [
          LocalText(
            ar: 'ترجمة النص وترك اتجاه الأيقونات خطأ.',
            en: 'Translating text but leaving icon direction wrong.',
          ),
          LocalText(
            ar: 'مزج العربية والإنجليزية بدون Directionality مناسب.',
            en: 'Mixing Arabic and English without proper Directionality.',
          ),
        ],
      ),
    ],
  ),
  CurriculumLevel(
    number: 7,
    title: LocalText(
      ar: 'ميزات التطبيقات اليومية',
      en: 'Everyday App Features',
    ),
    subtitle: LocalText(
      ar: 'الموضوعات التي تتكرر في أغلب تطبيقات العملاء والمنتجات.',
      en: 'Features that appear in most client and product apps.',
    ),
    icon: Icons.apps_rounded,
    color: Color(0xFF84CC16),
    topics: [
      CurriculumTopic(
        title: LocalText(ar: 'Authentication flow', en: 'Authentication flow'),
        summary: LocalText(
          ar: 'Login، register، token، refresh، logout، وحماية الصفحات.',
          en: 'Login, register, token, refresh, logout, and protected pages.',
        ),
        explain: LocalText(
          ar: 'الـ auth ليس شاشة login فقط. هو flow كامل: حفظ التوكن بأمان، التحقق من الجلسة عند التشغيل، تجديد التوكن، ومسح البيانات عند الخروج.',
          en: 'Auth is not only a login screen. It is a full flow: secure token storage, session check on startup, token refresh, and clearing data on logout.',
        ),
        whenToUse: [
          LocalText(
            ar: 'أي تطبيق له حسابات مستخدمين.',
            en: 'Any app with user accounts.',
          ),
          LocalText(
            ar: 'عند وجود صفحات لا تظهر إلا بعد تسجيل الدخول.',
            en: 'When some pages require login.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'نفذ AuthRepository كطبقة واحدة للحساب.',
            en: 'Create AuthRepository as the single auth layer.',
          ),
          LocalText(
            ar: 'احفظ access token في secure storage.',
            en: 'Save access token in secure storage.',
          ),
          LocalText(
            ar: 'اجعل splash يقرر هل المستخدم logged in أم لا.',
            en: 'Let splash decide whether the user is logged in.',
          ),
        ],
        code:
            'Future<void> signIn(String email, String password) async {\n'
            '  final token = await remote.login(email, password);\n'
            '  await secureStore.saveToken(token.accessToken);\n'
            '  emit(AuthAuthenticated());\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'حفظ التوكن في متغير فقط فيضيع عند إغلاق التطبيق.',
            en: 'Keeping token only in memory, then losing it on app close.',
          ),
          LocalText(
            ar: 'عدم مسح cache المستخدم بعد logout.',
            en: 'Not clearing user cache after logout.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'Permissions', en: 'Permissions'),
        summary: LocalText(
          ar: 'الكاميرا، الصور، الموقع، الإشعارات، والرفض الدائم.',
          en: 'Camera, photos, location, notifications, and permanent denial.',
        ),
        explain: LocalText(
          ar: 'الصلاحية يجب أن تطلب في وقت منطقي، مع شرح السبب قبل الطلب. لو المستخدم رفض، اعرض بديلًا واضحًا ولا تترك الشاشة معلقة.',
          en: 'Ask permission at the right moment with a clear reason. If denied, show a useful fallback instead of leaving the screen stuck.',
        ),
        whenToUse: [
          LocalText(
            ar: 'رفع صورة بروفايل أو فتح الكاميرا.',
            en: 'Uploading profile photo or opening camera.',
          ),
          LocalText(
            ar: 'تحديد عنوان المستخدم على الخريطة.',
            en: 'Picking user address on a map.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'اشرح السبب قبل النظام.',
            en: 'Explain the reason before the system prompt.',
          ),
          LocalText(
            ar: 'تعامل مع denied و permanentlyDenied.',
            en: 'Handle denied and permanentlyDenied.',
          ),
          LocalText(
            ar: 'أضف permission في AndroidManifest و Info.plist.',
            en: 'Add permissions in AndroidManifest and Info.plist.',
          ),
        ],
        code:
            'final status = await Permission.camera.request();\n'
            'if (status.isGranted) {\n'
            '  openCamera();\n'
            '} else if (status.isPermanentlyDenied) {\n'
            '  openAppSettings();\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'طلب الصلاحية أول ما التطبيق يفتح بلا سبب.',
            en: 'Requesting permission at app start with no context.',
          ),
          LocalText(
            ar: 'عدم كتابة نصوص iOS permissions.',
            en: 'Forgetting iOS permission descriptions.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'Push notifications', en: 'Push notifications'),
        summary: LocalText(
          ar: 'FCM token، استقبال الرسائل، فتح شاشة من notification.',
          en: 'FCM token, receiving messages, and opening screens from notifications.',
        ),
        explain: LocalText(
          ar: 'الإشعارات لها جزئين: جهاز يستقبل token، وسيرفر يرسل رسالة. التطبيق يجب أن يعرف ماذا يفعل لو وصل الإشعار وهو مفتوح أو في الخلفية.',
          en: 'Notifications have two sides: the device receives a token, and the server sends messages. The app must handle foreground and background messages.',
        ),
        whenToUse: [
          LocalText(
            ar: 'رسائل الطلبات والدفع والدروس الجديدة.',
            en: 'Order, payment, and new lesson messages.',
          ),
          LocalText(
            ar: 'تنبيه المستخدم بتغيير حالة مهمة.',
            en: 'Alerting users about important state changes.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'اطلب permission للإشعارات.',
            en: 'Request notification permission.',
          ),
          LocalText(
            ar: 'ارسل FCM token للسيرفر.',
            en: 'Send FCM token to the server.',
          ),
          LocalText(
            ar: 'استخدم payload لتحديد الشاشة المطلوبة.',
            en: 'Use payload to choose the target screen.',
          ),
        ],
        code:
            'FirebaseMessaging.onMessageOpenedApp.listen((message) {\n'
            '  final orderId = message.data["order_id"];\n'
            '  if (orderId != null) openOrderDetails(orderId);\n'
            '});',
        commonMistakes: [
          LocalText(
            ar: 'الاعتماد على عنوان الرسالة بدل data payload.',
            en: 'Relying on notification title instead of data payload.',
          ),
          LocalText(
            ar: 'نسيان حالات foreground.',
            en: 'Forgetting foreground message handling.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(
          ar: 'Files, images, upload',
          en: 'Files, images, upload',
        ),
        summary: LocalText(
          ar: 'اختيار صورة، ضغطها، رفعها، وعرض progress.',
          en: 'Pick an image, compress it, upload it, and show progress.',
        ),
        explain: LocalText(
          ar: 'رفع الملفات يحتاج UX واضح: اختيار، معاينة، ضغط عند الحاجة، progress، وإعادة محاولة عند الفشل.',
          en: 'File upload needs clear UX: pick, preview, compress when needed, progress, and retry on failure.',
        ),
        whenToUse: [
          LocalText(
            ar: 'صورة بروفايل أو مستندات تحقق.',
            en: 'Profile photos or verification documents.',
          ),
          LocalText(
            ar: 'تطبيقات محتوى أو تعليم أو متجر.',
            en: 'Content, learning, or store apps.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'اختر الملف من مصدر واضح.',
            en: 'Pick the file from a clear source.',
          ),
          LocalText(
            ar: 'اعرض preview قبل الرفع.',
            en: 'Show preview before upload.',
          ),
          LocalText(
            ar: 'اعرض progress وإمكانية retry.',
            en: 'Show progress and retry option.',
          ),
        ],
        code:
            'final form = FormData.fromMap({\n'
            '  "avatar": await MultipartFile.fromFile(file.path),\n'
            '});\n'
            '\n'
            'await dio.post("/profile/avatar", data: form);',
        commonMistakes: [
          LocalText(
            ar: 'رفع صورة ضخمة جدًا بدون ضغط.',
            en: 'Uploading huge images without compression.',
          ),
          LocalText(
            ar: 'عدم إظهار تقدم الرفع.',
            en: 'Not showing upload progress.',
          ),
        ],
      ),
    ],
  ),
  CurriculumLevel(
    number: 8,
    title: LocalText(
      ar: 'Integrations وخدمات خارجية',
      en: 'Integrations and Services',
    ),
    subtitle: LocalText(
      ar: 'الخرائط، الدفع، deep links، analytics، وخدمات المنتجات الحقيقية.',
      en: 'Maps, payments, deep links, analytics, and real product services.',
    ),
    icon: Icons.hub_rounded,
    color: Color(0xFFF97316),
    topics: [
      CurriculumTopic(
        title: LocalText(ar: 'Maps and location', en: 'Maps and location'),
        summary: LocalText(
          ar: 'عرض خريطة، marker، تحديد موقع، وحساب مسافة.',
          en: 'Show a map, marker, user location, and distance.',
        ),
        explain: LocalText(
          ar: 'الموقع ليس زر GPS فقط. يجب التعامل مع permission، دقة الموقع، حالة إغلاق الخدمة، وتحديث العنوان من coordinates.',
          en: 'Location is not just a GPS button. Handle permission, accuracy, disabled services, and converting coordinates to an address.',
        ),
        whenToUse: [
          LocalText(
            ar: 'تطبيق توصيل أو حجز أو عقارات.',
            en: 'Delivery, booking, or real estate apps.',
          ),
          LocalText(ar: 'اختيار عنوان المستخدم.', en: 'Picking user address.'),
        ],
        steps: [
          LocalText(
            ar: 'تحقق من service enabled.',
            en: 'Check that location service is enabled.',
          ),
          LocalText(
            ar: 'اطلب permission في لحظة الحاجة.',
            en: 'Request permission when needed.',
          ),
          LocalText(
            ar: 'خزن lat/lng وليس العنوان النصي فقط.',
            en: 'Store lat/lng, not only the text address.',
          ),
        ],
        code:
            'final position = await Geolocator.getCurrentPosition();\n'
            'final point = LatLng(position.latitude, position.longitude);\n'
            'mapController.animateCamera(CameraUpdate.newLatLng(point));',
        commonMistakes: [
          LocalText(
            ar: 'عدم التعامل مع إغلاق GPS.',
            en: 'Not handling disabled GPS.',
          ),
          LocalText(
            ar: 'تخزين العنوان النصي فقط بدون coordinates.',
            en: 'Saving only text address without coordinates.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'Payments', en: 'Payments'),
        summary: LocalText(
          ar: 'ابدأ payment session، افتح SDK، أكد النتيجة من السيرفر.',
          en: 'Start payment session, open SDK, confirm result from server.',
        ),
        explain: LocalText(
          ar: 'الدفع لا يعتمد على نتيجة التطبيق فقط. التطبيق يفتح بوابة الدفع، لكن الحقيقة النهائية يجب أن تأتي من السيرفر أو webhook.',
          en: 'Payment must not trust the app result only. The app opens the gateway, but final truth should come from server or webhook.',
        ),
        whenToUse: [
          LocalText(
            ar: 'المتاجر والاشتراكات والحجوزات.',
            en: 'Stores, subscriptions, and bookings.',
          ),
          LocalText(
            ar: 'أي عملية مالية تحتاج تأكيد.',
            en: 'Any financial action that needs confirmation.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'اطلب checkout id من السيرفر.',
            en: 'Request checkout id from backend.',
          ),
          LocalText(
            ar: 'افتح SDK أو payment page.',
            en: 'Open SDK or payment page.',
          ),
          LocalText(
            ar: 'اسأل السيرفر عن حالة الدفع بعد العودة.',
            en: 'Ask backend for payment status after return.',
          ),
        ],
        code:
            'final checkoutId = await payments.createCheckout(orderId);\n'
            'final result = await paymentSdk.pay(checkoutId);\n'
            'final status = await payments.verify(orderId);\n'
            'emit(PaymentFinished(status));',
        commonMistakes: [
          LocalText(
            ar: 'اعتبار نجاح SDK دليلًا نهائيًا على الدفع.',
            en: 'Treating SDK success as final proof of payment.',
          ),
          LocalText(
            ar: 'عدم منع الضغط المتكرر على زر الدفع.',
            en: 'Not preventing repeated payment taps.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'Deep links', en: 'Deep links'),
        summary: LocalText(
          ar: 'افتح شاشة معينة من رابط أو إشعار أو مشاركة.',
          en: 'Open a specific screen from a link, notification, or share.',
        ),
        explain: LocalText(
          ar: 'الـ deep link يحول الرابط إلى navigation داخل التطبيق. يجب أن يدعم التطبيق الرابط عند التشغيل البارد وأثناء فتحه.',
          en: 'A deep link turns a URL into in-app navigation. The app must handle links on cold start and while already open.',
        ),
        whenToUse: [
          LocalText(
            ar: 'مشاركة منتج أو درس أو دعوة.',
            en: 'Sharing a product, lesson, or invitation.',
          ),
          LocalText(
            ar: 'فتح التطبيق من email أو notification.',
            en: 'Opening the app from email or notification.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'حدد URL scheme أو universal link.',
            en: 'Define URL scheme or universal link.',
          ),
          LocalText(
            ar: 'حلل path والـ query parameters.',
            en: 'Parse path and query parameters.',
          ),
          LocalText(
            ar: 'وجه المستخدم للشاشة المناسبة بعد auth.',
            en: 'Route user after auth if needed.',
          ),
        ],
        code:
            'void handleUri(Uri uri) {\n'
            '  if (uri.pathSegments.firstOrNull == "courses") {\n'
            '    final id = uri.pathSegments.last;\n'
            '    openCourse(id);\n'
            '  }\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'فتح الشاشة قبل اكتمال auth/session loading.',
            en: 'Opening the screen before auth/session loading is complete.',
          ),
          LocalText(
            ar: 'عدم اختبار الرابط والتطبيق مغلق.',
            en: 'Not testing links while the app is closed.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(
          ar: 'Analytics and events',
          en: 'Analytics and events',
        ),
        summary: LocalText(
          ar: 'سجل الأحداث المهمة بدون كشف بيانات حساسة.',
          en: 'Track important events without exposing sensitive data.',
        ),
        explain: LocalText(
          ar: 'التحليلات تساعدك تفهم أين يتوقف المستخدم. سجل الأحداث المهمة مثل start_checkout و lesson_completed، وليس كل tap بلا معنى.',
          en: 'Analytics helps reveal where users stop. Track important events like start_checkout and lesson_completed, not every meaningless tap.',
        ),
        whenToUse: [
          LocalText(
            ar: 'قياس funnel تسجيل أو شراء.',
            en: 'Measuring signup or purchase funnel.',
          ),
          LocalText(
            ar: 'معرفة أكثر الشاشات استخدامًا.',
            en: 'Knowing the most used screens.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'حدد أسماء events ثابتة.',
            en: 'Define stable event names.',
          ),
          LocalText(
            ar: 'لا ترسل email أو phone في analytics.',
            en: 'Do not send email or phone in analytics.',
          ),
          LocalText(
            ar: 'اجعل AnalyticsService طبقة واحدة.',
            en: 'Keep AnalyticsService as one layer.',
          ),
        ],
        code:
            'analytics.logEvent(\n'
            '  name: "lesson_completed",\n'
            '  parameters: {"lesson_id": lesson.id},\n'
            ');',
        commonMistakes: [
          LocalText(
            ar: 'تسجيل بيانات شخصية داخل events.',
            en: 'Logging personal data inside events.',
          ),
          LocalText(
            ar: 'أسماء events عشوائية وغير موحدة.',
            en: 'Random and inconsistent event names.',
          ),
        ],
      ),
    ],
  ),
  CurriculumLevel(
    number: 9,
    title: LocalText(
      ar: 'أدوات المطور وتنظيم المشروع',
      en: 'Developer Tooling and Project Setup',
    ),
    subtitle: LocalText(
      ar: 'اجعل الشغل أسرع، أوضح، وأسهل للمراجعة والتسليم.',
      en: 'Make work faster, clearer, and easier to review and deliver.',
    ),
    icon: Icons.handyman_rounded,
    color: Color(0xFFEAB308),
    topics: [
      CurriculumTopic(
        title: LocalText(
          ar: 'Dependency injection',
          en: 'Dependency injection',
        ),
        summary: LocalText(
          ar: 'مرر dependencies بدل إنشاء كل شيء داخل الشاشة.',
          en: 'Pass dependencies instead of creating everything inside screens.',
        ),
        explain: LocalText(
          ar: 'DI يجعل الكود قابلًا للاختبار والتبديل. الشاشة لا تنشئ API client بنفسها، بل تحصل على Cubit أو service جاهز.',
          en: 'DI makes code testable and replaceable. A screen should not create the API client itself; it receives a ready Cubit or service.',
        ),
        whenToUse: [
          LocalText(
            ar: 'عند وجود repositories و services متعددة.',
            en: 'When you have multiple repositories and services.',
          ),
          LocalText(
            ar: 'عند كتابة tests تحتاج mocks.',
            en: 'When writing tests that need mocks.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'سجل singletons للخدمات العامة.',
            en: 'Register singletons for shared services.',
          ),
          LocalText(
            ar: 'سجل factories للـ Cubits.',
            en: 'Register factories for Cubits.',
          ),
          LocalText(
            ar: 'لا تستخدم service locator داخل domain entities.',
            en: 'Do not use service locator inside domain entities.',
          ),
        ],
        code:
            'final getIt = GetIt.instance;\n'
            '\n'
            'void configureDependencies() {\n'
            '  getIt.registerLazySingleton<ApiClient>(() => ApiClient());\n'
            '  getIt.registerFactory(() => CoursesCubit(getIt()));\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'استخدام getIt في كل مكان بدل constructor injection.',
            en: 'Using getIt everywhere instead of constructor injection.',
          ),
          LocalText(
            ar: 'نسيان reset dependencies في tests.',
            en: 'Forgetting to reset dependencies in tests.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(
          ar: 'Flavors and environments',
          en: 'Flavors and environments',
        ),
        summary: LocalText(
          ar: 'dev، staging، production بدون تغيير الكود يدويًا.',
          en: 'dev, staging, and production without manual code edits.',
        ),
        explain: LocalText(
          ar: 'المشروع المحترف يفصل بيئة التطوير عن الإنتاج. API base url، app name، icons، ومفاتيح الخدمات تختلف حسب flavor.',
          en: 'A professional project separates development from production. API base url, app name, icons, and service keys change by flavor.',
        ),
        whenToUse: [
          LocalText(
            ar: 'عند وجود backend staging و production.',
            en: 'When there are staging and production backends.',
          ),
          LocalText(
            ar: 'عند تسليم نسخة اختبار للعميل.',
            en: 'When delivering a testing build to a client.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'عرف enum للبيئة الحالية.',
            en: 'Define an enum for current environment.',
          ),
          LocalText(
            ar: 'اجعل Config يقرأ baseUrl حسب البيئة.',
            en: 'Let Config read baseUrl by environment.',
          ),
          LocalText(
            ar: 'ابنِ كل flavor بأمر منفصل.',
            en: 'Build every flavor with a separate command.',
          ),
        ],
        code:
            'enum AppFlavor { dev, staging, prod }\n'
            '\n'
            'class AppConfig {\n'
            '  const AppConfig({required this.flavor, required this.baseUrl});\n'
            '  final AppFlavor flavor;\n'
            '  final String baseUrl;\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'تغيير baseUrl يدويًا قبل build.',
            en: 'Changing baseUrl manually before build.',
          ),
          LocalText(
            ar: 'استخدام مفاتيح production في debug.',
            en: 'Using production keys in debug builds.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'Debugging workflow', en: 'Debugging workflow'),
        summary: LocalText(
          ar: 'استخدم logs، breakpoints، DevTools، وفهم stack traces.',
          en: 'Use logs, breakpoints, DevTools, and understand stack traces.',
        ),
        explain: LocalText(
          ar: 'التصحيح الجيد يبدأ من إعادة إنتاج المشكلة، ثم تضييق نطاقها. لا تطبع كل شيء عشوائيًا، بل سجل event واضح وحالة واضحة.',
          en: 'Good debugging starts by reproducing the issue, then narrowing it. Do not print everything randomly; log clear events and state.',
        ),
        whenToUse: [
          LocalText(
            ar: 'أي crash أو سلوك غير متوقع.',
            en: 'Any crash or unexpected behavior.',
          ),
          LocalText(
            ar: 'مشاكل الأداء والـ rebuilds.',
            en: 'Performance and rebuild issues.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'اقرأ أول سطر مفيد في stack trace.',
            en: 'Read the first useful line in the stack trace.',
          ),
          LocalText(
            ar: 'ضع breakpoint قبل مكان الفشل.',
            en: 'Place a breakpoint before the failure point.',
          ),
          LocalText(
            ar: 'استخدم Flutter DevTools للذاكرة والأداء.',
            en: 'Use Flutter DevTools for memory and performance.',
          ),
        ],
        code:
            'debugPrint("Loading courses for user: \$userId");\n'
            'assert(courses.isNotEmpty, "Courses should not be empty here");',
        commonMistakes: [
          LocalText(
            ar: 'تجاهل stack trace والبحث عشوائيًا.',
            en: 'Ignoring the stack trace and searching randomly.',
          ),
          LocalText(
            ar: 'ترك prints كثيرة في release logic.',
            en: 'Leaving many prints in release logic.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'Git workflow', en: 'Git workflow'),
        summary: LocalText(
          ar: 'branches، commits واضحة، PR review، وعدم كسر main.',
          en: 'Branches, clear commits, PR review, and keeping main stable.',
        ),
        explain: LocalText(
          ar: 'Git ليس مجرد حفظ ملفات. هو طريقة تعاون. كل ميزة في branch، commit يشرح السبب، وPR صغير يسهل مراجعته.',
          en: 'Git is not just file saving. It is collaboration. Each feature has a branch, commits explain intent, and small PRs are easier to review.',
        ),
        whenToUse: [
          LocalText(
            ar: 'أي مشروع حقيقي أو فريق.',
            en: 'Any real project or team.',
          ),
          LocalText(
            ar: 'عند العمل على أكثر من feature بالتوازي.',
            en: 'When working on multiple features in parallel.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'ابدأ branch باسم واضح.',
            en: 'Start a branch with a clear name.',
          ),
          LocalText(
            ar: 'اكتب commit صغير لكل تغيير منطقي.',
            en: 'Write small commits for logical changes.',
          ),
          LocalText(ar: 'شغل analyze قبل PR.', en: 'Run analyze before PR.'),
        ],
        code:
            'git checkout -b feature/course-details\n'
            'flutter analyze\n'
            'git add .\n'
            'git commit -m "Add course details screen"',
        commonMistakes: [
          LocalText(
            ar: 'commit ضخم فيه عدة features.',
            en: 'A huge commit with multiple features.',
          ),
          LocalText(
            ar: 'العمل مباشرة على main.',
            en: 'Working directly on main.',
          ),
        ],
      ),
    ],
  ),
  CurriculumLevel(
    number: 10,
    title: LocalText(
      ar: 'المراقبة والصيانة بعد النشر',
      en: 'Monitoring and Maintenance',
    ),
    subtitle: LocalText(
      ar: 'ما يحدث بعد نشر التطبيق: أخطاء، أداء، تحديثات، وحماية الاستقرار.',
      en: 'What happens after release: crashes, performance, updates, and stability.',
    ),
    icon: Icons.monitor_heart_rounded,
    color: Color(0xFFEF4444),
    topics: [
      CurriculumTopic(
        title: LocalText(ar: 'Crash reporting', en: 'Crash reporting'),
        summary: LocalText(
          ar: 'اجمع crash reports مع user id غير حساس وبيئة التشغيل.',
          en: 'Collect crash reports with non-sensitive user id and environment.',
        ),
        explain: LocalText(
          ar: 'بعد النشر لن ترى أخطاء المستخدمين إلا لو عندك crash reporting. اربط الأخطاء بالإصدار والبيئة، ولا ترسل بيانات حساسة.',
          en: 'After release you will not see user errors unless crash reporting exists. Link crashes to version and environment without sending sensitive data.',
        ),
        whenToUse: [
          LocalText(
            ar: 'قبل أول production release.',
            en: 'Before the first production release.',
          ),
          LocalText(
            ar: 'عند وجود مستخدمين حقيقيين.',
            en: 'When real users exist.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'سجل FlutterError.onError.',
            en: 'Register FlutterError.onError.',
          ),
          LocalText(
            ar: 'سجل errors غير المتوقعة في runZonedGuarded.',
            en: 'Record uncaught errors in runZonedGuarded.',
          ),
          LocalText(
            ar: 'أضف app version و flavor كـ keys.',
            en: 'Add app version and flavor as keys.',
          ),
        ],
        code:
            'FlutterError.onError = (details) {\n'
            '  crashReporter.recordFlutterFatalError(details);\n'
            '};\n'
            '\n'
            'runZonedGuarded(runApp, crashReporter.recordError);',
        commonMistakes: [
          LocalText(
            ar: 'تفعيل crash reporting بعد حدوث مشاكل كثيرة.',
            en: 'Adding crash reporting only after many issues.',
          ),
          LocalText(
            ar: 'إرسال بيانات شخصية داخل crash logs.',
            en: 'Sending personal data in crash logs.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(
          ar: 'Remote config and feature flags',
          en: 'Remote config and feature flags',
        ),
        summary: LocalText(
          ar: 'غير سلوك بسيط بدون نشر نسخة جديدة.',
          en: 'Change small behavior without publishing a new build.',
        ),
        explain: LocalText(
          ar: 'Feature flags تسمح بتجربة ميزة لمجموعة صغيرة أو إيقاف feature تسبب مشكلة. لكنها لا يجب أن تتحول لمنطق عشوائي في كل مكان.',
          en: 'Feature flags allow testing a feature for a small group or disabling a problematic feature. They should not become random logic everywhere.',
        ),
        whenToUse: [
          LocalText(
            ar: 'تفعيل ميزة تدريجيًا.',
            en: 'Rolling out a feature gradually.',
          ),
          LocalText(
            ar: 'إيقاف بانر أو تجربة مؤقتة.',
            en: 'Turning off a banner or temporary experiment.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'ضع القيم الافتراضية داخل التطبيق.',
            en: 'Put default values inside the app.',
          ),
          LocalText(
            ar: 'اجعل أسماء flags واضحة.',
            en: 'Make flag names clear.',
          ),
          LocalText(
            ar: 'لا تعتمد عليها لأمان أو صلاحيات.',
            en: 'Do not rely on flags for security or permissions.',
          ),
        ],
        code:
            'final enabled = remoteConfig.getBool("new_checkout_enabled");\n'
            'return enabled ? const NewCheckout() : const ClassicCheckout();',
        commonMistakes: [
          LocalText(
            ar: 'استخدام flags بدل حماية السيرفر.',
            en: 'Using flags instead of server-side protection.',
          ),
          LocalText(
            ar: 'ترك flags قديمة بلا تنظيف.',
            en: 'Leaving old flags without cleanup.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(ar: 'App update strategy', en: 'App update strategy'),
        summary: LocalText(
          ar: 'اختياري، إجباري، ورسائل تحديث واضحة.',
          en: 'Optional, forced, and clear update messages.',
        ),
        explain: LocalText(
          ar: 'بعض التحديثات تحسينات فقط، وبعضها ضروري بسبب API أو أمان. التطبيق يجب أن يعرف أقل إصدار مسموح ويعرض رسالة مناسبة.',
          en: 'Some updates are improvements, others are required because of API or security. The app should know the minimum supported version and show a clear message.',
        ),
        whenToUse: [
          LocalText(
            ar: 'تغيير API يكسر النسخ القديمة.',
            en: 'API changes that break old versions.',
          ),
          LocalText(
            ar: 'إصلاح أمان أو payment مهم.',
            en: 'Security or payment critical fixes.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'احصل على minSupportedVersion من السيرفر.',
            en: 'Fetch minSupportedVersion from backend.',
          ),
          LocalText(
            ar: 'قارنها بإصدار التطبيق الحالي.',
            en: 'Compare it with current app version.',
          ),
          LocalText(
            ar: 'اعرض dialog إجباري أو اختياري حسب الحالة.',
            en: 'Show forced or optional dialog based on status.',
          ),
        ],
        code:
            'if (currentVersion < config.minSupportedVersion) {\n'
            '  showForceUpdateDialog();\n'
            '} else if (currentVersion < config.latestVersion) {\n'
            '  showOptionalUpdateBanner();\n'
            '}',
        commonMistakes: [
          LocalText(
            ar: 'إجبار كل المستخدمين على كل تحديث.',
            en: 'Forcing every user to update every time.',
          ),
          LocalText(
            ar: 'عدم وجود خطة للنسخ القديمة.',
            en: 'Having no plan for old versions.',
          ),
        ],
      ),
      CurriculumTopic(
        title: LocalText(
          ar: 'Maintenance checklist',
          en: 'Maintenance checklist',
        ),
        summary: LocalText(
          ar: 'تابع dependencies، warnings، الأداء، وتجربة المستخدم.',
          en: 'Track dependencies, warnings, performance, and user experience.',
        ),
        explain: LocalText(
          ar: 'الصيانة المستمرة تمنع تراكم الديون التقنية. راجع التحذيرات، حدث الحزم بحذر، واقرأ تقارير crash والأداء بعد كل release.',
          en: 'Continuous maintenance prevents technical debt. Review warnings, update packages carefully, and read crash and performance reports after each release.',
        ),
        whenToUse: [
          LocalText(
            ar: 'بعد كل sprint أو release.',
            en: 'After every sprint or release.',
          ),
          LocalText(
            ar: 'قبل تحديث Flutter SDK.',
            en: 'Before updating Flutter SDK.',
          ),
        ],
        steps: [
          LocalText(
            ar: 'راجع flutter outdated.',
            en: 'Review flutter outdated.',
          ),
          LocalText(
            ar: 'شغل analyze و tests بعد كل تحديث.',
            en: 'Run analyze and tests after every update.',
          ),
          LocalText(
            ar: 'راقب crash-free users.',
            en: 'Monitor crash-free users.',
          ),
        ],
        code:
            'flutter pub outdated\n'
            'flutter pub upgrade\n'
            'flutter analyze\n'
            'flutter test',
        commonMistakes: [
          LocalText(
            ar: 'تحديث كل الحزم مرة واحدة بدون اختبار.',
            en: 'Updating all packages at once without testing.',
          ),
          LocalText(
            ar: 'تجاهل warnings حتى تتحول لأخطاء.',
            en: 'Ignoring warnings until they become errors.',
          ),
        ],
      ),
    ],
  ),
];
