import 'package:flutter/material.dart';
import 'package:galaxia/theme/extension.dart';
import 'package:google_fonts/google_fonts.dart';

const Map<int, Color> primary = {
  100: Color(0xff000614),
  200: Color(0xff001A52),
  300: Color(0xff002D8F),
  400: Color(0xff0041CC),
  500: Color(0xff004FFF),
  600: Color(0xff4782FF),
  700: Color(0xff85ABFF),
  800: Color(0xffC2D5FF),
  900: Color(0xffEBF1FF)
};
const Map<int, Color> grayscale = {
  100: Color(0xff08090D),
  200: Color(0xff0F121A),
  300: Color(0xff171B26),
  400: Color(0xff1F2433),
  500: Color(0xff262D40),
  600: Color(0xff8C99BA),
  700: Color(0xffA6B0C9),
  800: Color(0xffBFC6D9),
  900: Color(0xffD9DDE8),
  1000: Color(0xffF2F4F7)
};
Map<int, Color> success = {
  100: const Color(0xff112008),
  200: const Color(0xff19310D),
  300: const Color(0xff326119),
  400: const Color(0xff4C9226),
  500: const Color(0xff65C332),
  600: const Color(0xff87D55D),
  700: const Color(0xffABE28D),
  800: const Color(0xffCFEEBE),
  900: const Color(0xffF3FBEF)
};

Map<int, Color> error = {
  100: const Color(0xff290000),
  200: const Color(0xff3D0000),
  300: const Color(0xff7A0000),
  400: const Color(0xffB80000),
  500: const Color(0xffF50000),
  600: const Color(0xffFF3333),
  700: const Color(0xffFF7070),
  800: const Color(0xffFFADAD),
  900: const Color(0xffFFEBEB)
};

Map<int, Color> warning = {
  100: const Color(0xff141101),
  200: const Color(0xff3B3202),
  300: const Color(0xff776404),
  400: const Color(0xffB29506),
  500: const Color(0xffEFCA08),
  600: const Color(0xffF9D939),
  700: const Color(0xffFBE474),
  800: const Color(0xffFDF0B0),
  900: const Color(0xffFEFBEB)
};

Map<int, Color> secondary = {
  100: const Color(0xff0b0722),
  200: const Color(0xff150d45),
  300: const Color(0xff251778),
  400: const Color(0xff3521ab),
  500: const Color(0xff4a31d8),
  600: const Color(0xff7865e2),
  700: const Color(0xffa598eb),
  800: const Color(0xffc3baf2),
  900: const Color(0xfff0eefc),
};

ThemeData darkTheme = ThemeData(
    brightness: Brightness.dark,
    switchTheme: SwitchThemeData(
        trackColor: MaterialStatePropertyAll(grayscale[200]),
        overlayColor: MaterialStatePropertyAll(primary[200]),
        thumbColor: MaterialStatePropertyAll(primary[500])),
    scaffoldBackgroundColor: grayscale[100],
    primaryColor: primary[500],
    checkboxTheme: CheckboxThemeData(
        fillColor: MaterialStatePropertyAll(primary[500]),
        checkColor: MaterialStatePropertyAll(primary[900]),
        overlayColor: MaterialStatePropertyAll(primary[200]),
        shape:
            ContinuousRectangleBorder(borderRadius: BorderRadius.circular(12)),
        side: BorderSide(color: grayscale[500]!, width: 2)),
    splashFactory: InkRipple.splashFactory,
    bottomNavigationBarTheme: const BottomNavigationBarThemeData(
      backgroundColor: Colors.transparent,
    ),
    inputDecorationTheme: InputDecorationTheme(
        alignLabelWithHint: true,
        filled: true,
        fillColor: MaterialStateColor.resolveWith((states) =>
            states.contains(MaterialState.focused)
                ? primary[100]!
                : grayscale[200]!),
        focusColor: primary[500],
        labelStyle: TextStyle(
            color: grayscale[500],
            fontSize: 14,
            overflow: TextOverflow.visible),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
        errorStyle: TextStyle(color: error[500]),
        disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10000.0),
            borderSide: BorderSide(color: grayscale[300]!)),
        floatingLabelStyle: MaterialStateTextStyle.resolveWith(
          (Set<MaterialState> states) {
            final Color? color = states.contains(MaterialState.error)
                ? error[500]
                : states.contains(MaterialState.focused)
                    ? primary[500]
                    : grayscale[600];
            return TextStyle(color: color, letterSpacing: 1.3, fontSize: 14);
          },
        ),
        errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10000),
            borderSide: BorderSide(color: error[500]!)),
        focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10000),
            borderSide: BorderSide(color: error[500]!)),
        focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10000),
            borderSide: BorderSide(color: primary[500]!)),
        enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10000.0),
            borderSide: BorderSide(color: grayscale[500]!))),
    primarySwatch: const MaterialColor(500, primary),
    elevatedButtonTheme: ElevatedButtonThemeData(
        style: ButtonStyle(
            overlayColor: MaterialStatePropertyAll(primary[300]),
            padding: const MaterialStatePropertyAll(
                EdgeInsets.symmetric(horizontal: 20, vertical: 16)),
            textStyle: MaterialStatePropertyAll(GoogleFonts.spaceMono(
                fontWeight: FontWeight.bold, color: primary[900])),
            shape: const MaterialStatePropertyAll(StadiumBorder()),
            backgroundColor: MaterialStateProperty.resolveWith((states) =>
                states.contains(MaterialState.disabled) ? primary[600] : primary[500]))),
    textTheme: GoogleFonts.spaceMonoTextTheme().apply(
      bodyColor: grayscale[1000],
      displayColor: grayscale[1000],
      decorationColor: grayscale[1000],
    ),
    floatingActionButtonTheme: FloatingActionButtonThemeData(splashColor: primary[300], backgroundColor: primary[500], foregroundColor: grayscale[1000]),
    appBarTheme: AppBarTheme(
      backgroundColor: grayscale[100],
      elevation: 0.0,
    ),
    radioTheme: RadioThemeData(fillColor: MaterialStateColor.resolveWith((states) => states.contains(MaterialState.selected) ? primary[500]! : grayscale[400]!)),
    extensions: const <ThemeExtension<dynamic>>[
      GalaxiaTheme(
        primary: primary,
        grayscale: grayscale,
      )
    ]);
