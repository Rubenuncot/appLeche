import 'dart:convert';

class Descarga{
  Descarga({required this.codIndustria, required this.kilos, required this.fechaHora, required this.enviado});

  int codIndustria;
  double kilos;
  String fechaHora;
  bool enviado;


  factory Descarga.fromRawJson(String str) => Descarga.fromJson(json.decode(str));

  factory Descarga.fromJson(Map<String, dynamic> json) => Descarga(
    codIndustria: json["CodIndustria"],
    kilos: double.parse('${json["Kilos"]}'),
    fechaHora: json["FechaHora"],
    enviado: json["Enviado"] == 1 ? true : false
  );

  Map<String, dynamic> toJson() => {
    "CodIndustria": codIndustria,
    "Kilos": kilos,
    "FechaHora": fechaHora,
    "Enviado": enviado == true ? 1 : 0
  };
}