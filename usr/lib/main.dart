import 'package:flutter/material.dart';
import 'package:couldai_user_app/screens/main_scaffold.dart';
import 'package:couldai_user_app/screens/chat_screen.dart';

void main() {
  runApp(const NoorApp());
}

class NoorApp extends StatelessWidget {
  const NoorApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Noor Health Assistant',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF00BFA5), // Medical Teal
          primary: const Color(0xFF009688),
          secondary: const Color(0xFF4DB6AC),
          surface: const Color(0xFFF5F7FA),
        ),
        appBarTheme: const AppBarTheme(
          centerTitle: true,
          elevation: 0,
          backgroundColor: Colors.transparent,
          foregroundColor: Colors.black87,
        ),
        cardTheme: CardTheme(
          elevation: 2,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
          color: Colors.white,
        ),
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const MainScaffold(),
        '/chat': (context) => const ChatScreen(),
      },
    );
  }
}
