import 'dart:async';

import 'package:animated_radio_buttons/animated_radio_buttons.dart';
import 'package:drop_down_list/drop_down_list.dart';
import 'package:drop_down_list/model/selected_list_item.dart';
import 'package:flutter/material.dart';
import 'package:material_dialogs/dialogs.dart';
import 'package:material_dialogs/widgets/buttons/icon_button.dart';
import 'package:material_dialogs/widgets/buttons/icon_outline_button.dart';
import 'package:provider/provider.dart';
import 'package:smart_snackbars/smart_snackbars.dart';
import 'package:transportes_leche/database/models/descarga_model.dart';

import '../providers/model_provider.dart';
import '../theme/theme_main.dart';

class DownloadListScreen extends StatefulWidget {
  static String routeName = '_downloadList';
  const DownloadListScreen({Key? key}) : super(key: key);

  @override
  State<DownloadListScreen> createState() => _DownloadListScreenState();
}

class _DownloadListScreenState extends State<DownloadListScreen> {
  List? descargas = [];

  Descarga descarga = Descarga(codIndustria: 0, kilos: 0, fechaHora: 'fechaHora', enviado: false);

  bool borrar = false;
  bool aceptado = false;
  bool borrado = false;

  void getList() async {

    descargas = await ModelProvider.getAllReg(Descarga(codIndustria: 0, kilos: 0.0, fechaHora: 'fechaHora', enviado: false));

    setState(() {

    });
  }

  void borrarDescarga() async{
    await Provider.of<ModelProvider>(context, listen: false).deleteDescarga(descarga);
    borrado = true;
  }

  void showBorrar() {
    Dialogs.bottomMaterialDialog(
        msg: 'Estás seguro de borrar la Descarga? No se puede deshacer esta acción.',
        title: 'Borrar Descarga',
        context: context,
        actions: [
          IconsOutlineButton(
            onPressed: () {
              Navigator.pop(context);
            },
            text: 'Cancelar',
            iconData: Icons.cancel_outlined,
            textStyle: const TextStyle(color: Colors.grey),
            iconColor: Colors.grey,
          ),
          IconsButton(
            onPressed: () {
              borrarDescarga();
              Navigator.pop(context);
            },
            text: 'Borrar',
            iconData: Icons.delete,
            color: Colors.red,
            textStyle: const TextStyle(color: Colors.white),
            iconColor: Colors.white,
          ),
        ]);
    borrar = false;
  }

  @override
  Widget build(BuildContext context) {
    getList();


    Timer.periodic(const Duration(seconds: 1), (timer) {
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
        title: const Text('Descargas'),
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
          const SizedBox(height: 20,),
          Container(
            constraints: BoxConstraints(maxWidth: MediaQuery.of(context).size.width, maxHeight: MediaQuery.of(context).size.height * 0.76),
            child: ListView.builder(
              itemCount: descargas?.length,
              itemBuilder: (context, index) {
                return Container(
                  margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                  decoration: const BoxDecoration(
                      color: Colors.black12,
                      borderRadius: BorderRadius.all(Radius.circular(5))),
                  child: ListTile(
                      title: Column(
                        children: [
                          Row(
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
                                child: index < (descargas?.length ?? 1)
                                    ? Row(
                                  mainAxisSize: MainAxisSize.max,
                                  crossAxisAlignment: CrossAxisAlignment.center,
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text('${descargas![index].codIndustria ?? ''}'),
                                  ],
                                )
                                    : const Text(''),
                              ),
                              SizedBox(
                                  width: MediaQuery.of(context).size.width * 0.3,
                                  child: Text(
                                    '${descargas![index].fechaHora ?? ''}',
                                    maxLines: 1,
                                    overflow: TextOverflow.ellipsis,
                                  )),
                              AnimatedRadioButtons(
                                  items: [
                                    AnimatedRadioButtonItem(color: ThemeMain.buttonColor, label: '')
                                  ],
                                  animationCurve: const ElasticInCurve(),
                                  backgroundColor: Colors.black12,
                                  onChanged: (value) {
                                    Provider.of<ModelProvider>(context, listen: false).updateDescarga(descargas![index], !descargas![index].enviado);
                                    setState(() {

                                    });
                                  },
                                  value: descargas![index].enviado == false ? 1: 0)
                            ],
                          ),
                          const Divider(),
                          Center(child: Text('Kilos: ${descargas![index].kilos}'))
                        ],
                      ),
                      onTap: () {

                        descarga = descargas![index];

                        DropDownState(DropDown(
                            data: [
                              SelectedListItem(name: 'Borrar', value: '1'),
                              SelectedListItem(
                                  name: descargas![index].enviado == false
                                      ? 'Marcar como enviado'
                                      : 'Desmarcar como enviado',
                                  value: '3'),
                            ],
                            selectedItems: (selectedItems) {
                              for (var x in selectedItems) {
                                if (x.value == '1') {
                                  borrar = true;
                                } else {
                                  Provider.of<ModelProvider>(context,
                                      listen: false)
                                      .updateDescarga(descargas![index],
                                      !descargas![index].enviado);
                                }
                              }
                            },
                            isSearchVisible: false))
                            .showModal(context);
                        setState(() {

                        });
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
