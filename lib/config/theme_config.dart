import 'package:chatapp/const/dark_colors.dart';
import 'package:chatapp/const/light_colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class ThemeConfig {
  static const appFonts = 'DMSans';

  static ThemeData lightTheme = ThemeData(
    primaryColor: LightColors.themeColor,
    fontFamily: appFonts,
    scaffoldBackgroundColor: LightColors.whiteColor,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: LightColors.whiteColor,
        statusBarIconBrightness: Brightness.dark,
        statusBarBrightness: Brightness.dark,
      ),
    ),
    brightness: Brightness.light,
    useMaterial3: true,
  );

  static ThemeData darkTheme = ThemeData(
    primaryColor: DarkColors.themeColor,
    fontFamily: appFonts,
    scaffoldBackgroundColor: DarkColors.blackColor,
    brightness: Brightness.dark,
    appBarTheme: const AppBarTheme(
      systemOverlayStyle: SystemUiOverlayStyle(
        statusBarColor: LightColors.blackColor,
        statusBarIconBrightness: Brightness.light,
        statusBarBrightness: Brightness.light,
      ),
    ),
    useMaterial3: true,
  );
}
