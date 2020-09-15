// To parse this JSON data, do
//
//     final pedidosModel = pedidosModelFromJson(jsonString);

import 'dart:convert';

PedidosModel pedidosModelFromJson(String str) => PedidosModel.fromJson(json.decode(str));

String pedidosModelToJson(PedidosModel data) => json.encode(data.toJson());

class PedidosModel {
    PedidosModel({
        this.pedidos,
    });

    Map<String, Pedido> pedidos;

    factory PedidosModel.fromJson(Map<String, dynamic> json) => PedidosModel(
        pedidos: Map.from(json["pedidos"]).map((k, v) => MapEntry<String, Pedido>(k, Pedido.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "pedidos": Map.from(pedidos).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

class Pedido {
    Pedido({
        this.id,
        this.idCliente,
        this.fechaSolicitud,
        this.estatus,
        this.total,
        this.createdAt,
        this.updatedAt,
        this.idVenta,
        this.totalPagado,
        this.tipoEntrega,
        this.detalles,
        this.cliente
    });

    int id;
    int idCliente;
    DateTime fechaSolicitud;
    String estatus;
    int total;
    DateTime createdAt;
    DateTime updatedAt;
    int idVenta;
    double totalPagado;
    String tipoEntrega;
    List<Detalle> detalles;
    Cliente cliente;
    bool isNew=false;
    factory Pedido.fromJson(Map<String, dynamic> json) => Pedido(
        id: json["id"],
        idCliente: json["id_cliente"],
        fechaSolicitud: DateTime.parse(json["fechaSolicitud"]),
        estatus: json["estatus"],
        total:json["total"]==null?null: json["total"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
        idVenta: json["idVenta"] == null ? null : json["idVenta"],
        totalPagado:json["totalPagado"]==null?null: json["totalPagado"].toDouble(),
        tipoEntrega: json["tipo_entrega"],
        detalles: json["detalles"]==null?null: List<Detalle>.from(json["detalles"].map((x) => Detalle.fromJson(x))),
        cliente: json["cliente"]==null?null: Cliente.fromJson(json["cliente"]),
    );

    
    Map<String, dynamic> toJson() => {
        "id": id,
        "id_cliente": idCliente,
        "fechaSolicitud": "${fechaSolicitud.year.toString().padLeft(4, '0')}-${fechaSolicitud.month.toString().padLeft(2, '0')}-${fechaSolicitud.day.toString().padLeft(2, '0')}",
        "estatus": estatus,
        "total": total,
        "created_at": createdAt == null ? null : "${createdAt.year.toString().padLeft(4, '0')}-${createdAt.month.toString().padLeft(2, '0')}-${createdAt.day.toString().padLeft(2, '0')}",
        "updated_at": updatedAt == null ? null : "${updatedAt.year.toString().padLeft(4, '0')}-${updatedAt.month.toString().padLeft(2, '0')}-${updatedAt.day.toString().padLeft(2, '0')}",
        "idVenta": idVenta == null ? null : idVenta,
        "totalPagado": totalPagado,
        "tipo_entrega": tipoEntrega,
        "detalles": List<dynamic>.from(detalles.map((x) => x.toJson())),
        "cliente": cliente.toJson(),
    };
}

class Cliente {
    Cliente({
        this.id,
        this.nombre,
        this.ap,
        this.am,
        this.direccion,
        this.telefono,
        this.celular,
        this.rfc,
        this.urlImagen,
        this.lat,
        this.lng,
        this.correo,
    });

    int id;
    String nombre;
    String ap;
    String am;
    String direccion;
    String telefono;
    String celular;
    String rfc;
    String urlImagen;
    double lat;
    double lng;
    String correo;

    factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json["id"],
        nombre: json["nombre"],
        ap: json["ap"],
        am: json["am"],
        direccion: json["direccion"],
        telefono: json["telefono"] == null ? null : json["telefono"],
        celular: json["celular"],
        rfc: json["rfc"] == null ? null : json["rfc"],
        urlImagen: json["url_imagen"] == null ? null : json["url_imagen"],
        lat: json["lat"]==null?null: json["lat"].toDouble(),
        lng: json["lng"]==null?null:json["lng"].toDouble(),
        correo: json["correo"] == null ? null : json["correo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "ap": ap,
        "am": am,
        "direccion": direccion,
        "telefono": telefono == null ? null : telefono,
        "celular": celular,
        "rfc": rfc == null ? null : rfc,
        "url_imagen": urlImagen == null ? null : urlImagen,
        "lat": lat,
        "lng": lng,
        "correo": correo == null ? null : correo,
    };
}

class Detalle {
    Detalle({
        this.idPedido,
        this.nombreProducto,
        this.cantidadPedido,
        this.cantidadSurtida,
        this.idProducto,
        this.unidadM,
        this.precioUnitario,
        this.subtotal,
    });

    int idPedido;
    String nombreProducto;
    double cantidadPedido;
    double cantidadSurtida;
    int idProducto;
    String unidadM;
    double precioUnitario;
    double subtotal;

    factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
        idPedido: json["idPedido"],
        nombreProducto: json["nombreProducto"],
        cantidadPedido: json["cantidadPedido"].toDouble(),
        cantidadSurtida: json["cantidadSurtida"].toDouble(),
        idProducto: json["idProducto"],
        unidadM: json["unidadM"] == null ? null : json["unidadM"],
        precioUnitario: json["precioUnitario"].toDouble(),
        subtotal: json["subtotal"].toDouble(),
    );

    Map<String, dynamic> toJson() => {
        "idPedido": idPedido,
        "nombreProducto": nombreProducto,
        "cantidadPedido": cantidadPedido,
        "cantidadSurtida": cantidadSurtida,
        "idProducto": idProducto,
        "unidadM": unidadM == null ? null : unidadM,
        "precioUnitario": precioUnitario,
        "subtotal": subtotal,
    };
}
