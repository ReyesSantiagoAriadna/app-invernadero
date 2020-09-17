
import 'package:app_invernadero_trabajador/src/models/employee/tareas_trabajador_model.dart';
import 'package:app_invernadero_trabajador/src/providers/employee/task_employee/task_employee_provider.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:app_invernadero_trabajador/src/utils/DeString.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';

class TasksEmployeeService with ChangeNotifier{

  static TasksEmployeeService instance = new TasksEmployeeService();
  TaskEmployeeProvider taskEmployeeProvider = new TaskEmployeeProvider();

  Map<DateTime, List<TareasTrabajadorElement>> tasksMap = new Map(); 
  
  final _prefs = SecureStorage();

  final _tasksDateKeyController =  new BehaviorSubject<DateTime>();
  final _tasksCalendarController = new BehaviorSubject<Map<DateTime, List<TareasTrabajadorElement>>>();
  final _tasksCalendarEventsController = new BehaviorSubject<List>();
  
  final _responseController = new BehaviorSubject<String>();
 

  Stream<Map<DateTime, List<TareasTrabajadorElement>>> get tasksCalendarStream => _tasksCalendarController.stream;
  Stream<List> get tasksCalendarEventsStream => _tasksCalendarEventsController.stream;
  Stream<String> get responseStream => _responseController.stream;
  Stream<DateTime> get tasksDateKeyStream => _tasksDateKeyController.stream;

  Function(DateTime) get onChangeTasksDateKey => changeKey;//_tasksDateKeyController.sink.add;

  
  Function(String ) get onChangeResponse => _responseController.sink.add;
  Function(List) get onChangeEventsList => _tasksCalendarEventsController.sink.add;
  
  // Function(Tarea) get onChangeTareaActive => addTarea;
  
  DateTime get tasksDateKey => _tasksDateKeyController.value; 
  String get response => _responseController.value;
 


  
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


  TasksEmployeeService(){
    this.getTasks();
  }

 
  void getTasks()async{
    final tasks =  await taskEmployeeProvider.loadMyTasks(_prefs.idPersonal);
    if(tasks!=null){
      this.tasksMap.addAll(tasks);
      _tasksCalendarController.sink.add(tasksMap);
    }
    notifyListeners();
  }

  void addTask(TareasTrabajadorElement task)async{ //add task from push notification
    List<TareasTrabajadorElement> list = new List();
      if(tasksMap.containsKey(task.fecha)){
        list = tasksMap[task.fecha];
      }
      list.add(task);
      tasksMap.putIfAbsent(task.fecha, () => list);
      _tasksCalendarEventsController.sink.add(list);
      _tasksCalendarController.sink.add(tasksMap);
         
  }

  void updatedTask(TareasTrabajadorElement task)async{ //add task from push notification
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

  ///iniciar tarea
  Future<void> iniciarTarea(int consecutivo)async{
    final resp = await taskEmployeeProvider.iniciarTarea(consecutivo);
     if(resp['ok']){ 
      TareasTrabajadorElement tarea = resp['tarea_personal'];
      updatedTask(tarea);
    }
    onChangeResponse(resp['message']);
  }


  Future<void> finalizarTarea(int consecutivo)async{
    final resp = await taskEmployeeProvider.solicitarFinalizacion(consecutivo);
    if(resp['ok']){ 
      TareasTrabajadorElement tarea = resp['tarea_personal'];
      updatedTask(tarea);
      // List<TareasTrabajadorElement> list= new List();
      // list = tasksMap[tasksDateKey];
      // list[list.indexWhere((element) => element.consecutivo == tarea.consecutivo)] = tarea;
      // tasksMap[tasksDateKey] = list;
      // _tasksCalendarController.sink.add(tasksMap);
      // _tasksCalendarEventsController.sink.add(list);
    }
    onChangeResponse(resp['message']);
  }

  void actualizarTarea(TareasTrabajadorElement task){
    List<TareasTrabajadorElement> list= new List();
      list = tasksMap[tasksDateKey];
      list[list.indexWhere((element) => element.consecutivo == task.consecutivo)] = task;
      tasksMap[tasksDateKey] = list;
      _tasksCalendarController.sink.add(tasksMap);
      _tasksCalendarEventsController.sink.add(list);
  }


  

}