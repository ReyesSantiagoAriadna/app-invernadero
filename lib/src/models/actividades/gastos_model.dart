// To parse this JSON data, do
//
//     final gastosModel = gastosModelFromJson(jsonString);

import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';

import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart' as herr;


GastosModel gastosModelFromJson(String str) => GastosModel.fromJson(json.decode(str));

String gastosModelToJson(GastosModel data) => json.encode(data.toJson());

class GastosModel {
    GastosModel({
        this.gastos,
    });

    Map<String, Gasto> gastos;

    factory GastosModel.fromJson(Map<String, dynamic> json) => GastosModel(
        gastos: Map.from(json["gastos"]).map((k, v) => MapEntry<String, Gasto>(k, Gasto.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "gastos": Map.from(gastos).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

class Gasto {
    Gasto({
        this.id,
        this.idFkcultivo,
        this.fecha,
        this.costo,
        this.descripcion,
        this.createdAt,
        this.updatedAt,
        this.idHerramienta,
        this.idPersonal,
        this.cultivo,
        this.herramienta,
        this.personal,
    });

    int id;
    int idFkcultivo;
    DateTime fecha;
    dynamic costo;
    String descripcion;
    DateTime createdAt;
    DateTime updatedAt;
    int idHerramienta;
    int idPersonal;
    Cultivo cultivo;
    herr.Herramienta herramienta;
    Personal personal;

    factory Gasto.fromJson(Map<String, dynamic> json) => Gasto(
        id: json["id"],
        idFkcultivo: json["id_fkcultivo"],
        fecha: DateTime.parse(json["fecha"]),
        costo: json["costo"],
        descripcion: json["descripcion"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        idHerramienta: json["id_herramienta"] == null ? null : json["id_herramienta"],
        idPersonal: json["id_personal"] == null ? null : json["id_personal"],
        cultivo: Cultivo.fromJson(json["cultivo"]),
        herramienta: json["herramienta"] == null ? null :herr.Herramienta.fromJson(json["herramienta"]),
        personal: json["personal"] == null ? null : Personal.fromJson(json["personal"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_fkcultivo": idFkcultivo,
        "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "costo": costo,
        "descripcion": descripcion,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "id_herramienta": idHerramienta == null ? null : idHerramienta,
        "id_personal": idPersonal == null ? null : idPersonal,
        "cultivo": cultivo.toJson(),
        "herramienta": herramienta == null ? null : herramienta.toJson(),
        "personal": personal == null ? null : personal.toJson(),
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

    factory Personal.fromJson(Map<String, dynamic> json) => Personal(
        id: json["id"],
        nombre: json["nombre"],
        ap: json["ap"],
        am: json["am"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        celular: json["celular"],
        rfc: json["rfc"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        costoHora: json["costoHora"] == null ? null : json["costoHora"].toDouble(),
        urlImagen: json["url_imagen"] == null ? null : json["url_imagen"],
        lat: json["lat"] == null ? null : json["lat"].toDouble(),
        lng: json["lng"] == null ? null : json["lng"].toDouble(),
        codigo: json["codigo"] == null ? null : json["codigo"],
        verificado: json["verificado"],
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "ap": ap,
        "am": am,
        "direccion": direccion,
        "telefono": telefono,
        "celular": celular,
        "rfc": rfc,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
        "costoHora": costoHora == null ? null : costoHora,
        "url_imagen": urlImagen == null ? null : urlImagen,
        "lat": lat == null ? null : lat,
        "lng": lng == null ? null : lng,
        "codigo": codigo == null ? null : codigo,
        "verificado": verificado,
        "deleted_at": deletedAt == null ? null : deletedAt.toIso8601String(),
    };
}
