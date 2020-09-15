
import 'dart:convert';

import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/regiones.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar_model.dart';
import 'package:app_invernadero_trabajador/src/providers/actividades/tareas_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/solares_cultivos_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart' as herramienta;
import 'package:app_invernadero_trabajador/src/models/actividades/insumos_model.dart' as insumo;

class TareasService with ChangeNotifier{
  static TareasService instance = new TareasService();
  TareasProvider tareasProvider = TareasProvider();

  // SolarCultivoBloc solarCultivoBloc = SolarCultivoBloc();
  
  List<Tarea> tareasList = List();
  List<herramienta.Herramienta> herramientasList = List();
  List<insumo.Insumo> insumosList = List();
  

  final _tareasController = new BehaviorSubject<List<Tarea>>();
  final _herramientasController = new BehaviorSubject<List<herramienta.Herramienta>>();
  final _insumosController = new BehaviorSubject<List<insumo.Insumo>>();

  final _responseController = new BehaviorSubject<String>(); 


  Stream<List<Tarea>> get tareasStream => _tareasController.stream;
  Stream<List<herramienta.Herramienta>> get herramientasStream => _herramientasController.stream;
  Stream<List<insumo.Insumo>> get insumosStream => _insumosController.stream;
  

  Function(String) get changeResponse => _responseController.sink.add;
  

  String get response => _responseController.value;

  List<Tarea> get solares => tareasList;
  List<herramienta.Herramienta> get herramientas => _herramientasController.value;
  List<insumo.Insumo> get insumos => _insumosController.value;
  
  TareasService(){
    print("cargando data de tareasServices...");
    this.getTareas();
    this.getHerramientas();
    this.getInsumos();
    
  }
  
  
  dispose(){
    _tareasController.close();
    _responseController.close();
  }

  

  
  Future<bool> getTareas()async{
    print(">>>>>>>>>>>>>cargando Tareas>>>>>>>>>>>>>");
    final list =  await tareasProvider.loadTareas();
    if(list!=[] && list.isNotEmpty){
      this.tareasList.addAll(list);
      _tareasController.sink.add(tareasList);
      return true;
    }
    notifyListeners();
    return false;
  }


  void getHerramientas()async{
    print(">>>>>>>>>>>>>cargando Herramientas>>>>>>>>>>>>>");
    final list =  await tareasProvider.loadHerramientas();
    if(list!=[] && list.isNotEmpty){
      this.herramientasList.addAll(list);
      _herramientasController.sink.add(herramientasList);
    }
    notifyListeners();
  }

  Future<bool> getInsumos()async{
    print(">>>>>>>>>>>>>cargando Insumos>>>>>>>>>>>>>");
    final list =  await tareasProvider.loadInsumos();
    if(list!=[] && list.isNotEmpty){
      this.insumosList.addAll(list);
      _insumosController.sink.add(insumosList);
      return true;
    }
    // notifyListeners();
    return false;
  }

  
  // Future<bool> fetchSolares()async{
  //   print(">>>>>>>>>>>>>cargando Solares>>>>>>>>>>>>>");
  //   final list =  await solaresCultivosProvider.loadSolares();
  //   if(list!=[] && list.isNotEmpty){
  //     this.solarList.addAll(list);
  //     _solaresController.sink.add(solarList);
  //     return true;
  //   }
  //   return false;
  //   // notifyListeners();
  // }
  Future<bool> fetchHerramientas()async{
    print(">>>>>>>>>>>>>cargando Herramientas>>>>>>>>>>>>>");
    final list =  await tareasProvider.loadHerramientas();
    if(list!=[] && list.isNotEmpty){
      this.herramientasList.addAll(list);
      _herramientasController.sink.add(herramientasList);
      return true;
    }
    return false;
    // notifyListeners();
  }

  Future<bool> addTarea(Tarea tarea)async{
    final Tarea resp = await tareasProvider.addTarea(tarea);
    if(resp!=null){
      this.tareasList.add(resp);
      _tareasController.sink.add(tareasList);
      changeResponse("Registro agregado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return true;
    }
  }

  Future<bool> updateTarea(Tarea tarea)async{
    final resp = await tareasProvider.updateTarea(tarea);
    if(resp!=null){
      int index = this.tareasList.indexWhere((item)=>item.id==tarea.id);  
      print("index de elemento $index"); 
      this.tareasList[index]=resp;
      _tareasController.sink.add(tareasList);
      //solarCultivoBloc.onChangeSolar(resp); <__in stream
      changeResponse("Registro actualizado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return false;
    }
  }

   Future<bool> deleteTarea(int  idTarea)async{
    final resp = await tareasProvider.deleteTarea(idTarea.toString());
    if(resp){
      this.tareasList.removeWhere((item)=>item.id==idTarea);   
      _tareasController.sink.add(tareasList);
       changeResponse("Registro eliminado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return false;
    }
  }

  
  

}