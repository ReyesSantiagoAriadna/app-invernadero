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
import 'package:app_invernadero_trabajador/src/providers/regions_provider.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_cultivos.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_distrito.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_mun.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_region.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_solares.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
class ActividadesHomePage extends StatefulWidget {
  const ActividadesHomePage({Key key}) : super(key: key);

  @override
  _ActividadesHomePageState createState() => _ActividadesHomePageState();
}

class _ActividadesHomePageState extends State<ActividadesHomePage> with SingleTickerProviderStateMixin{
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
      TareasPage(),
      ProductosPage(),
      GastosPage(),
      SobrantesPage()
      // PedidosPendientesPage(),
    ]),
    );
  }
}
