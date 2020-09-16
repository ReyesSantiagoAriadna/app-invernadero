//
//     final tareasTrabajador = tareasTrabajadorFromJson(jsonString);

import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/task/tarea_date_mode.dart' as t;
import 'package:app_invernadero_trabajador/src/models/task/tarea_date_mode.dart';

TareasTrabajador tareasTrabajadorFromJson(String str) => TareasTrabajador.fromJson(json.decode(str));

String tareasTrabajadorToJson(TareasTrabajador data) => json.encode(data.toJson());

class TareasTrabajador {
    TareasTrabajador({
        this.tareasTrabajador,
    });

    Map<DateTime, List<TareasTrabajadorElement>> tareasTrabajador;

    factory TareasTrabajador.fromJson(Map<String, dynamic> json) => TareasTrabajador(
        tareasTrabajador: Map.from(json["tareas_trabajador"]).map((k, v) => MapEntry<DateTime, List<TareasTrabajadorElement>>
        (DateTime.parse(k), List<TareasTrabajadorElement>.from(v.map((x) => TareasTrabajadorElement.fromJson(x))))),
    );
  
    factory TareasTrabajador.fromJsonToAdmin(Map<String, dynamic> json) => 
    TareasTrabajador(
        tareasTrabajador: Map.from(json["tareas_trabajador"]).map((k, v) => MapEntry<DateTime, List<TareasTrabajadorElement>>
        (DateTime.parse(k), List<TareasTrabajadorElement>.from(v.map((x) => TareasTrabajadorElement.fromJsonToAdmins(x))))),
    );

    Map<String, dynamic> toJson() => {
        "tareas_trabajador": Map.from(tareasTrabajador).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
    };
}

class TareasTrabajadorElement {
    TareasTrabajadorElement({
        this.idTarea,
        this.idPersonal,
        this.fecha,
        this.status,
        this.consecutivo,
        this.horaInicio,
        this.horaFinal,
        this.createdAt,
        this.updatedAt,
        this.personal,
        this.tarea,
        this.insumos,
        this.herramientas,
    });

    int idTarea;
    int idPersonal;
    DateTime fecha;
    int status;
    int consecutivo;
    String horaInicio;
    String horaFinal;
    DateTime createdAt;
    DateTime updatedAt;
    Personal personal;
    t.Tarea tarea;
    List<Insumo> insumos;
    List<Herramienta> herramientas;

    factory TareasTrabajadorElement.fromJson(Map<String, dynamic> json) => TareasTrabajadorElement(
        idTarea: json["id_tarea"],
        idPersonal: json["id_personal"],
        fecha: json["fecha"]==null?null: DateTime.parse(json["fecha"]),
        status: json["status"],
        consecutivo: json["consecutivo"],
        horaInicio: json["horaInicio"],
        horaFinal: json["horaFinal"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"]==null?null: DateTime.parse(json["updated_at"]),
        tarea:json["tarea"]==null?null: t.Tarea.fromJson(json["tarea"]),
        insumos: json["insumos"]==null?[]: List<Insumo>.from(json["insumos"].map((x) => Insumo.fromJson(x))),
        herramientas:  json["herramientas"] ==null?[]:List<Herramienta>.from(json["herramientas"].map((x) => Herramienta.fromJson(x))),
    );

    factory TareasTrabajadorElement.fromJsonToAdmins(Map<String, dynamic> json) => TareasTrabajadorElement(
        idTarea: json["id_tarea"],
        idPersonal: json["id_personal"],
        fecha: json["fecha"]==null?null: DateTime.parse(json["fecha"]),
        status: json["status"],
        consecutivo: json["consecutivo"],
        horaInicio: json["horaInicio"],
        horaFinal: json["horaFinal"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"]==null?null: DateTime.parse(json["updated_at"]),
        personal: json["personal"]==null?null: Personal.fromJson( json["personal"]),
        tarea:json["tarea"]==null?null: t.Tarea.fromJson(json["tarea"]),
        insumos: json["insumos"]==null?[]: List<Insumo>.from(json["insumos"].map((x) => Insumo.fromJson(x))),
        herramientas:  json["herramientas"] ==null?[]:List<Herramienta>.from(json["herramientas"].map((x) => Herramienta.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id_tarea": idTarea,
        "id_personal": idPersonal,
        "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "status": status,
        "consecutivo": consecutivo,
        "horaInicio": horaInicio,
        "horaFinal": horaFinal,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "tarea": tarea.toJson(),
        "insumos": List<dynamic>.from(insumos.map((x) => x.toJson())),
        "herramientas": List<dynamic>.from(herramientas.map((x) => x.toJson())),
    };
}