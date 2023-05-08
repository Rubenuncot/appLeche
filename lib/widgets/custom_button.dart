import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transportes_leche/providers/theme_provider.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final Color color;
  final Color textColor;
  final void Function()? onClick;
  const CustomButton({
    super.key, required this.text, required this.color, this.textColor = Colors.black, this.onClick,
  });

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;

    return MaterialButton(
      disabledColor: Provider.of<ThemeProvider>(context).currentThemeName == 'light' ? Colors.black26 : Colors.white30,
      onPressed: onClick,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side: const BorderSide(color: Colors.black12)
      ),
      color: color,
      elevation: 0,
      height: 70,

      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,

        children: [
          Center(child: Text(text, maxLines: 2, overflow: TextOverflow.fade, style: TextStyle(color: textColor),)),
        ],
      ),
    );
  }
}
