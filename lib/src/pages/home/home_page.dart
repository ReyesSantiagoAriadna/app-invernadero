import 'package:app_invernadero_trabajador/src/blocs/page_bloc.dart';
import 'package:app_invernadero_trabajador/src/pages/menu_page.dart';
import 'package:app_invernadero_trabajador/src/pages/pedidos/pedidos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/zoom_scafold.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:provider/provider.dart';
class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => new _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> with TickerProviderStateMixin {
  MenuController menuController;
  PageBloc _pageBloc; 
  SecureStorage _prefs = SecureStorage(); 

  @override
  void initState() {
    super.initState();
    _prefs.route='home';
    FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    
    menuController = new MenuController(
      vsync: this,
    )..addListener(() => setState(() {}));
  }

  @override
  void didChangeDependencies() {
    _pageBloc = PageBloc();
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    menuController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    
    return ChangeNotifierProvider(
      builder: (context) => menuController,
      child: ZoomScaffold(
        menuScreen: MenuScreen(),
        contentScreen: Layout(
          contentBuilder: (cc) => Container(
                color: Colors.white,
                child: StreamBuilder(
                  // initialData: MyHomePage(),
                  stream: _pageBloc.pageStream,
                  builder: (BuildContext context, AsyncSnapshot snapshot){
                    if(snapshot.hasData){
                      return snapshot.data;
                    }else{
                      return Container(color:Colors.pink);
                    }
                  },
                ),
              )),
      ),
    );
  }
}