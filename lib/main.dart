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
    ).copyWith(
      surface: isDark ? const Color(0xFF101828) : const Color(0xFFF8FAFC),
      primary: const Color(0xFF14B8A6),
      secondary: const Color(0xFFF59E0B),
      tertiary: const Color(0xFF60A5FA),
    );

    final baseTheme = ThemeData(
      useMaterial3: true,
      brightness: brightness,
      colorScheme: scheme,
    );

    return baseTheme.copyWith(
      scaffoldBackgroundColor: isDark
          ? const Color(0xFF0B1220)
          : const Color(0xFFF8FAFC),
      appBarTheme: const AppBarTheme(
        elevation: 0,
        scrolledUnderElevation: 0,
        centerTitle: false,
        backgroundColor: Color(0xFF0A0F1D),
        foregroundColor: Colors.white,
      ),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: const Color(0xFF14B8A6),
          foregroundColor: const Color(0xFF04111C),
          minimumSize: const Size.fromHeight(48),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: const Color(0xFF5EEAD4),
        ),
      ),
      inputDecorationTheme: InputDecorationTheme(
        filled: true,
        fillColor: const Color(0xFF101828),
        contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF24324A)),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF24324A)),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8),
          borderSide: const BorderSide(color: Color(0xFF14B8A6), width: 1.4),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 0,
        color: isDark ? const Color(0xFF172033) : Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(8)),
      ),
      textTheme: baseTheme.textTheme.copyWith(
        headlineSmall: baseTheme.textTheme.headlineSmall?.copyWith(
          fontSize: 18,
          fontWeight: FontWeight.w800,
          height: 1.25,
        ),
        titleLarge: baseTheme.textTheme.titleLarge?.copyWith(
          fontSize: 15,
          fontWeight: FontWeight.w800,
        ),
        titleMedium: baseTheme.textTheme.titleMedium?.copyWith(
          fontSize: 13.5,
          fontWeight: FontWeight.w700,
        ),
        titleSmall: baseTheme.textTheme.titleSmall?.copyWith(
          fontSize: 12.5,
          fontWeight: FontWeight.w600,
        ),
        bodyLarge: baseTheme.textTheme.bodyLarge?.copyWith(
          fontSize: 13,
          height: 1.45,
        ),
        bodyMedium: baseTheme.textTheme.bodyMedium?.copyWith(
          fontSize: 12,
          height: 1.4,
        ),
        bodySmall: baseTheme.textTheme.bodySmall?.copyWith(
          fontSize: 11,
          height: 1.35,
        ),
        labelLarge: baseTheme.textTheme.labelLarge?.copyWith(
          fontSize: 12,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }
}
