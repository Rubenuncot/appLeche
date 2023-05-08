import 'dart:convert';

class Industria{
  Industria({required this.codigo, required this.nombre});

  int codigo;
  String nombre;

  factory Industria.fromRawJson(String str) => Industria.fromJson(json.decode(str));

  factory Industria.fromJson(Map<String, dynamic> json) => Industria(
    codigo: json["CodIndustria"],
    nombre: json["NombreIndustria"],
  );

  Map<String, dynamic> toJson() => {
    "CodIndustria": codigo,
    "NombreIndustria": nombre,
  };
}