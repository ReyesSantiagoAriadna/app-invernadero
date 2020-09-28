import 'dart:convert';
import 'dart:io';
import 'package:app_invernadero_trabajador/src/models/task/tarea_date_mode.dart';
import 'package:app_invernadero_trabajador/src/providers/firebase/push_notification_provider.dart';
import 'package:app_invernadero_trabajador/src/models/trabajador/trabajador.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/services.dart';
import 'package:meta/meta.dart'; 
import 'package:http_parser/http_parser.dart'; 
import 'package:mime_type/mime_type.dart';


import '../../app_config.dart';
import 'package:http/http.dart' as http;


class UserProvider{

  static final UserProvider _userProvider = UserProvider._internal();

  factory UserProvider() {
    return _userProvider;
  }

  UserProvider._internal();

  final _fcm = PushNotificationProvider();
  final _storage = SecureStorage();  
  
  Future<Map<String,dynamic>> findPhone({@required String celular})async{
      await _storage.write('celular',AppConfig.twilio_country_code+celular);
      final url = "${AppConfig.base_url}/api/personal/find_phone";

      
      final response = await http.post(
        url,body: {"celular": AppConfig.nexmo_country_code+ celular}
        );
    
      if(response.body.contains("error") && response.body.contains("no found")){
        return {'ok':false, 'mensaje' : "No se encontro el numero de celular",'error':"no found"};
      }

      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      print(decodedResp);
      

      if(decodedResp.containsKey('celular')){ 
        print("retornando respuesta valida del servidor");
        return {
          'ok':true, 
          'celular' : decodedResp['celular'],
          'nombre' : decodedResp['nombre'],
          'password':decodedResp['password'],
          'verificado':decodedResp['verificado']          
        };
      }else{
        return {'ok':false, 'mensaje' : decodedResp['error']};
      }
  }

  //fin code ss invernadero
  Future<Map<String,dynamic>> findCode({@required String code})async{
      await _storage.write('code', code);
      final url = "${AppConfig.base_url}/api/personal/find_code";

      final response = await http.post(url,body: {"code":code});

      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      print(decodedResp);
      
      if(decodedResp.containsKey('celular')){ 
         await _storage.write('celular', decodedResp['celular']);
        return {
          'ok':true, 
          'celular' : decodedResp['celular'],
          'verificado':decodedResp['verificado']          
        };
      }else{
        return {'ok':false, 'mensaje' : decodedResp['error']};
      }
  }
  

  Future<Map<String,dynamic>> login({@required String celular,@required  String password})async{
      Map<String, String> headers = {"Accept": "application/json"};
      final url = "${AppConfig.base_url}/api/personal/login";
      
      final response = await http.post(
        url,headers:headers ,
        body: {
          "grant_type" : "refresh_token" ,
          "customer_id" : "client-id" ,
          "client_secret" : "client-secret" ,
          "refresh_token" : "refresh-token" ,
          "provider" :'personals' ,
          "celular":celular,
          "password":password}
        );
      
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      print("CLIENTEEEEEEEEE");
      print(response.body);
      if(decodedResp.containsKey('access_token')){ //access_token,token_type,expires_at
        await _storage.write('token',decodedResp['access_token']);
        Personal p = Personal.fromJsonLogin(decodedResp['personal']);
        _storage.rolPersonal= p.rol;
        _storage.idPersonal = p.id;
        _storage.numberPhone = p.celular;
        print("Roooolll de personal ¨*********** ${p.rol}");
        await _fcm.subscribeToTopic(celular);
        if(p.rol==AppConfig.rol_admin){
          await _fcm.subscribeToTopic(AppConfig.fcm_topic_admin);
           await _fcm.subscribeToTopic(AppConfig.fcm_topic_employee);
        }else if(p.rol == AppConfig.rol_empleado){
          await _fcm.subscribeToTopic(AppConfig.fcm_topic_employee);
        }
      return {'ok':true, 'celular' : decodedResp};
      }else{
        return {'ok':false, 'mensaje' : decodedResp['message']};
      }
  }

  
  Future<Map<String,dynamic>> changePassword({@required String celular,@required  String password})async{
    
    final url = "${AppConfig.base_url}/api/personal/update_password";
    final token = await _storage.read('token');

    print("tokeeene: $token");
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.post(
      url,
      headers:headers,
      body: {"celular":celular,"password":password});
    
    Map<String,dynamic> decodedResp = jsonDecode(response.body);
    print("${   response.body}");
    
    print(decodedResp); 
    if(decodedResp.containsKey('access_token')){ 
      //  await _storage.write('token',decodedResp['access_token']);
       
      //   Personal p = Personal.fromJsonLogin(decodedResp['personal']);
      //   _storage.rolPersonal= p.rol;
      //   _storage.idPersonal = p.id;
      //   _storage.numberPhone = p.celular;
      //   print("Roooolll de personal ¨*********** ${p.rol}");
      //   await _fcm.subscribeToTopic(celular);
      //   if(p.rol==AppConfig.rol_admin){
      //     await _fcm.subscribeToTopic(AppConfig.fcm_topic_admin);
      //      await _fcm.subscribeToTopic(AppConfig.fcm_topic_employee);
      //   }else if(p.rol == AppConfig.rol_empleado){
      //     await _fcm.subscribeToTopic(AppConfig.fcm_topic_employee);
      //   }

      return {'ok':true, 'message' : decodedResp['message']};
    }else{
      return {'ok':false, 'message' : decodedResp['message']};
    }
  }


