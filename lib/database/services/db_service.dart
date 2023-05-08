import 'dart:convert';
import 'dart:io';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:sqflite/sqflite.dart';
import 'package:transportes_leche/database/models/models.dart';

class DBProvider {
  static Database? _database;
  static final DBProvider db = DBProvider._();

  DBProvider._();

  Future<Database?> get database async {
    if (_database != null) {
      return _database;
    }
    _database = await initDB();
    return _database;
  }

  Future<Database?> initDB() async {
    // Path de donde almacenaremos la base de datos.
    Directory documentDirectory = await getApplicationDocumentsDirectory();

    final path = join(documentDirectory.path, 'Transportistas.db');

    // Crear la base de datos
    return await openDatabase(path, version: 6, onOpen: (db) {},
        onCreate: (db, version) async {
      await db.execute('''
          CREATE TABLE Carga (
            CifConductor varchar(16) NOT NULL,
            NombreConductor varchar(256) NULL,
            Matricula varchar(15) NOT NULL,
            Cisterna varchar(15) NOT NULL,
            FechaHora datetime NOT NULL,
            CodGanadero int NOT NULL,
            Producto varchar(20) NULL,
            Tanque1 varchar(15) NULL,
            Litros1 decimal(6, 2) NULL,
            Muestra1 bit NULL,
            Temp1 decimal(4, 2) NULL,
            Tanque2 varchar(15) NULL,
            Litros2 decimal(6, 2) NULL,
            Muestra2 bit NULL,
            Temp2 decimal(4, 2) NULL,
            Tanque3 varchar(15) NULL,
            Litros3 decimal(6, 2) NULL,
            Muestra3 bit NULL,
            Temp3 decimal(4, 2) NULL,
            Tanque4 varchar(15) NULL,
            Litros4 decimal(6, 2) NULL,
            Muestra4 bit NULL,
            Temp4 decimal(4, 2) NULL,
            Enviado int NOT NULL,
            PRIMARY KEY(CifConductor, Matricula, Cisterna, FechaHora, CodGanadero)
          )''');
      await db.execute('''
          CREATE TABLE Descarga (
            CodIndustria int NOT NULL,
            Kilos decimal(6, 2) NOT NULL,
            FechaHora datetime NOT NULL,
            Enviado int NOT NULL,
            PRIMARY KEY(CodIndustria, Kilos, FechaHora)
          )''');
      await db.execute('''
          CREATE TABLE Ganadero (
            CodGanadero int PRIMARY KEY NOT NULL,
            NombreGanadero varchar(255) NULL,
            NifGanadero varchar(16) NOT NULL,
            Tanque1 varchar(15) NULL,
            Tanque2 varchar(15) NULL,
            Tanque3 varchar(15) NULL,
            Tanque4 varchar(15) NULL
          )''');
      await db.execute('''
          CREATE TABLE Industria (
            CodIndustria int PRIMARY KEY NOT NULL,
            NombreIndustria varchar(255) NULL
          )''');
      await db.execute('''
          CREATE TABLE Producto (
            Descripcion varchar(255) PRIMARY KEY NOT NULL
          )''');
      await db.execute('''
          CREATE TABLE Conductor (
            CodConductor varchar(16) PRIMARY KEY NOT NULL,
            NombreConductor varchar(255) NULL
          )''');
      await db.execute('''          
          CREATE TABLE Matricula (
            NombreMatricula varchar(50) PRIMARY KEY NOT NULL,
            Cisterna varchar(20) NOT NULL
          )
        ''');
    });
  }

  /* ----- Métodos de inserción de datos -----*/

  Future<int> newReg(dynamic newReg) async {
    final db = await database;
    final res = db!.insert('${newReg.runtimeType}', newReg.toJson());
    return res;
  }

