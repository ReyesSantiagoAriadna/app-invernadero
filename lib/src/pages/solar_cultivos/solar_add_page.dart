import 'dart:ui';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/map_widget.dart';
import 'package:app_invernadero_trabajador/src/searchs/mapbox_search.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialog_select.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:latlong/latlong.dart';


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


    if(solarCultivoBloc.region==null)
    solarCultivoBloc.changeRegion("Costa");

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
    //  solarCultivoBloc.dispose();
    // solarCultivoBloc.changeSolarNombre("******");
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                        borderSide: BorderSide(color:miTema.accentColor)),
              icon: Icon(LineIcons.sun_o),
              labelText: 'Nombre',
              
              errorText: snapshot.error,
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
                          errorText: snapshot.error
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
                          errorText: snapshot.error
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
  _region(){
  return Column(
    children: <Widget>[
     Row(
              children: <Widget>[
                //SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                Icon(LineIcons.globe,color: MyColors.GreyIcon,),
                SizedBox(width:15),
                
                Text("Región",style: _style,),
              ],
            ),
            SizedBox(height:_responsive.ip(2)),
            GestureDetector(
              onTap: (){
                showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogSelect();
                });
              },
              child: StreamBuilder(
                stream: solarCultivoBloc.regionStream ,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    return Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 1,
                        color: MyColors.GreyIcon)  
                      
                      ),
                      margin: EdgeInsets.only(left:40),
                      child: Text(
                      snapshot.data,style:_secundaryStyle,
                  ),
                    );
                  }
                },
              ),
            ),
  ],);
  }

  
  
  _distrito(){
  return Column(
    children: <Widget>[
     Row(
              children: <Widget>[
                //SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                Icon(LineIcons.globe,color: MyColors.GreyIcon,),
                SizedBox(width:15),
                
                Text("Distrito",style: _style,),
              ],
            ),
            SizedBox(height:_responsive.ip(2)),
            GestureDetector(
              onTap: (){
                showDialog(
                context: context,
                builder: (BuildContext context) {
                  return AlertDialogSelect();
                });
              },
              child: StreamBuilder(
                stream: solarCultivoBloc.regionStream ,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    return Container(
                      padding: const EdgeInsets.all(10.0),
                      decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(
                        width: 1,
                        color: MyColors.GreyIcon)  
                      
                      ),
                      margin: EdgeInsets.only(left:40),
                      child: Text(
                      snapshot.data,style:_secundaryStyle,
                  ),
                    );
                  }
                },
              ),
            ),
  ],);
}

  
_municipio(){
  return Container(
     margin: EdgeInsets.only(left:40),
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
       Row(
                children: <Widget>[
                  //SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                  Icon(LineIcons.globe,color: MyColors.GreyIcon,),
                  SizedBox(width:15),
                  
                  Text("Municipio",style: _style,),
                ],
              ),
              SizedBox(height:_responsive.ip(2)),
              GestureDetector(
                onTap: (){
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return AlertDialogSelect();
                  });
                },
                child: StreamBuilder(
                  stream: solarCultivoBloc.regionStream ,
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.hasData){
                      return Container(
                        padding: const EdgeInsets.all(10.0),
                        decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(5),
                        border: Border.all(
                          width: 1,
                          color: MyColors.GreyIcon)  
                        
                        ),
                       
                        child: Text(
                        snapshot.data,style:_secundaryStyle,
                    ),
                      );
                    }
                  },
                ),
              ),
    ],),
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
                        errorText: snapshot.error
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
  _location(){
    return Container(
      //margin: EdgeInsets.all(8),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(LineIcons.map_marker,color: MyColors.GreyIcon,),
              SizedBox(width:18),
              Text("Ubicación",style: _style,),
            ],
            ),
           SizedBox(height:_responsive.ip(2)),
          _findLocation(),
          _createFlutterMap(0,0)
        ],
      ),
    );
  }
   _createFlutterMap(double lat,double long) {
      
    var mapa =   FlutterMap(
     // mapController: map,
      options: MapOptions(
        
        center: new LatLng(lat,long),
        zoom: 15,
       
      ),
      
      layers: [
        _createMap(),
        _createMarkers(lat,long),
      ],
    );

      if (map.ready) {
    map.move(LatLng(lat,long) , 15);
    }
    

    return Container(
      height: _responsive.ip(18),
      width: double.infinity,
      child: mapa);
  }
  _createMap() {
     return TileLayerOptions(
      urlTemplate:  'https://api.mapbox.com/styles/v1/{id}/tiles/{z}/{x}/{y}?access_token={accessToken}',
      additionalOptions: {
        'accessToken':  AppConfig.mapbox_api_token, 
        'id': 'mapbox/streets-v11' 
        //streets, dark, light, outdoors, satellite
      }
    );
  }

  _createMarkers(double lat,double long) {
    return MarkerLayerOptions(
      markers: <Marker>[
        Marker(
          width: 100.0,
          height: 100.0,
          point:  new LatLng(lat,long),
          builder: (context)=>Container(
            child:Icon(
              Icons.location_on,
              size:45.0,
              color:Theme.of(context).primaryColor
              )
          )
        ),
      ]
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
  _addSolar(){
    Flushbar(
      message:  "Agregado correctamente",
      duration:  Duration(seconds: 2),              
    )..show(context).then((r){
      Navigator.pop(context);
    });
  }

}

