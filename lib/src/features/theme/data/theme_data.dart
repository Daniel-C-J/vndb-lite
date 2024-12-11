// ignore_for_file: public_member_api_docs, sort_constructors_first
// ignore_for_file: non_constant_identifier_names

import 'package:flutter/material.dart';
import 'package:vndb_lite/src/features/theme/domain/theme_model.dart';

enum ThemeCode {
  angel,
  air,
  ever17,
  fate,
  carnevale,
  higurashi,
  tsukihime,
  touhou,
  seinaru,
  littlebusters,
  saya,
}

final Map<String, VNDBLiteTheme> THEME_DATA = {
  ThemeCode.angel.name: VNDBLiteTheme(
    themeName: "Angel Serenade",
    backgroundImgPath: "assets/images/bg/bgAngel.png",
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 50, 80, 100),
      primary: const Color.fromARGB(255, 50, 80, 100),
      secondary: const Color.fromARGB(255, 140, 220, 255),
      tertiary: Colors.white,
      brightness: Brightness.light,
    ),
  ),
  ThemeCode.air.name: VNDBLiteTheme(
    themeName: "AIR",
    backgroundImgPath: "assets/images/bg/bgAIR.png",
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 180, 220, 255),
      primary: const Color.fromARGB(255, 180, 220, 255),
      secondary: const Color.fromARGB(255, 80, 130, 225),
      tertiary: Colors.black,
      brightness: Brightness.dark,
    ),
  ),
  ThemeCode.ever17.name: VNDBLiteTheme(
    themeName: "Ever17",
    backgroundImgPath: "assets/images/bg/bgEver17.png",
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 100, 180, 190),
      primary: const Color.fromARGB(255, 100, 180, 190),
      secondary: const Color.fromARGB(255, 240, 170, 100),
      tertiary: Colors.black,
      brightness: Brightness.dark,
    ),
  ),
  ThemeCode.fate.name: VNDBLiteTheme(
    themeName: "Fate/Stay Night",
    backgroundImgPath: "assets/images/bg/bgFate.png",
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 70, 50, 50),
      primary: const Color.fromARGB(255, 70, 50, 50),
      secondary: const Color.fromARGB(255, 210, 100, 70),
      tertiary: Colors.white,
      brightness: Brightness.light,
    ),
  ),
  ThemeCode.carnevale.name: VNDBLiteTheme(
    themeName: "Gekkou No Carnevale",
    backgroundImgPath: "assets/images/bg/bgCarnevale.png",
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 20, 20, 20),
      primary: const Color.fromARGB(255, 20, 20, 20),
      secondary: const Color.fromARGB(255, 190, 190, 190),
      tertiary: Colors.white,
      brightness: Brightness.light,
    ),
  ),
  ThemeCode.higurashi.name: VNDBLiteTheme(
    themeName: "Higurashi No Naku Koro Ni",
    backgroundImgPath: "assets/images/bg/bgHigurashi.png",
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 250, 180, 160),
      primary: const Color.fromARGB(255, 250, 180, 160),
      secondary: const Color.fromARGB(255, 220, 220, 220),
      tertiary: Colors.black,
      brightness: Brightness.dark,
    ),
  ),
  ThemeCode.tsukihime.name: VNDBLiteTheme(
    themeName: "Tsukihime",
    backgroundImgPath: "assets/images/bg/bgTsukihime.png",
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 100, 80, 80),
      primary: const Color.fromARGB(255, 100, 80, 80),
      secondary: const Color.fromARGB(255, 250, 70, 70),
      tertiary: Colors.white,
      brightness: Brightness.light,
    ),
  ),
  ThemeCode.touhou.name: VNDBLiteTheme(
    themeName: "Touhou",
    backgroundImgPath: "assets/images/bg/bgTouhou.png",
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 175, 175, 175),
      primary: const Color.fromARGB(255, 175, 175, 175),
      secondary: const Color.fromARGB(255, 215, 215, 215),
      tertiary: Colors.black,
      brightness: Brightness.dark,
    ),
  ),
  ThemeCode.seinaru.name: VNDBLiteTheme(
    themeName: "Seinarukana",
    backgroundImgPath: "assets/images/bg/bgSeinaru.png",
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 255, 240, 240),
      primary: const Color.fromARGB(255, 255, 240, 240),
      secondary: const Color.fromARGB(255, 255, 70, 150),
      tertiary: Colors.black,
      brightness: Brightness.dark,
    ),
  ),
  ThemeCode.littlebusters.name: VNDBLiteTheme(
    themeName: "Little Busters!",
    backgroundImgPath: "assets/images/bg/bgLittleBusters.png",
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 250, 200, 250),
      primary: const Color.fromARGB(255, 250, 200, 250),
      secondary: const Color.fromARGB(255, 240, 80, 215),
      tertiary: Colors.black,
      brightness: Brightness.dark,
    ),
  ),
  ThemeCode.saya.name: VNDBLiteTheme(
    themeName: "Saya No Uta",
    backgroundImgPath: "assets/images/bg/bgSaya.png",
    colorScheme: ColorScheme.fromSeed(
      seedColor: const Color.fromARGB(255, 50, 100, 80),
      primary: const Color.fromARGB(255, 50, 100, 80),
      secondary: const Color.fromARGB(255, 240, 180, 140),
      tertiary: Colors.white,
      brightness: Brightness.light,
    ),
  ),
};
