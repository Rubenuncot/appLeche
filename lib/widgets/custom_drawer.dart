import 'package:flutter/material.dart';
import 'package:smart_snackbars/smart_snackbars.dart';
import 'package:transportes_leche/providers/model_provider.dart';
import 'package:transportes_leche/screens/screens.dart';
import 'package:transportes_leche/theme/theme_main.dart';

class CustomDrawer extends StatelessWidget {
  final ModelProvider modelProvider;
  const CustomDrawer({Key? key, required this.modelProvider}) : super(key: key);

  Future<int> deleteElements() async {
    return await modelProvider.deleteDate();
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      elevation: 0,
      backgroundColor: const Color.fromARGB(255, 0, 40, 75),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 50),
        child: ListView(
          children: [
            const SizedBox(height: 20,),
            _listTile('Inicio', Icons.home, const Color.fromARGB(
                128, 255, 225, 88),() => Navigator.pushReplacementNamed(context, MainScreen.routeName)),
            const SizedBox(height: 20,),
            const SizedBox(height: 40,),
            _listTile('Ajustes', Icons.settings, Colors.white12, () => Navigator.pushNamed(context, ConfigScreen.routeName)),
            const SizedBox(height: 20,),
            _listTile('Lista de Cargas', Icons.list_alt, Colors.white12, () => Navigator.pushNamed(context, LoadListScreen.routeName)),
            const SizedBox(height: 20,),
            _listTile('Lista de Descargas', Icons.list, Colors.white12, () => Navigator.pushNamed(context, DownloadListScreen.routeName)),
            const SizedBox(height: 20,),
            // _listTile('Imprimir', Icons.print, Colors.black12, () => Navigator.pushNamed(context, PrintBluetooth.routeName)),
            // const SizedBox(height: 20,),
            _listTile('Borrado hasta la fecha', Icons.delete, Colors.white12, () async{

              SmartSnackBars.showTemplatedSnackbar (
                  context: context,
                subTitle: 'Borrados ${await deleteElements()} elementos.',
                backgroundColor: ThemeMain.buttonColor,
                  animationCurve: const ElasticInCurve()
              );

            }),
            const SizedBox(height: 40,),
            const SizedBox(height: 20,),
            _listTile('Cargar', Icons.fire_truck, const Color.fromARGB(128, 238, 104, 100),() => Navigator.pushReplacementNamed(context, LoadScreen.routeName)),
            const SizedBox(height: 20,),
            _listTile('Descargar', Icons.fire_truck, const Color.fromARGB(
                128, 100, 238, 139), () => Navigator.pushReplacementNamed(context, DownloadScreen.routeName)),

          ],
        ),
      ),
    );
  }

  Container _listTile(String text, IconData icon, Color color, void Function()? onTap, ) {
    return Container(
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(15),
              border: Border.all(color: color)
            ),
            child: ListTile(
              title: Text(text, style: const TextStyle(color: Colors.white),),
              leading: Icon(icon, color: Colors.white,),
              onTap: onTap,
            ),
          );
  }
}
