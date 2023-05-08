import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:path_provider/path_provider.dart';
import 'package:provider/provider.dart';
import 'package:transportes_leche/database/models/models.dart';
import 'package:transportes_leche/providers/fpt_provider.dart';
import 'package:transportes_leche/providers/model_provider.dart';
import 'package:transportes_leche/shared_preferences/preferences.dart';

import '../database/models/ganadero_model.dart';

class DownloadFile {
  static Future<void> download(BuildContext context) async {
    FtpService ftpService = Provider.of<FtpService>(context, listen: false);
    await _getFileFtp(context, ftpService);
  }

  static Future<void> _getFileFtp(
      BuildContext context, FtpService ftpService) async {
    ModelProvider modelProvider =
        Provider.of<ModelProvider>(context, listen: false);
    Directory? directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    }

    await ftpService.downloadFileFromFTP(
        'ganaderos.txt', "${directory?.path}/ganaderos.txt");
    await ftpService.downloadFileFromFTP(
        'industrias.txt', "${directory?.path}/industrias.txt");
    await ftpService.downloadFileFromFTP(
        'productos.txt', "${directory?.path}/productos.txt");
    await ftpService.downloadFileFromFTP(
        'conductores.txt', "${directory?.path}/conductores.txt");
    await ftpService.downloadFileFromFTP(
        'matriculas.txt', "${directory?.path}/matriculas.txt");

    await _getFileStorage(modelProvider);

    File file = await _setCarga(modelProvider, directory!);
    List<String> lineas = await file.readAsLines();
    if (lineas.isNotEmpty) {
      await ftpService.uploadFileFtp(file);
    } else {
      print('No se ha subido');
    }

    file = await _setDescarga(modelProvider, directory);
    lineas = await file.readAsLines();

    if (lineas.isNotEmpty) {
      await ftpService.uploadFileFtp(file);
    }
  }

  static Future<void> _getFileStorage(ModelProvider modelProvider) async {
    Directory? directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    }

    List<Ganadero>? ganaderos = await _getGanadero(modelProvider, directory!);
    _insertReg(ganaderos, modelProvider);

    List<Industria>? industrias = await _getIndustria(modelProvider, directory);
    _insertReg(industrias, modelProvider);

    List<Matricula>? matriculas = await _getMatricula(modelProvider, directory);
    _insertReg(matriculas, modelProvider);

    List<Conductor>? conductores =
        await _getConductor(modelProvider, directory);
    _insertReg(conductores, modelProvider);

    List<Producto>? productos = await _getProducto(modelProvider, directory);
    _insertReg(productos, modelProvider);
  }

  static Future<void> _setFile(
      BuildContext context, FtpService ftpService) async {
    ModelProvider modelProvider = Provider.of<ModelProvider>(context);
    Directory? directory;
    if (Platform.isIOS) {
      directory = await getApplicationDocumentsDirectory();
    } else if (Platform.isAndroid) {
      directory = await getExternalStorageDirectory();
    }
  }

  static void _insertReg(List<dynamic>? list, ModelProvider modelProvider) {
    for (var obj in list!) {
      modelProvider.newReg(obj);
    }
  }
}

/* Lectura de todos los ficheros linea a linea */
Future<List<Ganadero>?> _getGanadero(
    ModelProvider modelProvider, Directory directory) async {
  Ganadero ganadero =
      Ganadero(codigo: 0, nombre: 'nombre', nif: 'nif', tanques: []);
  File file = File('${directory.path}/ganaderos.txt');
  await modelProvider.deleteAll(ganadero);

  List<String> lines = await file.readAsLines(encoding: const Latin1Codec());
  List<Ganadero> ganaderos = [];

  String line;

  for (var x in lines) {
    line = x;
    List<String> linesSplit = line.split('#');
    List<Tanque> tanques = [];

    for (var x = 3; x <= 6; x++) {
      tanques.add(Tanque(codigo: linesSplit[x]));
    }

    Ganadero gan = Ganadero(
        codigo: int.parse(linesSplit[0]),
        nombre: linesSplit[1],
        nif: linesSplit[2],
        tanques: tanques);

    ganaderos.add(gan);
  }
  return ganaderos;
}

Future<List<Industria>?> _getIndustria(
    ModelProvider modelProvider, Directory directory) async {
  Industria industria = Industria(codigo: 0, nombre: 'nombre');
  File file = File('${directory.path}/industrias.txt');
  await modelProvider.deleteAll(industria);

  List<String> lines = await file.readAsLines(encoding: const Latin1Codec());
  List<Industria> industrias = [];

  String line;

  for (var x in lines) {
    line = x;
    List<String> linesSplit = line.split('#');

    Industria ind =
        Industria(codigo: int.parse(linesSplit[0]), nombre: linesSplit[1]);

    industrias.add(ind);
  }
  return industrias;
}

Future<List<Matricula>?> _getMatricula(
    ModelProvider modelProvider, Directory directory) async {
  Matricula matricula =
      Matricula(matricula: 'matricula', codCisterna: 'codCisterna');
  File file = File('${directory.path}/matriculas.txt');
  await modelProvider.deleteAll(matricula);

  List<String> lines = await file.readAsLines(encoding: const Latin1Codec());
  List<Matricula> matriculas = [];

  String line;

  for (var x in lines) {
    line = x;
    List<String> linesSplit = line.split('#');

    Matricula mat =
        Matricula(matricula: linesSplit[0], codCisterna: linesSplit[1]);

    matriculas.add(mat);
  }
  return matriculas;
}

