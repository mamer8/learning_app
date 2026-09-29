import 'package:equatable/equatable.dart';

/// الفئة الأساسية لجميع الأخطاء في طبقة الـ Domain والـ Presentation
/// Base Failure class extending [Equatable] for value equality comparison
abstract class Failure extends Equatable {
  final String message;
  final int? statusCode;

  const Failure({
    required this.message,
    this.statusCode,
  });

  @override
  List<Object?> get props => [message, statusCode];
}

/// خطأ قادم من السيرفر (مثل 500 Internal Server Error أو أخطاء الاستجابة)
class ServerFailure extends Failure {
  const ServerFailure({
    super.message = 'حدث خطأ غير متوقع في الخادم، يرجى المحاولة لاحقاً.',
    super.statusCode = 500,
  });
}

/// خطأ في الاتصال بالشبكة أو انقطاع الإنترنت (SocketException / No Internet)
class NetworkFailure extends Failure {
  const NetworkFailure({
    super.message = 'لا يوجد اتصال بالإنترنت، يرجى التحقق من الشبكة.',
    super.statusCode,
  });
}

/// خطأ الصلاحيات أو انتهاء الجلسة (401 Unauthorized / 403 Forbidden)
class UnauthorizedFailure extends Failure {
  const UnauthorizedFailure({
    super.message = 'انتهت جلستك أو ليس لديك صلاحية للوصول لهذا المورد.',
    super.statusCode = 401,
  });
}

/// خطأ في التخزين المؤقت أو قراءة قاعدة البيانات المحلية
class CacheFailure extends Failure {
  const CacheFailure({
    super.message = 'فشل في استرجاع البيانات من الذاكرة المحلية.',
    super.statusCode,
  });
}

/// خطأ في التحقق من صحة المدخلات (Validation Failure / 422 Unprocessable)
class ValidationFailure extends Failure {
  const ValidationFailure({
    required super.message,
    super.statusCode = 422,
  });
}

/// خطأ انتهاء وقت الطلب (Timeout Failure / 408)
class TimeoutFailure extends Failure {
  const TimeoutFailure({
    super.message = 'استغرق الطلب وقتاً أطول من المعتاد، يرجى المحاولة ثانية.',
    super.statusCode = 408,
  });
}

/// خطأ عام غير معروف
class UnknownFailure extends Failure {
  const UnknownFailure({
    super.message = 'حدث خطأ مجهول، يرجى المحاولة مرة أخرى.',
    super.statusCode,
  });
}
