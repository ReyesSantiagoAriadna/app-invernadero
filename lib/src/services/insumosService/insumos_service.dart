import 'dart:io';

import 'package:app_invernadero_trabajador/src/models/insumos/insumo.dart';
import 'package:app_invernadero_trabajador/src/models/proveedores/proveedor.dart';
import 'package:app_invernadero_trabajador/src/providers/insumos/insumos_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class InsumoService with ChangeNotifier{
  InsumosProvider insumosProvider = new InsumosProvider();

  List<Insumo> insumoList = List(); 
  List<Insumo> insumoSelect = List();
  List<Proveedor> proveedorList = List();
  
  final _insumosController =  new BehaviorSubject<List<Insumo>>();
  final _responseController = new BehaviorSubject<String>();
  final _proveedorController = new BehaviorSubject<List<Proveedor>>();
  final _insumoSelectController =  new BehaviorSubject<List<Insumo>>();
  
  Stream<List<Insumo>> get insumoStream => _insumosController.stream;
  Stream<List<Proveedor>> get proveedorStream => _proveedorController.stream;
  Stream<List<Insumo>> get insumoSelectStream => _insumoSelectController.stream;

  Function(String) get changeResponse => _responseController.sink.add;
  String get response => _responseController.value;

  List<Insumo> get insumos => insumoList;
  List<Proveedor> get proveedores => _proveedorController.value;
  List<Insumo> get insumoSelet => _insumoSelectController.value;

  InsumoService(){
    this.getInsumos(); 
    this.getProveedores();
    this.getInsumosSelect();
  }

  dispose(){
    _insumosController.close();
    _responseController.close(); 
    _insumoSelectController.close();
  }

  void getInsumos()async{
    final list =  await insumosProvider.loadInsumos();
    if(list != [] && list.isNotEmpty){
      this.insumoList.addAll(list);
      _insumosController.sink.add(insumoList);
    }
    notifyListeners();
  }

  Future<bool> fetchInsumos()async{ 
    final list = await insumosProvider.loadInsumos(); 
    if(list != [] && list.isNotEmpty){
     this.insumoList.addAll(list);
      _insumoSelectController.sink.add(insumoList);
      return true;
    }
    return false;
  }

  void getInsumosSelect()async{
     print("--------------insumos select --------------");
    final list =  await insumosProvider.loadInsumosSelect();
    if(list != [] && list.isNotEmpty){
      this.insumoSelect.addAll(list);
      _insumoSelectController.sink.add(insumoSelect);
    }
    notifyListeners();
  }

  Future<bool> fetchInsumosSelect()async{
    print("--------------insumos select fetch--------------");
    final list = await insumosProvider.loadInsumosSelect();
    print(list.toString());
    if(list != [] && list.isNotEmpty){
     this.insumoSelect.addAll(list);
      _insumoSelectController.sink.add(insumoSelect);
      return true;
    }
    return false;
  }

  void getDesSelect()async{
    final list = await insumosProvider.loadInsumos();
    for (var i = 0; i < list.length; i++) {
      
    }
  }
 

  Future<bool> addInsumo(Insumo insumo)async{
    final resp = await insumosProvider.addInsumo(insumo);
    if(resp != null){
      this.insumoList.add(resp);
      _insumosController.sink.add(insumoList);
      //-------select
      this.insumoSelect.add(resp);
      _insumoSelectController.sink.add(insumoSelect);
      changeResponse('succes');
      return true;
    }else {
      changeResponse('Algo salio mal');
      return false;
    }
  }

  Future<bool> updateInsumo(Insumo insumo)async{
    final resp = await insumosProvider.updateInsumo(insumo);
    if(resp != null){
      int index = this.insumoList.indexWhere((item)=>item.id==insumo.id);
      this.insumoList[index]=resp;
      _insumosController.sink.add(insumoList);
      changeResponse('Registro actualizado');
      return true;
    }else {
      changeResponse('Algo salio mal');
      return false;
    }
  } 

   Future<String> subirFoto(File foto) async{
    final fotoUrl = await insumosProvider.subirImagenCloudinary(foto);
    if(fotoUrl != null){
      changeResponse("Imagen cargada");
      return fotoUrl;
    }else {
      changeResponse("Algo salio mal");
      return "";
    }
    
  }

  void getProveedores()async{
    print("--------------proveedores-------------------");
    final list = await insumosProvider.getProveedores();
    if(list!=null && list.isNotEmpty){
      this.proveedorList.addAll(list);
      _proveedorController.sink.add(proveedorList); 
    }
    notifyListeners();
  }

  Future<bool> fetchProveedores()async{
    print(">>>>>>>>>>>>>cargando proveedores>>>>>>>>>>>>>");
    final list =  await insumosProvider.getProveedores();
    if(list!=[] && list.isNotEmpty){
      this.proveedorList.addAll(list);
      _proveedorController.sink.add(proveedorList);
      return true;
    }
    return false; 
  }
 
  Future<bool> addCompra(List<String> insumos, List<String> cantidades,List<String> precios, int proveedor)async{
    final list = await insumosProvider.addCompra(insumos, cantidades, precios, proveedor);
    if(list != [] && list.isNotEmpty){ 
      //this.insumoList.addAll(list);
      _insumosController.sink.add(list);
      notifyListeners();
      return true;
    }
    notifyListeners();
    return false;
  } 

  Future<bool> deleteInsumo(int idInsumo)async{
    final resp = await insumosProvider.deleteInsumo(idInsumo);
    if(resp){
      this.insumoList.removeWhere((item)=>item.id==idInsumo);
      _insumosController.sink.add(insumoList);
      changeResponse("Registro eliminado");
      return true;
    }else {
      changeResponse("Algo salio mal");
      return false;
    }
  }

}