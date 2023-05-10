import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';
import 'package:transportes_leche/providers/theme_provider.dart';
import 'package:transportes_leche/shared_preferences/preferences.dart';
import 'package:transportes_leche/theme/theme_main.dart';
import 'package:transportes_leche/ui/input_decorations.dart';
import 'package:transportes_leche/widgets/widgets.dart';

import '../providers/model_provider.dart';

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
  final TextEditingController _controllerPathLocal = TextEditingController();
  final TextEditingController _controllerPathExterna = TextEditingController();
  final TextEditingController _controllerHost = TextEditingController();
  final TextEditingController _controllerTheme = TextEditingController();
  final TextEditingController _controllerCoop = TextEditingController();
  final TextEditingController _controllerTipoRuta = TextEditingController();


  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    _controllerTheme.text = Provider.of<ThemeProvider>(context).currentThemeName == 'light' ? 'Light Mode' : 'Dark Mode';
    _controllerUser.text = Preferences.user ?? '';
    _controllerPathLocal.text = Preferences.pathLocal ?? '';
    _controllerPass.text = Preferences.pass ?? '';
    _controllerPort.text = '${Preferences.port}';
    _controllerHost.text = Preferences.host ?? '';
    _controllerCoop.text = Preferences.cooperativa ?? '';
    _controllerPathExterna.text = Preferences.pathExterna ?? '';
    _controllerTipoRuta.text = Preferences.tipoRuta ?? true ? 'Local' : 'Externo';
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
                        const SizedBox(height: 10,),
                        TextFormField(
                          decoration: InputDecorations.authImputDecoration(hintText: '', labelText: '', context: context),
                          initialValue: Preferences.cooperativa,
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
                      const SizedBox(height: 10,),
                      TextFormField(
                        decoration: InputDecorations.authImputDecoration(hintText: '', labelText: '', context: context),
                        initialValue: '${Preferences.port}',
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
                _containerRow(context, 'Servidor Externo', _controllerHost, () => showDialog(context: context, builder: (context) => CustomAlertDialog(
                  titulo: 'Cambiar Servidor',
                  contenido: Column(
                    children: [
                      const Text('Para cambiar el servidor contacte con GAE para tener más información y no provocar errores.'),
                      const SizedBox(height: 10,),
                      TextFormField(
                        decoration: InputDecorations.authImputDecoration(hintText: '', labelText: '', context: context),
                        initialValue: Preferences.host,
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
                _containerRow(context, 'Servidor Local', _controllerPathExterna, () {
                  showDialog(context: context, builder: (context) => CustomAlertDialog(
                    titulo: 'Cambiar Servidor',
                    contenido: Column(
                      children: [
                        const Text('Para cambiar la ruta contacte con GAE para tener más información y no provocar errores.'),
                        const SizedBox(height: 10,),
                        TextFormField(
                          decoration: InputDecorations.authImputDecoration(hintText: '', labelText: '', context: context),
                          initialValue: Preferences.pathExterna,
                          keyboardType: TextInputType.number,
                          onChanged: (value) {
                            _controllerPathExterna.text = value;
                            Preferences.pathExterna = value;
                          },
                        )
                      ],
                    ),
                    onPressed: () => Navigator.pop(context),
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
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Row(
                        children: [
                          const Text('Externo'), /* false */
                          Switch(
                            value: Preferences.tipoRuta ?? true,
                            onChanged: (value) {
                              Preferences.tipoRuta = value;
                              _controllerTipoRuta.text = value ? 'Local' : 'Externo';
                              setState(() {

                              });
                            },),
                          const Text('Local') /* true */
                        ],
                      )

                    ],
                  ),
                ),
                _containerRow(context, 'Ruta', _controllerPathLocal, () {
                  showDialog(context: context, builder: (context) => CustomAlertDialog(
                    titulo: 'Cambiar Ruta',
                    contenido: Column(
                      children: [
                        const Text('Para cambiar la ruta contacte con GAE para tener más información y no provocar errores.'),
                        const SizedBox(height: 10,),
                        TextFormField(
                          decoration: InputDecorations.authImputDecoration(hintText: '', labelText: '', context: context),
                          initialValue: Preferences.pathLocal,
                          onChanged: (value) {
                            _controllerPathLocal.text = value;
                            Preferences.pathLocal = value;
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
                        const SizedBox(height: 10,),
                        TextFormField(
                          decoration: InputDecorations.authImputDecoration(hintText: '', labelText: '', context: context),
                          initialValue: Preferences.user,
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
                        const SizedBox(height: 10,),
                        TextFormField(
                          decoration: InputDecorations.authImputDecoration(hintText: '', labelText: '', context: context),
                          initialValue: Preferences.pass,
                          onChanged: (value) {
                            _controllerPass.text = value;
                            Preferences.pass = value;
                          },
                        )
                      ],
                    ),
                    onPressed: () {
                      if(Preferences.port! > 0 && Preferences.host!.length > 1 && Preferences.user!.length > 1 && Preferences.pathLocal!.length > 1 && Preferences.pass!.length > 1){
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
                          margin: const EdgeInsets.only(right: 50, left: 20),
                          child: TextField(
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
