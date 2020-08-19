import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar_model.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http;

class SolaresCultivosProvider{
  static final SolaresCultivosProvider _solaresCultivosProvider = SolaresCultivosProvider._internal();

  factory SolaresCultivosProvider() {
    return _solaresCultivosProvider;
  }

  SolaresCultivosProvider._internal();
  final _storage = SecureStorage();  
  int _page=0;
  bool _loading=false;


  Future<List<Solar>> loadSolares()async{  
    if(_loading)return [];
    _loading=true;
    
    _page++;
    
    final url = "${AppConfig.base_url}/api/personal/solares?page=$_page"; 
    final token = await _storage.read('token');
    print("TOKEN: $token");
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);
    print("SOLARES RESPUESTA----------------");

    print(response.body);
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEE $_page");
      return[];
    } 
    
    if(response.body.contains("solares") && response.body.contains("id")){
      SolarModel solares = SolarModel.fromJson(json.decode(response.body));
      print("regresando listaaaa");
      _loading=false;
      return solares.solares.values.toList().cast();
    }
    return [];
  }
  



}