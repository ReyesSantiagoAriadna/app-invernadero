
import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';

class TaskEmployeeDetails extends StatefulWidget {
  @override
  _TaskEmployeeDetailsState createState() => _TaskEmployeeDetailsState();
}

class _TaskEmployeeDetailsState extends State<TaskEmployeeDetails> {
  Map<String,dynamic> map;
  List insumosList=[];
  List herramientasList =[];
  Responsive _responsive;
  bool isHerramientas;
  String title;
  @override
  void initState() {
    super.initState();
  }


  @override
  void didChangeDependencies() {
    if(map==null){
      map =   ModalRoute.of(context).settings.arguments  ;
      herramientasList = map['herramientas']; //as List<Herramienta>;
      insumosList = map['insumos'] ;//as List<Insumo>;
      isHerramientas = map['isHerramienta'] as bool;

      isHerramientas?title="Herramientas":title="Insumos";
      _responsive = Responsive.of(context);
    }
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        title: Text(title,style: TextStyle(color:MyColors.GreyIcon,),),
        backgroundColor: Colors.white,
        elevation: 0.0,
        leading: IconButton(icon: Icon(LineIcons.angle_left,color:MyColors.GreyIcon), onPressed: ()=>Navigator.pop(context)),
        // actions: <Widget>[
        //   IconButton(
        //         icon:SvgPicture.asset('assets/icons/bottle_icon.svg',color:MyColors.GreyIcon,height: 20,),
        //         onPressed: (){
        //           setState(() {
        //             isHerramientas=false;
        //             title = "Insumos";
        //           });
        //         }),
        //   IconButton(
        //         icon:SvgPicture.asset('assets/icons/tools_icon.svg',color:MyColors.GreyIcon,height: 20,),
        //         onPressed: (){
        //           setState(() {
        //             isHerramientas=true;
        //             title = "Herramientas";
        //           });
        //         }
        //         ),
        // ],
      ),

      backgroundColor: Colors.white,
      body: _body(),
    );
  }

  _body(){
    return SafeArea(
      child: Container(
        margin: EdgeInsets.all(4),
        color: Colors.white,
        width:double.infinity,
        height: double.infinity,

        child:isHerramientas? _listHerramientas():_listInsumos(),
      ),
    );
  }

  _listHerramientas(){
    return ListView.builder(
      itemCount: herramientasList.length,
      itemBuilder: (context,index){
        return _herramientaElement(herramientasList[index]);
      },
    );
  } 

  _listInsumos(){
    return ListView.builder(
      itemCount: insumosList.length,
      itemBuilder: (context,index){
        return _insumoElement(insumosList[index]);
      },
    );
  }

  _herramientaElement(dynamic d){
    Herramienta h = d as Herramienta;
    TextStyle style = TextStyle(fontFamily: AppConfig.quicksand,
      color: MyColors.GreyIcon,fontWeight: FontWeight.w600
    );
    return  new Container(
        margin: EdgeInsets.only(top:10,bottom:5),
        child:Card(
          elevation: 2,
                  child: Column(  
            children:<Widget>[
              Container(
                padding: EdgeInsets.all(4),
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 5,
                      height: _responsive.ip(8),
                      color: Colors.red,
                    ),
                    _icon(),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left:20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:<Widget>[
                            Text("Herramienta: ${h.nombre}",
                              overflow: TextOverflow.ellipsis,
                              style: style,),
                            SizedBox(height:5),
                            Row(
                              children:<Widget>[
                                // Icon(LineIcons.clock_o,size: 20,color: Colors.grey,),
                                Text("Cantidad: ${h.cantidad}",
                                  style: style,
                                )
                              ]),
                            Text("Estatus: ${h.status==0?'Disponible':'Ocupado'}",
                              overflow: TextOverflow.ellipsis,
                              style: style,),
                             Text("Código: ${h.codigo}",
                              overflow: TextOverflow.ellipsis,
                              style: style,),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ),
        ) ,

      );
  }


   _icon(){
    //if(widget.tarea==AppConfig.taskType1){
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Icon(
              Icons.brightness_1,
              size:_responsive.ip(5), color:Colors.blue[300]),
          SvgPicture.asset('assets/icons/tools_icon.svg',color:Colors.white,height: _responsive.ip(3),)
          // new Icon(
          //   LineIcons.calendar_check_o,
          //   size: _responsive.ip(3),
          //   color: Colors.white,
          // ),
        ],);
    //}
   }


    _insumoElement(dynamic d){
    Insumo i = d as Insumo;
    TextStyle style = TextStyle(fontFamily: AppConfig.quicksand,
      color: MyColors.GreyIcon,fontWeight: FontWeight.w600
    );
    return  new Container(
        margin: EdgeInsets.only(top:10,bottom:5),
        child:Card(
          elevation: 2,
                  child: Column(  
            children:<Widget>[
              Container(
                padding: EdgeInsets.all(4),
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Container(
                      width: 5,
                      height: _responsive.ip(8),
                      color: Colors.blue,
                    ),
                    _insumoIcon(),
                    Flexible(
                      child: Container(
                        margin: EdgeInsets.only(left:20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:<Widget>[
                            Text("Insumo: ${i.nombre}",
                              overflow: TextOverflow.ellipsis,
                              style: style,),
                            SizedBox(height:5),
                            Row(
                              children:<Widget>[
                                // Icon(LineIcons.clock_o,size: 20,color: Colors.grey,),
                                Text("Cantidad: ${i.cantidad}",
                                  style: style,
                                )
                              ]),
                            Text("Tipo: ${i.tipo}",
                              overflow: TextOverflow.ellipsis,
                              style: style,),
                             Text("Código: ${i.codigo}",
                              overflow: TextOverflow.ellipsis,
                              style: style,),
                        ]),
                      ),
                    ),
                  ],
                ),
              ),
            ]
          ),
        ) ,

      );
  }

  _insumoIcon(){
    //if(widget.tarea==AppConfig.taskType1){
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Icon(
              Icons.brightness_1,
              size:_responsive.ip(5), color:Colors.orange[400]),
          SvgPicture.asset('assets/icons/bottle_icon.svg',color:Colors.white,height: _responsive.ip(3),)
          // new Icon(
          //   LineIcons.calendar_check_o,
          //   size: _responsive.ip(3),
          //   color: Colors.white,
          // ),
        ],);
    //}
   }

}