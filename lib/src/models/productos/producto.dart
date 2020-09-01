// To parse this JSON data, do
//
//     final producto = productoFromJson(jsonString);

import 'dart:convert';

Producto productoFromJson(String str) => Producto.fromJson(json.decode(str));

String productoToJson(Producto data) => json.encode(data.toJson());

class Producto {
    Producto({
        this.id,
        this.idCultivo,
        this.nombre,
        this.equiKilos,
        this.precioMay,
        this.precioMen,
        this.cantExis,
        this.semana,
        this.urlImagen,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    int idCultivo;
    String nombre;
    int equiKilos;
    double precioMay;
    double precioMen;
    int cantExis;
    dynamic semana;
    String urlImagen;
    DateTime createdAt;
    DateTime updatedAt;

    factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["id"],
        idCultivo: json["idCultivo"],
        nombre: json["nombre"],
        equiKilos: json["equiKilos"],
        precioMay: json["precioMay"].toDouble(),
        precioMen: json["precioMen"].toDouble(),
        cantExis: json["cantExis"],
        semana: json["semana"]==null?null:json["semana"],
        urlImagen: json["url_imagen"]==null?null:json["url_imagen"],
        createdAt: json["created_at"]==null?null:DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"]==null?null:DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idCultivo": idCultivo,
        "nombre": nombre,
        "equiKilos": equiKilos,
        "precioMay": precioMay,
        "precioMen": precioMen,
        "cantExis": cantExis,
        "semana": semana,
        "url_imagen": urlImagen,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
