import 'dart:convert';

class Producto{
  Producto({required this.descripcion});

  String descripcion;

  factory Producto.fromRawJson(String str) => Producto.fromJson(json.decode(str));

  factory Producto.fromJson(Map<String, dynamic> json) => Producto(
    descripcion: json["Descripcion"],
  );

  Map<String, dynamic> toJson() => {
    "Descripcion": descripcion,
  };
}