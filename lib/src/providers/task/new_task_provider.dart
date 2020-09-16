


//tareas en cultivo para el dia x cultivo x
//**http://127.0.0.1:8000/api/personal/tareas_personal_fecha?page=1&fecha=2020-09-05&cultivo=36 */


import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/employee/tareas_trabajador_model.dart';
import 'package:app_invernadero_trabajador/src/models/task/personal_list.dart';
import 'package:app_invernadero_trabajador/src/models/task/tarea_date_mode.dart';
import 'package:app_invernadero_trabajador/src/models/task/task_list.dart';
import 'package:app_invernadero_trabajador/src/models/task/trabajador_disponible.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http;

import 'package:app_invernadero_trabajador/src/models/task/tarea_date_mode.dart' as t;

class NewTaskProvider{
  static final NewTaskProvider _NewTaskProvider = NewTaskProvider._internal();

  factory NewTaskProvider() {
    return _NewTaskProvider;
  }

  NewTaskProvider._internal();
  // TaskBloc taskBloc = TaskBloc();
  final _storage = SecureStorage();  
  int _page=0;
  bool _loading=false;


  int page2=0;
  bool _loading2=false;
  
  int _page3=0;
  bool _loading3=false;

  Future<Map<DateTime, List<TareasTrabajadorElement>>> loadTareasPersonal(int cultivo)async{  
    if(_loading)return null;
    _loading=true;
    _page++;
    int pag=1;
    final url = "${AppConfig.base_url}/api/personal/tareas_personal_fecha?page=$pag&cultivo=$cultivo"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);
    print("RESPUESTA DE PERSONAL EN CULTIVO");
    print(response.body);
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEE $_page");
      _loading=false;
      return null;
    } 

    if(response.body.contains("tareas_trabajador") && response.body.contains("id_tarea")){
      TareasTrabajador tareasDate = TareasTrabajador.fromJsonToAdmin(json.decode(response.body)); 
      _loading=false;
      return tareasDate.tareasTrabajador;
    }
    _loading=false;
    return null;
  } 

  //terminar tarea
 Future<Map<String,dynamic>> confirmarTarea(int consecutivo)async{  

    final url = "${AppConfig.base_url}/api/personal/finalizar_tarea"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    final response = await http.post(
      url, 
      headers: headers,
      // body:   json.encode( 
      body:  {
          "consecutivo":consecutivo.toString(),
        }
      // )
      );
    print("RESPUESTA DE TAREA PERSONAL");
    print(response.body);
    if(response.statusCode!=200){
      print("PAGEEEEEE $_page");
      // taskBloc.onChangeResponse(response.body);
      //return null;
      return {'ok':false, 'tarea_personal' : null ,'message' : response.body};
    } 

    if(response.body.contains("fecha") && response.body.contains("id_tarea")){
      TareasTrabajadorElement tareasPersonal = TareasTrabajadorElement.fromJsonToAdmins(json.decode(response.body)); 
      //taskBloc.onChangeResponse("Tarea confirmada");
      return {'ok':true, 'tarea_personal' : tareasPersonal ,'message' : "Tarea confirmada"};
    }
    return {'ok':false, 'tarea_personal' : null ,'message' : response.body};
  } 

   Future<Map<String,dynamic>> cancelarTarea(int consecutivo)async{  
     print("consecutivo $consecutivo");
    final url = "${AppConfig.base_url}/api/personal/cancelar_tarea"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    final response = await http.put(
      url, 
      headers: headers,
      body:   
        {
          "consecutivo":consecutivo.toString(),
        }
      )
      ;
    print("RESPUESTA DE TAREA  CANCELAR PERSONAL");
    print(response.body);
    if(response.statusCode!=200){
    
      // taskBloc.onChangeResponse(response.body);
         return {'ok':false, 'tarea_personal' : null ,'message' : json.decode(response.body)['message']};
    } 

    if(response.body.contains("fecha") && response.body.contains("id_tarea")){
      TareasTrabajadorElement tareasPersonal = TareasTrabajadorElement.fromJsonToAdmins(json.decode(response.body));
      
      return {'ok':true, 'tarea_personal' : tareasPersonal ,'message' : "Tarea cancelada"};
    }
    return {'ok':false, 'tarea_personal' : null ,'message' : json.decode(response.body)['message']};
  } 


  Future<Map<String,dynamic>> reasignarTrabajadorTarea(int consecutivo,int trabajador)async{  
    final url = "${AppConfig.base_url}/api/personal/reasignar_trabajador"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    final response = await http.put(
      url, 
      headers: headers,
      // body:   json.encode( 
        body:
        {
          "consecutivo":consecutivo.toString(),
          "trabajador":trabajador.toString()
        }
      // )
      );
    print("RESPUESTA DE TAREA PERSONAL");
    print(response.body);
    if(response.statusCode!=200){
      print("PAGEEEEEE $_page");
    return {'ok':false, 'tarea_personal' : null ,'message' : json.decode(response.body)['message']};
    } 

    if(response.body.contains("fecha") && response.body.contains("id_tarea")){
      TareasTrabajadorElement tareasPersonal = TareasTrabajadorElement.fromJsonToAdmins(json.decode(response.body));
       return {'ok':true, 'tarea_personal' : tareasPersonal ,'message' : "Tarea reasignada"};
    }
    return {'ok':false, 'tarea_personal' : null ,'message' : json.decode(response.body)['message']};
  } 
  //reasignar_horario
  
   Future<Map<String,dynamic>> reprogramarTareaTrabajador(int consecutivo,String horaInicio,String horaFinal,int personal)async{  
    final url = "${AppConfig.base_url}/api/personal/reasignar_horario"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    final response = await http.put(
      url, 
      headers: headers,
      body:  // json.encode( 
        {
          "consecutivo":consecutivo.toString(),
          "hora_inicio":horaInicio.toString(),
          "hora_final" : horaFinal.toString(),
          "personal" : personal.toString()
        }
     // )
      );
    print("RESPUESTA DE TAREA PERSONAL REPROGRAMANDO FECHA");
    print(response.body);
    if(response.statusCode!=200){
      print("PAGEEEEEE $_page");
      return {'ok':false, 'tarea_personal' : null ,'message' : json.decode(response.body)['message']};
    } 

    if(response.body.contains("fecha") && response.body.contains("id_tarea")){
      TareasTrabajadorElement tareasPersonal = TareasTrabajadorElement.fromJsonToAdmins(json.decode(response.body));
     return {'ok':true, 'tarea_personal' : tareasPersonal ,'message' : "Tarea reprogramada."};
    }
    return {'ok':false, 'tarea_personal' : null ,'message' : json.decode(response.body)['message']};
  } 



  Future<Map<String,dynamic>>  trabajadoresDisponibles(int tarea,String fecha,String horaInicio,String horaFinal)async{  
    print("params $tarea fecha $fecha hoi $horaInicio hof$horaFinal");
    
    if(_loading2)return null;
    _loading2=true;
    page2++;
    // _page2=1;
    final url = "${AppConfig.base_url}/api/personal/personal_disponible?tarea=$tarea&fecha=$fecha&hora_inicio=$horaInicio&hora_final=$horaFinal&page=$page2"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);
    print("RESPUESTA DE trabajadores disponibles");
    print(response.body);
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEE $page2");
      _loading2=false;
      return {'ok':false, 'personal' : [] , 'message':'No hay resultados'};
    } 

    if(response.statusCode==200 && response.body.contains("personal")){
      print("respuesta chida aqui pasa algo");
      PersonalList personalList = PersonalList.fromJson(json.decode(response.body));
      _loading2=false;
      print("ya no paso nda");
      return {'ok':true, 'personal' : personalList.personal};
    }
    _loading2=false;
    return {'ok':false, 'personal' : [], 'message':'No hay resultados'};
  } 
  

  Future<Personal> trabajadorisAvailable(int trabajador,int tarea,String fecha,String horaInicio,String horaFinal)async{  
    final url =
     "${AppConfig.base_url}/api/personal/trabajador_is_availabe?tarea=$tarea&trabajador=$trabajador&fecha=$fecha&hora_inicio=$horaInicio&hora_final=$horaFinal"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);
    print("RESPUESTA DE TAREAS EN CULTIVO");
    print(response.body);
    if(response.body.contains('no results')){
      return null;
    } 

    if(response.statusCode==200 && response.body.contains("personal")){
      Personal personal = Personal.fromJson(json.decode(response.body)['personal']);  
      return personal;
    }
    return null;
  } 

  Future<Map<String,dynamic>> loadTareasCultivo(int cultivo)async{  
    print("entrando al metodo id cultivo$cultivo badera $_loading3 pagina $_page3");

    if(_loading3)return null;
    _loading3=true;
    _page3++;


    final url = "${AppConfig.base_url}/api/personal/tareas_cultivo?page=$_page3&cultivo=$cultivo"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);
    print("RESPUESTA DE TAREAS EN CULTIVO");
    print(response.body);
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEE $_page3");
      return {'ok':false, 'tareas' : [], 'message':'No hay resultados'};
    } 
    if(response.body.contains("tareas")){
      TareasList tareas = TareasList.fromJson(json.decode(response.body)); 
      _loading3=false;
     // return tareas.tareas.values.toList();
      return {'ok':true, 'tareas' : tareas.tareas.values.toList()};
    }
    _loading3=false;
    return {'ok':false, 'tareas' : [], 'message':'No hay resultados'};
  } 



   Future<Map<String,dynamic>> asignarTarea(int tarea,int personal,String fecha)async{  
    final url = "${AppConfig.base_url}/api/personal/asignar_tarea"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    final response = await http.post(
      url, 
      headers: headers,
      body:   
        {
          "id_tarea":tarea.toString(),
          "id_personal":personal.toString(),
          "fecha": fecha
        }
      )
      ;
    print("RESPUESTA AL ASIGNAR TAREA");
    print(response.body);
    if(response.statusCode!=200 || response.body.contains("error")){
      // taskBloc.onChangeResponse(response.body);
         return {'ok':false, 'tarea_personal' : null ,'message' : json.decode(response.body)['message']};
    }   

    if(response.body.contains("fecha") && response.body.contains("id_tarea")){
      print("entrando chido");
      TareasTrabajadorElement tareasPersonal = TareasTrabajadorElement.fromJsonToAdmins(json.decode(response.body));
      print("Value response ${tareasPersonal.idTarea}");
      // taskBloc.onChangeResponse("Tarea cancelada"); 
      return {'ok':true, 'tarea_personal' : tareasPersonal ,'message' : "Tarea asignada"};
    }
    return {'ok':false, 'tarea_personal' : null ,'message' : json.decode(response.body)['message']};
  } 

  //disponibles en fecha hora
  //http://127.0.0.1:8000/api/personal/disponibles_fecha_hora?trabajador=49&hora_inicio=6:30:00&hora_final=7:15:00&consecutivo=30

  Future<Map<String,dynamic>>  trabajDispReprogramacionHoras(int trabajador,String horaInicio,String horaFinal,int consecutivo,)async{  
    print("hora inicial $horaInicio hora final $horaFinal consecutivo $consecutivo   trabajador $trabajador");

    final url = "${AppConfig.base_url}/api/personal/disponibles_fecha_hora?trabajador=$trabajador&hora_inicio=$horaInicio&hora_final=$horaFinal&consecutivo=$consecutivo"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);
    print("RESPUESTA DE trabajadores disponibles");
    print(response.body);
    if(response.body.contains('page_on_limit')){
      return {'ok':false, 'personal' : [] , 'message':'No hay resultados'};
    } 

    if(response.statusCode==200 && response.body.contains("personal")){
      TrabajadorDisponibleModel tdModel = TrabajadorDisponibleModel.fromJson(json.decode(response.body));
      return {'ok':true,'disponible': tdModel.disponible,'personal' : tdModel.personal};
    }
    return {'ok':false, 'personal' : [] , 'message':'No hay resultados'};
  } 
}

