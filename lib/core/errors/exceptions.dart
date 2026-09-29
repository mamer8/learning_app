/// الفئات الاستثنائية (Exceptions) التي تُرمى في طبقة الـ Data Sources
/// Exceptions thrown by Data Sources before being caught and converted to Failures in Repositories
library;

/// استثناء السيرفر
class ServerException implements Exception {
  final String message;
  final int? statusCode;

  const ServerException({
    this.message = 'Server encountered an unexpected error',
    this.statusCode = 500,
  });

  @override
  String toString() => 'ServerException: [$statusCode] $message';
}

/// استثناء الشبكة
class NetworkException implements Exception {
  final String message;

  const NetworkException({
    this.message = 'No internet connection or host unreachable',
  });

  @override
  String toString() => 'NetworkException: $message';
}

/// استثناء عدم المصادقة
class UnauthorizedException implements Exception {
  final String message;

  const UnauthorizedException({
    this.message = 'User is unauthorized or session expired',
  });

  @override
  String toString() => 'UnauthorizedException: $message';
}

/// استثناء التخزين المحلي
class CacheException implements Exception {
  final String message;

  const CacheException({
    this.message = 'Failed to read or write local cache',
  });

  @override
  String toString() => 'CacheException: $message';
}

/// استثناء انتهاء مهلة الطلب
class TimeoutExceptionCustom implements Exception {
  final String message;

  const TimeoutExceptionCustom({
    this.message = 'Request connection timed out',
  });

  @override
  String toString() => 'TimeoutExceptionCustom: $message';
}
