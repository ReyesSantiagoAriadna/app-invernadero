// To parse this JSON data, do
//
//     final regionesModel = regionesModelFromJson(jsonString);

import 'dart:convert';

RegionesModel regionesModelFromJson(String str) => RegionesModel.fromJson(json.decode(str));

String regionesModelToJson(RegionesModel data) => json.encode(data.toJson());

class RegionesModel {
    RegionesModel({
        this.regiones,
    });

    List<Region> regiones;

    factory RegionesModel.fromJson(Map<String, dynamic> json) => RegionesModel(
        regiones: List<Region>.from(json["regiones"].map((x) => Region.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "regiones": List<dynamic>.from(regiones.map((x) => x.toJson())),
    };
}

class Region {
    Region({
        this.region,
        this.distritos,
    });

    String region;
    List<Distrito> distritos;

    factory Region.fromJson(Map<String, dynamic> json) => Region(
        region: json["region"],
        distritos: List<Distrito>.from(json["distritos"].map((x) => Distrito.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "region": region,
        "distritos": List<dynamic>.from(distritos.map((x) => x.toJson())),
    };
}

class Distrito {
    Distrito({
        this.region,
        this.distrito,
        this.municipios,
    });

    String region;
    String distrito;
    List<String> municipios;

    factory Distrito.fromJson(Map<String, dynamic> json) => Distrito(
        region: json["region"],
        distrito: json["distrito"],
        municipios: json["municipios"] == null ? null : List<String>.from(json["municipios"].map((x) => x)),
    );

    Map<String, dynamic> toJson() => {
        "region": region,
        "distrito": distrito,
        "municipios": municipios == null ? null : List<dynamic>.from(municipios.map((x) => x)),
    };
}
