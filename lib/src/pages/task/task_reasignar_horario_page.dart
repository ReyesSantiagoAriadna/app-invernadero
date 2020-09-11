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
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select.dart';
import 'package:app_invernadero_trabajador/src/widgets/inputs/my_time_picker.dart';
import 'package:app_invernadero_trabajador/src/widgets/my_alert_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';
import 'package:time_range/time_range.dart';


class TaskReasignarHorarioPage extends StatefulWidget {
  TaskReasignarHorarioPage({Key key}) : super(key: key);
  @override
  _TaskReasignarHorarioPageState createState() => _TaskReasignarHorarioPageState();
}

class _TaskReasignarHorarioPageState extends State<TaskReasignarHorarioPage> {
  Responsive _responsive;
  bool _isLoading=false;
  SolarCultivoBloc solarBloc = SolarCultivoBloc();
  TaskBloc taskBloc = TaskBloc();
  TareasPersonal tp;
  TimeRangeResult _defaultTimeRange;
  TimeRangeResult _timeRange;
   MaterialLocalizations localizations ;
  @override
  void initState() {
    if(solarBloc.cultivoHome!=null){
      print("Cultivo homeeee = ${solarBloc.cultivoHome.id} ${solarBloc.cultivoHome}");
      taskBloc.tareasCultivo();
    }
    taskBloc.onChangeIsValid(false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(tp==null){
      localizations = MaterialLocalizations.of(context);
      tp = ModalRoute.of(context).settings.arguments as TareasPersonal;
      taskBloc.onChangeTareaActive(tp.tarea);
      taskBloc.onChangePersonalActive(tp.personal);
      taskBloc.onChangeDefaultPersonal(tp.personal);
    
      _defaultTimeRange = TimeRangeResult(
       TimeOfDay(hour:int.parse(tp.horaInicio.split(":")[0]),minute: int.parse(tp.horaInicio.split(":")[1])),
       TimeOfDay(hour:int.parse(tp.horaFinal.split(":")[0]),minute: int.parse(tp.horaFinal.split(":")[1])),
      );
      _timeRange = _defaultTimeRange;
    }
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
            title:Text("Reasignar Personal ${DateFormat('yyyy-MM-dd').format(taskBloc.tasksDateKey)}",
            style:TextStyle(color: MyColors.GreyIcon,
              fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w700
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
            Text("Información",style: TextStyle(
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
             stream: taskBloc.taskCultivoStream ,
             builder: (BuildContext context, AsyncSnapshot snapshot){
               List<Tarea> list;
                if(snapshot.hasData){
                  list = snapshot.data;
                }
                return DialogSelectGeneric(
                stream: taskBloc.tareaActiveStream,
                initialData: taskBloc.tareaActive,
                onchange: taskBloc.onChangeTareaActive,
                responsive: _responsive,
                title: "Tarea",
                content: "Elije la tarea",
                list: list,
                icon: Icon(LineIcons.calendar_check_o,color:MyColors.GreyIcon),
                isClickable: false,
             );
             },
           ),


            
            SizedBox(height:_responsive.ip(2)),

            StreamBuilder(
             stream: taskBloc.personalStream ,
             builder: (BuildContext context, AsyncSnapshot snapshot){
               List<Personal> list;
                if(snapshot.hasData){
                  list = snapshot.data;
                }
                return DialogSelectGeneric(
                stream: taskBloc.personalActiveStream,
                initialData: taskBloc.personalActive,
                onchange: taskBloc.onChangePersonalActive,
                responsive: _responsive,
                title: "Personal",
                content: "Elije al trabajador",
                list: list,
                icon: Icon(LineIcons.user,color:MyColors.GreyIcon),
                // isClickable: false,
             );
             },
           ),
          
            SizedBox(height:_responsive.ip(2)),

            StreamBuilder(
              stream: taskBloc.tareaActiveStream ,
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
      color: MyColors.GreyIcon,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w700
    );
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Container(
            width: double.infinity,
            child:Row(children: <Widget>[
                Icon(LineIcons.clock_o,color: MyColors.GreyIcon,),
                SizedBox(width: 15,),
                Expanded(child: Container(child: Text('${_defaultTimeRange.start.hhmm()} - ${_defaultTimeRange.end.hhmm()}',style: _style,overflow: TextOverflow.ellipsis,))),
                
                Expanded(child: Container()),
                Container(child:Column(children: <Widget>[
                  Text("Default",style: _style,),
                  IconButton(icon: Icon(LineIcons.refresh,color: Colors.grey,), onPressed: (){
                     setState(() {
                      _timeRange = _defaultTimeRange;
                    });

                    taskBloc.onChangePersonalActive(tp.personal);
                  }
                  )
                ],))
            ],)
          ),
            // _timeRange!=null?
            //     Column(
            //       crossAxisAlignment: CrossAxisAlignment.start,
            //       children: <Widget>[
            //         Text(
            //           'Horas: ${_defaultTimeRange.start.hhmm()} - ${_defaultTimeRange.end.hhmm()}',
            //           style: TextStyle(fontSize: 20, color: Colors.black54),
            //         ),
            //         SizedBox(height: 20),
            //         MaterialButton(
            //           child: Text('Default'),
            //           onPressed: () => setState(() => _timeRange = _defaultTimeRange),
            //           color: Colors.redAccent,
            //         )
            //       ],
            //     ):Container(),

            Container(
              margin: EdgeInsets.only(left:15),
              child: TimeRange(
                  fromTitle: Row(children:<Widget>[
                    Icon(LineIcons.clock_o,color: Colors.grey,),
                    SizedBox(width:5),
                    Text('Hora Inicial', style: _style,)
                  ]),
                  toTitle:Row(children:<Widget>[
                    Icon(LineIcons.clock_o,color:Colors.grey),
                    SizedBox(width:5),
                    Text('Hora Final', style: _style,)
                  ]),
                  titlePadding: 20,
                  textStyle: TextStyle(fontWeight: FontWeight.normal, color: Colors.black87),
                  activeTextStyle: TextStyle(fontWeight: FontWeight.bold, color: Colors.white),
                  borderColor: Colors.grey,
                  backgroundColor: Colors.transparent,
                  activeBackgroundColor: miTema.accentColor,
                  firstTime: TimeOfDay(hour: 00, minute: 00),
                  lastTime: TimeOfDay(hour: 20, minute: 00),
                  initialRange: _timeRange,
                  timeStep: 15,
                  timeBlock: 15,
                   onRangeCompleted: (range) => setState(() =>_fetchPersonal(range)),
                  //  onRangeCompleted: (range) => ()=>
                  // //  {
                  // //    setState(() {
                  // //      range==null?
                  // //       _timeRange=_defaultTimeRange
                  // //    : _fetchPersonal(range);
                  // //    });
                  // //  }
                  //  setState(() => (
                  //    range!=null)
                  //    ? _timeRange=_defaultTimeRange
                  //    :_fetchPersonal(range) //fetch to api
                  //    ),
                ),

               
            ),


     
             
        ],
      ),
    );
  }
  
  _fetchPersonal(TimeRangeResult range){
    print("Rangeeeeeeeee ${range.start}");
   if(range!=null){
      _timeRange=range;
      if(_timeRange.start!=null && _timeRange.end!=null){
       
        print("New init select = ${_timeRange.start}");
        print("New final select = ${_timeRange.end}");
        String initialHour = localizations.formatTimeOfDay(_timeRange.start,alwaysUse24HourFormat: true);
        initialHour = initialHour+":00";
        String finalHour = localizations.formatTimeOfDay(_timeRange.end,alwaysUse24HourFormat: true);
        finalHour = finalHour+":00";
        print("Inicial $initialHour Final $finalHour");
        taskBloc.onChangeTaskInitialTime(initialHour);
        taskBloc.onChangeTaskFinalTime(finalHour);
        
        taskBloc.trabajDispReprogramacionHoras(tp.consecutivo,tp.personal.id).then((v){
           Flushbar(
            message:taskBloc.response!=null? taskBloc.response:"",
            duration:  Duration(seconds: 2),
          )..show(context);
        });
      }
   }
  //  else{
  //    _timeRange=_defaultTimeRange;
  //  }
  }

  _createButton(){
    return StreamBuilder(
      stream: taskBloc.isValidStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
         if(!snapshot.hasData)
          return Container();

          return IconButton(
          icon: Icon(LineIcons.save,color: snapshot.data?MyColors.GreyIcon:Colors.grey[300],),
          onPressed: (){
            //snapshot.data?
            if(snapshot.data){
              showMyDialog(
                      context,
                      "Tarea Personal", "¿Estas seguro de reprogramar la tarea de ${taskBloc.taskInitialTime} hrs a ${taskBloc.taskFinalTime} hrs?"
                      ,()=>_changeTime() );
            }
             
             // :null;
          },
          
          //onPressed: ()=> snapshot.data?_changeTime():null,
          // onPressed: tp.personal.id!=p.id?()=>_delegetaTask():null
          );
      },
    );
    //return IconButton(icon: Icon(LineIcons.save,color: Colors.grey,), onPressed:()=> taskBloc.isValid?print("veeee"):print("no vayass"));
  }

  _changeTime()async{
    if(_isLoading)return;
    setState(() {
      _isLoading=true;
    });

    await taskBloc.cambiarHorarioTarea(tp.consecutivo);

    setState(() {
      _isLoading=false;
    });
    
    Flushbar(
      message: taskBloc.response,
      duration:  Duration(seconds: 2),
    )..show(context).then((r){
      Navigator.pop(context);

      //if()
    });
  }
}