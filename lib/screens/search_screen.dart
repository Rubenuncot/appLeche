import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transportes_leche/providers/input_provider.dart';
import 'package:transportes_leche/providers/model_provider.dart';
import 'package:transportes_leche/screens/load_screen.dart';

import '../theme/theme_main.dart';
import '../widgets/widgets.dart';
import 'download_screen.dart';

class SearchScreen extends StatelessWidget {
  static String routeName = '_search';
  static List? industria = [];
  static String type = '';
  static dynamic args = [];

  const SearchScreen({Key? key}) : super(key: key);

  void getList(dynamic obj, BuildContext context) async {
    List ind =  [];
    for( var x in industria!){
      ind.add(x);
    }
    if(ind.isEmpty){
      ModelProvider.indust = [];
      await Provider.of<ModelProvider>(context).setAllReg(obj);
      industria = ModelProvider.indust;
    } else if('${industria![0].runtimeType}' != getType(obj)){
      ModelProvider.indust = [];
      await Provider.of<ModelProvider>(context).setAllReg(obj);
      industria = ModelProvider.indust;
    }
  }

  String getType(dynamic obj) {
    type = '${obj.runtimeType}';
    return type;
  }

  @override
  Widget build(BuildContext context) {
    args = [];
    args = ModalRoute.of(context)?.settings.arguments;
    getList(args[0], context);
    getType(args[0]);
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Búsqueda'),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.pushReplacementNamed(context, type == 'Ganadero' ? LoadScreen.routeName : DownloadScreen.routeName);
            },
          ),
          actions: [
            IconButton(
              icon: const Icon(Icons.search),
              onPressed: () async {
                showSearch(
                    context: context,
                    delegate: CustomSearchDelegate(industria, type));
              },
            )
          ],
        ),
        body: ListView.builder(
          itemCount: industria?.length,
          itemBuilder: (context, index) {
            return Container(
              margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
              decoration: const BoxDecoration(color: Colors.black12, borderRadius: BorderRadius.all(Radius.circular(5))),
              child: ListTile(
                title: Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Container(
                      padding:
                          const EdgeInsets.symmetric(horizontal: 5, vertical: 3),
                      width: MediaQuery.of(context).size.width * 0.2,
                      decoration: BoxDecoration(
                        color: ThemeMain.buttonColor2,
                        borderRadius: BorderRadius.circular(5),
                      ),
                      child: index < (industria?.length ?? 1)
                          ? Row(
                              mainAxisSize: MainAxisSize.max,
                              crossAxisAlignment: CrossAxisAlignment.center,
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text('${industria![index].codigo ?? ''}'),
                              ],
                            )
                          : const Text(''),
                    ),
                    SizedBox(
                        width: MediaQuery.of(context).size.width * 0.5,
                        child: Text(
                          '${industria![index].nombre ?? ''}',
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ))
                  ],
                ),
                onTap: () {
                  type == 'Ganadero'
                      ? Provider.of<InputProvider>(context, listen: false).valueGan = '${industria![index].codigo}' : Provider.of<InputProvider>(context, listen: false).valueInd = '${industria![index].codigo}';
                  Navigator.pushReplacementNamed(context, type == 'Ganadero' ? LoadScreen.routeName : DownloadScreen.routeName);
                }
              ),
            );
          },
        ),
      ),
    );
  }
}
