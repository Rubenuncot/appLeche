import 'package:flutter/material.dart';
import 'package:transportes_leche/database/services/db_service.dart';

import '../database/models/models.dart';

class ModelProvider extends ChangeNotifier {
  static List<Carga> cargas = [];
  static List<Conductor> conductores = [];
  static List<Descarga> descargas = [];
  static List<Ganadero> ganaderos = [];
  static List<Industria> industrias = [];
  static List<Matricula> matriculas = [];
  static List<Producto> productos = [];

  static List? indust = [];

  Future<int> newReg(dynamic newReg) async {
    int resp = -1;
    final List<dynamic> all = await DBProvider.db.getAllReg(newReg);

    if (!all.contains(newReg)) {
      resp = await DBProvider.db.newReg(newReg);
      notifyListeners();
    }
    return resp;

  }

  Future<dynamic> getReg(int id, newReg) async {
    final reg = await DBProvider.db.getReg(id, newReg);

    switch (newReg.runtimeType.toString()) {
      case 'Carga':
        cargas.add(reg);
        break;
      case 'Conductor':
        conductores.add(reg);
        break;
      case 'Descarga':
        descargas.add(reg);
        break;
      case 'Ganadero':
        ganaderos.add(reg);
        break;
      case 'Industria':
        industrias.add(reg);
        break;
      case 'Matricula':
        matriculas.add(reg);
        break;
      case 'Producto':
        productos.add(reg);
        break;
    }
    return reg;
  }

  static Future<List<dynamic>?> getAllReg(dynamic obj) async {
    return await DBProvider.db.getAllReg(obj);
  }

  Future<void> setAllReg(dynamic obj) async {
    final res = await DBProvider.db.getAllReg(obj);

    switch (obj.runtimeType.toString()) {
      case 'Carga':
        for (var x in res) {
          cargas.add(x);
        }
        break;
      case 'Conductor':
        for (var x in res) {
          conductores.add(x);
        }
        break;
      case 'Descarga':
        for (var x in res) {
          descargas.add(x);
        }
        break;
      case 'Ganadero':
        for (var x in res) {
          ganaderos.add(x);
          indust?.add(x);
        }
        break;
      case 'Industria':
        for (var x in res) {
          industrias.add(x);
          indust?.add(x);
        }
        break;
      case 'Matricula':
        for (var x in res) {
          matriculas.add(x);
        }
        break;
      case 'Producto':
        for (var x in res) {
          productos.add(x);
        }
        break;
    }
    notifyListeners();
  }

  Future<int> deleteAll(dynamic newReg) async {
    return await DBProvider.db.deleteAll(newReg);
  }

  Future<int> deleteCarga(Carga reg) async {
    return await DBProvider.db.deleteCarga(reg);
  }

  Future<int> deleteDescarga(Descarga reg) async {
    return await DBProvider.db.deleteDescarga(reg);
  }

  Future<List<dynamic>> getRegName(String name, dynamic obj) async {
    return await DBProvider.db.getRegName(name, obj);
  }

  Future<List<dynamic>> getRegCod(String cod, dynamic obj) async {
    return await DBProvider.db.getRegCod(cod, obj);
  }

  Future<List<dynamic>> getCargaCist(String mat, dynamic obj) async {
    return await DBProvider.db.getCargaByCist(mat, obj);
  }

  Future<int> deleteDate() async {
    List? cargas = await getAllReg(Carga(
        cifConductor: 'cifConductor',
        nombreConductor: 'nombreConductor',
        matricula: 'matricula',
        cisterna: 'cisterna',
        fechaHora: 'fechaHora',
        codGanadero: 0,
        producto: 'producto',
        tanques: [],
        enviado: false));
    List? descargas = await getAllReg(Descarga(
        codIndustria: 0, kilos: 0.0, fechaHora: 'fechaHora', enviado: false));
    int res = 0;

    String now =
        '${DateTime.now().day}/${DateTime.now().month}/${DateTime.now().year}';

    List<String> nowSplitted = now.split('/');

    for (var x in cargas!) {
      if (x.enviado) {
        List? dateSplit = x.fechaHora.split('/');
        if (int.parse(nowSplitted[2]) >
            int.parse(dateSplit![2].split(' ')[0])) {
          res += await deleteCarga(x);
        } else if (int.parse(nowSplitted[2]) ==
            int.parse(dateSplit[2].split(' ')[0])) {
          if (int.parse(nowSplitted[1]) > int.parse(dateSplit[1])) {
            res += await deleteCarga(x);
          } else if (int.parse(nowSplitted[1]) == int.parse(dateSplit[1])) {
            if (int.parse(nowSplitted[0]) > int.parse(dateSplit[0])) {
              res += await deleteCarga(x);
            }
          }
        }
      }
    }

    for (var x in descargas!) {
      if (x.enviado) {
        List? dateSplit = x.fechaHora.split('/');
        if (int.parse(nowSplitted[2]) >
            int.parse(dateSplit![2].split(' ')[0])) {
          res += await deleteDescarga(x);
        } else if (int.parse(nowSplitted[2]) ==
            int.parse(dateSplit[2].split(' ')[0])) {
          if (int.parse(nowSplitted[1]) > int.parse(dateSplit[1])) {
            res += await deleteDescarga(x);
          } else if (int.parse(nowSplitted[1]) == int.parse(dateSplit[1])) {
            if (int.parse(nowSplitted[0]) > int.parse(dateSplit[0])) {
              res += await deleteDescarga(x);
            }
          }
        }
      }
    }

    return res;
  }

  Future<int> updateCarga(Carga carga, bool val) async{
    return await DBProvider.db.updateCarga(carga, val);
  }

  Future<int> updateDescarga(Descarga descarga, bool val) async{
    return await DBProvider.db.updateDescarga(descarga, val);
  }
}
