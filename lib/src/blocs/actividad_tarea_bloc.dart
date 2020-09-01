
import 'package:app_invernadero_trabajador/src/blocs/generic_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart' as h;
import 'package:app_invernadero_trabajador/src/models/actividades/insumos_model.dart' as i;
import 'package:app_invernadero_trabajador/src/models/feature/context_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/etapa_cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/tareas/tarea_tipo_widget.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';

import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart' as cu;

import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class ActividadTareaBloc with Validators{

  static final ActividadTareaBloc _singleton = ActividadTareaBloc._internal();
  factory ActividadTareaBloc() {
    return _singleton;
  }

  List<h.Herramienta> herramientaList=[];
  List<i.Insumo> insumoList=[];
  Tarea tareaParameter;

  ActividadTareaBloc._internal();
  
  GenericBloc gB = GenericBloc();
  SolarCultivoBloc solarBloc =SolarCultivoBloc();

  final _tareaController = new BehaviorSubject<Tarea>();
  final _tareaTipoController = new BehaviorSubject<String>();
  final _herramientasController = new BehaviorSubject<List<h.Herramienta>>();
  final _insumosController = new BehaviorSubject<List<i.Insumo>>();


  Stream<Tarea> get tareaStream => _tareaController.stream;
  Stream<String> get tareaTipoStream => _tareaTipoController.stream;
  Stream<List<h.Herramienta>> get herramientasStream => _herramientasController.stream;
  Stream<List<i.Insumo>> get insumosStream => _insumosController.stream;
  

  Function(Tarea) get onChangeTarea => _tareaController.sink.add;
  Function(String) get onChangetTareTipo => _tareaTipoController.sink.add;
  

  Tarea get tarea => _tareaController.value;
  String get tareaTipo => _tareaTipoController.value;
  List<h.Herramienta> get herramientas => _herramientasController.value;
  List<i.Insumo> get insumos => _insumosController.value;


  Stream<bool> get formTarea => 
    CombineLatestStream.combine5(solarBloc.etapaActiveStream,gB.nombreStream,gB.horaIniStream, gB.horaFinStream,
      gB.descripcionStream,
       (e1, e2,e3,e4,e5) => true);
  
  
  
  dipose(){
    _tareaController.close();
  } 
  
  reset(){
    _tareaTipoController.sink.addError('*');
    herramientaList=[];
    insumoList=[];
    _herramientasController.sink.addError('*');
    _insumosController.sink.addError('*');
    // getHerramientaList();
    // getInsumosList();
  }

  void init(BuildContext context, Tarea tarea){
    if(tarea.herramientas.isNotEmpty){
      tarea.herramientas.forEach((f){
        h.Herramienta item = h.Herramienta(
          id: f.codigo,
          nombre: f.nombre,
          descripcion: f.descripcion,
        );
        item.amountOnTask = f.cantidad;
        item.isSelect = true;
        herramientaList.add(item);
      });
      getHerramientaList();
    }

    if(tarea.insumos.isNotEmpty){
      tarea.insumos.forEach((f){
        i.Insumo item = i.Insumo(
          id: f.codigo,
          nombre: f.nombre,
        );
        item.amountOnTask = f.cantidad;
        item.isSelect=true;
        insumoList.add(item);
      });
      getInsumosList();
    }

    Solar sun = Provider
                  .of<SolarCultivoService>(context,listen: false)
                  .solares.firstWhere((item)=>item.id==tarea.cultivo.idFksolar);
    solarBloc.changeSolarActive(sun);
    cu.Cultivo cultivo = sun.cultivos.firstWhere((item)=>item.id == tarea.idFkcultivo);
    solarBloc.changeCultivoActive(cultivo);

    print("Etapas => ${cultivo.etapas.length}"); 
    cultivo.etapas.forEach((f){
      print("Etapa-> ${f.nombre}");
    });
    // Etapa etapa = cultivo.etapas.firstWhere((item)=>item.nombre==tarea.etapa);
    // solarBloc.changeEtapaActive(etapa);

  }

  Tarea prepareParameters(){
    int insum=0;
    int tools=0;
    List<Insumo> iList=[];
    List<Herramienta> hList=[];

    if(insumoList.isNotEmpty){
      insum=1;
      insumos.forEach((f){
        i.Insumo item = f;
        Insumo newItem = Insumo(
          idInsumo: item.id,
          cantidad: item.amountOnTask,
        );
        iList.add(newItem);
      });
    }

    if(herramientaList.isNotEmpty){
      tools=1;
      herramientas.forEach((f){
        h.Herramienta item = f;
        Herramienta newItem= Herramienta(
          idHerramienta: item.id,
          cantidad: item.amountOnTask,
        );
        hList.add(newItem);
      });
    }

    Tarea tarea = Tarea(
      idFkcultivo: solarBloc.cultivoActive.id,
      nombre: gB.nombre,
      etapa: solarBloc.etapaActive.nombre,
      tipo: tareaTipo,
      horaInicio: gB.horaIni,
      horaFinal: gB.horaFin,
      detalle: gB.descripcion,
      insumos: insum==1?iList:[],
      herramientas: tools==1?hList:[]
    );

    return tarea;
  }


  Future<bool> addTarea(BuildContext context)async{
    
    Tarea  tarea = prepareParameters();
    final resp = await Provider
      .of<TareasService>(context,listen: false).addTarea(tarea);
    if(resp)
      return true;
    return false;
  }

  Future<bool> updateTarea(BuildContext context,int idTarea)async{
    
    Tarea  tarea = prepareParameters();
    tarea.id = idTarea;
    final resp = await Provider
      .of<TareasService>(context,listen: false).updateTarea(tarea);
    if(resp)
      return true;
    return false;
  }


  void getHerramientaList(){
    _herramientasController.sink.add(herramientaList);
  }
  void addHerramienta(h.Herramienta h){
    try {
      final tool = herramientaList.firstWhere((test)=>test.id==h.id);
      if(tool!=null){
        tool.cantidad++;
        updateHerramienta(tool);
      }else{
        herramientaList.add(h);
        getHerramientaList();
      }
    } on Exception catch(e) {
    //Handle exception of type SomeException
      print("Exception 1 ${e.toString()}");
     
    } catch(e) {
      print("Exception 2 ${e.toString()}");
    //Handle all other exceptions
      herramientaList.add(h);
      getHerramientaList();
    }
  }

  void deleteHerramienta(h.Herramienta h){
    herramientaList.removeWhere((i)=> i.id == h.id);
    getHerramientaList();
  }

  void updateHerramienta(h.Herramienta h){
    int index = herramientaList.indexWhere((i)=> i.id == h.id);
    herramientaList[index] = h;
    getHerramientaList();
  }

  void decCantidadHerramienta(h.Herramienta h){
    if(h.amountOnTask>1){
      h.amountOnTask--;
      updateHerramienta(h);
    }
  }

  void incCantidadHerramienta(h.Herramienta h){
   // if(h.amountOnTask<=h.cantidad){
      h.amountOnTask++;
      updateHerramienta(h);
    // }
  }


  void getInsumosList(){
    _insumosController.sink.add(insumoList);
  }

  void addInsumo(i.Insumo i){
    insumoList.add(i);
    getInsumosList();
  }

  void deleteInsumo(i.Insumo insumo){
    insumoList.removeWhere((i)=> i.id == insumo.id);
    getInsumosList();
  }

  void updateInsumo(i.Insumo insumo){
    int index = insumoList.indexWhere((i)=> i.id == insumo.id);
    insumoList[index] = insumo;
    getInsumosList();
  }

  void decCantidadInsumo(i.Insumo i){
    if(i.amountOnTask>1){
      i.amountOnTask--;
      updateInsumo(i);
    }
  }

  void incCantidadInsumo(i.Insumo i){
    if(i.amountOnTask<=i.cantidad){
      i.amountOnTask++;
      updateInsumo(i);
    }
  }

}