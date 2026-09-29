import 'dart:async';
import 'package:flutter/foundation.dart';

/// كلاس الـ [Throttler]: يضمن تنفيذ عملية واحدة كحد أقصى خلال فترة زمنية محددة.
/// مفيد جداً للأزرار الحساسة (مثل أزرار الدفع Payment Buttons، تسجيل الإعجاب Like Buttons،
/// أو أحداث التمرير والتكبير Scroll/Resize Events) لمنع الضغطات المتتالية السريعة (Spam Clicks).
///
/// How it works:
/// ينفذ الطلب الأول فوراً، ويتجاهل أي طلبات لاحقة حتى تنتهي فترة الـ [interval].
class Throttler {
  /// الفترة الزمنية الفاصلة بين كل تنفيذ مسموح به
  final Duration interval;
  Timer? _timer;
  bool _isThrottling = false;

  Throttler({this.interval = const Duration(milliseconds: 1000)});

  /// هل الـ Throttler نشط ويتجاهل النقرات حالياً؟
  bool get isThrottling => _isThrottling;

  /// تنفيذ العملية إذا لم تكن قيد الـ Throttling
  /// يعيد `true` إذا تم تنفيذ العملية، و `false` إذا تم تجاهلها
  bool run(VoidCallback action) {
    if (_isThrottling) {
      return false; // تجاهل النداء لأنه تم استدعاؤه مبكراً جداً
    }

    _isThrottling = true;
    action();

    _timer = Timer(interval, () {
      _isThrottling = false;
      _timer = null;
    });

    return true;
  }

  /// تنفيذ عملية غير متزامنة (Async Action)
  Future<bool> runAsync(Future<void> Function() asyncAction) async {
    if (_isThrottling) {
      return false;
    }

    _isThrottling = true;
    try {
      await asyncAction();
    } finally {
      _timer = Timer(interval, () {
        _isThrottling = false;
        _timer = null;
      });
    }

    return true;
  }

  /// إعادة تعيين الحالة فوراً
  void reset() {
    _timer?.cancel();
    _timer = null;
    _isThrottling = false;
  }

  /// تنظيف الموارد
  void dispose() {
    reset();
  }
}
