import 'dart:io';

import 'package:app_invernadero_trabajador/src/models/inventario_herramientas/herramienta.dart';
import 'package:app_invernadero_trabajador/src/providers/inventarioProvider/inventario_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class InventarioService with ChangeNotifier {
  InventarioProvider inventarioProvider = InventarioProvider();

  List<Herramienta> herramientaList = List();

  final _herramientasController = new BehaviorSubject<List<Herramienta>>();
  final _responseController = new BehaviorSubject<String>();

  Stream<List<Herramienta>> get herramientaStream => _herramientasController.stream;
  List<Herramienta> get herramientas => herramientaList;

  Function(String) get changeResponse => _responseController.sink.add;
  String get response => _responseController.value;

  InventarioService(){
    this.getHerramientas();
  }

  dispose(){
    _herramientasController.close();
    _responseController.close();
  }

  void getHerramientas() async{
    final list = await inventarioProvider.cargarHerramientas();
    if(list != [] && list.isNotEmpty){
      this.herramientaList.addAll(list);
      _herramientasController.sink.add(herramientaList);
    }
    notifyListeners();
  }

  Future<bool> fetchHerramientas()async{
    final list = await inventarioProvider.cargarHerramientas();
    if(list != [] && list.isNotEmpty){
      this.herramientaList.addAll(list);
      _herramientasController.sink.add(herramientaList);
      return true;
    }
    return false;
  }

  Future<bool> addHerramienta(Herramienta herramienta)async{
    final resp = await inventarioProvider.addHerramienta(herramienta);
    if(resp != null){
      this.herramientaList.add(resp);
      _herramientasController.sink.add(herramientaList); 
      changeResponse('success');
      return true;
    }else {
      changeResponse('Algo salio mal');
      return false;
    }
  }

  Future<bool> updateHerramienta(Herramienta herramienta)async{
    final resp = await inventarioProvider.updateHerramienta(herramienta);
    if(resp != null){
      int index = this.herramientaList.indexWhere((item)=>item.id==herramienta.id);
      this.herramientaList[index]=resp;
      _herramientasController.sink.add(herramientaList);
      changeResponse("Registro actualizado");
      return true;
    }else {
      changeResponse("Algo salio mal");
      return false;
    }
  }

  Future<String> subirFoto(File foto) async{
    final fotoUrl = await inventarioProvider.subirImagenCloudinary(foto);
    if(fotoUrl != null){
      changeResponse("Imagen cargada");
      return fotoUrl;
    }else {
      changeResponse("Algo salio mal");
      return "";
    }
  }

  Future<bool> deleteHerramientas(int idHerramienta)async{
    final resp = await inventarioProvider.deleteHerramienta(idHerramienta);
    if(resp){
      this.herramientaList.removeWhere((item)=>item.id==idHerramienta);
      _herramientasController.sink.add(herramientaList);
      changeResponse("Registro eliminado");
      return true;
    }else {
      changeResponse("Algo salio mal");
      return false;
    }
  }
}