  Future<Map<String,dynamic>> changeInf({@required String telefono,@required  String name,String email})async{
    
    final url = "${AppConfig.base_url}/api/auth/change_inf";
    final token = await _storage.read('token');

    
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.post(
      url,
      headers:headers,
      body: {
        "telefono":telefono,
        "name":name,
        "email":email==null?'no_email':email,
        });
    
    Map<String,dynamic> decodedResp = jsonDecode(response.body);

    print("API CHANGE INFORMATION");
    print(decodedResp); 
    if(decodedResp.containsKey('result')){ 

      return {'ok':true, 'message' : decodedResp['message']};
    }else{
      return {'ok':false, 'message' : decodedResp['message']};
    }
  }


  Future<Map<String,dynamic>> logout()async{
    try{
      final url = "${AppConfig.base_url}/api/personal/logout";
      final token = await _storage.read('token');
        Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};

      final response = await http.get(
        url, 
        headers: headers,);
      
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      
      print("CODE LOGOUT response: $response.statusCode");
      print("***RESPUESTA****");
      print(decodedResp); 
      
      
      if(decodedResp.containsKey('message')){ 
        // TODO: remove  token 
        // _storage.rolPersonal='';
        // _storage.idPersonal = -1;
        // _storage.numberPhone = '';

        await _fcm.unsubscribeFromTopic( _storage.numberPhone);
        await _fcm.unsubscribeFromTopic(AppConfig.rol_empleado);
        if(_storage.rolPersonal==AppConfig.rol_admin){
          await _fcm.unsubscribeFromTopic(AppConfig.fcm_topic_admin);
        }



        await _storage.delete('token'); 
        _storage.sesion = false;
      // fcm.deleteToken();
        return {'ok':true, 'celular' : decodedResp};
      }else{
        return {'ok':false, 'mensaje' : decodedResp['message']};
      }
    }on PlatformException catch(e){
      print("Error ${e.code}:${e.message}");  
      return {'ok':false, 'mensaje' : 'error'};
    }
      
  }


  
   Future<Trabajador> getTrabajador()async{    
    final url = "${AppConfig.base_url}/api/personal/getUser"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    print("Respuesta Trabajador----------------");
    print(response.body);
    if(response.body.contains("trabajador")&& response.body.contains("id") ){
      print("Respuesta Update----------------${response.body}");
      Trabajador trabajador = Trabajador.fromJson(json.decode(response.body)['trabajador']);
      return trabajador;
    } 
    return null;
  }

   Future<String> subirImagenCloudinary(File imagen) async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dtev8lpem/image/upload?upload_preset=f9k9os9d');
    final mimeType = mime(imagen.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest( //peticion para subir el archivo
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath( //se carga el archivo
      'file', 
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );

    imageUploadRequest.files.add(file);
    
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
        print('Algo salio mal');
        print(resp.body);
        return null;
    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];
  }

  Future<Trabajador> updateName(String nameTrabajador) async{
    final url = "${AppConfig.base_url}/api/personal/updateName"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 
    
    final response = await http.put(
      url, 
      headers: headers,
      body: { 
        "nombre":nameTrabajador,  
      });

    if(response.body.contains('trabajador')  && response.body.contains("id")){
      Trabajador trabajador = Trabajador.fromJson(json.decode(response.body)['trabajador']);
      return trabajador;
    }
    return null;
  }

  Future<Trabajador> updateApaterno(String aPaterno) async{
    final url = "${AppConfig.base_url}/api/personal/updatePaterno"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 
    
    final response = await http.put(
      url, 
      headers: headers,
      body: { 
        "ap":aPaterno,  
      });

    if(response.body.contains('trabajador')  && response.body.contains("id")){
      Trabajador trabajador = Trabajador.fromJson(json.decode(response.body)['trabajador']);
      return trabajador;
    }
    return null;
  }

  Future<Trabajador> updateAmaterno(String aMaterno) async{
    final url = "${AppConfig.base_url}/api/personal/updateMaterno"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 
    
    final response = await http.put(
      url, 
      headers: headers,
      body: { 
        "am":aMaterno,  
      });

    if(response.body.contains('trabajador')  && response.body.contains("id")){
      Trabajador trabajador = Trabajador.fromJson(json.decode(response.body)['trabajador']);
      return trabajador;
    }
    return null;
  }

  Future<Trabajador> updateRfc(String rfc) async{
    final url = "${AppConfig.base_url}/api/personal/updateRfc"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 
    
    final response = await http.put(
      url, 
      headers: headers,
      body: { 
        "rfc":rfc,  
      });

    if(response.body.contains('trabajador')  && response.body.contains("id")){
      Trabajador trabajador = Trabajador.fromJson(json.decode(response.body)['trabajador']);
      return trabajador;
    }
    return null;
  }

  Future<Trabajador> updatePhoto(String urlImagen) async{
    final url = "${AppConfig.base_url}/api/personal/updatePhoto"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 
    
    final response = await http.put(
      url, 
      headers: headers,
      body: { 
        "url_imagen": urlImagen,  
      });

    if(response.body.contains('trabajador')  && response.body.contains("id")){
      Trabajador trabajador = Trabajador.fromJson(json.decode(response.body)['trabajador']);
      return trabajador;
    }
    return null;
  }
 
  // Future<UserModel> cargarUsuario()async{
  //     final telefono = _storage.user.phone;
  //     final url = "${AppConfig.base_url}/api/client/buscarUser";
  //     final token = await _storage.read('token');
  //   Map<String, String> headers = {
  //     HttpHeaders.authorizationHeader: "Bearer $token",
  //     "Accept": "application/json",};
     

  //     final response = await http.post(url, headers: headers, body: {"telefono":telefono}); 
      
  //     var decodeData = jsonDecode(response.body);
  //     print(decodeData);
  //     if(decodeData == null) return null; 
      
  //     return  UserModel.fromJson(decodeData); 
      
  // }

  // Future<bool> updateDatosUser(ClientModel user) async{
  //   final url = "${AppConfig.base_url}/api/client/add_info"; 
  //   final token = await _storage.read('token');
  //   Map<String, String> headers = {
  //     HttpHeaders.authorizationHeader: "Bearer $token",
  //     "Accept": "application/json",}; 
    
  //   final response = await http.post(
  //     url, 
  //     headers: headers,
  //     body: {
  //       "celular":user.celular,
  //       "nombre":user.nombre, 
  //       "ap":user.ap, 
  //       "am":user.am,
  //       "rfc":user.rfc,
  //     });

  //   final decodeData = json.decode(response.body);
  //   print(decodeData);
  //   return true;
  // }

  //  Future<bool> updatePhoto(ClientModel user) async{ 
  //   final url = "${AppConfig.base_url}/api/client/update_photo"; 
  //   final token = await _storage.read('token');
  //   Map<String, String> headers = {
  //     HttpHeaders.authorizationHeader: "Bearer $token",
  //     "Accept": "application/json",}; 
    
  //   final response = await http.post(
  //     url, 
  //     headers: headers,
  //     body: {
  //       "celular":user.celular,
  //       "url_imagen":user.urlImagen,  
  //     });

  //   final decodeData = json.decode(response.body);
  //   print(decodeData);
  //   return true;
  // }

  //  Future<String> subirImagenCloudinary(File imagen) async{
  //   final url = Uri.parse('https://api.cloudinary.com/v1_1/dtev8lpem/image/upload?upload_preset=f9k9os9d');
  //   final mimeType = mime(imagen.path).split('/'); //image/jpeg

  //   final imageUploadRequest = http.MultipartRequest( //peticion para subir el archivo
  //     'POST',
  //     url
  //   );

  //   final file = await http.MultipartFile.fromPath( //se carga el archivo
  //     'file', 
  //     imagen.path,
  //     contentType: MediaType(mimeType[0], mimeType[1]),
  //   );

  //   imageUploadRequest.files.add(file);
    
  //   final streamResponse = await imageUploadRequest.send();
  //   final resp = await http.Response.fromStream(streamResponse);

  //   if (resp.statusCode != 200 && resp.statusCode != 201) {
  //       print('Algo salio mal');
  //       print(resp.body);
  //       return null;
  //   }

  //   final respData = json.decode(resp.body);
  //   print(respData);

  //   return respData['secure_url'];
  // } 

  //  Future<List<NotificacionModel>> cargarNotificaciones()async{
  //   final url = "${AppConfig.base_url}/api/client/notificationsAll"; 
  //   final token = await _storage.read('token');
  //   Map<String, String> headers = {
  //     HttpHeaders.authorizationHeader: "Bearer $token",
  //     "Accept": "application/json",};
    
  //   final response = await http.get(url, headers: headers,);

  //   print("NOTIFICACIONES RESPUESTA----------------");
  //   print(response.body);
    
  //   if(response.body.contains('message')){
  //     return [];
  //   } 

  //   final Map<dynamic,dynamic> decodeData = json.decode(response.body)['notificaciones'];  
  //   final List<NotificacionModel> notificaciones = List();


  //   Map notiMap = Map<String, NotificacionModel>();


  //   decodeData.forEach((id,notification){
       
  //     NotificacionModel notiTemp = NotificacionModel.fromJson(notification);  
  //     print(notiTemp); 
  //     notificaciones.add(notiTemp);
         
  //     notiMap.putIfAbsent(id, ()=>notiTemp); 

  //   }); 

  //   _dbProvider.insertNotification(notiMap); 
     
  //   if(decodeData==null) return [];
  //   return notificaciones; 
  // }

  //  Future<List<NotificacionModel>> unReadNotifications()async{
  //   final url = "${AppConfig.base_url}/api/client/notifications"; 
  //   final token = await _storage.read('token');
  //   Map<String, String> headers = {
  //     HttpHeaders.authorizationHeader: "Bearer $token",
  //     "Accept": "application/json",};
    
  //   final response = await http.get(
  //     url, 
  //     headers: headers,);

  //   print(response.body); 
    
  //   if(response.body.contains('error')){
  //     return [];
  //   } 

    
  //    print("***********NOTIFICACIONES NO LEIDAS RESPUESTA-**************");
   
  //    if(response.body.contains("notificaciones") && response.body.contains("id")){
  //      final Map<dynamic,dynamic> decodeData = json.decode(response.body)['notificaciones'];
  //     final List<NotificacionModel> notifications = List();


  //     Map notifiMap = Map<String, NotificacionModel>();

    
  //     decodeData.forEach((id,notification){
  //       NotificacionModel notiTemp = NotificacionModel.fromJson(notification);
  //       notifications.add(notiTemp);
  //       notifiMap.putIfAbsent(id, ()=>notiTemp);
  //     });

  //     _dbProvider.insertNotification(notifiMap);
  //     if(decodeData==null) return [];
  //     return notifications; 
  //    }
  //   return [];
  // }

  //  Future<List<NotificacionModel>> markAsReadNotifications(List<String> list) async{ 
  //   final url = "${AppConfig.base_url}/api/client/notifications_mark_as_read"; 
  //   final token = await _storage.read('token');
    
  //   Map<String, String> headers = {
  //     HttpHeaders.authorizationHeader: "Bearer $token",
  //     "Content-Type" : "application/json",
  //     "Accept": "application/json",}; 
    
  //   final response = await http.post(
  //     url, 
  //     headers: headers,
  //     body: json.encode( 
  //       {
  //       "notifications" :list ,
  //       }
  //       )
  //   );
  //   print("MARK AS READ****");
  //   print(response.body);

  //   if(response.body.contains("message")){
  //     return [];
  //   }

  //   if(response.body.contains("notifications") && response.body.contains("id")){
  //     final Map<dynamic,dynamic> decodeData = json.decode(response.body)['notifications'];
  //     final List<NotificacionModel> notifications = List();


  //     Map notifiMap = Map<String, NotificacionModel>();


  //     decodeData.forEach((id,notification){
  //       NotificacionModel notiTemp = NotificacionModel.fromJson(notification);
  //       notifications.add(notiTemp);
  //       //notifiMap.putIfAbsent(id, ()=>notiTemp);

  //       _dbProvider.markAsRead(notiTemp);
  //     });

      

  //     //_dbProvider.insertNotification(notifiMap);

  //     if(notifications.isNotEmpty)
  //     return notifications;
  //     else 
  //     return [];
  //   }
  //   return [];
  // }



  // //create fcm token
  // Future<bool> fcmToken({@required  String fcmToken})async{
  //   print(">>>>>>>>>>>>> CREATE FCM TOKEN>>>>>>>>>>>>>>>>");
  //   final token = await _storage.read('token');
  //   Map<String, String> headers = {
  //     HttpHeaders.authorizationHeader: "Bearer $token",
  //     "Accept": "application/json",};

  //   final url = "${AppConfig.base_url}/api/client/fcm_token";
    
  //   final response = await http.post(
  //     url,headers:headers ,
  //     body: {
  //       "fcm_token" : fcmToken ,}
  //     );
    
  //   Map<String,dynamic> decodedResp = jsonDecode(response.body);
    
  //   print("status ${response.statusCode}");
  //   print(response.body);
  //   if(decodedResp.containsKey('result')){ 
  //     return true;
  //   }else{
  //     return false;
  //   }
  // }

  // //delete_fcm_token
  // Future<bool> deleteFcmToken({@required  String fcmToken})async{
  //   print(">>>>>>>>>>>>> DELETE FCM TOKEN>>>>>>>>>>>>>>>>");

  //   final token = await _storage.read('token');
  //   Map<String, String> headers = {
  //     HttpHeaders.authorizationHeader: "Bearer $token",
  //     "Accept": "application/json",};

  //   final url = "${AppConfig.base_url}/api/client/delete_fcm_token";
    
  //   final response = await http.post(
  //     url,headers:headers ,
  //     body: {
  //       "fcm_token" : fcmToken ,}
  //     );
    
  //   Map<String,dynamic> decodedResp = jsonDecode(response.body);
    
  //   print("STATUS: ${response.statusCode}");
  //   print(response.body);
  //   if(decodedResp.containsKey('result')){ 
  //   return true;
  //   }else{
  //     return false;
  //   }
  // }
  

  // Future<bool> updateName(ClientModel cliente) async{
  //   final url = "${AppConfig.base_url}/api/client/updateName"; 
  //   final token = await _storage.read('token');
  //   Map<String, String> headers = {
  //     HttpHeaders.authorizationHeader: "Bearer $token",
  //     "Accept": "application/json",}; 
    
  //   final response = await http.post(
  //     url, 
  //     headers: headers,
  //     body: {
  //       "celular":cliente.celular,
  //       "nombre":cliente.nombre,  
  //     });

  //   final decodeData = json.decode(response.body);
  //   print(decodeData);
  //   return true;
  // }

  // Future<bool> updateApaterno(ClientModel cliente) async{
  //   final url = "${AppConfig.base_url}/api/client/updatePaterno"; 
  //   final token = await _storage.read('token');
  //   Map<String, String> headers = {
  //     HttpHeaders.authorizationHeader: "Bearer $token",
  //     "Accept": "application/json",}; 
    
  //   final response = await http.post(
  //     url, 
  //     headers: headers,
  //     body: {
  //       "celular":cliente.celular,
  //       "ap":cliente.ap,  
  //     });

  //   final decodeData = json.decode(response.body);
  //   print(decodeData);
  //   return true;
  // }

  // Future<bool> updateAmaterno(ClientModel cliente) async{
  //   final url = "${AppConfig.base_url}/api/client/updateMaterno"; 
  //   final token = await _storage.read('token');
  //   Map<String, String> headers = {
  //     HttpHeaders.authorizationHeader: "Bearer $token",
  //     "Accept": "application/json",}; 
    
  //   final response = await http.post(
  //     url, 
  //     headers: headers,
  //     body: {
  //       "celular":cliente.celular,
  //       "am":cliente.am,  
  //     });

  //   final decodeData = json.decode(response.body);
  //   print(decodeData);
  //   return true;
  // }

  // Future<bool> updateRFC(ClientModel cliente) async{
  //   final url = "${AppConfig.base_url}/api/client/updateRfc"; 
  //   final token = await _storage.read('token');
  //   Map<String, String> headers = {
  //     HttpHeaders.authorizationHeader: "Bearer $token",
  //     "Accept": "application/json",}; 
    
  //   final response = await http.post(
  //     url, 
  //     headers: headers,
  //     body: {
  //       "celular":cliente.celular,
  //       "rfc":cliente.rfc,  
  //     });

  //   final decodeData = json.decode(response.body);
  //   print(decodeData);
  //   return true;
  // }

  //  Future<bool> updateEmail(ClientModel cliente) async{
  //   final url = "${AppConfig.base_url}/api/client/updateEmail"; 
  //   final token = await _storage.read('token');
  //   Map<String, String> headers = {
  //     HttpHeaders.authorizationHeader: "Bearer $token",
  //     "Accept": "application/json",}; 
    
  //   final response = await http.post(
  //     url, 
  //     headers: headers,
  //     body: { 
  //       "email":cliente.correo,  
  //     });

  //   final decodeData = json.decode(response.body);
  //   print(decodeData);
  //   return true;
  // }

  
}