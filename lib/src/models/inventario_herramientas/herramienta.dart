// To parse this JSON data, do
//
//     final herramienta = herramientaFromJson(jsonString);

import 'dart:convert';

Herramienta herramientaFromJson(String str) => Herramienta.fromJson(json.decode(str));

String herramientaToJson(Herramienta data) => json.encode(data.toJson());

class Herramienta {
    Herramienta({
        this.id,
        this.nombre,
        this.descripcion,
        this.cantidad,
        this.urlImagen,
        this.updatedAt,
        this.createdAt,
    });

    int id;
    String nombre;
    String descripcion;
    int cantidad;
    String urlImagen;
    DateTime updatedAt;
    DateTime createdAt;

    factory Herramienta.fromJson(Map<String, dynamic> json) => Herramienta(
        id: json["id"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
        cantidad: json["cantidad"],
        urlImagen: json["url_imagen"]==null?null:json["url_imagen"],
        updatedAt:json["updated_at"]==null?null: DateTime.parse(json["updated_at"]),
        createdAt:json["created_at"]==null?null: DateTime.parse(json["created_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "descripcion": descripcion,
        "cantidad": cantidad,
        "url_imagen": urlImagen,
        "updated_at": updatedAt.toIso8601String(),
        "created_at": createdAt.toIso8601String(),
    };
}
