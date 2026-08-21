import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Central color & style tokens for Lumora (Strict Palette: #F6F6F6, #82976C, #323232 + Streak)
class AppColors {
  static const bg = Color(0xFFF6F6F6);          // Fond principal (#f6f6f6)
  static const bgOuter = Color(0xFFF6F6F6);     // Fond extérieur (#f6f6f6)
  static const surface = Color(0xFFF6F6F6);     // Cartes (#f6f6f6)
  static const surface2 = Color(0xFFF6F6F6);    // Cartes secondaires (#f6f6f6)
  static const surface3 = Color(0xFFF6F6F6);    // Éléments secondaires (#f6f6f6)
  static const text = Color(0xFF323232);         // Texte & icônes sombres (#323232)
  static const muted = Color(0xFF323232);        // Texte secondaire
  static const lime = Color(0xFF82976C);         // Vert signature (#82976c)
  static const lime2 = Color(0xFF82976C);        // Vert signature (#82976c)
  static const limeLight = Color(0xFF82976C);    // Fond doux sauge
  static const bannerBg = Color(0xFF82976C);     // Bannière accent (#82976c)
  static const bannerLight = Color(0xFFF6F6F6);  // Fond clair
  static const chipBg = Color(0xFFF6F6F6);       // Fond des tags
  static const neoBorder = Color(0xFF323232);    // Bordure sombre (#323232)
  static const stickerNew = Color(0xFF82976C);   // Sticker vert (#82976c)
  static const stickerPin = Color(0xFF82976C);   // Sticker vert (#82976c)
  static const line = Color(0xFF323232);         // Bordure interne

  // Exception explicite : Streak
  static const amber = Color(0xFFE5A632);        // Doré / Orange flamme de streak
  static const fireBg = Color(0xFFFDECD2);       // Fond flamme streak
}

class AppRadius {
  static const card = 18.0;
  static const lesson = 16.0;
  static const icon = 14.0;
  static const chip = 10.0;
  static const button = 12.0;
  static const sticker = 8.0;
}

class AppShadows {
  /// Neo-Brutalist Hard Drop Shadow with sharp zero blur
  static List<BoxShadow> neo({double offset = 3.5, Color color = AppColors.neoBorder}) => [
        BoxShadow(
          color: color,
          offset: Offset(offset, offset),
          blurRadius: 0,
          spreadRadius: 0,
        ),
      ];

  static List<BoxShadow> get card => neo(offset: 3.5);
  static List<BoxShadow> get cardSmall => neo(offset: 2.5);
  static List<BoxShadow> get button => neo(offset: 3.0);
  static List<BoxShadow> get floating => neo(offset: 5.0);
}

class AppBorders {
  static Border neo({double width = 2.0, Color color = AppColors.neoBorder}) =>
      Border.all(color: color, width: width);
}

TextStyle heading(double size, {FontWeight weight = FontWeight.w800, Color? color, double? letterSpacing}) {
  return GoogleFonts.outfit(
    fontSize: size,
    fontWeight: weight,
    color: color ?? AppColors.text,
    letterSpacing: letterSpacing ?? -0.5,
    height: 1.15,
  );
}

TextStyle body(double size, {FontWeight weight = FontWeight.w500, Color? color, double? height}) {
  return GoogleFonts.dmSans(
    fontSize: size,
    fontWeight: weight,
    color: color ?? AppColors.text,
    height: height ?? 1.3,
  );
}

ThemeData buildLumoraTheme() {
  return ThemeData(
    useMaterial3: true,
    scaffoldBackgroundColor: AppColors.bgOuter,
    fontFamily: GoogleFonts.dmSans().fontFamily,
    colorScheme: const ColorScheme.light(
      primary: AppColors.lime,
      secondary: AppColors.lime2,
      surface: AppColors.surface,
      onPrimary: AppColors.bg,
    ),
    splashColor: AppColors.lime.withValues(alpha: 0.12),
    highlightColor: Colors.transparent,
  );
}
