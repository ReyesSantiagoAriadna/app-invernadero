import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart' as herramienta;
import 'package:app_invernadero_trabajador/src/models/actividades/insumos_model.dart' as insumo;

class TareasProvider{
  static final TareasProvider _TareasProvider = TareasProvider._internal();

  factory TareasProvider() {
    return _TareasProvider;
  }

  TareasProvider._internal();
  
  final _storage = SecureStorage();  
  int _page=0;
  bool _loading=false;
  ///*herramientas
  bool _loadingH =false;
  int _pageH=0;
  //*insumos
  bool _loadingI =false;
  int _pageI=0;

  Future<List<Tarea>> loadTareas()async{  
    if(_loading)return [];
    _loading=true;
    
    _page++;
    
    final url = "${AppConfig.base_url}/api/personal/actividades_tareas?page=$_page"; 
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
    
    if(response.body.contains("tareas") && response.body.contains("id")){
      TareasModel tareas = TareasModel.fromJson(json.decode(response.body));
      _loading=false;
      return tareas.tareas.values.toList().cast();
    }
    return [];
  }
  
  Future<Tarea> addTarea(Tarea tarea)async{
    final url = "${AppConfig.base_url}/api/personal/add_tarea"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type" : "application/json",
      "Accept": "application/json",}; 

    List<String> insumosId=[];
    List<String> insumosCantidad=[];

    List<String> herramientasId=[];
    List<String> herramientasCantidad=[];

    if(tarea.insumos.isNotEmpty){
      this.listHerramientas(insumosId, insumosCantidad, tarea);
    }
    if(tarea.herramientas.isNotEmpty){
      this.listHerramientas(herramientasId, herramientasCantidad, tarea);
    }

    final response = await http.post(
      url, 
      headers: headers,
      body:   json.encode( 
        {
          "id_fkcultivo":tarea.idFkcultivo,
          "nombre":tarea.nombre,
          "etapa":tarea.etapa,
          "tipo":tarea.tipo,
          "horaInicio": tarea.horaInicio,
          "horaFinal":tarea.horaFinal,
          "detalle":tarea.detalle,
          "herramientas":tarea.herramientas.isNotEmpty?1:0,
          "insumos":tarea.insumos.isNotEmpty?1:0,
          "insumos_id":insumosId,
          "insumos_cantidad":insumosCantidad,
          "herramientas_id":herramientasId,
          "herramientas_cantidad":herramientasCantidad
        }
      )
      );
      print("RESPONSE BODY ${response.body}");
    if(response.body.contains("tarea") && response.body.contains("id")){
      print("ADD-TAREA RESPONSE-> ${response.body}");
      Tarea tarea = Tarea.fromJson(json.decode(response.body)['tarea']);
      return tarea;
    }
    return null;
  }

  Future<Tarea> updateTarea(Tarea tarea)async{
    final url = "${AppConfig.base_url}/api/personal/update_tarea"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type" : "application/json",
      "Accept": "application/json",}; 

    List<String> insumosId=[];
    List<String> insumosCantidad=[];

    List<String> herramientasId=[];
    List<String> herramientasCantidad=[];

    if(tarea.insumos.isNotEmpty){
      this.listHerramientas(insumosId, insumosCantidad, tarea);
    }
    if(tarea.herramientas.isNotEmpty){
      this.listHerramientas(herramientasId, herramientasCantidad, tarea);
    }

    final response = await http.put(
      url, 
      headers: headers,
      body:   json.encode( 
        {

          "id_tarea":tarea.id,
          "nombre":tarea.nombre,
          "etapa":tarea.etapa,
          "tipo":tarea.tipo,
          "horaInicio": tarea.horaInicio,
          "horaFinal":tarea.horaFinal,
          "detalle":tarea.detalle,
          "herramientas":tarea.herramientas.isNotEmpty?1:0,
          "insumos":tarea.insumos.isNotEmpty?1:0,
          "insumos_id":insumosId,
          "insumos_cantidad":insumosCantidad,
          "herramientas_id":herramientasId,
          "herramientas_cantidad":herramientasCantidad
        }
      )
      );
      print("RESPONSE BODY ${response.body}");
    if(response.body.contains("tarea") && response.body.contains("id")){
      print("ADD-TAREA RESPONSE-> ${response.body}");
      Tarea tarea = Tarea.fromJson(json.decode(response.body)['tarea']);
      return tarea;
    }
    return null;
  }

  
  Future<bool> deleteTarea(String idTarea)async{
    final url = "${AppConfig.base_url}/api/personal/delete_tarea?id_tarea=$idTarea"; 
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

   //parameters
  void listInsumos(List<String> insumoId,List<String> insumoCantidad,Tarea tarea){
    tarea.insumos.forEach((i){
      insumoId.add(i.idInsumo.toString());
      insumoCantidad.add(i.cantidad.toString());
    });
  }

  void listHerramientas(List<String> herramientaId,List<String> herramientaCantidad,Tarea tarea){
    tarea.herramientas.forEach((h){
      herramientaId.add(h.idHerramienta.toString());
      herramientaCantidad.add(h.cantidad.toString());
    });
  }

 
  Future<List<herramienta.Herramienta>> loadHerramientas()async{  
    if(_loadingH)return [];
    _loadingH=true;
    
    _pageH++;
    
    final url = "${AppConfig.base_url}/api/personal/actividades_herramientas?page=$_pageH"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    print(response.body);
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEE $_pageH");
      return[];
    } 
    
    if(response.body.contains("herramientas") && response.body.contains("id")){
      HerramientaModel herramientas = HerramientaModel.fromJson(json.decode(response.body));
      _loadingH=false;
      return herramientas.herramientas.values.toList().cast();
    }
    return [];
  }

  Future<List<insumo.Insumo>> loadInsumos()async{  
    if(_loadingI)return [];
    _loadingI=true;
    
    _pageI++;
    
    final url = "${AppConfig.base_url}/api/personal/actividades_insumos?page=$_pageI"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    print(response.body);
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEE $_pageI");
      return[];
    } 
    
    if(response.body.contains("insumos") && response.body.contains("id")){
      insumo.InsumosModel insumos = insumo.InsumosModel.fromJson(json.decode(response.body));
      _loadingI=false;
      return insumos.insumos.values.toList().cast();
    }
    return [];
  }

  //delete_cultivo_etapa 
  //   {
  //     "id_cultivo":66,
  //     "orden" : 2
  // }
}