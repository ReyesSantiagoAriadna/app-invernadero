// To parse this JSON data, do
//
//     final fechaPedidoModel = fechaPedidoModelFromJson(jsonString);

import 'dart:convert';

FechaPedidoModel fechaPedidoModelFromJson(String str) => FechaPedidoModel.fromJson(json.decode(str));

String fechaPedidoModelToJson(FechaPedidoModel data) => json.encode(data.toJson());

class FechaPedidoModel {
    FechaPedidoModel({
        this.id,
        this.fechaInicio,
        this.fechaFinal,
        this.fechaEntrega,
        this.createdAt,
        this.updatedAt,
        this.productoPedido,
    });

    int id;
    DateTime fechaInicio;
    DateTime fechaFinal;
    DateTime fechaEntrega;
    DateTime createdAt;
    DateTime updatedAt;
    List<ProductoPedido> productoPedido;

    factory FechaPedidoModel.fromJson(Map<String, dynamic> json) => FechaPedidoModel(
        id: json["id"],
        fechaInicio: DateTime.parse(json["fechaInicio"]),
        fechaFinal: DateTime.parse(json["fechaFinal"]),
        fechaEntrega: DateTime.parse(json["fechaEntrega"]),
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        productoPedido: List<ProductoPedido>.from(json["producto_pedido"].map((x) => ProductoPedido.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "fechaInicio": "${fechaInicio.year.toString().padLeft(4, '0')}-${fechaInicio.month.toString().padLeft(2, '0')}-${fechaInicio.day.toString().padLeft(2, '0')}",
        "fechaFinal": "${fechaFinal.year.toString().padLeft(4, '0')}-${fechaFinal.month.toString().padLeft(2, '0')}-${fechaFinal.day.toString().padLeft(2, '0')}",
        "fechaEntrega": "${fechaEntrega.year.toString().padLeft(4, '0')}-${fechaEntrega.month.toString().padLeft(2, '0')}-${fechaEntrega.day.toString().padLeft(2, '0')}",
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "producto_pedido": List<dynamic>.from(productoPedido.map((x) => x.toJson())),
    };
}

class ProductoPedido {
    ProductoPedido({
        this.idFechaPedido,
        this.createdAt,
        this.updatedAt,
        this.producto,
        this.idProducto,
    });

    int idFechaPedido;
    DateTime createdAt;
    DateTime updatedAt;
    String producto;
    int idProducto;

    factory ProductoPedido.fromJson(Map<String, dynamic> json) => ProductoPedido(
        idFechaPedido: json["idFechaPedido"],
        createdAt:json["created_at"]==null?null: DateTime.parse(json["created_at"]),
        updatedAt:json["updated_at"]==null?null:DateTime.parse(json["updated_at"]),
        producto: json["producto"],
        idProducto: json["id_producto"],
    );

    Map<String, dynamic> toJson() => {
        "idFechaPedido": idFechaPedido,
        "created_at": "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
        "updated_at": "${updatedAt.year.toString().padLeft(4, '0')}-${updatedAt.month.toString().padLeft(2, '0')}-${updatedAt.day.toString().padLeft(2, '0')}",
        "producto": producto,
        "id_producto": idProducto,
    };
}
