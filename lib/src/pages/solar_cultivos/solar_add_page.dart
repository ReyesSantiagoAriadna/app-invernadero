import 'dart:ui';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialog_select.dart';
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
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title:Text("Nuevo Solar",style:TextStyle(color: MyColors.GreyIcon)),
        leading: IconButton(
          icon: Icon(LineIcons.angle_left,color:MyColors.GreyIcon), 
          onPressed:()=> Navigator.pop(context)),
      ),
      body: _body(),
    );
  }

  _body(){
    

    return Container(
      // color: Colors.red,
      margin: EdgeInsets.only(left:10,right:10,top: 10),
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Text("Información del Solar",style: TextStyle(
              fontFamily:AppConfig.quicksand,fontWeight: FontWeight.w700,
              color: MyColors.GreyIcon,fontSize: _responsive.ip(1.8)
            ),),
            SizedBox(height:2),
            Container(
              width: double.infinity,
              height: 2,
              color: Colors.grey[300],
            ),
            SizedBox(height:5),
            TextFormField(
              
              decoration: InputDecoration(
                 focusedBorder:  UnderlineInputBorder(      
                          borderSide: BorderSide(color:miTema.accentColor)),
                icon: Icon(LineIcons.sun_o),
                labelText: 'Nombre'
              ),
            ),
            SizedBox(height:_responsive.ip(2)),
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
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:<Widget>[
                  Container(
                    width:_responsive.wp(35),
                    child:TextFormField(
                       keyboardType: TextInputType.number,
                  decoration: InputDecoration(
                     focusedBorder:  UnderlineInputBorder(      
                          borderSide: BorderSide(color:miTema.accentColor)),
                    labelText: 'Largo'
                  ),
                  ),
                  ),
                  SizedBox(width:5),
                   Container(
                    width:_responsive.wp(35),
                    child:TextFormField(
                       keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      
                     focusedBorder:  UnderlineInputBorder(      
                          borderSide: BorderSide(color:miTema.accentColor)),
          // enabledBorder: UnderlineInputBorder(      
          //                 borderSide: BorderSide(color:Color(0xffdddddd)),),
                    labelText: 'Ancho',
                  ),
                  ),
                  )
                ]
              ),
            ),
            SizedBox(height:_responsive.ip(2)),
            _description(),
            SizedBox(height:_responsive.ip(2)),

            
            _createFlutterMap(17.06542, -96.72365),

            Row(
              children:<Widget>[
                _region(),
                _distrito(),
              ]
            ),
            SizedBox(height:_responsive.ip(2)),
            _municipio(),

          ],
        )
      ),
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
            child: TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
               hintText: "Ingresa una descripción..",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:MyColors.GreyIcon),
                ),
                     focusedBorder:  OutlineInputBorder(      
                          borderSide: BorderSide(color:miTema.accentColor)),
                    //labelText: 'Largo'
                  ),
              // decoration: InputDecoration.collapsed(

               
            ),
          )
        ]
      ),
    );
  }
  _location(){
    return Container(
      margin: EdgeInsets.all(8),
      child: Column(
        children: <Widget>[
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
}
