// To parse this JSON data, do
//
//     final tareasDate = tareasDateFromJson(jsonString);

import 'dart:convert';

TareasDate tareasDateFromJson(String str) => TareasDate.fromJson(json.decode(str));

String tareasDateToJson(TareasDate data) => json.encode(data.toJson());

class TareasDate {
    TareasDate({
        this.tareasPersonal,
    });

    Map<DateTime, List<TareasPersonal>> tareasPersonal;

    factory TareasDate.fromJson(Map<String, dynamic> json) => TareasDate(
        tareasPersonal: Map.from(json["tareas_personal"])
        .map((k, v) => MapEntry<DateTime, List<TareasPersonal>>
        (DateTime.parse(k), List<TareasPersonal>.from(v.map((x) => TareasPersonal.fromJson(x))))),
    );

    Map<String, dynamic> toJson() => {
        "tareas_personal": Map.from(tareasPersonal).map((k, v) => MapEntry<String, dynamic>(k, List<dynamic>.from(v.map((x) => x.toJson())))),
    };
}

class TareasPersonal {
    TareasPersonal({
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
    Tarea tarea;

    factory TareasPersonal.fromJson(Map<String, dynamic> json) => TareasPersonal(
        idTarea: json["id_tarea"],
        idPersonal: json["id_personal"],
        fecha: DateTime.parse(json["fecha"]),
        status: json["status"],
        consecutivo: json["consecutivo"],
        horaInicio: json["horaInicio"],
        horaFinal: json["horaFinal"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt:json["updated_at"]==null?null: DateTime.parse(json["updated_at"]),
        personal:json["personal"]==null?null:  Personal.fromJson(json["personal"]),
        tarea: json["tarea"]==null?null:Tarea.fromJson(json["tarea"]),
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
        "personal": personal.toJson(),
        "tarea": tarea.toJson(),
    };
}

class Personal {
    Personal({
        this.id,
        this.nombre,
        this.ap,
        this.am,
        this.direccion,
        this.telefono,
        this.celular,
        this.rfc,
        this.createdAt,
        this.updatedAt,
        this.costoHora,
        this.urlImagen,
        this.lat,
        this.lng,
        this.codigo,
        this.verificado,
        this.deletedAt,
        this.rol,
    });

    int id;
    String nombre;
    String ap;
    String am;
    String direccion;
    String telefono;
    String celular;
    String rfc;
    DateTime createdAt;
    DateTime updatedAt;
    double costoHora;
    String urlImagen;
    double lat;
    double lng;
    String codigo;
    String verificado;
    DateTime deletedAt;
    String rol;
    factory Personal.fromJson(Map<String, dynamic> json) => Personal(
        id: json["id"],
        nombre: json["nombre"],
        ap: json["ap"],
        am: json["am"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        celular: json["celular"],
        rfc: json["rfc"] == null ? null : json["rfc"],
        createdAt:json["created_at"]==null?null: DateTime.parse(json["created_at"]),
        updatedAt:json["updated_at"]==null?null: DateTime.parse(json["updated_at"]),
        costoHora:json["costoHora"]==null?null: json["costoHora"].toDouble(),
        urlImagen: json["url_imagen"] == null ? null : json["url_imagen"],
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lng: json["lng"] == null ? null : json["lng"].toDouble(),
        codigo: json["codigo"]==null?null:json["codigo"],
        verificado:json["verificado"]==null? null:json["verificado"],
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
    );


    factory Personal.fromJsonLogin(Map<String, dynamic> json) => Personal(
        id: json["id"],
        nombre: json["nombre"],
        ap: json["ap"],
        am: json["am"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        celular: json["celular"],
        rfc: json["rfc"] == null ? null : json["rfc"],
        createdAt:json["created_at"]==null?null: DateTime.parse(json["created_at"]),
        updatedAt:json["updated_at"]==null?null: DateTime.parse(json["updated_at"]),
        costoHora:json["costoHora"]==null?null: json["costoHora"].toDouble(),
        urlImagen: json["url_imagen"] == null ? null : json["url_imagen"],
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lng: json["lng"] == null ? null : json["lng"].toDouble(),
        codigo: json["codigo"]==null?null:json["codigo"],
        verificado:json["verificado"]==null? null:json["verificado"],
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
        rol : json["rol"]
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "ap": ap,
        "am": am,
        "direccion": direccion,
        "telefono": telefono,
        "celular": celular,
        "rfc": rfc == null ? null : rfc,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "costoHora": costoHora,
        "url_imagen": urlImagen == null ? null : urlImagen,
        "lat": lat == null ? null : lat,
        "lng": lng == null ? null : lng,
        "codigo": codigo,
        "verificado": verificado,
        "deleted_at": deletedAt == null ? null : deletedAt.toIso8601String(),
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
        createdAt:json["created_at"]==null?null: DateTime.parse(json["created_at"]),
        updatedAt:json["updated_at"]==null?null: DateTime.parse(json["updated_at"]),
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
    };
}
