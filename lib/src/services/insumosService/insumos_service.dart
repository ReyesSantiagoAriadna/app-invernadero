
import 'dart:io';

import 'package:app_invernadero_trabajador/src/models/insumos/insumo.dart';
import 'package:app_invernadero_trabajador/src/providers/insumos/insumos_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class InsumoService with ChangeNotifier{
  InsumosProvider insumosProvider = new InsumosProvider();

  List<Insumo> insumoList = List();
  
  final _insumosController =  new BehaviorSubject<List<Insumo>>();
  final _responseController = new BehaviorSubject<String>();

  Stream<List<Insumo>> get insumoStream => _insumosController.stream;
  List<Insumo> get insumos => insumoList;

  Function(String) get changeResponse => _responseController.sink.add;
  String get response => _responseController.value;

  InsumoService(){
    this.getInsumos();
  }

  dispose(){
    _insumosController.close();
    _responseController.close();
  }

  void getInsumos()async{
    final list =  await insumosProvider.getInsumos();
    if(list != [] && list.isNotEmpty){
      this.insumoList.addAll(list);
      _insumosController.sink.add(insumoList);
    }
    notifyListeners();
  }

  Future<bool> fetchInsumos()async{
    final list = await insumosProvider.getInsumos();
    if(list != [] && list.isNotEmpty){
     this.insumoList.addAll(list);
      _insumosController.sink.add(insumoList);
      return true;
    }
    return false;
  }

  Future<bool> addInsumo(Insumo insumo)async{
    final resp = await insumosProvider.addInsumo(insumo);
    if(resp != null){
      this.insumoList.add(resp);
      _insumosController.sink.add(insumoList);
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
}