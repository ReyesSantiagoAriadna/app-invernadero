// To parse this JSON data, do
//
//     final trabajadorDisponibleModel = trabajadorDisponibleModelFromJson(jsonString);

import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/task/tarea_date_mode.dart';

TrabajadorDisponibleModel trabajadorDisponibleModelFromJson(String str) => TrabajadorDisponibleModel.fromJson(json.decode(str));

String trabajadorDisponibleModelToJson(TrabajadorDisponibleModel data) => json.encode(data.toJson());

class TrabajadorDisponibleModel {
    TrabajadorDisponibleModel({
        this.trabajador,
        this.disponible,
        this.personal,
    });

    String trabajador;
    bool disponible;
    List<Personal> personal;

    factory TrabajadorDisponibleModel.fromJson(Map<String, dynamic> json) => TrabajadorDisponibleModel(
        trabajador: json["trabajador"],
        disponible: json["disponible"],
        personal: List<Personal>.from(json["personal"].map((x) => Personal.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "trabajador": trabajador,
        "disponible": disponible,
        "personal": List<dynamic>.from(personal.map((x) => x.toJson())),
    };
}