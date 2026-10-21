import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/app_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize App Configuration
  AppConfig.initialize(
    const AppConfig(
      appVersion: '1.0.0',
      buildNumber: '1',
      apiBaseUrl: 'https://api.tolate.bd',
      enableVoiceToText: true,
      enableVideoUploads: true,
      isProduction: false,
    ),
  );

  runApp(const ToLateApp());
}
