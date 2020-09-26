
import 'dart:io';

import 'package:app_invernadero_trabajador/src/blocs/generic_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/sobrantes_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart' as h;
import 'package:app_invernadero_trabajador/src/models/actividades/insumos_model.dart' as i;
import 'package:app_invernadero_trabajador/src/models/feature/context_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/etapa_cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/tareas/tarea_tipo_widget.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/productos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart' as cu;

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ActividadProductoBloc with Validators{

  static final ActividadProductoBloc _singleton = ActividadProductoBloc._internal();
  factory ActividadProductoBloc() {
    return _singleton;
  }
  ActividadProductoBloc._internal();
  SolarCultivoBloc sBloc = SolarCultivoBloc();
  GenericBloc gB = GenericBloc();

  final _kilosXcajaController = new BehaviorSubject<String>();
  final _precioMayController = new BehaviorSubject<String>();
  final _precioMenController = new BehaviorSubject<String>();
  final _cantidadController = new BehaviorSubject<String>();
  final _urlImagenController = new BehaviorSubject<String>();

  Stream<String> get kilosXcajaStream => _kilosXcajaController.stream.transform(validateInteger);
  Stream<String> get precioMenStream => _precioMenController.stream.transform(validateMenudeo);
  Stream<String> get precioMayStream => _precioMayController.stream.transform(validateDecimal);
  Stream<String> get cantidadStream => _cantidadController.stream.transform(validateDecimal);
  Stream<String> get urlImagenSteam => _urlImagenController.stream.transform(validateUrlImagenProducto);
  

  Function(String) get onChangeKilosXcaja => _kilosXcajaController.sink.add;
  Function(String) get onChangePrecioMen => _precioMenController.sink.add;
  Function(String) get onChangePrecioMay => _precioMayController.sink.add;
  Function(String) get onChangeCantidad => _cantidadController.sink.add;
  Function(String) get onChangeUrlImagen => _urlImagenController.sink.add;


  String get kilosXcaja => _kilosXcajaController.value;
  String get precioMen => _precioMenController.value;
  String get precioMay => _precioMayController.value;
  String get cantidad => _cantidadController.value;
  String get urlImagen => _urlImagenController.value;
  

  dispose(){
    _kilosXcajaController.close();
    _precioMayController.close();
    _precioMenController.close();
    _cantidadController.close();
    _urlImagenController.close();
  }

  
  Stream<bool> get formProducto => 
    CombineLatestStream.combine6(sBloc.cultivoActiveStream,gB.nombreStream,kilosXcajaStream,
      precioMayStream,precioMenStream, cantidadStream,
       (e1, e2,e3,e4,e5,e6) => true);
  
  init(BuildContext context,Producto p){
      Solar sun = Provider
      .of<SolarCultivoService>(context,listen: false)
      .solares.firstWhere((item)=>item.id==p.cultivo.idFksolar);
      sBloc.changeSolarActive(sun);
      cu.Cultivo cultivo = sun.cultivos.firstWhere((item)=>item.id == p.cultivo.id);
      sBloc.changeCultivoActive(cultivo);
    
  }
  
  

  dipose(){
   
  } 
  
  reset(){
    _kilosXcajaController.sink.addError('*');
    _precioMayController.sink.addError('*');
    _precioMenController.sink.addError('*');
    _cantidadController.sink.addError('*');    
  }


  Producto prepareParameters(){
    Producto p = Producto(
      idCultivo: sBloc.cultivoActive.id,
      nombre: gB.nombre,
      equiKilos: int.parse(kilosXcaja),
      precioMay: double.parse(precioMay),
      precioMen: double.parse(precioMen),
      cantExis: int.parse(cantidad),
      urlImagen: urlImagen //'https://res.cloudinary.com/dtev8lpem/image/upload/v1591389058/xfc3pn8i7hvayb2u7qim.png',
    );
    return p;
  }
  Future<bool> addProducto(BuildContext context)async{
    
    Producto  p = prepareParameters();
    final resp = await Provider
      .of<ProductosService>(context,listen: false).addProducto(p);
    if(resp)
      return true;
    return false;
  }

  Future<bool> updateProducto(BuildContext context,int id)async{
    Producto  p = prepareParameters();
    p.id = id;
    final resp = await Provider
      .of<ProductosService>(context,listen: false).updateProducto(p);
    if(resp)
      return true;
    return false;
  } 

  Future<String> subirFoto(BuildContext context, File foto) async{
    final fotoUrl = await Provider
      .of<ProductosService>(context,listen: false).subirFoto(foto);  
     return fotoUrl; 
    
  }


}