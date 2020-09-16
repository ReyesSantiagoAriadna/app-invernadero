import 'dart:io';

import 'package:app_invernadero_trabajador/src/models/trabajador/trabajador.dart';
import 'package:app_invernadero_trabajador/src/providers/user_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class TrabajadorService with ChangeNotifier{
  UserProvider userProvider = UserProvider();

  final _trabajadorController = new BehaviorSubject<Trabajador>();
  final _responseController = new BehaviorSubject<String>();

  Stream<Trabajador> get trabajadorStream => _trabajadorController.stream;
  Function(Trabajador) get changeTrabajador => _trabajadorController.sink.add;
  Trabajador get trabajador => _trabajadorController.value;

  Function(String) get changeResponse => _responseController.sink.add;
   String get response => _responseController.value;

  TrabajadorService(){
    this.getTrabajador();
  }

  void getTrabajador()async{
    final trabajador = await userProvider.getTrabajador();
    _trabajadorController.sink.add(trabajador);
  }

  Future<bool> updateNombre(String nameTrabajador)async{
    final resp = await userProvider.updateName(nameTrabajador);
      if(resp != null){
        _trabajadorController.sink.add(resp);
        changeResponse('Resgistro actualizado');
        return true;
      }else {
        changeResponse('Algo salio mal');
        return false;
      }
  }

  Future<bool> updateApaterno(String aPaterno)async{
    final resp = await userProvider.updateApaterno(aPaterno);
     if(resp != null){
        _trabajadorController.sink.add(resp);
        changeResponse('Resgistro actualizado');
        return true;
      }else {
        changeResponse('Algo salio mal');
        return false;
      }
  }

  Future<bool> updateAmaterno(String aMaterno)async{
    final resp = await userProvider.updateAmaterno(aMaterno);
     if(resp != null){
        _trabajadorController.sink.add(resp);
        changeResponse('Resgistro actualizado');
        return true;
      }else {
        changeResponse('Algo salio mal');
        return false;
      }
  }

  Future<bool> updateRfc(String rfc)async{
    final resp = await userProvider.updateRfc(rfc);
     if(resp != null){
        _trabajadorController.sink.add(resp);
        changeResponse('Resgistro actualizado');
        return true;
      }else {
        changeResponse('Algo salio mal');
        return false;
      }
  }

  Future<bool> updatePhoto(String  urlImagen)async{
    final resp = await userProvider.updatePhoto(urlImagen);
      if(resp != null){
        _trabajadorController.sink.add(resp);
        changeResponse('Resgistro actualizado');
        return true;
      }else {
        changeResponse('Algo salio mal');
        return false;
      }
  }
  
  Future<String> subirFoto(File foto) async{
    final fotoUrl = await userProvider.subirImagenCloudinary(foto);
    changeResponse('Imagen cargada');
    return fotoUrl;
    
  }

  dispose(){
    _trabajadorController.close();
    _responseController.close();
  }
}