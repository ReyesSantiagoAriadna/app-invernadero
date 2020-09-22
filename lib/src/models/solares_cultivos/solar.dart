import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';

class Solar {
    Solar({
        this.id,
        this.nombre,
        this.largo,
        this.ancho,
        this.region,
        this.distrito,
        this.municipio,
        this.latitud,
        this.longitud,
        this.descripcion,
        this.createdAt,
        this.updatedAt,
        this.deletedAt,
        this.cultivos,
    });

    int id;
    String nombre;
    double largo;
    double ancho;
    String region;
    String distrito;
    String municipio;
    double latitud;
    double longitud;
    String descripcion;
    DateTime createdAt;
    DateTime updatedAt;
    DateTime deletedAt;
    List<Cultivo> cultivos;

    double m2Libres;


    factory Solar.fromJson(Map<String, dynamic> json) => Solar(
        id: json["id"],
        nombre: json["nombre"],
        largo:json["largo"]==null?0.0: json["largo"].toDouble(),
        ancho:json["ancho"]==null?0.0: json["ancho"].toDouble(),
        region: json["region"],
        distrito: json["distrito"],
        municipio: json["municipio"],
        latitud: json["latitud"]==null?0.0:json["latitud"].toDouble(),
        longitud: json["longitud"]==null?0.0:json["longitud"].toDouble(),
        descripcion: json["descripcion"],
        createdAt:json["created_at"]==null?null: DateTime.parse(json["created_at"]),
        updatedAt:json["updated_at"]==null?null: DateTime.parse(json["updated_at"]),
        deletedAt: json["deleted_at"] == null ? null : DateTime.parse(json["deleted_at"]),
        cultivos:json["cultivos"]==null?null: List<Cultivo>.from(json["cultivos"].map((x) => Cultivo.fromJson(x))),
    );
    
    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "largo": largo,
        "ancho": ancho,
        "region": region,
        "distrito": distrito,
        "municipio": municipio,
        "latitud": latitud,
        "longitud": longitud,
        "descripcion": descripcion,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "deleted_at": deletedAt == null ? null : deletedAt.toIso8601String(),
        "cultivos": List<dynamic>.from(cultivos.map((x) => x.toJson())),
    };
}