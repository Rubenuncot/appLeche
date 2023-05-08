import 'dart:convert';

import 'models.dart';

class Carga {



  Carga({
    required this.cifConductor,
    required this.nombreConductor,
    required this.matricula,
    required this.cisterna,
    required this.fechaHora,
    required this.codGanadero,
    required this.producto,
    required this.tanques,
    required this.enviado
  });

  String cifConductor;
  String nombreConductor;
  String matricula;
  String cisterna;
  String fechaHora;
  int codGanadero;
  String producto;
  List<Tanque> tanques;
  bool enviado;


  factory Carga.fromRawJson(String str) => Carga.fromJson(json.decode(str));

  factory Carga.fromJson(Map<String, dynamic> json) => Carga(
    cifConductor: json["CifConductor"],
    nombreConductor: json["NombreConductor"],
    matricula: json["Matricula"],
    cisterna: json["Cisterna"],
    fechaHora: json["FechaHora"],
    codGanadero: json["CodGanadero"],
    producto: json["Producto"],
    tanques: [
      Tanque(codigo: json["Tanque1"], litros: double.parse('${json["Litros1"]}'), muestra: json["Muestra1"] == 1 ? true : false, temp: double.parse('${json["Temp1"]}')),
      Tanque(codigo: json["Tanque2"], litros: double.parse('${json["Litros2"]}'), muestra: json["Muestra2"] == 1 ? true : false, temp: double.parse('${json["Temp2"]}')),
      Tanque(codigo: json["Tanque3"], litros: double.parse('${json["Litros3"]}'), muestra: json["Muestra3"] == 1 ? true : false, temp: double.parse('${json["Temp3"]}')),
      Tanque(codigo: json["Tanque4"], litros: double.parse('${json["Litros4"]}'), muestra: json["Muestra4"] == 1 ? true : false, temp: double.parse('${json["Temp4"]}')),
    ],
    enviado: json["Enviado"] == 1 ? true : false
  );

  Map<String, dynamic> toJson() => {
    "CifConductor": cifConductor,
    "NombreConductor": nombreConductor,
    'Matricula': matricula,
    "Cisterna": cisterna,
    "FechaHora": fechaHora,
    "CodGanadero": codGanadero,
    "Producto": producto,
    "Tanque1": tanques[0].codigo,
    "Litros1": tanques[0].litros,
    'Muestra1': tanques[0].muestra == true ? 1 : 0,
    "Temp1": tanques[0].temp,
    "Tanque2": tanques[1].codigo,
    "Litros2": tanques[1].litros == 0 ? '0' : tanques[1].litros,
    'Muestra2': tanques[1].litros == 0 ? 0 : tanques[1].muestra == true ? 1 : 0,
    "Temp2": tanques[1].temp == 0 ? '0' : tanques[1].temp,
    "Tanque3": tanques[2].codigo,
    "Litros3": tanques[2].litros == 0 ? '0' : tanques[2].litros,
    'Muestra3': tanques[2].litros == 0 ? 0 : tanques[2].muestra == true ? 1 : 0,
    "Temp3": tanques[2].temp == 0 ? '0' : tanques[2].temp,
    "Tanque4": tanques[3].codigo,
    "Litros4": tanques[3].litros == 0 ? '0' : tanques[3].litros,
    'Muestra4': tanques[3].litros == 0 ? 0 : tanques[3].muestra == true ? 1 : 0,
    "Temp4": tanques[3].temp == 0 ? '0' : tanques[3].temp,
    "Enviado": enviado == true ? 1 : 0
  };
}