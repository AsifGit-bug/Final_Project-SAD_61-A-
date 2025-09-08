import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';
import 'pages/login_page.dart';
import 'pages/register_page.dart';
import 'pages/home_page.dart';
import 'crud.dart';

// Create a global RouteObserver to track navigation
final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Supabase.initialize(
    url: "https://zdbhauozoqqrgqxnwypq.supabase.co",
    anonKey:
        "eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6InpkYmhhdW96b3FxcmdxeG53eXBxIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTcxODczNDUsImV4cCI6MjA3Mjc2MzM0NX0.pfwlX5Yuu-EEGDaxmND31dEpX0TX0mahfTJGL3ma0Zc",
  );
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final base = ThemeData(
      colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
      useMaterial3: true,
    );
    return MaterialApp(
      title: 'Book Management App',
      debugShowCheckedModeBanner: false,
      theme: base.copyWith(
        inputDecorationTheme: InputDecorationTheme(
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        ),
        elevatedButtonTheme: ElevatedButtonThemeData(
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.blue,
            foregroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            padding: const EdgeInsets.symmetric(vertical: 14, horizontal: 20),
          ),
        ),
        cardTheme: const CardThemeData(
          margin: EdgeInsets.symmetric(vertical: 6, horizontal: 4),
        ),
      ),
      navigatorObservers: [routeObserver], // <-- Add this line here
      routes: {
        '/': (_) => const LoginPage(),
        '/register': (_) => const RegisterPage(),
        '/home': (_) => const HomePage(),
        '/crud': (_) => const CrudPage(),
      },
    );
  }
}
