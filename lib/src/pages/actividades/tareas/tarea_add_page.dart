import 'dart:ui';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_tarea_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/generic_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/insumos_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/tareas/select_herramientas.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/tareas/select_insumos.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/tareas/tarea_tipo_widget.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/sensores_widget.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_cultivo.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_cultivo_etapa.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_solar.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_cultivo_tipo.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_solares.dart';
import 'package:app_invernadero_trabajador/src/widgets/input_select.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';
class TareaAddPage extends StatefulWidget {
  TareaAddPage({Key key}) : super(key: key);

  @override
  _TareaAddPageState createState() => _TareaAddPageState();
}

class _TareaAddPageState extends State<TareaAddPage> {
  Responsive _responsive;
  TextStyle _style;
  TextStyle _secundaryStyle;
  bool _isLoading=false;
  MaterialLocalizations localizations;
  TextStyle _itemStyle;
  ActividadTareaBloc tareaBloc;
  GenericBloc genericBloc;
  SolarCultivoBloc solarCultivoBloc;
  @override
  void initState() {
    tareaBloc = ActividadTareaBloc();
    genericBloc = GenericBloc();
    solarCultivoBloc = SolarCultivoBloc();
    
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _responsive = Responsive.of(context);
    localizations = MaterialLocalizations.of(context);
 
    _itemStyle = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400);
    _style = TextStyle(
      color: MyColors.GreyIcon,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: _responsive.ip(1.8)
    );

