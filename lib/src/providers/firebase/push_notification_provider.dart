import 'dart:async';
import 'dart:convert';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/employee/tareas_trabajador_model.dart';
import 'package:app_invernadero_trabajador/src/models/pedidos/pedido_model.dart';
import 'package:app_invernadero_trabajador/src/services/employee/tasks_services.dart';
import 'package:app_invernadero_trabajador/src/services/notifications/notifications_service.dart';
import 'package:app_invernadero_trabajador/src/services/pedidos/pedidos_service.dart';
import 'package:app_invernadero_trabajador/src/services/tasks/task_services.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationProvider{

  

  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  
  final _mensajeStreamController = StreamController<String>();
  final _messageController = new BehaviorSubject<String>();
  Stream get messageStream => _messageController.stream;
  Function(String) get onChangeMessage => _messageController.sink.add;

  static bool isNotified=false;

  dispose(){
    _mensajeStreamController.close();
    _messageController.close();
  }

  
  static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) async {
    // if (message.containsKey('data')) {
    //   // Handle data message
    //   final dynamic data = message['data'];
    // }

    // if (message.containsKey('notification')) {
    //   // Handle notification message
    //   final dynamic notification = message['notification'];
    // }

  // Or do other work.
  }


  initNotifications()async{
    await _firebaseMessaging.requestNotificationPermissions();
    final token = await _firebaseMessaging.getToken();
    print("===============FCM TOKEN ==================");
    print(token);


    _firebaseMessaging.configure(
      onMessage: onMessage,
      onBackgroundMessage: onBackgroundMessage,
      onLaunch: onLaunch,
      onResume: onResume,
    );
  }

  Future<dynamic> onMessage(Map<String, dynamic> message) async{
    if(!isNotified){
      print("=======on message========"); //ap en primer plano
      print("mensaje $message");
      NotificationsService.instance.getNotifications();
      Map data = message['data'];
      if(data!=null){
        _toProcessData(data);
      }
    }
   
    isNotified = !isNotified; 

  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async{
    if(!isNotified){
      print("=======on onLaunch========");
      print("mensaje $message");
      NotificationsService.instance.getNotifications();
      Map data = message['data'];
      if(data!=null){
        _toProcessData(data);
      }
    }
    
    isNotified = !isNotified; 
  }
  Future<dynamic> onResume(Map<String, dynamic> message) async{
    if(!isNotified){
      print("=======on onResume========"); //volviendo del bakground
      print("mensaje $message");
      NotificationsService.instance.getNotifications();
      Map data = message['data'];
      if(data!=null){
        _toProcessData(data);
      }
    }

    isNotified = !isNotified; 
  }
  
  _toProcessData(dynamic data){
    print("===========TIPO DE NOTIFCACION ${data['tipo']}");
    switch (data['tipo']){
      case AppConfig.fcm_type_pedido:  //tipo pedido
        if(data['pedido']!=null){
          _processPedido(data);
        }
      
      break;
      case AppConfig.fcm_type_tarea_personal: //tipo tarea personal
        if(data['tarea_personal']!=null){
          _processTareaPersonal(data);
        }
      break;
      default:

      break;
    }
  }


  _processPedido(dynamic data){
    Pedido p = Pedido.fromJson(json.decode(data['pedido']));
    switch(data['event']){
      case AppConfig.event_created:
        PedidosService.instance.addPedido(p);
      break;

      case AppConfig.event_updated:

      break;
    } 
  }

  _processTareaPersonal(dynamic data){
    TareasTrabajadorElement task;
    switch(data['event']){
      case AppConfig.event_created:
        task = TareasTrabajadorElement.fromJson(json.decode(data['tarea_personal'])); 
        TasksEmployeeService.instance.addTask(task);
      break;
      case AppConfig.event_updated:
        TasksEmployeeService.instance.updatedTask(task);
      break;
      case AppConfig.event_updated_to_admin:
        task = TareasTrabajadorElement.fromJsonToAdmins(json.decode(data['tarea_personal'])); 
        TaskService.instance.updatedTask(task);
      break;
    } 
  }




  subscribeToTopic(String topic){
    print("*********SUBCRIBIENDOSE A TOPIC $topic *********");
    _firebaseMessaging.subscribeToTopic(topic);
  }
  
  unsubscribeFromTopic(String topic){
    _firebaseMessaging.unsubscribeFromTopic(topic);
  }

  deleteToken(){
    print(">>>== DELETE TOKEN ==>>");
    _firebaseMessaging.deleteInstanceID();
    print(">>>>=====>>>>");
  }
}