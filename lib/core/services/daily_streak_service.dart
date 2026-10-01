import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

class StreakData {
  final int currentStreak;
  final int maxStreak;
  final String lastActiveDate; // YYYY-MM-DD
  final int totalActiveDays;
  final List<String> unlockedBadges;

  const StreakData({
    required this.currentStreak,
    required this.maxStreak,
    required this.lastActiveDate,
    required this.totalActiveDays,
    required this.unlockedBadges,
  });

  factory StreakData.empty() => const StreakData(
        currentStreak: 0,
        maxStreak: 0,
        lastActiveDate: '',
        totalActiveDays: 0,
        unlockedBadges: [],
      );

  Map<String, dynamic> toJson() => {
        'currentStreak': currentStreak,
        'maxStreak': maxStreak,
        'lastActiveDate': lastActiveDate,
        'totalActiveDays': totalActiveDays,
        'unlockedBadges': unlockedBadges,
      };

  factory StreakData.fromJson(Map<String, dynamic> json) => StreakData(
        currentStreak: (json['currentStreak'] as num?)?.toInt() ?? 0,
        maxStreak: (json['maxStreak'] as num?)?.toInt() ?? 0,
        lastActiveDate: json['lastActiveDate'] as String? ?? '',
        totalActiveDays: (json['totalActiveDays'] as num?)?.toInt() ?? 0,
        unlockedBadges: (json['unlockedBadges'] as List<dynamic>?)
                ?.map((e) => e.toString())
                .toList() ??
            [],
      );
}

/// خدمة سلاسل الإنجاز اليومية والتحفيز (Daily Streaks Engine)
class DailyStreakService extends ChangeNotifier {
  DailyStreakService._();
  static final DailyStreakService instance = DailyStreakService._();

  static const String _storageKey = 'user_daily_streak_v1';
  StreakData _data = StreakData.empty();

  StreakData get data => _data;
  int get currentStreak => _data.currentStreak;
  int get maxStreak => _data.maxStreak;
  List<String> get unlockedBadges => _data.unlockedBadges;

  Future<void> init() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getString(_storageKey);
    if (raw != null) {
      try {
        _data = StreakData.fromJson(jsonDecode(raw) as Map<String, dynamic>);
      } catch (_) {
        _data = StreakData.empty();
      }
    }
    await recordDailyActivity();
  }

  /// تسجيل نشاط اليوم وتحديث سلسلة الـ Streak تلقائياً
  Future<void> recordDailyActivity() async {
    final now = DateTime.now();
    final todayStr = '${now.year}-${now.month.toString().padLeft(2, '0')}-${now.day.toString().padLeft(2, '0')}';

    if (_data.lastActiveDate == todayStr) {
      return; // تم تسجيل النشاط لليوم بالفعل
    }

    int newStreak = _data.currentStreak;
    int newTotalDays = _data.totalActiveDays + 1;

    if (_data.lastActiveDate.isNotEmpty) {
      final lastDate = DateTime.tryParse(_data.lastActiveDate);
      if (lastDate != null) {
        final diffInDays = DateTime(now.year, now.month, now.day)
            .difference(DateTime(lastDate.year, lastDate.month, lastDate.day))
            .inDays;

        if (diffInDays == 1) {
          // يوم متتالي!
          newStreak += 1;
        } else if (diffInDays > 1) {
          // انقطعت السلسلة
          newStreak = 1;
        }
      } else {
        newStreak = 1;
      }
    } else {
      newStreak = 1;
    }

    final newMaxStreak = newStreak > _data.maxStreak ? newStreak : _data.maxStreak;
    final badges = Set<String>.from(_data.unlockedBadges);

    if (newStreak >= 1) badges.add('first_spark');
    if (newStreak >= 3) badges.add('momentum_3');
    if (newStreak >= 7) badges.add('streak_master_7');
    if (newStreak >= 14) badges.add('architect_14');
    if (newTotalDays >= 30) badges.add('flutter_legend_30');

    _data = StreakData(
      currentStreak: newStreak,
      maxStreak: newMaxStreak,
      lastActiveDate: todayStr,
      totalActiveDays: newTotalDays,
      unlockedBadges: badges.toList(),
    );

    final prefs = await SharedPreferences.getInstance();
    await prefs.setString(_storageKey, jsonEncode(_data.toJson()));
    notifyListeners();
  }
}
