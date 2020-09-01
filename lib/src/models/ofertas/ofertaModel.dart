// To parse this JSON data, do
//
//     final ofertaModel = ofertaModelFromJson(jsonString);

import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/ofertas/oferta.dart';

OfertaModel ofertaModelFromJson(String str) => OfertaModel.fromJson(json.decode(str));

String ofertaModelToJson(OfertaModel data) => json.encode(data.toJson());

class OfertaModel {
    OfertaModel({
        this.ofertas,
    });

    Map<String, Oferta> ofertas;

    factory OfertaModel.fromJson(Map<String, dynamic> json) => OfertaModel(
        ofertas: Map.from(json["ofertas"]).map((k, v) => MapEntry<String, Oferta>(k, Oferta.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "ofertas": Map.from(ofertas).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

 
