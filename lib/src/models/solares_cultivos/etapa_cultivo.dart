class Etapa {
    Etapa({
        this.nombre,
        this.idc,
        this.orden,
        this.dias,
        this.createdAt,
        this.updatedAt,
    });
    
    String uniqueKey;


    String nombre;
    int idc;
    int orden;
    int dias;
    DateTime createdAt;
    DateTime updatedAt;

    factory Etapa.fromJson(Map<String, dynamic> json) => Etapa(
        nombre: json["nombre"],
        idc: json["idc"],
        orden: json["orden"]==null?null:json["orden"],
        dias: json["dias"]==null?null:json["dias"],
        createdAt: json["created_at"]==null?null: DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"]==null?null: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "idc": idc,
        "orden": orden,
        "dias": dias,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
