import 'package:app_invernadero_trabajador/src/blocs/actividad_tarea_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/page_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/pedido/pedido_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/pedidos/pedido_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/pages/actividades/tareas/tarea_widget.dart';
import 'package:app_invernadero_trabajador/src/pages/pedidos/pedido_widget.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/solar_widget.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/services/pedidos/pedidos_service.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';



class PedidosHomePage extends StatefulWidget {
  PedidosHomePage({Key key}) : super(key: key);

  @override
  _PedidosHomePageState createState() => _PedidosHomePageState();
}

class _PedidosHomePageState extends State<PedidosHomePage> {
  PageBloc _pageBloc;
  // Stream<List<Pedido>> tareasStream;
  ScrollController _hideButtonController;
  bool _isVisible;
  PedidoBloc pedidoBloc = PedidoBloc();

  bool _isLoading=false;


  @override
  void initState() {
    _pageBloc = PageBloc();
    _hideButtonController  = _pageBloc.scrollCont;
    super.initState();
    _isVisible = true;
    _hideButtonController.addListener((){
      if(_hideButtonController.position.userScrollDirection == ScrollDirection.reverse){
        if(_hideButtonController.position.pixels==_hideButtonController.position.maxScrollExtent){
          print("final**********");
        
          setState(() {
          _isLoading=true;
          });
          
           Provider.of<PedidosService>(context,listen: false)
           .getPedidos()
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
  void dispose() {
    //_hideButtonController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // _solarCultivoBloc = SolarCultivoBloc();
    // _solarCultivoBloc.solares();
  //  if(tareasStream==null)
  //   tareasStream = Provider.of<TareasService>(context).tareasStream;

    super.didChangeDependencies();
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
                      child: Container(
              margin:EdgeInsets.only(left:8,right: 8),
              child: StreamBuilder(
                stream: Provider.of<PedidosService>(context).pedidosStream,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    List<Pedido> pedidos = snapshot.data;
                    return ListView.builder(
                      controller: _pageBloc.scrollCont,
                      physics: BouncingScrollPhysics(),
                      itemCount: pedidos.length,
                      itemBuilder: (BuildContext context, int index) {
                      return PedidoWidget(pedido:pedidos[index],pedidoBloc: pedidoBloc,);
                     },
                    );
                  }
                  return Container(
                  );
                },
              ),
            ),
          ),

         Positioned(child:  _createLoading(),)
        ],
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
              child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'pedido_agendar');
          },
          child: Icon(LineIcons.plus),
          backgroundColor: miTema.accentColor,
        ),
      ),
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
}