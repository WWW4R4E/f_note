import 'package:f_note/Pages/NotePage.dart';
import 'package:flutter/material.dart';

import '/pages/EditorPage.dart';
import '/pages/HomePage.dart';

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
      },
      onGenerateRoute: (settings) {
        if (settings.name == '/note') {
          final args = settings.arguments as Map<String, String>;
          final title = args['fileName'] as String;
          final path = args['filePath'] as String;
          return MaterialPageRoute(
            builder: (context) => NotePage(title: title, path: path),
          );
        }
        if (settings.name == '/editor') {
          if (settings.arguments == null) {
            return MaterialPageRoute(
              builder: (context) => const EditorPage(),
            );
          }
          final args = settings.arguments as Map<String, String>;
          final title = args['fileName'] as String;
          final text = args['context'] as String;
             print('title: $title, text: $text');
          return MaterialPageRoute(
            builder: (context) => EditorPage(title: title, text: text),
          );
        }
        return null;
      },
    );
  }
}
