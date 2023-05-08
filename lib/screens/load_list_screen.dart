import 'dart:async';

import 'package:animated_radio_buttons/animated_radio_buttons.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:smart_snackbars/smart_snackbars.dart';
import 'package:ticket_widget/ticket_widget.dart';
import 'package:transportes_leche/database/models/carga_model.dart';
import 'package:transportes_leche/providers/model_provider.dart';
import 'package:transportes_leche/widgets/custom_alert_dialog.dart';

import '../database/models/ganadero_model.dart';
import '../database/models/tanque_model.dart';
import '../providers/input_provider.dart';
import '../providers/theme_provider.dart';
import '../shared_preferences/preferences.dart';
import '../theme/theme_main.dart';

class LoadListScreen extends StatefulWidget {
  static String routeName = '_loadList';

  const LoadListScreen({Key? key}) : super(key: key);

  @override
  State<LoadListScreen> createState() => _LoadListScreenState();
}

class _LoadListScreenState extends State<LoadListScreen> {
  Ganadero obj = Ganadero(codigo: 0, nombre: 'nombre', nif: 'nif', tanques: []);
  Carga carga = Carga(
      cifConductor: 'cifConductor',
      nombreConductor: 'nombreConductor',
      matricula: 'matricula',
      cisterna: 'cisterna',
      fechaHora: 'fechaHora',
      codGanadero: 0,
      producto: 'producto',
      tanques: [],
      enviado: false);

  List? cargas = [];

  String productoSelected = '';
  String matricula = '';
  String codCisterna = '';
  String fecha = '';
  String ganaderoNombre = '';
  String ganaderoDni = '';

  int codigo = 0;

  double litrosTotal = 0;

  List<Tanque> tanques = [];

  List<bool> muestras = [];

  bool verTicket = false;
  bool borrar = false;
  bool borrado = false;
  bool aceptado = false;

  List<String> valuesLitros = [];
  List<String> valuesTemps = [];

  String _info = "";
  String _msj = '';
  bool connected = false;
  List<BluetoothInfo> items = [];
  final List<String> _options = [
    "permission bluetooth granted",
    "bluetooth enabled",
    "connection status",
    "update info"
  ];

  final _txtText = TextEditingController(text: "Hello developer");
  bool _connceting = false;

  bool printed = false;

  void borrarCarga() async{
    await Provider.of<ModelProvider>(context, listen: false).deleteCarga(carga);
    borrado = true;
  }

