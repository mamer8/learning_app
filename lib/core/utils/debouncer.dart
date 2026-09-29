import 'dart:async';
import 'package:flutter/foundation.dart';

/// كلاس الـ [Debouncer]: يؤخر تنفيذ العملية حتى يتوقف المستخدم عن إرسال مدخلات لفترة محددة.
/// مفيد جداً في حقول البحث الفوري (Search-as-you-type) لمنع إرسال طلب API مع كل حرف.
///
/// How it works:
/// إذا تم استدعاء [run] أكثر من مرة خلال فترة [delay]، يتم إلغاء المؤقت السابق وبدء مؤقت جديد.
class Debouncer {
  /// المدة الزمنية المراد انتظارها قبل تنفيذ العملية
  final Duration delay;
  Timer? _timer;

  Debouncer({this.delay = const Duration(milliseconds: 500)});

  /// هل هناك عملية مؤجلة قيد الانتظار حالياً؟
  bool get isActive => _timer?.isActive ?? false;

  /// جدولة تنفيذ العملية بعد انقضاء المهلة [delay]
  void run(VoidCallback action) {
    // إلغاء أي طلب سابق كان ينتظر
    _timer?.cancel();

    // بدء مؤقت جديد
    _timer = Timer(delay, () {
      action();
    });
  }

  /// تنفيذ عملية غير متزامنة (Async)
  void runAsync(Future<void> Function() asyncAction) {
    _timer?.cancel();
    _timer = Timer(delay, () async {
      await asyncAction();
    });
  }

  /// إلغاء العملية المؤقتة الحالية
  void cancel() {
    _timer?.cancel();
    _timer = null;
  }

  /// تنظيف الموارد عند الانتهاء (في dispose الـ State)
  void dispose() {
    cancel();
  }
}
