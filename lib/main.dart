import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/home_screen.dart';
import 'screens/landing_screen.dart';
import 'screens/portal_screen.dart';
import 'supabase/supabase_config.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await initializeSupabase();
  runApp(
    ChangeNotifierProvider(
      create: (_) => AppState(),
      child: const ServiceDogPrepApp(),
    ),
  );
}

class ServiceDogPrepApp extends StatelessWidget {
  const ServiceDogPrepApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Service Dog Trainer Pro',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF1A2A4A),
          secondary: const Color(0xFFD4AF37),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF9F0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF1A2A4A),
          foregroundColor: Colors.white,
          elevation: 0,
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: const Color(0xFFD4AF37),
            foregroundColor: const Color(0xFF1A2A4A),
          ),
        ),
      ),
      home: Consumer<AppState>(
        builder: (context, state, _) {
          return state.isLoggedIn ? const PortalScreen() : const LandingScreen();
        },
      ),
    );
  }
}
