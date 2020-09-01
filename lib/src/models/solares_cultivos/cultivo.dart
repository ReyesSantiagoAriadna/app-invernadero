import 'package:app_invernadero_trabajador/src/models/solares_cultivos/etapa_cultivo.dart';

class Cultivo {
    Cultivo({
        this.id,
        this.idFksolar,
        this.tipo,
        this.nombre,
        this.largo,
        this.ancho,
        this.fecha,
        this.fechaFinal,
        this.moniSensor,
        this.observacion,
        this.tempMin,
        this.tempMax,
        this.humeMin,
        this.humeMax,
        this.humeSMin,
        this.humeSMax,
        this.createdAt,
        this.updatedAt,
        this.etapas,
    });

    int id;               
    int idFksolar;
    String tipo;
    String nombre;
    double largo;
    double ancho;
    DateTime fecha;
    DateTime fechaFinal;
    int moniSensor;
    String observacion;
    int tempMin;
    int tempMax;
    int humeMin;
    int humeMax;
    int humeSMin;
    int humeSMax;
    DateTime createdAt;
    DateTime updatedAt;
    List<Etapa> etapas;

    
    factory Cultivo.fromJson(Map<String, dynamic> json) => Cultivo(
        id: json["id"],
        idFksolar: json["id_fksolar"],
        tipo: json["tipo"],
        nombre: json["nombre"],
        largo: json["largo"] == null ? 0.0 : json["largo"].toDouble(),
        ancho: json["ancho"] == null ? 0.0 : json["ancho"].toDouble(),
        fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
        fechaFinal:json["fechaFinal"]==null?null: DateTime.parse(json["fechaFinal"]),
        moniSensor: json["moniSensor"] ==null? null: json["moniSensor"],
        observacion: json["observacion"],
        tempMin: json["tempMin"] == null ? 0 : json["tempMin"],
        tempMax: json["tempMax"] == null ? 0 : json["tempMax"],
        humeMin: json["humeMin"] == null ? 0 : json["humeMin"],
        humeMax: json["humeMax"] == null ? 0 : json["humeMax"],
        humeSMin: json["humeSMin"] == null ? 0 : json["humeSMin"],
        humeSMax: json["humeSMax"] == null ? 0 : json["humeSMax"],
        createdAt:json["created_at"]==null?null: DateTime.parse(json["created_at"]),
        updatedAt:json["updated_at"]==null?null: DateTime.parse(json["updated_at"]),
        etapas: json["etapas"]==null?null: List<Etapa>.from(json["etapas"].map((x) => Etapa.fromJson(x))),
    );

    
    Map<String, dynamic> toJson() => {
        "id": id,
        "id_fksolar": idFksolar,
        "tipo": tipo,
        "nombre": nombre,
        "largo": largo,
        "ancho": ancho,
        "fecha": "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
        "fechaFinal": "${fechaFinal.year.toString().padLeft(4, '0')}-${fechaFinal.month.toString().padLeft(2, '0')}-${fechaFinal.day.toString().padLeft(2, '0')}",
        "moniSensor": moniSensor,
        "observacion": observacion,
        "tempMin": tempMin,
        "tempMax": tempMax,
        "humeMin": humeMin,
        "humeMax": humeMax,
        "humeSMin": humeSMin,
        "humeSMax": humeSMax,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
        "etapas": List<dynamic>.from(etapas.map((x) => x.toJson())),
    };
}


// class Cultivo {
//     Cultivo({
//         this.id,
//         this.idFksolar,
//         this.tipo,
//         this.nombre,
//         this.largo,
//         this.ancho,
//         this.fecha,
//         this.fechaFinal,
//         this.moniSensor,
//         this.observacion,
//         this.tempMin,
//         this.tempMax,
//         this.humeMin,
//         this.humeMax,
//         this.humeSMin,
//         this.humeSMax,
//         this.createdAt,
//         this.updatedAt,
//     });

//     int id;
//     int idFksolar;
//     String tipo;
//     String nombre;
//     double largo;
//     double ancho;
//     DateTime fecha;
//     DateTime fechaFinal;
//     int moniSensor;
//     String observacion;
//     int tempMin;
//     int tempMax;
//     int humeMin;
//     int humeMax;
//     int humeSMin;
//     int humeSMax;
//     DateTime createdAt;
//     DateTime updatedAt;

//     factory Cultivo.fromJson(Map<String, dynamic> json) => Cultivo(
//         id: json["id"],
//         idFksolar: json["id_fksolar"],
//         tipo: json["tipo"],
//         nombre: json["nombre"],
//         largo: json["largo"] == null ? 0.0 : json["largo"].toDouble(),
//         ancho: json["ancho"] == null ? 0.0 : json["ancho"].toDouble(),
//         fecha: json["fecha"] == null ? null : DateTime.parse(json["fecha"]),
//         fechaFinal: json["fechaFinal"] == null ? null : DateTime.parse(json["fechaFinal"]),
//         moniSensor: json["moniSensor"] == null ? null : json["moniSensor"],
//         observacion: json["observacion"],
//         tempMin: json["tempMin"] == null ? 0 : json["tempMin"],
//         tempMax: json["tempMax"] == null ? 0 : json["tempMax"],
//         humeMin: json["humeMin"] == null ? 0 : json["humeMin"],
//         humeMax: json["humeMax"] == null ? 0 : json["humeMax"],
//         humeSMin: json["humeSMin"] == null ? 0 : json["humeSMin"],
//         humeSMax: json["humeSMax"] == null ? 0 : json["humeSMax"],
//         createdAt: DateTime.parse(json["created_at"]),
//         updatedAt: DateTime.parse(json["updated_at"]),
//     );

//     Map<String, dynamic> toJson() => {
//         "id": id,
//         "id_fksolar": idFksolar,
//         "tipo": tipo,
//         "nombre": nombre,
//         "largo": largo == null ? null : largo,
//         "ancho": ancho == null ? null : ancho,
//         "fecha": fecha == null ? null : "${fecha.year.toString().padLeft(4, '0')}-${fecha.month.toString().padLeft(2, '0')}-${fecha.day.toString().padLeft(2, '0')}",
//         "fechaFinal": fechaFinal == null ? null : "${fechaFinal.year.toString().padLeft(4, '0')}-${fechaFinal.month.toString().padLeft(2, '0')}-${fechaFinal.day.toString().padLeft(2, '0')}",
//         "moniSensor": moniSensor == null ? null : moniSensor,
//         "observacion": observacion,
//         "tempMin": tempMin == null ? null : tempMin,
//         "tempMax": tempMax == null ? null : tempMax,
//         "humeMin": humeMin == null ? null : humeMin,
//         "humeMax": humeMax == null ? null : humeMax,
//         "humeSMin": humeSMin == null ? null : humeSMin,
//         "humeSMax": humeSMax == null ? null : humeSMax,
//         "created_at": createdAt.toIso8601String(),
//         "updated_at": updatedAt.toIso8601String(),
//     };
// }