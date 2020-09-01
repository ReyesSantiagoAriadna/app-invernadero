// To parse this JSON data, do
//
//     final ofertaTipo = ofertaTipoFromJson(jsonString);

import 'dart:convert';

OfertaTipo ofertaTipoFromJson(String str) => OfertaTipo.fromJson(json.decode(str));

String ofertaTipoToJson(OfertaTipo data) => json.encode(data.toJson());

class OfertaTipo {
    OfertaTipo({
        this.id,
        this.tipo,
        this.valor,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String tipo;
    int valor;
    DateTime createdAt;
    DateTime updatedAt;

    factory OfertaTipo.fromJson(Map<String, dynamic> json) => OfertaTipo(
        id: json["id"],
        tipo: json["tipo"],
        valor: json["valor"],
        createdAt: json["created_at"]==null?null: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"]==null?null:DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "tipo": tipo,
        "valor": valor,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
