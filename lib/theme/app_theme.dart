import 'package:flutter/material.dart';
import 'tw_colors.dart';

extension TailwindTheme on ThemeData {
  TWColors get twColors => extension<TWColors>()!;
}

final lightTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.light,
  primaryColor: const Color(0xFF2563EB),
  colorScheme: const ColorScheme(
    brightness: Brightness.light,
    primary: Color(0xFF2563EB),
    onPrimary: Color(0xFF2563EB),
    secondary: Color(0xFF4B7BFF),
    onSecondary: Color(0xFF4B7BFF),
    error: Colors.red,
    onError: Colors.red,
    background: Colors.white,
    onBackground: Colors.white,
    surface: Colors.white,
    onSurface: Colors.black,
  ),
  appBarTheme: const AppBarTheme(elevation: 0, color: Colors.white),
  extensions: const <ThemeExtension<dynamic>>[
    TWColors(
        primary: Color(0xFF2563EB),
        primaryHover: Color(0xFF1D4ED8),
        primaryDisable: Color(0xFF94BFFF),
        primaryBackgroundColor: Color(0xFFFFFFFF),
        secondBackgroundColor: Color(0xFFF3F4F6),
        thirdBackgroundColor: Color(0xFFE5E7EB),
        primaryTextColor: Color(0xFF111827),
        secondTextColor: Color(0xFF6B7280),
        thirdTextColor: Color(0xFF9CA3AF),
        dialogBackgroundColor: Color(0xFFFFFFFF),
        dividerBackgroundColor: Color(0xFFE5E5E5),
        inputBackgroundColor: Color(0xFFF6F6FA),
        fillOffBackgroundColor: Color(0xFFE5E7EB),
        iconSelectedFillColor: Color(0xFFE8F3FF),
        iconTintColor: Color(0xFF000000)

        ),
  ],
);

final darkTheme = ThemeData(
  useMaterial3: false,
  brightness: Brightness.dark,
  primaryColor: const Color(0xFF3B82F6),
  colorScheme: const ColorScheme(
    brightness: Brightness.dark,
    primary: Color(0xFF3B82F6),
    onPrimary: Color(0xFF3B82F6),
    secondary: Color(0xFF658AFF),
    onSecondary: Color(0xFF658AFF),
    error: Colors.red,
    onError: Colors.red,
    background: Colors.black,
    onBackground: Colors.black,
    surface: Colors.black,
    onSurface: Colors.white,
  ),
  appBarTheme: const AppBarTheme(
    elevation: 0,
    color: Color(0xFF25262A),
  ),
  extensions: const <ThemeExtension<dynamic>>[
    TWColors(
        primary: Color(0xFF3B82F6),
        primaryHover: Color(0xFF2563EB),
        primaryDisable: Color(0x993B82F6),
        primaryBackgroundColor: Color(0xFF25262A),
        secondBackgroundColor: Color(0xFF17181C),
        thirdBackgroundColor: Color(0xFF36373C),
        primaryTextColor: Color(0xFFFFFFFF),
        secondTextColor: Color(0xFFD1D5DB),
        thirdTextColor: Color(0xFF6B7280),
        dialogBackgroundColor: Color(0xFF25262A),
        dividerBackgroundColor: Color(0xFF404040),
        inputBackgroundColor: Color(0x1A3B82F6),
        fillOffBackgroundColor: Color(0xFF4B5563),
        iconSelectedFillColor: Color(0x294F6EFF),
        iconTintColor: Color(0xFFFFFFFF)
        ),
  ],
);
