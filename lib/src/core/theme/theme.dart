import 'package:flutter/material.dart';

extension AppColorsExtension on BuildContext {
  AppColors get colors {
    final brightness = Theme.of(this).brightness;

    return brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.standard;
  }
}

extension ThemeModeExtension on BuildContext {
  bool get isDark => Theme.of(this).brightness == Brightness.dark;
}


class AppColors {
  final Color background, button, textPrimary, buttonText, inputFieldBorder, heading, error;
  final Color iDontRemember, topNav, topNavBorder, inactiveProgressBar, veg, nonVeg;
  final Color follicular, ovulation, luteal, menstrual, birthday;
  final Color chatUserText;
  final Color foodText, foodTag;
  final Color menstrualBg, follicularBg, ovulationBg, lutealBg;
  final Color menstrualText, follicularText, ovulationText, lutealText;
  final Color appBar;

  // This static variable will be updated by the getAppTheme function
  static AppColors current = AppColors.standard;

  const AppColors({
    required this.background,
    required this.button,
    required this.textPrimary,
    required this.buttonText,
    required this.inputFieldBorder,
    required this.heading,
    required this.error,
    required this.iDontRemember,
    required this.topNav,
    required this.topNavBorder,
    required this.inactiveProgressBar,
    required this.veg,
    required this.nonVeg,
    required this.follicular,
    required this.ovulation,
    required this.luteal,
    required this.menstrual,
    required this.birthday,
    required this.chatUserText,
    required this.foodText,
    required this.foodTag,
    required this.menstrualBg,
    required this.follicularBg,
    required this.ovulationBg,
    required this.lutealBg,
    required this.menstrualText,
    required this.follicularText,
    required this.ovulationText,
    required this.lutealText,
    required this.appBar,
  });

  // --- LIGHT THEME (Your Original) ---
  static const AppColors standard = AppColors(
    background: Color(0xFFFFFBFB),
    button: Color(0xFFD85C7B),
    appBar: Color(0xFFD85C7B),
    textPrimary: Color(0xFF63504B),
    buttonText: Color(0xFFFFFFFF),
    inputFieldBorder: Color(0xFFD9CACE),
    heading: Color(0xFFD85C7B),
    error: Color(0xFFCF5D60),
    iDontRemember: Color(0xFFF2C6D2),
    topNav: Color(0xFFF9DEE4),
    topNavBorder: Color(0xFFF1C0CB),
    inactiveProgressBar: Color(0xFFE0E0E0),
    veg: Color(0xFF00C853),
    nonVeg: Color(0xFF9A0100),
    follicular: Color(0xFF7BC9C9),
    ovulation: Color(0xFFF9B13A),
    luteal: Color(0xFFD386B1),
    menstrual: Color(0xFFCF4145),
    birthday: Color(0xFFFF6131),
    chatUserText: Color(0xFFA63F60),
    foodText: Color(0xFFAC5672),
    foodTag: Color(0xFFECA9B0),
    menstrualBg: Color(0xFFFFDCDC),
    follicularBg: Color(0xFFE9F9FA),
    ovulationBg: Color(0xFFFEEDE4),
    lutealBg: Color(0xFFFFE3F3),
    menstrualText: Color(0xFFCF1A1A),
    follicularText: Color(0xFF61B1B5),
    ovulationText: Color(0xFFFC924B),
    lutealText: Color(0xFFE26DB5),
  );

  // --- DARK THEME (The New Palette) ---
  static const AppColors dark = AppColors(
    background: Color(0xFF1A0A0F),              // Deeper, richer dark base
    button: Color(0xFFDCBEBE),                  // Slightly brighter pink for visibility
    appBar: Color(0xFF2D1219),                  // Warmer dark surface
    textPrimary: Color(0xFFCCCCCC),             // Soft white with pink tint
    buttonText: Color(0xFF2D1219),              // Pure white for contrast
    inputFieldBorder: Color(0xFF4A2830),        // More visible border
    heading: Color(0xFFDDC3C8),                 // Brighter heading for emphasis
    error: Color(0xFFFF6B6E),                   // More vibrant error color
    iDontRemember: Color(0xFF3D1F28),           // Subtle dark surface
    topNav: Color(0xFF2D1219),                  // Matches appBar for consistency
    topNavBorder: Color(0xFF4A2830),            // Visible separation
    inactiveProgressBar: Color(0xFF3D2229),     // Subtle inactive state
    veg: Color(0xFF66BB6A),                     // Softer green for dark mode
    nonVeg: Color(0xFFEF5350),                  // Softer red for dark mode
    follicular: Color(0xFF5EC4C4),              // Maintained but slightly muted
    ovulation: Color(0xFFFFB84D),               // Brighter for visibility
    luteal: Color(0xFFE89BC8),                  // Lighter for readability
    menstrual: Color(0xFFE65C5F),               // Adjusted red tone
    birthday: Color(0xFFFF7A52),                // Softer orange
    chatUserText: Color(0xFFCCCCCC),            // Very light pink for readability
    foodText: Color(0xFFFFD6E3),                // Consistent with chatUserText
    foodTag: Color(0xFF4A2830),                 // Dark subtle tag background
    menstrualBg: Color(0xFF3D1A1F),             // Deep red-tinted background
    follicularBg: Color(0xFF1A2B2B),            // Deep teal background
    ovulationBg: Color(0xFF3D2A1A),             // Deep warm background
    lutealBg: Color(0xFF3D1A2D),                // Deep purple-pink background
    menstrualText: Color(0xFFFFB3B8),           // Soft red text
    follicularText: Color(0xFF8CE9ED),          // Bright cyan for readability
    ovulationText: Color(0xFFFFCC80),           // Bright warm text
    lutealText: Color(0xFFFFCCE5),              // Bright pink text
  );

