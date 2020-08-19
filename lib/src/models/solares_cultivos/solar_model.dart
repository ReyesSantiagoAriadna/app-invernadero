// To parse this JSON data, do
//
//     final SolaresModel = SolaresModelFromJson(jsonString);

import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';

SolarModel SolaresModelFromJson(String str) => SolarModel.fromJson(json.decode(str));

String SolaresModelToJson(SolarModel data) => json.encode(data.toJson());

class SolarModel {
    SolarModel({
        this.solares,
    });

    Map<String, Solar> solares;

    factory SolarModel.fromJson(Map<String, dynamic> json) => SolarModel(
        solares: Map.from(json["solares"]).map((k, v) => MapEntry<String, Solar>(k, Solar.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "solares": Map.from(solares).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}




