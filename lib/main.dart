import 'package:flutter/material.dart';
import 'package:gemini_ai_test/pages/chat_page.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Belajar Bikin AI',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: const Color(0xff149954)),
        useMaterial3: true,
      ),
      routes: {
        '/': (context) => const ChatPage(),
      },
    );
  }
}
