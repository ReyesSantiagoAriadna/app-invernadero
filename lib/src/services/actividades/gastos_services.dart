import 'package:app_invernadero_trabajador/src/models/actividades/gastos_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/providers/actividades/gastos_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class GastosService with ChangeNotifier{
  
  GastosProvider gastosProvider = GastosProvider();

  // SolarCultivoBloc solarCultivoBloc = SolarCultivoBloc();
  
  List<Gasto> gastosList = List();
  List<Personal> personalList = List();
  

  final _gastosController = new BehaviorSubject<List<Gasto>>();
  final _personalController = new BehaviorSubject<List<Personal>>();

  final _responseController = new BehaviorSubject<String>(); 


  Stream<List<Gasto>> get gastosStream => _gastosController.stream;
  Stream<List<Personal>> get personalStream => _personalController.stream;  

  Function(String) get changeResponse => _responseController.sink.add;

  String get response => _responseController.value;

  List<Gasto> get gastos => gastosList;
  List<Personal> get personal => personalList;  
  
  GastosService(){
    this.getGastos();
    this.getPersonal();
  }
  
  
  dispose(){
    _gastosController.close();
    _responseController.close();
  }

  


  Future<bool> getGastos()async{
    print(">>>>>>>>>>>>>cargando Gastos>>>>>>>>>>>>>");
    final list =  await gastosProvider.loadGastos();
    if(list!=[] && list.isNotEmpty){
      this.gastosList.addAll(list);
      _gastosController.sink.add(gastosList);
      return true;
    }
    notifyListeners();
    return false;
  }

  Future<bool> getPersonal()async{
    print(">>>>>>>>>>>>>cargando personal>>>>>>>>>>>>>");
    final list =  await gastosProvider.loadPersonal();
    if(list!=[] && list.isNotEmpty){
      this.personalList.addAll(list);
      _personalController.sink.add(personalList);
      return true;
    }
    notifyListeners();
    return true;
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

  Future<bool> addGasto(Gasto gasto)async{
    final Gasto resp = await gastosProvider.addGasto(gasto);
    if(resp!=null){
      this.gastosList.add(resp);
      _gastosController.sink.add(gastosList);
      changeResponse("Registro agregado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return true;
    }
  } 
  
  Future<bool> updateGasto(Gasto gasto)async{
    final resp = await gastosProvider.updateGasto(gasto);
    if(resp!=null){
      int index = this.gastosList.indexWhere((item)=>item.id==gasto.id);  
      print("index de elemento $index"); 
      this.gastosList[index]=resp;
      _gastosController.sink.add(gastosList);
      //solarCultivoBloc.onChangeSolar(resp); <__in stream
      changeResponse("Registro actualizado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return false;
    }
  }

   Future<bool> deleteGasto(int  idGasto)async{
    final resp = await gastosProvider.deleteGasto(idGasto.toString());
    if(resp){
      this.gastosList.removeWhere((item)=>item.id==idGasto);   
      _gastosController.sink.add(gastosList);
       changeResponse("Registro eliminado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return false;
    }
  }
}