import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:latlong/latlong.dart';
import 'package:line_icons/line_icons.dart';


class SolarWidget extends StatefulWidget {
  final Solar solar;

  const SolarWidget({Key key, this.solar}) : super(key: key);

 
  @override
  _SolarWidgetState createState() => _SolarWidgetState();
}

class _SolarWidgetState extends State<SolarWidget> {
  MapController  map;
  TextStyle _style,_styleSub;
  Responsive _responsive;
  @override
  void initState() {
    map = new MapController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _responsive = Responsive.of(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    _style = TextStyle(color:Colors.black,fontFamily: AppConfig.quicksand,fontSize: _responsive.ip(2.2));
    _styleSub = TextStyle(color:Colors.black,fontFamily: AppConfig.quicksand,fontSize:_responsive.ip(1.5));
    return GestureDetector(
      onTap: ()=>Navigator.pushNamed(context, 'details_solar',arguments: widget.solar),
          child: Container(
        margin: EdgeInsets.only(top:4,bottom:4),
        height: _responsive.ip(27),
        width: double.infinity,
        child:Card(
          // color: miTema.accentColor.withOpacity(0.2),
          child: Column(
            children:<Widget>[
             
              _createFlutterMap(widget.solar.latitud, widget.solar.longitud),
              //  Container(
              //   height:4,
              //   width:double.infinity,
              //   color:miTema.accentColor.withOpacity(.5),
              // ),
              Container(
                padding: EdgeInsets.all(4),
                width: double.infinity,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children:<Widget>[
                    Text('${widget.solar.nombre } - ${widget.solar.region}',style: _style,),
                    Text('${widget.solar.region} , ${widget.solar.municipio}',style: _styleSub,)
                  ]
                ),
              ),
              // ListTile(
              //   dense: false,
              //   title: Text('${widget.solar.nombre } - ${widget.solar.region}',style: _style,),
              //   subtitle: Text('${widget.solar.region} , ${widget.solar.municipio}',style: _style,),
              //   //onTap: ()=>Navigator.pushNamed(context, 'producto',arguments: producto),
              //   ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.end,
              //   children:<Widget>[
              //     Icon(LineIcons.trash_o,color: MyColors.GreyIcon,)
              //   ]
              // ),
              
            ]
          )
        ) 
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