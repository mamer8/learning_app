import 'dart:math';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class NotificationService extends ChangeNotifier {
  NotificationService._();
  static final NotificationService instance = NotificationService._();

  static const String _notificationsEnabledKey = 'daily_notifications_enabled';
  bool _isEnabled = true;

  bool get isEnabled => _isEnabled;

  final List<String> _motivationalLabSuggestions = [
    'جرب مختبر جديد اليوم: حركات وفيزياء ناعمة (Animation Physics) 🚀',
    'تحدي اليوم: تسريع الرسم وعزل الـ RepaintBoundary ⚡',
    'فكرة اليوم: اختبار الأداء وتنظيف الذاكرة Memory Profiling 🧹',
    'مهارة جديدة: تدفق البيانات اللحظية Reactive Streams 🌊',
    'سر معماري: إدارة الحالة ومقارنة Cubit مع setState 🧭',
    'أمان اليوم: تشفير الـ JWT وتجديد الـ Access Token تلقائياً 🔒',
    'جودة الكود: كتابة Unit Tests و Mocktail قبل الإنتاج 🧪',
    'تخزين محلي: معاملات SQLite و Hive Outbox Sync Queue 🗄️',
  ];

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    _isEnabled = prefs.getBool(_notificationsEnabledKey) ?? true;
  }

  Future<void> toggleNotifications(bool enabled) async {
    _isEnabled = enabled;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool(_notificationsEnabledKey, enabled);
    notifyListeners();
  }

  /// الحصول على اقتراح تحفيزي عشوائي لليوم
  String getRandomDailySuggestion() {
    final random = Random();
    return _motivationalLabSuggestions[random.nextInt(_motivationalLabSuggestions.length)];
  }

  /// محاكاة إطلاق إشعار محلي مع SnackBar تفاعلي
  void triggerSimulatedDailyNotification(BuildContext context) {
    final suggestion = getRandomDailySuggestion();
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF0F172A),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
          side: const BorderSide(color: Color(0xFF14B8A6), width: 1),
        ),
        content: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: const Color(0xFF14B8A6).withValues(alpha: 0.15),
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(Icons.notifications_active_rounded,
                  color: Color(0xFF5EEAD4), size: 20),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    '🔔 إشعار تحفيزي يومي (Daily Challenge):',
                    style: TextStyle(
                      color: Color(0xFF5EEAD4),
                      fontWeight: FontWeight.bold,
                      fontSize: 11.5,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    suggestion,
                    style: const TextStyle(color: Colors.white, fontSize: 11),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
