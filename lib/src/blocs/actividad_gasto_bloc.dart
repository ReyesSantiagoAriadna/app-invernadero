
import 'package:app_invernadero_trabajador/src/blocs/generic_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/gastos_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/sobrantes_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart' as h;
import 'package:app_invernadero_trabajador/src/models/actividades/insumos_model.dart' as i;
import 'package:app_invernadero_trabajador/src/models/feature/context_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/etapa_cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/tareas/tarea_tipo_widget.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/gastos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/productos_services.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart' as cu;
import 'package:intl/intl.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ActividadGastoBloc with Validators{

  static final ActividadGastoBloc _singleton = ActividadGastoBloc._internal();
  factory ActividadGastoBloc() {
    return _singleton;
  }
  ActividadGastoBloc._internal();
  
  SolarCultivoBloc sBloc = SolarCultivoBloc();
  GenericBloc gB = GenericBloc();

  final _herramientaActiveController = new BehaviorSubject<h.Herramienta>();
  final _personalActiveController = new BehaviorSubject<Personal>();


  Stream<h.Herramienta> get herramientaActiveStream => _herramientaActiveController.stream.transform(validateHerramienta);
  Stream<Personal> get personalActiveStream => _personalActiveController.stream.transform(validatePersonal);



  Function(h.Herramienta) get onChangeHerramientaActive => _herramientaActiveController.sink.add;
  Function(Personal) get onChangePersonalActive => _personalActiveController.sink.add;


  h.Herramienta get  herramientaActive => _herramientaActiveController.value;
  Personal get  personalActive => _personalActiveController.value;


  dispose(){
    _herramientaActiveController.close();
    _personalActiveController.close();
  }

  
  Stream<bool> get formBasicBloc => 
    CombineLatestStream.combine4(sBloc.cultivoActiveStream,gB.fechaIniStream,
      gB.decimalStream,gB.descripcionStream,
       (e1, e2,e3,e4) => true);
  Stream<bool> get formGastoHerramienta =>
   CombineLatestStream.combine2(formBasicBloc,herramientaActiveStream,
       (e1, e2) => true);
  Stream<bool> get formGastoPersonal =>
    CombineLatestStream.combine2(formBasicBloc,personalActiveStream,
       (e1, e2) => true);

  init(BuildContext context,Gasto o){
      Solar sun = Provider
      .of<SolarCultivoService>(context,listen: false)
      .solares.firstWhere((item)=>item.id==o.cultivo.idFksolar);
      sBloc.changeSolarActive(sun);
      cu.Cultivo cultivo = sun.cultivos.firstWhere((item)=>item.id == o.cultivo.id);
      sBloc.changeCultivoActive(cultivo);

      if(o.idHerramienta!=null){
        onChangeHerramientaActive(o.herramienta);
      }else if(o.idPersonal!=null){
        onChangePersonalActive(o.personal);
      }
    
  }
  
  

  dipose(){
   
  } 
  
  reset(){
       
  }


  Gasto prepareParameters(){
     var formatter = new DateFormat("yyyy-MM-dd");
    Gasto object = Gasto(
      idFkcultivo: sBloc.cultivoActive.id,
      fecha: DateFormat("yyyy-MM-dd").parse(gB.fechaIni),//DateTime.parse(gB.fechaIni),
      costo: double.parse(gB.decimal),
      descripcion: gB.descripcion,
      idHerramienta: herramientaActive!=null?herramientaActive.id:null,
      idPersonal: personalActive!=null?personalActive.id:null
    );
    return object;
  }

  Future<bool> addGasto(BuildContext context)async{
    
    Gasto  object = prepareParameters();
    final resp = await Provider
      .of<GastosService>(context,listen: false).addGasto(object);
    if(resp)
      return true;
    return false;
  }

  Future<bool> updateGasto(BuildContext context,int id)async{
    Gasto  object = prepareParameters();
    object.id = id;
    final resp = await Provider
      .of<GastosService>(context,listen: false).updateGasto(object);
    if(resp)
      return true;
    return false;
  }


}