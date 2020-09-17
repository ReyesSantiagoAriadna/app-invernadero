import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:app_invernadero_trabajador/src/models/employee/tareas_trabajador_model.dart';
import 'package:app_invernadero_trabajador/src/models/task/tarea_date_mode.dart';
import 'package:app_invernadero_trabajador/src/providers/task/new_task_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/task/tasks_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart' as tm;


class TaskService  with ChangeNotifier,Validators{
  

  //* CLASE PARA ADMINISTRADORESSSSS*/

  
  static TaskService instance = TaskService();
  
  NewTaskProvider taskProvider = NewTaskProvider();
  SolarCultivoBloc solarBloc = SolarCultivoBloc();
  Map<DateTime, List<TareasTrabajadorElement>> tasksMap = new Map(); 
  
  List<Personal> personalList = new List();

  final _tasksDateKeyController =  new BehaviorSubject<DateTime>();
  final _tasksCalendarController = new BehaviorSubject<Map<DateTime, List<TareasTrabajadorElement>>>();
  final _tasksCalendarEventsController = new BehaviorSubject<List>();
  
  final _responseController = new BehaviorSubject<String>();
  final _personalListController = new BehaviorSubject<List<Personal>>();
  final _taskActiveController = new BehaviorSubject<int>();
  final _taskCultivoController = new BehaviorSubject<List<Tarea>>();

  final _tareaActiveController = new BehaviorSubject<Tarea>();
  final _personalActiveController = new BehaviorSubject<Personal>();
  final _defaultPersonalController = new BehaviorSubject<Personal>();
  
  final _dateNetController = new BehaviorSubject<DateTime>(); 
  final _taskInitialTimeController =  new BehaviorSubject<String>();
  final _taskFinalTimeController = new BehaviorSubject<String>();
  final _isValidController = new BehaviorSubject<bool>();
  
  final _tareasPorAsignarController = new BehaviorSubject<List<tm.Tarea>>();
  final _countTaskPorAsignarController = new BehaviorSubject<int>();
  
  Stream<Map<DateTime, List<TareasTrabajadorElement>>> get tasksCalendarStream => _tasksCalendarController.stream;
  Stream<List> get tasksCalendarEventsStream => _tasksCalendarEventsController.stream;

  Stream<String> get responseStream => _responseController.stream;
  Stream<DateTime> get tasksDateKeyStream => _tasksDateKeyController.stream;
  Stream<List<Personal>> get personalStream => _personalListController.stream;
  Stream<int> get taskActiveStream => _taskActiveController.stream;
  Stream<List<Tarea>> get taskCultivoStream => _taskCultivoController.stream;
  Stream<Tarea> get tareaActiveStream => _tareaActiveController.stream.transform(validateTarea);
  Stream<Personal> get personalActiveStream => _personalActiveController.stream.transform(validateTrabajador);
  Stream<DateTime> get dateNetStream => _dateNetController.stream;
  Stream<Personal> get defaultPersonalStream => _defaultPersonalController.stream;
  Stream<String> get taskInitialTimeStream => _taskInitialTimeController.stream;
  Stream<String> get taskFinalTimeStream => _taskFinalTimeController.stream;
  Stream<bool> get isValidStream => _isValidController.stream;

  Stream<List<tm.Tarea>> get tareasPorAsignarStream => _tareasPorAsignarController.stream;
  Stream<int> get countTaskPorAsignar => _countTaskPorAsignarController.stream;
  
  Function(DateTime) get onChangeTasksDateKey => changeKey;//_tasksDateKeyController.sink.add;

  Function(String) get onChangeTaskInitialTime => _changeTime;
  Function(String) get onChangeTaskFinalTime => _taskFinalTimeController.sink.add;

  Function(Personal) get onChangeDefaultPersonal =>_defaultPersonalController.sink.add;

  int get countTasks => _countTaskPorAsignarController.value;
  Function(int) get onChangeCountTaskPAsignar => _countTaskPorAsignarController.sink.add;

  Function(String ) get onChangeResponse => _responseController.sink.add;
  Function(int) get onChangeTaskActive => _taskActiveController.sink.add;
  Function(List) get onChangeEventsList => _tasksCalendarEventsController.sink.add;
  Function(DateTime) get onChangeDateNet => _dateNetController.sink.add;
  
  Function(Tarea) get onChangeTareaActive => addTarea;
  Function(Personal) get onChangePersonalActive => _personalActiveController.sink.add;
  Function(bool) get onChangeIsValid => _isValidController.sink.add;
  
