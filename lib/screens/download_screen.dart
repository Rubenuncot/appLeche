import 'package:flutter/material.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:provider/provider.dart';
import 'package:smart_snackbars/smart_snackbars.dart';
import 'package:transportes_leche/database/models/descarga_model.dart';
import 'package:transportes_leche/database/models/industria_model.dart';
import 'package:transportes_leche/providers/input_provider.dart';
import 'package:transportes_leche/providers/model_provider.dart';
import 'package:transportes_leche/screens/screens.dart';
import 'package:transportes_leche/shared_preferences/preferences.dart';

import '../providers/theme_provider.dart';
import '../theme/theme_main.dart';
import '../ui/input_decorations.dart';
import '../widgets/widgets.dart';

class DownloadScreen extends StatefulWidget {
  static String routeName = '_download';

  const DownloadScreen({Key? key}) : super(key: key);

  @override
  State<DownloadScreen> createState() => _DownloadScreenState();
}

class _DownloadScreenState extends State<DownloadScreen>
    with WidgetsBindingObserver {
  final _advancedDrawerController = AdvancedDrawerController();

  final _focusNodeCode = FocusNode();
  final _focusNodeKilos = FocusNode();
  String industriaNombre = '';

  /* Variables */
  bool valid = false;
  bool waiting = false;
  bool complete = false;

  dynamic obj = Industria(codigo: 0, nombre: '');

  List<dynamic>? industrias = [];
  Industria industria = Industria(codigo: 0, nombre: 'nombre');

  Descarga descarga = Descarga(
      codIndustria: 0, kilos: 0.0, fechaHora: 'fechaHora', enviado: false);

  void getLista() async {
    industrias =
        await ModelProvider.getAllReg(Industria(codigo: 0, nombre: 'nombre'));
    setState(() {});
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    getLista();
  }

  String getIndustria() {
    String cod = Provider.of<InputProvider>(context, listen: false).valueInd;
    industriaNombre = '';

    for (var x in industrias!) {
      if ('${x.codigo}' == cod) {
        industria = x;
        industriaNombre = x.nombre;
      }
    }

    return industriaNombre;
  }

  void createDescarga() async {
    SmartSnackBars.showTemplatedSnackbar(
        context: context,
        backgroundColor: ThemeMain.buttonColor,
        subTitle: 'Creada la descarga correctamente',
        animationCurve: const ElasticInCurve());
    ModelProvider modelProvider =
        Provider.of<ModelProvider>(context, listen: false);
    String cod = Provider.of<InputProvider>(context, listen: false).valueKil;

    List<dynamic> industrias =
        await modelProvider.getRegName(getIndustria(), obj);
    industria = industrias[0];

    descarga.enviado = false;
    descarga.fechaHora =
        '${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day}/${DateTime.now().month < 10 ? '0${DateTime.now().month}' : DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute < 10 ? '0${DateTime.now().minute}' : DateTime.now().minute}';
    descarga.codIndustria = industria.codigo;
    descarga.kilos = double.parse(cod);

    print(
        '${descarga.kilos} - ${descarga.enviado} - ${descarga.fechaHora} - ${descarga.codIndustria}');
    modelProvider.newReg(descarga);
  }

  /* Métodos override */

  @override
  Widget build(BuildContext context) {
    final dynamic args = ModalRoute.of(context)?.settings.arguments;
    if (args != null) {
      Provider.of<InputProvider>(context, listen: false).valueInd =
          '${args.codigo}';
    }

    return GestureDetector(
      onTap: () {
        _focusNodeCode.unfocus();
        _focusNodeKilos.unfocus();
      },
      child: AdvancedDrawer(
        backdrop: Container(
          width: double.infinity,
          height: double.infinity,
          decoration: BoxDecoration(
              gradient: LinearGradient(
                  stops: const [0.759, 1],
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: [
                    const Color.fromARGB(255, 0, 40, 75),
                    const Color.fromARGB(255, 0, 40, 75).withOpacity(0.7)
                  ])),
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
        drawer:
            CustomDrawer(modelProvider: Provider.of<ModelProvider>(context)),
        child: Scaffold(
          floatingActionButtonLocation:
              FloatingActionButtonLocation.centerFloat,
          /* Botones Flotantes */
          floatingActionButton: SizedBox(
            width: double.infinity,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    height: 50,
                    onPressed: () {
                      Navigator.pushReplacementNamed(
                          context, MainScreen.routeName);
                    },
                    color: ThemeMain.buttonColor3,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    elevation: 0,
                    child: const Icon(
                      Icons.arrow_back,
                      color: ThemeMain.backgroundColorLight,
                    ),
                  ),
                  MaterialButton(
                    height: 50,
                    onPressed: !complete
                        ? null
                        : () {
                            createDescarga();
                            setState(() {
                              Provider.of<InputProvider>(context, listen: false)
                                  .valueInd = '';
                              Provider.of<InputProvider>(context, listen: false)
                                  .valueKil = '';
                              complete = false;
                            });
                            Navigator.pushReplacementNamed(
                                context, DownloadScreen.routeName);
                          },
                    color: ThemeMain.buttonColor,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    elevation: 0,
                    child: const Icon(
                      Icons.save_alt,
                      color: ThemeMain.backgroundColorLight,
                    ),
                  ),
                ],
              ),
            ),
          ),
          appBar: CustomAppBar(
            name: Preferences.conductor ?? '',
            advancedDrawerController: _advancedDrawerController,
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                /* Cabecera donde está el codigo de industria */
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: SizedBox(
                    height: 100,
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(
                          width: MediaQuery.of(context).size.width * 0.3,
                          child: TextFormField(
                            onChanged: (value) {
                              Provider.of<InputProvider>(context, listen: false)
                                  .valueInd = value;
                              getLista();
                            },
                            initialValue:
                                Provider.of<InputProvider>(context).valueInd,
                            focusNode: _focusNodeCode,
                            keyboardType: TextInputType.number,
                            decoration: InputDecorations.authImputDecoration(
                                context: context,
                                hintText: '123',
                                labelText: 'Código'),
                          ),
                        ),
                        const SizedBox(
                          width: 20,
                        ),
                        /* Botón de buscar */
                        ElevatedButton(
                            onPressed: () => Navigator.pushReplacementNamed(
                                    context, SearchScreen.routeName,
                                    arguments: [
                                      Industria(codigo: 0, nombre: 'nombre')
                                    ]),
                            style: const ButtonStyle(
                                shape: MaterialStatePropertyAll(
                                    RoundedRectangleBorder(
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20)))),
                                backgroundColor: MaterialStatePropertyAll(
                                    ThemeMain.buttonColor2),
                                side: MaterialStatePropertyAll(
                                    BorderSide(color: Colors.black12))),
                            child: Row(
                              children: const [
                                Icon(
                                  Icons.search,
                                  color: ThemeMain.backgroundColorLight,
                                ),
                                Text(
                                  'Buscar',
                                  style: TextStyle(
                                      color: ThemeMain.backgroundColorLight),
                                )
                              ],
                            ))
                      ],
                    ),
                  ),
                ),
                const SizedBox(
                  height: 50,
                ),
                SingleChildScrollView(
                  child: Container(
                    decoration: BoxDecoration(
                        border: Border.all(color: Colors.black26),
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black12,
                            spreadRadius: 2,
                            blurRadius: 10,
                          )
                        ],
                        color: Provider.of<ThemeProvider>(context)
                                    .currentThemeName ==
                                'light'
                            ? Colors.black12
                            : Colors.white),
                    margin:
                        const EdgeInsets.symmetric(horizontal: 5, vertical: 20),
                    padding: const EdgeInsets.symmetric(
                        horizontal: 10, vertical: 15),
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 15, vertical: 10),
                              decoration: BoxDecoration(
                                  color: ThemeMain.buttonColor,
                                  borderRadius: BorderRadius.circular(20)),
                              child: Container(
                                constraints: BoxConstraints(
                                    maxWidth:
                                        MediaQuery.of(context).size.width *
                                            0.7),
                                child: Text(
                                  'Industria: ${getIndustria()}',
                                  style: const TextStyle(color: Colors.white),
                                  overflow: TextOverflow.ellipsis,
                                  maxLines: 1,
                                ),
                              ),
                            )
                          ],
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                        Container(
                          padding: const EdgeInsets.symmetric(
                              horizontal: 15, vertical: 10),
                          decoration: BoxDecoration(
                              color: Colors.black12,
                              borderRadius: BorderRadius.circular(20),
                              border: Border.all(color: Colors.black12)),
                          child: Row(
                            mainAxisSize: MainAxisSize.max,
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Expanded(
                                  child: TextFormField(
                                onChanged: (value) {
                                  InputProvider inputProvider =
                                      Provider.of<InputProvider>(context,
                                          listen: false);

                                  inputProvider.valueKil = value;
                                },
                                onEditingComplete: () {
                                  complete = true;
                                  setState(() {

                                  });
                                  _focusNodeKilos.unfocus();
                                },
                                focusNode: _focusNodeKilos,
                                keyboardType: TextInputType.number,
                                decoration:
                                    InputDecorations.authImputDecoration(
                                        context: context,
                                        hintText: '',
                                        labelText: 'Kilos'),
                              )),
                              const SizedBox(
                                width: 70,
                              ),
                              const Text('Kilos')
                            ],
                          ),
                        ),
                        const SizedBox(
                          height: 20,
                        ),
                      ],
                    ),
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
