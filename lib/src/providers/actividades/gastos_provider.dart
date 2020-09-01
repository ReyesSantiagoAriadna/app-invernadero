import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/gastos_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/sobrantes_model.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http;

class GastosProvider{
  static final GastosProvider _GastosProvider = GastosProvider._internal();

  factory GastosProvider() {
    return _GastosProvider;
  }

  GastosProvider._internal();
  
  final _storage = SecureStorage();  
  int _page=0;
  bool _loading=false;

  int _page2=0;
  bool _loading2=false;

  Future<List<Gasto>> loadGastos()async{  
    if(_loading)return [];
    _loading=true;
    
    _page++;
    
    final url = "${AppConfig.base_url}/api/personal/gastos?page=$_page"; 
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
    
    if(response.body.contains("gastos") && response.body.contains("id")){
      GastosModel gastos = GastosModel.fromJson(json.decode(response.body));
      _loading=false;
      return gastos.gastos.values.toList().cast();
    }
    return [];
  }
  
  int conceptoGasto(Gasto g){
    if(g.idPersonal!=null)
      return 1;
    else if(g.idHerramienta!=null)
      return 2;
    else
      return 3;
  }

  Future<Gasto> addGasto(Gasto gasto)async{
    final url = "${AppConfig.base_url}/api/personal/add_gasto"; 
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
         "id_fkcultivo": gasto.idFkcultivo,
          "fecha":gasto.fecha.toString(),
          "costo" :gasto.costo,
          "descripcion" : gasto.descripcion,
          "tipo": conceptoGasto(gasto) ,  // 1->personal 2->herramienta ->other
          "id_personal" : gasto.idPersonal,
          "id_herramienta":gasto.idHerramienta
        }
      )
      );
    print("RESPONSE BODY ${response.body}");
    if(response.body.contains("gasto") && response.body.contains("id")){
      print("ADD-GASTO RESPONSE-> ${response.body}");
      Gasto gasto = Gasto.fromJson(json.decode(response.body)['gasto']);
      return gasto;
    }
    return null;
  }

 Future<Gasto> updateGasto(Gasto gasto)async{
    final url = "${AppConfig.base_url}/api/personal/update_gasto"; 
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
          "id_gasto" : gasto.id,
          "id_fkcultivo": gasto.idFkcultivo,
          "fecha":gasto.fecha.toString(),
          "costo" :gasto.costo,
          "descripcion" : gasto.descripcion,
          "tipo": conceptoGasto(gasto) ,  // 1->personal 2->herramienta ->other
          "id_personal" : gasto.idPersonal,
          "id_herramienta":gasto.idHerramienta
        }
      )
      );
    print("RESPONSE BODY ${response.body}");
    if(response.body.contains("gasto") && response.body.contains("id")){
      print("UPDATE-GASTO RESPONSE-> ${response.body}");
      Gasto gasto = Gasto.fromJson(json.decode(response.body)['gasto']);
      return gasto;
    }
    return null;
  }

  
  Future<bool> deleteGasto(String idGasto)async{
    final url = "${AppConfig.base_url}/api/personal/delete_gasto?id_gasto=$idGasto"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};

    final response = await http.delete(
      url, 
      headers: headers,
      );
    if(response.body.contains("message") && response.body.contains("success")){
      print("eliminando");
      return true;
    }
    if(response.statusCode==200)
      return true;
    print("Error al eliminar");
    return false;
  }
  //gastos_personal 

   Future<List<Personal>> loadPersonal()async{  
    if(_loading2)return [];
    _loading2=true;
    
    _page2++;
    
    final url = "${AppConfig.base_url}/api/personal/gastos_personal?page=$_page2"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    print(response.body);
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEE $_page2");
      return[];
    } 
    
    if(response.body.contains("personal") && response.body.contains("id")){
      Map<String, Personal> trabajadores;
      Map m = json.decode( response.body);
      trabajadores = Map.from(m["personal"]).map((k, v) => MapEntry<String, Personal>(k, Personal.fromJson(v)));

      _loading2=false;
      return trabajadores.values.toList().cast();      
    }
    return [];
  }
}