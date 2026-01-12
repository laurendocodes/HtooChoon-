import 'package:flutter/material.dart';

import 'package:flutter/material.dart';

class AppColors {
  // Core Palette
  static const granite = Color(0xFF3C493F);
  static const greyOlive = Color(0xFF7E8D85);
  static const ashGrey = Color(0xFFB3BFB8);
  static const mintCream = Color(0xFFF0F7F4);
  static const celadon = Color(0xFFA2E3C4);
}

class AppTheme {
  static ThemeData lightTheme = ThemeData(
    brightness: Brightness.light,

    scaffoldBackgroundColor: AppColors.mintCream,

    primaryColor: AppColors.granite,

    colorScheme: const ColorScheme.light(
      primary: AppColors.granite,
      secondary: AppColors.celadon,
      background: AppColors.mintCream,
      surface: Colors.white,
      onPrimary: Colors.white,
      onSecondary: AppColors.granite,
      onBackground: AppColors.granite,
      onSurface: AppColors.granite,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.granite,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: AppColors.granite),
      bodyMedium: TextStyle(color: AppColors.granite),
      titleLarge: TextStyle(
        color: AppColors.granite,
        fontWeight: FontWeight.bold,
      ),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.celadon,
        foregroundColor: AppColors.granite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Colors.white,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.ashGrey),
      ),
    ),
  );

  static ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,

    scaffoldBackgroundColor: AppColors.granite,

    primaryColor: AppColors.celadon,

    colorScheme: const ColorScheme.dark(
      primary: AppColors.celadon,
      secondary: AppColors.greyOlive,
      background: AppColors.granite,
      surface: Color(0xFF2F3A33),
      onPrimary: AppColors.granite,
      onSecondary: Colors.white,
      onBackground: Colors.white,
      onSurface: Colors.white,
    ),

    appBarTheme: const AppBarTheme(
      backgroundColor: AppColors.granite,
      foregroundColor: Colors.white,
      elevation: 0,
    ),

    textTheme: const TextTheme(
      bodyLarge: TextStyle(color: Colors.white),
      bodyMedium: TextStyle(color: Colors.white70),
      titleLarge: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
    ),

    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: AppColors.celadon,
        foregroundColor: AppColors.granite,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      ),
    ),

    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: Color(0xFF2F3A33),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(12),
        borderSide: BorderSide(color: AppColors.greyOlive),
      ),
    ),
  );
}

// const Color? guideTextColor = Color(0xFF797979);
// ThemeData lightMode = ThemeData(
//   fontFamily: "Poppins",
//   textTheme: TextTheme(
//     headlineLarge: TextStyle(
//       fontFamily: 'Poppins',
//       fontWeight: FontWeight.bold,
//     ),
//     headlineMedium: TextStyle(
//       fontFamily: 'Poppins',
//       fontWeight: FontWeight.w600,
//     ),
//     bodyMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.normal),
//     bodyLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.normal),
//   ),
//   colorScheme: ColorScheme.light(
//     background: Color(0xFFFAFAF5), // Warm White
//     primary: Color(0xFF660F09), // Soft Blue
//     secondary: Color(0xFFBFBD72), // Light Teal
//     tertiary: Color(0xFFAD7A32), // Misty Gray
//     inversePrimary: Color(0xFF333333), // Deep Charcoal
//   ),
// );
// // ThemeData lightMode = ThemeData(
// //     fontFamily: "Poppins",
// //     textTheme: TextTheme(
// //       headlineLarge:
// //           TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.bold),
// //       headlineMedium:
// //           TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.w600),
// //       bodyMedium:
// //           TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.normal),
// //       bodyLarge:
// //           TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.normal),
// //     ),
// //     colorScheme: ColorScheme.light(
// //       background: Colors.white,
// //       primary: Color(0xFF991602),
// //       secondary: Color(0xFFF2F2F2),
// //       tertiary: Color(0xFFEFEFEF),
// //       inversePrimary: Colors.black,
// //
// //       // Color(0xFF797979)
// //     ));
// ThemeData darkMode = ThemeData(
//   fontFamily: "Poppins",
//   textTheme: TextTheme(
//     headlineLarge: TextStyle(
//       fontFamily: 'Poppins',
//       fontWeight: FontWeight.bold,
//     ),
//     headlineMedium: TextStyle(
//       fontFamily: 'Poppins',
//       fontWeight: FontWeight.w600,
//     ),
//     bodyMedium: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.normal),
//     bodyLarge: TextStyle(fontFamily: 'Poppins', fontWeight: FontWeight.normal),
//   ),
//   colorScheme: ColorScheme.light(
//     background: Colors.grey.shade900,
//     primary: Colors.grey.shade600,
//     secondary: Colors.grey.shade700,
//     tertiary: Colors.grey.shade800,
//     inversePrimary: Colors.grey.shade300,
//   ),
// );
