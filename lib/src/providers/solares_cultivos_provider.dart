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

  //  Route::post('add_solar','Api\trabajador\SolarCultivosController@addSolar');
  //       Route::put('update_solar','Api\trabajador\SolarCultivosController@updateSolar');
  //       Route::delete('delete_solar','Api\trabajador\SolarCultivosController@deleteSolar');
  
  Future<Solar> addSolar(Solar solar)async{
    final url = "${AppConfig.base_url}/api/personal/add_solar"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};

    final response = await http.post(
      url, 
      headers: headers,
      body: json.encode( 
        {
          "nombre"  :solar.nombre ,
          "largo":solar.largo,
          "ancho":solar.ancho, 
          "region"     :  solar.region,
          "distrito"   :  solar.distrito ,
          "municipio"  :  solar.municipio,
          "latitud":solar.latitud,
          "longitud":solar.longitud,
          "descripcion":solar.descripcion,
        }
        )
      );

    print("SOLARES RESPUESTA ADD----------------");
    print(response.body);
    if(response.body.contains("solar") && response.body.contains("id")){
      Solar solar = Solar.fromJson(json.decode(response.body));
      return solar;
    }
    return null;
  }

  Future<Solar> updateSolar(Solar solar)async{
    final url = "${AppConfig.base_url}/api/personal/update_solar"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};

    final response = await http.put(
      url, 
      headers: headers,
      body: json.encode( 
        {
          "nombre"  :solar.nombre ,
          "largo":solar.largo,
          "ancho":solar.ancho, 
          "region"     :  solar.region,
          "distrito"   :  solar.distrito ,
          "municipio"  :  solar.municipio,
          "latitud":solar.latitud,
          "longitud":solar.longitud,
          "descripcion":solar.descripcion,
        }
        )
      );

    print("SOLARES RESPUESTA UPDATE----------------");
    print(response.body);
    if(response.body.contains("solar") && response.body.contains("id")){
      Solar solar = Solar.fromJson(json.decode(response.body));
      return solar;
    }
    return null;
  }

  
  Future<bool> deleteSolar(String idSolar)async{
    final url = "${AppConfig.base_url}/api/personal/delete_solar?id_solar=$idSolar"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};

    final response = await http.delete(
      url, 
      headers: headers,
      );
    print("SOLARES RESPUESTA DELETE----------------");
    print(response.body);
    
    if(response.body.contains("message") && response.body.contains("success")){
      print("eliminando");
      return true;
    }
    if(response.statusCode==200)
      return true;

    print("Error al eliminar");
    return false;
  }

}