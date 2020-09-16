

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/login_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/map_box_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/page_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/user_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/ofertas/ofertaTipo.dart';
import 'package:app_invernadero_trabajador/src/models/productos/producto.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/pages/default_actions_app_bar.dart';
import 'package:app_invernadero_trabajador/src/pages/employee/home/home_employee_page.dart';
import 'package:app_invernadero_trabajador/src/pages/home/home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/home/main_page.dart';
import 'package:app_invernadero_trabajador/src/providers/menu_provider.dart';
import 'package:app_invernadero_trabajador/src/services/notifications/notifications_service.dart';
import 'package:app_invernadero_trabajador/src/services/ofertaService/ofertas_service.dart';
import 'package:app_invernadero_trabajador/src/services/productoService/produtos_service.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/icon_string_util.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/badge_bottom_icon.dart';
import 'package:feature_discovery/feature_discovery.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import 'employee/home/employee_calendar.dart';

class MenuDrawer extends StatefulWidget {
  @override
  _MenuDrawerState createState() => _MenuDrawerState();
}

class _MenuDrawerState extends State<MenuDrawer> {
  TextStyle _style ; 
  Responsive _responsive;
  Future<List<dynamic>> opts;
  PageBloc _pageBloc;
  LoginBloc loginBloc = LoginBloc();
  GlobalKey<ScaffoldState> _key = new GlobalKey<ScaffoldState>();
  bool open=false;

  bool _showAppbar = true ; // esto es para mostrar la barra de aplicaciones 
  ScrollController _scrollBottomBarController = new ScrollController (); // establece el controlador en desplazamiento 
  bool isScrollingDown = false ; 
  bool _show = true ; 
  
  bool fetch=false;

  Stream<List<Solar>> solaresStream;
  Stream<List<OfertaTipo>> ofertaTipoStream;
  Stream<List<Producto>> productoStream;
  String rol;
  int init =-1;
  String initialRoute;
  bool _isLoading =false;
  SecureStorage _prefs = SecureStorage();
  _handleDrawer(){
    _key.currentState.openDrawer();
    setState(() {
      print("open");
    });  
  }
  bool _checkConfiguration() => true;

  TextStyle _titleStyle;
  TextStyle _subtitleStyle ;


