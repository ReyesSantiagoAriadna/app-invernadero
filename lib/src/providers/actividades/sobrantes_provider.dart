import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/sobrantes_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart' as herramienta;
import 'package:app_invernadero_trabajador/src/models/actividades/insumos_model.dart' as insumo;

class SobrantesProvider{
  static final SobrantesProvider _SobrantesProvider = SobrantesProvider._internal();

  factory SobrantesProvider() {
    return _SobrantesProvider;
  }

  SobrantesProvider._internal();
  
  final _storage = SecureStorage();  
  int _page=0;
  bool _loading=false;

  int _page2=0;
  bool _loading2=false;

  Future<List<Sobrante>> loadSobrantes()async{  
    if(_loading)return [];
    _loading=true;
    
    _page++;
    
    final url = "${AppConfig.base_url}/api/personal/sobrantes?page=$_page"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    print(response.body);
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEE $_page");
      return[];
    } 
    
    if(response.body.contains("sobrantes") && response.body.contains("id")){
      SobrantesModel sobrantes = SobrantesModel.fromJson(json.decode(response.body));
      _loading=false;
      return sobrantes.sobrantes.values.toList().cast();
    }
    return [];
  }
  
  Future<Sobrante> addSobrante(Sobrante sobrante)async{
    final url = "${AppConfig.base_url}/api/personal/add_sobrante"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type" : "application/json",
      "Accept": "application/json",}; 

    final response = await http.post(
      url, 
      headers: headers,
      body:   json.encode( 
        {
          "id_producto":sobrante.idProducto,
          "fecha":sobrante.fecha.toString(),
          "cantidad":sobrante.cantidad,
          "observacion":sobrante.observacion,
        }
      )
      );
    print("RESPONSE BODY ${response.body}");
    if(response.body.contains("sobrante") && response.body.contains("id")){
      print("ADD-SOBRANTE RESPONSE-> ${response.body}");
      Sobrante sobrante = Sobrante.fromJson(json.decode(response.body)['sobrante']);
      return sobrante;
    }
    return null;
  }

  Future<Sobrante> updateSobrante(Sobrante sobrante)async{
    final url = "${AppConfig.base_url}/api/personal/update_sobrante"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type" : "application/json",
      "Accept": "application/json",}; 

    final response = await http.put(
      url, 
      headers: headers,
      body:   json.encode( 
        {
          "id_sobrante" : sobrante.id,
          "id_producto":sobrante.idProducto,
          "fecha":sobrante.fecha.toString(),
          "cantidad":sobrante.cantidad,
          "observacion":sobrante.observacion,
        }
      )
      );
    print("RESPONSE BODY ${response.body}");
    if(response.body.contains("sobrante") && response.body.contains("id")){
      print("UPDATE-SOBRANTE RESPONSE-> ${response.body}");
      Sobrante sobrante = Sobrante.fromJson(json.decode(response.body)['sobrante']);
      return sobrante;
    }
    return null;
  }

  
  Future<bool> deleteSobrante(String idSobrante)async{
    final url = "${AppConfig.base_url}/api/personal/delete_sobrante?id_sobrante=$idSobrante"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};

    final response = await http.delete(
      url, 
      headers: headers,
      );
    
    print("Response delete ${response.body}");
    
    if(response.body.contains("message") && response.body.contains("success")){
      print("eliminando");
      return true;
    }
    if(response.statusCode==200)
      return true;

    print("Error al eliminar");
    return false;
  }


  Future<List<Producto>> productosCultivo(String cultivo)async{  
    
    if(_loading2)return [];
    _loading2=true;
    
    _page2++;
    print("llmando antes");
    final url = "${AppConfig.base_url}/api/personal/productos_cultivo?page=$_page2&cultivo=$cultivo"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);
    
    print(response.body);
    print("response apiii");
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEE $_page");
      return[];
    } 
    
    
    if(response.body.contains("productos") && response.body.contains("id")){
      ProductosModel p = ProductosModel.fromJsonCultivo(json.decode(response.body));
      _loading2=false;
      return p.productos.values.toList().cast();
    }
    _loading2=false;
    return [];
  }
  
}