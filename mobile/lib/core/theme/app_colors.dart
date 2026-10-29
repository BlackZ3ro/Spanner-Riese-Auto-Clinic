import 'package:flutter/material.dart';

/// Colour tokens from the approved dark-theme designs.
class AppColors {
  AppColors._();

  // Surfaces
  static const bg = Color(0xFF16181A); // screen background
  static const surface = Color(0xFF1F2224); // cards, app bars
  static const surfaceRaised = Color(0xFF262A2D); // dialogs, menus
  static const border = Color(0xFF2C3033); // hairlines, card borders
  static const outline = Color(0xFF3A3E41); // outlined buttons, empty step circles

  // Text
  static const text = Color(0xFFF2F1ED);
  static const textMuted = Color(0xFF9BA1A6);
  static const textFaint = Color(0xFF6B7075);

  // Gold: brand and main actions
  static const gold = Color(0xFFD4A72C);
  static const onGold = Color(0xFF16181A); // dark text/icons on gold

  // Solid fills used for step circles
  static const green = Color(0xFF4C9A44);
  static const orange = Color(0xFFC9480A);

  // Destructive actions and validation errors
  static const danger = Color(0xFFE5604F);
  static const dangerOutline = Color(0x80E5604F);
}

/// The three accent roles used across the app:
/// gold = brand / actions, green = done / positive, orange = active / needs attention.
enum AppTone {
  gold(solid: AppColors.gold, chipBg: Color(0xFF3A2F12), chipText: Color(0xFFE8C468)),
  green(solid: AppColors.green, chipBg: Color(0xFF1C2E19), chipText: Color(0xFF6FBF63)),
  orange(solid: AppColors.orange, chipBg: Color(0xFF3A1F0E), chipText: Color(0xFFE0691C));

  const AppTone({required this.solid, required this.chipBg, required this.chipText});

  final Color solid;
  final Color chipBg;
  final Color chipText;
}
