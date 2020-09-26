import 'dart:convert';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/map_box_bloc.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/actividades_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/gastos/gasto_add_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/gastos/gasto_edit_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/productos/producto_add_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/productos/producto_edit_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/sobrantes/sobrante_add_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/sobrantes/sobrante_edit_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/tareas/tarea_add_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/tareas/tarea_edit_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/tareas/tarea_herramientas.dart';
import 'package:app_invernadero_trabajador/src/pages/ajustes/ajustes_page.dart';
import 'package:app_invernadero_trabajador/src/pages/compras/compras_page.dart';
import 'package:app_invernadero_trabajador/src/pages/employee/actividades/actividades_home_employee.dart';
import 'package:app_invernadero_trabajador/src/pages/employee/home/employee_calendar.dart';
import 'package:app_invernadero_trabajador/src/pages/employee/home/home_employee_page.dart';
import 'package:app_invernadero_trabajador/src/pages/employee/home/task_details_widget.dart';
import 'package:app_invernadero_trabajador/src/pages/insumos/compra_insumo_page.dart';
import 'package:app_invernadero_trabajador/src/pages/ajustes/configuration_page.dart';
import 'package:app_invernadero_trabajador/src/pages/ajustes/update_datos_trabajador.dart';
import 'package:app_invernadero_trabajador/src/pages/herramientas/add_herramienta_page.dart';
import 'package:app_invernadero_trabajador/src/pages/herramientas/edit_herramienta_page.dart';
import 'package:app_invernadero_trabajador/src/pages/herramientas/herramientas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/home/home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/home/main_page.dart';
import 'package:app_invernadero_trabajador/src/pages/insumos/add_insumo_page.dart';
import 'package:app_invernadero_trabajador/src/pages/insumos/edit_insumo_page.dart';
import 'package:app_invernadero_trabajador/src/pages/insumos/insumos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/login/config_password_page.dart';
import 'package:app_invernadero_trabajador/src/pages/login/login_password_page.dart';
import 'package:app_invernadero_trabajador/src/pages/login/login_phone_page.dart';
import 'package:app_invernadero_trabajador/src/pages/login/pin_code_page.dart';
import 'package:app_invernadero_trabajador/src/pages/login/register_code_page.dart';
import 'package:app_invernadero_trabajador/src/pages/menu_drawer.dart';
import 'package:app_invernadero_trabajador/src/pages/notifications/notifications_page.dart';
import 'package:app_invernadero_trabajador/src/pages/ofertas/add_oferta_page.dart';
import 'package:app_invernadero_trabajador/src/pages/ofertas/ofertas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/pedidos/pedido_agendar_page.dart';
import 'package:app_invernadero_trabajador/src/pages/pedidos/pedidos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/plagas/add_plaga_page.dart';
import 'package:app_invernadero_trabajador/src/pages/plagas/edit_plaga_page.dart';
import 'package:app_invernadero_trabajador/src/pages/plagas/plagas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/cultivo_add_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/cultivo_edit_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/cultivo_etapas_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/details_solar_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/solar_add_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/solar_cultivos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/solar_edit_page.dart';
import 'package:app_invernadero_trabajador/src/pages/task/task_assign_page.dart';
import 'package:app_invernadero_trabajador/src/pages/task/task_reasignar_horario_page.dart';
import 'package:app_invernadero_trabajador/src/pages/task/task_reasignar_personal_page.dart';
import 'package:app_invernadero_trabajador/src/pages/ventas/ventas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/task/calendar.dart';
import 'package:app_invernadero_trabajador/src/providers/firebase/push_notification_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/hive/hive_provider.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/gastos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/productos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/sobrantes_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/services/employee/tasks_services.dart';
import 'package:app_invernadero_trabajador/src/services/insumosService/insumos_service.dart';
import 'package:app_invernadero_trabajador/src/services/notifications/notifications_service.dart';
import 'package:app_invernadero_trabajador/src/services/ofertaService/ofertas_service.dart';
import 'package:app_invernadero_trabajador/src/services/pedidos/pedidos_service.dart';
import 'package:app_invernadero_trabajador/src/services/plagasService/plaga_services.dart';
// import 'package:app_invernadero_trabajador/src/services/productoService/produtos_service.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/services/inventarioService/inventario_service.dart';
import 'package:app_invernadero_trabajador/src/services/trabajadorService/trabajador_service.dart';
import 'package:app_invernadero_trabajador/src/services/ventas/ventas_service.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/widgets/date_picker.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:firebase_messaging/firebase_messaging.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:geolocator/geolocator.dart';

import 'package:permission_handler/permission_handler.dart';
import 'package:provider/provider.dart';
import 'package:intl/date_symbol_data_local.dart';

