// To parse this JSON data, do
//
//     final compraModel = compraModelFromJson(jsonString);

import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/proveedores/proveedor.dart';

CompraModel compraModelFromJson(String str) => CompraModel.fromJson(json.decode(str));

String compraModelToJson(CompraModel data) => json.encode(data.toJson());

class CompraModel {
    CompraModel({
        this.compras,
    });

    Map<String, Compra> compras;

    factory CompraModel.fromJson(Map<String, dynamic> json) => CompraModel(
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
    double total;
    DateTime createdAt;
    DateTime updatedAt;
    List<Detalle> detalles;
    Proveedor proveedor;

    factory Compra.fromJson(Map<String, dynamic> json) => Compra(
        id: json["id"],
        idProveedor: json["id_proveedor"],
        fecha: json["fecha"]==null?null:DateTime.parse(json["fecha"]),
        total: json["total"]==null?null:json["total"].toDouble(),
        createdAt:json["created_at"]==null?null: DateTime.parse(json["created_at"]),
        updatedAt:json["updated_at"]==null?null:DateTime.parse(json["updated_at"]),
        detalles:json["detalles"]==null?null: List<Detalle>.from(json["detalles"].map((x) => Detalle.fromJson(x))),
        proveedor:json["proveedor"]==null?null: Proveedor.fromJson(json["proveedor"]),
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
        this.nombre,
        this.tipo,
        this.unidadM,
        this.idCompra,
        this.idInsumo,
        this.cantidad,
        this.precio,
        this.createdAt,
        this.updatedAt,
    });

    String nombre;
    String tipo;
    String unidadM;
    int idCompra;
    int idInsumo;
    double cantidad;
    double precio;
    DateTime createdAt;
    DateTime updatedAt;

    factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
        nombre: json["nombre"],
        tipo: json["tipo"],
        unidadM: json["unidadM"],
        idCompra: json["id_compra"],
        idInsumo: json["id_insumo"],
        cantidad: json["cantidad"]==null?null:json["cantidad"].toDouble(),
        precio: json["precio"]==null?null:json["precio"].toDouble(),
        createdAt:json["created_at"]==null?null: DateTime.parse(json["created_at"]),
        updatedAt:json["updated_at"]==null?null: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "nombre": nombre,
        "tipo": tipo,
        "unidadM" : unidadM,
        "id_compra": idCompra,
        "id_insumo": idInsumo,
        "cantidad": cantidad,
        "precio": precio,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}
