import 'package:flutter/material.dart';

class ThemeMain {
  static const Color primaryColorDark = Color.fromARGB(255, 20, 26, 59);
  static Color secondaryColorDark = Colors.indigo;
  static const Color backgroundColorDark = Color.fromARGB(255, 255, 255, 255);
  static const Color primaryColorLight = Colors.indigo;
  static Color secondaryColorLight = Colors.indigo.shade300;
  static const Color backgroundColorLight = Color.fromARGB(255, 255, 255, 255);


  static const Color buttonColor = Color.fromARGB(255, 97, 97, 224);
  static const Color buttonColor2 = Color.fromARGB(255, 121, 213, 110);
  static const Color buttonColor3 = Color.fromARGB(255, 239, 89, 89);

  static const Color codeColor = Color.fromARGB(255, 125, 0, 199);



  static final ThemeData lightTheme = ThemeData.light().copyWith(
    primaryColor: primaryColorLight,

  );

  static final ThemeData darkTheme = ThemeData.dark().copyWith(

  );
}