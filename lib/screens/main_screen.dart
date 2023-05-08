import 'dart:async';

import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:transportes_leche/database/models/conductor_model.dart';
import 'package:transportes_leche/database/models/matricula_model.dart';
import 'package:transportes_leche/file_management/file_download.dart';
import 'package:transportes_leche/providers/model_provider.dart';
import 'package:transportes_leche/providers/theme_provider.dart';
import 'package:transportes_leche/screens/download_screen.dart';
import 'package:transportes_leche/screens/load_screen.dart';
import 'package:transportes_leche/shared_preferences/preferences.dart';
import 'package:transportes_leche/theme/theme_main.dart';

import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

Map<String, String> listCond =
    {}; /* Lista de elementos del dropdown de conductores */
List<String> condCod = [];
List<String> condName = [];
Map<String, String> listMat =
    {}; /* Lista de elementos del dropdown de matriculas */
List<String> matCod = [];

class MainScreen extends StatefulWidget {
  static String routeName = '_main';

  const MainScreen({Key? key}) : super(key: key);

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> with WidgetsBindingObserver {
  // ----- Variables ----- //

  final _advancedDrawerController = AdvancedDrawerController();

  /* Valor del dropdown de matriculas */

  String dropdownValueMat = Preferences.matricula ?? '';
  String dropdownValueCond = Preferences.conductor ?? '';

  bool showNowDialog = false;

  bool waiting = false;

  // ----- Fin Variables ----- //

  // ----- ----- Métodos ----- ----- //
  /*
  * Relleno las listas
  */
  void rellenarListas() async {
    // Ahora mismo las relleno con literales por no tener los datos.

    listCond = {};
    listMat = {};

    List<dynamic>? list =
        await ModelProvider.getAllReg(Conductor(cif: 'cif', nombre: 'nombre'));
    for (var g in list!) {
      listCond.addAll({'${g.cif}': g.nombre});
    }

    List<dynamic>? listMatr = await ModelProvider.getAllReg(
        Matricula(matricula: 'matricula', codCisterna: 'codCisterna'));
    for (var g in listMatr!) {
      listMat.addAll({'${g.matricula}': g.codCisterna});
    }

    Iterable<String> listConductores = listCond.keys;

    condCod = [];
    condName = [];

    for (var gan in listConductores) {
      condCod.add(gan);
      condName.add(listCond[gan]!);
    }

    if (Preferences.conductor == '') Preferences.conductor = condName.first;

    Iterable<String> listMatriculas = listMat.keys;

    matCod = [];
    for (var gan in listMatriculas) {
      matCod.add(gan);
    }

    if (Preferences.matricula == '') Preferences.matricula = matCod.first;

    setState(() {
    });
  }

  Future<void> _downloadFtp() async {
    waiting = false;
    await DownloadFile.download(context);
    setState(() {
      showNowDialog = true;
    });
  }

  // ----- ----- Fin Métodos ----- ----- //

  // ----- ----- Overrides ----- ----- //
  @override
  void didChangeDependencies() async {
    super.didChangeDependencies();
    if (listCond.isEmpty) rellenarListas();

    if (await Permission.bluetooth.request().isDenied) {
      SystemNavigator.pop();
    }

    if (await Permission.bluetoothConnect.request().isDenied) {
      SystemNavigator.pop();
    }

    if (await Permission.bluetoothScan.request().isDenied) {
      SystemNavigator.pop();
    }

    if (await Permission.bluetoothAdvertise.request().isDenied) {
      SystemNavigator.pop();
    }

    if (await Permission.storage.request().isDenied) {
      SystemNavigator.pop();
    }
  }

  // ----- ----- Fin Overrides ----- ----- //
  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size; /* Tamaño de la pantalla */


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

    return AdvancedDrawer(
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
          appBar: CustomAppBar(
            name: dropdownValueCond,
            advancedDrawerController: _advancedDrawerController,
          ),
          body: Stack(
            children: [
              FutureBuilder(
                future: waiting ? _downloadFtp() : null,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return Container(
                      color: Colors.black26,
                      child: const Center(
                        child: CupertinoActivityIndicator(
                            color: ThemeMain.buttonColor),
                      ),
                    );
                  } else {
                    return SingleChildScrollView(
                      child: Stack(children: [
                        Column(
                          children: [
                            const SizedBox(
                              height: 10,
                            ),
                            // Formulario de la matricula y el conductor.
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 20),
                              child: Form(
                                  // Formulario donde está el conductor y la matricula.
                                  child: Column(
                                children: [
                                  SizedBox(
                                      width: double.infinity,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Provider.of<ThemeProvider>(
                                                            context)
                                                        .currentThemeName ==
                                                    'light'
                                                ? Colors.black12
                                                : Colors.white54,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: ListTile(
                                          title: Center(
                                              child: Text(
                                                  Preferences.conductor == ''
                                                      ? 'Conductor'
                                                      : dropdownValueCond)),
                                          onTap: () {
                                            DropDownState(DropDown(
                                              data: [
                                                for (var x in condName)
                                                  SelectedListItem(
                                                      name: x, value: x),
                                              ],
                                              selectedItems: (selectedItems) {
                                                for (var x = 0;
                                                    x < selectedItems.length;
                                                    x++) {
                                                  Preferences.conductor =
                                                      selectedItems[x].value;
                                                  setState(() {
                                                    dropdownValueCond =
                                                        selectedItems[x].value!;
                                                  });
                                                }
                                              },
                                            )).showModal(context);
                                          },
                                        ),
                                      )),
                                  SizedBox(
                                    width: size.width * 0.2,
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  SizedBox(
                                      // TODO: Poner en un widget a parte.
                                      width: double.infinity,
                                      child: Container(
                                        decoration: BoxDecoration(
                                            color: Provider.of<ThemeProvider>(
                                                            context)
                                                        .currentThemeName ==
                                                    'light'
                                                ? Colors.black12
                                                : Colors.white54,
                                            borderRadius:
                                                BorderRadius.circular(20)),
                                        child: ListTile(
                                          title: Center(
                                              child: Text(
                                                  Preferences.matricula == ''
                                                      ? 'Matricula'
                                                      : dropdownValueMat)),
                                          onTap: () {
                                            DropDownState(DropDown(
                                              data: [
                                                for (var x in matCod)
                                                  SelectedListItem(
                                                      name: x, value: x),
                                              ],
                                              selectedItems: (selectedItems) {
                                                for (var x = 0;
                                                    x < selectedItems.length;
                                                    x++) {
                                                  Preferences.matricula =
                                                      selectedItems[x].value;
                                                  setState(() {
                                                    dropdownValueMat =
                                                        selectedItems[x].value!;
                                                  });
                                                }
                                              },
                                            )).showModal(context);
                                          },
                                        ),
                                      )),
                                ],
                              )),
                            ),
                            const SizedBox(
                              height: 30,
                            ),
                            // En este padding están los botones.
                            Padding(
                              padding: EdgeInsets.symmetric(
                                  horizontal: size.width * 0.1),
                              child: Column(
                                children: [
                                  CustomButton(
                                    text: 'Cargar',
                                    color: ThemeMain.buttonColor,
                                    textColor: Colors.white,
                                    onClick: waiting
                                        ? null
                                        : () => Navigator.pushNamed(
                                            context, LoadScreen.routeName),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomButton(
                                    text: 'Descargar',
                                    color: ThemeMain.buttonColor,
                                    textColor: Colors.white,
                                    onClick: waiting
                                        ? null
                                        : () => Navigator.pushNamed(
                                            context, DownloadScreen.routeName),
                                  ),
                                  const SizedBox(
                                    height: 20,
                                  ),
                                  CustomButton(
                                    text: 'Enviar/Recibir',
                                    color: ThemeMain.buttonColor2,
                                    onClick: waiting
                                        ? null
                                        : () {
                                            setState(() {
                                              waiting = true;
                                            });
                                          },
                                  ),
                                ],
                              ),
                            )
                          ],
                        ),
                      ]),
                    );
                  }
                },
              ),
            ],
          )),
    );
  }
}
