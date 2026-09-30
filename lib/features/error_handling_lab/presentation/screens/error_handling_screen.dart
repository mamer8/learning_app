import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../../core/core.dart';
import '../../data/datasources/mock_user_remote_data_source.dart';
import '../../data/repositories/user_repository_impl.dart';
import '../../domain/repositories/user_repository.dart';
import '../cubit/user_cubit.dart';
import '../cubit/user_state.dart';
import '../../../ai_chat/widgets/contextual_ai_sheet.dart';

/// 🏛️ مختبر الـ Functional Error Handling مع `Either<Failure, Success>` و Cubit
class ErrorHandlingScreen extends StatelessWidget {
  const ErrorHandlingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    // حقن التبعيات (Dependency Injection) للـ Cubit
    return BlocProvider(
      create: (context) => UserCubit(
        repository: UserRepositoryImpl(
          remoteDataSource: MockUserRemoteDataSourceImpl(),
        ),
      ),
      child: const _ErrorHandlingView(),
    );
  }
}

class _ErrorHandlingView extends StatelessWidget {
  const _ErrorHandlingView();

  void _openAiCopilot(BuildContext context) {
    const code =
        'Future<Either<Failure, UserProfile>> getUserProfile(String scenario) async {\n'
        '  try {\n'
        '    final remoteData = await remoteDataSource.fetchUserData(scenario);\n'
        '    return Right(remoteData);\n'
        '  } on ServerException catch (e) {\n'
        '    return Left(ServerFailure(e.message));\n'
        '  } on NetworkException catch (_) {\n'
        '    return Left(NetworkFailure("تعذر الاتصال بالخادم"));\n'
        '  }\n'
        '}\n\n'
        '// استقبال النتيجة وفكها بطريقة آمنة:\n'
        'final result = await repository.getUserProfile(scenario);\n'
        'result.fold(\n'
        '  (failure) => emit(UserError(failure)), // Left  <- Failure\n'
        '  (user)    => emit(UserLoaded(user)),   // Right <- Success\n'
        ');';

    ContextualAiSheet.show(
      context,
      topicTitle: 'مختبر المعالجة الوظيفية للأخطاء (dartz Either & Failures)',
      topicCode: code,
      levelTitle: 'معمارية معالجة الأخطاء والبرمجة الوظيفية',
      isArabic: true,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0F172A),
      appBar: AppBar(
        title: const Text('مختبر Either & معالجة الأخطاء'),
        backgroundColor: const Color(0xFF1E293B),
        actions: [
          IconButton(
            tooltip: 'اسأل المساعد الذكي',
            icon: const Icon(Icons.psychology_rounded, color: Color(0xFF14B8A6)),
            onPressed: () => _openAiCopilot(context),
          ),
          IconButton(
            tooltip: 'إعادة التعيين',
            onPressed: () => context.read<UserCubit>().reset(),
            icon: const Icon(Icons.refresh_rounded),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: () => _openAiCopilot(context),
        icon: const Icon(Icons.psychology_rounded, color: Color(0xFF04111C)),
        label: const Text(
          'اسأل المساعد الذكي عن هذا الكود',
          style: TextStyle(color: Color(0xFF04111C), fontWeight: FontWeight.bold),
        ),
        backgroundColor: const Color(0xFF14B8A6),
      ),
      body: ResponsiveContentWrapper(
        maxWidth: 1200,
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(16.0, 16.0, 16.0, 80.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // 1. بطاقة الشرح النظري
              _buildEducationalCard(),
              16.heightBox,

              // 2. أزرار محاكاة السيناريوهات المختلفة
              const Text(
                '🎮 اختر سيناريو الاستجابة لمحاكاته:',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              12.heightBox,
              _buildScenarioButtons(context),
              20.heightBox,

              // 3. مساحة عرض الحالة الحالية (BlocBuilder State Area)
              const Text(
                '📱 استجابة الـ Cubit والواجهة (Live UI State):',
                style: TextStyle(
                  color: Colors.white70,
                  fontSize: 13,
                  fontWeight: FontWeight.bold,
                ),
              ),
              12.heightBox,
              _buildStateCard(),
              20.heightBox,

              // 4. كود الـ fold التوضيحي
              _buildCodeSnippetCard(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildEducationalCard() {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(
          color: const Color(0xFF10B981).withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              const Icon(
                Icons.security_rounded,
                color: Color(0xFF10B981),
                size: 24,
              ),
              8.widthBox,
              const Text(
                'لماذا نستخدم إستراتيجية Either<Failure, T>؟',
                style: TextStyle(
                  color: Color(0xFF10B981),
                  fontWeight: FontWeight.bold,
                  fontSize: 15,
                ),
              ),
            ],
          ),
          8.heightBox,
          const Text(
            '🔹 في Clean Architecture، لا نترك الـ Exceptions تتسرب إلى واجهة المستخدم (UI) فتسبب انهيار التطبيق (Crash).\n'
            '🔹 نقوم بتحويل كل Exception في الـ Repository إلى كائن Failure ونعيده داخل Either:\n'
            '  • Left(Failure): يمثل حالة الفشل بدقة وأمان.\n'
            '  • Right(Success): يمثل البيانات الناجحة.\n'
            '🔹 في الـ Cubit نستخدم دالة `.fold()` لمعالجة كلا الاحتمالين بدون الحاجة لـ try/catch في الواجهات.',
            style: TextStyle(color: Colors.white70, fontSize: 12, height: 1.5),
          ),
        ],
      ),
    );
  }

  Widget _buildScenarioButtons(BuildContext context) {
    return Wrap(
      spacing: 8,
      runSpacing: 8,
      children: [
        _buildActionButton(
          context: context,
          scenario: MockScenario.success,
          label: '🟢 نجاح (200 OK)',
          color: const Color(0xFF10B981),
        ),
        _buildActionButton(
          context: context,
          scenario: MockScenario.unauthorized,
          label: '🔒 غير مصرح (401)',
          color: const Color(0xFFF59E0B),
        ),
        _buildActionButton(
          context: context,
          scenario: MockScenario.noInternet,
          label: '🌐 انقطاع إنترنت',
          color: const Color(0xFF6366F1),
        ),
        _buildActionButton(
          context: context,
          scenario: MockScenario.serverError,
          label: '💥 خطأ سيرفر (500)',
          color: const Color(0xFFEF4444),
        ),
        _buildActionButton(
          context: context,
          scenario: MockScenario.timeout,
          label: '⏳ انتهاء المهلة (Timeout)',
          color: const Color(0xFF8B5CF6),
        ),
      ],
    );
  }

  Widget _buildActionButton({
    required BuildContext context,
    required MockScenario scenario,
    required String label,
    required Color color,
  }) {
    return ElevatedButton(
      onPressed: () => context.read<UserCubit>().fetchUser(scenario),
      style: ElevatedButton.styleFrom(
        backgroundColor: color.withValues(alpha: 0.2),
        foregroundColor: color,
        side: BorderSide(color: color, width: 1.2),
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
        shape: RoundedRectangleBorder(borderRadius: 10.circularRadius),
      ),
      child: Text(
        label,
        style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 12),
      ),
    );
  }

  Widget _buildStateCard() {
    return BlocConsumer<UserCubit, UserState>(
      listener: (context, state) {
        if (state is UserLoaded) {
          context.showSuccessSnackBar('تم جلب بيانات المستخدم بنجاح!');
        } else if (state is UserError) {
          context.showErrorSnackBar(
            state.failure.message,
            title: 'فشل العملية',
          );
        }
      },
      builder: (context, state) {
        if (state is UserLoading) {
          return Container(
            height: 160,
            alignment: Alignment.center,
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: 16.circularRadius,
              border: Border.all(color: Colors.white12),
            ),
            child: const Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                CircularProgressIndicator(color: Colors.blueAccent),
                SizedBox(height: 12),
                Text(
                  'جاري محاكاة الاتصال بالسيرفر...',
                  style: TextStyle(color: Colors.white70),
                ),
              ],
            ),
          );
        }

        if (state is UserLoaded) {
          final user = state.user;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: 16.circularRadius,
              border: Border.all(
                color: Colors.greenAccent.withValues(alpha: 0.5),
                width: 1.5,
              ),
            ),
            child: Row(
              children: [
                CircleAvatar(
                  radius: 30,
                  backgroundColor: Colors.greenAccent.withValues(alpha: 0.2),
                  child: const Icon(
                    Icons.person_rounded,
                    color: Colors.greenAccent,
                    size: 36,
                  ),
                ),
                16.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            user.name,
                            style: const TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.bold,
                              fontSize: 16,
                            ),
                          ),
                          8.widthBox,
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 6,
                              vertical: 2,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.greenAccent.withValues(alpha: 0.2),
                              borderRadius: 4.circularRadius,
                            ),
                            child: const Text(
                              '200 OK',
                              style: TextStyle(
                                color: Colors.greenAccent,
                                fontSize: 10,
                              ),
                            ),
                          ),
                        ],
                      ),
                      4.heightBox,
                      Text(
                        user.email,
                        style: const TextStyle(
                          color: Colors.white60,
                          fontSize: 12,
                        ),
                      ),
                      4.heightBox,
                      Text(
                        'الدور: ${user.role} | المعرف: ${user.id}',
                        style: const TextStyle(
                          color: Colors.cyanAccent,
                          fontSize: 11,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        if (state is UserError) {
          final failure = state.failure;
          return Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: const Color(0xFF1E293B),
              borderRadius: 16.circularRadius,
              border: Border.all(
                color: Colors.redAccent.withValues(alpha: 0.6),
                width: 1.5,
              ),
            ),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  padding: const EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.redAccent.withValues(alpha: 0.2),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.error_outline_rounded,
                    color: Colors.redAccent,
                    size: 28,
                  ),
                ),
                12.widthBox,
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            failure.runtimeType.toString(),
                            style: const TextStyle(
                              color: Colors.redAccent,
                              fontWeight: FontWeight.bold,
                              fontSize: 14,
                            ),
                          ),
                          if (failure.statusCode != null) ...[
                            8.widthBox,
                            Container(
                              padding: const EdgeInsets.symmetric(
                                horizontal: 6,
                                vertical: 2,
                              ),
                              decoration: BoxDecoration(
                                color: Colors.redAccent.withValues(alpha: 0.2),
                                borderRadius: 4.circularRadius,
                              ),
                              child: Text(
                                '${failure.statusCode}',
                                style: const TextStyle(
                                  color: Colors.redAccent,
                                  fontSize: 10,
                                ),
                              ),
                            ),
                          ],
                        ],
                      ),
                      6.heightBox,
                      Text(
                        failure.message,
                        style: const TextStyle(
                          color: Colors.white70,
                          fontSize: 12,
                          height: 1.4,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        }

        // UserInitial
        return Container(
          padding: const EdgeInsets.all(24),
          alignment: Alignment.center,
          decoration: BoxDecoration(
            color: const Color(0xFF1E293B),
            borderRadius: 16.circularRadius,
            border: Border.all(color: Colors.white12),
          ),
          child: const Column(
            children: [
              Icon(Icons.touch_app_outlined, color: Colors.white38, size: 36),
              SizedBox(height: 8),
              Text(
                'اضغط على أحد الأزرار أعلاه لتجربة محاكاة الأخطاء والنجاح',
                style: TextStyle(color: Colors.white54, fontSize: 12),
              ),
            ],
          ),
        );
      },
    );
  }

  Widget _buildCodeSnippetCard() {
    const code =
        'final result = await repository.getUserProfile(scenario);\n\n'
        'result.fold(\n'
        '  (failure) => emit(UserError(failure)), // Left  <- Failure\n'
        '  (user)    => emit(UserLoaded(user)),   // Right <- Success\n'
        ');';

    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: const Color(0xFF1E293B),
        borderRadius: 16.circularRadius,
        border: Border.all(color: Colors.white12),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text(
            '💻 كيف يتم فك النتيجة في الـ Cubit عبر fold():',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 13,
            ),
          ),
          10.heightBox,
          const CopyableCodeBlock(
            code: code,
            copiedMessage: 'تم نسخ الكود',
            copyTooltip: 'نسخ الكود',
          ),
        ],
      ),
    );
  }
}
