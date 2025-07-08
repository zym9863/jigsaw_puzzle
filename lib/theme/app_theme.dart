import 'package:flutter/material.dart';

class AppTheme {
  // 主色调
  static const Color primaryBlue = Color(0xFF4A90E2);
  static const Color primaryYellow = Color(0xFFF5A623);
  
  // 辅助色
  static const Color successGreen = Color(0xFF50C878);
  static const Color backgroundGrey = Color(0xFFE8ECEF);
  static const Color textDarkGrey = Color(0xFF333333);
  
  // 渐变色
  static const List<Color> blueGradient = [Color(0xFF4A90E2), Color(0xFFA3CFFA)];
  static const List<Color> yellowGradient = [Color(0xFFF5A623), Color(0xFFFF7043)];
  
  // 获取主题数据
  static ThemeData getTheme() {
    return ThemeData(
      useMaterial3: true,
      colorScheme: ColorScheme.fromSeed(
        seedColor: primaryBlue,
        primary: primaryBlue,
        secondary: primaryYellow,
        tertiary: successGreen,
        background: backgroundGrey,
      ),
      scaffoldBackgroundColor: backgroundGrey,
      appBarTheme: const AppBarTheme(
        backgroundColor: primaryBlue,
        foregroundColor: Colors.white,
        elevation: 2,
        centerTitle: true,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.vertical(
            bottom: Radius.circular(15),
          ),
        ),
      ),
      cardTheme: CardThemeData(
        elevation: 4,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(12),
        ),
        clipBehavior: Clip.antiAlias,
      ),
      elevatedButtonTheme: ElevatedButtonThemeData(
        style: ElevatedButton.styleFrom(
          backgroundColor: primaryYellow,
          foregroundColor: Colors.white,
          elevation: 3,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
        ),
      ),
      textTheme: const TextTheme(
        displayLarge: TextStyle(color: textDarkGrey, fontWeight: FontWeight.bold),
        displayMedium: TextStyle(color: textDarkGrey, fontWeight: FontWeight.bold),
        displaySmall: TextStyle(color: textDarkGrey, fontWeight: FontWeight.bold),
        headlineLarge: TextStyle(color: textDarkGrey, fontWeight: FontWeight.bold),
        headlineMedium: TextStyle(color: textDarkGrey, fontWeight: FontWeight.w600),
        titleLarge: TextStyle(color: textDarkGrey, fontWeight: FontWeight.w600),
        titleMedium: TextStyle(color: textDarkGrey),
        bodyLarge: TextStyle(color: textDarkGrey),
        bodyMedium: TextStyle(color: textDarkGrey),
      ),
    );
  }
}