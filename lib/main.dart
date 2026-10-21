import 'package:flutter/material.dart';
import 'app/app.dart';
import 'app/app_config.dart';
import 'core/services/firebase_service.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // Initialize Firebase (Auth, Firestore, Storage)
  await FirebaseService.initialize();

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
