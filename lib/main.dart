import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/app_state.dart';
import 'screens/home_screen.dart';
import 'screens/auth_screen.dart';
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
          seedColor: const Color(0xFF2E7D6F),
          brightness: Brightness.light,
        ),
        useMaterial3: true,
        scaffoldBackgroundColor: const Color(0xFFFFF8F0),
        appBarTheme: const AppBarTheme(
          backgroundColor: Color(0xFF2E7D6F),
          foregroundColor: Colors.white,
        ),
      ),
      home: Consumer<AppState>(
        builder: (context, state, _) {
          return state.isLoggedIn ? const HomeScreen() : const AuthScreen();
        },
      ),
    );
  }
}