  void showBorrar() {
    Dialogs.bottomMaterialDialog(
        msg: 'Estás seguro de borrar la Carga? No se puede rehacer esta acción.',
        title: 'Borrar Carga',
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: 'Cancel',
            iconData: Icons.cancel_outlined,
            textStyle: const TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () {
              borrarCarga();
              Navigator.pop(context);
            },
            text: 'Delete',
            iconData: Icons.delete,
            color: Colors.red,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
    borrar = false;
  }

  void showTicket() async {
    double width = MediaQuery.of(context).size.width;
    double height = MediaQuery.of(context).size.height;
    showDialog(
      context: context,
      builder: (context) => CustomAlertDialog(
          showButton: false,
          bakcgorundColor: Colors.transparent,
          titulo: '',
          contenido: TicketWidget(
              isCornerRounded: true,
              shadow: [BoxShadow(color: Provider.of<ThemeProvider>(context).currentThemeName == 'light' ? Colors.black12 : Colors.white12,)],
              color: Provider.of<ThemeProvider>(context).currentThemeName == 'light' ? Colors.white : const Color.fromARGB(
                  1, 82, 82, 82),
              width: width,
              height: tanques.length < 2 ? height * 0.6 : height * 0.7,
              child: Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      const Text(
                        '--- COMPRADOR ---',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${Preferences.cooperativa}',
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        '--- CONDUCTOR ---',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        '${Preferences.conductor}',
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Matricula: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                          Text(
                            '${Preferences.matricula}',
                            style: const TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Cisterna: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                          Text(
                            codCisterna,
                            style: const TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        '--- FECHA ---',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        fecha,
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        '--- GANADERO ---',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Text(
                        ganaderoNombre,
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.min,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'NIF: ',
                            style: TextStyle(
                                fontWeight: FontWeight.bold, fontSize: 10),
                          ),
                          Text(
                            ganaderoDni,
                            style: const TextStyle(fontSize: 10),
                          )
                        ],
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: const [
                          Text(
                            'TAN',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                decoration: TextDecoration.underline),
                          ),
                          Text(
                            'LIT',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                decoration: TextDecoration.underline),
                          ),
                          Text(
                            'MUE',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                decoration: TextDecoration.underline),
                          ),
                          Text(
                            'TEM',
                            style: TextStyle(
                                fontWeight: FontWeight.bold,
                                fontSize: 10,
                                decoration: TextDecoration.underline),
                          ),
                        ],
                      ),
                      const SizedBox(
                        height: 10,
                      ),
                      for (var x in tanques)
                        Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              x.codigo,
                              style: const TextStyle(fontSize: 10),
                            ),
                            Text(
                              '${x.litros}',
                              style: const TextStyle(fontSize: 10),
                            ),
                            Text(
                              x.muestra ? 'S' : 'N',
                              style: const TextStyle(fontSize: 10),
                            ),
                            Text(
                              '${x.temp}',
                              style: const TextStyle(fontSize: 10),
                            ),
                          ],
                        ),
                      const SizedBox(
                        height: 20,
                      ),
                      const Text(
                        '--- PRODUCTO ---',
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Text(
                        productoSelected,
                        style: const TextStyle(fontSize: 10),
                      ),
                      const SizedBox(
                        height: 20,
                      ),
                      Text(
                        'TOTAL: $litrosTotal L',
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 10),
                      ),
                    ],
                  )))),
    );
    verTicket = false;
  }

  void getList() async {
    cargas = await ModelProvider.getAllReg(Carga(
        cifConductor: 'cifConductor',
        nombreConductor: 'nombreConductor',
        matricula: 'matricula',
        cisterna: 'cisterna',
        fechaHora: 'fechaHora',
        codGanadero: 0,
        producto: 'producto',
        tanques: [],
        enviado: false));
    setState(() {});
  }

  Future<void> initPlatformState() async {
    String platformVersion;
    int porcentbatery = 0;
    // Platform messages may fail, so we use a try/catch PlatformException.
    try {
      platformVersion = await PrintBluetoothThermal.platformVersion;
      porcentbatery = await PrintBluetoothThermal.batteryLevel;
    } on PlatformException {
      platformVersion = 'Failed to get platform version.';
    }

    // If the widget was removed from the tree while the asynchronous platform
    // message was in flight, we want to discard the reply rather than calling
    // setState to update our non-existent appearance.
    if (!mounted) return;

    final bool result = await PrintBluetoothThermal.bluetoothEnabled;
    //print("bluetooth enabled: $result");
    if (result) {
      _msj = "Bluetooth enabled, please search and connect";
    } else {
      _msj = "Bluetooth not enabled";
    }

    setState(() {
      _info = platformVersion + " ($porcentbatery% battery)";
    });
  }

  Future<void> getBluetoots() async {
    final List<BluetoothInfo> listResult =
        await PrintBluetoothThermal.pairedBluetooths;

    /*await Future.forEach(listResult, (BluetoothInfo bluetooth) {
      String name = bluetooth.name;
      String mac = bluetooth.macAdress;
    });*/

    if (listResult.isEmpty) {
      _msj =
          "There are no bluetoohs linked, go to settings and link the printer";
    } else {
      _msj = "Touch an item in the list to connect";
    }

    setState(() {
      items = listResult;
    });
  }

  Future<void> connect(String mac) async {
    setState(() {
      _connceting = true;
    });
    if (mac == '') {
      dialogConnect();
    } else {
      if (!printed) {
        final bool result =
            await PrintBluetoothThermal.connect(macPrinterAddress: mac);
        print("state conected $result");
        if (result) {
          connected = true;
          printed = true;
        }
      } else {
        connected = true;
      }
      setState(() {
        _connceting = false;
      });
    }
  }

  void dialogConnect() {
    getBluetoots();
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
        backgroundColor: Colors.white,
        child: Container(
            height: 200,
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: Colors.grey.withOpacity(0.3),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
            margin: const EdgeInsets.symmetric(horizontal: 5, vertical: 15),
            child: ListView.builder(
              itemCount: items.isNotEmpty ? items.length : 0,
              itemBuilder: (context, index) {
                return ListTile(
                  onTap: () {
                    String mac = items[index].macAdress;
                    Preferences.mac = mac;
                    connect(mac);
                    Navigator.pop(context);
                  },
                  title: Text('Name: ${items[index].name}'),
                  subtitle: Text("macAdress: ${items[index].macAdress}"),
                );
              },
            )),
      ),
    );
  }

  Future<void> disconnect() async {
    final bool status = await PrintBluetoothThermal.disconnect;
    setState(() {
      connected = false;
    });
    print("status disconnect $status");
  }

  Future<List<int>> testTicket() async {
    InputProvider inputProvider =
        Provider.of<InputProvider>(context, listen: false);

    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontB);
    bytes += generator.reset();

    bytes += generator.text('--- COMPRADOR --- ',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size2,
            height: PosTextSize.size2));
    bytes += generator.text('${Preferences.cooperativa}',
        styles: const PosStyles(align: PosAlign.center));
    bytes += generator.emptyLines(1);

    bytes += generator.text('--- CONDUCTOR ---',
        styles: const PosStyles(
            codeTable: 'CP1252',
            height: PosTextSize.size2,
            width: PosTextSize.size2,
            align: PosAlign.center));
    bytes += generator.text(
      '${Preferences.conductor}',
      styles: const PosStyles(codeTable: 'CP1252', align: PosAlign.center),
    );
    bytes += generator.emptyLines(1);
    bytes += generator.text(
      'MATRICULA: ${Preferences.matricula}',
      styles: const PosStyles(codeTable: 'CP1252', align: PosAlign.center),
    );
    bytes += generator.emptyLines(1);
    //bytes += generator.text('Reverse text', styles: PosStyles(reverse: true));
    // bytes += generator.text('Underlined text',
    //     styles: PosStyles(underline: true), linesAfter: 1);
    bytes += generator.text('CISTERNA: $codCisterna',
        styles: const PosStyles(
          align: PosAlign.center,
        ));
    bytes += generator.emptyLines(2);

    bytes += generator.text(' --- Fecha ---',
        styles: const PosStyles(
            align: PosAlign.center,
            width: PosTextSize.size2,
            height: PosTextSize.size2));

    bytes +=
        generator.text(fecha, styles: const PosStyles(align: PosAlign.center));
    // bytes += generator.text('Align right',
    //     styles: PosStyles(align: PosAlign.right), linesAfter: 1);
    bytes += generator.emptyLines(2);
    bytes += generator.text('--- GANADERO ---',
        styles: const PosStyles(
            bold: true,
            align: PosAlign.center,
            width: PosTextSize.size2,
            height: PosTextSize.size2));
    bytes += generator.text(ganaderoNombre,
        styles: const PosStyles(bold: true, align: PosAlign.center));
    bytes += generator.text('NIF: $ganaderoDni ',
        styles: const PosStyles(bold: true, align: PosAlign.center));
    bytes += generator.emptyLines(1);
    bytes += generator.row([
      PosColumn(
        text: 'TANQUES',
        width: 3,
        styles: const PosStyles(
            align: PosAlign.center,
            underline: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2),
      ),
      PosColumn(
        text: 'LITROS',
        width: 3,
        styles: const PosStyles(
            align: PosAlign.center,
            underline: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2),
      ),
      PosColumn(
        text: 'MUESTRAS',
        width: 3,
        styles: const PosStyles(
            align: PosAlign.center,
            underline: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2),
      ),
      PosColumn(
        text: 'TEMP',
        width: 3,
        styles: const PosStyles(
            align: PosAlign.center,
            underline: true,
            width: PosTextSize.size2,
            height: PosTextSize.size2),
      ),
    ]);
    bytes += generator.emptyLines(1);
    List<PosColumn> listTanquesColum = [];
    for (var x = 0; x < tanques.length; x++) {
      if (x < valuesLitros.length) {
        listTanquesColum = [];
        listTanquesColum.add(
          PosColumn(
            text: tanques[x].codigo,
            width: 3,
            styles: const PosStyles(
              align: PosAlign.center,
            ),
          ),
        );
        listTanquesColum.add(
          PosColumn(
            text:
                '${(valuesLitros[x] == '' ? 0 : double.parse(valuesLitros[x]))} L',
            width: 3,
            styles: const PosStyles(
              align: PosAlign.center,
            ),
          ),
        );
        listTanquesColum.add(
          PosColumn(
            text: muestras[x] ? 'S' : 'N',
            width: 3,
            styles: const PosStyles(align: PosAlign.center),
          ),
        );
        listTanquesColum.add(
          PosColumn(
            text:
                '${double.parse(valuesTemps[x] == '' ? '0' : valuesTemps[x])}',
            width: 3,
            styles: const PosStyles(
              align: PosAlign.center,
            ),
          ),
        );
        bytes += generator.row(listTanquesColum);
      }
    }
    bytes += generator.emptyLines(3);

    bytes += generator.text(
      '--- Producto ---',
      styles: const PosStyles(
          height: PosTextSize.size2,
          width: PosTextSize.size2,
          align: PosAlign.center),
    );
    bytes += generator.text(
      productoSelected,
      styles: const PosStyles(align: PosAlign.center),
    );
    bytes += generator.emptyLines(2);
    bytes += generator.text(
      'Total: $litrosTotal L',
      styles: const PosStyles(
        height: PosTextSize.size2,
        width: PosTextSize.size2,
        align: PosAlign.center,
      ),
    );
    bytes += generator.emptyLines(2);
    bytes += generator.feed(2);
    //bytes += generator.cut();
    return bytes;
  }

  Future<void> printTest() async {
    await connect(Preferences.mac ?? '');

    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    if (conexionStatus) {
      List<int> ticket = await testTicket();
      final result = await PrintBluetoothThermal.writeBytes(ticket);
      print("impresion $result");
    } else {
      //no conectado, reconecte
    }
  }

  void getGanaderoInfo() async {
    List? ganaderos = await ModelProvider.getAllReg(obj);

    for (var x in ganaderos!) {
      if (x.codigo == codigo) {
        ganaderoNombre = x.nombre;
        ganaderoDni = x.nif;
      }
    }

    for (var x in tanques) {
      muestras.add(x.muestra);
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    getList();

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if (verTicket) {
        showTicket();
        verTicket = false;
      }

      if (borrado) {
        SmartSnackBars.showTemplatedSnackbar(
            context: context,
            subTitle: 'Elemento borrado correctamente',
            backgroundColor: ThemeMain.buttonColor3);
        borrado = false;
      }

      if (borrar) {
        setState(() {
          aceptado = false;
        });
        showBorrar();
        borrar = false;
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Cargas'),
        backgroundColor: ThemeMain.buttonColor,
      ),
      body: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            margin: const EdgeInsets.only(top: 20, right: 20),
            child: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.4,
                    child: const Text(
                      'CodigoGanadero',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.2,
                    child: const Text(
                      'Fecha',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    )),
                const Text('Enviado')
              ],
            ),
          ),
          const SizedBox(
            height: 20,
          ),
          Container(
            constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width,
                maxHeight: MediaQuery.of(context).size.height * 0.8),
            child: ListView.builder(
              itemCount: cargas?.length,
              itemBuilder: (context, index) {
                return Container(
                  margin:
                      const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: ListTile(
                      title: Row(
                        mainAxisSize: MainAxisSize.max,
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Container(
                            padding: const EdgeInsets.symmetric(
                                horizontal: 5, vertical: 3),
                            width: MediaQuery.of(context).size.width * 0.2,
                            decoration: BoxDecoration(
                              color: const Color.fromARGB(255, 143, 67, 238),
                              borderRadius: BorderRadius.circular(5),
                            ),
                            child: index < (cargas?.length ?? 1)
                                ? Row(
                                    mainAxisSize: MainAxisSize.max,
                                    crossAxisAlignment:
                                        CrossAxisAlignment.center,
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: [
                                      Text(
                                          '${cargas![index].codGanadero ?? ''}'),
                                    ],
                                  )
                                : const Text(''),
                          ),
                          SizedBox(
                              width: MediaQuery.of(context).size.width * 0.3,
                              child: Text(
                                '${cargas![index].fechaHora ?? ''}',
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
                              )),
                          AnimatedRadioButtons(
                              items: [
                                AnimatedRadioButtonItem(
                                    color: ThemeMain.buttonColor, label: '')
                              ],
                              animationCurve: const ElasticInCurve(),
                              backgroundColor: Colors.black12,
                              onChanged: (value) {
                                Provider.of<ModelProvider>(context,
                                        listen: false)
                                    .updateCarga(cargas![index],
                                        !cargas![index].enviado);
                                setState(() {});
                              },
                              value: cargas![index].enviado == false ? 1 : 0)
                        ],
                      ),
                      onTap: () {
                        setState(() {
                          carga = cargas![index];
                          codigo = cargas![index].codGanadero;
                          print(codigo);
                          productoSelected = cargas![index].producto;
                          print(productoSelected);
                          codCisterna = cargas![index].cisterna;
                          print(codCisterna);
                          matricula = cargas![index].matricula;
                          print(matricula);
                          fecha = cargas![index].fechaHora;
                          print(fecha);

                          valuesLitros = [];
                          valuesTemps = [];
                          tanques = [];
                          litrosTotal = 0;

                          for (var x in cargas![index].tanques) {
                            if (x.codigo != '') {
                              tanques.add(x);
                            }
                          }

                          for (var x in tanques) {
                            valuesLitros.add('${x.litros}');
                            valuesTemps.add('${x.temp}');
                            print('Tanque: ${x.codigo}');
                          }

                          for (var x = 0; x < valuesLitros.length; x++) {
                            litrosTotal = litrosTotal +
                                (valuesLitros[x] == ''
                                    ? 0
                                    : double.parse(valuesLitros[x]));
                          }
                          print('Litros totales: $litrosTotal');
                        });
                        getGanaderoInfo();
                        print(ganaderoDni);
                        print(ganaderoNombre);
                        DropDownState(DropDown(
                                data: [
                              SelectedListItem(name: 'Ver tiket', value: '1'),
                              SelectedListItem(name: 'Imprimir', value: '2'),
                              SelectedListItem(
                                  name: cargas![index].enviado == false
                                      ? 'Marcar como enviado'
                                      : 'Desmarcar como enviado',
                                  value: '3'),
                              SelectedListItem(name: 'Borrar', value: '4'),
                            ],
                                selectedItems: (selectedItems) {
                                  for (var x in selectedItems) {
                                    if (x.value == '1') {
                                      print('Ver ticket');
                                      verTicket = true;
                                    } else if (x.value == '2') {
                                      print('Imprimir');
                                      printTest();
                                    } else if (x.value == '3') {
                                      Provider.of<ModelProvider>(context,
                                              listen: false)
                                          .updateCarga(cargas![index],
                                              !cargas![index].enviado);
                                    } else {
                                      borrar = true;
                                    }
                                  }
                                },
                                isSearchVisible: false))
                            .showModal(context);
                      }),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
