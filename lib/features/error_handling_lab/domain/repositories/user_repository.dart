import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';
import '../entities/user_profile.dart';

/// واجهة المستودع (Domain Repository Contract)
/// تعتمد المعالجة الوظيفية للأخطاء باستخدام `Either<Failure, UserProfile>`
/// الطرف الأيسر (Left) يمثل الفشل (Failure)، والطرف الأيمن (Right) يمثل النجاح (Success)
abstract class UserRepository {
  /// جلب بيانات المستخدم مع إمكانية تحديد سيناريو المحاكاة
  Future<Either<Failure, UserProfile>> getUserProfile({
    required MockScenario scenario,
  });
}

/// سيناريوهات المحاكاة لاختبار مختلف أنواع الأخطاء
enum MockScenario {
  success,
  unauthorized,
  noInternet,
  serverError,
  timeout,
}
