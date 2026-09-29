import 'package:flutter/material.dart';

/// امتدادات للأرقام (num) لإنشاء مسافات (SizedBox) بشكل سريع وسلس
/// Number extensions for quick spacing in layouts
extension NumSpacingExtension on num {
  /// مسافة رأسية سريعة: `16.heightBox` بدلاً من `SizedBox(height: 16)`
  Widget get heightBox => SizedBox(height: toDouble());

  /// مسافة أفقية سريعة: `12.widthBox` بدلاً من `SizedBox(width: 12)`
  Widget get widthBox => SizedBox(width: toDouble());

  /// حواف دائرية سريعة: `16.circularRadius`
  BorderRadius get circularRadius => BorderRadius.circular(toDouble());

  /// زاوية دائرية سريعة: `16.circularRadiusValue`
  Radius get circularRadiusValue => Radius.circular(toDouble());

  /// مدة زمنية بالمللي ثانية: `300.milliseconds`
  Duration get milliseconds => Duration(milliseconds: toInt());

  /// مدة زمنية بالثواني: `2.seconds`
  Duration get seconds => Duration(seconds: toInt());
}

/// امتدادات للـ Widget لإضافة حشوة، محاذاة، وتوسيع بسهولة
/// Widget extensions for chaining layout helpers
extension WidgetExtension on Widget {
  /// إضافة Padding شامل لجميع الجهات
  Widget paddingAll(double padding) {
    return Padding(
      padding: EdgeInsets.all(padding),
      child: this,
    );
  }

  /// إضافة Padding متماثل أفقي وعمودي
  Widget paddingSymmetric({double horizontal = 0.0, double vertical = 0.0}) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: horizontal, vertical: vertical),
      child: this,
    );
  }

  /// إضافة Padding لجهات محددة فقط
  Widget paddingOnly({
    double left = 0.0,
    double top = 0.0,
    double right = 0.0,
    double bottom = 0.0,
  }) {
    return Padding(
      padding: EdgeInsets.only(
        left: left,
        top: top,
        right: right,
        bottom: bottom,
      ),
      child: this,
    );
  }

  /// توسيط الـ Widget
  Widget center() => Center(child: this);

  /// جعل الـ Widget يملأ المساحة المتاحة داخل Row أو Column
  Widget expanded({int flex = 1}) => Expanded(flex: flex, child: this);

  /// جعل الـ Widget مرناً بحسب محتواه
  Widget flexible({int flex = 1, FlexFit fit = FlexFit.loose}) =>
      Flexible(flex: flex, fit: fit, child: this);

  /// إضافة حركة عند النقر أو الضغط
  Widget onTap(VoidCallback? onTap, {BorderRadius? borderRadius}) {
    return Material(
      color: Colors.transparent,
      child: InkWell(
        borderRadius: borderRadius ?? BorderRadius.circular(12),
        onTap: onTap,
        child: this,
      ),
    );
  }

  /// إخفاء الـ Widget بشكل شرطي مع الاحتفاظ بالحجم أو بدونه
  Widget isVisible(bool visible, {bool maintainState = false}) {
    return Visibility(
      visible: visible,
      maintainState: maintainState,
      child: this,
    );
  }
}

/// امتدادات للتحقق ومعالجة النصوص (String Validations & Helpers)
/// String validation & utility extensions
extension StringValidationExtension on String {
  /// التحقق من صحة صيغة البريد الإلكتروني
  bool get isValidEmail {
    final emailRegExp = RegExp(
      r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$',
    );
    return emailRegExp.hasMatch(trim());
  }

  /// التحقق من صحة رقم الهاتف الدولي أو المحلي
  bool get isValidPhone {
    final phoneRegExp = RegExp(r'^\+?[0-9]{8,15}$');
    return phoneRegExp.hasMatch(replaceAll(RegExp(r'[\s-]'), ''));
  }

  /// التحقق من صحة الرابط (URL)
  bool get isValidUrl {
    final urlRegExp = RegExp(
      r'^(http|https):\/\/[a-zA-Z0-9\-\.]+\.[a-zA-Z]{2,}(\/\S*)?$',
    );
    return urlRegExp.hasMatch(trim());
  }

  /// تحويل الحرف الأول إلى حرف كبير
  String get capitalizeFirst {
    if (isEmpty) return this;
    return '${this[0].toUpperCase()}${substring(1)}';
  }
}
