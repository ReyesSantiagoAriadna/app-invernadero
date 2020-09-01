// To parse this JSON data, do
//
//     final herramientaModel = herramientaModelFromJson(jsonString);

import 'dart:convert';

HerramientaModel herramientaModelFromJson(String str) => HerramientaModel.fromJson(json.decode(str));

String herramientaModelToJson(HerramientaModel data) => json.encode(data.toJson());

class HerramientaModel {
    HerramientaModel({
        this.herramientas,
    });

    Map<String, Herramienta> herramientas;

    factory HerramientaModel.fromJson(Map<String, dynamic> json) => HerramientaModel(
        herramientas: Map.from(json["herramientas"]).map((k, v) => MapEntry<String, Herramienta>(k, Herramienta.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "herramientas": Map.from(herramientas).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

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
    bool isSelect=false;
    int amountOnTask=0;
    
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
        urlImagen: json["url_imagen"],
        updatedAt: DateTime.parse(json["updated_at"]),
        createdAt: DateTime.parse(json["created_at"]),
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
