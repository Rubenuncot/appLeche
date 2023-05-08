import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';
import 'package:transportes_leche/providers/theme_provider.dart';
import 'package:transportes_leche/shared_preferences/preferences.dart';
import 'package:transportes_leche/theme/theme_main.dart';
import 'package:transportes_leche/widgets/widgets.dart';

import '../providers/model_provider.dart';
import 'main_screen.dart';

class ConfigScreen extends StatefulWidget {
  static String routeName = '_config';

  const ConfigScreen({Key? key}) : super(key: key);

  @override
  State<ConfigScreen> createState() => _ConfigScreenState();
}

class _ConfigScreenState extends State<ConfigScreen> with WidgetsBindingObserver{
  /* Variables */
  bool showNowDialog = false;

  final _advancedDrawerController = AdvancedDrawerController();

  //--Controllers--//
  final TextEditingController _controllerPort = TextEditingController();
  final TextEditingController _controllerUser = TextEditingController();
  final TextEditingController _controllerPass = TextEditingController();
  final TextEditingController _controllerPath = TextEditingController();
  final TextEditingController _controllerHost = TextEditingController();
  final TextEditingController _controllerTheme = TextEditingController();
  final TextEditingController _controllerCoop = TextEditingController();


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controllerTheme.text = Provider.of<ThemeProvider>(context).currentThemeName == 'light' ? 'Light Mode' : 'Dark Mode';
    _controllerUser.text = Preferences.user ?? '';
    _controllerPath.text = Preferences.path ?? '';
    _controllerPass.text = Preferences.pass ?? '';
    _controllerPort.text = '${Preferences.port}';
    _controllerHost.text = Preferences.host ?? '';
    _controllerCoop.text = Preferences.cooperativa ?? '';
  }

  /* Overrides */

  @override
  Widget build(BuildContext context) {
    Timer.periodic(const Duration(seconds: 1), (timer) {
      if(showNowDialog){
        showDialog(context: context, builder: (context) => CustomAlertDialog(
          titulo: 'Reiniciar App',
          contenido: Column(
            children: const [
              Text('Por favor, reinicie la aplicación para aplicar los cambios recientes.'),
            ],
          ),
          onPressed: () => SystemNavigator.pop(),
        ));
        showNowDialog = false;
      }
    });

    return GestureDetector(
      child: AdvancedDrawer(
        backdrop: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: const [0.759, 1],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [const Color.fromARGB(255, 0, 40, 75), const Color.fromARGB(255, 0, 40, 75).withOpacity(0.7)]
              )
          ),
        ),
        controller: _advancedDrawerController,
        animationCurve: Curves.easeInOut,
        animationDuration: const Duration(milliseconds: 300),
        animateChildDecoration: true,
        rtlOpening: false,
        // openScale: 1.0,
        disabledGestures: false,
        childDecoration: const BoxDecoration(
          // NOTICE: Uncomment if you want to add shadow behind the page.
          // Keep in mind that it may cause animation jerks.
          // boxShadow: <BoxShadow>[
          //   BoxShadow(
          //     color: Colors.black12,
          //     blurRadius: 0.0,
          //   ),
          // ],
          borderRadius: BorderRadius.all(Radius.circular(16)),
        ),
        drawer: CustomDrawer(modelProvider: Provider.of<ModelProvider>(context)),
        child: Scaffold(
          appBar: CustomAppBar(name: 'Ajustes', advancedDrawerController: _advancedDrawerController,),
          body: SingleChildScrollView(
            child: Column(
              children: [
                _containerRow(context, 'Cooperativa', _controllerCoop, () {
                  showDialog(context: context, builder: (context) => CustomAlertDialog(
                    titulo: 'Cambiar Cooperativa',
                    contenido: Column(
                      children: [
                        const Text('Escriba el nombre de la cooperativa'),
                        TextField(
                          onChanged: (value) {
                            _controllerCoop.text = value;
                            Preferences.cooperativa = value;
                          },
                        )
                      ],
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),);
                }),
                _containerRow(context, 'Puerto', _controllerPort, () => showDialog(context: context, builder: (context) => CustomAlertDialog(
                  titulo: 'Cambiar Puerto',
                  contenido: Column(
                    children: [
                      const Text('Para cambiar el puerto contacte con GAE para tener más información y no provocar errores.'),
                      TextField(
                        onChanged: (value) {
                          _controllerPort.text = value;
                          Preferences.port = int.parse(value);
                        },
                        keyboardType: TextInputType.number,
                      )
                    ],
                  ),
                  onPressed: () => Navigator.pop(context),
                ),)),
                _containerRow(context, 'Servidor', _controllerHost, () => showDialog(context: context, builder: (context) => CustomAlertDialog(
                  titulo: 'Cambiar Servidor',
                  contenido: Column(
                    children: [
                      const Text('Para cambiar el servidor contacte con GAE para tener más información y no provocar errores.'),
                      TextField(
                        onChanged: (value) {
                          _controllerHost.text = value;
                          Preferences.host = value;
                        },
                        keyboardType: TextInputType.number,
                      )
                    ],
                  ),
                  onPressed: () => Navigator.pop(context),
                ),)),
                _containerRow(context, 'Ruta', _controllerPath, () {
                  showDialog(context: context, builder: (context) => CustomAlertDialog(
                    titulo: 'Cambiar Ruta',
                    contenido: Column(
                      children: [
                        const Text('Para cambiar la ruta contacte con GAE para tener más información y no provocar errores.'),
                        TextField(
                          onChanged: (value) {
                            _controllerPath.text = value;
                            Preferences.path = value;
                          },
                        )
                      ],
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),);
                }),
                _containerRow(context, 'Usuario', _controllerUser, () {
                  showDialog(context: context, builder: (context) => CustomAlertDialog(
                    titulo: 'Cambiar Usuario',
                    contenido: Column(
                      children: [
                        const Text('Para cambiar el usuario contacte con GAE para tener más información y no provocar errores.'),
                        TextField(
                          onChanged: (value) {
                            _controllerUser.text = value;
                            Preferences.user = value;
                          },
                        )
                      ],
                    ),
                    onPressed: () => Navigator.pop(context),
                  ),);
                }),
                _containerRow(context, 'Contraseña', _controllerPass, () {
                  showDialog(context: context, builder: (context) => CustomAlertDialog(
                    titulo: 'Cambiar Contraseña',
                    contenido: Column(
                      children: [
                        const Text('Para cambiar la contraseña contacte con GAE para tener más información y no provocar errores.'),
                        TextField(
                          onChanged: (value) {
                            _controllerPass.text = value;
                            Preferences.pass = value;
                          },
                        )
                      ],
                    ),
                    onPressed: () {
                      if(Preferences.port! > 0 && Preferences.host!.length > 1 && Preferences.user!.length > 1 && Preferences.path!.length > 1 && Preferences.pass!.length > 1){
                        showNowDialog = true;
                      }
                      Navigator.pop(context);
                    },
                  ),);
                }),
                Container(
                  margin: const EdgeInsets.only(top: 20, right: 20),
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                      borderRadius: const BorderRadius.only(
                          topRight: Radius.circular(20),
                          bottomRight: Radius.circular(20)),
                      color: Provider.of<ThemeProvider>(context).currentThemeName == 'light' ? Colors.black12 : Colors.white12),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: Container(
                          margin: const EdgeInsets.only(right: 120, left: 20),
                          child:TextField(
                            controller: _controllerTheme,
                            enabled: false,
                            decoration: InputDecoration(
                                disabledBorder: OutlineInputBorder(
                                    borderSide: const BorderSide(color: Colors.black12),
                                    borderRadius: BorderRadius.circular(5)),
                                labelText: 'Tema'),
                          ),
                        ),
                      ),
                      Row(
                       children: [
                         const Icon(Icons.light_mode),
                         Switch(
                           value: Preferences.theme ?? false,
                           onChanged: (value) {
                             value ? Provider.of<ThemeProvider>(context, listen: false).setDarktMode() : Provider.of<ThemeProvider>(context, listen: false).setLightMode();
                             setState(() {

                             });
                         },),
                         const Icon(Icons.dark_mode)
                       ],
                      )

                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  Container _containerRow(BuildContext context, String text,
      TextEditingController controller, void Function()? onPressed) {
    return Container(
      margin: const EdgeInsets.only(top: 20, right: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
              topRight: Radius.circular(20), bottomRight: Radius.circular(20)),
          color: Provider.of<ThemeProvider>(context).currentThemeName == 'light' ? Colors.black12 : Colors.white12),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(right: 50, left: 20),
              child: TextField(
                controller: controller,
                enabled: false,
                decoration: InputDecoration(
                    disabledBorder: OutlineInputBorder(
                        borderSide: const BorderSide(color: Colors.black12),
                        borderRadius: BorderRadius.circular(5)),
                    labelText: text),
              ),
            ),
          ),
          MaterialButton(
            onPressed: onPressed,
            color: ThemeMain.buttonColor,
            textColor: ThemeMain.backgroundColorLight,
            child: const Text('Cambiar'),
          )
        ],
      ),
    );
  }
}
// TODO: Crear parametro que va a ser la cooperativa (COMPRADOR EN EL TICKET)
