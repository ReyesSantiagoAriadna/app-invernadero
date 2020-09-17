
import 'package:app_invernadero_trabajador/src/models/employee/tareas_trabajador_model.dart';
import 'package:app_invernadero_trabajador/src/models/notifications/notificacion.dart';
import 'package:app_invernadero_trabajador/src/providers/employee/notifications_employee/notifications_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/employee/task_employee/task_employee_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/hive/hive_provider.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

class NotificationsService with ChangeNotifier{
  //  static final NotificationsService _singleton = NotificationsService._internal();

  // factory NotificationsService() => _singleton;

  // NotificationsService._internal(){
  //   this.getNotifications();
  // }
  static NotificationsService instance = NotificationsService();
  
  NotificationsEmployeeProvider notificationsProvider = NotificationsEmployeeProvider();
  HiveProvider _hiveProvider = new HiveProvider();

  List<Notificacion> listNotifications = new List();
  
  
  final _notificationsController =  new BehaviorSubject<List<Notificacion>>();
  final _notifIndicatorController = new BehaviorSubject<int>();

  Stream<List<Notificacion>> get notificationsStream => _notificationsController.stream;
  Stream<int> get notifIndicatorStream => _notifIndicatorController.stream;
  


  dispose(){
    _notificationsController.close();
  }

  NotificationsService(){
    this.getNotifications();
   // this.getNotificationsHiveProvider();
  }
  
  Future<void> getNotifications()async{
    print("************LLAMANDO NOTIFICACIONES**********");
    final notifications =  await notificationsProvider.unReadNotifications();
    if(notifications.isNotEmpty){
       print("*************AGREGANDO NOTIFICACIONES**********");
      int n = notifications.length;
      this._notifIndicatorController.sink.add(n);
      this.listNotifications.addAll(notifications);
      _notificationsController.sink.add(this.listNotifications);
    }

    notifyListeners();
  }
  

  

  void getNotificationsHiveProvider()async{
    final l = await notificationsProvider.unReadNotifications();
    final list = await _hiveProvider.notificationsList();
    if(l!=null){
      
      int n = l.length;
      
      this._notifIndicatorController.sink.add(n);
      this.listNotifications.addAll(list);
      _notificationsController.sink.add(listNotifications);
    }
    notifyListeners();
  }


  void markAsReadLocal()async{
    await notificationsProvider.markAsReadNotifications();
    this._notifIndicatorController.sink.add(0);
    DateTime now = DateTime.now();
    listNotifications.forEach((n){
      print("read ass");
        if(n.readAt==null)
          n.readAt = now;
    });
  }

  void markAsReadHive()async{
    final flag = await notificationsProvider.markAsReadNotifications();
    if(flag){
      print("Marcandooo");
      await _hiveProvider.markAsRead();
      this._notifIndicatorController.sink.add(0);
      //this.getNotificationsHiveProvider();
    }
    
  }
  
  // test(){
  //    if(!isNotified) { 
  //      print("onMessage called"); 
  //      print(msg);
  //       DocumentReference documentReference = Firestore.instance.collection('PushNotifications').document();
  //        documentReference.setData({ "payload": msg }); 
  //        } 
  //        isNotified = !isNotified; 
         
  // }
}