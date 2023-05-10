import 'dart:async';

import 'package:animated_toggle_switch/animated_toggle_switch.dart';
import 'package:esc_pos_utils_plus/esc_pos_utils.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_advanced_drawer/flutter_advanced_drawer.dart';
import 'package:print_bluetooth_thermal/print_bluetooth_thermal.dart';
import 'package:provider/provider.dart';
import 'package:smart_snackbars/smart_snackbars.dart';
import 'package:transportes_leche/database/models/models.dart';
import 'package:transportes_leche/providers/input_provider.dart';
import 'package:transportes_leche/providers/model_provider.dart';
import 'package:transportes_leche/providers/theme_provider.dart';
import 'package:transportes_leche/screens/main_screen.dart';
import 'package:transportes_leche/screens/screens.dart';
import 'package:transportes_leche/shared_preferences/preferences.dart';
import 'package:transportes_leche/theme/theme_main.dart';
import 'package:transportes_leche/ui/input_decorations.dart';
import 'package:transportes_leche/widgets/widgets.dart';

class LoadScreen extends StatefulWidget {
  static String routeName = '_load';

  const LoadScreen({Key? key}) : super(key: key);

  @override
  State<LoadScreen> createState() => _LoadScreenState();
}

class _LoadScreenState extends State<LoadScreen> with WidgetsBindingObserver {

  final _advancedDrawerController = AdvancedDrawerController();

  String fecha = '';
  bool change = true;
  bool insert = false;
  bool notInsert = false;

  String codigoGanadero = '';


  /* Variables impresión */
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

  final FocusNode _focusNodeCode = FocusNode();

  final TextEditingController _controller = TextEditingController();

  /* ----- Variables ----- */
  int itemCount = 0;

  int maxItemCount = 0;
  String valueGan = '';

  bool argsBool = true;
  bool litrosChange = false;
  bool tempChange = false;

  /* Número de ganaderos */
  Map<String, String> ganaderos = {};

  Map<String, String> ganaderosTemp = {};

  List<FocusNode> focusNodesLitros = [];
  List<FocusNode> focusNodesTemp = [];

  List<String> productos = [];

  List<Tanque> tanques = [];
  String productoSelected = '';

  /* Lista de ganaderos */
  List<String> ganaderosCode = [];

  List<bool> muestras = [true, true, true, true];

  /* Código de ganadero */
  String ganaderoCode = '';
  String ganaderoNombre = '';
  String ganaderoDni = '';

  bool muestra = true;

  Matricula matricula =
      Matricula(matricula: 'matricula', codCisterna: 'codCisterna');

  Conductor conductor = Conductor(cif: 'cif', nombre: 'nombre');

