
import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/solares_cultivos/regiones.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar_model.dart';
import 'package:app_invernadero_trabajador/src/providers/solares_cultivos_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class SolarCultivoService with ChangeNotifier{
  
  SolaresCultivosProvider solaresCultivosProvider = SolaresCultivosProvider();
  
  List<Solar> solarList= List();
  List<Region> regionList = List();

 

  final _solaresController = new BehaviorSubject<List<Solar>>();
  final _responseController = new BehaviorSubject<String>(); 

  final _regionesController = new BehaviorSubject<List<dynamic>>();

  Stream<List<Solar>> get solarStream =>_solaresController.stream;
  Stream<List<dynamic>> get regionesStream =>_regionesController.stream;
  

  Function(String) get changeResponse => _responseController.sink.add;
  //Function(String) get changeResponse => _responseController.sink.add;


  String get response => _responseController.value;

  
  List<Solar> get solares => solarList;
  
  
  SolarCultivoService(){
    this.getSolares();
    this.regiones();
  }
  
  
  dispose(){
    _solaresController.close();
    _responseController.close();
  }

  void  regiones() async{
    final resp = await rootBundle.loadString('data/regionalizacion.json');
    RegionesModel regiones = RegionesModel.fromJson(json.decode(resp));
    regionList = regiones.regiones.cast();

    
    notifyListeners();
  }


  void getSolares()async{
    print(">>>>>>>>>>>>>cargando Solares>>>>>>>>>>>>>");
    final list =  await solaresCultivosProvider.loadSolares();
    if(list!=[] && list.isNotEmpty){
      this.solarList.addAll(list);
      _solaresController.sink.add(solarList);
    }
    notifyListeners();
  }

  Future<bool> addSolar(Solar solar)async{
    final Solar resp = await solaresCultivosProvider.addSolar(solar);
    if(resp!=null){
      this.solarList.add(resp);
      _solaresController.sink.add(solarList);
      changeResponse("Registro agregado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return true;
    }
  }

  Future<bool> updateSolar(Solar solar)async{
    final resp = await solaresCultivosProvider.updateSolar(solar);
    if(resp!=null){
      int index = this.solarList.indexWhere((item)=>item.id==solar.id);   
      this.solarList[index]=resp;
      this.solarList.add(resp);
      _solaresController.sink.add(solarList);
      changeResponse("Registro actualizado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return false;
    }
  }


  Future<bool> deleteSolar(int  idSolar)async{
    final resp = await solaresCultivosProvider.deleteSolar(idSolar.toString());
    if(resp){
      this.solarList.removeWhere((item)=>item.id==idSolar);   
      _solaresController.sink.add(solarList);
       changeResponse("Registro eliminado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return false;
    }
  }



}