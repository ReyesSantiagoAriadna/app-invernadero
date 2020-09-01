import 'dart:ui';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/map_box_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/regiones.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/map_widget.dart';
import 'package:app_invernadero_trabajador/src/searchs/mapbox_search.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialog_select.dart';
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


class SolarAddPage extends StatefulWidget {
  SolarAddPage({Key key}) : super(key: key);

  @override
  _SolarAddPageState createState() => _SolarAddPageState();
}

class _SolarAddPageState extends State<SolarAddPage> {
  Responsive _responsive;
  SolarCultivoBloc solarCultivoBloc;
  TextStyle _style;
  TextStyle _secundaryStyle;
  MapController  map;
  final _nombre = TextEditingController();
  bool _isLoading=false;
  @override
  void initState() {
    map = new MapController();

    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _responsive = Responsive.of(context);
    solarCultivoBloc = SolarCultivoBloc();
 

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
    print("cerrando...");
     solarCultivoBloc.reset();
    solarCultivoBloc.dispose();
   
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
            title:Text("Nuevo Solar",style:TextStyle(color: MyColors.GreyIcon,
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
            Text("Información del Solar",style: TextStyle(
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
            _inputNombre(), 
            SizedBox(height:_responsive.ip(2)),
            _medidas(),
            SizedBox(height:_responsive.ip(2)),
            _description(),
            SizedBox(height:_responsive.ip(2)),
            _region(),
            SizedBox(height:_responsive.ip(2)),
            _distrito(),            
            SizedBox(height:_responsive.ip(2)),
            _municipio(),
            MapWidget(responsive: _responsive,),
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

  _inputNombre(){
    return StreamBuilder(
        stream: solarCultivoBloc.solarNombreStream ,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return  TextFormField(
             controller: _nombre,
            decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                        borderSide: BorderSide(color:miTema.accentColor)),
              icon: Icon(LineIcons.sun_o),
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
        children:<Widget>[
          Row(
              children: <Widget>[
                SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                SizedBox(width:18),
                Text("Medidas",style: _style,),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left:35),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:<Widget>[
                  Container(
                    width:_responsive.wp(30),
                    child:StreamBuilder (
                      stream: solarCultivoBloc.solarLargoStream,
                      builder: (BuildContext context,snapshot){
                        return TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                          focusedBorder:  UnderlineInputBorder(      
                                borderSide: BorderSide(color:miTema.accentColor)),
                          labelText: 'Largo',
                          errorText: snapshot.error =='*' ? null:snapshot.error,
                          ),
                          onChanged: solarCultivoBloc.changeSolarLargo,
                          );
                      },
                      
                    ),
                  ),
                  Text("m",style: _style,),
                  SizedBox(width:5),
                   Container(
                    width:_responsive.wp(30),
                    child:StreamBuilder<Object>(
                      stream: solarCultivoBloc.solarAnchoStream,
                      builder: (context, snapshot) {
                        return TextFormField(
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            
                          focusedBorder:  UnderlineInputBorder(      
                                  borderSide: BorderSide(color:miTema.accentColor)),
                          labelText: 'Ancho',
                          errorText: snapshot.error =='*' ? null:snapshot.error,
                  ),
                  onChanged: solarCultivoBloc.changeSolarAncho,
                  );
                      }
                    ),
                  ),
                  Text("m",style: _style,),
                ]
              ),
            ),
        ]
      )
    );
  }

  
  _description(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
               // SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                Icon(LineIcons.clipboard,color: MyColors.GreyIcon,),
                SizedBox(width:18),
                Text("Descripción",style: _style,),
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
                   hintText: "Ingresa una descripción..",
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

  _findLocation(){
    return GestureDetector(
      onTap: ()=>showSearch(
        context: context, delegate: PlacesSearch()),
        child: Container(
          width: _responsive.widht,
          height: _responsive.ip(10),
          child: Center(
            child: Container(
              height: _responsive.ip(5),
              width: _responsive.wp(90),
              decoration: BoxDecoration(
                color: miTema.accentColor.withOpacity(0.2),
                borderRadius:BorderRadius.circular(15)
              ),
              child:Row(children: <Widget>[
                  IconButton(
                  icon:Icon(LineIcons.search,color:Colors.grey), 
                  onPressed:()=>showSearch(
                  context: context, delegate: PlacesSearch()),),
                Expanded(child: Container(
                  child: Text(
                    "Buscar",
                    style: TextStyle(
                      color:Colors.grey,
                      fontFamily: 'Quicksand',
                      fontWeight: FontWeight.w900
                      ),
                      ),
                )),
                Expanded(child: Container()),
              ],)
          ),
        ),
      ),
    );
  }

  
  _region(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
                Icon(LineIcons.globe,color: MyColors.GreyIcon,),
                SizedBox(width:18),
                Text("Región",style: _style,),
              ],
            ),
          SizedBox(height:5),
          StreamBuilder(
              stream: solarCultivoBloc.regionActiveStream ,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                Region region = snapshot.data;
                return GestureDetector(
                  onTap: (){
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogListRegion(solarCultivoBloc: solarCultivoBloc,);
                    });
                  },
                  child:snapshot.hasData?
                  _select(region.region):
                  _select("Elije la región"),
                );
              },
            ),
        ]
      ),
    );
  }

   _distrito(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
                Icon(LineIcons.globe,color: Colors.white,),
                SizedBox(width:18),
                Text("Distrito",style: _style,),
              ],
            ),
          SizedBox(height:5),
          StreamBuilder(
            stream: solarCultivoBloc.distritoActiveStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
             
              return GestureDetector(
                onTap: snapshot.hasData ? () {
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogListDistrito(solarCultivoBloc: solarCultivoBloc,);
                  });
                }:null,
                child:snapshot.hasData?
                 _select(snapshot.data.distrito):
                 _select("Elije el distrito"),
              );
            },
          ),
        ]
      ),
    );
  }

  _municipio(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
                Icon(LineIcons.globe,color: Colors.white,),
                SizedBox(width:18),
                Text("Municipio",style: _style,),
              ],
            ),
          SizedBox(height:5),
          StreamBuilder(
            stream: solarCultivoBloc.municipioActiveStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return GestureDetector(
                onTap:snapshot.hasData? (){
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogListMunicipio(solarCultivoBloc: solarCultivoBloc,);
                  });
                }
                :
                null,
                child:snapshot.hasData?
                 _select(snapshot.data):
                 _select("Elije el distrito"),
              );
            },
          ),
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

  _createButton(){
    return StreamBuilder(
      stream: solarCultivoBloc.formValidStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
          return IconButton(
          icon: Icon(LineIcons.save,color: MyColors.GreyIcon,), 
          onPressed: snapshot.hasData?()=>_addSolar():null
          );
      },
    );
  }
  _addSolar()async{
    
    MapBoxBloc mapBoxBloc = MapBoxBloc();
    if(mapBoxBloc.position==null)
      return;
    
    if(_isLoading)return;
    
    setState(() {
      _isLoading=true;
    });
      
    Solar solar= Solar(
      nombre: solarCultivoBloc.solarNombre,
      largo: double.parse(solarCultivoBloc.solarLargo),
      ancho: double.parse(solarCultivoBloc.solarAncho),
      descripcion: solarCultivoBloc.solarDescrip,
      region: solarCultivoBloc.regionActive.region,
      distrito: solarCultivoBloc.distritoActive.distrito,
      municipio: solarCultivoBloc.municipioActive,
      latitud:mapBoxBloc.position.latitude,
      longitud: mapBoxBloc.position.longitude,
    );
    
    // print("Solar data ${solar.nombre}");
    // setState(() {
    //   _isLoading=false;
    // });
    await Provider.of<SolarCultivoService>(context,listen: false)
      .addSolar(solar);
      // .then((r){ 
        setState(() {
          _isLoading=true;
        });     
    Flushbar(
      message:  Provider.of<SolarCultivoService>(context,listen: false).response,
      duration:  Duration(seconds: 2),              
    )..show(context).then((r){
      Navigator.pop(context);
    });
    // });
  }




}

