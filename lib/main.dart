import 'package:app_invernadero_trabajador/src/pages/actividades/actividades_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/ajustes/ajustes_page.dart';
import 'package:app_invernadero_trabajador/src/pages/herramientas/herramientas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/home/home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/home/main_page.dart';
import 'package:app_invernadero_trabajador/src/pages/insumos/insumos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/login/config_password_page.dart';
import 'package:app_invernadero_trabajador/src/pages/login/login_password_page.dart';
import 'package:app_invernadero_trabajador/src/pages/login/login_phone_page.dart';
import 'package:app_invernadero_trabajador/src/pages/login/pin_code_page.dart';
import 'package:app_invernadero_trabajador/src/pages/login/register_code_page.dart';
import 'package:app_invernadero_trabajador/src/pages/menu_drawer.dart';
import 'package:app_invernadero_trabajador/src/pages/ofertas/ofertas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/pedidos/pedidos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/plagas/plagas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/details_solar_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/solar_add_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/solar_cultivos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/solar_edit_page.dart';
import 'package:app_invernadero_trabajador/src/pages/ventas/ventas_home_page.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';

void main() async{
  //var path = await getApplicationDocumentsDirectory();
  //Hive.init(path.path );
  

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new SecureStorage();
  await prefs.initPrefs();

  // DBProvider db = DBProvider();
  // await db.initDB();
  // SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle(
  //  systemNavigationBarColor: Colors.white, // navigation bar color
  //   statusBarColor: Colors.white, // status bar color
  //   statusBarIconBrightness: Brightness.dark,
  //   statusBarBrightness: Brightness.light,
  //   systemNavigationBarIconBrightness: Brightness.dark,
    
  // ));

  // PushNotificationsProvider provider = PushNotificationsProvider();
  // provider.initNotifications();
  // provider.getToken();

// SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyl e.dark);
  runApp(MyApp());
} 

class MyApp extends StatefulWidget {
  // This widget is the root of your application.
  @override
  _MyAppState createState() => _MyAppState();
}


class _MyAppState extends State<MyApp> {
  final prefs = new SecureStorage();

  @override
  void initState() {
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
     return MultiProvider(
        providers: [
            //ChangeNotifierProvider(create: (_)=> new LocalService()),
            ChangeNotifierProvider(create: (_)=> new SolarCultivoService(),),
          ],
            child: new MaterialApp(
        title: 'SS Invernadero',
        theme: miTema,
        initialRoute: prefs.route,
        debugShowCheckedModeBanner: false,
        routes: {
          'main'                  : (BuildContext)=>MainPage(),
          'menu'                  : (BuildContext)=>MenuDrawer(),
          'register_code'         : (BuildContext)=>CodeRegisterPage(),
          'login_phone'           : (BuildContext)=>LoginPhonePage(),
          'login_password'        : (BuildContext)=>LoginPasswordPage(),
          'pin_code'              : (BuildContext)=>PinCodePage(),
          'config_password'       : (BuildContext)=>ConfigPasswordPage(),
          
          'menu_drawer'           : (BuildContext)=>MenuDrawer(),

          'home'                  : (BuildContext)=>MyHomePage(),
          'solar_cultivos'        : (BuildContext)=>SolarCultivosHomePage(),
          'details_solar'         : (BuildContext)=>DetailsSolarPage(),
          'solar_add'             : (BuildContext)=>SolarAddPage(),
          'solar_edit'            : (BuildContext)=>SolarEditPAge(),

          'actividades'           : (BuildContext)=>ActividadesHomePage(),
          'herramientas'          : (BuildContext)=>HerramientasHomePage(),
          'insumos'               : (BuildContext)=>InsumosHomePage(),
          'ofertas'               : (BuildContext)=>OfertasHomePage(),
          'pedidos'               : (BuildContext)=>PedidosHomePage(),
          'plagas'                : (BuildContext)=>PlagasHomePage(),
          'ventas'                : (BuildContext)=>VentasHomePage(),
          'ajustes'               : (BuildContext)=>AjustesPage(),
          
        }
    ),
     );
  }
}


