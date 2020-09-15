// import 'package:app_invernadero_trabajador/app_config.dart';
// import 'package:app_invernadero_trabajador/src/blocs/map_box_bloc.dart';
// import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
// import 'package:app_invernadero_trabajador/src/blocs/task/task_bloc.dart';
// import 'package:app_invernadero_trabajador/src/models/weather/weather_bit.dart';
// import 'package:app_invernadero_trabajador/src/pages/zoom_scafold.dart';
// import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
// import 'package:app_invernadero_trabajador/src/theme/theme.dart';
// import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';


// class HomeEmployeePage extends StatefulWidget {
//   @override
//   _HomeEmployeePageState createState() => new _HomeEmployeePageState();
// }

// class _HomeEmployeePageState extends State<HomeEmployeePage> with TickerProviderStateMixin {
//   MenuController menuController;
//   SecureStorage _prefs = SecureStorage(); 
//   MapBoxBloc mapBoxBloc = MapBoxBloc();
//   Responsive _responsive;
//   SolarCultivoBloc solarBloc = SolarCultivoBloc();
//   TaskBloc taskBloc = TaskBloc();
//   @override
//   void initState() {
//     super.initState();


//     FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    
//     menuController = new MenuController(
//       vsync: this,
//     )..addListener(() => setState(() {}));
//   }

//   @override
//   void didChangeDependencies() {
//     _responsive = Responsive.of(context);
//     super.didChangeDependencies();
//   }

//   @override
//   void dispose() {
//     menuController.dispose();
//     super.dispose();
//   }

//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: _body(),
//     );
     
//   }

//   _body(){
//     return Container(
//       height: double.infinity,
//       width: double.infinity,
//       margin: EdgeInsets.all(10),
//       child: SingleChildScrollView(
//               child: Column(
//           children: <Widget>[
//             _weatherBit(),
//             // SizedBox(height:20),
//             // _solarInf(),
//             // SizedBox(height:10),
//             // _cultivoInf(),
//             // SizedBox(height:10),
//             // _cultivo(),
//             // SizedBox(height:10),
//             // _dashBoard(),
//             // MyCalendar(),
//           ],
//         ),
//       ),
//     );
//   }
 

//   _weatherBit(){
//     return StreamBuilder(
//       stream: mapBoxBloc.weatherBitStream ,
//       initialData: mapBoxBloc.weatherBit,
//       builder: (BuildContext context, AsyncSnapshot snapshot){
//         if(!snapshot.hasData)
//           return Container(
//             height: 150,
//             padding: EdgeInsets.all(10),
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius : BorderRadius.circular(15)
//             ),
//           );
//         WeatherBit weather;
//          weather= snapshot.data;
//         return _itemWeatherBit(weather);
//       },
//     );
//   }
//   _itemWeatherBit(WeatherBit clima){
//     // if(clima!=null){
//     //   final date = DateTime.parse(clima.data[0].datetime);
//     //   taskBloc.onChangeDateNet(date);
//     // }
//     TextStyle _style =TextStyle(color:Colors.white,fontFamily: AppConfig.quicksand,
//                   fontWeight: FontWeight.w700
//                 );
//      return Container( 
//       padding: EdgeInsets.all(10),
//       decoration: BoxDecoration(
//         color: miTema.accentColor,
//         borderRadius : BorderRadius.circular(15)
//       ),
//       width: double.infinity,
//       height: 150,
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: <Widget>[
//           Column(
//             children:<Widget>[
//               Text(clima==null?
//                 "Oaxaca, MX":
//                "${clima.data[0].cityName}, ${clima.data[0].countryCode}",
//               style: TextStyle(
//                 fontSize: 25,
//                 color:Colors.white,fontFamily:AppConfig.quicksand,fontWeight:FontWeight.w700),),
//               SizedBox(height:5),
//               Text(
//                 clima==null?
//                 "0.0 °C":
//                 "${clima.data[0].temp} °C",style:  TextStyle(fontFamily:AppConfig.quicksand,fontSize:35,color:Colors.white),),
//               SizedBox(height:5),
//               Text(clima==null?"":"Sensación termica ${clima.data[0].appTemp} °C",style: _style,),
//               SizedBox(height:5),
//               Text(clima==null?"":"${clima.data[0].datetime}",style: _style,)

            
//             ]
//           ),
//           Column(
//             children:<Widget>[
//               _icon(clima.data[0].weather.icon),
//                Text(clima==null?"":"${clima.data[0].weather.description}",
//                 style: TextStyle(color:Colors.white,fontFamily: AppConfig.quicksand,
//                   fontWeight: FontWeight.w700
//                 ),),
//             ]
//           )
//         ],
//       ),  
//     );
//   }


//   _icon(String icon){
//     if(icon!=null){
//       return  FadeInImage(
//         placeholder: AssetImage('assets/images/placeholder.png'), 
//         image: NetworkImage(AppConfig.weather_bit_url_icon+icon+".png"),
//         fit : BoxFit.cover,
//         height: _responsive.ip(10),
//         );
//     }
//     return 
//       Container(
//         height:_responsive.ip(10),
//         child:Image.asset('assets/images/placeholder.png')
//       );
//   }

  
// }