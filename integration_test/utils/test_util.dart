import 'package:flutter/material.dart';
import 'package:flutter_config/flutter_config.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:kayla_flutter_ic/api/oauth_service.dart';
import 'package:kayla_flutter_ic/di/di.dart';
import 'package:kayla_flutter_ic/main.dart';
import 'package:package_info_plus/package_info_plus.dart';

import '../fake_services/fake_oauth_service.dart';

class TestUtil {
  /// This is useful when we test the whole app with the real configs(styling,
  /// localization, routes, etc)
  static Widget pumpWidgetWithRealApp(String initialRoute) {
    _initDependencies();
    return const MyApp();
  }

  /// We normally use this function to test a specific [widget] without
  /// considering much about theming.
  static Widget pumpWidgetWithShellApp(Widget widget) {
    _initDependencies();
    return MaterialApp(
      localizationsDelegates: AppLocalizations.localizationsDelegates,
      supportedLocales: AppLocalizations.supportedLocales,
      home: ProviderScope(child: widget),
    );
  }

  static void _initDependencies() {
    PackageInfo.setMockInitialValues(
      appName: 'Flutter templates testing',
      packageName: '',
      version: '',
      buildNumber: '',
      buildSignature: '',
      installerStore: '',
    );
    FlutterConfig.loadValueForTesting({
      'REST_API_ENDPOINT': 'REST_API_ENDPOINT',
      'CLIENT_ID': 'CLIENT_ID',
      'CLIENT_SECRET': 'CLIENT_SECRET',
    });
  }

  static Future setupTestEnvironment() async {
    _initDependencies();
    getIt.allowReassignment = true;
    getIt.registerSingleton<OAuthService>(FakeOAuthService());
    await configureDependencies();
  }
}
