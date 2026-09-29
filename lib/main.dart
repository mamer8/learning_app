import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';

import 'core/localization/app_localizations.dart';
import 'features/home/home_screen.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const FlutterLearningLabApp());
}

class FlutterLearningLabApp extends StatefulWidget {
  const FlutterLearningLabApp({super.key});

  @override
  State<FlutterLearningLabApp> createState() => _FlutterLearningLabAppState();
}

class _FlutterLearningLabAppState extends State<FlutterLearningLabApp> {
  Locale _locale = const Locale('ar', 'EG');

  void _toggleLanguage() {
    setState(() {
      _locale = _locale.languageCode == 'ar'
          ? const Locale('en', 'US')
          : const Locale('ar', 'EG');
    });
  }

  @override
  Widget build(BuildContext context) {
    final strings = AppStrings(isArabic: _locale.languageCode == 'ar');

    return AppLocaleScope(
      locale: _locale,
      onToggleLanguage: _toggleLanguage,
      child: MaterialApp(
        title: strings.t('appTitle'),
        debugShowCheckedModeBanner: false,
        locale: _locale,
        supportedLocales: const [Locale('ar', 'EG'), Locale('en', 'US')],
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        themeMode: ThemeMode.dark,
        theme: _buildTheme(Brightness.light),
        darkTheme: _buildTheme(Brightness.dark),
        home: const HomeScreen(),
      ),
    );
  }

  ThemeData _buildTheme(Brightness brightness) {
    final isDark = brightness == Brightness.dark;
    final scheme = ColorScheme.fromSeed(
      seedColor: const Color(0xFF14B8A6),
      brightness: brightness,
    );

    return ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme.copyWith(
        surface: isDark ? const Color(0xFF101828) : const Color(0xFFF8FAFC),
        primary: const Color(0xFF14B8A6),
        secondary: const Color(0xFFF59E0B),
        tertiary: const Color(0xFF60A5FA),
      ),
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0B1220)
          : const Color(0xFFF8FAFC),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Colors.transparent,
        foregroundColor: Colors.white,
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? const Color(0xFF172033) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      textTheme: const TextTheme(
        titleLarge: TextStyle(fontWeight: FontWeight.w800),
        titleMedium: TextStyle(fontWeight: FontWeight.w700),
        bodyMedium: TextStyle(height: 1.45),
      ),
    );
  }
}
