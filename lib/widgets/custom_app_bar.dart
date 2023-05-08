import 'dart:async';

import 'package:flutter/material.dart';

import '../helpers/date_time.dart';

class CustomAppBar extends StatefulWidget implements PreferredSizeWidget {
  final String name;

  const CustomAppBar({Key? key, required this.name}) : super(key: key);

  @override
  State<CustomAppBar> createState() => _CustomAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(60);
}

class _CustomAppBarState extends State<CustomAppBar> {
  /* ----- Variables ----- */
  /* Hora y minutos */
  String time = '';

  /* Fecha actual */
  String date = '';

  /* Timer */
  late Timer timer;

  TextStyle dateTimeStyle =
      const TextStyle(color: Colors.white70, fontSize: 13);

  /* Estilo del texto de la hora y la fecha */

  void getTime() {
    date = DateTimeHelper.getDate();
    time = DateTimeHelper.getTime();
    if(mounted){
      setState(() {});
    }
  }

  @override
  void dispose() {
    super.dispose();
    timer.cancel();
  }

  @override
  Widget build(BuildContext context) {
    /**
     * Miramos el tiempo cada segundo para actualizarlo,
     * lo mismo con la fecha y siempre está actualizada.
     */
    timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      getTime();
    });

    return AppBar(
        backgroundColor: Theme.of(context).primaryColor,
        elevation: 0,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            SizedBox(
                width: MediaQuery.of(context).size.width * 0.5,
                child: Text(
                  widget.name,
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                )),
            Center(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  Text(
                    date,
                    style: dateTimeStyle,
                  ),
                  Text(
                    time,
                    style: dateTimeStyle,
                  )
                ],
              ),
            )
          ],
        ));
  }
}