  /* Imprimir */
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
    if (mac != '') {
      getBluetoots();
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
    List<String> valuesLitros = [];
    List<String> valuesTemps = [];

    for (var x in inputProvider.valueLitList) {
      if (x != '') {
        valuesLitros.add(x);
      }
    }
    for (var x in inputProvider.valueTempList) {
      if (x != '') {
        valuesTemps.add(x);
      }
    }

    double litrosTotal = 0;
    List<int> bytes = [];
    // Using default profile
    final profile = await CapabilityProfile.load();
    final generator = Generator(PaperSize.mm58, profile);
    //bytes += generator.setGlobalFont(PosFontType.fontB);
    bytes += generator.reset();

    bytes += generator.text('--- COMPRADOR --- ',
        styles:
            const PosStyles(align: PosAlign.center, width: PosTextSize.size2, height: PosTextSize.size2));
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
    bytes += generator.text('CISTERNA: ${matricula.codCisterna}',
        styles: const PosStyles(
          align: PosAlign.center,
        ));
    bytes += generator.emptyLines(2);

    bytes += generator.text(' --- Fecha ---',
        styles:
            const PosStyles(align: PosAlign.center, width: PosTextSize.size2, height: PosTextSize.size2));

    bytes +=
        generator.text(fecha, styles: const PosStyles(align: PosAlign.center));
    // bytes += generator.text('Align right',
    //     styles: PosStyles(align: PosAlign.right), linesAfter: 1);
    bytes += generator.emptyLines(2);
    bytes += generator.text('--- GANADERO ---',
        styles: const PosStyles(
            bold: true, align: PosAlign.center, width: PosTextSize.size2,  height: PosTextSize.size2));
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
            align: PosAlign.center, underline: true, width: PosTextSize.size2, height: PosTextSize.size2),
      ),
      PosColumn(
        text: 'LITROS',
        width: 3,
        styles: const PosStyles(
            align: PosAlign.center, underline: true, width: PosTextSize.size2, height: PosTextSize.size2),
      ),
      PosColumn(
        text: 'MUESTRAS',
        width: 3,
        styles: const PosStyles(
            align: PosAlign.center, underline: true, width: PosTextSize.size2, height: PosTextSize.size2),
      ),
      PosColumn(
        text: 'TEMP',
        width: 3,
        styles: const PosStyles(
            align: PosAlign.center, underline: true, width: PosTextSize.size2, height: PosTextSize.size2),
      ),
    ]);
    bytes += generator.emptyLines(1);
    List<PosColumn> listTanquesColum = [];
    for (var x = 0; x < 4; x++) {
      if (x < valuesLitros.length) {
        listTanquesColum = [];
        litrosTotal = litrosTotal +
            (valuesLitros[x] == '' ? 0 : double.parse(valuesLitros[x]));
        listTanquesColum.add(
          PosColumn(
            text: tanques[x].codigo,
            width: 3,
            styles: const PosStyles(
                align: PosAlign.center,),
          ),
        );
        listTanquesColum.add(
          PosColumn(
            text:
                '${(valuesLitros[x] == '' ? 0 : double.parse(valuesLitros[x]))} L',
            width: 3,
            styles: const PosStyles(
                align: PosAlign.center,),
          ),
        );
        listTanquesColum.add(
          PosColumn(
            text: muestras[x] ? 'S' : 'N',
            width: 3,
            styles: const PosStyles(
                align: PosAlign.center),
          ),
        );
        listTanquesColum.add(
          PosColumn(
            text:
                '${double.parse(valuesTemps[x] == '' ? '0' : valuesTemps[x])}',
            width: 3,
            styles: const PosStyles(
                align: PosAlign.center,),
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
    if(change){
      createCarga(context);
    }

    bool conexionStatus = await PrintBluetoothThermal.connectionStatus;
    if (conexionStatus) {
      List<int> ticket = await testTicket();
      final result = await PrintBluetoothThermal.writeBytes(ticket);
      print("impresion $result");
    } else {
      dialogConnect();
    }
    change = false;
  }

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

  bool valid = false;
  dynamic obj = Ganadero(codigo: 0, nombre: 'nombre', nif: 'nif', tanques: []);

  bool button = false; // Para activar el boton de buscar ganadero.
  List<dynamic>? listGan = [];

  dynamic args;
  bool waiting = true;
  int value = 1;

  /* Métodos */
  int getTanques() {
    String nombre = Provider.of<InputProvider>(context, listen: false).valueGan;
    tanques = [];
    for (var g in listGan!) {
      if ('${g.codigo}' == nombre) {
        for (var x in g.tanques) {
          if (x.codigo != '*') {
            tanques.add(x);
          }
        }
      }
    }
    return tanques.length;
  }

  String getNombre() {
    String nombre = Provider.of<InputProvider>(context, listen: false).valueGan;
    ganaderoNombre = '';
    ganaderoDni = '';

    for (var x in listGan!) {
      if ('${x.codigo}' == nombre) {
        ganaderoNombre = x.nombre;
        ganaderoDni = x.nif;
      }
    }

    return ganaderoNombre;
  }

  void rellenarListas() async {
    setState(() {
      codigoGanadero = Provider.of<InputProvider>(context, listen: false).valueGan;
    });
    listGan = await ModelProvider.getAllReg(
        Ganadero(codigo: 0, nombre: 'nombre', nif: 'nif', tanques: []));
    for (var g in listGan!) {
      if ('${g.codigo}' == codigoGanadero) {
        for (var x in g.tanques) {
          if (x.codigo != '*') {
            tanques.add(x);
          }
        }
      }
      ganaderos.addAll({'${g.codigo}': g.nombre});
    }

    switch (tanques.length) {
      case 1:
        createFocus(1);
        break;
      case 2:
        createFocus(2);
        break;
      case 3:
        createFocus(3);
        break;
      case 4:
        createFocus(4);
        break;
    }

    ganaderosTemp = ganaderos;
    Iterable<String> listGanaderos = ganaderos.keys;

    for (var gan in listGanaderos) {
      if (gan == codigoGanadero) ganaderoNombre = ganaderos[gan]!;
      ganaderosCode.add(gan);
    }

    List<dynamic>? listProd =
        await ModelProvider.getAllReg(Producto(descripcion: 'descripcion'));

    if(productos.isEmpty){
      for (var g in listProd!) {
        productos.add(g.descripcion);
      }
    }

    productoSelected = productos.first;

    setState(() {});
  }

  void createFocus(int num) {
    for (var x = 0; x < num; x++) {
      focusNodesLitros.add(FocusNode());
      focusNodesTemp.add(FocusNode());
    }
  }

  void printTicket() {
    print('Imprimendo ticket');
  }

  void createCarga(BuildContext contextC) async {
    fecha =
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute}';
    ModelProvider modelProvider =
        Provider.of<ModelProvider>(contextC, listen: false);
    List<dynamic> conductores =
        await modelProvider.getRegName(Preferences.conductor ?? '', conductor);
    conductor = conductores[0];

    List<dynamic> matriculas =
        await modelProvider.getRegName(Preferences.matricula ?? '', matricula);
    matricula = matriculas[0];

    List<Tanque> tanquesCarga = [];

    List<String> valuesLitros = [];
    List<String> valuesTemps = [];

    carga.matricula = Preferences.matricula ?? '';
    carga.nombreConductor = Preferences.conductor ?? '';
    carga.cifConductor = conductor.cif;
    carga.producto = productoSelected;
    carga.codGanadero = int.parse(Provider.of<InputProvider>(contextC, listen: false).valueGan);
    carga.fechaHora =
        '${DateTime.now().day < 10 ? '0${DateTime.now().day}' : DateTime.now().day}/${DateTime.now().month < 10 ? '0${DateTime.now().month}': DateTime.now().month}/${DateTime.now().year} ${DateTime.now().hour}:${DateTime.now().minute < 10 ? '0${DateTime.now().minute}' : DateTime.now().minute}';
    carga.cisterna = matricula.codCisterna;
    carga.enviado = false;

    for (var x in Provider.of<InputProvider>(contextC, listen: false).valueLitList) {
      if (x != '') {
        valuesLitros.add(x);
      }
    }
    for (var x in Provider.of<InputProvider>(contextC, listen: false).valueTempList) {
      if (x != '') {
        valuesTemps.add(x);
      }
    }
    for (var x = 0; x < 4; x++) {
      if (x >= valuesLitros.length) {
        Tanque tanque =
            Tanque(codigo: '', litros: 0.0, muestra: false, temp: 0.0);
        tanquesCarga.add(tanque);
      } else {
        Tanque tanque = Tanque(
            codigo: tanques[x].codigo,
            litros: double.parse(valuesLitros[x] == '' ? '0' : valuesLitros[x]),
            muestra: valuesLitros[x] == '' ? false : muestras[x],
            temp: double.parse(valuesTemps[x]));
        tanquesCarga.add(tanque);
      }
    }
    carga.tanques = tanquesCarga;
    print(
        '${carga.matricula}-${carga.nombreConductor}-${carga.cisterna}-${carga.codGanadero}-${carga.cifConductor}-${carga.fechaHora}-${carga.enviado}-${carga.producto}');

    if(await modelProvider.newReg(carga) > 0){
      insert = true;
    } else {
      notInsert = true;
    }
  }

  /* Metodos override */
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    if(productos.isEmpty) rellenarListas();
  }

  @override
  void dispose() {
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    args = ModalRoute.of(context)?.settings.arguments;

    Timer.periodic(const Duration(seconds: 1), (timer) {
      if(insert){
        SmartSnackBars.showTemplatedSnackbar(
            context: context,
            backgroundColor: ThemeMain.buttonColor,
            animationCurve: const ElasticInCurve(),
            subTitle: 'Carga creada correctamente');
        insert = false;
        Provider.of<InputProvider>(context, listen: false)
            .valueLitList = [];
        Provider.of<InputProvider>(context, listen: false)
            .valueTempList = [];
        Provider.of<InputProvider>(context, listen: false).valueGan = '';
        setState(() {

        });
      }

      if(notInsert){
        SmartSnackBars.showTemplatedSnackbar(
            context: context,
            backgroundColor: Colors.redAccent,
            animationCurve: const ElasticInCurve(),
            subTitle: 'La carga no se pudo crear');
        notInsert = false;
        Provider.of<InputProvider>(context, listen: false)
            .valueLitList = [];
        Provider.of<InputProvider>(context, listen: false)
            .valueTempList = [];
        Provider.of<InputProvider>(context, listen: false).valueGan = '';
        setState(() {

        });
      }
    });

    return GestureDetector(
      onTap: () {
        _focusNodeCode.unfocus();
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
          floatingActionButtonLocation: FloatingActionButtonLocation.centerFloat,
          /* Botones flotantes */
          floatingActionButton: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 20),
            child: SizedBox(
              width: double.infinity,
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  MaterialButton(
                    height: 50,
                    onPressed: () {
                      Provider.of<InputProvider>(context, listen: false)
                          .valueGan = '';
                      Provider.of<InputProvider>(context, listen: false)
                          .valueLitList = [];
                      Provider.of<InputProvider>(context, listen: false)
                          .valueTempList = [];

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
                    onPressed: litrosChange && tempChange ? () async {
                      await printTest();
                      litrosChange = false;
                      tempChange = false;
                    } : null,
                    color: ThemeMain.buttonColor,
                      disabledColor: Provider.of<ThemeProvider>(context).currentThemeName == 'light' ? Colors.black12 : Colors.white30,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(100)),
                    elevation: 0,
                    child: Row(
                      children: [
                        Icon(
                          Icons.save_alt,
                          color: change ? ThemeMain.backgroundColorLight : Colors.black12,
                        ),
                        const Text('|', style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold, fontSize: 20),),
                        const Icon(
                          Icons.print,
                          color: ThemeMain.backgroundColorLight,
                        ),
                      ],
                    )
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
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text('Nombre: ${getNombre()}'),
                  const SizedBox(
                    height: 20,
                  ),
                  DropdownButtonFormField<String>(
                    isExpanded: true,
                    focusColor: const Color.fromARGB(255, 111, 111, 252),
                    decoration: InputDecorations.authImputDecoration(
                      context: context,
                        hintText: '', labelText: 'Productos'),
                    value: productoSelected,
                    elevation: 16,
                    style: const TextStyle(
                      color: Color.fromARGB(255, 111, 111, 252),
                    ),
                    onChanged: (String? value) {
                      change = true;
                      setState(() {
                        productoSelected = value!;
                      });
                    },
                    items:
                        productos.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  const SizedBox(
                    height: 10,
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: TextFormField(
                          focusNode: _focusNodeCode,
                          onChanged: (value) {
                            change = true;
                            Provider.of<InputProvider>(context, listen: false)
                                .valueGan = value;
                            rellenarListas();
                          },
                          keyboardType: TextInputType.number,
                          initialValue: Provider.of<InputProvider>(context).valueGan,
                          decoration: InputDecorations.authImputDecoration(
                            context: context,
                              hintText: '', labelText: 'Código'),
                        ),
                      ),
                      const SizedBox(
                        width: 50,
                      ),
                      ElevatedButton(
                        onPressed: () {
                          Navigator.pushReplacementNamed(context, SearchScreen.routeName, arguments: [Ganadero(codigo: 0, nombre: 'nombre', nif: 'nif', tanques: [])]);
                        },
                        style: const ButtonStyle(
                            shape: MaterialStatePropertyAll(
                                RoundedRectangleBorder(
                                    borderRadius: BorderRadius.only(
                                        topLeft: Radius.circular(20),
                                        bottomRight: Radius.circular(20)))),
                            backgroundColor:
                                MaterialStatePropertyAll(ThemeMain.buttonColor2),
                            side: MaterialStatePropertyAll(
                                BorderSide(color: Colors.black12))),
                        child: Row(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: const [Icon(Icons.search), Text('Buscar')],
                        ),
                      )
                    ],
                  ),
                  Container(
                    constraints: BoxConstraints(
                        maxWidth: MediaQuery.of(context).size.width * 0.9,
                        maxHeight: MediaQuery.of(context).size.height * 0.6),
                    /* Tamaño de pantalla */
                    child: ListView.builder(
                      itemCount: getTanques(),
                      itemBuilder: (context, index) => Container(
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
                            color: Provider.of<ThemeProvider>(context).currentThemeName == 'light' ? const Color.fromARGB(1, 56, 56, 56) : Colors.white30),
                        margin: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 20),
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
                                  child: Text(
                                    'Tanque: ${tanques.isNotEmpty ? tanques[index].codigo : ''}',
                                    style: const TextStyle(color: Colors.white),
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
                                      change = true;
                                      InputProvider inputProvider =
                                          Provider.of<InputProvider>(context,
                                              listen: false);

                                      inputProvider.valueLit = value;
                                    },
                                    focusNode: focusNodesLitros.isEmpty
                                        ? FocusNode()
                                        : focusNodesLitros[index],
                                    onEditingComplete: () {
                                      InputProvider inputProvider =
                                          Provider.of<InputProvider>(context,
                                              listen: false);

                                      inputProvider
                                          .setValueLit(inputProvider.valueLit);
                                      FocusScope.of(context)
                                          .requestFocus(focusNodesTemp[index]);
                                      litrosChange = true;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration:
                                        InputDecorations.authImputDecoration(
                                          context: context,
                                            hintText: '', labelText: 'Litros'),
                                  )),
                                  const SizedBox(
                                    width: 70,
                                  ),
                                  const Text('Litros')
                                ],
                              ),
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
                                      change = true;
                                      InputProvider inputProvider =
                                          Provider.of<InputProvider>(context,
                                              listen: false);

                                      inputProvider.valueTemp = value;
                                    },
                                    focusNode: focusNodesTemp.isEmpty
                                        ? FocusNode()
                                        : focusNodesTemp[index],
                                    onEditingComplete: () {
                                      InputProvider inputProvider =
                                          Provider.of<InputProvider>(context,
                                              listen: false);

                                      if(inputProvider.valueTempList.isEmpty){
                                        inputProvider
                                            .setValueTemp('0');
                                      } else {
                                        inputProvider
                                            .setValueTemp(inputProvider.valueTemp == '' ? '0' : inputProvider.valueTemp);
                                      }
                                      focusNodesTemp[index].unfocus();
                                      tempChange = true;
                                    },
                                    keyboardType: TextInputType.number,
                                    decoration:
                                        InputDecorations.authImputDecoration(
                                          context: context,
                                            hintText: '', labelText: 'Temp'),
                                  )),
                                  const SizedBox(
                                    width: 70,
                                  ),
                                  const Text('Temp')
                                ],
                              ),
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
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width * 0.8),
                              child: Row(
                                mainAxisSize: MainAxisSize.max,
                                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                children: [
                                  AnimatedToggleSwitch.dual(
                                    borderColor: Colors.black26,
                                    colorBuilder: (value) {
                                      if (value == 0) {
                                        return Colors.redAccent;
                                      } else {
                                        return ThemeMain.buttonColor2;
                                      }
                                    },
                                    iconBuilder: (value) {
                                      if (value == 0) {
                                        return const Icon(Icons.close);
                                      } else {
                                        return const Icon(Icons.add);
                                      }
                                    },
                                    textBuilder: (value) {
                                      if (value == 0) {
                                        return const Text(
                                          'No',
                                          style: TextStyle(
                                              fontWeight: FontWeight.bold),
                                        );
                                      } else {
                                        return const Text('Si',
                                            style: TextStyle(
                                                fontWeight: FontWeight.bold));
                                      }
                                    },
                                    current: muestras[index] == false ? 0 : 1 ,
                                    onChanged: (p0) {
                                      change = true;
                                      value = p0;
                                      muestras.removeAt(index);
                                      muestras.insert(index, value == 0 ? false : true);
                                      setState(() {});
                                    },
                                    first: 1,
                                    second: 0,
                                  ),
                                  const Text(
                                    'Muestra',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    height: 100,
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
