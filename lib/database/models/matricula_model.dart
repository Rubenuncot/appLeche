import 'dart:convert';

class Matricula {
  Matricula({required this.matricula, required this.codCisterna});

  String matricula;
  String codCisterna;

  factory Matricula.fromRawJson(String str) => Matricula.fromJson(json.decode(str));

  factory Matricula.fromJson(Map<String, dynamic> json) => Matricula(
    matricula: json["NombreMatricula"],
    codCisterna: json["Cisterna"],
  );

  Map<String, dynamic> toJson() => {
    "NombreMatricula": matricula,
    "Cisterna": codCisterna,
  };
}