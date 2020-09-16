import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/pedido/pedido_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart';
import 'package:app_invernadero_trabajador/src/models/pedidos/fecha_pedido_model.dart';
import 'package:app_invernadero_trabajador/src/models/pedidos/pedido_model.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http;
import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart' as herramienta;
import 'package:app_invernadero_trabajador/src/models/actividades/insumos_model.dart' as insumo;

class PedidosProvider{
  static final PedidosProvider _PedidosProvider = PedidosProvider._internal();

  factory PedidosProvider() {
    return _PedidosProvider;
  }

  PedidosProvider._internal();
  
  final _storage = SecureStorage();  
  int _page=0;
  bool _loading=false;
  ///*herramientas
  bool _loadingH =false;
  int _pageH=0;
  //*insumos
  bool _loadingI =false;
  int _pageI=0;

  Future<List<Pedido>> loadPedidos()async{  
    if(_loading)return [];
    _loading=true;
    
    _page++;
    
    final url = "${AppConfig.base_url}/api/personal/pedidos?page=$_page"; 
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


    if(response.body.contains("pedidos") && response.body.contains("id")){
      PedidosModel pedidos = PedidosModel.fromJson(json.decode(response.body));
      _loading=false;
      return pedidos.pedidos.values.toList().cast();
    }
    return [];
  }
  
  
  Future<List<Pedido>> searchPedido(String data)async{      
    final url = "${AppConfig.base_url}/api/personal/search_pedido?data=$data"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    print(response.body);
    if(response.body.contains('message')){
      return[];
    } 

    if(response.body.contains("pedidos") && response.body.contains("id")){
      PedidosModel pedidos = PedidosModel.fromJson(json.decode(response.body));
      return pedidos.pedidos.values.toList().cast();
    }
    return [];
  }

  Future<FechaPedidoModel> agendarPedido(FechaPedidoModel fechaPedido)async{
    final url = "${AppConfig.base_url}/api/personal/agendar_pedido"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type" : "application/json",
      "Accept": "application/json",}; 

    List<String> productosId=[];
    if(fechaPedido.productoPedido.isNotEmpty){
      this.listProductos(productosId, fechaPedido);
    }
    
    final response = await http.post(
      url, 
      headers: headers,
      body:   json.encode( 
        {
          "fecha_inicio":fechaPedido.fechaInicio.toString(),
          "fecha_final":fechaPedido.fechaFinal.toString(),
          "fecha_entrega":fechaPedido.fechaEntrega.toString(),
          "productos_id":productosId
        }
      )
      );
      print("RESPONSE BODY ${response.body}");
    if(response.body.contains("fechaInicio") && response.body.contains("idFechaPedido")){
      print("ADD-AGENDAR PEDIDO RESPONSE-> ${response.body}");
      FechaPedidoModel fecha = FechaPedidoModel.fromJson(json.decode(response.body));
      return fecha;
    }
    return null;
  }

  Future<Pedido> rechazarPedido(int idPedido)async{
    final url = "${AppConfig.base_url}/api/personal/pedido_rechazar"; 
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
          "idPedido":idPedido,
        }
      )
      );
      print("RESPONSE BODY ${response.body}");
    if(response.body.contains("id")){
      print("CANCELAR-PEDIDO RESPONSE-> ${response.body}");
      Pedido pedido = Pedido.fromJson(json.decode(response.body));
      return pedido;
    }
    return null;
  }

  Future<Pedido> entregarPedido(int idPedido)async{
    final url = "${AppConfig.base_url}/api/personal/pedido_entregar"; 
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
          "idPedido":idPedido,
        }
      )
      );
      print("RESPONSE BODY ${response.body}");
    if(response.body.contains("finalizar") && response.body.contains("rechazado")){
      PedidoBloc bloc = PedidoBloc();     
      bloc.onChangeResponse("EL pedido ya no puede ser entregado");
      return null;
    }
    if(response.body.contains("finalizar") && response.body.contains("message")){
      PedidoBloc bloc = PedidoBloc();     
      bloc.onChangeResponse("No ha llegado la fecha de entrega programada");
      return null;
    }
    if(response.body.contains("id")){
      print("CANCELAR-PEDIDO RESPONSE-> ${response.body}");
      Pedido pedido = Pedido.fromJson(json.decode(response.body));
      return pedido;
    }
    return null;
  }

  
  // Future<bool> deleteTarea(String idTarea)async{
  //   final url = "${AppConfig.base_url}/api/personal/delete_tarea?id_tarea=$idTarea"; 
  //   final token = await _storage.read('token');
  //   Map<String, String> headers = {
  //     HttpHeaders.authorizationHeader: "Bearer $token",
  //     "Accept": "application/json",};

  //   final response = await http.delete(
  //     url, 
  //     headers: headers,
  //     );
    
    
  //   if(response.body.contains("message") && response.body.contains("success")){
  //     print("eliminando");
  //     return true;
  //   }
  //   if(response.statusCode==200)
  //     return true;

  //   print("Error al eliminar");
  //   return false;
  // }

//parameters
   

  void listProductos(List<String> ids,FechaPedidoModel fechaPedidoModel){
    fechaPedidoModel.productoPedido.forEach((h){
      ids.add(h.idProducto.toString());
    });
  }

 
}