  // Future<int> newCarga(Carga newCarga) async {
  //   final db = await database;
  //   final res = db!.insert('Cargas', newCarga.toJson());
  //   return res;
  // }
  //
  // Future<int> newConductor(Conductor newConductor) async {
  //   final db = await database;
  //   final res = db!.insert('Conductores', newConductor.toJson());
  //   return res;
  // }
  //
  // Future<int> newDescarga(Descarga newDescarga) async {
  //   final db = await database;
  //   final res = db!.insert('Descargas', newDescarga.toJson());
  //   return res;
  // }
  //
  // Future<int> newGanadero(Ganadero newGanadero) async {
  //   final db = await database;
  //   final res = db!.insert('Ganaderos', newGanadero.toJson());
  //   return res;
  // }
  //
  // Future<int> newIndustria(Industria newIndustria) async {
  //   final db = await database;
  //   final res = db!.insert('Industrias', newIndustria.toJson());
  //   return res;
  // }
  //
  // Future<int> newMatricula(Matricula newMatricula) async {
  //   final db = await database;
  //   final res = db!.insert('Matriculas', newMatricula.toJson());
  //   return res;
  // }
  //
  // Future<int> newProducto(Producto newProducto) async {
  //   final db = await database;
  //   final res = db!.insert('Productos', newProducto.toJson());
  //   return res;
  // }

  /* ----- Fin métodos de inserción de datos -----*/

  /* -------------------------------------------- */

  /* ----- Métodos de obtención de datos -----*/

  Future<List<dynamic>> getRegName(String name, dynamic obj) async {
    final db = await database;
    final List<dynamic> objects = [];
    Iterable<dynamic> ids = [];
    final res = await db!.rawQuery('''
        SELECT * from ${obj.runtimeType} WHERE Nombre${obj.runtimeType} LIKE '%$name%'
      ''');
    for (var x = 0; x < res.length; x++) {
      ids = res[x].keys;
      List<String> idsStr = [];
      for (var i = 0; i < 1; i++) {
        for (var x in ids) {
          idsStr.add(x);
        }
        switch ('${obj.runtimeType}') {
          case 'Ganadero':
            objects.add(Ganadero(
                codigo: res[x][idsStr[i]] as int,
                nombre: '${res[x][idsStr[i + 1]]}',
                nif: '${res[x][idsStr[i + 2]]}',
                tanques: [
                  Tanque(codigo: '${res[x][idsStr[i + 3]]}'),
                  Tanque(codigo: '${res[x][idsStr[i + 4]]}'),
                  Tanque(codigo: '${res[x][idsStr[i + 5]]}'),
                  Tanque(codigo: '${res[x][idsStr[i + 6]]}'),
                ]));
            break;
          case 'Industria':
            objects.add(Industria(
                codigo: res[x][idsStr[i]] as int,
                nombre: '${res[x][idsStr[i + 1]]}'));
            break;
          case 'Conductor':
            objects.add(Conductor(
                cif: '${res[x][idsStr[i]]}',
                nombre: '${res[x][idsStr[i + 1]]}'));
            break;
          case 'Matricula':
            objects.add(Matricula(
                matricula: '${res[x][idsStr[i]]}',
                codCisterna: '${res[x][idsStr[i + 1]]}'));
            break;
        }
      }
    }

    return objects;
  }

  Future<List> getCargaByCist(String matricula, obj) async {
    final db = await database;
    Iterable<String> ids = [];
    Iterable<Object?> values = [];
    final Map<String, String> map = {};
    final List valores = [];
    final List retornable = [];

    final res = await db!.rawQuery('''
        SELECT * from ${obj.runtimeType} WHERE Matricula = '$matricula'
      ''');

    if (res.isNotEmpty) {
      ids = res.first.keys;
      values = res.first.values;
      for (var x in values) {
        valores.add('$x');
      }
      var i = 0;
      for (var x in ids) {
        map.addAll({x: valores[i]});
        i++;
      }
      retornable.add(Carga(
          cifConductor: map['CifConductor'] ?? '',
          nombreConductor: map['NombreConductor'] ?? '',
          matricula: matricula,
          cisterna: map['Cisterna'] ?? '',
          fechaHora: map['FechaHora'] ?? '',
          codGanadero: int.parse('${map['CodGanadero']}'),
          producto: map['Producto'] ?? '',
          tanques: [],
          enviado: false));
    }

    return retornable;
  }

