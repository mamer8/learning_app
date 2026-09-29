import '../../../../core/core.dart';
import '../../domain/entities/user_profile.dart';
import '../../domain/repositories/user_repository.dart';

/// واجهة مصدر البيانات البعيد
abstract class UserRemoteDataSource {
  Future<UserProfile> fetchUserProfile(MockScenario scenario);
}

/// تنفيذ مصدر البيانات الوهمي لمحاكاة استجابات السيرفر والأخطاء المختلفة
class MockUserRemoteDataSourceImpl implements UserRemoteDataSource {
  @override
  Future<UserProfile> fetchUserProfile(MockScenario scenario) async {
    // محاكاة تأخير الشبكة
    await Future.delayed(const Duration(milliseconds: 600));

    switch (scenario) {
      case MockScenario.success:
        return const UserProfile(
          id: 'USR-7789',
          name: 'م. أحمد محمود',
          email: 'ahmed.dev@flutter-lab.io',
          role: 'Senior Flutter Engineer',
          avatarUrl: 'https://images.unsplash.com/photo-1534528741775-53994a69daeb',
        );

      case MockScenario.unauthorized:
        throw const UnauthorizedException(
          message: 'رمز المصادقة (Token) منتهي الصلاحية أو غير صالح [401]',
        );

      case MockScenario.noInternet:
        throw const NetworkException(
          message: 'تعذر الوصول إلى الخادم، يرجى فحص اتصالك بالإنترنت [SocketException]',
        );

      case MockScenario.serverError:
        throw const ServerException(
          message: 'حدث عطل داخلي في خوادم قاعدة البيانات [500 Internal Server Error]',
          statusCode: 500,
        );

      case MockScenario.timeout:
        throw const TimeoutExceptionCustom(
          message: 'انتهت مهلة انتظار استجابة الخادم [408 Request Timeout]',
        );
    }
  }
}
