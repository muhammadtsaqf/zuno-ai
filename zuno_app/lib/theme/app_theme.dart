import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class AppTheme {
  // Cyber Dark Palette
  static const Color bgDark = Color(0xFF0F0E17);
  static const Color cardDark = Color(0xFF1B1A29);
  static const Color surfaceDark = Color(0xFF252338);

  static const Color primaryNeon = Color(0xFF6C5CE7); // Cyber Purple
  static const Color secondaryNeon = Color(0xFF00F5D4); // Cyber Cyan
  static const Color accentPink = Color(0xFFFF007F); // Hot Pink
  static const Color userBubbleColor = Color(0xFF6C5CE7);
  static const Color aiBubbleColor = Color(0xFF222035);

  static const Color textLight = Color(0xFFFFFFFE);
  static const Color textMuted = Color(0xFFA7A9BE);

  static ThemeData get darkTheme {
    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      scaffoldBackgroundColor: bgDark,
      primaryColor: primaryNeon,
      colorScheme: const ColorScheme.dark(
        primary: primaryNeon,
        secondary: secondaryNeon,
        surface: cardDark,
        background: bgDark,
        error: accentPink,
      ),
      textTheme: GoogleFonts.plusJakartaSansTextTheme(
        ThemeData.dark().textTheme.copyWith(
          displayLarge: const TextStyle(color: textLight, fontWeight: FontWeight.bold),
          bodyLarge: const TextStyle(color: textLight),
          bodyMedium: const TextStyle(color: textMuted),
        ),
      ),
      appBarTheme: const AppBarTheme(
        backgroundColor: bgDark,
        elevation: 0,
        centerTitle: true,
        iconTheme: IconThemeData(color: textLight),
      ),
      cardTheme: CardTheme(
        color: cardDark,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
          side: BorderSide(color: primaryNeon.withOpacity(0.2), width: 1),
        ),
      ),
    );
  }
}