Future<List<Producto>?> _getProducto(
    ModelProvider modelProvider, Directory directory) async {
  Producto producto = Producto(descripcion: 'descripcion');
  File file = File('${directory.path}/productos.txt');
  await modelProvider.deleteAll(producto);

  List<String> lines = await file.readAsLines(encoding: const Latin1Codec());
  List<Producto> productos = [];

  String line;

  for (var x in lines) {
    line = x;
    List<String> linesSplit = line.split('#');

    Producto prod = Producto(descripcion: linesSplit[0]);

    productos.add(prod);
  }

  return productos;
}

Future<List<Conductor>?> _getConductor(
    ModelProvider modelProvider, Directory directory) async {
  Conductor conductor = Conductor(cif: 'cif', nombre: 'nombre');
  File file = File('${directory.path}/conductores.txt');
  await modelProvider.deleteAll(conductor);

  List<String> lines = await file.readAsLines(encoding: const Latin1Codec());
  List<Conductor> conductores = [];

  String line;

  for (var x in lines) {
    line = x;
    List<String> linesSplit = line.split('#');

    Conductor cond = Conductor(cif: linesSplit[0], nombre: linesSplit[1]);

    conductores.add(cond);
  }
  return conductores;
}

Future<File> _setCarga(ModelProvider modelProvider, Directory directory) async {
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

  List<dynamic>? cargas = await ModelProvider.getAllReg(carga);

  /* Escribir el fichero*/
  File file = File(
      '${directory.path}/cargas-${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.txt');
  IOSink sink = file.openWrite(mode: FileMode.append);

  if (cargas != null) {
    for (var x in cargas) {
      if (!x.enviado) {
        Map<String, dynamic> cargaJson = x.toJson();

        sink.writeln('${cargaJson["CifConductor"]}'
            '\t${cargaJson["NombreConductor"]}'
            '\t${cargaJson["Matricula"]}'
            '\t${cargaJson["Cisterna"]}'
            '\t${cargaJson["FechaHora"]}'
            '\t${cargaJson["CodGanadero"]}'
            '\t${cargaJson["Producto"]}'
            '\t${cargaJson["Tanque1"]}'
            '\t${cargaJson["Litros1"].toString().replaceAll('.', ',')}'
            '\t${cargaJson["Muestra1"]}'
            '\t${cargaJson["Temp1"].toString().replaceAll('.', ',')}'
            '\t${cargaJson["Tanque2"]}'
            '\t${cargaJson["Litros2"] == 0 ? '' : cargaJson["Litros2"].toString().replaceAll('.', ',')}'
            '\t${cargaJson["Litros2"] == 0 ? '' : cargaJson["Muestra2"]}'
            '\t${cargaJson["Temp2"].toString().replaceAll('.', ',')}'
            '\t${cargaJson["Tanque3"]}'
            '\t${cargaJson["Litros3"] == 0 ? '' : cargaJson["Litros3"].toString().replaceAll('.', ',')}'
            '\t${cargaJson["Litros3"] == 0 ? '' : cargaJson["Muestra3"]}'
            '\t${cargaJson["Temp3"].toString().replaceAll('.', ',')}'
            '\t${cargaJson["Tanque4"]}'
            '\t${cargaJson["Litros4"] == 0 ? '' : cargaJson["Litros4"].toString().replaceAll('.', ',')}'
            '\t${cargaJson["Litros4"] == 0 ? '' : cargaJson["Muestra4"]}'
            '\t${cargaJson["Temp4"].toString().replaceAll('.', ',')}');

        await modelProvider.updateCarga(Carga.fromJson(cargaJson), true);
      }
    }
  }

  return file;
}

Future<File> _setDescarga(
    ModelProvider modelProvider, Directory directory) async {
  File file = File('Empty');
  if (Preferences.matricula != '') {
    Descarga descarga = Descarga(
        codIndustria: 0, kilos: 0, fechaHora: 'fechaHora', enviado: false);
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

    List<dynamic>? cargas =
        await modelProvider.getCargaCist(Preferences.matricula ?? '', carga);

    List<dynamic>? descargas = await ModelProvider.getAllReg(descarga);

    /* Escribir el fichero*/
    file = File(
        '${directory.path}/descargas-${DateTime.now().day}${DateTime.now().month}${DateTime.now().year}${DateTime.now().hour}${DateTime.now().minute}${DateTime.now().second}${DateTime.now().millisecond}.txt');
    IOSink sink = file.openWrite(mode: FileMode.append);

    if (descargas != null) {
      for (var x in descargas) {
        if (!x.enviado) {
          Map<String, dynamic> cargaJson = x.toJson();

          sink.writeln('${cargas[0].cifConductor}'
              '\t${cargas[0].nombreConductor}'
              '\t${cargas[0].matricula}'
              '\t${cargas[0].cisterna}'
              '\t${cargas[0].producto}'
              '\t${cargaJson["CodIndustria"]}'
              '\t${cargaJson["Kilos"].toString().replaceAll('.', ',')}'
              '\t${cargaJson["FechaHora"]}');


          await modelProvider.updateDescarga(Descarga.fromJson(cargaJson), true);
        }
      }
    }
  }
  return file;
}
