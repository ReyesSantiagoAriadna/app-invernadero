import 'dart:io'; 
import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/trabajador/trabajador_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/trabajador/trabajador.dart';
import 'package:app_invernadero_trabajador/src/providers/firebase/push_notification_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/menu_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/user_provider.dart';
import 'package:app_invernadero_trabajador/src/services/trabajadorService/trabajador_service.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/icon_string_util.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
class AjustesPage extends StatefulWidget {
  @override
  _AjustesPageState createState() => _AjustesPageState();
}

class _AjustesPageState extends State<AjustesPage> { 
  Responsive _responsive; 
  UserProvider userProvider = UserProvider();
  Stream<Trabajador> trabajadorStream;
  TrabajadorService _trabajadorService;
  TrabajadorBloc _trabajadorBloc;
  
  bool _blockCheck=true;
  bool _isLoading=false;
  IconData _switch = LineIcons.toggle_on;
  Future<List<dynamic>> options;
  File foto;
  String urlImagen = '';
  final fcm = PushNotificationProvider();
  final _storage = SecureStorage();  

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _responsive = Responsive.of(context); 
    options =  menuProvider.loadMenu();
 

    _trabajadorService = Provider.of<TrabajadorService>(context);
    trabajadorStream = Provider.of<TrabajadorService>(context).trabajadorStream;
    _trabajadorBloc = new TrabajadorBloc();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white, 
      body: Stack(
        children: <Widget>[
          SafeArea(
          child: Container(
            margin: EdgeInsets.only(left:10,right:10),
          height: double.infinity,
          width: double.infinity,
          child: SingleChildScrollView(
            physics: BouncingScrollPhysics(),
                      child: Column(
              children:<Widget>[
                _header(),
                SizedBox(height:_responsive.ip(2)),
                Container(
                  margin: EdgeInsets.only(left:40,right:40),
                  height:_responsive.ip(0.1),
                  color:Colors.grey[300]
                ),
                SizedBox(height:_responsive.ip(2)),
                _options()
               ]
             ),
          )
        ),
      ),
       _isLoading ? Positioned.fill(child:  Container(
                    color:Colors.black45,
                    child: Center(
                      child:SpinKitCircle(color: miTema.accentColor),
                    ),
                  ),):Container()
        ],
      )
    );
  }

  

  _header(){
   return Container(  
      child: StreamBuilder(
        stream: trabajadorStream,
        builder: (BuildContext context, AsyncSnapshot snapshot){
           if (snapshot.hasData) {
            Trabajador trabajador = snapshot.data; 
            _trabajadorBloc.changeUrlImagen(trabajador.urlImagen);
            return  _datosUser(trabajador);
          }else { 
            return Center(child: CircularProgressIndicator());
          }
        },
      ),
    );
  }

  
  Widget _datosUser(Trabajador trabajador){
    return Stack(
      alignment: const Alignment(-1.0, -1.0),
      children: <Widget>[
      Container(
      margin: EdgeInsets.only(top:_responsive.ip(3)),
      width: double.infinity,
      child: ListTile(
        title:Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children:<Widget>[
            Column(
              children: <Widget>[
                _mostrarFoto(trabajador),

                (trabajador.nombre!=null && trabajador.ap!=null)
                  ?
                  Text("${trabajador.nombre} ${trabajador.ap}", style: TextStyle( fontFamily:'Quicksand',fontWeight: FontWeight.w900),)
                  :
                  Container(),
                SizedBox(
                  height: _responsive.ip(1),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children:<Widget>[
                  Icon(Icons.location_on,color:Colors.grey,size: _responsive.ip(2),),
                  SizedBox(width:_responsive.ip(1)),
                  (trabajador.direccion!=null)
                  ?
                  Container(
                    width: _responsive.ip(22),
                    child: Text("${trabajador.direccion}",overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: TextStyle(fontSize: _responsive.ip(1.2), fontFamily:'Quicksand',fontWeight: FontWeight.w900,color: Colors.grey),),
                  )
                  :
                  Container()
                  ]
                )
              ],
            ),
          ]
        ), 
        trailing: IconButton(
          icon:Icon(LineIcons.ellipsis_v,size: _responsive.ip(3),color: Colors.black,) , 
          onPressed: ()=> _settingModalBottomSheet(context,trabajador),
      ),
     )

     ),
     Container(
       child: IconButton(
         icon: Icon(LineIcons.angle_left, color: MyColors.GreyIcon),
         onPressed: ()=>Navigator.pop(context),
       ),
     )
      ],
    );
  }  


  _mostrarFoto(Trabajador trabajador){
    if(trabajador.urlImagen == null || trabajador.urlImagen == ""){      
      return  SvgPicture.asset('assets/icons/user.svg',                  
          height: _responsive.ip(10));
    }else {   
    return Container( 
          child:  ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: _responsive.ip(10),
              width:_responsive.ip(10),
              child: FadeInImage(
              image: NetworkImage(trabajador.urlImagen),
              placeholder: AssetImage('assets/jar-loading.gif'), 
              fit: BoxFit.fill,
             ),
            ),
          )
     );
    }
 } 
  Widget _options() {
    return FutureBuilder(
      future:options,
      initialData: [],
      builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
      return Column(
        children: _listItems(snapshot.data),
      );
      },
    );

    
  }

  List<Widget> _listItems(List<dynamic> data){
    final List<Widget> opciones=[];
    data.forEach((opt){
      final widgetTemp = 
      Container(
        
        padding: EdgeInsets.symmetric(horizontal:5),    
        child:  ListTile(
        title:  Text(opt['texto'],
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                    fontSize: _responsive.ip(1.8)
                  ),
                  ),
        subtitle: Text(opt['subtitulo'],
                  style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w600,
                    fontSize: _responsive.ip(1.3)
        ),),
        leading: getIcon(opt['icon'],_responsive, Colors.grey),
        trailing:opt['texto']=='Notificaciones'? 
            Icon(_switch, size: 40,color:miTema.primaryColor) 
            : Icon(LineIcons.angle_right,color:Colors.grey),
        onTap: (){
          _opciones(opt['ruta']);
        },
      )
      );

      opciones..add(widgetTemp)..add(Container(
      padding: EdgeInsets.symmetric(horizontal:5),  
                      height: 2,
                      color: Color(0xFFEEEEEE),
                    ),);//..add(Divider());
    });
    return opciones;
  } 

  _notifications()async{


    
      _blockCheck=!_blockCheck;

      if(_blockCheck){
        _switch = LineIcons.toggle_on;
        
        await fcm.subscribeToTopic(_storage.numberPhone);
        if(_storage.rolPersonal==AppConfig.rol_admin){
          await fcm.subscribeToTopic(AppConfig.fcm_topic_admin);
           await fcm.subscribeToTopic(AppConfig.fcm_topic_employee);
        }else if(_storage.rolPersonal == AppConfig.rol_empleado){
          await fcm.subscribeToTopic(AppConfig.fcm_topic_employee);
        }
      }else{
          print("DESACTIVAD**");
        _disableNotification();
      }
      //     _blockCheck?
      //     print("Activado")
      //   :
     
     setState(() {
     });
  }

  _disableNotification(){
    _showDialog();
  }

  _logOut()async{
    if(_isLoading)return;
    setState(() {
        _isLoading=true;
        //_statusBar();
    });

    Map info = await userProvider.logout();
    setState(() {
      _isLoading=false;
    });

    if(info['ok']){
      //inicio de sesión
      Navigator.pushReplacementNamed(context, 'login_phone');
     //Navigator.pop(context);
    }else{
      print("ERROR LOGOUT");
    }
  } 
  _opciones(String route){
    switch (route) {
        case 'notificaciones':  
          _notifications();
        break;
        case 'logout':
          _logOut();
        break;
        default:
        Navigator.pushNamed(context, route);
    }
  }

  void _settingModalBottomSheet(context,trabajador){
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: new Wrap(
          children: <Widget>[
            new ListTile(
              leading: new Icon(LineIcons.edit),
              title: new Text('Editar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
              onTap: () { 
                 _procesarImagen(trabajador);  
                Navigator.pop(context);
              },
            ),
            ],
           ),
        );
      }
    );
  } 

  _procesarImagen(Trabajador user) async{
    final _picker = ImagePicker();
    final pickedFile = await _picker.getImage(source: ImageSource.gallery);
    foto = File(pickedFile.path);

    if(foto != null){ 
      user.urlImagen = null; //limpieza para redibujar la nueva foto
    }  
    setState(() {
     _guardarImagen(user);  
    }); 
  }

  _guardarImagen(Trabajador user) async{ 

    if (foto != null) {
      
      setState(() {
        _isLoading=true;
      });

      urlImagen = await _trabajadorService.subirFoto(foto);
      print("++++++++++++++++++++++++++++");
      print(urlImagen); 
      _trabajadorBloc.changeUrlImagen(urlImagen);
      _trabajadorService.updatePhoto(_trabajadorBloc.urlImagen); 

       setState(() {
        _isLoading=false;
      });
       
    }
    
  }

   void _showDialog() {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Notificaciones",
            style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w900),),
          content: new Text("¿Estas seguro de desactivar las notificaciones?",
            style: TextStyle(fontFamily:'Quicksand',fontWeight:FontWeight.w500),
          ),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Aceptar",style: TextStyle(color:miTema.accentColor),),
              onPressed: ()async {
                
               
                // await fcm.unsubscribeFromTopic( _storage.numberPhone);
                // await fcm.unsubscribeFromTopic(AppConfig.rol_empleado);
                // if(_storage.rolPersonal==AppConfig.rol_admin){
                //   await fcm.unsubscribeFromTopic(AppConfig.fcm_topic_admin);
                // }
                _switch = LineIcons.toggle_off;
                 
                Navigator.of(context).pop();

                setState(() {
                  
                });


              },
            ),

            new FlatButton(
              child: new Text("Cancelar",style: TextStyle(color:miTema.accentColor)),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}