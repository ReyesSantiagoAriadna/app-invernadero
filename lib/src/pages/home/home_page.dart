import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/map_box_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/page_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/task/task_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/models/weather/weather_bit.dart';
import 'package:app_invernadero_trabajador/src/models/weather/weather_model.dart';
import 'package:app_invernadero_trabajador/src/pages/menu_page.dart';
import 'package:app_invernadero_trabajador/src/pages/pedidos/pedidos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/task/calendar.dart';
import 'package:app_invernadero_trabajador/src/pages/zoom_scafold.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_cultivo.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_solar.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_icons/line_icons.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  MenuController menuController;
  SecureStorage _prefs = SecureStorage(); 
  MapBoxBloc mapBoxBloc = MapBoxBloc();
  Responsive _responsive;
  SolarCultivoBloc solarBloc = SolarCultivoBloc();
  TaskBloc taskBloc = TaskBloc();
  PageBloc _pageBloc;
  TextStyle _titleStyle;
  TextStyle _subtitleStyle ;

  @override
  void initState() {
    super.initState();
    _titleStyle = TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w600);
    _subtitleStyle =  TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w700);

  //   SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
  //   FeatureDiscovery.discoverFeatures(
  //     context,
  //     const <String>{ // Feature ids for every feature that you want to showcase in order.
  //       'solar_select_feature_id',
  //       'cultivo_select_feature_id',
  //     },
  //   ); 
  // });


    _pageBloc = PageBloc();


    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    _responsive = Responsive.of(context);
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: Colors.white,
      body: _body(),
    );
     
  }

  _body(){
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: EdgeInsets.all(10),
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        controller: _pageBloc.scrollCont,
              child: Column(
          children: <Widget>[
            _weatherBit(),

            SizedBox(height:20),
            _solarInf(),
            SizedBox(height:10),
            _cultivoInf(),
            SizedBox(height:10),
            _cultivo(),
            SizedBox(height:10),
            _dashBoard(),

            // MyCalendar(),


          ],
        ),
      ),
    );
  }
  _cultivo(){
    TextStyle _style = TextStyle(
      color: Colors.black54,
      fontWeight: FontWeight.w700,
      fontFamily: AppConfig.quicksand
    );
    return Container(
      child:StreamBuilder(
        stream: solarBloc.cultivoHomeStream,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(!snapshot.hasData){
            return Container(
              width: double.infinity,
              height: 150,
              decoration: BoxDecoration(
                color: Colors.grey[300],
                borderRadius: BorderRadius.circular(15)
              ),
            );
          }
          Cultivo c = snapshot.data;
          return Container(
            width:double.infinity,
            // height:150,
            child: Column(children: <Widget>[
              Container(
                padding: EdgeInsets.all(8),
                width:double.infinity,
                // height: 20,
                decoration:BoxDecoration(
                  color:miTema.accentColor,
                  borderRadius: BorderRadius.circular(15)

                ),
                child: Center(
                  child:Text(
                    "Información del cultivo",
                    style: TextStyle(
                      color:Colors.white,
                      fontFamily:AppConfig.quicksand,
                      fontWeight:FontWeight.w700,
                      fontSize: _responsive.ip(1.8)
                    ),
                  )
                ),
              ),

              Row(children: <Widget>[
                Expanded(
                  child: Column(
                    children:<Widget>[
                      ListTile(
                        dense: true,
                        leading: Icon(LineIcons.indent),
                        title: Text("# ${c.id}",style: _style),
                      ),
                      ListTile(
                        dense: true,
                        leading: Icon(LineIcons.sun_o),
                        title: Text("Solar: ${c.idFksolar}",style: _style),
                      ),
                      ListTile(
                        dense: true,
                        leading: Icon(FontAwesomeIcons.rulerVertical),
                        title: Text("Medidas: ${c.largo}m x ${c.ancho}m",style: _style),
                      ),
                    ])),
                Expanded(
                  child: Column(
                    children:<Widget>[
                       ListTile(
                        dense: true,
                        leading: Icon(LineIcons.calendar_check_o),
                        title: Text("Del ${DateFormat('dd-MMM-yyyy').format(c.fecha)} al ${DateFormat('dd-MM-yyyy').format(c.fechaFinal)}",style: _style),
                      ),
                      ListTile(
                        dense: true,
                        leading: Icon(LineIcons.clipboard),
                        title: Text("Observación: ${c.observacion}",style: _style),
                      ),
                      ListTile(
                        dense: true,
                        leading: Icon(LineIcons.sitemap),
                        title: Text("Tipo: ${c.tipo}",style: _style),
                      ),

                    ])),

              ],)
            ],),
          );
        },
      ),
    );
  }

  _descripElement(IconData icon,String text){
    return Container(
      child: Row(
        children:<Widget>[
          Icon(icon,color: MyColors.GreyIcon,),
          Text(text),

        ]
      ),
    );
  }
  
  _solarInf(){
    
    return GestureDetector(
      onTap: (){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogListSolares(
              solarCultivoBloc: solarBloc,
              type: 1,
              );
        });
      },
          child: Container(
          width:double.infinity,
          height: 45,
          decoration: BoxDecoration(
            color:Colors.grey[200],
            borderRadius:BorderRadius.circular(10)
          ),
          child: Row(
            children:<Widget>[
              DescribedFeatureOverlay(
                featureId: 'solar_select_feature_id', // Unique id that identifies this overlay.
                tapTarget:   Icon(LineIcons.sun_o,color: MyColors.GreyIcon,), // The widget that will be displayed as the tap target.
                title: Text("Solar",style: _titleStyle),
                description: Text("Elije el solar para ver la información",
                  style: _subtitleStyle
                ),
                backgroundColor: MyColors.YellowDiscovery,// Theme.of(context).primaryColor,
                targetColor:Colors.white,
                textColor: Colors.grey[800],
                child:    IconButton(icon: Icon(LineIcons.sun_o,color:Colors.black54), 
                    onPressed:(){
                    })
              ),
             
              StreamBuilder(
                stream: solarBloc.solarHomeStream ,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  Solar s;
                  if(snapshot.hasData)
                    s=snapshot.data;
                  return Text(
                    snapshot.hasData?
                    s.nombre:"Solar",
                    style: TextStyle(
                      fontFamily:AppConfig.quicksand,
                      fontWeight:FontWeight.w700
                    ),
                  );
                },
              ),
            ]
          ),
        ),
    );
  }

  _cultivoInf(){
    return GestureDetector(
      onTap: (){
        showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogListCultivo(
              solarCultivoBloc: solarBloc,
              type: 1,
            );
        });
      },
          child: Container(
          width:double.infinity,
          height: 45,
          decoration: BoxDecoration(
            color:Colors.grey[200],
            borderRadius:BorderRadius.circular(10)
          ),
          child: Row(
            children:<Widget>[
              DescribedFeatureOverlay(
                featureId: 'cultivo_select_feature_id', // Unique id that identifies this overlay.
                tapTarget:  IconButton(icon:  SvgPicture.asset('assets/icons/seelding_icon.svg',color:Colors.black54,height: 20,) , 
                    onPressed:(){}), // The widget that will be displayed as the tap target.
                title: Text("Cultivo",style: _titleStyle),
                description: Text("Elije el cultivo para más información",
                  style: _subtitleStyle
                ),
                backgroundColor: MyColors.YellowDiscovery,// Theme.of(context).primaryColor,
                targetColor:Colors.white,
                textColor: Colors.grey[800],
                child:   IconButton(icon:  SvgPicture.asset('assets/icons/seelding_icon.svg',color:Colors.black54,height: 20,) , 
                    onPressed:(){}),
              ),

              StreamBuilder(
                stream: solarBloc.cultivoHomeStream ,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  Cultivo c;
                  if(snapshot.hasData)
                    c=snapshot.data;
                  return Text(
                    snapshot.hasData?
                    "${c.nombre} ":"Cultivo",
                    style: TextStyle(
                      fontFamily:AppConfig.quicksand,
                      fontWeight:FontWeight.w700
                    ),
                  );
                },
              ),
            ]
          ),
        ),
    );
  }
  _weatherBit(){
    return StreamBuilder(
      stream: mapBoxBloc.weatherBitStream ,
      initialData: mapBoxBloc.weatherBit,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(!snapshot.hasData)
          return Container(
            height: 150,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius : BorderRadius.circular(15)
            ),
          );
        WeatherBit weather;
         weather= snapshot.data;
        return _itemWeatherBit(weather);
      },
    );
  }
  _itemWeatherBit(WeatherBit clima){
    // if(clima!=null){
    //   final date = DateTime.parse(clima.data[0].datetime);
    //   taskBloc.onChangeDateNet(date);
    // }
    
    TextStyle _style =TextStyle(color:Colors.white,fontFamily: AppConfig.quicksand,
                  fontWeight: FontWeight.w700
                );
     return Container( 
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: miTema.accentColor,
        borderRadius : BorderRadius.circular(15)
      ),
      width: double.infinity,
      height: 160,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: <Widget>[
          Expanded(
                      child: Column(
              children:<Widget>[
                Text(clima==null?
                  "Oaxaca, MX":
                 "${clima.data[0].cityName}, ${clima.data[0].countryCode}",
                style: TextStyle(
                
                  fontSize: 20,
                  color:Colors.white,fontFamily:AppConfig.quicksand,fontWeight:FontWeight.w700),
                  overflow: TextOverflow.ellipsis,
                  ),
                SizedBox(height:5),
                Text(
                  clima==null?
                  "0.0 °C":
                  "${clima.data[0].temp} °C",style:  TextStyle(fontFamily:AppConfig.quicksand,fontSize:35,color:Colors.white),),
                SizedBox(height:5),
                Text(clima==null?"":"Sensación termica ${clima.data[0].appTemp} °C",style: _style,),
                SizedBox(height:5),
                Text(clima==null?"":"${clima.data[0].datetime}",style: _style,)

              
              ]
            ),
          ),
          Expanded(
                      child: Column(
              children:<Widget>[
                _icon(clima.data[0].weather.icon),
                 Text(clima==null?"":"${clima.data[0].weather.description}",
                  style: TextStyle(color:Colors.white,fontFamily: AppConfig.quicksand,
                    fontWeight: FontWeight.w700
                  ),),
              ]
            ),
          )
        ],
      ),  
    );
  }


  _icon(String icon){
    if(icon!=null){
      return  FadeInImage(
        placeholder: AssetImage('assets/images/placeholder.png'), 
        image: NetworkImage(AppConfig.weather_bit_url_icon+icon+".png"),
        fit : BoxFit.cover,
        height: _responsive.ip(10),
        );
    }
    return 
      Container(
        height:_responsive.ip(10),
        child:Image.asset('assets/images/placeholder.png')
      );
  }

  _tareasPorAsignar(){
    return GestureDetector(
      onTap: ()=> Navigator.pushNamed(context, 'calendar'),
          child: Container(
        padding: EdgeInsets.all(10),
        // width: 150,
        // height: 120,
        decoration: BoxDecoration(
          color: Colors.red[300],
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children:<Widget>[
            Text("Calendario",style: TextStyle(fontSize:15,fontFamily: AppConfig.quicksand, color:Colors.white,fontWeight: FontWeight.w700),),
            Icon(LineIcons.calendar_check_o,color:Colors.white,size:45),
            // Text("1",style: TextStyle(color:Colors.white,fontWeight: FontWeight.w700,fontSize: 25),),
          ]
        ),      
      ),
    );
  }

   _tareasTerminadas(){
    return GestureDetector(
      onTap: (){

      },
          child: Container(
        padding: EdgeInsets.all(10),
        // width: 150,
        // height: 120,
        decoration: BoxDecoration(
          color: Colors.blue[300],
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children:<Widget>[
            Text("Tareas concluidas",style: TextStyle(fontSize: 15, fontFamily: AppConfig.quicksand, color:Colors.white,fontWeight: FontWeight.w700),),
            Icon(LineIcons.calendar_check_o,color:Colors.white,size:45),
            // Text("1",style: TextStyle(fontFamily: AppConfig.quicksand, color:Colors.white,fontWeight: FontWeight.w700,fontSize: 25),),
          ]
        ),      
      ),
    );
  }
  _dashBoard(){
   return Column(
     children: <Widget>[
       Row(
         children:<Widget>[
           Expanded(child: _tareasPorAsignar() ,),
           SizedBox(width:10),
           Expanded(child: _tareasTerminadas() ,)

         ]
       )
     ],
   );
  }
}