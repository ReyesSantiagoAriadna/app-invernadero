

import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/notifications/notificacion.dart';
import 'package:app_invernadero_trabajador/src/models/notifications/notification_model.dart';
import 'package:app_invernadero_trabajador/src/providers/hive/hive_provider.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http; 
import 'package:http_parser/http_parser.dart';

class NotificationsEmployeeProvider{
  SecureStorage _storage = SecureStorage();
  HiveProvider hiveProvider = HiveProvider();

  bool _isLoading = false;
  Future<List<Notificacion>> unReadNotifications()async{
    if(_isLoading)return[];
    _isLoading=true;

    final url = "${AppConfig.base_url}/api/personal/unread_notifications"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

   
    if(response.body.contains('error')){
      _isLoading=false;
      return [];
    } 
    print("***********NOTIFICACIONES NO LEIDAS RESPUESTA-**************");
     print(response.body); 
    if(response.body.contains("notificaciones") && response.body.contains("id")){
      final NotificationModel notificationModel  = NotificationModel.fromJson(json.decode(response.body));
      
      // hiveProvider.insertNotification(notificationModel.notificaciones);
      notificationModel.notificaciones.forEach((k,v){
        hiveProvider.inserNotification(v);
      });
       _isLoading=false;
      return notificationModel.notificaciones.values.toList();
    }
     _isLoading=false;
    return [];
  }
  //mark_as_read_notifications

  Future<bool> markAsReadNotifications()async{
    final url = "${AppConfig.base_url}/api/personal/mark_as_read_notifications"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};

    final response = await http.post(
      url, 
      headers: headers,);
    print(response.body); 
    if(response.statusCode!=200){
      return false;
    } 
    if(response.statusCode==200){
      return true;
    }
    return false;
  }

 

}