  @override
  void initState() {
    SchedulerBinding.instance.addPostFrameCallback((Duration duration) {
    FeatureDiscovery.discoverFeatures(
      context,
      const <String>{ // Feature ids for every feature that you want to showcase in order.
        'menu_feature_id',
        'notifications_feature_id',
        "home_feature_id",
        "solar_cultivos_feature_id",
        "plagas_feature_id",
        "insumos_feature_id",
        "herramientas_feature_id",
        "actividades_feature_id",
        "pedidos_feature_id",
        "ofertas_feature_id",
        "ventas_feature_id"
      },
    ); 
  });

  
    if(_prefs.rolPersonal=='0'){
      rol = "Administrador";
      initialRoute = 'home';
      opts =  menuProvider.loadData();
    }else{
      rol= "Trabajador";
      initialRoute = 'home_employee';
      opts =  menuProvider.loadRoutesEmployee();
    }

   

    MapBoxBloc mbBloc = MapBoxBloc();
    if(mbBloc.position==null){
      Position p = new Position(latitude: AppConfig.default_lat,longitude: AppConfig.default_long);
      mbBloc.changePosition(p);
    }
    //mbBloc.getClima();
    mbBloc.getWeatherBit();


    myScroll ();

    if (_checkConfiguration()) {
      print("LLAMANDO UNA VEZ");
      Future.delayed(Duration.zero,() async{
        context;
        await Provider
        .of<SolarCultivoService>(context,listen: false)
        .fetchSolares();
      });      
    }
    _prefs.route = 'menu_drawer';
    NotificationsService.instance.getNotifications();
    super.initState();
  } 

  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _titleStyle = TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w600);
    _subtitleStyle =  TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w700);

    if(_pageBloc==null){
      _pageBloc = PageBloc();
      _pageBloc.pickPage(context,initialRoute, "Inicio");
      _pageBloc.changeScrollController(_scrollBottomBarController);
      _pageBloc.changeShowAppBar(true);


      _responsive = Responsive.of(context);    
      solaresStream = Provider.of<SolarCultivoService>(context).solarStream;
      ofertaTipoStream = Provider.of<OfertaService>(context).ofertaTipoStream;

       if( Provider.of<SolarCultivoService>(context).solarList.isNotEmpty){
        SolarCultivoBloc solarBloc = SolarCultivoBloc();
        solarBloc.changeSolarHome(Provider.of<SolarCultivoService>(context).solarList[0]);
      }
    
    }
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
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: StreamBuilder(
              stream: _pageBloc.actionsAppBarStream ,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return Scaffold(
                  backgroundColor: Colors.white,
                  key: _key,
                  appBar: _showAppbar
                    ?  myAppBar(snapshot.data)
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
                      if(_prefs.rolPersonal==AppConfig.rol_empleado)
                        return HomeEmployeePage();
                      return MyHomePage();
                    },
                  ),
                  drawer: Drawer(
                    child: _options(),
                  ),
            );

              },
            ),
        ),

        _isLoading? Positioned.fill(child:  Container(
                    color:Colors.black45,
                    child: Center(
                      child:SpinKitCircle(color: miTema.accentColor),
                    ),
                  ),):Container()
      ],
    );
    // return ;
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

    ListTile( 
      onTap: ()async {    

       await _logOut();
      
      },
      leading: Icon(LineIcons.sign_out,color:MyColors.GreyIcon),
      title: Text('Salir',
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

    
  _logOut()async{
    if(_isLoading)return;
    setState(() {
      _isLoading=true;
    });
    await loginBloc.logOut();
    setState(() {
      _isLoading = false;
    });
    if(loginBloc.navRoute.contains("Error")){
      Flushbar(
        message:  loginBloc.navRoute,
        duration:  Duration(seconds: 2),              
      )..show(context);
    }else{
      Navigator.pushReplacementNamed(context, loginBloc.navRoute); 
    }
  }
  List<Widget> _listItems(List<dynamic> data){
    final List<Widget> opciones=[];
    
    


    data.forEach((opt){

      String id_feature = "${opt['ruta']}_feature_id";
      print("ID DEL FEATURE $id_feature");
      final widgetTemp = 
      Container(
        margin: EdgeInsets.only(left:10,right:10),
        decoration: BoxDecoration(
          color: opt['ruta']==initialRoute?miTema.accentColor.withOpacity(0.2):Colors.white,
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
      leading:
        DescribedFeatureOverlay(
                    featureId: id_feature, // Unique id that identifies this overlay.
                    tapTarget:   getIcon(opt['icon'],_responsive,MyColors.GreyIcon), // The widget that will be displayed as the tap target.
                    title: Text(opt['texto'],style: _titleStyle),
                    description: Text(opt['subtitulo'],
                      style: _subtitleStyle
                    ),
                    backgroundColor: MyColors.YellowDiscovery,// Theme.of(context).primaryColor,
                    targetColor:Colors.white,
                    textColor: Colors.grey[800],
                    child:   getIcon(opt['icon'],_responsive,MyColors.GreyIcon),
                  ),
     
      onTap: (){
        // isScrollingDown =true;
        // _pageBloc.changeShowAppBar(true);
        _pageBloc.pickPage(context,opt['ruta'],opt['texto']);
          initialRoute = opt['ruta'];

        // if(_prefs.rolPersonal==AppConfig.rol_empleado && opt['ruta']=='home'){
        //   _pageBloc.pickPage('home_employee',opt['texto']);
        //   initialRoute = 'home_employee';
        // }else{
        //   _pageBloc.pickPage(opt['ruta'],opt['texto']);
        //   initialRoute = opt['ruta'];
        // }
      
        Navigator.pop(context);

      },
      )
      );
      opciones.add(widgetTemp);
    });
    return opciones;
  }

  Color _selectColor(String route){
    if(_prefs.rolPersonal==AppConfig.rol_empleado && route=='home' && initialRoute=='home_employee'){
        return miTema.accentColor.withOpacity(0.2);
    }else{
      if(route==initialRoute)
      return miTema.accentColor.withOpacity(0.2);
    }
  }
  _drawerHeader() {
    return DrawerHeader(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children:<Widget>[
          SvgPicture.asset('assets/icons/user.svg',                  
          height: _responsive.ip(8)),
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
           Text("Rol: $rol",style: TextStyle(
                color: Colors.white,
                fontFamily: 'Quicksand',
                fontWeight: FontWeight.w700,
                fontSize: _responsive.ip(1.5)
              ),),
            // GestureDetector(
            //             child: Icon(LineIcons.chevron_circle_down),
            //             onTapDown: (TapDownDetails details) {
            //                 _showPopupMenu(details.globalPosition);
            //               },
            //           ),


          ]
        ),
        decoration: BoxDecoration(
          color: miTema.accentColor,
        ),
      );
  } 


  
  AppBar myAppBar(List<Widget> actions){
    return AppBar(
        brightness: Brightness.light,
        elevation:0.0,
        backgroundColor:Colors.white,
        
        leading : DescribedFeatureOverlay(
                    featureId: 'menu_feature_id', // Unique id that identifies this overlay.
                    tapTarget: const Icon(LineIcons.bars), // The widget that will be displayed as the tap target.
                    title: Text('Menu',style: _titleStyle),
                    description: Text('Toca el icono para navegar en el menu de opciones.',
                      style: _subtitleStyle
                    ),
                    backgroundColor: MyColors.YellowDiscovery,// Theme.of(context).primaryColor,
                    targetColor:Colors.white,
                    textColor: Colors.grey[800],
                    child: new IconButton(icon: new Icon(
                        LineIcons.bars,color: MyColors.GreyIcon,
                      ),onPressed:_handleDrawer,)
                  ),
        // leading: new IconButton(icon: new Icon(
        //   LineIcons.bars,color: MyColors.GreyIcon,
        // ),onPressed:_handleDrawer,), 
        
        
        
        title: StreamBuilder(
        stream: _pageBloc.pageTitleStream,
        initialData: _pageBloc.pageTitle,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return Text(snapshot.hasData?snapshot.data:'Inicio',
            style: TextStyle(color:MyColors.GreyIcon,fontFamily: AppConfig.quicksand,
            fontWeight: FontWeight.w700
            ),);
        },
      ),
     actions: actions,
      // actions: <Widget>[
      //     IconButton(icon: Icon(LineIcons.search,color:MyColors.GreyIcon), onPressed: (){}),
      //     GestureDetector(
      //       onTap: ()=>"abrir notificaciones",
      //         child: Container(
      //         margin: EdgeInsets.only(top:15),
      //         child:BadgeBottomIcon(icon:Icon(LineIcons.bell,color:MyColors.GreyIcon),number: 5,)
      //       ),
      //     )
      //   ],
      );
  }

  
  
  _showPopupMenu(Offset offset) async {
    const TextStyle _itemStyle = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400);
    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(left, top, 0, 0),
    items: [
     PopupMenuItem<String>(
          child:GestureDetector(
            onTap: ()async{
              // await Provider
              //   .of<PedidosService>(context,listen: false).entregarPedido(widget.pedido.id);
              // Flushbar(
              //           message: widget.pedidoBloc.response!=null?
              //           widget.pedidoBloc.response
              //           :
              //           "Ha ocurrido un error."
              //           ,
              //           duration:  Duration(seconds: 2),              
              //         )..show(context);
            },
            child:  const Text('Salir',style:_itemStyle ,), ),
          ),
    ],
    elevation: 8.0,
  );
}

}
