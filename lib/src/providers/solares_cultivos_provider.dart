import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/server/date.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar_model.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
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

    print(response.body);
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEE $_page");
      return[];
    } 
    
    if(response.body.contains("solares") && response.body.contains("id")){
      SolarModel solares = SolarModel.fromJson(json.decode(response.body));
      _loading=false;
      return solares.solares.values.toList().cast();
    }
    return [];
  }
  
  Future<Solar> addSolar(Solar solar)async{
    final url = "${AppConfig.base_url}/api/personal/add_solar"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};

    final response = await http.post(
      url, 
      headers: headers,
      body:  
        {
          "nombre"  : solar.nombre,
          "largo"   : solar.largo.toString(),
          "ancho"   : solar.ancho.toString(), 
          "region"     :  solar.region,
          "distrito"   :  solar.distrito ,
          "municipio"  :  solar.municipio,
          "latitud":solar.latitud.toString(),
          "longitud":solar.longitud.toString(),
          "descripcion":solar.descripcion,
        }
        
      );

   
    if(response.body.contains("solar") && response.body.contains("id")){
      Solar solar = Solar.fromJson(json.decode(response.body)['solar']);
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
      body: 
        {
          "id_solar" : solar.id.toString(),
          "nombre"  :solar.nombre ,
          "largo":solar.largo.toString(),
          "ancho":solar.ancho.toString(), 
          "region"     :  solar.region,
          "distrito"   :  solar.distrito ,
          "municipio"  :  solar.municipio,
          "latitud":solar.latitud.toString(),
          "longitud":solar.longitud.toString(),
          "descripcion":solar.descripcion,
        }
      );
    if(response.body.contains("solar") && response.body.contains("id")){
      print("RESPONSE UPDATE ${response.body}");
      Solar solar = Solar.fromJson(json.decode(response.body)['solar']);
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
    
    
    if(response.body.contains("message") && response.body.contains("success")){
      print("eliminando");
      return true;
    }
    if(response.statusCode==200)
      return true;

    print("Error al eliminar");
    return false;
  }

  Future<Cultivo> addCultivo(Cultivo cultivo,int etapas)async{
    final url = "${AppConfig.base_url}/api/personal/add_cultivo"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type" : "application/json",
      "Accept": "application/json",}; 

    List<String> etapasNombre=[];
    List<String> etapasDias=[];

    if(etapas!=0){
      this.listEtapas(etapasNombre, etapasDias, cultivo);
    }

    var formatter = new DateFormat("yyyy-MM-dd");
        

    final response = await http.post(
      url, 
      headers: headers,
      body:   json.encode( 
        {
          "solar": cultivo.idFksolar,
          "tipo":cultivo.tipo,
          "nombre":cultivo.nombre,
          "largo":cultivo.largo,
          "ancho":cultivo.ancho,
          "fecha" : formatter.format(cultivo.fechaFinal).toString(),
          "fechaFinal" : formatter.format(cultivo.fecha).toString(),
          "moniSensor":cultivo.moniSensor,
          "observacion":cultivo.observacion,
          "tempMin":cultivo.tempMin,
          "tempMax":cultivo.tempMax,
          "humeMin":cultivo.humeMin,
          "humeMax":cultivo.humeMax,
          "humeSMin":cultivo.humeSMin,
          "humeSMax":cultivo.humeSMax,
          "etapas": etapas,
          "etapa_nombre" : etapasNombre,
          "etapa_dias":etapasDias,
        }
      )
      );
      print("RESPONSE BODY ${response.body}");
    if(response.body.contains("cultivo") && response.body.contains("id")){
      print("ADD-CULTIVO RESPONSE-> ${response.body}");
      Cultivo cultivo = Cultivo.fromJson(json.decode(response.body)['cultivo']);
      return cultivo;
    }
    return null;
  }
  //parameters
  void listEtapas(List<String> eNombres,List<String> eDias,Cultivo cultivo){
    cultivo.etapas.forEach((e){
      eNombres.add(e.nombre);
      eDias.add(e.dias.toString());
    });
  }


  Future<Cultivo> updateCultivo(Cultivo cultivo,int etapas)async{
    final url = "${AppConfig.base_url}/api/personal/update_cultivo"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type" : "application/json",
      "Accept": "application/json",}; 

    List<String> etapasNombre=[];
    List<String> etapasDias=[];

    if(etapas!=0){
      this.listEtapas(etapasNombre, etapasDias, cultivo);
    }

    var formatter = new DateFormat("yyyy-MM-dd");
    print("ID DE CULTIVO ${cultivo.id}");

    
    final response = await http.put(
      url, 
      headers: headers,
      body:   json.encode( 
        {
          "id_cultivo" :cultivo.id,
          "solar": cultivo.idFksolar,
          "tipo":cultivo.tipo,
          "nombre":cultivo.nombre,
          "largo":cultivo.largo,
          "ancho":cultivo.ancho,
          "fecha" : formatter.format(cultivo.fecha).toString(),
          "fechaFinal" : formatter.format(cultivo.fechaFinal).toString(),
          "moniSensor":cultivo.moniSensor,
          "observacion":cultivo.observacion,
          "tempMin":cultivo.tempMin,
          "tempMax":cultivo.tempMax,
          "humeMin":cultivo.humeMin,
          "humeMax":cultivo.humeMax,
          "humeSMin":cultivo.humeSMin,
          "humeSMax":cultivo.humeSMax,
          "etapas": etapas,
          "etapa_nombre" : etapasNombre,
          "etapa_dias":etapasDias,
        }
      )
      );
    if(response.body.contains("errors")){
      print("Error ${response.body}");
      return null;
    }
    if(response.body.contains("cultivo") && response.body.contains("id") && response.body.contains("update")){
      print("UPDATE-CULTIVO RESPONSE-> ${response.body}");
      Cultivo cultivo = Cultivo.fromJson(json.decode(response.body)['cultivo']);
      return cultivo;
    }
    return null;
  }

   Future<bool> deleteCultivo(String idCultivo)async{
    final url = "${AppConfig.base_url}/api/personal/delete_cultivo?id_cultivo=$idCultivo"; 
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


  //delete_cultivo_etapa 
  //   {
  //     "id_cultivo":66,
  //     "orden" : 2
  // }

  Future<Date> getDate()async{  
    final url = "${AppConfig.base_url}/api/personal/date"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    print(response.body);
    if(response.body.contains('error') || response.body.contains("message")){
      return null;
    } 
    
    if(response.body.contains("date") ){
      Date date = Date.fromJson(json.decode(response.body));
      return date;
    }
    return null;
  }
}