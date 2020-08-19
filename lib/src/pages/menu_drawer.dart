

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/page_bloc.dart';
import 'package:app_invernadero_trabajador/src/pages/home/home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/home/main_page.dart';
import 'package:app_invernadero_trabajador/src/providers/menu_provider.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/icon_string_util.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  TextStyle _style ; 
  Responsive _responsive;
  Future<List<dynamic>> opts;
  PageBloc _pageBloc;
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  int _counter =0;
  bool open=false;

  SecureStorage _prefs = SecureStorage();
  _handleDrawer(){
      _key.currentState.openDrawer();
 
        setState(() {
          print("open");
        });

      
  }

  @override
  void didChangeDependencies() {
    _prefs.route = 'menu_drawer';
    super.didChangeDependencies();
    _pageBloc = PageBloc();
    opts =  menuProvider.loadData();
    _responsive = Responsive.of(context);
  }

  
  @override
  Widget build(BuildContext context) {
    // _style = TextStyle(color:Colors.white,fontFamily:AppConfig.quicksand,
    //   fontWeight: FontWeight.w700, fontSize:_responsive.ip(1.7)
    // );

     return Scaffold(
      backgroundColor: Colors.white,
        key: _key,
      appBar: _appBar(),
      body: StreamBuilder(
        stream: _pageBloc.pageStream ,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return snapshot.data;
          }
          return MainPage();
        },
      ),
      drawer: Drawer(
        
        child: _options(),
      ),
    );
  }

  AppBar _appBar(){
    return AppBar(
      elevation: 0.0,
      backgroundColor: Colors.white,
      brightness: Brightness.light,
      // iconTheme: new IconThemeData(color: Colors.black),
      title: StreamBuilder(
        stream: _pageBloc.pageTitleStream,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            return Text(snapshot.data,
              style: TextStyle(color:MyColors.GreyIcon,fontFamily: AppConfig.quicksand,
              fontWeight: FontWeight.w700
              ),);
          }
          return Text('Home');
        },
      ),

       leading: new IconButton(icon: new Icon(
          Icons.menu,color: MyColors.GreyIcon,
        ),onPressed:_handleDrawer,),
    );

    //  _key.currentState.openDrawer();
    //         if (_key.currentState.isDrawerOpen) {
    //           print("Drawer is Open");
    //         } else {
    //         print("object")
    //         }
  }
  Widget _options(){
    return ListView(
      padding: EdgeInsets.zero,
       children: <Widget>[
      _drawerHeader(),
      FutureBuilder(
        future: opts,
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          crossAxisAlignment: CrossAxisAlignment.end,
          children: _listItems(snapshot.data),
        );
        },
    ),
    Container(
      margin: EdgeInsets.only(left:15,right: 15),
      width: double.infinity,
      height: 2,
      color: Colors.grey[200],
    ),
            ListTile(
              onTap: () {
                // Provider.of<MenuController>(context, listen: true).toggle();
               
                Navigator.pushNamed(context, 'ajustes');
              },
              leading: Icon(LineIcons.cog,color:MyColors.GreyIcon),
              title: Text('Ajustes  ',
                style: TextStyle(
                  color: MyColors.GreyIcon,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: _responsive.ip(1.8)
                ),
                ),
            ),
           
    ],
    );
  }
  String rut = 'solar_cultivos';
  List<Widget> _listItems(List<dynamic> data){
    
    final List<Widget> opciones=[];
    data.forEach((opt){
      final widgetTemp = 
      Container(
        margin: EdgeInsets.only(left:10,right:10),
        decoration: BoxDecoration(
          color: opt['ruta']==rut?miTema.accentColor.withOpacity(0.2):Colors.white,
          borderRadius:BorderRadius.circular(10)
        ),
        child:ListTile(
        dense:true,  
      title:  Text(opt['texto'],
                style: TextStyle(
                  //color:opt['ruta']==rut?Colors.white: MyColors.GreyIcon,
                  color: MyColors.GreyIcon,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: _responsive.ip(1.8)
                ),
                ),
      //leading: getIcon(opt['icon'],_responsive,opt['ruta']==rut?Colors.white:MyColors.GreyIcon),
      leading: getIcon(opt['icon'],_responsive,MyColors.GreyIcon),
      onTap: (){
        // Navigator.pushNamed(context, opt['ruta']);
        //Provider.of<MenuController>(context, listen: true).toggle();
      //  _pageBloc.pickPage(opt['ruta'],opt['texto']);
       _pageBloc.pickPage(opt['ruta'],opt['texto']);
        rut = opt['ruta'];
        Navigator.pop(context);

      },
      )
      );
      opciones.add(widgetTemp);
    });
    return opciones;
  }

  _drawerHeader() {
    return DrawerHeader(
        
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:<Widget>[
            Icon(
              LineIcons.user,
              color: Colors.white ,
              size: 20,
            ),
            Text('User name',style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: _responsive.ip(2)
                ),),
          ]
        ),
        decoration: BoxDecoration(
          color: miTema.accentColor,
        ),
      );
  } 

  

}
