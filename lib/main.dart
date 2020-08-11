import 'package:app_invernadero_trabajador/src/pages/actividades/actividades_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/herramientas/herramientas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/home/home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/insumos/insumos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/ofertas/ofertas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/pedidos/pedidos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/plagas/plagas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/solar_cultivos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/ventas/ventas_home_page.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
     return new MaterialApp(
      title: 'Zoom Menu',
      theme: miTema,
      initialRoute: 'home',
      debugShowCheckedModeBanner: false,
      routes: {
        'home'                  : (BuildContext)=>MyHomePage(),
        'solar_cultivos'        : (BuildContext)=>SolarCultivosHomePage(),
        'actividades'           : (BuildContext)=>ActividadesHomePage(),
        'herramientas'          : (BuildContext)=>HerramientasHomePage(),
        'insumos'               : (BuildContext)=>InsumosHomePage(),
        'ofertas'               : (BuildContext)=>OfertasHomePage(),
        'pedidos'               : (BuildContext)=>PedidosHomePage(),
        'plagas'                : (BuildContext)=>PlagasHomePage(),
        'ventas'                : (BuildContext)=>VentasHomePage(),
        
      }
    );
  }
}
