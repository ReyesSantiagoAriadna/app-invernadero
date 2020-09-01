// To parse this JSON data, do
//
//     final oferta = ofertaFromJson(jsonString);

import 'dart:convert';

Oferta ofertaFromJson(String str) => Oferta.fromJson(json.decode(str));

String ofertaToJson(Oferta data) => json.encode(data.toJson());

class Oferta {
    Oferta({
        this.id,
        this.idTipo,
        this.tipo,
        this.idProducto,
        this.producto,
        this.descripcion,
        this.inicio,
        this.fin,
        this.estado,
        this.urlImagen,
    });

    int id;
    int idTipo;
    String tipo;
    int idProducto;
    String producto;
    String descripcion;
    String inicio;
    String fin;
    String estado;
    String urlImagen;

    factory Oferta.fromJson(Map<String, dynamic> json) => Oferta(
        id: json["id"],
        idTipo: json["idTipo"],
        tipo: json["tipo"],
        idProducto: json["idProducto"],
        producto: json["producto"],
        descripcion: json["descripcion"]==null?null:json["descripcion"],
        inicio: json["inicio"],
        fin: json["fin"],
        estado: json["estado"]==null?null:json["estado"],
        urlImagen: json["url_imagen"]==null?null:json["url_imagen"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idTipo": idTipo,
        "tipo": tipo,
        "idProducto": idProducto,
        "producto": producto,
        "descripcion": descripcion,
        "inicio": inicio,
        "fin": fin,
        "estado": estado,
        "url_imagen": urlImagen,
    };
}
