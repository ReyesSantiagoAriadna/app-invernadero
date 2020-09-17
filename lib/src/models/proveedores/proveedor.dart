// To parse this JSON data, do
//
//     final proveedor = proveedorFromJson(jsonString);

import 'dart:convert';

Proveedor proveedorFromJson(String str) => Proveedor.fromJson(json.decode(str));

String proveedorToJson(Proveedor data) => json.encode(data.toJson());

class Proveedor {
    Proveedor({
        this.id,
        this.rs,
        this.telefono,
        this.celular,
        this.email,
        this.direccion,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    String rs;
    String telefono;
    String celular;
    String email;
    String direccion;
    String createdAt;
    String updatedAt;

    factory Proveedor.fromJson(Map<String, dynamic> json) => Proveedor(
        id: json["id"],
        rs: json["rs"],
        telefono: json["telefono"],
        celular: json["celular"],
        email: json["email"],
        direccion: json["direccion"],
        createdAt: json["created_at"],
        updatedAt: json["updated_at"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "rs": rs,
        "telefono": telefono,
        "celular": celular,
        "email": email,
        "direccion": direccion,
        "created_at": createdAt,
        "updated_at": updatedAt,
    };
}
