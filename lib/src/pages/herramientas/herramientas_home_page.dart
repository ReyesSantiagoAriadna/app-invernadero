

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/inventarioBloc/inventario_bloc.dart'; 
import 'package:app_invernadero_trabajador/src/blocs/page_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/inventario_herramientas/herramienta.dart';
import 'package:app_invernadero_trabajador/src/services/inventarioService/inventario_service.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/my_alert_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class HerramientasHomePage extends StatefulWidget {
  @override
  _HerramientasHomePageState createState() => _HerramientasHomePageState();
}

class _HerramientasHomePageState extends State<HerramientasHomePage> {
  Stream<List<Herramienta>> herramientaStream;
  Responsive _responsive;
  TextStyle _style,_styleSub;
  ScrollController _hideButtonController;
  bool _isVisible;
  PageBloc _pageBloc;
  InventarioBloc inventarioBloc;
  bool _isLoading=false;

  @override
  void initState() { 
    super.initState();
    _pageBloc = PageBloc();
    _hideButtonController  = _pageBloc.scrollCont;

     _isVisible = true;
     
     _hideButtonController.addListener((){
      if(_hideButtonController.position.userScrollDirection == ScrollDirection.reverse){
        if(_hideButtonController.position.pixels==_hideButtonController.position.maxScrollExtent){
          print("final**********");
        
          setState(() {
          _isLoading=true;
          });

           Provider.of<InventarioService>(context,listen: false)
           .fetchHerramientas()
           .then((v){
              if(mounted){
              setState(() {
                _isLoading=false;
              });

              
              if(v){
                _hideButtonController.animateTo(
                  _hideButtonController.position.pixels +100,
                   duration: Duration(milliseconds:250), 
                   curve: Curves.fastOutSlowIn);
              }
             }
           });
        }
        if(_isVisible == true) {
            
            if(mounted){
              setState((){
              _isVisible = false;
            });
            }
        }
      } else {
        if(_hideButtonController.position.userScrollDirection == ScrollDirection.forward){
          if(_isVisible == false) {
               if(mounted){
                 setState((){
                 _isVisible = true;
               });
               }
           }
        }
    }});
  }

  @override
  void didChangeDependencies() { 
    super.didChangeDependencies();
    _responsive = Responsive.of(context);

    herramientaStream = Provider.of<InventarioService>(context).herramientaStream;
    inventarioBloc = new InventarioBloc();
  
  }

  @override
  Widget build(BuildContext context) {
     _style = TextStyle(color:Colors.black,fontFamily: AppConfig.quicksand,fontSize: _responsive.ip(2.0));
    _styleSub = TextStyle(color:Colors.black,fontFamily: AppConfig.quicksand,fontSize:_responsive.ip(1.5));
  
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
            margin: EdgeInsets.only(left:8,right: 8),
            child: StreamBuilder(
              stream: herramientaStream,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  List<Herramienta> herramienta = snapshot.data; 
                  return ListView.builder(
                    controller: _pageBloc.scrollCont,
                    physics: BouncingScrollPhysics(),
                    itemCount: herramienta.length,
                    itemBuilder: (context, i) => _crearItem(context, herramienta[i]),
                  );
                }
                return Container(
                );
              },
            ),
          ),      
          ),
          Positioned(child: _createLoading())
        ],
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context,'herramienta_add');
          },
          child: Icon(LineIcons.plus),
          backgroundColor: miTema.accentColor,
        ),
      )
    ); 
  }

  _createLoading(){
    if(_isLoading){
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator()
            ],),
            SizedBox(height:15.0)
          ],
      );
     
    }
    return Container();
  }

  Widget _crearItem(BuildContext context, Herramienta herramienta){ 
    return Container(
      margin: EdgeInsets.only(top: 2, bottom:15),
      child: Column(
        children: <Widget>[
          Container(
            height: _responsive.ip(18),
            width: double.infinity,
            child: (herramienta.urlImagen == null)
            ? Image(image: AssetImage('assets/tools1.png'),fit: BoxFit.fitHeight ,)
            :FadeInImage(
               image: NetworkImage(herramienta.urlImagen),
               placeholder: AssetImage('assets/jar-loading.gif'), 
               height: double.infinity,
               width: double.infinity,
               fit: BoxFit.cover,
            ),
          ),

          Container(
             padding: EdgeInsets.all(4),
             width: double.infinity,
             child: Row(
               children: <Widget>[
               Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children:<Widget>[
                   Text('${herramienta.nombre }',style: _style, overflow: TextOverflow.ellipsis,),
                   Text('Cantidad: ${herramienta.cantidad}',style: _styleSub,),
                   Container(
                     width: 240, 
                     child: 
                      Text('Descripción: ${herramienta.descripcion}',
                      style: TextStyle(color:Colors.grey,fontFamily: AppConfig.quicksand,fontSize:_responsive.ip(1.4)),
                      overflow: TextOverflow.ellipsis,),
                   ) 
                 ]
               ), 

                
                Expanded(child: Container()),

                Stack(
                  children: <Widget>[
                    Row( 
                      children: <Widget>[
                        IconButton(icon:  Icon(LineIcons.pencil,color: MyColors.GreyIcon,), 
                        onPressed: () => Navigator.pushNamed(context, 'herramienta_edit',arguments: herramienta)
                        ),
                        IconButton(icon: Icon(LineIcons.trash, color: MyColors.GreyIcon,),
                        onPressed: ()=> _deleteModalBottomSheet(context, herramienta.id),
                        )
                      ],
                    )
                     
                  ],
                ), 
                                           
               ],
             )
          ),        
        ],
      ),
       decoration: BoxDecoration(
         color : Colors.white,
         borderRadius: BorderRadius.circular(5.0),
         boxShadow: <BoxShadow>[
            BoxShadow(                  
              color:Colors.black26,
              blurRadius: 3.0,
              offset : Offset(0.0,3),
              spreadRadius: 3.0
            )
        ]
      ),
    );
  }

  void _deleteModalBottomSheet(context, int idHerramienta)async{
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: new Wrap(
          children: <Widget>[ 
            new ListTile(
              leading: new Icon(LineIcons.trash_o),
              title: new Text('Eliminar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
              onTap: (){
                showMyDialog(context, 
                  'Eliminar herramienta', 
                  '¿Estas seguro de eliminar la herramienta?', 
                  ()=> Provider.of<InventarioService>(context, listen: false)
                    .deleteHerramientas(idHerramienta)
                    .then((r){
                      Flushbar(
                      message:  Provider.of<InventarioService>(context,listen: false).response,
                      duration:  Duration(seconds: 2),              
                    )..show(context).then((r){
                      Navigator.pop(context);
                    });
                    })
                );
              },
            ),
            ],
           ),
        );
      }
    );
  } 
}