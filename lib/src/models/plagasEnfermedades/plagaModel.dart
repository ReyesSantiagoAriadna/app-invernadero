 // To parse this JSON data, do
//
//     final plagasModel = plagasModelFromJson(jsonString);

import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/plagasEnfermedades/plaga.dart';

PlagasModel plagasModelFromJson(String str) => PlagasModel.fromJson(json.decode(str));

String plagasModelToJson(PlagasModel data) => json.encode(data.toJson());

class PlagasModel {
    PlagasModel({
        this.plagas,
    });

    Map<String, Plagas> plagas;

    factory PlagasModel.fromJson(Map<String, dynamic> json) => PlagasModel(
        plagas: Map.from(json["plagas"]).map((k, v) => MapEntry<String, Plagas>(k, Plagas.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "plagas": Map.from(plagas).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}
 