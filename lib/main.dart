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
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (context) => ThemeNotifier()),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    final themeNotifier = Provider.of<ThemeNotifier>(context);
    return MaterialApp(
      title: '笔记',
      themeMode: themeNotifier.themeMode,
      theme: GlobalThemData.lightThemeData(themeNotifier.fontSize),
      darkTheme: GlobalThemData.darkThemeData(themeNotifier.fontSize),
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations
            .delegate, //一定要配置,否则iphone手机长按编辑框有白屏卡着的bug出现
      ],
      supportedLocales: [
        const Locale('zh', 'CN'), //设置语言为中文
      ],
      initialRoute: '/',
      routes: {
        '/': (context) => const HomePage(),
        '/setting': (context) => SettingPage(),
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
              print('title: $title, text: $text');
              return MaterialPageRoute(
                builder: (context) => EditorPage(title: title, text: text),
              );
            }
          }
        }

        return null;
      },
    );
  }
}
