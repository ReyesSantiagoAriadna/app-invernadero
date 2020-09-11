import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_tarea_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';


class TareaWidget extends StatefulWidget {
  final Tarea tarea;
  final ActividadTareaBloc tareaBloc;

  const TareaWidget({Key key, this.tarea, this.tareaBloc}) : super(key: key);

 
  @override
  _TareaWidgetState createState() => _TareaWidgetState();
}

class _TareaWidgetState extends State<TareaWidget> {
  
  TextStyle _style,_styleSub;
  Responsive _responsive;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _responsive = Responsive.of(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {  
    _style = TextStyle(color:Colors.black54,fontWeight: FontWeight.w600,fontFamily: AppConfig.quicksand,fontSize: _responsive.ip(1.8));
    _styleSub = TextStyle(color:Colors.black87,fontFamily: AppConfig.quicksand,fontSize:_responsive.ip(1.5));
    
    return GestureDetector(
      onTap: (){
        widget.tareaBloc.onChangeTarea(widget.tarea);
        //Navigator.pushNamed(context, 'details_solar',arguments: widget.solar);
      },
      child: new Container(
        margin: EdgeInsets.only(top:10,bottom:5),
        child:Card(
          elevation: 2,
                  child: Column(  
            children:<Widget>[
             // _createFlutterMap(widget.solar.latitud, widget.solar.longitud),
              Container(
                padding: EdgeInsets.all(4),
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    // Column(
                    //   mainAxisAlignment: MainAxisAlignment.start,
                    //   crossAxisAlignment: CrossAxisAlignment.start,
                    //   children:<Widget>[
                    //     Icon(LineIcons.sun_o,color: miTema.accentColor,),
                    //     Text('${widget.tarea.nombre }',style: _style,),
                    //     Text('${widget.tarea.cultivo.nombre } ',style: _styleSub,)
                    //   ]
                    // ),
                    _icon(),
                    // Expanded(child: Container()),
                    Flexible(
                                          child: Container(
                        // color: Colors.red,
                        margin: EdgeInsets.only(left:20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:<Widget>[
                            Text("${widget.tarea.nombre}",
                              overflow: TextOverflow.ellipsis,
                              style: _style,),
                            SizedBox(height:5),
                            Row(
                              children:<Widget>[
                                Icon(LineIcons.clock_o,size: 20,color: Colors.grey,),
                                Text("${widget.tarea.horaInicio} - ${widget.tarea.horaFinal}",
                                  style: _styleSub,
                                )
                              ]),
                        ]),
                      ),
                    ),
                    //Expanded(child: Container()),
                    Row(
                      children:<Widget>[
                        IconButton(icon:  Icon(LineIcons.eye,color: MyColors.GreyIcon,), 
                          onPressed: ()=>showItem()),
                        IconButton(icon:  Icon(LineIcons.ellipsis_v,color: MyColors.GreyIcon,), 
                          onPressed: ()=>menuOptions()),
                       
                      ]
                    )
                  ],
                ),
              ),
              
            ]
          ),
        ) ,
        // decoration: BoxDecoration(
        //         color : Colors.white,
        //         borderRadius: BorderRadius.circular(5.0),
        //         boxShadow: <BoxShadow>[
        //           BoxShadow(
                  
        //             color:Colors.black26,
        //             blurRadius: 3.0,
        //             offset : Offset(0.0,3),
        //             spreadRadius: 3.0
        //           )
        //         ]
        //       ),
      ),
    );
  }


  // void _deleteModalBottomSheet(context)async{
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext bc){
  //       return Container(
  //         child: new Wrap(
  //         children: <Widget>[ 
  //           new ListTile(
  //             leading: new Icon(LineIcons.trash_o),
  //             title: new Text('Eliminar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
  //             onTap: () { 
  //               Provider.of<TareasService>(context,listen: false)
  //               .deleteTarea(widget.tarea.id)
  //               .then((r){
  //                 Flushbar(
  //                   message:  Provider.of<TareasService>(context,listen: false).response,
  //                   duration:  Duration(seconds: 2),              
  //                 )..show(context).then((r){
  //                   Navigator.pop(context);
  //                 });
  //               });
  //             },
  //           ),

  //           new ListTile(
  //             leading: new Icon(LineIcons.pencil),
  //             title: new Text('Editar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
  //             onTap: () { 
  //               Navigator.pushNamed(context, 'tarea_edit',arguments: widget.tarea);
  //             },
  //           ),
            
  //           ],
  //          ),
  //       );
  //     }
  //   );
  // } 

 

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

  void menuOptions(){
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
              new ListTile(
                dense: true,
                  leading: new Icon(LineIcons.trash_o),
                  title: new Text('Eliminar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
                  onTap: () { 
                    Provider.of<TareasService>(context,listen: false)
                    .deleteTarea(widget.tarea.id)
                    .then((r){
                      Flushbar(
                        message:  Provider.of<TareasService>(context,listen: false).response,
                        duration:  Duration(seconds: 2),              
                      )..show(context).then((r){
                        Navigator.pop(context);
                      });
                    });
                  },
                ),

                new ListTile(
                  dense: true,
                  leading: new Icon(LineIcons.pencil),
                  title: new Text('Editar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
                  onTap: () { 
                    Navigator.pushNamed(context, 'tarea_edit',arguments: widget.tarea);
                  },
                ),
            ]
          );
    customBottomSheet(myWidget, 0.18);
  }


  void showItem(){
    TextStyle _style = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400,color: MyColors.GreyIcon);
    Column myWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        
        Container(
          child: new ListTile(
            dense:true,
            leading: new Icon(LineIcons.calendar_check_o,color: Colors.white,),
            title: new Text('Tarea',
            style: TextStyle(fontFamily:'Quicksand',
            fontWeight: FontWeight.w400,color: Colors.white),),
            onTap: null
          ),
          decoration: BoxDecoration(
            color:miTema.accentColor,
            borderRadius: BorderRadius.only(topRight:  Radius.circular(25),topLeft:Radius.circular(25))
          ),
        ),
         SizedBox(height:10),
        _element(LineIcons.life_bouy, widget.tarea.nombre),
        _element(LineIcons.calendar_check_o, widget.tarea.cultivo.nombre),
        _element(LineIcons.sitemap, widget.tarea.etapa),
         _element(LineIcons.clipboard, widget.tarea.detalle),
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
        SizedBox(width:40),
        Text(texto,style: _style,)
      ],)
    );
  }


  _icon(){
    //if(widget.tarea==AppConfig.taskType1){
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Icon(
              Icons.brightness_1,
              size: _responsive.ip(5), color: _color(widget.tarea.tipo)),
          new Icon(
            LineIcons.calendar_check_o,
            size: _responsive.ip(3),
            color: Colors.white,
          ),
        ],);
    //}
  }

  Color _color(String type){
    switch (type){
      case AppConfig.taskType1:
      return Colors.red;
      case AppConfig.taskType2:
      return Colors.purple;
      case AppConfig.taskType3:
      return Colors.blue;
      case AppConfig.taskType4:
      return Colors.purple;
      default:
      return Colors.greenAccent;
    }
  }

  
}