  DateTime get tasksDateKey => _tasksDateKeyController.value; 
  String get response => _responseController.value;
  int get task => _taskActiveController.value;
  Tarea get tareaActive => _tareaActiveController.value;
  Personal get personalActive => _personalActiveController.value;
  DateTime get dateNet => _dateNetController.value;
  Personal get defaultPersonal => _defaultPersonalController.value;

  String get taskInitialTime => _taskInitialTimeController.value;
  String get taskFinalTime => _taskFinalTimeController.value;
  bool get isValid => _isValidController.value;

  _changeTime(String time){
    _taskInitialTimeController.sink.add(time);
    onChangeTaskFinalTime(time);
  }

    Stream<bool> get formDelegateTask => 
    CombineLatestStream.combine2(tareaActiveStream,personalActiveStream,
       (e1, e2) => true);

  void resetPage(){
    taskProvider.page2=0;
  }

  void addTarea(dynamic t){
    if(t!=null){
      _tareaActiveController.sink.add(t);
      taskProvider.page2=0;
      getPersonalDisponible();
    }
  }

  void disponiblesHora(){
    
  }
  // void get onChangeTareaActive =>(Tarea t){
  //   if(t!=null){
  //     _tareaActiveController.sink.add(t);
  //     getPersonalDisponible();
  //   }
    
  // };

  

  int _cultivo=0;
  dipose(){
   
  }
  
  void reset(){
    _tasksDateKeyController.sink.addError('*');
    _tasksCalendarEventsController.sink.add([]);
  }

  void getTaskCalendar(int cultivo)async{
    // print("cnsultando");
    //containsKey();
    print("consulta datos");
    //if(cultivo==_cultivo)return;
    //taskProvider.page2=0;
    final tasks =  await taskProvider.loadTareasPersonal(cultivo);
    print("recibiendo respuesta");
    // if(task!=null){
    //   print("datos bien");
      tasksMap=tasks;
      _tasksCalendarController.sink.add(tasksMap);

    // }

    // containsKey();
    print("sale de datos");
    _cultivo=cultivo;
    // }
    // }
  } 

  void changeKey(DateTime key){
    final temp  = DateFormat('yyyy-MM-dd').format(key); //dejar solo fecha sin hora
    final tempDate = DateTime.parse(temp);
    print("LLAve $tempDate");
    _tasksDateKeyController.sink.add(tempDate);
  }

  containsKey(){
    if(tasksDateKey==null)
      return;
    if(tasksMap.containsKey(tasksDateKey)){
      final list = tasksMap[tasksDateKey];
      onChangeEventsList(list);
    }
  }
  

  Future<bool> confirmarTarea(int tarea)async{
    Map resp = await taskProvider.confirmarTarea(tarea);
    if(resp['ok']){ 
      TareasTrabajadorElement tarea = resp['tarea_personal'];
      List<TareasTrabajadorElement> list = tasksMap[tasksDateKey];
      list[list.indexWhere((element) => element.consecutivo == tarea.consecutivo)] = tarea;
      tasksMap[tasksDateKey] = list;
      _tasksCalendarController.sink.add(tasksMap);
      onChangeResponse(resp['message']);
      return true;
    }
    onChangeResponse(resp['message']);
    return false;
  }

  Future<bool> cancelarTarea(int tarea)async{
    if(tasksMap.containsKey(tasksDateKey)){
      Map resp = await taskProvider.cancelarTarea(tarea);
      if(resp['ok']){ 
        TareasTrabajadorElement tarea = resp['tarea_personal'];
        if(tasksMap.containsKey(tasksDateKey)){
          List<TareasTrabajadorElement> list = tasksMap[tasksDateKey];
          list[list.indexWhere((element) => element.consecutivo == tarea.consecutivo)] = tarea;
          tasksMap[tasksDateKey] = list;
          _tasksCalendarController.sink.add(tasksMap);
          onChangeResponse(resp['message']);
        }
        return true;
      }
      onChangeResponse(resp['message']);
      return false;
    }
    return false;
   
  }

