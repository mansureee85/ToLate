import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';
import '../core/speech/speech_input_service.dart';
import '../data/repositories/admin_repository.dart';
import '../data/repositories/auth_repository.dart';
import '../data/repositories/interaction_repository.dart';
import '../data/repositories/location_repository.dart';
import '../data/repositories/property_repository.dart';
import '../data/repositories/review_repository.dart';
import 'app_router.dart';
import 'app_theme.dart';

/// Root application widget configuring dependency injection and routing.
class ToLateApp extends StatelessWidget {
  const ToLateApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => AuthRepository()),
        ChangeNotifierProvider(create: (_) => LocationRepository()),
        ChangeNotifierProvider(create: (_) => PropertyRepository()),
        ChangeNotifierProvider(create: (_) => ReviewRepository()),
        ChangeNotifierProvider(create: (_) => InteractionRepository()),
        ChangeNotifierProxyProvider<PropertyRepository, AdminRepository>(
          create: (ctx) => AdminRepository(ctx.read<PropertyRepository>()),
          update: (ctx, propertyRepo, previous) =>
              previous ?? AdminRepository(propertyRepo),
        ),
        ChangeNotifierProvider(create: (_) => SpeechInputService()),
      ],
      child: MaterialApp.router(
        title: 'ToLate - Bangladesh Property Marketplace',
        debugShowCheckedModeBanner: false,
        theme: AppTheme.lightTheme,
        routerConfig: AppRouter.router,
        localizationsDelegates: const [
          GlobalMaterialLocalizations.delegate,
          GlobalWidgetsLocalizations.delegate,
          GlobalCupertinoLocalizations.delegate,
        ],
        supportedLocales: const [
          Locale('bn', 'BD'), // Bangla (Bangladesh)
          Locale('en', 'US'), // English
        ],
      ),
    );
  }
}

