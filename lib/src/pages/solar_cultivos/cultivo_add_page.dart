import 'dart:ui';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/map_box_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/regiones.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/map_widget.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/sensores_widget.dart';
import 'package:app_invernadero_trabajador/src/searchs/mapbox_search.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialog_select.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_cultivo_tipo.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_distrito.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_mun.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_region.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:latlong/latlong.dart';
import 'package:provider/provider.dart';

import 'package:intl/intl.dart';
class CultivoAddPage extends StatefulWidget {
  CultivoAddPage({Key key}) : super(key: key);

  @override
  _CultivoAddPageState createState() => _CultivoAddPageState();
}

class _CultivoAddPageState extends State<CultivoAddPage> {
  Responsive _responsive;
  SolarCultivoBloc solarCultivoBloc;
  TextStyle _style;
  TextStyle _secundaryStyle;
  bool _isLoading=false;
  TextEditingController _inputDateController = new TextEditingController();
  @override
  void initState() {
    solarCultivoBloc = SolarCultivoBloc();
    solarCultivoBloc.onChangeSensores(false);
    solarCultivoBloc.onChangeStage(false);
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _responsive = Responsive.of(context);
   
 
  
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
    solarCultivoBloc.reset();
    solarCultivoBloc.resetCultivo();
    //  solarCultivoBloc.dispose();
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
            title:Text("Nuevo Cultivo",style:TextStyle(color: MyColors.GreyIcon,
              fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w800
            )),
            leading: IconButton(
              icon: Icon(LineIcons.angle_left,color:MyColors.GreyIcon), 
              onPressed:()=> Navigator.pop(context)),
            actions: <Widget>[
              // IconButton(
              //   icon: Icon(LineIcons.save,color: MyColors.GreyIcon,), onPressed: ()=>_addSolar())
              _createButton()
            ],
          ),
          body:GestureDetector(
            onTap: ()=>FocusScope.of(context).unfocus(),
            child: _body()
          ),
          floatingActionButton: FloatingActionButton(
            onPressed: () {
              Navigator.pushNamed(context, 'cultivo_etapas');
            },
            child: Icon(LineIcons.plus),
          backgroundColor: miTema.accentColor,
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
      // color: Colors.red,
      margin: EdgeInsets.only(left:8,right:12,top: 10),
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Información del Cultivo",style: TextStyle(
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
            _inputTipo(),
            SizedBox(height:_responsive.ip(2)),
            _inputNombre(), 
            SizedBox(height:_responsive.ip(2)),
            _medidas(),
            SizedBox(height:_responsive.ip(2)),
            _observacion(),
            SizedBox(height:_responsive.ip(2)),
            _fechas(),
            SizedBox(height:_responsive.ip(2)),
            CultivoSensores(solarCultivoBloc:solarCultivoBloc,responsive: _responsive,),
            // Row(
            //   children:<Widget>[
            //     _region(),
            //     _distrito(),
            //   ]
            // ),
            // SizedBox(height:_responsive.ip(2)),
            // _municipio(),

          ],
        )
      ),
    );
  }

  _inputTipo(){
     return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
              SvgPicture.asset('assets/icons/seelding_icon.svg',color:MyColors.GreyIcon,height: 20,),
              SizedBox(width:18),
              Text("Tipo",style: _style,),
              ],
            ),
          SizedBox(height:10),
          StreamBuilder(
              stream: solarCultivoBloc.tipoCultivoStream ,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return GestureDetector(
                  onTap: (){
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogListTipoCultivo(solarCultivoBloc: solarCultivoBloc,);
                    });
                  },
                  child:snapshot.hasData?
                  _select(snapshot.data):
                  _select("Elije el tipo"),
                );
              },
            ),
        ]
      ),
    );
  }
 
  _inputNombre(){
    return StreamBuilder(
        stream: solarCultivoBloc.solarNombreStream ,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return  TextFormField(
            decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                        borderSide: BorderSide(color:miTema.accentColor)),
              icon: Icon(LineIcons.sun_o,color: Colors.white),
              labelText: 'Nombre', 
              errorText: snapshot.error =='*' ? null:snapshot.error,
            ),
            onChanged: solarCultivoBloc.changeSolarNombre,
            
          );
          }
      );
  }
  
  _medidas(){
    return Container(
      
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget>[
          Row(
              children: <Widget>[
                SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                SizedBox(width:18),
                Text("Medidas",style: _style,),
              ],
            ),
            Container(
               margin: EdgeInsets.only(left:40),
              // width:_responsive.wp(30),
              child:StreamBuilder (
                stream: solarCultivoBloc.cultivoLargoStream,
                builder: (BuildContext context,snapshot){
                  return TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                    focusedBorder:  UnderlineInputBorder(      
                          borderSide: BorderSide(color:miTema.accentColor)),
                    labelText: 'Largo en metros',
                    errorText: snapshot.error =='*' ? null:snapshot.error,
                    ),
                    onChanged: solarCultivoBloc.changeCultivoLargo,
                    );
                },
                
              ),
            ),
            // Text("m",style: _style,),
            SizedBox(width:5),
            Container(
                margin: EdgeInsets.only(left:40),
              // width:_responsive.wp(30),
              child:StreamBuilder<Object>(
                stream: solarCultivoBloc.cultivoAnchoStream,
                builder: (context, snapshot) {
                  return TextFormField(
                    keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      
                    focusedBorder:  UnderlineInputBorder(      
                            borderSide: BorderSide(color:miTema.accentColor)),
                    labelText: 'Ancho en metros',
                    errorText: snapshot.error =='*' ? null:snapshot.error,
            ),
            onChanged: solarCultivoBloc.changeCultivoAncho,
            );
                }
              ),
            ),
            // Text("m",style: _style,),
        ]
      )
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
                Text("Observación",style: _style,),
              ],
            ),
           SizedBox(height:_responsive.ip(2)),
          Container(
            margin: EdgeInsets.only(left:40),
            padding: EdgeInsets.all(8),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(5),
            //   border: Border.all(
            //     width: 1,
            //     color: MyColors.GreyIcon)  
            //   ),
            child: StreamBuilder<Object>(
              stream: solarCultivoBloc.solarDescripStream,
              builder: (context, snapshot) {
                return TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                   hintText: "Ingresa la observación..",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:MyColors.GreyIcon),
                    ),
                         focusedBorder:  OutlineInputBorder(      
                              borderSide: BorderSide(color:miTema.accentColor)),
                        //labelText: 'Largo'
                      errorText: snapshot.error =='*' ? null:snapshot.error,
                      ),
                  // decoration: InputDecoration.collapsed(
                    onChanged: solarCultivoBloc.changeSolarDescrip,
                   
                );
              }
            ),
          )
        ]
      ),
    );
  }

   _select(String data){
    return Container(
      height: 40,
      margin: EdgeInsets.only(left:40,right:10),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        width: 1,
        color: MyColors.GreyIcon)  
      ),
      child: Row(
        children:<Widget>[
         Text(data,style: TextStyle(color:MyColors.GreyIcon,fontFamily: AppConfig.quicksand,
          fontSize: _responsive.ip(1.5),fontWeight: FontWeight.w700
        ),),
        Expanded(child:Container()),
        Icon(Icons.expand_more,color: MyColors.GreyIcon,)
        ]
      )
    );
  }

  _fechas(){
    return Row(
      children: <Widget>[
        _fecha(solarCultivoBloc.fechaInicioStream, "Fecha de Inicio",
         solarCultivoBloc.onChangeFechaInicio,1),
        SizedBox(width:5),
        _fecha(solarCultivoBloc.fechaTerminacionStream, "Fecha de Terminación"
        , solarCultivoBloc.onChangeFechaTerminacion,2)

      ],
    );
  }
  _fecha(Stream stream,String title,Function(String) onChange,int tipo){
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return GestureDetector(
          onTap: (){
            print("tapp=>>");
            if(tipo==1)
              _selectDate(context,onChange,null);
            else if(tipo==2){
              if(solarCultivoBloc.fechaInicio!=null){
                _selectDate(context, onChange, solarCultivoBloc.fechaInicio);
              }
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(LineIcons.calendar,color: MyColors.GreyIcon,),
                  Container(
                    width: 90, 
                    margin: EdgeInsets.only(left:20),
                    child: Text(title,style: _style, overflow: TextOverflow.clip,)),
                    
                 
                ],
              ),
              SizedBox(height:5),
               Container(
                margin: EdgeInsets.only(left:45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start, 
                  children: <Widget>[
                    Text(
                      snapshot.hasData? "${snapshot.data}": "",
                    ),
                    SizedBox(height:5),
                    Container(
                      height:1,
                       width:100,
                      color:Colors.grey
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );

    
  }
  
  _selectDate(BuildContext context,Function(String) onChange,String firstDate) async{
     DateTime parsedDate;
    if(firstDate!=null)
    parsedDate = DateTime.parse(firstDate);
      new DateFormat("yyyy-MM-dd");
       DateTime picked = await showDatePicker(
        context: context, 
        initialDate: new DateTime.now(), 
        firstDate:  parsedDate !=null?parsedDate: new DateTime(2020), 
        lastDate: new DateTime(2021), 
        locale: Locale('es'),
      );

      if(picked != null){
          String _fecha;
          var formatter = new DateFormat("yyyy-MM-dd");
          _fecha = formatter.format(picked);
          // solarCultivoBloc.onChangeFechaIncio(_fecha);
          onChange(_fecha);
      }
  }
  _createButton(){
    return StreamBuilder(
      initialData: solarCultivoBloc.sensores,
      stream: solarCultivoBloc.sensoresStream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        bool res = snapshot.data;
        print("switch valueee $res");
        return StreamBuilder( 
          stream: res?
            solarCultivoBloc.formAddCultivoWitSensoresValidStream
            :
            solarCultivoBloc.formAddCultivoValidStream, 
          builder: (BuildContext context, AsyncSnapshot snapshot){
          return IconButton(
          icon: Icon(LineIcons.save,color: MyColors.GreyIcon,), 
          onPressed: snapshot.hasData?()=>_addCultivo():null
          );
      },
      );
      },
    );
  }

  // 
  _addCultivo()async{
    if(_isLoading)return;
    
    setState(() {
      _isLoading=true;
    });
    bool sensores = solarCultivoBloc.sensores;
    bool etapas = solarCultivoBloc.stage;
    Cultivo cultivo = Cultivo(
      idFksolar: solarCultivoBloc.solar.id,
      tipo: solarCultivoBloc.cultivoTipo,
      nombre:solarCultivoBloc.solarNombre,
      largo: double.parse(solarCultivoBloc.cultivoLargo),
      ancho: double.parse(solarCultivoBloc.cultivoAncho),
      fecha: DateTime.parse(solarCultivoBloc.fechaInicio),
      fechaFinal: DateTime.parse(solarCultivoBloc.fechaTerminacion),
      observacion: solarCultivoBloc.solarDescrip,
      moniSensor: sensores ? 1:0,
      tempMin:sensores?int.parse(solarCultivoBloc.tempMin):0,
      tempMax:sensores?int.parse(solarCultivoBloc.tempMax):0,
      humeMin:sensores?int.parse(solarCultivoBloc.humMin):0,
      humeMax:sensores?int.parse(solarCultivoBloc.humMax):0,
      humeSMin:sensores?int.parse(solarCultivoBloc.humSMin):0, 
      humeSMax:sensores?int.parse(solarCultivoBloc.humSMax):0, 
      etapas: etapas? solarCultivoBloc.listEtapas:[]
    );

    
    
   
    await Provider.of<SolarCultivoService>(context,listen: false)
      .addCultivo(cultivo,etapas?1:0);


    setState(() {
      _isLoading=true;
    });     
    
    Flushbar(
      message:  Provider.of<SolarCultivoService>(context,listen: false).response,
      duration:  Duration(seconds: 2),              
    )..show(context).then((r){
      Navigator.pop(context);
    });
     
  }
}

