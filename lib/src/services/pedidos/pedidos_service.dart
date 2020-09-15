import 'package:app_invernadero_trabajador/src/models/actividades/gastos_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/pedidos/fecha_pedido_model.dart';
import 'package:app_invernadero_trabajador/src/models/pedidos/pedido_model.dart';
import 'package:app_invernadero_trabajador/src/providers/actividades/gastos_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/pedidos/pedidos_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PedidosService with ChangeNotifier{
  static PedidosService instance = PedidosService();

  PedidosProvider pedidosProvider = PedidosProvider();

  // SolarCultivoBloc solarCultivoBloc = SolarCultivoBloc();
  
  List<Pedido> pedidosList = List();
  
  

  final _pedidosController = new BehaviorSubject<List<Pedido>>();

  final _responseController = new BehaviorSubject<String>(); 


  Stream<List<Pedido>> get pedidosStream => _pedidosController.stream;

  Function(String) get changeResponse => _responseController.sink.add;

  String get response => _responseController.value;

  List<Pedido> get pedidos => _pedidosController.value;  
  
  PedidosService(){
    this.getPedidos();
  }
  bool _isLoading =false;
  
  dispose(){
    _pedidosController.close();
    _responseController.close();
  }

  


  

  void addPedido(Pedido p){   
    p.isNew=true;
    pedidosList.insert(0,p);
    _pedidosController.sink.add(pedidosList);
  }
  

  Future<bool> getPedidos()async{
    print(">>>>>>>>>>>>>cargando pedidos>>>>>>>>>>>>>");
    final list =  await pedidosProvider.loadPedidos();
    if(list!=[] && list.isNotEmpty){
      this.pedidosList.addAll(list);
      _pedidosController.sink.add(pedidosList);
      return true;
    }
    notifyListeners();
    return true;
  }

  

  Future<bool> fechaPedido(FechaPedidoModel fechaPedido)async{
    final FechaPedidoModel resp = await pedidosProvider.agendarPedido(fechaPedido);
    if(resp!=null){
      // this.gastosList.add(resp);
      // _gastosController.sink.add(gastosList);
      changeResponse("Registro agregado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return true;
    }
  }

  Future<bool> rechazarPedido(int idPedido)async{
    final resp = await pedidosProvider.rechazarPedido(idPedido);
    if(resp!=null){
      int index = this.pedidosList.indexWhere((item)=>item.id==idPedido);  
      print("index de elemento $index"); 
      this.pedidosList[index]=resp;
      _pedidosController.sink.add(pedidosList);
      changeResponse("Pedido rechazado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return false;
    }
  }


  Future<bool> entregarPedido(int idPedido)async{
    final resp = await pedidosProvider.entregarPedido(idPedido);
    if(resp!=null){
      int index = this.pedidosList.indexWhere((item)=>item.id==idPedido);  
      print("index de elemento $index"); 
      this.pedidosList[index]=resp;
      _pedidosController.sink.add(pedidosList);
      changeResponse("Registro actualizado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return false;
    }
  }
  //  Future<bool> deleteGasto(int  idGasto)async{
  //   final resp = await gastosProvider.deleteGasto(idGasto.toString());
  //   if(resp){
  //     this.gastosList.removeWhere((item)=>item.id==idGasto);   
  //     _gastosController.sink.add(gastosList);
  //      changeResponse("Registro eliminado");
  //     return true;
  //   }else{
  //     changeResponse("Algo ha salido mal");
  //     return false;
  //   }
  // }
}