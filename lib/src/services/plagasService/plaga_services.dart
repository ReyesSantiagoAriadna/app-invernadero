import 'dart:io';

import 'package:app_invernadero_trabajador/src/models/plagasEnfermedades/plaga.dart';
import 'package:app_invernadero_trabajador/src/providers/plagaProvider/plaga_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class PlagaService with ChangeNotifier {
  PlagaProvider plagaProvider = PlagaProvider();

  List<Plagas> plagaList = List();

  final _plagasController = new BehaviorSubject<List<Plagas>>();
  final _responseController =  new BehaviorSubject<String>();

  Stream<List<Plagas>> get plagaStream => _plagasController.stream;
  
  Function(String) get changeResponse => _responseController.sink.add;

  String get response => _responseController.value;

  List<Plagas> get plagas => plagaList;

  PlagaService(){
    this.getPlagas();
  }

  dispose(){
    _plagasController.close();
    _responseController.close();
  }

  void getPlagas() async{
    final list = await plagaProvider.cargarPlagas();
    if(list != [] && list.isNotEmpty){
      this.plagaList.addAll(list);
      _plagasController.sink.add(plagaList);
    }
    notifyListeners();
  }

  Future<bool> fetchPlagas()async{
    final list = await plagaProvider.cargarPlagas();
    if(list !=[] && list.isNotEmpty){
      this.plagaList.addAll(list);
      _plagasController.sink.add(plagaList);
      return true;
    }
    return false;
  }

  void addPlaga(Plagas plaga) async{
    final resp = await plagaProvider.addPlaga(plaga);
    if(resp != null){
      this.plagaList.add(resp);
      _plagasController.sink.add(plagaList);
      changeResponse("succes");
    }else{
      changeResponse("Algo ha salido mal");
    }
  }

  Future<bool> updatePlaga(Plagas plaga)async{ 
     final resp = await plagaProvider.updatePlaga(plaga);
    if(resp !=  null){
      print(resp.id);
      int index = this.plagaList.indexWhere((item)=>item.id==plaga.id);
      this.plagaList[index]=resp;
      _plagasController.sink.add(plagaList);
      changeResponse("Resgistro actualizadp");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return false;
    } 
  }

  Future<bool> deletePlaga(int idPlaga)async{
    final resp = await plagaProvider.deletePlaga(idPlaga);
    if(resp){
      this.plagaList.removeWhere((item) => item.id==idPlaga);
      _plagasController.sink.add(plagaList);
      changeResponse("Registro eliminado");
      return true;
    }else{
        changeResponse("Algo ha salido mal");
        return false;
      
      }
  }

  Future<String> subirFoto(File foto) async{
    final fotoUrl = await plagaProvider.subirImagenCloudinary(foto);
    changeResponse('Imagen cargada');
    return fotoUrl;
    
  }



}