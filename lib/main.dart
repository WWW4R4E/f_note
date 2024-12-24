import 'package:flutter/material.dart';
import '/pages/NotePage.dart';
import '/pages/HomePage.dart';
import '/pages/EditorPage.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: '笔记',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(
            seedColor: const Color.fromARGB(255, 230, 179, 83)),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/editor': (context) => const EditorPage(),
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/note') {
          final args = settings.arguments as Map<String, dynamic>;
          final String title = args['title'] ?? '';
          final String text = args['text'] ?? '';
          return MaterialPageRoute(
            builder: (context) {
              return NotePage(title: title, text: text);
            },
          );
        }
        // 其他路由配置
        return null;
      },
    );
  }
}