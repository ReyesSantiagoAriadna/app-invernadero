
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar_model.dart';
import 'package:app_invernadero_trabajador/src/providers/solares_cultivos_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SolarCultivoService with ChangeNotifier{
  
  SolaresCultivosProvider solaresCultivosProvider = SolaresCultivosProvider();
  
  List<Solar> solarList= List();
  
  final _solaresController = new BehaviorSubject<List<Solar>>();
  final _responseController = new BehaviorSubject<String>(); 

  Stream<List<Solar>> get solarStream =>_solaresController.stream;
  
  Function(String) get changeResponse => _responseController.sink.add;

  String get response => _responseController.value;

  
  List<Solar> get solares => solarList;
  
  
  SolarCultivoService(){
    this.getSolares();
  }
  
  
  dispose(){
    _solaresController.close();
    _responseController.close();
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

  void addSolar(Solar solar)async{
    final resp = await solaresCultivosProvider.addSolar(solar);
    if(resp!=null){
      this.solarList.add(resp);
      _solaresController.sink.add(solarList);
      changeResponse("succes");
    }else{
      changeResponse("Algo ha salido mal");
    }
  }

  void updateSolar(Solar solar)async{
    final resp = await solaresCultivosProvider.updateSolar(solar);
    if(resp!=null){
      this.solarList.removeWhere((item)=>item.id==solar.id);   
      this.solarList.add(resp);
      _solaresController.sink.add(solarList);
    }else{
      changeResponse("Algo ha salido mal");
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