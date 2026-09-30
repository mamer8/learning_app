import 'package:flutter/material.dart';
import '../../core/core.dart';
import '../../core/localization/app_localizations.dart';
import '../ai_chat/widgets/contextual_ai_sheet.dart';

/// 1. Domain Layer: Entity
class ArticleEntity {
  final int id;
  final String title;
  final String source;

  const ArticleEntity({required this.id, required this.title, required this.source});
}

/// 1. Domain Layer: Repository Interface (Dependency Inversion Principle)
abstract class ArticleRepositoryContract {
  Future<List<ArticleEntity>> getArticles();
}

/// 2. Data Layer: Remote Data Source
class RemoteArticleDataSource {
  Future<List<ArticleEntity>> fetchFromNetwork() async {
    await Future.delayed(const Duration(milliseconds: 500));
    return const [
      ArticleEntity(id: 1, title: 'Flutter 3.24 & Impeller Engine Deep Dive', source: '🌐 Remote Server API'),
      ArticleEntity(id: 2, title: 'Dart 3.5 Type System & Macro Updates', source: '🌐 Remote Server API'),
    ];
  }
}

/// 2. Data Layer: Local Cache Data Source
class LocalArticleDataSource {
  Future<List<ArticleEntity>> fetchFromCache() async {
    await Future.delayed(const Duration(milliseconds: 200));
    return const [
      ArticleEntity(id: 101, title: 'Clean Architecture Principles in Mobile', source: '💾 Local SQLite DB'),
      ArticleEntity(id: 102, title: 'SOLID Design Patterns in Dart', source: '💾 Local SQLite DB'),
      ArticleEntity(id: 103, title: 'TDD & Unit Testing Best Practices', source: '💾 Local SQLite DB'),
    ];
  }
}

/// 2. Data Layer: Repository Implementation
class ArticleRepositoryImpl implements ArticleRepositoryContract {
  final bool useRemote;
  final RemoteArticleDataSource remoteDataSource;
  final LocalArticleDataSource localDataSource;

