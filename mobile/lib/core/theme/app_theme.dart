import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'app_colors.dart';

/// Text styles from the designs: Archivo for headings, Public Sans for everything else.
class AppText {
  AppText._();

  static TextStyle heading(
    double size, {
    FontWeight weight = FontWeight.w800,
    Color color = AppColors.text,
    double? letterSpacing,
  }) =>
      GoogleFonts.archivo(
        fontSize: size,
        fontWeight: weight,
        color: color,
        letterSpacing: letterSpacing,
      );

  static TextStyle body(
    double size, {
    FontWeight weight = FontWeight.w400,
    Color color = AppColors.text,
    double? height,
  }) =>
      GoogleFonts.publicSans(
        fontSize: size,
        fontWeight: weight,
        color: color,
        height: height,
      );

  /// Small uppercase label, e.g. "WORKSPACE".
  static TextStyle get label =>
      body(11.5, weight: FontWeight.w600, color: AppColors.textFaint).copyWith(letterSpacing: 0.6);
}

class AppTheme {
  AppTheme._();

  /// Light status-bar icons on the dark background.
  static const SystemUiOverlayStyle overlayStyle = SystemUiOverlayStyle(
    statusBarColor: Colors.transparent,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.dark,
  );

  static ThemeData dark() {
    const scheme = ColorScheme.dark(
      primary: AppColors.gold,
      onPrimary: AppColors.onGold,
      primaryContainer: Color(0xFF3A2F12),
      onPrimaryContainer: Color(0xFFE8C468),
      secondary: AppColors.green,
      onSecondary: Colors.white,
      secondaryContainer: Color(0xFF1C2E19),
      onSecondaryContainer: Color(0xFF6FBF63),
      tertiary: AppColors.orange,
      onTertiary: Colors.white,
      tertiaryContainer: Color(0xFF3A1F0E),
      onTertiaryContainer: Color(0xFFE0691C),
      error: AppColors.danger,
      onError: AppColors.onGold,
      surface: AppColors.surface,
      onSurface: AppColors.text,
      onSurfaceVariant: AppColors.textMuted,
      surfaceTint: Colors.transparent,
      surfaceContainerLowest: AppColors.bg,
      surfaceContainerLow: AppColors.surface,
      surfaceContainer: AppColors.surface,
      surfaceContainerHigh: AppColors.surfaceRaised,
      surfaceContainerHighest: AppColors.surfaceRaised,
      outline: AppColors.outline,
      outlineVariant: AppColors.border,
    );

        // 1. Fetch the default Material 3 base typography layout rules
    final m3Baseline = Typography.material2021(platform: TargetPlatform.android).white;

    // 2. Map your custom text rules explicitly without using chained copyWith methods
    final finalTextTheme = TextTheme(
      displayLarge: m3Baseline.displayLarge,
      displayMedium: m3Baseline.displayMedium,
      displaySmall: m3Baseline.displaySmall,
      headlineLarge: m3Baseline.headlineLarge,
      headlineMedium: AppText.heading(26),
      headlineSmall: AppText.heading(20, weight: FontWeight.w700),
      titleLarge: AppText.heading(18),
      titleMedium: AppText.heading(16, weight: FontWeight.w700),
      titleSmall: AppText.heading(14, weight: FontWeight.w700),
      bodyLarge: m3Baseline.bodyLarge?.merge(GoogleFonts.publicSans(color: AppColors.text)),
      bodyMedium: m3Baseline.bodyMedium?.merge(GoogleFonts.publicSans(color: AppColors.text)),
      bodySmall: m3Baseline.bodySmall?.merge(GoogleFonts.publicSans(color: AppColors.text)),
      labelLarge: m3Baseline.labelLarge?.merge(GoogleFonts.publicSans(color: AppColors.text)),
      labelMedium: m3Baseline.labelMedium?.merge(GoogleFonts.publicSans(color: AppColors.text)),
      labelSmall: m3Baseline.labelSmall?.merge(GoogleFonts.publicSans(color: AppColors.text)),
    );


    final buttonShape = RoundedRectangleBorder(borderRadius: BorderRadius.circular(12));

    return ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorScheme: scheme,
      scaffoldBackgroundColor: AppColors.bg,
      canvasColor: AppColors.surfaceRaised,
      textTheme: finalTextTheme,
      dividerTheme: const DividerThemeData(color: AppColors.border, thickness: 1, space: 1),
      filledButtonTheme: FilledButtonThemeData(
        style: FilledButton.styleFrom(
          backgroundColor: AppColors.gold,
          foregroundColor: AppColors.onGold,
          minimumSize: const Size(64, 44),
          shape: buttonShape,
          textStyle: AppText.body(14.5, weight: FontWeight.w600),
        ),
      ),
      outlinedButtonTheme: OutlinedButtonThemeData(
        style: OutlinedButton.styleFrom(
          foregroundColor: AppColors.text,
          side: const BorderSide(color: AppColors.outline),
          minimumSize: const Size(64, 44),
          shape: buttonShape,
          textStyle: AppText.body(14.5, weight: FontWeight.w600),
        ),
      ),
      textButtonTheme: TextButtonThemeData(
        style: TextButton.styleFrom(
          foregroundColor: AppColors.gold,
          textStyle: AppText.body(14, weight: FontWeight.w600),
        ),
      ),
      floatingActionButtonTheme: FloatingActionButtonThemeData(
        backgroundColor: AppColors.gold,
        foregroundColor: AppColors.onGold,
        elevation: 2,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      ),
      snackBarTheme: SnackBarThemeData(
        backgroundColor: AppColors.surfaceRaised,
        contentTextStyle: AppText.body(14),
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
      ),
      progressIndicatorTheme: const ProgressIndicatorThemeData(color: AppColors.gold),
    );
  }

  /// Text-field look from the designs: rounded, filled, gold when focused.
  /// Used explicitly by the screens that were redesigned.
  static InputDecoration inputDecoration({
    String? label,
    String? hint,
    String? helper,
    Widget? prefixIcon,
    Widget? suffixIcon,
    Color fill = AppColors.surface,
  }) {
    OutlineInputBorder border(Color color) => OutlineInputBorder(
          borderRadius: BorderRadius.circular(10),
          borderSide: BorderSide(color: color),
        );

    return InputDecoration(
      labelText: label,
      hintText: hint,
      helperText: helper,
      prefixIcon: prefixIcon,
      suffixIcon: suffixIcon,
      prefixIconColor: AppColors.textFaint,
      suffixIconColor: AppColors.textFaint,
      filled: true,
      fillColor: fill,
      isDense: true,
      contentPadding: const EdgeInsets.symmetric(horizontal: 14, vertical: 14),
      labelStyle: AppText.body(14, color: AppColors.textMuted),
      floatingLabelStyle: AppText.body(14, color: AppColors.gold),
      hintStyle: AppText.body(14, color: AppColors.textFaint),
      helperStyle: AppText.body(12, color: AppColors.textFaint),
      border: border(AppColors.border),
      enabledBorder: border(AppColors.border),
      focusedBorder: border(AppColors.gold),
      errorBorder: border(AppColors.danger),
      focusedErrorBorder: border(AppColors.danger),
    );
  }
}
