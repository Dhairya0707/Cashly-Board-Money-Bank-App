import "package:flutter/material.dart";

class MaterialTheme {
  final TextTheme textTheme;

  const MaterialTheme(this.textTheme);

  static ColorScheme lightScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff006a66),
      surfaceTint: Color(0xff006a66),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff9df1eb),
      onPrimaryContainer: Color(0xff00201e),
      secondary: Color(0xff00696e),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff9cf0f6),
      onSecondaryContainer: Color(0xff002022),
      tertiary: Color(0xff38608f),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xffd2e4ff),
      onTertiaryContainer: Color(0xff001c37),
      error: Color(0xff904a43),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffffdad6),
      onErrorContainer: Color(0xff3b0907),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff191c20),
      onSurfaceVariant: Color(0xff3f4948),
      outline: Color(0xff6f7978),
      outlineVariant: Color(0xffbec9c7),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3035),
      inversePrimary: Color(0xff80d5cf),
      primaryFixed: Color(0xff9df1eb),
      onPrimaryFixed: Color(0xff00201e),
      primaryFixedDim: Color(0xff80d5cf),
      onPrimaryFixedVariant: Color(0xff00504c),
      secondaryFixed: Color(0xff9cf0f6),
      onSecondaryFixed: Color(0xff002022),
      secondaryFixedDim: Color(0xff80d4da),
      onSecondaryFixedVariant: Color(0xff004f53),
      tertiaryFixed: Color(0xffd2e4ff),
      onTertiaryFixed: Color(0xff001c37),
      tertiaryFixedDim: Color(0xffa2c9fe),
      onTertiaryFixedVariant: Color(0xff1d4875),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fa),
      surfaceContainer: Color(0xffecedf4),
      surfaceContainerHigh: Color(0xffe7e8ee),
      surfaceContainerHighest: Color(0xffe1e2e8),
    );
  }

  ThemeData light() {
    return theme(lightScheme());
  }

  static ColorScheme lightMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff004b48),
      surfaceTint: Color(0xff006a66),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff25817c),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff004b4f),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff238086),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff174471),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff5077a6),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff6e302a),
      onError: Color(0xffffffff),
      errorContainer: Color(0xffaa6058),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff191c20),
      onSurfaceVariant: Color(0xff3b4544),
      outline: Color(0xff576160),
      outlineVariant: Color(0xff737d7b),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3035),
      inversePrimary: Color(0xff80d5cf),
      primaryFixed: Color(0xff25817c),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff006763),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff238086),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff00666b),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff5077a6),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff365e8c),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fa),
      surfaceContainer: Color(0xffecedf4),
      surfaceContainerHigh: Color(0xffe7e8ee),
      surfaceContainerHighest: Color(0xffe1e2e8),
    );
  }

  ThemeData lightMediumContrast() {
    return theme(lightMediumContrastScheme());
  }

  static ColorScheme lightHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.light,
      primary: Color(0xff002725),
      surfaceTint: Color(0xff006a66),
      onPrimary: Color(0xffffffff),
      primaryContainer: Color(0xff004b48),
      onPrimaryContainer: Color(0xffffffff),
      secondary: Color(0xff002729),
      onSecondary: Color(0xffffffff),
      secondaryContainer: Color(0xff004b4f),
      onSecondaryContainer: Color(0xffffffff),
      tertiary: Color(0xff002343),
      onTertiary: Color(0xffffffff),
      tertiaryContainer: Color(0xff174471),
      onTertiaryContainer: Color(0xffffffff),
      error: Color(0xff44100c),
      onError: Color(0xffffffff),
      errorContainer: Color(0xff6e302a),
      onErrorContainer: Color(0xffffffff),
      surface: Color(0xfff8f9ff),
      onSurface: Color(0xff000000),
      onSurfaceVariant: Color(0xff1c2625),
      outline: Color(0xff3b4544),
      outlineVariant: Color(0xff3b4544),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xff2e3035),
      inversePrimary: Color(0xffa6fbf5),
      primaryFixed: Color(0xff004b48),
      onPrimaryFixed: Color(0xffffffff),
      primaryFixedDim: Color(0xff003331),
      onPrimaryFixedVariant: Color(0xffffffff),
      secondaryFixed: Color(0xff004b4f),
      onSecondaryFixed: Color(0xffffffff),
      secondaryFixedDim: Color(0xff003235),
      onSecondaryFixedVariant: Color(0xffffffff),
      tertiaryFixed: Color(0xff174471),
      onTertiaryFixed: Color(0xffffffff),
      tertiaryFixedDim: Color(0xff002e54),
      onTertiaryFixedVariant: Color(0xffffffff),
      surfaceDim: Color(0xffd8dae0),
      surfaceBright: Color(0xfff8f9ff),
      surfaceContainerLowest: Color(0xffffffff),
      surfaceContainerLow: Color(0xfff2f3fa),
      surfaceContainer: Color(0xffecedf4),
      surfaceContainerHigh: Color(0xffe7e8ee),
      surfaceContainerHighest: Color(0xffe1e2e8),
    );
  }

  ThemeData lightHighContrast() {
    return theme(lightHighContrastScheme());
  }

  static ColorScheme darkScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff80d5cf),
      surfaceTint: Color(0xff80d5cf),
      onPrimary: Color(0xff003734),
      primaryContainer: Color(0xff00504c),
      onPrimaryContainer: Color(0xff9df1eb),
      secondary: Color(0xff80d4da),
      onSecondary: Color(0xff003739),
      secondaryContainer: Color(0xff004f53),
      onSecondaryContainer: Color(0xff9cf0f6),
      tertiary: Color(0xffa2c9fe),
      onTertiary: Color(0xff00325a),
      tertiaryContainer: Color(0xff1d4875),
      onTertiaryContainer: Color(0xffd2e4ff),
      error: Color(0xffffb4ab),
      onError: Color(0xff561e19),
      errorContainer: Color(0xff73332d),
      onErrorContainer: Color(0xffffdad6),
      surface: Color(0xff111418),
      onSurface: Color(0xffe1e2e8),
      onSurfaceVariant: Color(0xffbec9c7),
      outline: Color(0xff889391),
      outlineVariant: Color(0xff3f4948),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2e8),
      inversePrimary: Color(0xff006a66),
      primaryFixed: Color(0xff9df1eb),
      onPrimaryFixed: Color(0xff00201e),
      primaryFixedDim: Color(0xff80d5cf),
      onPrimaryFixedVariant: Color(0xff00504c),
      secondaryFixed: Color(0xff9cf0f6),
      onSecondaryFixed: Color(0xff002022),
      secondaryFixedDim: Color(0xff80d4da),
      onSecondaryFixedVariant: Color(0xff004f53),
      tertiaryFixed: Color(0xffd2e4ff),
      onTertiaryFixed: Color(0xff001c37),
      tertiaryFixedDim: Color(0xffa2c9fe),
      onTertiaryFixedVariant: Color(0xff1d4875),
      surfaceDim: Color(0xff111418),
      surfaceBright: Color(0xff37393e),
      surfaceContainerLowest: Color(0xff0c0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData dark() {
    return theme(darkScheme());
  }

  static ColorScheme darkMediumContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xff85d9d3),
      surfaceTint: Color(0xff80d5cf),
      onPrimary: Color(0xff001a19),
      primaryContainer: Color(0xff489e99),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xff84d8de),
      onSecondary: Color(0xff001a1c),
      secondaryContainer: Color(0xff479da3),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xffa9cdff),
      onTertiary: Color(0xff00172f),
      tertiaryContainer: Color(0xff6c93c4),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xffffbab1),
      onError: Color(0xff330404),
      errorContainer: Color(0xffcc7b72),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff111418),
      onSurface: Color(0xfffafaff),
      onSurfaceVariant: Color(0xffc2cdcb),
      outline: Color(0xff9ba5a3),
      outlineVariant: Color(0xff7b8584),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2e8),
      inversePrimary: Color(0xff00514e),
      primaryFixed: Color(0xff9df1eb),
      onPrimaryFixed: Color(0xff001413),
      primaryFixedDim: Color(0xff80d5cf),
      onPrimaryFixedVariant: Color(0xff003d3b),
      secondaryFixed: Color(0xff9cf0f6),
      onSecondaryFixed: Color(0xff001416),
      secondaryFixedDim: Color(0xff80d4da),
      onSecondaryFixedVariant: Color(0xff003d40),
      tertiaryFixed: Color(0xffd2e4ff),
      onTertiaryFixed: Color(0xff001226),
      tertiaryFixedDim: Color(0xffa2c9fe),
      onTertiaryFixedVariant: Color(0xff013764),
      surfaceDim: Color(0xff111418),
      surfaceBright: Color(0xff37393e),
      surfaceContainerLowest: Color(0xff0c0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData darkMediumContrast() {
    return theme(darkMediumContrastScheme());
  }

  static ColorScheme darkHighContrastScheme() {
    return const ColorScheme(
      brightness: Brightness.dark,
      primary: Color(0xffeafffc),
      surfaceTint: Color(0xff80d5cf),
      onPrimary: Color(0xff000000),
      primaryContainer: Color(0xff85d9d3),
      onPrimaryContainer: Color(0xff000000),
      secondary: Color(0xffedfeff),
      onSecondary: Color(0xff000000),
      secondaryContainer: Color(0xff84d8de),
      onSecondaryContainer: Color(0xff000000),
      tertiary: Color(0xfffafaff),
      onTertiary: Color(0xff000000),
      tertiaryContainer: Color(0xffa9cdff),
      onTertiaryContainer: Color(0xff000000),
      error: Color(0xfffff9f9),
      onError: Color(0xff000000),
      errorContainer: Color(0xffffbab1),
      onErrorContainer: Color(0xff000000),
      surface: Color(0xff111418),
      onSurface: Color(0xffffffff),
      onSurfaceVariant: Color(0xfff3fdfb),
      outline: Color(0xffc2cdcb),
      outlineVariant: Color(0xffc2cdcb),
      shadow: Color(0xff000000),
      scrim: Color(0xff000000),
      inverseSurface: Color(0xffe1e2e8),
      inversePrimary: Color(0xff00302e),
      primaryFixed: Color(0xffa1f6ef),
      onPrimaryFixed: Color(0xff000000),
      primaryFixedDim: Color(0xff85d9d3),
      onPrimaryFixedVariant: Color(0xff001a19),
      secondaryFixed: Color(0xffa1f5fa),
      onSecondaryFixed: Color(0xff000000),
      secondaryFixedDim: Color(0xff84d8de),
      onSecondaryFixedVariant: Color(0xff001a1c),
      tertiaryFixed: Color(0xffdae8ff),
      onTertiaryFixed: Color(0xff000000),
      tertiaryFixedDim: Color(0xffa9cdff),
      onTertiaryFixedVariant: Color(0xff00172f),
      surfaceDim: Color(0xff111418),
      surfaceBright: Color(0xff37393e),
      surfaceContainerLowest: Color(0xff0c0e13),
      surfaceContainerLow: Color(0xff191c20),
      surfaceContainer: Color(0xff1d2024),
      surfaceContainerHigh: Color(0xff272a2f),
      surfaceContainerHighest: Color(0xff32353a),
    );
  }

  ThemeData darkHighContrast() {
    return theme(darkHighContrastScheme());
  }

  ThemeData theme(ColorScheme colorScheme) => ThemeData(
        useMaterial3: true,
        brightness: colorScheme.brightness,
        splashColor: Colors.transparent,
        highlightColor: Colors.transparent,
        colorScheme: colorScheme,
        textTheme: textTheme.apply(
          bodyColor: colorScheme.onSurface,
          displayColor: colorScheme.onSurface,
        ),
        scaffoldBackgroundColor: colorScheme.background,
        canvasColor: colorScheme.surface,
      );

  List<ExtendedColor> get extendedColors => [];
}

class ExtendedColor {
  final Color seed, value;
  final ColorFamily light;
  final ColorFamily lightHighContrast;
  final ColorFamily lightMediumContrast;
  final ColorFamily dark;
  final ColorFamily darkHighContrast;
  final ColorFamily darkMediumContrast;

  const ExtendedColor({
    required this.seed,
    required this.value,
    required this.light,
    required this.lightHighContrast,
    required this.lightMediumContrast,
    required this.dark,
    required this.darkHighContrast,
    required this.darkMediumContrast,
  });
}

class ColorFamily {
  const ColorFamily({
    required this.color,
    required this.onColor,
    required this.colorContainer,
    required this.onColorContainer,
  });

  final Color color;
  final Color onColor;
  final Color colorContainer;
  final Color onColorContainer;
}
