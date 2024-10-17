import 'package:flutter/material.dart';
import 'package:car_app/constants/app_color.dart';

class Styles {
  static ThemeData themeData(
      {required bool isDarkTheme, required BuildContext context}) {
    return ThemeData(
        scaffoldBackgroundColor: isDarkTheme ? AppColor.black : AppColor.white,
        cardColor: isDarkTheme
            ? const Color.fromARGB(255, 13, 6, 37)
            : const Color.fromARGB(106, 250, 250, 250),
        brightness: isDarkTheme ? Brightness.dark : Brightness.light);
  }
}