  Future<bool> reasignarTrabajadorTarea(int consecutivo)async{
    if(tasksMap.containsKey(tasksDateKey)){
       Map resp = await taskProvider.reasignarTrabajadorTarea(consecutivo,personalActive.id);
    if(resp['ok']){ 
      TareasTrabajadorElement tarea = resp['tarea_personal'];
      List<TareasTrabajadorElement> list = tasksMap[tasksDateKey];     
      list[list.indexWhere((element) => element.consecutivo == tarea.consecutivo)] = tarea;
      tasksMap[tasksDateKey] = list;
      _tasksCalendarController.sink.add(tasksMap);
      onChangeResponse(resp['message']);
      return true;
    }
    onChangeResponse(resp['message']);
    return false;
    }
    return false;
  }

  
  Future<bool> cambiarHorarioTarea(int consecutivo)async{
    Map resp = await taskProvider
    .reprogramarTareaTrabajador(
      consecutivo,
      taskInitialTime,
      taskFinalTime,
      personalActive.id);
    
    
    if(resp['ok']){ 
      TareasTrabajadorElement tarea = resp['tarea_personal'];
      List<TareasTrabajadorElement> list = tasksMap[tasksDateKey];
      // if(list.isNotEmpty)        
      list[list.indexWhere((element) => element.consecutivo == tarea.consecutivo)] = tarea;
      tasksMap[tasksDateKey] = list;
      _tasksCalendarController.sink.add(tasksMap);
      onChangeResponse(resp['message']);
      return true;
    }
    onChangeResponse(resp['message']);
    return false;
  }

  void tareasCultivo()async{
    final resp = await taskProvider.loadTareasCultivo(solarBloc.cultivoHome.id);
    if(resp!=null){
      if(resp['ok']){
      List<Tarea> list = resp['tareas'];
        _taskCultivoController.sink.add(list);
      }else{
        onChangeResponse(resp['message']);
      }
    }
  }

  void getPersonalDisponible()async{
    final resp = await taskProvider
      .trabajadoresDisponibles(
        tareaActive.id,
        DateFormat('yyyy-MM-dd').format(tasksDateKey),
        tareaActive.horaInicio,
        tareaActive.horaFinal);
    if(resp!=null){
      if(resp['ok']){
        List<Personal> list = resp['personal'];
        if(list!=null){
          _personalListController.sink.add(list);
        }
      }else{
        onChangeResponse(resp['message']);
      }
    }
  } 
 

  Future<bool> trabajDispReprogramacionHoras(int consecutivo,int trabajador)async{
    final resp = await taskProvider.trabajDispReprogramacionHoras(
      //trabajador, //trabajador
      personalActive.id,
      taskInitialTime,
      taskFinalTime,
      consecutivo,
      );
    
    if(resp!=null){
      if(resp['ok']){
          List<Personal> list = resp['personal'];
          //if(list.isNotEmpty){
          _personalListController.sink.add(list);
          if(resp['disponible']){
            onChangeResponse("Trabajador disponible.");
          }else{
            onChangeResponse("Trabajador no disponible.");
            onChangePersonalActive(list[0]);
          }
          onChangeIsValid(resp['disponible']);
          return true;
     }else{
        onChangeResponse(resp['message']);
        return false;
      }
   }else{
     onChangeResponse("Ha ocurrido un error.");
     return false;
   }


 }


  Future<bool> asignarTarea()async{
    Map resp = await taskProvider.asignarTarea(
      tareaActive.id,
      personalActive.id,
      DateFormat('yyyy-MM-dd').format(tasksDateKey));
    if(resp['ok']){ 
      TareasTrabajadorElement tarea = resp['tarea_personal'];
      List<TareasTrabajadorElement> list = new List();
      if(tasksMap.containsKey(tasksDateKey)){
        list = tasksMap[tasksDateKey];
      }
      list.add(tarea);
      tasksMap.putIfAbsent(tasksDateKey, () => list);
      _tasksCalendarEventsController.sink.add(list);
      _tasksCalendarController.sink.add(tasksMap);
      onChangeResponse(resp['message']);
      return true;
    }
    onChangeResponse(resp['message']);
    return false;
  }

  
  void updatedTask(TareasTrabajadorElement task){ //updated task from firebase push notification
    List<TareasTrabajadorElement> list = new List();

      if(tasksMap.containsKey(task.fecha)){
        print("contiene key******");
        list = tasksMap[task.fecha];  
        int index = list.indexWhere((f)=> f.consecutivo == task.consecutivo);
        list[index] = task;
      }
      print("actualizando");
      tasksMap.putIfAbsent(task.fecha, () => list);
      _tasksCalendarController.sink.add(tasksMap);
      if(tasksDateKey==task.fecha || tasksDateKey==null)
        _tasksCalendarEventsController.sink.add(list);
      //onChangeTasksDateKey(task.fecha);
  }

  void tasksPorAsignar()async{
    final list = await taskProvider.getTareasDiarias();
    if(list.isNotEmpty){
      onChangeCountTaskPAsignar(list.length);
    }
  }
} 