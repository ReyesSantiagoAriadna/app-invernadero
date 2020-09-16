// To parse this JSON data, do
//
//     final comprasModel = comprasModelFromJson(jsonString);

import 'dart:convert';

ComprasModel comprasModelFromJson(String str) => ComprasModel.fromJson(json.decode(str));

String comprasModelToJson(ComprasModel data) => json.encode(data.toJson());

class ComprasModel {
    ComprasModel({
        this.compras,
    });

    Map<String, Compra> compras;

    factory ComprasModel.fromJson(Map<String, dynamic> json) => ComprasModel(
        compras: Map.from(json["compras"]).map((k, v) => MapEntry<String, Compra>(k, Compra.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "compras": Map.from(compras).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

class Compra {
    Compra({
        this.id,
        this.idProveedor,
        this.fecha,
        this.total,
        this.createdAt,
        this.updatedAt,
        this.detalles,
        this.proveedor,
    });

    int id;
    int idProveedor;
    DateTime fecha;
    int total;
    DateTime createdAt;
    DateTime updatedAt;
    List<Detalle> detalles;
    Proveedor proveedor;

    factory Compra.fromJson(Map<String, dynamic> json) => Compra(
        id: json["id"],
        idProveedor: json["id_proveedor"],
        fecha: DateTime.parse(json["fecha"]),
        total: json["total"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        detalles: List<Detalle>.from(json["detalles"].map((x) => Detalle.fromJson(x))),
        proveedor: Proveedor.fromJson(json["proveedor"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "id_proveedor": idProveedor,
        "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "total": total,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "detalles": List<dynamic>.from(detalles.map((x) => x.toJson())),
        "proveedor": proveedor.toJson(),
    };
}

class Detalle {
    Detalle({
        this.idCompra,
        this.idInsumo,
        this.cantidad,
        this.precio,
        this.createdAt,
        this.updatedAt,
    });

    int idCompra;
    int idInsumo;
    int cantidad;
    int precio;
    DateTime createdAt;
    DateTime updatedAt;

    factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
        idCompra: json["id_compra"],
        idInsumo: json["id_insumo"],
        cantidad: json["cantidad"],
        precio: json["precio"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id_compra": idCompra,
        "id_insumo": idInsumo,
        "cantidad": cantidad,
        "precio": precio,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}

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
    DateTime createdAt;
    DateTime updatedAt;

    factory Proveedor.fromJson(Map<String, dynamic> json) => Proveedor(
        id: json["id"],
        rs: json["rs"]==null?"":json["telefono"],
        telefono: json["telefono"]==null?"":json["telefono"],
        celular: json["celular"]==null?"":json["celular"],
        email: json["email"]==null?"":json["email"],
        direccion: json["direccion"]==null?"":json["direccion"],
        createdAt: json["created_at"]==null?null:  DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"]==null?null:  DateTime.parse(json["updated_at"])
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "rs": rs,
        "telefono": telefono,
        "celular": celular,
        "email": email,
        "direccion": direccion,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
