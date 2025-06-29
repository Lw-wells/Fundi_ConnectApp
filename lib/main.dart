import 'package:flutter/material.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

import 'login_screen.dart';
import 'signup_screen.dart';
import 'home_screen.dart';
import 'fundi_profile_screen.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();

  await Supabase.initialize(
    url: 'https://fcppairznxuunrkhoijp.supabase.co',
    anonKey:
        'eyJhbGciOiJIUzI1NiIsInR5cCI6IkpXVCJ9.eyJpc3MiOiJzdXBhYmFzZSIsInJlZiI6ImZjcHBhaXJ6bnh1dW5ya2hvaWpwIiwicm9sZSI6ImFub24iLCJpYXQiOjE3NTExOTUxMjIsImV4cCI6MjA2Njc3MTEyMn0.enY-QEVfCP5aYemACao8zf9zIP4kvCaYINbTeVS7Urg',
  );

  runApp(const FundiApp());
}

class FundiApp extends StatelessWidget {
  const FundiApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'FundiConnect',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
      ),
      initialRoute: '/login',
      routes: {
        '/login': (context) => const LoginScreen(),
        '/signup': (context) => const SignupScreen(),
        '/home': (context) => const HomeScreen(),

        // '/home': (context) => const MyHomePage(title: 'FundiConnect Home'),
        '/profile': (context) => FundiProfileScreen(),
      },
    );
  }
}
