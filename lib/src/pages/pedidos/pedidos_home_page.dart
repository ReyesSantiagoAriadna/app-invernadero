import 'package:app_invernadero_trabajador/src/pages/pedidos/pedidos_confirmados_page.dart';
import 'package:app_invernadero_trabajador/src/pages/pedidos/pedidos_pendientes_page.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class PedidosHomePage extends StatefulWidget {
  @override
  _PedidosHomePageState createState() => _PedidosHomePageState();
}

class _PedidosHomePageState extends State<PedidosHomePage>  with SingleTickerProviderStateMixin {
  TabController _tabController;
  @override
  void initState() {
    _tabController= TabController(vsync: this, length: 2);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
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
                  new Tab(icon: new Icon(LineIcons.list_alt,color: Colors.grey,)),
                  new Tab(icon: new Icon(LineIcons.clock_o,color: Colors.grey,)),
                ],
              ),
            ],
          ),
    title: null,
  ),

   body: TabBarView(
     controller: _tabController,children: <Widget>[
        PedidosConfirmadosPage(),
        PedidosPendientesPage(),
      ]),
    );
  }
}