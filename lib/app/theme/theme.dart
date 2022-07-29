import 'package:flutter/material.dart';
import 'color_schemes.g.dart';

class JointPurchasesTheme {
  static ThemeData get light {
    return ThemeData(
      useMaterial3: true,
      colorScheme: lightColorScheme,
      inputDecorationTheme:
          const InputDecorationTheme(border: OutlineInputBorder()),
    );
  }

  static ThemeData get dark {
    return ThemeData(
      useMaterial3: true,
      colorScheme: darkColorScheme,
      inputDecorationTheme:
          const InputDecorationTheme(border: OutlineInputBorder()),
    );
  }
}