import 'src/models/pedidos/pedido_model.dart';
// Example holidays


void main() async{
  //var path = await getApplicationDocumentsDirectory();
  //Hive.init(path.path );

  WidgetsFlutterBinding.ensureInitialized();
  final prefs = new SecureStorage();
  await prefs.initPrefs();
  HiveProvider hiveProvider = HiveProvider();
  await hiveProvider.initDB();

  // Intl.defaultLocale = 'pt_BR';
 // await findSystemLocale();
  // await initializeDateFormatting();
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
  MapBoxBloc mapBoxBloc;
  final GlobalKey<NavigatorState> navigatorKey = new GlobalKey<NavigatorState>();
  
  // final FirebaseMessaging _firebaseMessaging = new FirebaseMessaging();
  // static bool isNotified=false;
  

  
  @override
  void initState() {
    final pushProvider = new PushNotificationProvider();
    pushProvider.initNotifications();
    // _firebaseMessaging.requestNotificationPermissions();
    // _firebaseMessaging.getToken().then((v){
    //   print("===============FCM TOKEN ==================");
    //   print("Token $v");
    // });



    // _firebaseMessaging.configure(
    //   onMessage: onMessage,
    //   onBackgroundMessage: onBackgroundMessage,
    //   onLaunch: onLaunch,
    //   onResume: onResume,
    // );




    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    mapBoxBloc = MapBoxBloc();

    
    
    // pushProvider.messageStream.listen((onData){
    //   //navigatorKey.currentState.pushNamed('ruta'); //navgar hacia ruta o hacer algo

    // });

    
    super.initState();
  }

  
  // Future<dynamic> onMessage(Map<String, dynamic> message) async{
  

  //   if(isNotified)return;
  //     print("=======on message========"); //ap en primer plano
  //   print("mensaje $message");
  //   isNotified=true;
    
  //   NotificationsService.instance.getNotifications();
  //   final data = message['data'];
  //   if(data!=null){
  //     _toProcessData(data);
  //   }
  //   print("Saliendo de on message");
  //   isNotified=false;
  // }

  // Future<dynamic> onLaunch(Map<String, dynamic> message) async{
  //   print("=======on onLaunch========");
  //   NotificationsService.instance.getNotifications();
  //   print("mensaje $message");
  // }
  // Future<dynamic> onResume(Map<String, dynamic> message) async{
  //   print("=======on onResume========"); //volviendo del bakground
  //   print("mensaje $message");
  //   NotificationsService.instance.getNotifications();
  // }

  //  static Future<dynamic> onBackgroundMessage(Map<String, dynamic> message) async {
  //   // var provider = Provider.of<NotificationsService>(context,listen: false);
  //   // provider.getNotifications();
  //   if (message.containsKey('data')) {
  //     // Handle data message
  //     final dynamic data = message['data'];
      
  //   }

  //   if (message.containsKey('notification')) {
  //     // Handle notification message
  //     final dynamic notification = message['notification'];
  //   }

  // // Or do other work.
  // } 

  // _toProcessData(dynamic data){
  //   switch (data['tipo']){
  //     case AppConfig.fcm_type_pedido:  //tipo pedido
  //     Pedido p = Pedido.fromJson(json.decode(data['pedido']));
  //     print("======== PEDIDO ======");
  //     print("${p.id} ${p.totalPagado}");
  //     PedidosService.instance.addOrReplace(p);
  //     break;

  //     default:

  //     break;
  //   }
  // }

  @override
  Widget build(BuildContext context) {
     return FeatureDiscovery(
            child: FutureBuilder(
        future: Permission.location.request(),
        builder: (BuildContext context, AsyncSnapshot snapshot) {
          return FutureBuilder( //obtener position actual
            future: Geolocator().getCurrentPosition(desiredAccuracy: LocationAccuracy.high),
            builder: (BuildContext context, AsyncSnapshot snapshot) {
              if(snapshot.hasData){
                //guardar en el bloc
                Position p = snapshot.data;
                mapBoxBloc.changePosition(p);
              }

              return MultiProvider(
                  providers: [
                  //ChangeNotifierProvider(create: (_)=> new LocalService()),
                  ChangeNotifierProvider(create: (_)=> new SolarCultivoService(),),
                  ChangeNotifierProvider(create: (_)=> new TareasService(),),
                  ChangeNotifierProvider(create: (_)=> new ProductosService(),),
                  ChangeNotifierProvider(create: (_)=> new GastosService(),),
                  ChangeNotifierProvider(create: (_)=> new SobrantesService(),),
                  ChangeNotifierProvider(create: (_)=> PedidosService.instance),

                  ChangeNotifierProvider(create: (_)=> new PlagaService(),),
                  ChangeNotifierProvider(create: (_)=>new InventarioService(),),
                  ChangeNotifierProvider(create: (_)=>new OfertaService(),),
                  // ChangeNotifierProvider(create: (_)=>new ProductosService(),),
                  ChangeNotifierProvider(create: (_)=>new InsumoService(),),
                  ChangeNotifierProvider(create: (_)=>TasksEmployeeService.instance,),
                  ChangeNotifierProvider(create: (_)=>NotificationsService.instance,),
                  ChangeNotifierProvider(create: (_)=>new TrabajadorService(),),
                  ChangeNotifierProvider(create: (_)=>VentaService.instance,), 
                ],
                // import 'package:intl/intl.dart';
                  child: new MaterialApp(
                      navigatorKey: navigatorKey,
                  localizationsDelegates: [ 
                    GlobalMaterialLocalizations.delegate,
                    GlobalWidgetsLocalizations.delegate,
                    GlobalCupertinoLocalizations.delegate,
                  ],
                  supportedLocales: [
                    const Locale('en'), // English
                    const Locale('es'), // Español
                  ],

              title: 'SS Invernadero',
              theme: miTema,
              initialRoute:prefs.route,
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
                'home_employee'         : (BuildContext)=>HomeEmployeePage(),
                'solar_cultivos'        : (BuildContext)=>SolarCultivosHomePage(),
                'details_solar'         : (BuildContext)=>DetailsSolarPage(),
                'solar_add'             : (BuildContext)=>SolarAddPage(),
                'solar_edit'            : (BuildContext)=>SolarEditPAge(),
                'cultivo_add'           : (BuildContext)=>CultivoAddPage(),
                'cultivo_edit'          : (BuildContext)=>CultivoEditPage(),
                'cultivo_etapas'        : (BuildContext)=>CultivoEtapasPage(),

                'actividades'           : (BuildContext)=>ActividadesHomePage(),
                
                'tarea_add'             :(BuildContext)=>TareaAddPage(),
                'tarea_edit'             :(BuildContext)=>TareaEditPage(),
                'tarea_herramientas'    : (BuildContext)=>TareaHerramientasPage(),
                'producto_add'          : (BuildContext)=>ProductoAddPage(),
                'producto_edit'         : (BuildContext)=>ProductoEditPage(),
                'gasto_add'             : (BuildContext)=>GastoAddPage(),
                'gasto_edit'            : (BuildContext)=>GastoEditPage(),
                'sobrante_add'          : (BuildContext)=>SobranteAddPage(),
                'sobrante_edit'         : (BuildContext)=>SobranteEditPage(),
                'herramientas'          : (BuildContext)=>HerramientasHomePage(),
                'herramienta_add'       : (BuildContext)=>AddHerramientaPage(),
                'herramienta_edit'      : (BuildContext)=>EditHerramientaPage(),
                
                'insumos'               : (BuildContext)=>InsumosHomePage(),
                'insumos_edit'          : (BuildContext)=>EditInsumoPage(),
                'insumos_add'           : (BuildContext)=>AddInsumoPage(),
                'compra_insumos'        : (BuildContext)=>CompraIsumosPage(),
                
                'ofertas'               : (BuildContext)=>OfertasHomePage(),
                'oferta_add'            : (BuildContext)=>AddOfertaPage(),
                
                'pedidos'               : (BuildContext)=>PedidosHomePage(),
                'pedido_agendar'        : (BuildContext)=>PedidoAgendarPage(),
                
                'plagas'                : (BuildContext)=>PlagasHomePage(),
                'plaga_add'             : (BuildContext)=>AddPlagaPage(),
                'plaga_edit'            : (BuildContext)=>PlagaEditPage(),

                'ventas'                : (BuildContext)=>VentasHomePage(),
                
                'ajustes'               : (BuildContext)=>AjustesPage(),
                'configuracion'         : (BuildContext)=>ConfigurationPage(),
                'updateTrabajador'      : (BuildContext)=>UpdateDatosTrabajador(),
                
                'calendar'              : (BuildContext)=>MyCalendar(),
                'tarea_asignar'         : (BuildContext)=>TaskAssignPage(),
                'tarea_reasignar_personal' : (BuildContext)=>TaskReasignarPersonalPage(),
                'tarea_reasignar_horario'  : (BuildContext)=>TaskReasignarHorarioPage(),
                'test'                  : (BuildContext)=>MyDatePicker(),


                'actividades_employee'  : (BuildContext)=>ActividadesEmployeeHome(),
                'task_employee_details' : (BuildContext)=>TaskEmployeeDetails(),

                
                'notifications'         : (BuildContext)=>NotificationsPage(),
                'compras'               : (BuildContext)=>ShoppingPage()
              }
            ),
          );        
            },
          );
        },
    ),
     );
  }
}


