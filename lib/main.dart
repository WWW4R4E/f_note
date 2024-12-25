import 'package:f_note/Pages/NotePage.dart';
import 'package:f_note/Pages/SettingPage.dart';
import 'package:f_note/Theme.dart';
import 'package:f_note/provider/ThemNotifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:provider/provider.dart';

import '/pages/EditorPage.dart';
import '/pages/HomePage.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => ThemeNotifier(),
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return Consumer<ThemeNotifier>(
      builder: (context, themeNotifier, child) {
        return MaterialApp(
          title: '笔记',
          theme: GlobalThemData.lightThemeData(themeNotifier.fontSize),
          darkTheme: GlobalThemData.darkThemeData(themeNotifier.fontSize),
          themeMode: themeNotifier.themeMode,
          localizationsDelegates: [
            GlobalMaterialLocalizations.delegate,
            GlobalWidgetsLocalizations.delegate,
            GlobalCupertinoLocalizations.delegate,
          ],
          supportedLocales: [
            const Locale('zh', 'CN'),
          ],
          initialRoute: '/',
          routes: {
            '/': (context) => const HomePage(),
            '/setting': (context) => const SettingPage(),
          },
          onGenerateRoute: (settings) {
            if (settings.name == '/note') {
              final args = settings.arguments as Map<String, dynamic>?;

              if (args != null) {
                final title = args['fileName'] as String?;
                final path = args['filePath'] as String?;

                if (title != null && path != null) {
                  return MaterialPageRoute(
                    builder: (context) => NotePage(title: title, path: path),
                  );
                }
              }
            }

            if (settings.name == '/editor') {
              final args = settings.arguments as Map<String, dynamic>?;

              if (args == null) {
                return MaterialPageRoute(
                  builder: (context) => const EditorPage(),
                );
              } else {
                final title = args['fileName'] as String?;
                final text = args['context'] as String?;

                if (title != null && text != null) {
                  // print('title: $title, text: $text');
                  return MaterialPageRoute(
                    builder: (context) => EditorPage(title: title, text: text),
                  );
                }
              }
            }
            return null;
          },
        );
      },
    );
  }
}
