

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/page_bloc.dart';
import 'package:app_invernadero_trabajador/src/pages/home/home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/home/main_page.dart';
import 'package:app_invernadero_trabajador/src/providers/menu_provider.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/icon_string_util.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

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
  bool open=false;

  bool _showAppbar = true ; // esto es para mostrar la barra de aplicaciones 
  ScrollController _scrollBottomBarController = new ScrollController (); // establece el controlador en desplazamiento 
  bool isScrollingDown = false ; 
  bool _show = true ; 
  
  bool fetch=false;

  SecureStorage _prefs = SecureStorage();
  _handleDrawer(){
    _key.currentState.openDrawer();
    setState(() {
      print("open");
    });  
  }
  bool _checkConfiguration() => true;

  @override
  void initState() {
    _pageBloc = PageBloc();
    _pageBloc.onChangePageTitle('Home');
    myScroll ();

    if (_checkConfiguration()) {
      print("LLAMANDO UNA VEZ");
      Future.delayed(Duration.zero,() async{
        context;
        await Provider
        .of<SolarCultivoService>(context,listen: false)
        .fetchSolares();
        // showDialog(context: context, builder: (context) => AlertDialog(
        //   content: Column(
        //     children: <Widget>[
        //       Text('@todo')
        //     ],
        //   ),
        //   actions: <Widget>[
        //     FlatButton(onPressed: (){
        //       Navigator.pop(context);
        //     }, child: Text('OK')),
        //   ],
        // ));
      });
    }

    super.initState();
  } 



 

  @override
  void dispose() {
    _scrollBottomBarController.removeListener (() {}); 
    super.dispose();
  }
  void showBottomBar () { 
  setState (() { 
    _show = true ; 
  }); 
  } 

void hideBottomBar () { 
  setState (() { 
    _show = false ; 
  }); 
}
void myScroll() async {
  _scrollBottomBarController.addListener(() {
    if (_scrollBottomBarController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!isScrollingDown) {
        isScrollingDown = true;
        _showAppbar = false;
        hideBottomBar();
      }
    }
    if (_scrollBottomBarController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (isScrollingDown) {
        isScrollingDown = false;
        _showAppbar = true;
        showBottomBar();
      }
    }
  });
} 


  @override
  void didChangeDependencies() {
    _prefs.route = 'menu_drawer';
    super.didChangeDependencies();
    opts =  menuProvider.loadData();
    _responsive = Responsive.of(context);
    _pageBloc.changeScrollController(_scrollBottomBarController);
    _pageBloc.changeShowAppBar(true);
  }

  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
        key: _key,
      appBar: _showAppbar
        ?  AppBar(
        brightness: Brightness.light,
        elevation:0.0,
        backgroundColor:Colors.white,
       leading: new IconButton(icon: new Icon(
          LineIcons.bars,color: MyColors.GreyIcon,
        ),onPressed:_handleDrawer,), 
        title: StreamBuilder(
        stream: _pageBloc.pageTitleStream,
        initialData: _pageBloc.pageTitle,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          //if(snapshot.hasData){
            return Text(snapshot.hasData?snapshot.data:'Home',
              style: TextStyle(color:MyColors.GreyIcon,fontFamily: AppConfig.quicksand,
              fontWeight: FontWeight.w700
              ),);
          //}
          // return Text('Home', style: TextStyle(color:MyColors.GreyIcon,fontFamily: AppConfig.quicksand,
          //     fontWeight: FontWeight.w700
          //     ),);
        },
      ),
        
       
      actions: <Widget>[
          IconButton(icon: Icon(LineIcons.search,color:MyColors.GreyIcon), onPressed: (){})
        ],
      )
        : PreferredSize(
      child: Container(),
      preferredSize: Size(0.0, 0.0),
    ),
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
        // isScrollingDown =true;
        // _pageBloc.changeShowAppBar(true);
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
          SvgPicture.asset('assets/icons/user.svg',                  
          height: _responsive.ip(10)),
          Text('Bienvenido',style: TextStyle(
                color: Colors.white,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: _responsive.ip(2)
              ),),
          Text('User name',style: TextStyle(
                color: Colors.white,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: _responsive.ip(1.5)
              ),),
          ]
        ),
        decoration: BoxDecoration(
          color: miTema.accentColor,
        ),
      );
  } 


  
  

}
