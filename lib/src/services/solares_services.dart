
import 'dart:convert';

import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/server/date.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/regiones.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar_model.dart';
import 'package:app_invernadero_trabajador/src/providers/solares_cultivos_provider.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rxdart/rxdart.dart';

class SolarCultivoService with ChangeNotifier{
  
  SolaresCultivosProvider solaresCultivosProvider = SolaresCultivosProvider();
  SolarCultivoBloc solarCultivoBloc = SolarCultivoBloc();
  List<Solar> solarList= List();
  List<Region> regionList = List();


 

  final _solaresController = new BehaviorSubject<List<Solar>>();
  final _responseController = new BehaviorSubject<String>(); 

  final _regionesController = new BehaviorSubject<List<dynamic>>();
  final _dateController = new BehaviorSubject<Date>();

  Stream<List<Solar>> get solarStream =>_solaresController.stream;
  Stream<List<dynamic>> get regionesStream =>_regionesController.stream;
  Stream<Date> get dateStream => _dateController.stream;

  Function(String) get changeResponse => _responseController.sink.add;
  //Function(String) get changeResponse => _responseController.sink.add;
  Function(Date) get changeDate => _dateController.sink.add;
  String get response => _responseController.value;

  
  List<Solar> get solares => solarList;
  Date get date => _dateController.value;
  
  SolarCultivoService(){
    this.getSolares();
    this.regiones();
    this.getDate();
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

  Future<bool> fetchSolares()async{
    print(">>>>>>>>>>>>>cargando Solares>>>>>>>>>>>>>");
    final list =  await solaresCultivosProvider.loadSolares();
    if(list!=[] && list.isNotEmpty){
      this.solarList.addAll(list);
      _solaresController.sink.add(solarList);
      return true;
    }
    return false;
    // notifyListeners();
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
      print("index de elemento $index"); 
      this.solarList[index]=resp;
      _solaresController.sink.add(solarList);
      solarCultivoBloc.onChangeSolar(resp);
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
  
  Future<bool> addCultivo(Cultivo cultivo,int etapas)async{
    final Cultivo resp = await solaresCultivosProvider.addCultivo(cultivo,etapas);
    if(resp!=null){
      int index = this.solarList.indexWhere((item)=>item.id==cultivo.idFksolar);  
      Solar s = solarList[index];
      s.cultivos.add(resp);
      solarList[index] = s; 
      _solaresController.sink.add(solarList);
      solarCultivoBloc.onChangeSolar(s);
      changeResponse("Cultivo Agregado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return true;
    }
  }

  void getDate()async{
    final date =await solaresCultivosProvider.getDate();
    if(date!=null){
      changeDate(date);
    }
  }
  
  Future<bool> updateCultivo(Cultivo cultivo,int etapas)async{
    final Cultivo resp = await solaresCultivosProvider.updateCultivo(cultivo,etapas);
    if(resp!=null){
      int index = this.solarList.indexWhere((item)=>item.id==cultivo.idFksolar);  
      Solar s = solarList[index];
      
      int indexcultivo = s.cultivos.indexWhere((item)=>item.id==cultivo.id);  
      s.cultivos[indexcultivo] = resp;

      solarList[index] = s; 
      _solaresController.sink.add(solarList);
      solarCultivoBloc.onChangeSolar(s);
      changeResponse("Cultivo editado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return true;
    }
  }

   Future<bool> deleteCultivo(int idSolar,int  idCultivo)async{
    final resp = await solaresCultivosProvider.deleteCultivo(idCultivo.toString());
    if(resp){
      int index = this.solarList.indexWhere((item)=>item.id==idSolar);  
      Solar s = solarList[index];
      s.cultivos.removeWhere((item)=>item.id==idCultivo); 
      solarList[index] = s; 
      _solaresController.sink.add(solarList);
      solarCultivoBloc.onChangeSolar(s);
      changeResponse("cultivo eliminado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return false;
    }
  }
}