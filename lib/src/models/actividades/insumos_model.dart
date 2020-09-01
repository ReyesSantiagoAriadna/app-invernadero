// To parse this JSON data, do
//
//     final insumosModel = insumosModelFromJson(jsonString);

import 'dart:convert';

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

class Insumo {
    Insumo({
        this.id,
        this.nombre,
        this.tipo,
        this.unidadM,
        this.especie,
        this.tamano,
        this.composicion,
        this.cantidad,
        this.cantidadMinima,
        this.observacion,
        this.urlImagen,
        this.createdAt,
        this.updatedAt,
    });
    bool isSelect=false;
    int amountOnTask=0;

    int id;
    String nombre;
    String tipo;
    String unidadM;
    String especie;
    double tamano;
    String composicion;
    int cantidad;
    int cantidadMinima;
    String observacion;
    String urlImagen;
    DateTime createdAt;
    DateTime updatedAt;

    factory Insumo.fromJson(Map<String, dynamic> json) => Insumo(
        id: json["id"],
        nombre: json["nombre"],
        tipo: json["tipo"],
        unidadM: json["unidadM"],
        especie: json["especie"] == null ? null : json["especie"],
        tamano: json["tamano"] == null ? null :json["tamano"].toDouble() ,
        composicion: json["composicion"],
        cantidad: json["cantidad"],
        cantidadMinima: json["cantidadMinima"],
        observacion: json["observacion"],
        urlImagen: json["url_imagen"] == null ? null : json["url_imagen"],
        createdAt:json["created_at"]==null?null: DateTime.parse(json["created_at"]),
        updatedAt:json["updated_at"]==null?null: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "tipo": tipo,
        "unidadM": unidadM,
        "especie": especie == null ? null : especie,
        "tamano": tamano == null ? null : tamano,
        "composicion": composicion,
        "cantidad": cantidad,
        "cantidadMinima": cantidadMinima,
        "observacion": observacion,
        "url_imagen": urlImagen == null ? null : urlImagen,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
