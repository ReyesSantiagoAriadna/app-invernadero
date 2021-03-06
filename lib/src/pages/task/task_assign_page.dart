import 'dart:ui';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_gasto_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_producto_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_sobrante_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/generic_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/pedido/pedido_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/task/task_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/task/tarea_date_mode.dart';
import 'package:app_invernadero_trabajador/src/services/tasks/task_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';


class TaskAssignPage extends StatefulWidget {
  TaskAssignPage({Key key}) : super(key: key);

  @override
  _TaskAssignPageState createState() => _TaskAssignPageState();
}

class _TaskAssignPageState extends State<TaskAssignPage> {
  Responsive _responsive;
  bool _isLoading=false;
  SolarCultivoBloc solarBloc = SolarCultivoBloc();
  // TaskBloc taskBloc = TaskBloc();
  TaskService taskService = TaskService.instance;

  @override
  void initState() {
    if(solarBloc.cultivoHome!=null){
      print("Cultivo homeeee = ${solarBloc.cultivoHome.id} ${solarBloc.cultivoHome}");
      taskService.tareasCultivo();
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _responsive = Responsive.of(context);
  }
  @override
  void dispose() {
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child:Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            title:Text("Asignar Tarea ${DateFormat('yyyy-MM-dd').format(taskService.tasksDateKey)}",style:TextStyle(color: MyColors.GreyIcon,
              fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w800
            )),
            leading: IconButton(
              icon: Icon(LineIcons.angle_left,color:MyColors.GreyIcon),
              onPressed:()=> Navigator.pop(context)),
            actions: <Widget>[
              
              _createButton()
            ],
          ),
          body:GestureDetector(
            onTap: ()=>FocusScope.of(context).unfocus(),
            child: _body()
          ),
        ),
        ),
        _isLoading? Positioned.fill(child:  Container(
                  color:Colors.black45,
                  child: Center(
                    child:SpinKitCircle(color: miTema.accentColor),
                  ),
                ),):Container()
      ],
    );
  }
  
  _body(){
    return Container(
      margin: EdgeInsets.only(left:8,right:12,top: 10),
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Informaci??n",style: TextStyle(
              fontFamily:AppConfig.quicksand,fontWeight: FontWeight.w700,
              color: MyColors.GreyIcon,fontSize: _responsive.ip(1.9)
            ),),
            SizedBox(height:5),
            Container(
              width: double.infinity,
              height: 2,
              color: Colors.grey[300],
            ),
            SizedBox(height:5),
            // _inputSolar(), 
           StreamBuilder(
             stream: taskService.taskCultivoStream ,
             builder: (BuildContext context, AsyncSnapshot snapshot){
               List<Tarea> list;
                if(snapshot.hasData){
                  list = snapshot.data;
                }
                return DialogSelectGeneric(
                stream: taskService.tareaActiveStream,
                initialData: taskService.tareaActive,
                onchange: taskService.onChangeTareaActive,
                responsive: _responsive,
                title: "Tarea",
                content: "Elije la tarea",
                list: list,
                icon: Icon(LineIcons.calendar_check_o,color:MyColors.GreyIcon),
             );
             },
           ),


            
            SizedBox(height:_responsive.ip(2)),

            StreamBuilder(
             stream: taskService.personalStream ,
             builder: (BuildContext context, AsyncSnapshot snapshot){
               List<Personal> list;
                if(snapshot.hasData){
                  list = snapshot.data;
                }
                return DialogSelectGeneric(
                stream: taskService.personalActiveStream,
                initialData: taskService.personalActive,
                onchange: taskService.onChangePersonalActive,
                responsive: _responsive,
                title: "Personal",
                content: "Elije al trabajador",
                list: list,
                icon: Icon(LineIcons.user,color:MyColors.GreyIcon),
             );
             },
           ),
          
            SizedBox(height:_responsive.ip(2)),

            StreamBuilder(
              stream: taskService.tareaActiveStream ,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData)
                  return _taskDetails(snapshot.data);
                return  Container();
              },
            ), 

          ],
        )
      ),
    );
  }

  _taskDetails(Tarea t){
    TextStyle _style = TextStyle(
      color: Colors.black54,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w700
    );
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
           ListTile(
             dense: true,
            leading:Icon(LineIcons.calendar_check_o),
            title: Text("Tipo de tarea: ${t.tipo}",style: _style,),
          ),
          ListTile(
            dense: true,
            leading:Icon(LineIcons.clock_o),
            title: Text("Hora de Inicio: ${t.horaInicio}",style: _style,),
          ),
          ListTile(
            dense: true,
            leading:Icon(LineIcons.clock_o),
            title: Text("Hora de Finalizaci??n: ${t.horaFinal}",style: _style,),
          ),
        ],
      ),
    );
  }

 

  _createButton(){
    return StreamBuilder(
      stream: taskService.formDelegateTask,
      builder: (BuildContext context, AsyncSnapshot snapshot){
          return IconButton(
          icon: Icon(LineIcons.save,color: MyColors.GreyIcon,),
          onPressed: snapshot.hasData?()=>_delegetaTask():null
          );
      },
    );
  }

  _delegetaTask()async{
    if(_isLoading)return;
    setState(() {
      _isLoading=true;
    });

    await taskService.asignarTarea();
    
    setState(() {
      _isLoading=true;
    });
    
    Flushbar(
      message: taskService.response,
      duration:  Duration(seconds: 2),
    )..show(context).then((r){
      Navigator.pop(context);

      //if()
    });
  }
}