  Future<List<dynamic>> getRegCod(String cod, dynamic obj) async {
    final db = await database;
    final List<dynamic> objects = [];
    Iterable<dynamic> ids = [];

    final res = await db!.rawQuery('''
        SELECT * from ${obj.runtimeType} WHERE Cod${obj.runtimeType} = '$cod'
      ''');

    for (var x = 0; x < res.length; x++) {
      ids = res[x].keys;
      List<String> idsStr = [];
      for (var i = 0; i < 1; i++) {
        for (var x in ids) {
          idsStr.add(x);
        }
        switch ('${obj.runtimeType}') {
          case 'Ganadero':
            print('${res[x]}');
            objects.add(Ganadero(
                codigo: res[x][idsStr[i]] as int,
                nombre: '${res[x][idsStr[i + 1]]}',
                nif: '${res[x][idsStr[i + 2]]}',
                tanques: [
                  Tanque(codigo: '${res[x][idsStr[i + 3]]}'),
                  Tanque(codigo: '${res[x][idsStr[i + 4]]}'),
                  Tanque(codigo: '${res[x][idsStr[i + 5]]}'),
                  Tanque(codigo: '${res[x][idsStr[i + 6]]}'),
                ]));
            break;
          case 'Industria':
            objects.add(Industria(
                codigo: res[x][idsStr[i]] as int,
                nombre: '${res[x][idsStr[i + 1]]}'));
            break;
        }
      }
    }
    return objects;
  }

  Future<dynamic> getReg(int id, dynamic obj) async {
    final db = await database;
    final res = await db!.query(
      '${obj.runtimeType}',
    );

    switch (obj.runtimeType.toString()) {
      case 'Carga':
        return Carga.fromJson(res[id - 1]);
      case 'Conductor':
        return Conductor.fromJson(res[id - 1]);
      case 'Descarga':
        return Descarga.fromJson(res[id - 1]);
      case 'Ganadero':
        return Ganadero.fromJson(res[id - 1]);
      case 'Industria':
        return Industria.fromJson(res[id - 1]);
      case 'Matricula':
        return Matricula.fromJson(res[id - 1]);
      case 'Producto':
        return Producto.fromJson(res[id - 1]);
    }
  }

  Future<List<dynamic>> getAllReg(dynamic obj) async {
    final db = await database;
    final res = await db!.query(
      '${obj.runtimeType}',
    );

    final List<dynamic> list = [];

    for (var x = 0; x < res.length; x++) {
      switch (obj.runtimeType.toString()) {
        case 'Carga':
          list.add(Carga.fromJson(res[x]));
          break;
        case 'Conductor':
          list.add(Conductor.fromJson(res[x]));
          break;
        case 'Descarga':
          list.add(Descarga.fromJson(res[x]));
          break;
        case 'Ganadero':
          list.add(Ganadero.fromJson(res[x]));
          break;
        case 'Industria':
          list.add(Industria.fromJson(res[x]));
          break;
        case 'Matricula':
          list.add(Matricula.fromJson(res[x]));
          break;
        case 'Producto':
          list.add(Producto.fromJson(res[x]));
          break;
      }
    }

    return list;
  }

  Future<Carga> getCargaById(String cifConductor, String matricula,
      String cisterna, String fechaHora, String codGanadero) async {
    final db = await database;
    final res = await db!.query('Cargas',
        where:
            'CifConductor = ? and Matricula = ? and Cisterna = ? and FechaHora = ?, CodGanadero = ?',
        whereArgs: [cifConductor, matricula, cisterna, fechaHora, codGanadero]);

    return Carga.fromJson(res.first);
  }

  Future<Conductor> getConductorById(int id) async {
    final db = await database;
    final res = await db!.query(
      'Conductor',
    );

    return Conductor.fromJson(res[id - 1]);
  }

  Future<Descarga> getDescargaById(
    String codIndustria,
    String kilos,
    String fechaHora,
  ) async {
    final db = await database;
    final res = await db!.query('Descargas',
        where: 'CodIndustria = ? and Kilos = ? and FechaHora = ?',
        whereArgs: [codIndustria, kilos, fechaHora]);

    return Descarga.fromJson(res.first);
  }

  Future<Ganadero> getGanaderoById(
    int codGanadero,
  ) async {
    final db = await database;
    final res =
        await db!.query('Ganaderos', where: 'CodGanadero = ?', whereArgs: [
      codGanadero,
    ]);

    return Ganadero.fromJson(res.first);
  }

