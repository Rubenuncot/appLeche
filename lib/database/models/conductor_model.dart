import 'dart:convert';

class Conductor{
  Conductor({required this.cif, required this.nombre});

  String cif;
  String nombre;


  factory Conductor.fromRawJson(String str) => Conductor.fromJson(json.decode(str));

  factory Conductor.fromJson(Map<String, dynamic> json) => Conductor(
    cif: json["CodConductor"],
    nombre: json["NombreConductor"],
  );

  Map<String, dynamic> toJson() => {
    "CodConductor": cif,
    "NombreConductor": nombre,
  };
}