// To parse this JSON data, do
//
//     final trabajador = trabajadorFromJson(jsonString);

import 'dart:convert';

Trabajador trabajadorFromJson(String str) => Trabajador.fromJson(json.decode(str));

String trabajadorToJson(Trabajador data) => json.encode(data.toJson());

class Trabajador {
    Trabajador({
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
    int costoHora;
    dynamic urlImagen;
    dynamic lat;
    dynamic lng;
    String codigo;
    String verificado;
    dynamic deletedAt;

    factory Trabajador.fromJson(Map<String, dynamic> json) => Trabajador(
        id: json["id"],
        nombre: json["nombre"],
        ap: json["ap"],
        am: json["am"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        celular: json["celular"],
        rfc: json["rfc"],
        createdAt: json["updated_at"]==null?null: DateTime.parse(json["updated_at"]),
        updatedAt: json["created_at"]==null?null: DateTime.parse(json["created_at"]),
        costoHora: json["costoHora"],
        urlImagen: json["url_imagen"]==null?null:json["url_imagen"],
        lat: json["lat"]==null?null:json["lat"],
        lng: json["lng"]==null?null:json["lng"],
        codigo: json["codigo"],
        verificado: json["verificado"],
        deletedAt: json["deleted_at"]==null?null:json["deleted_at"],
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
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "costoHora": costoHora,
        "url_imagen": urlImagen,
        "lat": lat,
        "lng": lng,
        "codigo": codigo,
        "verificado": verificado,
        "deleted_at": deletedAt,
    };
}