  static AppColors of(BuildContext context) {
    final brightness = Theme.of(context).brightness;
    return brightness == Brightness.dark
        ? AppColors.dark
        : AppColors.standard;
  }
}

ThemeData getAppTheme(Brightness brightness) {
  final colors = brightness == Brightness.light  // just rename selectedColors → colors
      ? AppColors.standard
      : AppColors.dark;


  return ThemeData(
    useMaterial3: true,
    brightness: brightness,
    scaffoldBackgroundColor: colors.background,

    //snack bar theme
    snackBarTheme: SnackBarThemeData(

      behavior: SnackBarBehavior.floating,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),

      backgroundColor: brightness == Brightness.dark
          ? const Color(0xFF2D1219)
          : Colors.white,

      contentTextStyle: TextStyle(
        fontFamily: 'Satoshi',
        fontWeight: FontWeight.w500,
        color: brightness == Brightness.dark
            ? Colors.white
            : colors.heading,
      ),

    ),

    extensions: [
      CustomColors(
        topNav: colors.topNav,
        topNavBorder: colors.topNavBorder,
        veg: colors.veg,
        nonVeg: colors.nonVeg,
        heading: colors.heading,
        textPrimary: colors.textPrimary,
      ),
    ],
    colorScheme: ColorScheme.fromSeed(
      brightness: brightness,
      seedColor: colors.button,
      surface: colors.background,
      onSurface: colors.textPrimary,
      primary: colors.button,
      onPrimary: colors.buttonText,
      error: colors.error,
    ),
    textTheme: TextTheme(
      displayLarge: TextStyle(color: colors.heading, fontWeight: FontWeight.bold, fontFamily: 'Satoshi'),
      bodyLarge: TextStyle(color: colors.textPrimary, fontFamily: 'Satoshi'),
      bodyMedium: TextStyle(color: colors.textPrimary, fontFamily: 'Satoshi'),
    ),
    // ... rest of your elevatedButtonTheme and inputDecorationTheme stay the same
    elevatedButtonTheme: ElevatedButtonThemeData(
      style: ElevatedButton.styleFrom(
        backgroundColor: colors.button,
        foregroundColor: colors.buttonText,
        elevation: 0,
        textStyle: const TextStyle(fontWeight: FontWeight.w700, fontSize: 16, fontFamily: 'Satoshi'),
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
      ),
    ),
    inputDecorationTheme: InputDecorationTheme(
      filled: true,
      fillColor: brightness == Brightness.light ? Colors.white : const Color(0xFF2D121B),
      contentPadding: const EdgeInsets.symmetric(vertical: 20, horizontal: 24),
      hintStyle: TextStyle(color: colors.textPrimary.withOpacity(0.4), fontFamily: 'Satoshi'),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(60),
        borderSide: BorderSide(color: colors.inputFieldBorder.withOpacity(0.5)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(60),
        borderSide: BorderSide(color: colors.button, width: 1.5),
      ),
    ),
  );
}

// Keep your CustomColors class exactly as it was
class CustomColors extends ThemeExtension<CustomColors> {
  final Color? topNav;
  final Color? topNavBorder;
  final Color? veg;
  final Color? nonVeg;
  final Color? heading;
  final Color? textPrimary;

  CustomColors({this.topNav, this.topNavBorder, this.veg, this.nonVeg, this.heading, this.textPrimary});

  @override
  ThemeExtension<CustomColors> copyWith({Color? topNav, Color? topNavBorder, Color? veg, Color? nonVeg, Color? heading, Color? textPrimary}) {
    return CustomColors(
      topNav: topNav ?? this.topNav,
      topNavBorder: topNavBorder ?? this.topNavBorder,
      veg: veg ?? this.veg,
      nonVeg: nonVeg ?? this.nonVeg,
      heading: heading ?? this.heading,
      textPrimary: textPrimary ?? this.textPrimary,
    );
  }

  @override
  ThemeExtension<CustomColors> lerp(ThemeExtension<CustomColors>? other, double t) {
    if (other is! CustomColors) return this;
    return CustomColors(
      topNav: Color.lerp(topNav, other.topNav, t),
      topNavBorder: Color.lerp(topNavBorder, other.topNavBorder, t),
      veg: Color.lerp(veg, other.veg, t),
      nonVeg: Color.lerp(nonVeg, other.nonVeg, t),
      heading: Color.lerp(heading, other.heading, t),
      textPrimary: Color.lerp(textPrimary, other.textPrimary, t),
    );
  }
}

