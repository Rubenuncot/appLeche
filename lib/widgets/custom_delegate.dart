import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:transportes_leche/providers/input_provider.dart';

import '../screens/screens.dart';
import '../theme/theme_main.dart';

class CustomSearchDelegate extends SearchDelegate {
  List<dynamic>? industrias = [];
  final String type;
  CustomSearchDelegate(this.industrias, this.type);

  Widget build(BuildContext context) {
    return const Placeholder();
  }

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
        icon: const Icon(Icons.clear),
        onPressed: () {
          query = '';
        },
      )
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
      icon: const Icon(Icons.arrow_back),
      onPressed: () {
        close(context, null);
      },
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    List? matchQuery = [];
    for (var x in industrias!) {
      if (x.nombre.toString().toLowerCase().contains(query.toLowerCase())) matchQuery.add(x);
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return  ListTile(
          title: Row(
            mainAxisSize: MainAxisSize.max,
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                    horizontal: 5, vertical: 3),
                width: MediaQuery.of(context).size.width * 0.3,
                decoration: BoxDecoration(
                  color: ThemeMain.buttonColor2,
                  borderRadius: BorderRadius.circular(5),
                ),
                child: index < (matchQuery.length)
                    ? Row(
                  mainAxisSize: MainAxisSize.max,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('${matchQuery[index].codigo ?? ''}'),
                  ],
                )
                    : const Text(''),
              ),
              SizedBox(
                  width: MediaQuery.of(context).size.width * 0.5,
                  child: Text(
                    '${matchQuery[index].nombre ?? ''}',
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ))
            ],
          ),
          onTap: () {
            type == 'Ganadero'
                ? Provider.of<InputProvider>(context, listen: false).valueGan = '${matchQuery[index].codigo}'
            : Provider.of<InputProvider>(context, listen: false).valueInd = '${matchQuery[index].codigo}';
            Navigator.pushReplacementNamed(context, type == 'Ganadero' ? LoadScreen.routeName : DownloadScreen.routeName);
          }
        );
      },
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List? matchQuery = [];
    for (var x in industrias!) {
      if (x.nombre.toString().toLowerCase().contains(query.toLowerCase())) matchQuery.add(x);
    }
    return ListView.builder(
      itemCount: matchQuery.length,
      itemBuilder: (context, index) {
        return  ListTile(
            title: Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 5, vertical: 3),
                  width: MediaQuery.of(context).size.width * 0.3,
                  decoration: BoxDecoration(
                    color: ThemeMain.buttonColor2,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: index < (matchQuery.length)
                      ? Row(
                    mainAxisSize: MainAxisSize.max,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('${matchQuery[index].codigo ?? ''}'),
                    ],
                  )
                      : const Text(''),
                ),
                SizedBox(
                    width: MediaQuery.of(context).size.width * 0.5,
                    child: Text(
                      '${matchQuery[index].nombre ?? ''}',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ))
              ],
            ),
            onTap: () {
              type == 'Ganadero'
                  ? Provider.of<InputProvider>(context, listen: false).valueGan = '${matchQuery[index].codigo}'
                  : Provider.of<InputProvider>(context, listen: false).valueInd = '${matchQuery[index].codigo}';
              Navigator.pushReplacementNamed(context, type == 'Ganadero' ? LoadScreen.routeName : DownloadScreen.routeName);
            }
        );
      },
    );
  }
}
