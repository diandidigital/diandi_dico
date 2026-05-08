import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'providers/dictionary_provider.dart';
import 'screens/home_screen.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (_) => DictionaryProvider()..init(),
      child: const DiandIDicoApp(),
    ),
  );
}

class DiandIDicoApp extends StatelessWidget {
  const DiandIDicoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'TranslateHub',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7E57C2),
          brightness: Brightness.light,
        ),
      ),
      darkTheme: ThemeData(
        useMaterial3: true,
        colorScheme: ColorScheme.fromSeed(
          seedColor: const Color(0xFF7E57C2),
          brightness: Brightness.dark,
        ),
      ),
      themeMode: ThemeMode.system,
      home: const HomeScreen(),
    );
  }
}
