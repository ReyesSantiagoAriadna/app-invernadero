// To parse this JSON data, do
//
//     final herramientasModel = herramientasModelFromJson(jsonString);

import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/inventario_herramientas/herramienta.dart';

HerramientasModel herramientasModelFromJson(String str) => HerramientasModel.fromJson(json.decode(str));

String herramientasModelToJson(HerramientasModel data) => json.encode(data.toJson());

class HerramientasModel {
    HerramientasModel({
        this.herramientas,
    });

    Map<String, Herramienta> herramientas;

    factory HerramientasModel.fromJson(Map<String, dynamic> json) => HerramientasModel(
        herramientas: Map.from(json["herramientas"]).map((k, v) => MapEntry<String, Herramienta>(k, Herramienta.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "herramientas": Map.from(herramientas).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}
 