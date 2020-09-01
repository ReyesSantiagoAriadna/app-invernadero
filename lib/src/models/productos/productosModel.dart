// To parse this JSON data, do
//
//     final productosModel = productosModelFromJson(jsonString);

import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/productos/producto.dart';

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

    Map<String, dynamic> toJson() => {
        "productos": Map.from(productos).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}
 
