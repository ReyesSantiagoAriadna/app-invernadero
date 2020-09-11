import 'dart:async';

import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:rxdart/rxdart.dart';

class PushNotificationProvider{

  static final PushNotificationProvider _singleton = PushNotificationProvider._internal();
  factory PushNotificationProvider() => _singleton;
  PushNotificationProvider._internal();// private constructor


  final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  
  final _mensajeStreamController = StreamController<String>();
  final _messageController = new BehaviorSubject<String>();
  Stream get messageStream => _messageController.stream;
  Function(String) get onChangeMessage => _messageController.sink.add;


  dispose(){
    _mensajeStreamController.close();
    _messageController.close();
  }

  static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) async {
    if (message.containsKey('data')) {
      // Handle data message
      final dynamic data = message['data'];
    }

    if (message.containsKey('notification')) {
      // Handle notification message
      final dynamic notification = message['notification'];
    }

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
    print("=======on message========"); //ap en primer plano
    print("mensaje $message");

    final data = message['data'];
  }

  Future<dynamic> onLaunch(Map<String, dynamic> message) async{
    print("=======on onLaunch========");
    print("mensaje $message");
  }
  Future<dynamic> onResume(Map<String, dynamic> message) async{
    print("=======on onResume========"); //volviendo del bakground
    print("mensaje $message");
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