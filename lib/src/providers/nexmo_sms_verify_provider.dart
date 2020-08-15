import 'dart:convert';

import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:meta/meta.dart';
import 'package:http/http.dart' as http;
import '../../app_config.dart';


class NexmoSmsVerifyProvider{
  String apiKey;
  String apiSecret;
  String requestId;
  String number;

  final _storage = SecureStorage();  

  static NexmoSmsVerifyProvider _instance =
      NexmoSmsVerifyProvider.internal();

  NexmoSmsVerifyProvider.internal();

  factory NexmoSmsVerifyProvider() => _instance;

  Future<Map<String,dynamic>> sendCode({@required String celular})async{
      Map<String, String> headers = {"Accept": "application/json"};
      final url = "${AppConfig.base_url}/api/personal/send_code";
      final response = await http.post(
        url,
        headers: headers,
        body: {
          "number": AppConfig.nexmo_country_code + celular,
          }
      );

      Map<String,dynamic> decodedResp = jsonDecode(response.body);
      print(decodedResp);
      if(decodedResp.containsKey('request_id')){ 
        //inicializar Request ID & number
        this.requestId = decodedResp['request_id'];
        this.number = decodedResp['number'];
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
         // "apiKey":this.apiKey,
          //"apiSecret" :this.apiSecret,
          "request_id":this.requestId,
          "code" : code,
          "number":this.number,
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

  
  //RESEND CODE
  Future<Map<String,dynamic>> resend({@required String code})async{
      Map<String, String> headers = {"Accept": "application/json"};
      final url = "${AppConfig.base_url}/api/personal/verifyCode";
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