  Future<Industria> getIndustriaById(
    int codindustria,
  ) async {
    final db = await database;
    final res =
        await db!.query('Industrias', where: 'Codindustria = ?', whereArgs: [
      codindustria,
    ]);

    return Industria.fromJson(res.first);
  }

  Future<Matricula> getMatriculaById(
    String matricula,
  ) async {
    final db = await database;
    final res =
        await db!.query('Matriculas', where: 'Matricula = ?', whereArgs: [
      matricula,
    ]);

    return Matricula.fromJson(res.first);
  }

  Future<Producto> getProductoById(
    String descripcion,
  ) async {
    final db = await database;
    final res =
        await db!.query('Productos', where: 'Descripcion = ?', whereArgs: [
      descripcion,
    ]);

    return Producto.fromJson(res.first);
  }

/* ----- Fin métodos de obtención de datos -----*/

/* -------------------------------------------- */

/* ----- Métodos de borrado de datos -----*/

  Future<int> deleteCarga(Carga carga) async {
    final db = await database;
    final res = db!.rawDelete('''
      DELETE FROM Carga WHERE CifConductor = '${carga.cifConductor}' and Matricula = '${carga.matricula}' and Cisterna = '${carga.cisterna}' and FechaHora = '${carga.fechaHora}' and CodGanadero = '${carga.codGanadero}'
    ''');
    return res;
  }

  Future<int> deleteDescarga(Descarga descarga) async {
    final db = await database;
    final res = db!.rawDelete('''
      DELETE FROM Descarga WHERE CodIndustria = '${descarga.codIndustria}' and Kilos = '${descarga.kilos}' and FechaHora = '${descarga.fechaHora}'
    ''');
    return res;
  }

  Future<int> deleteConductor(
    String cifConductor,
  ) async {
    final db = await database;
    final res = db!.rawDelete('''
      DELETE FROM Conductores WHERE CifConductor = $cifConductor
    ''');
    return res;
  }

  Future<int> deleteGanadero(
    int codGanadero,
  ) async {
    final db = await database;
    final res = db!.rawDelete('''
      DELETE FROM Ganaderos WHERE CodGanadero = $codGanadero
    ''');
    return res;
  }

  Future<int> deleteIndustria(
    int codIndustria,
  ) async {
    final db = await database;
    final res = db!.rawDelete('''
      DELETE FROM Industrias WHERE CodGanadero = $codIndustria
    ''');
    return res;
  }

  Future<int> deleteMatricula(
    String matricula,
  ) async {
    final db = await database;
    final res = db!.rawDelete('''
      DELETE FROM Matriculas WHERE Matricula = $matricula
    ''');
    return res;
  }

  Future<int> deleteProducto(
    String descripcion,
  ) async {
    final db = await database;
    final res = db!.rawDelete('''
      DELETE FROM Productos WHERE Descripcion = $descripcion
    ''');
    return res;
  }

  Future<int> deleteAll(dynamic obj) async {
    final db = await database;
    final res = db!.delete(obj.runtimeType.toString());
    return res;
  }

/* ----- Fin métodos de borrado de datos -----*/

/* ----- Métodos de modificación de datos -----*/

  Future<int> updateCarga(Carga carga, bool val) async {
    final db = await database;
    final res = db!.rawUpdate('''
    UPDATE Carga SET Enviado = ${val == false ? 0 : 1} WHERE CifConductor = '${carga.cifConductor}' and Matricula = '${carga.matricula}' and Cisterna = '${carga.cisterna}' and FechaHora = '${carga.fechaHora}' and CodGanadero = '${carga.codGanadero}'
  ''');
    return res;
  }

  Future<int> updateDescarga(Descarga descarga, bool val) async {
    final db = await database;
    final res = db!.rawUpdate('''
    UPDATE Descarga SET Enviado = ${val == false ? 0 : 1} WHERE CodIndustria = '${descarga.codIndustria}' and Kilos = '${descarga.kilos}' and FechaHora = '${descarga.fechaHora}'
  ''');
    return res;
  }

/* ----- Fin métodos de modificación de datos -----*/

/* -------------------------------------------- */
}
