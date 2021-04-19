import 'dart:ui';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/employe/task/task_employee_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/map_box_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/employee/tareas_trabajador_model.dart';
import 'package:app_invernadero_trabajador/src/models/task/tarea_date_mode.dart';
import 'package:app_invernadero_trabajador/src/models/weather/weather_bit.dart';
import 'package:app_invernadero_trabajador/src/providers/employee/task_employee/task_employee_provider.dart';
import 'package:app_invernadero_trabajador/src/services/employee/tasks_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/widgets/my_alert_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_speed_dial/flutter_speed_dial.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:table_calendar/table_calendar.dart';
import 'package:intl/intl.dart';


class HomeEmployeePage extends StatefulWidget {
  @override
  _HomeEmployeePageState createState() => _HomeEmployeePageState();
}

class _HomeEmployeePageState extends State<HomeEmployeePage> with TickerProviderStateMixin{
  ScrollController scrollController;
  bool dialVisible = true;
  // SolarCultivoBloc solarBloc = SolarCultivoBloc();
  // TaskBloc taskBloc = TaskBloc();
  Map<DateTime, List<dynamic>> _events;
  List _selectedEvents;
  DateTime dateSelected;
  AnimationController _animationController;
  CalendarController _calendarController;
  final Map<DateTime, List> _holidays = {
  // DateTime(2020, 09, 08): ['New Year\'s Day'],
  DateTime(2019, 1, 6): ['Epiphany'],
  DateTime(2019, 2, 14): ['Valentine\'s Day'],
  DateTime(2019, 4, 21): ['Easter Sunday'],
  DateTime(2019, 4, 22): ['Easter Monday'],
};
  MapBoxBloc mapBoxBloc = MapBoxBloc();
  
