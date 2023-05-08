import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transportes_leche/theme/theme_main.dart';

import '../providers/theme_provider.dart';

class InputDecorations {
  static InputDecoration authImputDecoration({
    required String hintText,
    required String labelText,
    required BuildContext context,
    IconData? prefixIcon,
}) {
    return InputDecoration(
      enabledBorder: OutlineInputBorder(
        borderSide: BorderSide(color: Provider.of<ThemeProvider>(context).currentThemeName == 'light' ? ThemeMain.buttonColor : Colors.white70),
      ),
      focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: ThemeMain.buttonColor2, width: 2), borderRadius: BorderRadius.only(topRight: Radius.circular(20), bottomLeft: Radius.circular(20))),
      hintText: hintText,
      labelText: labelText,
      prefixIcon: prefixIcon != null ? Icon(prefixIcon, color: ThemeMain.primaryColorLight,) : null);
  }
}