  ArticleRepositoryImpl({
    required this.useRemote,
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<List<ArticleEntity>> getArticles() {
    if (useRemote) {
      return remoteDataSource.fetchFromNetwork();
    } else {
      return localDataSource.fetchFromCache();
    }
  }
}

/// 1. Domain Layer: UseCase
class GetArticlesUseCase {
  final ArticleRepositoryContract repository;
  GetArticlesUseCase(this.repository);

  Future<List<ArticleEntity>> call() async {
    return await repository.getArticles();
  }
}

/// شاشة مختبر Clean Architecture & SOLID Principles
class CleanArchScreen extends StatefulWidget {
  const CleanArchScreen({super.key});

  @override
  State<CleanArchScreen> createState() => _CleanArchScreenState();
}

class _CleanArchScreenState extends State<CleanArchScreen> {
  bool _useRemoteSource = true;
  bool _isLoading = false;
  List<ArticleEntity> _articles = [];

  @override
  void initState() {
    super.initState();
    _loadArticles();
  }

  void _loadArticles() async {
    setState(() => _isLoading = true);

    // محاكاة استدعاء الـ UseCase عبر الـ Dependency Inversion
    final repo = ArticleRepositoryImpl(
      useRemote: _useRemoteSource,
      remoteDataSource: RemoteArticleDataSource(),
      localDataSource: LocalArticleDataSource(),
    );
    final useCase = GetArticlesUseCase(repo);

    final result = await useCase();

    setState(() {
      _isLoading = false;
      _articles = result;
    });
  }

  String _getCleanArchCode() {
    return '// 1. إنشاء الـ Repository وتحديد مصدر البيانات (حالياً: ${_useRemoteSource ? "Remote API" : "Local SQLite"})\n'
        'final repository = ArticleRepositoryImpl(\n'
        '  useRemote: $_useRemoteSource,\n'
        '  remoteDataSource: RemoteArticleDataSource(),\n'
        '  localDataSource: LocalArticleDataSource(),\n'
        ');\n\n'
        '// 2. حقن الـ Repository داخل الـ UseCase (Domain Layer معزولة تماماً)\n'
        'final getArticlesUseCase = GetArticlesUseCase(repository);\n\n'
        '// 3. استدعاء الـ UseCase من الـ UI دون معرفة تفاصيل الـ Network أو الـ Database\n'
        'final List<ArticleEntity> articles = await getArticlesUseCase();';
  }

  void _openAiCopilot(BuildContext context, bool isArabic) {
    ContextualAiSheet.show(
      context,
      topicTitle: isArabic ? 'مختبر المعمارية النظيفة (Clean Architecture & SOLID)' : 'Clean Architecture & SOLID Lab',
      topicCode: _getCleanArchCode(),
      levelTitle: isArabic ? 'هندسة معمارية البرمجيات وفصل الاهتمامات' : 'Software Architecture & SOLID Principles',
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
          title: Text(isArabic ? 'مختبر المعمارية النظيفة (Clean Architecture)' : 'Clean Architecture & SOLID Lab'),
          actions: [
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
        body: ListView(
          padding: const EdgeInsets.fromLTRB(16, 16, 16, 80),
          children: [
            _buildIntroCard(isArabic),
            16.heightBox,

            // 1. المخطط التفاعلي للطبقات (Interactive Layer Map)
            _buildLayersMap(isArabic),
            16.heightBox,

            // 2. مبدأ عكس التبعية (Dependency Inversion Demonstration)
            _buildDependencyInversionControl(isArabic),
            16.heightBox,

            // 3. المخرجات في طبقة Presentation
            _buildPresentationList(isArabic),
            16.heightBox,

            // 4. كود الـ Clean Architecture المحدث ديناميكياً
            _buildCodeSection(isArabic),
            24.heightBox,
          ],
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
        border: Border.all(color: const Color(0xFFF59E0B).withValues(alpha: 0.4)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFF59E0B).withValues(alpha: 0.15),
              borderRadius: BorderRadius.circular(8),
            ),
            child: const Icon(Icons.architecture_rounded, color: Color(0xFFFBBF24), size: 24),
          ),
          12.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  isArabic ? 'فصل الاهتمامات وقواعد SOLID' : 'Separation of Concerns & SOLID',
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 14, color: Colors.white),
                ),
                4.heightBox,
                Text(
                  isArabic
                      ? 'الهدف الجوهري للمشاريع الضخمة: طبقة Domain مستقلة 100% عن أي حزم خارجية أو أطر عمل، وتعتمد طبقات Data و Presentation عليها عبر Interfaces مجردة.'
                      : 'Zero business logic coupling. Domain layer stays 100% pure, while Data and Presentation depend inward via contracts.',
                  style: const TextStyle(fontSize: 12, color: Colors.white70, height: 1.4),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildLayersMap(bool isArabic) {
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
          Text(
            isArabic ? 'خريطة الطبقات الثلاث (Clean Architecture Layers):' : 'Clean Architecture 3-Tier Model:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
          ),
          12.heightBox,

          _buildLayerBadge('1. Presentation Layer', isArabic ? 'UI, Widgets, Bloc / Cubit State' : 'UI, Widgets, Bloc / Cubit State', const Color(0xFF0284C7)),
          8.heightBox,
          _buildLayerBadge('2. Domain Layer (The Core)', isArabic ? 'Entities, UseCases, Repositories Contracts' : 'Entities, UseCases, Repositories Contracts', const Color(0xFF10B981)),
          8.heightBox,
          _buildLayerBadge('3. Data Layer', isArabic ? 'DataSources (Dio, Retrofit), Models, DB' : 'DataSources (Dio, Retrofit), Models, DB', const Color(0xFF8B5CF6)),
        ],
      ),
    );
  }