  ScrollController _hideButtonController;
  bool _isVisible;
  bool bannerVisible;
  //TaskEmployeeBloc taskEmployeeBloc = TaskEmployeeBloc();
  int initValue=-1;
  @override
  void initState() {
    super.initState();
    print("iniciando calendar");
    
     _hideButtonController  = ScrollController();
    // final temp = DateTime.now();
    // final temporal  = DateFormat('yyyy-MM-dd').format(temp);
    final _selectedDay = DateTime.now();
    dateSelected = _selectedDay;
    bannerVisible=true;
    ///--> _selectedDay
    // taskEmployeeBloc.onChangeTasksDateKey(dateSelected);
    // taskEmployeeBloc.getMyTasksCalendar();
    // if(solarBloc.cultivoHome!=null)
    //     taskBloc.getTaskCalendar(solarBloc.cultivoHome.id);
    _events = {
      
      _selectedDay: [],
     
    };

    _selectedEvents = _events[_selectedDay] ?? [];
    _calendarController = CalendarController();

    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 400),
    );

    _animationController.forward();


    _isVisible = true;


    _hideButtonController.addListener((){
      if(_hideButtonController.position.userScrollDirection == ScrollDirection.reverse){
       // if(_hideButtonController.position.pixels==_hideButtonController.position.maxScrollExtent){
        if(_isVisible == true) {
            
            if(mounted){
              setState((){
              _isVisible = false;
            });
            }
        }
        //}
      } else {
        if(_hideButtonController.position.userScrollDirection == ScrollDirection.forward){
          if(_isVisible == false) {
               if(mounted){
                 setState((){
                 _isVisible = true;
               });
               }
           }
        }
    }});
  }
  
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    if(initValue==-1){
      initValue=0;
      // Provider
      // .of<TasksEmployeeService>(context,listen: false).getTasks();
      // Provider
      // .of<TasksEmployeeService>(context,listen: false).changeKey(dateSelected);

      TasksEmployeeService.instance.changeKey(dateSelected);

    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _calendarController.dispose();
    // taskBloc.reset();
    super.dispose();
  }

  void _onDaySelected(DateTime day, List events) {
    print('CALLBACK: _onDaySelected $day');
    
    //  Provider
    //   .of<TasksEmployeeService>(context,listen: false).onChangeTasksDateKey(day);
      TasksEmployeeService.instance.onChangeTasksDateKey(day);
    // dateSelected = day;
    // List<TareasPersonal> list = events as List<TareasPersonal>;
    //  Provider
    //   .of<TasksEmployeeService>(context,listen: false).onChangeEventsList(events);
      TasksEmployeeService.instance.onChangeEventsList(events);
    // setState(() {
    //   _selectedEvents = events;
    // });
  }

  
  void _onVisibleDaysChanged(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onVisibleDaysChanged');
  }

  void _onCalendarCreated(DateTime first, DateTime last, CalendarFormat format) {
    print('CALLBACK: _onCalendarCreated');
  }

  @override
  Widget build(BuildContext context) {
    
    
    // bool b = solarBloc.cultivoHome
    // .fechaFinal.isAfter(Provider.of<SolarCultivoService>(context,listen: false).date.date); //dateSelected.isBefore();
    
    // print("fecha final ${solarBloc.cultivoHome.fechaFinal} -  result $b");

    // print("Seleccion ${taskBloc.tasksDateKey}");
    // print("FEcha final ${solarBloc.cultivoHome.fechaFinal}");

    // bool bol = taskBloc.tasksDateKey.isAfter(solarBloc.cultivoHome.fechaFinal);

    // print("boolean result $bol");


    return StreamBuilder(
      // stream:  Provider
      // .of<TasksEmployeeService>(context,listen: false).tasksCalendarStream ,
      stream: TasksEmployeeService.instance.tasksCalendarStream,
      
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          Map<DateTime, List<TareasTrabajadorElement>> map = snapshot.data;
          _events= map;
        }
        return Scaffold(
          backgroundColor: Colors.white,
        // appBar: AppBar(
        //   title: Text("Calendario de Actividades",
        //     style: TextStyle(color:MyColors.GreyIcon,fontFamily: AppConfig.quicksand,
        //     fontWeight: FontWeight.w700
        //     ),),
        //   elevation: 0.0,
        //   backgroundColor: Colors.white,
        //   leading: IconButton(icon: Icon(LineIcons.angle_left,color: MyColors.GreyIcon,), 
        //     onPressed:()=> Navigator.pop(context)),
        // ),
        body: Container(
          width: double.infinity,
          height: double.infinity,
          child: SingleChildScrollView(
            controller: _hideButtonController ,
                    child: Container(
                      margin: EdgeInsets.all(4),
                      height: 700,
                      width: double.infinity,
                      child: Column(
              mainAxisSize: MainAxisSize.max,
              children: <Widget>[
                //_buildTableCalendar(),
                _weatherBit(),
                _buildTableCalendarWithBuilders(),
                const SizedBox(height: 8.0),
                //_buildButtons(),
                _colorsCode(),
                const SizedBox(height: 8.0),
                Expanded(
                  
                  // child: _buildEventList()
                  child: _listEvents(),
                ),

              
              ],
            ),
                    ),
          ),
        ),
        floatingActionButton: 
          Visibility(
            visible: _isVisible,
            child: StreamBuilder(
            // stream:  Provider
            //           .of<TasksEmployeeService>(context,listen: false).tasksDateKeyStream ,
            
            stream: TasksEmployeeService.instance.tasksDateKeyStream,
            
            builder: (BuildContext context, AsyncSnapshot snapshot){
              // bool f1=true;
              // bool f2=true;
              // bool f3=true;
              // bool f4=true;
             
              // if(solarBloc.cultivoHome!=null){
              //   f1  = taskBloc.tasksDateKey.subtract(new Duration(days: 1)).isAfter(solarBloc.cultivoHome.fechaFinal);
              //   f2  = taskBloc.tasksDateKey.isBefore(solarBloc.cultivoHome.fecha);
              //   f3  = Provider.of<SolarCultivoService>(context,listen: false).date.date.isAfter(solarBloc.cultivoHome.fechaFinal);
              //   f4  = Provider.of<SolarCultivoService>(context,listen: false).date.date.isBefore(solarBloc.cultivoHome.fecha);
              // }                  
              // print(" F1 $f1 F2 $f2 F3 $f3 F4 $f4");


              return   SpeedDial(
            // both default to 16
            marginRight: 18,
            marginBottom: 20,
            animatedIcon: AnimatedIcons.menu_close,
            animatedIconTheme: IconThemeData(size: 22.0),
            // this is ignored if animatedIcon is non null
            // child: Icon(Icons.add),
            visible: dialVisible,
            // If true user is forced to close dial manually 
            // by tapping main button and overlay is not rendered.
            closeManually: false,
            curve: Curves.bounceIn,
            overlayColor: Colors.black,
            overlayOpacity: 0.5,
            // onOpen: () => print('OPENING DIAL'),
            // onClose: () => print('DIAL CLOSED'),
            tooltip: 'Speed Dial',
            heroTag: 'speed-dial-hero-tag',
            backgroundColor: miTema.accentColor,
            foregroundColor: Colors.white,
            elevation: 8.0,
            shape: CircleBorder(),
            children: [
              // _calendarController.setCalendarFormat(CalendarFormat.month);
              // _calendarController.setCalendarFormat(CalendarFormat.twoWeeks);
              // _calendarController.setCalendarFormat(CalendarFormat.week);
              SpeedDialChild(
                child: Icon(LineIcons.calendar),
                backgroundColor: Colors.red,
                label: 'Mes',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () =>setState((){
                   _calendarController.setCalendarFormat(CalendarFormat.month);
                }),
              ),
              SpeedDialChild(
                child: Icon(LineIcons.calendar),
                backgroundColor: Colors.blue,
                label: '2 Semanas',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap:()=> setState(() {
                   _calendarController.setCalendarFormat(CalendarFormat.twoWeeks);
                }),
              ),
              SpeedDialChild(
                child: Icon(LineIcons.calendar),
                backgroundColor: Colors.green,
                label: 'Semana',
                labelStyle: TextStyle(fontSize: 18.0),
                onTap: () => setState((){
                  _calendarController.setCalendarFormat(CalendarFormat.week);
                }),
              ),
              ],
            );
            },
          ),
          ),
          
          );
      },
    );
    
  }
  _colorsCode(){
    return AnimatedCrossFade(
    duration: const Duration(milliseconds: 500),
    firstChild: _mainContainer(),  // When you don't want to show menu.. 
    secondChild:_secondContainer(),
    crossFadeState: bannerVisible ? CrossFadeState.showFirst : CrossFadeState.showSecond,
    );
  
}

  _secondContainer(){
    return Container(
      margin: EdgeInsets.only(left:20,right: 20),
      width: double.infinity,
      // height: 85,
      child: Column(
      children:<Widget>[
      _titleContainer(),
      ]
      ),
    );
  }
  _titleContainer(){
    TextStyle _style = TextStyle(fontFamily:AppConfig.quicksand,fontWeight:FontWeight.w700);
    return  Row(children: <Widget>[
      Text("Tareas: código de colores",style: _style,),
      Expanded(child: Container()),
      IconButton(
          icon:Icon(bannerVisible?LineIcons.chevron_circle_up:LineIcons.chevron_circle_down)
          ,onPressed:(){
          setState(() {
            bannerVisible=!bannerVisible;
          });
          }
        )
      ],);
  }
  _mainContainer(){
    return Container(
       margin: EdgeInsets.only(left:20,right: 20),
      width: double.infinity,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        children: <Widget>[
          _titleContainer(),
        Row(children: <Widget>[
        Container(
          color: Colors.grey,
          height: 10,
          width: 10,
        ),
        SizedBox(width:5),
        Text("Sin realizar")
      ],),
      Row(
          children:<Widget>[
            Container(
            color: Colors.green,
            height: 10,
            width: 10,
            ),
            SizedBox(width:5),
            Text("Concluida"),
          ]
        ),
        Row(children:<Widget>[
        Container(
        color: Colors.blue,
        height: 10,
          width: 10,
        ),
        SizedBox(width:5),
        Text("En proceso"),
      ]),
      Row(children:<Widget>[
          Container(
          color: Colors.red,
          height: 10,
            width: 10,
          ),
          SizedBox(width:5),
          Text("Cancelada"),
        ]),
        Row(children:<Widget>[
          Container(
          color: Colors.purple,
          height: 10,
            width: 10,
          ),
          SizedBox(width:5),
          Text("En espera de confirmar"),
        ]),
      ],),
    );
  }
  // Simple TableCalendar configuration (using Styles)
  // Widget _buildTableCalendar() {
  //   return TableCalendar(
  //     locale: 'es_ES',
  //     calendarController: _calendarController,
  //     // events: _events,
  //     holidays: _holidays,
  //     startingDayOfWeek: StartingDayOfWeek.monday,
  //     calendarStyle: CalendarStyle(
  //       selectedColor:miTema.accentColor,
  //       todayColor: miTema.accentColor.withOpacity(0.5),
  //       markersColor: miTema.primaryColor,
  //       outsideDaysVisible: false,
  //     ),
  //     headerStyle: HeaderStyle(
  //       formatButtonTextStyle: TextStyle().copyWith(color: Colors.white, fontSize: 15.0),
  //       formatButtonDecoration: BoxDecoration(
  //         color: miTema.accentColor,
  //         borderRadius: BorderRadius.circular(16.0),
  //       ),
  //     ),
  //     onDaySelected: _onDaySelected,
  //     onVisibleDaysChanged: _onVisibleDaysChanged,
  //     onCalendarCreated: _onCalendarCreated,
  //   );
  // }

  //More advanced TableCalendar configuration (using Builders & Styles)
  Widget _buildTableCalendarWithBuilders() {
    return TableCalendar(
      
      locale: 'es_ES',
      calendarController: _calendarController,
      events: _events,
      
      holidays: _holidays,
      initialCalendarFormat: CalendarFormat.month,
      formatAnimation: FormatAnimation.slide,
      startingDayOfWeek: StartingDayOfWeek.sunday,
      availableGestures: AvailableGestures.all,
      availableCalendarFormats: const {
        CalendarFormat.month: '',
        CalendarFormat.week: '',
      },
      calendarStyle: CalendarStyle(
        outsideDaysVisible: false,
        weekendStyle: TextStyle().copyWith(color: miTema.primaryColor),
        holidayStyle: TextStyle().copyWith(color: Colors.blue[800]),
      ),
      daysOfWeekStyle: DaysOfWeekStyle(
        weekendStyle: TextStyle().copyWith(color:miTema.primaryColor),
      ),
      headerStyle: HeaderStyle(
        centerHeaderTitle: true,
        formatButtonVisible: false,
      ),
      builders: CalendarBuilders(
        selectedDayBuilder: (context, date, _) {
          return FadeTransition(
            opacity: Tween(begin: 0.0, end: 1.0).animate(_animationController),
            child: Container(
              margin: const EdgeInsets.all(4.0),
              padding: const EdgeInsets.only(top: 5.0, left: 6.0),
              color: miTema.primaryColor,
              width: 100,
              height: 100,
              child: Text(
                '${date.day}',
                style: TextStyle(color: Colors.white).copyWith(fontSize: 16.0),
              ),
            ),
          );
        },
        todayDayBuilder: (context, date, _) {
          return Container(
            margin: const EdgeInsets.all(4.0),
            padding: const EdgeInsets.only(top: 5.0, left: 6.0),
            color: miTema.accentColor,
            width: 100,
            height: 100,
            child: Text(
              '${date.day}',
              style: TextStyle(color: Colors.white).copyWith(fontSize: 16.0),
            ),
          );
        },
        markersBuilder: (context, date, events, holidays) {
          final children = <Widget>[];

          if (events.isNotEmpty) {
            children.add(
              Positioned(
                right: 1,
                bottom: 1,
                child: _buildEventsMarker(date, events),
              ),
            );
          }

          if (holidays.isNotEmpty) {
            children.add(
              Positioned(
                right: -2,
                top: -2,
                child: _buildHolidaysMarker(),
              ),
            );
          }

          return children;
        },
      ),
      onDaySelected: (date, events) {
        _onDaySelected(date, events);
        _animationController.forward(from: 0.0);
      },
      onVisibleDaysChanged: _onVisibleDaysChanged,
      onCalendarCreated: _onCalendarCreated,
    );
  }

  //indicadores de tareas
  Widget _buildEventsMarker(DateTime date, List events) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      decoration: BoxDecoration(
        shape: BoxShape.rectangle,
        color: _calendarController.isSelected(date)
            ? Colors.redAccent
            : _calendarController.isToday(date) ?Colors.orange[200] : miTema.accentColor,
      ),
      width: 16.0,
      height: 16.0,
      child: Center(
        child: Text(
          '${events.length}',
          style: TextStyle().copyWith(
            color: Colors.white,
            fontSize: 12.0,
          ),
        ),
      ),
    );
  }

  Widget _buildHolidaysMarker() {
    return Icon(
      Icons.add_box,
      size: 20.0,
      color: Colors.blueGrey[800],
    );
  }



  Widget _listEvents(){
    return StreamBuilder(
      // stream:  Provider
      // .of<TasksEmployeeService>(context,listen: false).tasksCalendarEventsStream ,
      stream: TasksEmployeeService.instance.tasksCalendarEventsStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        //List<TareasPersonal> list=new List();
        List list = new List();
        if(snapshot.hasData)
          list = snapshot.data;
        return ListView.builder(
          //controller: _hideButtonController,
          itemCount: list.length,
          itemBuilder: (context,index){
            return _elementEvent(list[index]);
          }
        );
      },
    );
  }

  _elementEvent(TareasTrabajadorElement tp){
      // print("Estatus ${tp.status}");
     return Container(
              margin: const EdgeInsets.symmetric(horizontal: 8.0, vertical: 4.0,),
              
              child: Card(
                elevation: 2.0,
                child: Row(
                  children:<Widget>[
                    Container(
                      color:statusColor(tp.status),
                      width: 10,
                      height: 50,
                    ),
                    SizedBox(width:5),
                    Expanded(child: Container(
                      child:Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Text("# ${tp.consecutivo}"),
                        Row(
                          children:<Widget>[
                            Icon(LineIcons.clock_o,color: MyColors.GreyIcon,),
                            SizedBox(width:5),
                            Flexible(
                              child: Container(
                              child:Text("${tp.horaInicio}  hrs - ${tp.horaFinal} hrs",overflow: TextOverflow.ellipsis,)
                              ),
                            )
                          ]
                        ),
                        Text("${DateFormat('yyyy-MM-dd').format(tp.fecha)} ${tp.tarea.nombre}"),
                        // Text("A cargo de ${tp!=null? tp.personal.nombre:""}"),
                      ],)
                    )),
                    tp.status==AppConfig.statusTaskNueva? //tarea nueva
                      IconButton(icon: Icon(LineIcons.check),
                        onPressed: ()=>showMyDialog(
                         context,
                         "Tarea",
                          "¿Estas seguro de comenzar la tarea?",
                          ()=>_iniciarTarea(tp.consecutivo), 
                         ))
                      :Container(),
                    tp.status==AppConfig.statusTaskEnProceso? //tarea en proceso => para finalizar
                      IconButton(icon: Icon(LineIcons.check,color: miTema.accentColor,),
                        onPressed: ()=>showMyDialog(
                         context,
                         "Tarea",
                          "¿Estas seguro de finalizar la tarea?",
                          ()=>_finalizarTarea(tp.consecutivo), 
                         ))
                      :Container(),
                    IconButton(icon: Icon(LineIcons.eye), onPressed: ()=>showDetails(tp)),
                    
                    
                  ]
                ),
              //   child: ListTile(
              //   title: Text("${tp.horaInicio} hrs - ${tp.horaFinal} hrs "),
              //   onTap: () => print('${tp.horaInicio} tapped! concluir'  ),
              //   leading: IconButton(icon: Icon(LineIcons.ellipsis_v), onPressed: null),
              // ),
              ),
              );
  }

  _iniciarTarea(int consecutivo){
    TasksEmployeeService.instance.iniciarTarea(consecutivo)
      .then((v){
        Flushbar(
          message: TasksEmployeeService.instance.response,
          duration:  Duration(seconds: 2),              
        )..show(context);
      });
  }
  
  _finalizarTarea(int consecutivo){
    TasksEmployeeService.instance.finalizarTarea(consecutivo)
      .then((v){
        Flushbar(
          message: TasksEmployeeService.instance.response,
          duration:  Duration(seconds: 2),              
        )..show(context);
      });
  }
  Color statusColor(int status){
    switch(status){
      case 0:
        return Colors.grey;  //sin realizar || null
      case 1:
        return Colors.green; // finalizada
      break;
      case 2:
        return Colors.blue; // activa
      case 3:
        return Colors.red; //cancelada
      case 4:
        return Colors.purple; // en espera 
      default:
        return Colors.yellow; 
    }
  }

  void customBottomSheet(Widget myWidget,double heightP){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height *heightP,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: Center(
          child: myWidget
        ),
      ),
    );
  }

  void menuOptions(TareasTrabajadorElement tp){
    Column myWidget = Column(
            children:<Widget>[
              Container(
                margin: EdgeInsets.only(top:2),
                width:100,
                height:5,
                decoration: BoxDecoration(
                  color:Colors.black87,
                  borderRadius: BorderRadius.circular(5)
                  ),
                ),
              // tp.status==1?
              // Container():
              // new ListTile(
              //   dense: true,
              //     leading: new Icon(LineIcons.close),
              //     title: new Text('Cancelar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
              //     onTap: ()async { 
              //       print("consecutivo ${tp.consecutivo}");
              //       // showMyDialog(
              //       //   context,
              //       //   "Tarea", "¿Estas seguro de cancelar la tarea?"
              //       //   ,()=>taskBloc.cancelarTarea(tp.consecutivo).then((v){
              //       //     Flushbar(
              //       //       message:  taskBloc.response,
              //       //       duration:  Duration(seconds: 2),              
              //       //     )..show(context).then((r){
              //       //       Navigator.pop(context);
              //       //     });
              //       //   }));
              //     },
              //   ),
              //   new ListTile(
              //     dense: true,
              //     leading: new Icon(LineIcons.clock_o),
              //     title: new Text('Reasignar horario',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
              //     onTap: () { 
              //      Navigator.pushNamed(context, 'tarea_reasignar_horario',arguments:tp);
              //     },
              //   ),

                // new ListTile(     
                //   dense: true,
                //   leading: new Icon(LineIcons.check),
                //   title: new Text('Comenzar tarea',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
                //   onTap: () { 
                //   /// Navigator.pushNamed(context, 'tarea_reasignar_personal',arguments: tp);
                //   showMyDialog(
                //       context,
                //       "Tarea", "¿Estas seguro de comenzar la tarea?"
                //       ,
                //       null
                //       // ()=>taskBloc.cancelarTarea(tp.consecutivo).then((v){
                //       //   Flushbar(
                //       //     message:  taskBloc.response,
                //       //     duration:  Duration(seconds: 2),              
                //       //   )..show(context).then((r){
                //       //     Navigator.pop(context);
                //       //   });
                //       // })
                //       );
                //   },
                // ),
            ]
          );
    customBottomSheet(myWidget, 0.35);
  }

  void showDetails(TareasTrabajadorElement tp){
    TextStyle _style = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400,color: MyColors.GreyIcon);
    Column myWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        
        Container(
          child: new ListTile(
            dense:true,
            leading: new Icon(LineIcons.calendar_check_o,color: Colors.white,),
            title: Container(
              child: Row(
                children: <Widget>[
                  new Text('Tarea',
                    style: TextStyle(fontFamily:'Quicksand',
                    fontWeight: FontWeight.w400,color: Colors.white),),


                  Expanded(child: Container()),
                  Row(
                    children:<Widget>[
                      IconButton(
                        icon:SvgPicture.asset('assets/icons/bottle_icon.svg',color:Colors.white,height: 20,),
                        onPressed: (){
                          Map<String,dynamic> map = new Map();
                          map =  {
                          'isHerramienta':false,
                          'herramientas':tp.herramientas.isNotEmpty?tp.herramientas:[],
                          'insumos' : tp.insumos.isNotEmpty?tp.insumos:[]};
                          Navigator.pushNamed(context, 'task_employee_details',arguments: map);
                        }),
                        IconButton(
                        icon:SvgPicture.asset('assets/icons/tools_icon.svg',color:Colors.white,height: 20,),
                        onPressed: (){
                          Map<String,dynamic> map = new Map();
                          map =  {
                            'isHerramienta':true,
                            'herramientas':tp.herramientas.isNotEmpty?tp.herramientas:[],
                            'insumos' : tp.insumos.isNotEmpty?tp.insumos:[]};
                    
                          Navigator.pushNamed(context, 'task_employee_details',arguments: map);

                        })
                    ]
                  )
                ],
              ),
            ),
            onTap: null,
            // trailing:  Container(
            //   width: 50,
            //   height: 50,
            //   child: Row(
            //     children:<Widget>[
                  
            //     ]
            //   ),
            // )
              // IconButton(
              //   icon:SvgPicture.asset('assets/icons/tools_icon.svg',color:MyColors.GreyIcon,height: 20,),
              //   onPressed: ()=> toolsModalBottomSheet(context)//Navigator.pushNamed(context, 'tarea_herramientas')
              //   ),
          ),
          decoration: BoxDecoration(
            color:miTema.accentColor,
            borderRadius: BorderRadius.only(topRight:  Radius.circular(25),topLeft:Radius.circular(25))
          ),
        ),
         SizedBox(height:10),
        _element(LineIcons.calendar_check_o,tp.tarea!=null? tp.tarea.nombre:""),
        _element(LineIcons.map_pin ,strignStatus(tp.status!=null?tp.status:0)),
        // _element(LineIcons.user,tp.personal!=null?tp.personal.nombre:""),
        _element(LineIcons.clock_o,"Inicio: ${tp.horaInicio}hrs --Final ${tp.horaFinal}hrs" ),
      ],
    );
    customBottomSheet(myWidget, 0.25);
  }

  _element(IconData icon,String texto){
    TextStyle _style = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w700,color: MyColors.GreyIcon);
    return Container(
      margin: EdgeInsets.only(left:15),
      child:Row(children: <Widget>[
        Icon(icon,color: MyColors.GreyIcon,),
        SizedBox(width:20),
        Flexible(
                  child: Container(
            child:Text(texto,style: _style, overflow: TextOverflow.ellipsis,)
          ),
        )
      ],)
    );
  }


  String strignStatus(int status){
    switch(status){
      case 0:
        return "Sin realizar";  //sin realizar || null
      case 1:
        return "Concluida"; // finalizada
      break;
      case 2:
        return "En proceso"; // activa
      case 3:
        return "Cancelada"; //cancelada
      case 4:
        return "En espera de ser confirmada"; // en espera 
    }
  }


   _weatherBit(){
    return StreamBuilder(
      stream: mapBoxBloc.weatherBitStream ,
      initialData: mapBoxBloc.weatherBit,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData)
          return Container(
            height: 160,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius : BorderRadius.circular(15)
            ),
          );
        WeatherBit weather;
         weather= snapshot.data;
        return _itemWeatherBit(weather);
      },
    );
  }
  _itemWeatherBit(WeatherBit clima){
    // if(clima!=null){
    //   final date = DateTime.parse(clima.data[0].datetime);
    //   taskBloc.onChangeDateNet(date);
    // }
    TextStyle _style =TextStyle(color:Colors.white,fontFamily: AppConfig.quicksand,
                  fontWeight: FontWeight.w700,
                );
     return Container( 
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: miTema.accentColor,
        borderRadius : BorderRadius.circular(15)
      ),
      width: double.infinity,
      height: 170,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
            child: Column(
            children:<Widget>[
              Text(clima==null?
                "Oaxaca, MX":
               "${clima.data[0].cityName}, ${clima.data[0].countryCode}",
              style: TextStyle(
                fontSize: 18,
                color:Colors.white,fontFamily:AppConfig.quicksand,fontWeight:FontWeight.w700),),
              SizedBox(height:2),
              Text(
                clima==null?
                "0.0 °C":
                "${clima.data[0].temp} °C",style:  TextStyle(fontFamily:AppConfig.quicksand,fontSize:35,color:Colors.white),),
              SizedBox(height:2),
              Text(clima==null?"":"Sensación termica ${clima.data[0].appTemp} °C",style: _style,), 
              SizedBox(height:5),
              Text(clima==null?"":"${clima.data[0].datetime}",style: _style,)

            
            ]
          ),
          ),
          Expanded(child: Column(
            children:<Widget>[
              _icon(clima.data[0].weather.icon),
               Text(clima==null?"":"${clima.data[0].weather.description}",
                style: TextStyle(color:Colors.white,fontFamily: AppConfig.quicksand,
                  fontWeight: FontWeight.w700
                ),),
            ]
          ))
        ],
      ),  
    );
  }


  _icon(String icon){
    if(icon!=null){
      return  FadeInImage(
        placeholder: AssetImage('assets/images/placeholder.png'), 
        image: NetworkImage(AppConfig.weather_bit_url_icon+icon+".png"),
        fit : BoxFit.cover,
        height: 80,
        );
    }
    return 
      Container(
        height:40,
        child:Image.asset('assets/images/placeholder.png')
      );
  }
}