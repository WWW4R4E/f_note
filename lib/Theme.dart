import 'package:flutter/material.dart';

class GlobalThemData {
  static final Color _lightFocusColor = Colors.black.withOpacity(0.12);
  static final Color _darkFocusColor = Colors.white.withOpacity(0.12);

  /// 定义浅色模式主题
  static ThemeData lightThemeData(double fontSize) =>
      themeData(lightColorScheme, _lightFocusColor, fontSize);

  /// 定义深色模式主题
  static ThemeData darkThemeData(double fontSize) =>
      themeData(darkColorScheme, _darkFocusColor, fontSize);

  /// 创建自定义主题数据
  static ThemeData themeData(
      ColorScheme colorScheme, Color focusColor, double fontSize) {
    return ThemeData(
      colorScheme: colorScheme,
      // 设置背景颜色
      canvasColor: colorScheme.surface,
      scaffoldBackgroundColor: colorScheme.surface,
      // 禁用高亮效果
      highlightColor: Colors.transparent,
      // 设置焦点颜色
      focusColor: focusColor,
      textTheme: TextTheme(
        bodyMedium: TextStyle(fontSize: fontSize),
      ),
    );
  }

  static const ColorScheme lightColorScheme = ColorScheme(
    primary: Color.fromARGB(255, 210, 189, 81),
    onPrimary: Color.fromARGB(122, 0, 0, 0),
    secondary: Color(0xFFEFF3F3),
    onSecondary: Color(0xFF322942),
    error: Color.fromARGB(102, 131, 173, 4),
    onError: Colors.white,
    surface: Color(0xFFFAFBFB),
    onSurface: Color(0xFF241E30),
    brightness: Brightness.light,
  );
  static const ColorScheme darkColorScheme = ColorScheme(
    primary: Color(0xFFBB86FC),
    secondary: Color(0xFF03DAC6),
    surface: Color(0xFF202020), // 调整为更亮的颜色
    onSurface: Color(0xFFE0E0E0),
    error: Color(0xFFCF6679),
    onPrimary: Color(0xFF000000),
    onSecondary: Color(0xFF000000),
    onError: Color(0xFF000000),
    brightness: Brightness.dark,
  );
}