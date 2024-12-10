import 'package:denis_kebap/config/size_config.dart';
import 'package:denis_kebap/consts/app_consts.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'app_colors.dart';

ThemeData appTheme(BuildContext context) {
  return ThemeData(
    useMaterial3: true,
    primaryColor: AppColors.kPrimaryColor,

   // colorScheme: const ColorScheme.light(background: AppColors.backgroundColor),
    colorScheme: ColorScheme.fromSeed(
        seedColor: AppColors.kPrimaryColor,
      brightness: Brightness.dark,
      background: AppColors.backgroundColor,
      secondary: Colors.black

    ),
    scaffoldBackgroundColor: AppColors.backgroundColor,
    appBarTheme: appBarTheme(),
    buttonTheme: _buttonThemeData(),
    fontFamily: 'Poppins',
    textTheme: textTheme(),
    inputDecorationTheme: inputDecorationTheme(context),
    visualDensity: VisualDensity.adaptivePlatformDensity,
  );
}

InputDecorationTheme inputDecorationTheme(BuildContext context) {
  OutlineInputBorder outlineInputBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppColors.colorTextPrimary),
    gapPadding: 10,
  );
  OutlineInputBorder enabledBorder = OutlineInputBorder(
    borderRadius: BorderRadius.circular(8),
    borderSide: const BorderSide(color: AppColors.kPrimaryColor),
    gapPadding: 10,
  );

  return InputDecorationTheme(
    floatingLabelBehavior: FloatingLabelBehavior.auto,
    contentPadding: EdgeInsets.symmetric(
        horizontal: 2 * SizeConfig.widthMultiplier,
        vertical: 2 * SizeConfig.heightMultiplier),
    enabledBorder: outlineInputBorder,
    focusedBorder: enabledBorder,
    hintStyle: Theme.of(context).textTheme.bodyLarge,
    labelStyle: Theme.of(context).textTheme.bodyLarge,
    errorStyle:
        Theme.of(context).textTheme.bodyLarge!.copyWith(color: Colors.red),
    border: outlineInputBorder,
    /*   errorBorder: OutlineInputBorder(
      borderRadius: BorderRadius.zero,
      borderSide: BorderSide(color: Colors.red, width: .5),
    )*/
  );
}



TextTheme textTheme() {
  return TextTheme(
    //headlineLarge
    displayLarge: const TextStyle(
        color: AppColors.colorTextPrimary,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins'),
    //headlineLarge
    displayMedium: const TextStyle(
        color: Colors.white,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins'),
    //headlineLarge
    displaySmall: const TextStyle(
        color: AppColors.colorTextPrimary,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins'),
    //headlineMedium
    headlineMedium: const TextStyle(
        color: AppColors.colorTextPrimary,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins'),

    //headlineMedium
    headlineSmall: const TextStyle(
        color: AppColors.colorTextPrimary,
        fontWeight: FontWeight.w400,
        fontFamily: 'Poppins'),
    //titleLarge
    titleLarge: const TextStyle(
        color: AppColors.colorTextPrimary,
        fontWeight: FontWeight.w500,
        fontFamily: 'Poppins'),

    titleMedium: const TextStyle(
        color: AppColors.colorTextPrimary,
        fontWeight: FontWeight.w300,
        fontFamily: 'Poppins'),

    bodyMedium: const TextStyle(
        color: AppColors.colorTextPrimary, fontFamily: 'Poppins'),
    bodySmall: const TextStyle(
        color: AppColors.colorTextPrimary, fontFamily: 'Poppins'),


    labelLarge: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w500,
      fontSize: 15.fontMultiplier,
      fontFamily: 'Poppins',
    ),

    labelSmall: TextStyle(
      color: Colors.white,
      fontWeight: FontWeight.w600,
      fontSize: 13.fontMultiplier,
      fontFamily: 'Poppins',
    ),
  );
}

ButtonThemeData _buttonThemeData() {
  return ButtonThemeData(
    buttonColor: AppColors.kPrimaryColor,
    textTheme: ButtonTextTheme.primary,
    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(0)),
  );
}

AppBarTheme appBarTheme() {
  return AppBarTheme(
      backgroundColor: AppColors.backgroundColor,
      elevation: 0,
      systemOverlayStyle: SystemUiOverlayStyle.dark
          .copyWith(statusBarColor: AppColors.backgroundColor),
      iconTheme: const IconThemeData(color: Colors.black),
      titleTextStyle: const TextStyle(
          fontFamily: 'Poppins',
          color: Colors.black,
          fontWeight: FontWeight.w500,
          fontSize: 16.0));
}
