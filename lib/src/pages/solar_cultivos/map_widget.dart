import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/map_box_bloc.dart';
import 'package:app_invernadero_trabajador/src/searchs/mapbox_search.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_icons/line_icons.dart';
import 'package:latlong/latlong.dart';


class MapWidget extends StatefulWidget {
  final Responsive responsive;

  const MapWidget({Key key, this.responsive}) : super(key: key);
  @override
  _MapWidgetState createState() => _MapWidgetState();
}

class _MapWidgetState extends State<MapWidget> {

  MapController map;
  
  TextStyle _style;
  MapBoxBloc mapBoxBloc;

  @override
  void initState() {
     map= new MapController();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    mapBoxBloc = MapBoxBloc();
    
    Position position = Position(latitude: 17.06542,longitude: -96.72365);
    
    mapBoxBloc.changePosition(position);
    _style = TextStyle(
      color: MyColors.GreyIcon,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: widget.responsive.ip(1.8)
    );
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return _location();
  }

   _findLocation(){
    return GestureDetector(
      onTap: ()=>showSearch(
        context: context, delegate: PlacesSearch()),
        child: Container(
          width: widget.responsive.widht,
          height: widget.responsive.ip(10),
          child: Center(
            child: Container(
              height: widget.responsive.ip(5),
              width: widget.responsive.wp(90),
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
      // margin: EdgeInsets.all(8),

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
           SizedBox(height:widget.responsive.ip(2)),
          _findLocation(),
          StreamBuilder(
            stream: mapBoxBloc.positionStream,
            initialData: mapBoxBloc.position,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                Position p = snapshot.data;
                return  _createFlutterMap(p.latitude,p.longitude);
              }  
              return  _createFlutterMap(17.06542, -96.72365);            
            },
          ),
        ],
      ),
    );
  }

   _createFlutterMap(double lat,double long) {
      
    var mapa =   FlutterMap(
      mapController: map,
      options: MapOptions(
        
        center: new LatLng(lat,long),
        zoom: 15,
       
      ),
      
      layers: [
        _createMap(),
        _createMarkers(lat,long),
      ],
    );
  
      // if (map.ready) {
    // }  
    // LatLng latlng = LatLng(lat,long);
    //           map.move(latlng , 15);

      map.onReady.then((result) {
        map.move(LatLng(lat,long), 18.0);
       
      });
      
    return Container(
      margin: EdgeInsets.only(left:8,right: 8),
      height: widget.responsive.ip(25),
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