  Widget _buildLayerBadge(String title, String subtitle, Color color) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
        border: Border.all(color: color.withValues(alpha: 0.4)),
      ),
      child: Row(
        children: [
          Container(
            width: 8,
            height: 8,
            decoration: BoxDecoration(color: color, shape: BoxShape.circle),
          ),
          10.widthBox,
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title, style: TextStyle(color: color, fontWeight: FontWeight.bold, fontSize: 12)),
                Text(subtitle, style: const TextStyle(color: Colors.white60, fontSize: 11)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildDependencyInversionControl(bool isArabic) {
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
          Text(
            isArabic ? 'مبدأ عكس التبعية (DIP) والتبديل الحي لمصدر البيانات:' : 'Dependency Inversion Live DataSource Switcher:',
            style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 13, color: Colors.white),
          ),
          8.heightBox,
          Text(
            isArabic
                ? 'لاحظ كيف تتغير البيانات بين الخادم السحابي وقاعدة البيانات المحلية دون تعديل حرف واحد في كود الـ UseCase أو الـ UI!'
                : 'Notice how UI seamlessly swaps DataSources through repository abstraction without refactoring.',
            style: const TextStyle(fontSize: 11.5, color: Colors.white70),
          ),
          12.heightBox,

          Row(
            children: [
              Expanded(
                child: FilterChip(
                  label: Text(isArabic ? '🌐 Remote API Source' : '🌐 Remote API Source'),
                  selected: _useRemoteSource,
                  selectedColor: const Color(0xFF0284C7).withValues(alpha: 0.3),
                  side: BorderSide(color: _useRemoteSource ? const Color(0xFF0284C7) : const Color(0xFF24324A)),
                  onSelected: (val) {
                    setState(() => _useRemoteSource = true);
                    _loadArticles();
                  },
                ),
              ),
              8.widthBox,
              Expanded(
                child: FilterChip(
                  label: Text(isArabic ? '💾 Local SQLite DB' : '💾 Local SQLite DB'),
                  selected: !_useRemoteSource,
                  selectedColor: const Color(0xFF8B5CF6).withValues(alpha: 0.3),
                  side: BorderSide(color: !_useRemoteSource ? const Color(0xFF8B5CF6) : const Color(0xFF24324A)),
                  onSelected: (val) {
                    setState(() => _useRemoteSource = false);
                    _loadArticles();
                  },
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildPresentationList(bool isArabic) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF080D1A),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFF1E293B)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                isArabic ? 'المخرجات في طبقة Presentation:' : 'Presentation Layer Output:',
                style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12.5, color: Colors.white),
              ),
              if (_isLoading)
                const SizedBox(
                  width: 14,
                  height: 14,
                  child: CircularProgressIndicator(strokeWidth: 2, color: Color(0xFF10B981)),
                ),
            ],
          ),
          12.heightBox,

          if (_articles.isEmpty && !_isLoading)
            Center(child: Text(isArabic ? 'لا توجد بيانات' : 'No Data', style: const TextStyle(color: Colors.white38)))
          else
            ..._articles.map((article) {
              return Container(
                margin: const EdgeInsets.only(bottom: 8),
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: const Color(0xFF101828),
                  borderRadius: BorderRadius.circular(8),
                  border: Border.all(color: const Color(0xFF24324A)),
                ),
                child: Row(
                  children: [
                    Container(
                      width: 28,
                      height: 28,
                      alignment: Alignment.center,
                      decoration: BoxDecoration(
                        color: const Color(0xFF10B981).withValues(alpha: 0.15),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text('${article.id}', style: const TextStyle(color: Color(0xFF34D399), fontWeight: FontWeight.bold, fontSize: 11)),
                    ),
                    10.widthBox,
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(article.title, style: const TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 12)),
                          2.heightBox,
                          Text(article.source, style: const TextStyle(color: Colors.white54, fontSize: 10.5)),
                        ],
                      ),
                    ),
                  ],
                ),
              );
            }),
        ],
      ),
    );
  }

  Widget _buildCodeSection(bool isArabic) {
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
          Text(
            isArabic ? '💻 الكود الحي للحقن واستدعاء الـ UseCase (يتغير مع مصدر البيانات):' : '💻 Live UseCase Code (Updates dynamically):',
            style: const TextStyle(color: Color(0xFFFBBF24), fontWeight: FontWeight.bold, fontSize: 13),
          ),
          10.heightBox,
          CopyableCodeBlock(
            code: _getCleanArchCode(),
            copiedMessage: isArabic ? 'تم نسخ كود المعمارية النظيفة' : 'Clean Architecture code copied',
          ),
        ],
      ),
    );
  }
}
