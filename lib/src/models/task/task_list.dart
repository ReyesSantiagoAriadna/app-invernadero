// To parse this JSON data, do
//
//     final TareasList = TareasListFromJson(jsonString);

import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/task/tarea_date_mode.dart';

TareasList TareasListFromJson(String str) => TareasList.fromJson(json.decode(str));

String TareasListToJson(TareasList data) => json.encode(data.toJson());

class TareasList {
    TareasList({
        this.tareas,
    });

    Map<String, Tarea> tareas;

    factory TareasList.fromJson(Map<String, dynamic> json) => TareasList(
        tareas: Map.from(json["tareas"]).map((k, v) => MapEntry<String, Tarea>(k, Tarea.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "tareas": Map.from(tareas).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}