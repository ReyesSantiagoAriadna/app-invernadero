// To parse this JSON data, do
//
//     final ventasModel = ventasModelFromJson(jsonString);

import 'dart:convert';

VentasModel ventasModelFromJson(String str) => VentasModel.fromJson(json.decode(str));

String ventasModelToJson(VentasModel data) => json.encode(data.toJson());

class VentasModel {
    VentasModel({
        this.ventas,
    });

    Map<String, Venta> ventas;

    factory VentasModel.fromJson(Map<String, dynamic> json) => VentasModel(
        ventas: Map.from(json["ventas"]).map((k, v) => MapEntry<String, Venta>(k, Venta.fromJson(v))),
    );

    Map<String, dynamic> toJson() => {
        "ventas": Map.from(ventas).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };
}

class Venta {
    Venta({
        this.id,
        this.idPersonal,
        this.idCliente,
        this.total,
        this.createdAt,
        this.updatedAt,
        this.detalles,
        this.cliente,
        this.personal,
    });

    int id;
    int idPersonal;
    int idCliente;
    int total;
    String createdAt;
    String updatedAt;
    List<Detalle> detalles;
    Cliente cliente;
    Personal personal;

    factory Venta.fromJson(Map<String, dynamic> json) => Venta(
        id: json["id"],
        idPersonal: json["idPersonal"],
        idCliente: json["idCliente"],
        total: json["total"],
        createdAt:  json["created_at"],
        updatedAt: json["updated_at"],
        detalles: List<Detalle>.from(json["detalles"].map((x) => Detalle.fromJson(x))),
        cliente: Cliente.fromJson(json["cliente"]),
        personal: Personal.fromJson(json["personal"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "idPersonal": idPersonal,
        "idCliente": idCliente,
        "total": total,
        "created_at": createdAt,
        "updated_at": updatedAt,
        "detalles": List<dynamic>.from(detalles.map((x) => x.toJson())),
        "cliente": cliente.toJson(),
        "personal": personal.toJson(),
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
    dynamic telefono;
    String celular;
    dynamic rfc;
    dynamic urlImagen;
    double lat;
    double lng;
    dynamic correo;

    factory Cliente.fromJson(Map<String, dynamic> json) => Cliente(
        id: json["id"],
        nombre: json["nombre"],
        ap: json["ap"] == null ? null : json["ap"],
        am: json["am"] == null ? null : json["am"],
        direccion: json["direccion"] == null ? null : json["direccion"],
        telefono: json["telefono"],
        celular: json["celular"],
        rfc: json["rfc"],
        urlImagen: json["url_imagen"],
        lat: json["lat"].toDouble(),
        lng: json["lng"].toDouble(),
        correo: json["correo"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "ap": ap == null ? null : ap,
        "am": am == null ? null : am,
        "direccion": direccion == null ? null : direccion,
        "telefono": telefono,
        "celular": celular,
        "rfc": rfc,
        "url_imagen": urlImagen,
        "lat": lat,
        "lng": lng,
        "correo": correo,
    };
}

class Detalle {
    Detalle({
        this.id,
        this.codigoProducto,
        this.nombre,
        this.unidadM,
        this.precioU,
        this.cantidad,
        this.subtotal,
        this.createdAt,
        this.updatedAt,
    });

    int id;
    int codigoProducto;
    String nombre;
    String unidadM;
    int precioU;
    int cantidad;
    int subtotal;
    DateTime createdAt;
    DateTime updatedAt;

    factory Detalle.fromJson(Map<String, dynamic> json) => Detalle(
        id: json["id"],
        codigoProducto: json["codigoProducto"],
        nombre: json["nombre"],
        unidadM: json["unidadM"],
        precioU: json["precioU"],
        cantidad: json["cantidad"],
        subtotal: json["subtotal"],
        createdAt: json["created_at"] == null ? null : DateTime.parse(json["created_at"]),
        updatedAt: json["updated_at"] == null ? null : DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "codigoProducto": codigoProducto,
        "nombre": nombre,
        "unidadM": unidadM,
        "precioU": precioU,
        "cantidad": cantidad,
        "subtotal": subtotal,
        "created_at": createdAt == null ? null : createdAt.toIso8601String(),
        "updated_at": updatedAt == null ? null : updatedAt.toIso8601String(),
    };
}

class Personal {
    Personal({
        this.id,
        this.nombre,
        this.ap,
        this.am,
        this.direccion,
        this.telefono,
        this.celular,
        this.rfc,
        this.createdAt,
        this.updatedAt,
        this.costoHora,
        this.urlImagen,
        this.lat,
        this.lng,
        this.codigo,
        this.verificado,
        this.deletedAt,
        this.rol,
    });

    int id;
    String nombre;
    String ap;
    String am;
    String direccion;
    String telefono;
    String celular;
    String rfc;
    DateTime createdAt;
    DateTime updatedAt;
    int costoHora;
    String urlImagen;
    dynamic lat;
    dynamic lng;
    String codigo;
    String verificado;
    dynamic deletedAt;
    String rol;

    factory Personal.fromJson(Map<String, dynamic> json) => Personal(
        id: json["id"],
        nombre: json["nombre"],
        ap: json["ap"],
        am: json["am"],
        direccion: json["direccion"],
        telefono: json["telefono"],
        celular: json["celular"],
        rfc: json["rfc"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
        costoHora: json["costoHora"],
        urlImagen: json["url_imagen"],
        lat: json["lat"],
        lng: json["lng"],
        codigo: json["codigo"],
        verificado: json["verificado"],
        deletedAt: json["deleted_at"],
        rol: json["rol"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "nombre": nombre,
        "ap": ap,
        "am": am,
        "direccion": direccion,
        "telefono": telefono,
        "celular": celular,
        "rfc": rfc,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "costoHora": costoHora,
        "url_imagen": urlImagen,
        "lat": lat,
        "lng": lng,
        "codigo": codigo,
        "verificado": verificado,
        "deleted_at": deletedAt,
        "rol": rol,
    };

}
