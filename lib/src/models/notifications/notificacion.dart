// To parse this JSON data, do
//
//     final notificacionModel = notificacionModelFromJson(jsonString);

import 'dart:convert';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:hive/hive.dart';

import 'data.dart'; 
part 'notificacion.g.dart';


@HiveType(
  typeId: AppConfig.hive_type1, adapterName: AppConfig.hive_adapter_name_1)

class Notificacion{
    Notificacion({
        this.id,
        this.type,
        this.notifiableType,
        this.notifiableId,
        this.data,
        this.readAt,
        this.createdAt,
        this.updatedAt,
    });
    @HiveField(0)
    String id;
    @HiveField(1)
    String type;
    @HiveField(2)
    String notifiableType;
    @HiveField(3)
    int notifiableId;
    @HiveField(4)
    Data data;
    @HiveField(5)
    dynamic readAt;
    @HiveField(6)
    DateTime createdAt;
    @HiveField(7)
    DateTime updatedAt;

    
    factory Notificacion.fromJson(Map<String, dynamic> json) => Notificacion(
        id: json["id"],
        type: json["type"],
        notifiableType: json["notifiable_type"],
        notifiableId: json["notifiable_id"],
        data: Data.fromJson(json["data"]),
        readAt: json["read_at"],
        createdAt: DateTime.parse(json["created_at"]),
        updatedAt: DateTime.parse(json["updated_at"]),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "notifiable_type": notifiableType,
        "notifiable_id": notifiableId,
        "data": data.toJson(),
        "read_at": readAt,
        "created_at": createdAt.toIso8601String(),
        "updated_at": updatedAt.toIso8601String(),
    };
}


