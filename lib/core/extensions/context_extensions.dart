import 'package:flutter/material.dart';

/// امتدادات مخصصة لـ [BuildContext] لتسهيل الوصول للأبعاد، الثيم، التنقل، والرسائل المنبثقة
/// Custom [BuildContext] extensions for quick access to MediaQuery, Theme, Navigation, and SnackBars.
extension BuildContextExtensions on BuildContext {
  // ===========================================================================
  // 1. أبعاد الشاشة (Screen Dimensions & Responsive Helpers)
  // ===========================================================================

  /// عرض الشاشة الكلي
  double get width => MediaQuery.sizeOf(this).width;

  /// ارتفاع الشاشة الكلي
  double get height => MediaQuery.sizeOf(this).height;

  /// نسبة العرض إلى الارتفاع
  double get aspectRatio => MediaQuery.sizeOf(this).aspectRatio;

  /// اتجاه الشاشة (عمودي)
  bool get isPortrait => MediaQuery.orientationOf(this) == Orientation.portrait;

  /// اتجاه الشاشة (أفقي)
  bool get isLandscape => MediaQuery.orientationOf(this) == Orientation.landscape;

  /// فحص ما إذا كان الجهاز هاتفاً (عرض أقل من 600)
  bool get isMobile => width < 600;

  /// فحص ما إذا كان الجهاز لوحياً (Tablet)
  bool get isTablet => width >= 600 && width < 1024;

  /// فحص ما إذا كان الجهاز شاشة حاسوب (Desktop)
  bool get isDesktop => width >= 1024;

  /// حشوة الحواف الآمنة (SafeArea Padding)
  EdgeInsets get padding => MediaQuery.paddingOf(this);

  // ===========================================================================
  // 2. الثيم والألوان والخطوط (Theme, Colors & Typography)
  // ===========================================================================

  /// كائن الـ ThemeData الحالي
  ThemeData get theme => Theme.of(this);

  /// لوحة الألوان (ColorScheme) الحالية
  ColorScheme get colorScheme => Theme.of(this).colorScheme;

  /// أنماط النصوص (TextTheme) الحالية
  TextTheme get textTheme => Theme.of(this).textTheme;

  /// هل التطبيق في الوضع الليلي (Dark Mode)؟
  bool get isDarkMode => theme.brightness == Brightness.dark;

  /// الألوان الشائعة للتسهيل
  Color get primaryColor => colorScheme.primary;
  Color get secondaryColor => colorScheme.secondary;
  Color get backgroundColor => colorScheme.surface;
  Color get errorColor => colorScheme.error;

  // ===========================================================================
  // 3. التنقل بين الشاشات (Navigation Helpers)
  // ===========================================================================

  /// الانتقال لشاشة جديدة عبر كائن الـ Widget مباشرة
  Future<T?> push<T>(Widget page) {
    return Navigator.of(this).push<T>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// الانتقال لشاشة جديدة باستخدام Route مخصص مع حركة انتقال سلسة
  Future<T?> pushWithFade<T>(Widget page) {
    return Navigator.of(this).push<T>(
      PageRouteBuilder(
        pageBuilder: (context, animation, secondaryAnimation) => page,
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(opacity: animation, child: child);
        },
      ),
    );
  }

  /// الانتقال لشاشة جديدة واستبدال الشاشة الحالية
  Future<T?> pushReplacement<T, TO>(Widget page) {
    return Navigator.of(this).pushReplacement<T, TO>(
      MaterialPageRoute(builder: (_) => page),
    );
  }

  /// الانتقال وحذف جميع الشاشات السابقة من الـ Stack
  Future<T?> pushAndRemoveUntil<T>(Widget page) {
    return Navigator.of(this).pushAndRemoveUntil<T>(
      MaterialPageRoute(builder: (_) => page),
      (route) => false,
    );
  }

  /// الرجوع للشاشة السابقة
  void pop<T extends Object?>([T? result]) {
    if (Navigator.of(this).canPop()) {
      Navigator.of(this).pop<T>(result);
    }
  }

  // ===========================================================================
  // 4. رسائل التنبيه العصرية (Modern SnackBars)
  // ===========================================================================

  /// إظهار SnackBar مخصص للنجاح بلون أخضر وتصميم عائم
  void showSuccessSnackBar(String message, {String? title}) {
    _showCustomSnackBar(
      message: message,
      title: title ?? 'نجاح العملية',
      backgroundColor: const Color(0xFF10B981),
      icon: Icons.check_circle_rounded,
    );
  }

  /// إظهار SnackBar مخصص للخطأ بلون أحمر عصري
  void showErrorSnackBar(String message, {String? title}) {
    _showCustomSnackBar(
      message: message,
      title: title ?? 'حدث خطأ',
      backgroundColor: const Color(0xFFEF4444),
      icon: Icons.error_rounded,
    );
  }

  /// إظهار SnackBar مخصص للمعلومات بلون أزرق
  void showInfoSnackBar(String message, {String? title}) {
    _showCustomSnackBar(
      message: message,
      title: title ?? 'تنبيه',
      backgroundColor: const Color(0xFF3B82F6),
      icon: Icons.info_rounded,
    );
  }

  /// الدالة الداخلية لتوليد SnackBar بتصميم أنيق وزوايا دائرية
  void _showCustomSnackBar({
    required String message,
    required String title,
    required Color backgroundColor,
    required IconData icon,
  }) {
    final messenger = ScaffoldMessenger.of(this);
    messenger.hideCurrentSnackBar();
    messenger.showSnackBar(
      SnackBar(
        behavior: SnackBarBehavior.floating,
        backgroundColor: Colors.transparent,
        elevation: 0,
        margin: const EdgeInsets.all(16),
        content: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          decoration: BoxDecoration(
            color: backgroundColor,
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: backgroundColor.withValues(alpha: 0.35),
                blurRadius: 16,
                offset: const Offset(0, 6),
              ),
            ],
          ),
          child: Row(
            children: [
              Icon(icon, color: Colors.white, size: 28),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: const TextStyle(
                        color: Colors.white,
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      message,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
