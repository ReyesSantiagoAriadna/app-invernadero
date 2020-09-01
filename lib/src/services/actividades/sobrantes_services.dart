import 'package:app_invernadero_trabajador/src/models/actividades/gastos_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/sobrantes_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/providers/actividades/gastos_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/actividades/sobrantes_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class SobrantesService with ChangeNotifier{
  
  SobrantesProvider sobrantesProvider = SobrantesProvider();

  // SolarCultivoBloc solarCultivoBloc = SolarCultivoBloc();
  
  List<Sobrante> sobrantesList = List();

  

  final _sobrantesController = new BehaviorSubject<List<Sobrante>>();
  final _responseController = new BehaviorSubject<String>(); 
  final _productosController = new BehaviorSubject<List<Producto>>();

  Stream<List<Sobrante>> get sobranteStream => _sobrantesController.stream;
  Stream<List<Producto>> get productosStream => _productosController.stream;

  Function(String) get changeResponse => _responseController.sink.add;
  

  String get response => _responseController.value;

  List<Sobrante> get sobrantes => sobrantesList;
  List<Producto> get productos => _productosController.value;

  
  SobrantesService(){
    this.getSobrantes();
  }
  
  
  dispose(){
    _sobrantesController.close();
    _responseController.close();
  }

  


  void getSobrantes()async{
    print(">>>>>>>>>>>>>cargando sobrantes>>>>>>>>>>>>>");
    final list =  await sobrantesProvider.loadSobrantes();
    if(list!=[] && list.isNotEmpty){
      this.sobrantesList.addAll(list);
      _sobrantesController.sink.add(sobrantesList);
    }
    notifyListeners();
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

  Future<bool> addSobrante(Sobrante sobrante)async{
    final Sobrante resp = await sobrantesProvider.addSobrante(sobrante);
    if(resp!=null){
      this.sobrantesList.add(resp);
      _sobrantesController.sink.add(sobrantesList);
      changeResponse("Registro agregado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return true;
    }
  }

  Future<bool> updateSobrante(Sobrante sobrante)async{
    final resp = await sobrantesProvider.updateSobrante(sobrante);
    if(resp!=null){
      int index = this.sobrantesList.indexWhere((item)=>item.id==sobrante.id);  
      print("index de elemento $index"); 
      this.sobrantesList[index]=resp;
      _sobrantesController.sink.add(sobrantesList);
      //solarCultivoBloc.onChangeSolar(resp); <__in stream
      changeResponse("Registro actualizado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return false;
    }
  }

  Future<bool> deleteSobrante(int  idSobrante)async{
    final resp = await sobrantesProvider.deleteSobrante(idSobrante.toString());
    if(resp){
      this.sobrantesList.removeWhere((item)=>item.id==idSobrante);   
      _sobrantesController.sink.add(sobrantesList);
       changeResponse("Registro eliminado");
      return true;
    }else{
      changeResponse("Algo ha salido mal");
      return false;
    }
  }

  void productosCultivo(String cultivo)async{
    final list = await sobrantesProvider.productosCultivo(cultivo);
    _productosController.sink.add(list);
    
  }
}