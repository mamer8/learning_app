import 'package:flutter_dotenv/flutter_dotenv.dart';

enum AppFlavor {
  dev,
  staging,
  prod,
}

/// إدارة البيئات والفصائل المتعددة للتطبيق (Environment & Flavors Engine)
class AppEnvironment {
  AppEnvironment._();
  static final AppEnvironment instance = AppEnvironment._();

  static const String _defaultFlavorName = String.fromEnvironment(
    'FLAVOR',
    defaultValue: 'prod',
  );

  AppFlavor _flavor = AppFlavor.prod;

  AppFlavor get flavor => _flavor;
  bool get isDev => _flavor == AppFlavor.dev;
  bool get isStaging => _flavor == AppFlavor.staging;
  bool get isProd => _flavor == AppFlavor.prod;

  String get name => _flavor.name.toUpperCase();

  String get appTitle {
    switch (_flavor) {
      case AppFlavor.dev:
        return 'Flutter Academy (DEV)';
      case AppFlavor.staging:
        return 'Flutter Academy (STAGING)';
      case AppFlavor.prod:
        return 'Flutter Master Academy';
    }
  }

  String get baseUrl {
    switch (_flavor) {
      case AppFlavor.dev:
        return dotenv.maybeGet('DEV_API_URL') ?? 'https://api.dev.learning.flutter.dev';
      case AppFlavor.staging:
        return dotenv.maybeGet('STAGING_API_URL') ?? 'https://api.staging.learning.flutter.dev';
      case AppFlavor.prod:
        return dotenv.maybeGet('PROD_API_URL') ?? 'https://api.learning.flutter.dev';
    }
  }

  bool get enableDetailedLogging => isDev || isStaging;

  void init({AppFlavor? explicitFlavor}) {
    if (explicitFlavor != null) {
      _flavor = explicitFlavor;
      return;
    }

    final envFlavor = dotenv.maybeGet('APP_FLAVOR') ?? _defaultFlavorName;
    switch (envFlavor.toLowerCase()) {
      case 'dev':
      case 'development':
        _flavor = AppFlavor.dev;
        break;
      case 'staging':
      case 'qa':
        _flavor = AppFlavor.staging;
        break;
      case 'prod':
      case 'production':
      default:
        _flavor = AppFlavor.prod;
        break;
    }
  }
}
