// To parse this JSON data, do
//
//     final sobrantesModel = sobrantesModelFromJson(jsonString);

import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';

SobrantesModel sobrantesModelFromJson(String str) => SobrantesModel.fromJson(json.decode(str));

String sobrantesModelToJson(SobrantesModel data) => json.encode(data.toJson());

class SobrantesModel {
    SobrantesModel({
        this.sobrantes,
    });

    Map<String, Sobrante> sobrantes;

    factory SobrantesModel.fromJson(Map<String, dynamic> json) => SobrantesModel(
        sobrantes: Map.from(json["sobrantes"]).map((k, v) => MapEntry<String, Sobrante>(k, Sobrante.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "sobrantes": Map.from(sobrantes).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

class Sobrante {
    Sobrante({
        this.id,
        this.idProducto,
        this.fecha,
        this.cantidad,
        this.observacion,
        this.createdAt,
        this.updatedAt,
        this.producto,
    });

    int id;
    int idProducto;
    DateTime fecha;
    int cantidad;
    String observacion;
    DateTime createdAt;
    DateTime updatedAt;
    Producto producto;

    factory Sobrante.fromJson(Map<String, dynamic> json) => Sobrante(
        id: json["id"],
        idProducto: json["idProducto"],
        fecha: DateTime.parse(json["fecha"]),
        cantidad: json["cantidad"],
        observacion: json["observacion"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        producto: Producto.fromJsonPerdida(json["producto"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idProducto": idProducto,
        "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "cantidad": cantidad,
        "observacion": observacion,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "producto": producto.toJson(),
    };
}

// class Producto {
//     Producto({
//         this.id,
//         this.idCultivo,
//         this.nombre,
//         this.equiKilos,
//         this.precioMay,
//         this.precioMen,
//         this.cantExis,
//         this.semana,
//         this.urlImagen,
//         this.createdAt,
//         this.updatedAt,
//     });

//     int id;
//     int idCultivo;
//     String nombre;
//     int equiKilos;
//     double precioMay;
//     double precioMen;
//     int cantExis;
//     int semana;
//     String urlImagen;
//     DateTime createdAt;
//     DateTime updatedAt;

//     factory Producto.fromJson(Map<String, dynamic> json) => Producto(
//         id: json["id"],
//         idCultivo: json["idCultivo"],
//         nombre: json["nombre"],
//         equiKilos: json["equiKilos"],
//         precioMay: json["precioMay"].toDouble(),
//         precioMen: json["precioMen"].toDouble(),
//         cantExis: json["cantExis"],
//         semana: json["semana"] == null ? null : json["semana"],
//         urlImagen: json["url_imagen"] == null ? null : json["url_imagen"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "idCultivo": idCultivo,
//         "nombre": nombre,
//         "equiKilos": equiKilos,
//         "precioMay": precioMay,
//         "precioMen": precioMen,
//         "cantExis": cantExis,
//         "semana": semana == null ? null : semana,
//         "url_imagen": urlImagen == null ? null : urlImagen,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//     };
// }
