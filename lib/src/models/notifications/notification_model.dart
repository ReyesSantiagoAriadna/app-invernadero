
import 'dart:convert';

import 'notificacion.dart';

class NotificationModel {
    NotificationModel({
        this.notificaciones,
    });
    
    Map<String, Notificacion> notificaciones;

    factory NotificationModel.fromJson(Map<String, dynamic> json) => NotificationModel(
        notificaciones: Map.from(json["notificaciones"]).map((k, v) => MapEntry<String, Notificacion>(k, Notificacion.fromJson(v))),
    );
    
    Map<String, dynamic> toJson() => {
        "notificaciones": Map.from(notificaciones).map((k, v) => MapEntry<String, dynamic>(k, v.toJson())),
    };

    NotificationModel notificationModelFromJson(String str) => NotificationModel.fromJson(json.decode(str));
    String notificationModelToJson(NotificationModel data) => json.encode(data.toJson());
}