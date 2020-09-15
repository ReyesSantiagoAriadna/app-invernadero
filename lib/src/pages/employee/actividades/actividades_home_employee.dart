import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/regiones.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/gastos/gastos_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/productos/productos_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/sobrantes/sobrantes_page.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/tareas/tareas_page.dart';
import 'package:app_invernadero_trabajador/src/pages/employee/actividades/tareas_employee_page.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
class ActividadesEmployeeHome extends StatefulWidget {
  const ActividadesEmployeeHome({Key key}) : super(key: key);

  @override
  _ActividadesEmployeeHomeState createState() => _ActividadesEmployeeHomeState();
}

class _ActividadesEmployeeHomeState extends State<ActividadesEmployeeHome> with SingleTickerProviderStateMixin{
  TabController _tabController;
  @override
  void initState() {
    _tabController= TabController(vsync: this, length: 4);
    super.initState();
  }


  @override
  void didChangeDependencies() {
  
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    TextStyle style = TextStyle(color: MyColors.GreyIcon,fontFamily:AppConfig.quicksand,fontSize:10,fontWeight: FontWeight.w700 );
    return Scaffold(
      appBar: new AppBar(
        elevation: 0.0,
        backgroundColor: Colors.white,
        flexibleSpace: new Column(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              new TabBar(
                indicatorColor: miTema.accentColor,
                controller: _tabController,
                tabs: [
                  new Tab(icon: new Column(children:<Widget>[ 
                    Text("Tareas",style: style,),
                    Icon(LineIcons.calendar_check_o,color: MyColors.GreyIcon,)]),),
                  new Tab(icon: Column(
                    children: <Widget>[
                      Text("Productos",style: style,),
                      new Icon(LineIcons.archive,color:MyColors.GreyIcon,),
                    ],
                  )),
                  new Tab(icon: Column(
                    children: <Widget>[
                      Text("Gastos",style: style,),
                      new Icon(LineIcons.money,color: Colors.grey,),
                    ],
                  )),
                  new Tab(icon: Column(
                    children: <Widget>[
                      Text("Sobrantes",style: style,),
                      new Icon(LineIcons.clipboard,color: Colors.grey,),
                    ],
                  )),
                ],
              ),
            ],
          ),
    title: null,
  ),
  
  body: TabBarView(
    controller: _tabController,children: <Widget>[
      // PedidosConfirmadosPage(),
      TareasEmployeePage(),
      ProductosPage(),
      GastosPage(),
      SobrantesPage()
      // PedidosPendientesPage(),
    ]),
    );
  }
}
