
import 'dart:convert';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/task/tarea_date_mode.dart';
import 'package:app_invernadero_trabajador/src/providers/firebase/push_notification_provider.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;


class TwilioProvider{
  String apiKey;
  String apiSecret;
  String requestId;
  String number;

  final _storage = SecureStorage();  

  static TwilioProvider _instance =
      TwilioProvider.internal();

  TwilioProvider.internal();

  factory TwilioProvider() => _instance;

  final fcm = PushNotificationProvider();

  Future<Map<String,dynamic>> sendCode({@required String celular})async{
      Map<String, String> headers = {"Accept": "application/json"};
      final url = "${AppConfig.base_url}/api/personal/send_code";
      final response = await http.post(
        url,
        headers: headers,
        body: {
          "number":celular,
          });
       print("reponse send code>>> ${response.body}");
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      print("RESPUESTA DE VERIFICACION $decodedResp");
      if(decodedResp.containsKey('response') && decodedResp.containsKey('number')){ 
        //inicializar Request ID & number 
        
        ///this.requestId = decodedResp['request_id'];
        this.number = decodedResp['number'];
        
        //print("ASIGNANDO VALORES A REQUEST ID & NUMBER ${this.requestId} ${this.number}");
        return {'ok':true, 'request_id' : decodedResp['request_id']};
      }else{
        return {'ok':false, 'message' : decodedResp['message']};
      }
  }


  Future<Map<String,dynamic>> verify({@required String code})async{
      Map<String, String> headers = {"Accept": "application/json"};
      final url = "${AppConfig.base_url}/api/personal/verify_code";
      final response = await http.post(
        url,
        headers: headers,
        body: {
          "verification_code" : code,
          "number":this.number,
          });
       print("reponse verify_>>> ${response.body}");
      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      if(decodedResp.containsKey('access_token')){ 
        //save token 
        Personal p = Personal.fromJsonLogin(jsonDecode(response.body)['client']);
        _storage.idPersonal = p.id;
        
        await _storage.write('token',decodedResp['access_token']);
        await fcm.subscribeToTopic(this.number);
        if(p.rol==AppConfig.rol_admin){
          await fcm.subscribeToTopic(AppConfig.fcm_topic_admin);
        }else if(p.rol == AppConfig.rol_empleado){
          await fcm.subscribeToTopic(AppConfig.fcm_topic_employee);
        }
        
        return {'ok':true, 'access_token' : decodedResp['access_token']};
      }else{
        return {'ok':false, 'message' : decodedResp['message']};
      }
  }

  
  //RESEND CODE
  Future<Map<String,dynamic>> resend({@required String code})async{
      Map<String, String> headers = {"Accept": "application/json"};
      final url = "${AppConfig.base_url}/api/auth/verifyCode";
      final response = await http.post(
        url,
        headers: headers,
        body: {
          "apiKey":this.apiKey,
          "apiSecret" :this.apiSecret,
          "request_id":this.requestId,
          "code" : code
          });

      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      print(decodedResp);
      
      if(decodedResp.containsKey('access_token')){ 
        //save token 
        await _storage.write('token',decodedResp['access_token']);
        return {'ok':true, 'access_token' : decodedResp['access_token']};
      }else{
        return {'ok':false, 'message' : decodedResp['message']};
      }
  }
}

