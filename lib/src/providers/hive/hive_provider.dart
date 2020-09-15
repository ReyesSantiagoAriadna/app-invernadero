import 'package:app_invernadero_trabajador/src/models/notifications/data.dart';
import 'package:app_invernadero_trabajador/src/models/notifications/notificacion.dart';
import 'package:hive/hive.dart';
import 'package:path_provider/path_provider.dart';

class HiveProvider{
  static HiveProvider _instance =
      HiveProvider.internal();

  HiveProvider.internal();

  factory HiveProvider() => _instance;

  Box notificationBox;
  Box dataBox;

   Future initDB()async{
    var path = await getApplicationDocumentsDirectory();
    Hive.init(path.path);
    //adapter register
    Hive.registerAdapter(NotificationsAdapter());  
    Hive.registerAdapter(DataAdapter());
    //shoppingCartBox= await Hive.openBox("shoppingCart");
    notificationBox = await Hive.openBox("notification");
    dataBox =  await Hive.openBox("data");
    return true;
  }


  // ***NOTIFICACIONES */
  insertNotification(Map<String, Notificacion> entries) async{
    print("insertando notificaciones.....");
    await notificationBox.putAll(entries);
  } 

  Box notificationsBox(){
    return notificationBox;
  }

  Future deleteNotificationsBox() async{
    await notificationBox.clear();
  }

  void deleteNotification(String id){ 
    notificationBox.delete(id); 
  } 

  void inserNotification(Notificacion n)async{
    await notificationBox.put(n.id, n);    
  }
  
  void markAsRead()async{
    Map map =  notificationBox.toMap();
    // Map newMap = Map();
    DateTime now = DateTime.now();
    map.forEach((k,v){
      Notificacion n = v;
      if(n.readAt==null){
        n.readAt = now;
        //newMap.putIfAbsent(n.id, () => n);
        notificationBox.put(n.id, n);
       }
     });
    // await notificationBox.putAll(newMap);
  }

  // void markAsRead(NotificacionModel notificacionModel){
  //   print("Actualizandooo notificacion marcando como leida...");
  //   NotificacionModel notification = notificationBox.get(notificacionModel.id);
  //   if(notification!=null)
  //     notification.readAt = notification.readAt;

  //   notificacionModel.data = notification.data;
    
  //   notificationBox.put(notification.id, notificacionModel);
  // }
  
  
  Future<List<Notificacion>> notificationsList()async{
    Map map =  notificationBox.toMap();
    List<Notificacion> notifications =  new List();
    notifications = map.values.toList().cast();
    notifications..sort((b, a) => a.createdAt.compareTo(b.createdAt));
    print("notificacionesss ${map.length}");
    return notifications;
  }



  // Future<List<NotificacionModel>> filterNotifications(
  //   List<NotificacionModel> lista,String query)async{
  //   List<NotificacionModel> copyList=
  //     lista.where(
  //       (f) => f.data['titulo'].toUpperCase().contains(query.toUpperCase())
  //     ).toList();

  //   return copyList;
  // } 

  // bool notifIsEmpty(){
  //   return notificationBox.isEmpty;
  // }

}