    _secundaryStyle = TextStyle(
      color: Colors.black87,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: _responsive.ip(1.5));
  }
  @override
  void dispose() {
    genericBloc.reset();
    tareaBloc.reset();
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
            title:Text("Nuevo Tarea",style:TextStyle(color: MyColors.GreyIcon,
              fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w800
            )),
            leading: IconButton(
              icon: Icon(LineIcons.angle_left,color:MyColors.GreyIcon), 
              onPressed:()=> Navigator.pop(context)),
            actions: <Widget>[
              // IconButton(
              //   icon: Icon(LineIcons.save,color: MyColors.GreyIcon,), onPressed: ()=>_addSolar())
              IconButton(
                icon:SvgPicture.asset('assets/icons/bottle_icon.svg',color:MyColors.GreyIcon,height: 20,),
                onPressed: ()=>insumosModalBottomSheet(context)),
              IconButton(
                icon:SvgPicture.asset('assets/icons/tools_icon.svg',color:MyColors.GreyIcon,height: 20,),
                onPressed: ()=> toolsModalBottomSheet(context)//Navigator.pushNamed(context, 'tarea_herramientas')
                ),
              _createButtonSave(),
            ],
          ),
          body:GestureDetector(
            onTap: ()=>FocusScope.of(context).unfocus(),
            child: _body()
          ),
        //   floatingActionButton: FloatingActionButton(
        //     onPressed: () {
        //       Navigator.pushNamed(context, 'cultivo_etapas');
        //     },
        //     child: Icon(LineIcons.plus),
        //   backgroundColor: miTema.accentColor,
        // ),
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
            Text("Información de la tarea",style: TextStyle(
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
            DialogSelectSolar(solarCultivoBloc: solarCultivoBloc, responsive: _responsive),
            SizedBox(height:_responsive.ip(2)),
            DialogSelectCultivo(solarCultivoBloc: solarCultivoBloc, responsive: _responsive),
            SizedBox(height:_responsive.ip(2)),
            DialogSelectCultivoEtapa(solarCultivoBloc: solarCultivoBloc, responsive: _responsive),
            SizedBox(height:_responsive.ip(2)),
            _inputNombre(), 
            SizedBox(height:_responsive.ip(2)),
             _tipo(),
            SizedBox(height:_responsive.ip(2)),
            _times(),
            SizedBox(height:_responsive.ip(2)),
            _observacion(),
          ],
        )
      ),
    );
  }

  _tipo(){
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget>[
          Row(
              children: <Widget>[
               // SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                Icon(LineIcons.calendar_check_o,color: MyColors.GreyIcon,),
                SizedBox(width:18),
                Text("Tipo de tarea",style: _style,),
              ],
            ),
          SizedBox(height:_responsive.ip(2)),
          StreamBuilder<Object>(
            stream: tareaBloc.tareaTipoStream,
            builder: (context, snapshot) {
              return GestureDetector(
                onTap: (){
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return TareaTipo(tareaBloc: tareaBloc,);
                  });
                },
              child: InputSelect(text:snapshot.hasData?snapshot.data:"Elije el tipo",responsive: _responsive,));
            }
          )
        ]
      ),
    );
  }
  
  

  _inputNombre(){
    return StreamBuilder(
        stream: genericBloc.nombreStream ,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return  TextFormField(
            decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                        borderSide: BorderSide(color:miTema.accentColor)),
              icon: Icon(LineIcons.sun_o,color: Colors.white),
              labelText: 'Nombre', 
              errorText: snapshot.error =='*' ? null:snapshot.error,
            ),
            onChanged: genericBloc.onChangeNombre,
          );
          }
      );
  }
  
 
  _observacion(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
               // SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                Icon(LineIcons.clipboard,color: MyColors.GreyIcon,),
                SizedBox(width:18),
                Text("Detalles",style: _style,),
              ],
            ),
           SizedBox(height:_responsive.ip(2)),
          Container(
            margin: EdgeInsets.only(left:40),
            padding: EdgeInsets.all(8),
            child: StreamBuilder<Object>(
              stream: genericBloc.descripcionStream,
              builder: (context, snapshot) {
                return TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                   hintText: "Ingresa los detalles..",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:MyColors.GreyIcon),
                    ),
                         focusedBorder:  OutlineInputBorder(      
                              borderSide: BorderSide(color:miTema.accentColor)),
                        //labelText: 'Largo'
                      errorText: snapshot.error =='*' ? null:snapshot.error,
                      ),
                  // decoration: InputDecoration.collapsed(
                    onChanged: genericBloc.onChangeDescripcion,
                   
                );
              }
            ),
          )
        ]
      ),
    );
  }


  _times(){
    return Row(
      children: <Widget>[
        _time("Hora de inicio", 1,genericBloc.horaIniStream,genericBloc.onChangeHoraIn),
        Expanded(child: Container()),
        _time("Hora de Finalización", 2,genericBloc.horaFinStream,genericBloc.onChangeHoraFin),
      ],
    );
  }
  
  _time(String title,int tipo,Stream stream,Function(String) onChange){
    return GestureDetector(
      onTap: (){
        if(tipo==1)
              _selectTime(context,onChange,null);
        else if(tipo==2){
          //if(genericBloc.fechaIni!=null){
            _selectTime(context,onChange,genericBloc.fechaIni);
          // }
        }
      },
      child: Container(
            // color: Colors.red,
        child: Column(
          // mainAxisAlignment: MainAxisAlignment.end,
          // crossAxisAlignment: CrossAxisAlignment.end,
          children:<Widget>[
           Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Icon(LineIcons.clock_o,color: MyColors.GreyIcon,),
                Container(
                  margin: EdgeInsets.only(left:20),
                  child: Text(title,style: _style,)),
                
              ],
                ),
            SizedBox(height:10),
            Container(
              //color: Colors.yellow,
              margin: EdgeInsets.only(left:15),
              padding: EdgeInsets.all(5),
              child: StreamBuilder<Object>(
                stream: stream,
                builder: (context, snapshot) {
                  return Text(snapshot.hasData?snapshot.data:"00:00",
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily:AppConfig.quicksand,fontWeight:FontWeight.w700,
                    fontSize: _responsive.ip(1.8)
                    ),);
                }
              ),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  width: 1,
                  color: MyColors.GreyIcon)  
                ),
                
                )
          ]
        ),
      ),
    );
  }
  _selectTime(BuildContext context,Function(String) onChange,String s) async{
      TimeOfDay _startTime ;
      if(s!=null)
        _startTime  = TimeOfDay(hour:int.parse(s.split(":")[0]),minute: int.parse(s.split(":")[1]));
      
      TimeOfDay  picked = await showTimePicker(
        context: context, 
        initialTime:_startTime !=null?_startTime: new TimeOfDay.now(),
      );
      if(picked != null){
        String formattedTime = localizations.formatTimeOfDay(picked,
          alwaysUse24HourFormat: true);
        if (formattedTime != null) {
          formattedTime = formattedTime+":00";
          print(formattedTime);
          onChange(formattedTime);
        }
      }
  }
 
  

  
  void toolsModalBottomSheet(context)async{
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          // height:200,
          child: Column(
            children: <Widget>[
              Container(
                color: miTema.accentColor,
                child: new ListTile(
                  dense: false,
                  leading: new SvgPicture.asset('assets/icons/tools_icon.svg',color:Colors.white,height: 20,),
                  title: Row(
                    children: <Widget>[
                      new Text('Herramientas',style: TextStyle(color:Colors.white,fontFamily:'Quicksand',fontWeight: FontWeight.w700),),
                      Expanded(child: Container()),
                      new IconButton(icon: Icon(LineIcons.plus,color: Colors.white,), onPressed: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SelectHerramientas(tareaBloc: tareaBloc,);
                          });
                      })
                    ],
                  ),
                  onTap: null,
                ),
              ),
              new ListTile(
                
                leading: Text("#",style: _itemStyle,),
                title: Row(
                  children: <Widget>[
                    Text('Nombre',style:_itemStyle ,),
                    Expanded(child: Container()),
                    Text('Cantidad',style: _itemStyle,),
                  ],
                ),
                onTap: null,
              ),
              Expanded(
                              child: Container(
                  // height: 200,
                  child: StreamBuilder(
                    stream: tareaBloc.herramientasStream ,
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(!snapshot.hasData)
                        return Container();
                      List<Herramienta> herramientas= snapshot.data;
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: herramientas.length,
                        itemBuilder: (context,index){
                          return _itemHerramienta(herramientas[index]);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  } 

  _itemHerramienta(Herramienta h){
    return new ListTile(
                leading: Text("${h.id}",style: _itemStyle,),
                title: Row(
                  children: <Widget>[
                    Text(h.nombre,style: _itemStyle,),
                    Expanded(child: Container()),
                    Row(
                      children:<Widget>[
                        IconButton(icon: Icon(LineIcons.chevron_circle_left), onPressed: ()=>tareaBloc.decCantidadHerramienta(h)),
                        Text("${h.amountOnTask}",style:_itemStyle,),
                        IconButton(icon: Icon(LineIcons.chevron_circle_right), onPressed: ()=>tareaBloc.incCantidadHerramienta(h))
                      ]
                    )
                  ],
                ),
                onTap: null,
              );
  }


  void insumosModalBottomSheet(context)async{
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          // height:200,
          child: Column(
            children: <Widget>[
              Container(
                color: miTema.accentColor,
                child: new ListTile(
                  dense: false,
                  leading: new SvgPicture.asset('assets/icons/bottle_icon.svg',color:Colors.white,height: 20,),
                  title: Row(
                    children: <Widget>[
                      new Text('Insumos',style: TextStyle(color:Colors.white,fontFamily:'Quicksand',fontWeight: FontWeight.w700),),
                      Expanded(child: Container()),
                      new IconButton(icon: Icon(LineIcons.plus,color: Colors.white,), onPressed: (){
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return SelectInsumos(tareaBloc: tareaBloc,);
                          });
                      })
                    ],
                  ),
                  onTap: null,
                ),
              ),
              new ListTile(
                
                leading: Text("#",style: _itemStyle,),
                title: Row(
                  children: <Widget>[
                    Text('Nombre',style:_itemStyle ,),
                    Expanded(child: Container()),
                    Text('Cantidad',style: _itemStyle,),
                  ],
                ),
                onTap: null,
              ),
              Expanded(
                              child: Container(
                  // height: 200,
                  child: StreamBuilder(
                    stream: tareaBloc.insumosStream ,
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(!snapshot.hasData)
                        return Container();
                      List<Insumo> insumos= snapshot.data;
                      return ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: insumos.length,
                        itemBuilder: (context,index){
                          return _itemInsumo(insumos[index]);
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
        );
      }
    );
  } 

  _itemInsumo(Insumo item){
    return new ListTile(
                leading: Text("${item.id}",style: _itemStyle,),
                title: Row(
                  children: <Widget>[
                    Text(item.nombre,style: _itemStyle,),
                    Expanded(child: Container()),
                    Row(
                      children:<Widget>[
                        IconButton(icon: Icon(LineIcons.chevron_circle_left), onPressed: ()=>tareaBloc.decCantidadInsumo(item)),
                        Text("${item.amountOnTask}",style:_itemStyle,),
                        IconButton(icon: Icon(LineIcons.chevron_circle_right), onPressed: ()=>tareaBloc.incCantidadInsumo(item))
                      ]
                    )
                  ],
                ),
                onTap: null,
              );
  }
  
  _createButtonSave(){
    return StreamBuilder(
      stream: tareaBloc.formTarea,
      builder: (BuildContext context, AsyncSnapshot snapshot){
          return IconButton(
          icon: Icon(LineIcons.save,color: MyColors.GreyIcon,), 
          onPressed: snapshot.hasData?()=>_addTarea():null
          );
      },
    );
  }
  
  _addTarea()async{
    if(_isLoading)return;
    setState(() {
      _isLoading=true;
    });
    await tareaBloc.addTarea(context);
    setState(() {
      _isLoading=true;
    });     
    
    Flushbar(
      message: Provider.of<TareasService>(context,listen: false).response,
      duration:  Duration(seconds: 2),              
    )..show(context).then((r){
      Navigator.pop(context);

      //if()
    });
  }
}

