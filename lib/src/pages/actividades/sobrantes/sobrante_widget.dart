import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_sobrante_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_tarea_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/sobrantes_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/sobrantes_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';


class SobranteWidget extends StatefulWidget {
  final Sobrante sobrante;
  final ActividadSobranteBloc sobranteBloc;

  const SobranteWidget({Key key, this.sobrante, this.sobranteBloc}) : super(key: key);


 
  @override
  _SobranteWidgetState createState() => _SobranteWidgetState();
}

class _SobranteWidgetState extends State<SobranteWidget> {
  
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
    
    return new Container(
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
                  _icon(),
                  Flexible(
                    child: Container(
                      margin: EdgeInsets.only(left:20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children:<Widget>[
                          Text("${widget.sobrante.observacion}",
                            overflow: TextOverflow.ellipsis,
                            style: _style,),
                          SizedBox(height:5),
                          Row(
                            children:<Widget>[
                              Icon(LineIcons.clock_o,size: 20,color: Colors.grey,),
                              Text("${widget.sobrante.fecha}",
                                style: _styleSub,
                              )
                            ]),
                      ]),
                    ),
                  ),
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
    );
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
                    Provider.of<SobrantesService>(context,listen: false)
                    .deleteSobrante(widget.sobrante.id)
                    .then((r){
                      Flushbar(
                        message:  Provider.of<SobrantesService>(context,listen: false).response,
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
                    Navigator.pushNamed(context, 'sobrante_edit',arguments: widget.sobrante);
                  },
                ),
            ]
          );
    customBottomSheet(myWidget, 0.15);
  }


  void showItem(){
    TextStyle _style = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400,color: MyColors.GreyIcon);
    Column myWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        
        Container(
          child: new ListTile(
            dense:true,
            leading: new Icon(LineIcons.clipboard,color: Colors.white,),
            title: new Text('Sobrante',
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
        _element(LineIcons.code, widget.sobrante.id.toString()),
        _element(LineIcons.archive, widget.sobrante.producto.nombre.toString()),
        _element(LineIcons.clipboard, widget.sobrante.observacion.toString()),

        // _element(LineIcons.calendar_check_o, widget.tarea.cultivo.nombre),
        // _element(LineIcons.sitemap, widget.tarea.etapa),
        //  _element(LineIcons.clipboard, widget.tarea.detalle),
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
              size: _responsive.ip(5), color: Colors.grey//_color(widget.tarea.tipo)
              ),
          new Icon(
            LineIcons.clipboard,
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