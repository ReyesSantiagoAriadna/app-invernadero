// To parse this JSON data, do
//
//     final productosModel = productosModelFromJson(jsonString);

import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/actividades/sobrantes_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';

ProductosModel productosModelFromJson(String str) => ProductosModel.fromJson(json.decode(str));

String productosModelToJson(ProductosModel data) => json.encode(data.toJson());

class ProductosModel {
    ProductosModel({
        this.productos,
    });

    Map<String, Producto> productos;

    factory ProductosModel.fromJson(Map<String, dynamic> json) => ProductosModel(
        productos: Map.from(json["productos"]).map((k, v) => MapEntry<String, Producto>(k, Producto.fromJson(v))),
    );
    //buscando producto por cultivo
    factory ProductosModel.fromJsonCultivo(Map<String, dynamic> json) => ProductosModel(
        productos: Map.from(json["productos"]).map((k, v) => MapEntry<String, Producto>(k, Producto.fromJsonProductoIdCultivo(v))),
    );

    Map<String, dynamic> toJson() => {
        "productos": Map.from(productos).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

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
        this.cultivo,
        this.cultivoNombre,
        this.solar
    });

    bool isSelect=false;

    int id;
    int idCultivo;
    String nombre;
    int equiKilos;
    double precioMay;
    double precioMen;
    int cantExis;
    int semana;
    String urlImagen;
    DateTime createdAt;
    DateTime updatedAt;
    Cultivo cultivo;
    String cultivoNombre;
    int solar;
  //  //"cultivo_nombre": "Jitomate",
  //               "solar": 21
    factory Producto.fromJson(Map<String, dynamic> json) => Producto(
        id: json["id"],
        idCultivo: json["idCultivo"],
        nombre: json["nombre"],
        equiKilos: json["equiKilos"],
        precioMay: json["precioMay"]==null?0.0:json["precioMay"].toDouble(),
        precioMen: json["precioMen"]==null?0.0:json["precioMen"].toDouble(),
        cantExis: json["cantExis"],
        semana: json["semana"] == null ? null : json["semana"],
        urlImagen: json["url_imagen"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        cultivo: Cultivo.fromJson(json["cultivo"]),
    );
    factory Producto.fromJsonPerdida(Map<String, dynamic> json) => Producto(
        id: json["id"],
        idCultivo: json["idCultivo"],
        nombre: json["nombre"],
        equiKilos: json["equiKilos"],
        precioMay: json["precioMay"]==null?0.0:json["precioMay"].toDouble(),
        precioMen: json["precioMen"]==null?0.0:json["precioMen"].toDouble(),
        cantExis: json["cantExis"],
        semana: json["semana"] == null ? null : json["semana"],
        urlImagen: json["url_imagen"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        //cultivo: Cultivo.fromJson(json["cultivo"]),
        cultivoNombre:  json["cultivo_nombre"],
        solar: json["solar"]
    );
  
    factory Producto.fromJsonProductoIdCultivo(Map<String, dynamic> json) => Producto(
        id: json["id"],
        idCultivo: json["idCultivo"],
        nombre: json["nombre"],
        equiKilos: json["equiKilos"],
        precioMay: json["precioMay"]==null?0.0:json["precioMay"].toDouble(),
        precioMen: json["precioMen"]==null?0.0:json["precioMen"].toDouble(),
        cantExis: json["cantExis"],
        semana: json["semana"] == null ? null : json["semana"],
        urlImagen: json["url_imagen"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idCultivo": idCultivo,
        "nombre": nombre,
        "equiKilos": equiKilos,
        "precioMay": precioMay,
        "precioMen": precioMen,
        "cantExis": cantExis,
        "semana": semana == null ? null : semana,
        "url_imagen": urlImagen,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "cultivo": cultivo.toJson(),
    };
}