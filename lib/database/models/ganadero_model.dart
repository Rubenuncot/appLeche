import 'dart:convert';

import 'models.dart';

class Ganadero{
  Ganadero({required this.codigo, required this.nombre, required this.nif, required this.tanques});

  int codigo;
  String nombre;
  String nif;
  List<Tanque> tanques;


  factory Ganadero.fromRawJson(String str) => Ganadero.fromJson(json.decode(str));

  factory Ganadero.fromJson(Map<String, dynamic> json) => Ganadero(
    codigo: json["CodGanadero"],
    nombre: json["NombreGanadero"],
    nif: json["NifGanadero"],
    tanques: [
      Tanque(codigo: json["Tanque1"],),
      Tanque(codigo: json["Tanque2"],),
      Tanque(codigo: json["Tanque3"],),
      Tanque(codigo: json["Tanque4"],)
    ],
  );

  Map<String, dynamic> toJson() => {
    "CodGanadero": codigo,
    "NombreGanadero": nombre,
    "NifGanadero": nif,
    "Tanque1": tanques[0].codigo,
    "Tanque2": tanques[1].codigo,
    "Tanque3": tanques[2].codigo,
    "Tanque4": tanques[3].codigo,
  };
}