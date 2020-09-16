// To parse this JSON data, do
//
//     final proveedorModel = proveedorModelFromJson(jsonString);

import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/proveedores/proveedor.dart';
 

 
ProveedorModel proveedorModelFromJson(String str) => ProveedorModel.fromJson(json.decode(str));

String proveedorModelToJson(ProveedorModel data) => json.encode(data.toJson());

class ProveedorModel {
    ProveedorModel({
        this.proveedores,
    });

    Map<String, Proveedor> proveedores;

    factory ProveedorModel.fromJson(Map<String, dynamic> json) => ProveedorModel(
        proveedores: Map.from(json["proveedores"]).map((k, v) => MapEntry<String, Proveedor>(k, Proveedor.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "proveedores": Map.from(proveedores).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

 