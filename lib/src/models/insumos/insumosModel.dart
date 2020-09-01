// To parse this JSON data, do
//
//     final insumosModel = insumosModelFromJson(jsonString);

import 'dart:convert';
import 'package:app_invernadero_trabajador/src/models/insumos/insumo.dart';


InsumosModel insumosModelFromJson(String str) => InsumosModel.fromJson(json.decode(str));

String insumosModelToJson(InsumosModel data) => json.encode(data.toJson());

class InsumosModel {
    InsumosModel({
        this.insumos,
    });

    Map<String, Insumo> insumos;

    factory InsumosModel.fromJson(Map<String, dynamic> json) => InsumosModel(
        insumos: Map.from(json["insumos"]).map((k, v) => MapEntry<String, Insumo>(k, Insumo.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "insumos": Map.from(insumos).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

 