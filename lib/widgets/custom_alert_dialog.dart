import 'package:flutter/material.dart';

class CustomAlertDialog extends StatefulWidget {
  final String titulo;
  final Widget contenido;
  final IconData? icono;
  final Color? iconColor;
  final Color? bakcgorundColor;
  final void Function()? onPressed;
  final bool? showButton;

  const CustomAlertDialog({
    super.key,
    required this.titulo,
    required this.contenido,
    this.icono,
    this.iconColor,
    this.bakcgorundColor,
    this.onPressed,
    this.showButton = true,
  });

  @override
  State<CustomAlertDialog> createState() => _CustomAlertDialogState();
}

class _CustomAlertDialogState extends State<CustomAlertDialog> {


  @override
  Widget build(BuildContext context) {

    bool button = widget.showButton ?? true;

    return AlertDialog(
      elevation: 0,
      backgroundColor: widget.bakcgorundColor,
      // icon: Icon(icono, size: 120, color: iconColor,),
      shape: RoundedRectangleBorder(
          borderRadius: BorderRadiusDirectional.circular(30)),
      title: Center(child: Text(widget.titulo)),
      content: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            if (widget.icono != null)
              Icon(
                widget.icono,
                size: 120,
                color: widget.iconColor,
              ),
            widget.contenido,
            const SizedBox(
              height: 5,
            ),
          ],
        ),
      ),
      actions: [
        if(button)
        TextButton(
            onPressed: widget.onPressed,
            child: const Text(
              'Aceptar',
              style: TextStyle(color: Colors.blue),
            )),
      ],
    );
  }
}
