// To parse this JSON data, do
//
//     final tareasModel = tareasModelFromJson(jsonString);

import 'dart:convert';

TareasModel tareasModelFromJson(String str) => TareasModel.fromJson(json.decode(str));

String tareasModelToJson(TareasModel data) => json.encode(data.toJson());

class TareasModel {
    TareasModel({
        this.tareas,
    });

    Map<String, Tarea> tareas;

    factory TareasModel.fromJson(Map<String, dynamic> json) => TareasModel(
        tareas: Map.from(json["tareas"]).map((k, v) => MapEntry<String, Tarea>(k, Tarea.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "tareas": Map.from(tareas).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

class Tarea {
    Tarea({
        this.id,
        this.idFkcultivo,
        this.nombre,
        this.etapa,
        this.tipo,
        this.horaInicio,
        this.horaFinal,
        this.detalle,
        this.backgroundColor,
        this.createdAt,
        this.updatedAt,
        this.insumos,
        this.herramientas,
        this.cultivo,
    });

    int id;
    int idFkcultivo;
    String nombre;
    String etapa;
    String tipo;
    String horaInicio;
    String horaFinal;
    String detalle;
    String backgroundColor;
    DateTime createdAt;
    DateTime updatedAt;
    List<Insumo> insumos;
    List<Herramienta> herramientas;
    Cultivo cultivo;
    
    factory Tarea.fromJson(Map<String, dynamic> json) => Tarea(
        id: json["id"],
        idFkcultivo: json["id_fkcultivo"],
        nombre: json["nombre"],
        etapa: json["etapa"],
        tipo: json["tipo"],
        horaInicio: json["horaInicio"],
        horaFinal: json["horaFinal"],
        detalle: json["detalle"],
        backgroundColor: json["backgroundColor"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        insumos: List<Insumo>.from(json["insumos"].map((x) => Insumo.fromJson(x))),
        herramientas: List<Herramienta>.from(json["herramientas"].map((x) => Herramienta.fromJson(x))),
        cultivo: Cultivo.fromJson(json["cultivo"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_fkcultivo": idFkcultivo,
        "nombre": nombre,
        "etapa": etapa,
        "tipo": tipo,
        "horaInicio": horaInicio,
        "horaFinal": horaFinal,
        "detalle": detalle,
        "backgroundColor": backgroundColor,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "insumos": List<dynamic>.from(insumos.map((x) => x.toJson())),
        "herramientas": List<dynamic>.from(herramientas.map((x) => x.toJson())),
        "cultivo": cultivo.toJson(),
    };
}

class Cultivo {
    Cultivo({
        this.id,
        this.idFksolar,
        this.tipo,
        this.nombre,
        this.largo,
        this.ancho,
        this.fecha,
        this.fechaFinal,
        this.moniSensor,
        this.observacion,
        this.tempMin,
        this.tempMax,
        this.humeMin,
        this.humeMax,
        this.humeSMin,
        this.humeSMax,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    int idFksolar;
    String tipo;
    String nombre;
    double largo;
    double ancho;
    DateTime fecha;
    DateTime fechaFinal;
    int moniSensor;
    String observacion;
    int tempMin;
    int tempMax;
    int humeMin;
    int humeMax;
    int humeSMin;
    int humeSMax;
    DateTime createdAt;
    DateTime updatedAt;

    factory Cultivo.fromJson(Map<String, dynamic> json) => Cultivo(
        id: json["id"],
        idFksolar: json["id_fksolar"],
        tipo: json["tipo"],
        nombre: json["nombre"],
        largo: json["largo"].toDouble(),
        ancho: json["ancho"].toDouble(),
        fecha: DateTime.parse(json["fecha"]),
        fechaFinal: json["fechaFinal"] == null ? null : DateTime.parse(json["fechaFinal"]),
        moniSensor: json["moniSensor"],
        observacion: json["observacion"],
        tempMin: json["tempMin"],
        tempMax: json["tempMax"],
        humeMin: json["humeMin"],
        humeMax: json["humeMax"],
        humeSMin: json["humeSMin"],
        humeSMax: json["humeSMax"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_fksolar": idFksolar,
        "tipo": tipo,
        "nombre": nombre,
        "largo": largo,
        "ancho": ancho,
        "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "fechaFinal": fechaFinal == null ? null : "${fechaFinal.year.toString().padLeft(4, '0')}-${fechaFinal.month.toString().padLeft(2, '0')}-${fechaFinal.day.toString().padLeft(2, '0')}",
        "moniSensor": moniSensor,
        "observacion": observacion,
        "tempMin": tempMin,
        "tempMax": tempMax,
        "humeMin": humeMin,
        "humeMax": humeMax,
        "humeSMin": humeSMin,
        "humeSMax": humeSMax,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

class Herramienta {
    Herramienta({
        this.id,
        this.idHerramienta,
        this.status,
        this.cantidad,
        this.createdAt,
        this.updatedAt,
        this.codigo,
        this.nombre,
        this.descripcion,
    });

    int id;
    int idHerramienta;
    int status;
    int cantidad;
    DateTime createdAt;
    DateTime updatedAt;
    int codigo;
    String nombre;
    String descripcion;
    
    factory Herramienta.fromJson(Map<String, dynamic> json) => Herramienta(
        id: json["id"],
        idHerramienta: json["idHerramienta"],
        status: json["status"],
        cantidad: json["cantidad"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        codigo: json["codigo"],
        nombre: json["nombre"],
        descripcion: json["descripcion"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idHerramienta": idHerramienta,
        "status": status,
        "cantidad": cantidad,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "codigo": codigo,
        "nombre": nombre,
        "descripcion": descripcion,
    };
}

class Insumo {
    Insumo({
        this.idt,
        this.idInsumo,
        this.cantidad,
        this.createdAt,
        this.updatedAt,
        this.codigo,
        this.nombre,
        this.tipo,
    });

    int idt;
    int idInsumo;
    int cantidad;
    DateTime createdAt;
    DateTime updatedAt;
    int codigo;
    String nombre;
    String tipo;

    factory Insumo.fromJson(Map<String, dynamic> json) => Insumo(
        idt: json["idt"],
        idInsumo: json["idInsumo"],
        cantidad: json["cantidad"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        codigo: json["codigo"],
        nombre: json["nombre"],
        tipo: json["tipo"],
    );

    Map<String, dynamic> toJson() => {
        "idt": idt,
        "idInsumo": idInsumo,
        "cantidad": cantidad,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "codigo": codigo,
        "nombre": nombre,
        "tipo": tipo,
    };
}
