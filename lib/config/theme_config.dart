import 'package:chatapp/const/dark_colors.dart';
import 'package:chatapp/const/light_colors.dart';
import 'package:flutter/material.dart';

class ThemeConfig {
  static const appFonts = 'DMSans';

  static ThemeData lightTheme = ThemeData(
    primaryColor: LightColors.themeColor,
    fontFamily: appFonts,
    scaffoldBackgroundColor: LightColors.whiteColor,
    brightness: Brightness.light,
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: DarkColors.themeColor,
    fontFamily: appFonts,
    scaffoldBackgroundColor: DarkColors.blackColor,
    brightness: Brightness.dark,
    useMaterial3: true,
  );
}
