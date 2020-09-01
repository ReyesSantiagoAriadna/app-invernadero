// To parse this JSON data, do
//
//     final plagas = plagasFromJson(jsonString);

import 'dart:convert';

Plagas plagasFromJson(String str) => Plagas.fromJson(json.decode(str));

String plagasToJson(Plagas data) => json.encode(data.toJson());

class Plagas {
    Plagas({
        this.id,
        this.idSolar,
        this.idCultivo,
        this.nombreCultivo,
        this.nombre,
        this.fecha,
        this.observacion,
        this.tratamiento,
        this.urlImagen,
    });

    int id;
    int idSolar;
    int idCultivo;
    String nombreCultivo;
    String nombre;
    String fecha;
    String observacion;
    String tratamiento;
    String urlImagen;

    factory Plagas.fromJson(Map<String, dynamic> json) => Plagas(
        id: json["id"],
        idSolar: json["id_solar"],
        idCultivo: json["id_Cultivo"],
        nombreCultivo: json["nombreCultivo"],
        nombre: json["nombre"],
        fecha: json["fecha"],
        observacion: json["observacion"],
        tratamiento: json["tratamiento"],
        urlImagen: json["url_imagen"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_solar": idSolar,
        "id_Cultivo": idCultivo,
        "nombreCultivo": nombreCultivo,
        "nombre": nombre,
        "fecha":  fecha,
        "observacion": observacion,
        "tratamiento": tratamiento,
        "url_imagen": urlImagen,
    };
}
