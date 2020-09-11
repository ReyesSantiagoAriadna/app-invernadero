
import 'package:app_invernadero_trabajador/src/blocs/actividad_tarea_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/pedido/pedido_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/productos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/services/pedidos/pedidos_service.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/widgets/loading_bottom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectProductos extends StatefulWidget {
  final PedidoBloc pedidoBloc;

  const SelectProductos({Key key, this.pedidoBloc}) : super(key: key);


  
  @override
  _SelectProductosState createState() => _SelectProductosState();
}

class _SelectProductosState extends State<SelectProductos> {
  ScrollController _scrollController;
  bool _isLoading =false;
  
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener((){
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
          setState(() {
          _isLoading=true;
          });
           Provider.of<ProductosService>(context,listen: false)
           .getProductos()
           .then((v){
              if(mounted){
                setState(() {
                  _isLoading=false;
                });
              if(v){
                _scrollController.animateTo(
                _scrollController.position.pixels +100,
                  duration: Duration(milliseconds:250), 
                  curve: Curves.fastOutSlowIn);
              }
             }
           });
        }
    });   
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
  
    super.didChangeDependencies();
  }

 
  @override
  Widget build(BuildContext context) {
    return _herramientas();
  }

  _herramientas(){
    return AlertDialog(
      elevation: 0.0,
      title: new Text("Productos",
        style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w900),),
      content: Container(
         height: 200,
        child: Stack(
          children: <Widget>[
            Positioned(child: Container(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                child: Column(
                children: 
                _options()
                ),
              ),
            ),),
            Positioned(child:  LoadingBottom(isLoading:_isLoading),)
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Aceptar",style: TextStyle(color:miTema.accentColor),),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
  _options(){
    List<Widget> list = [];
    Provider.of<ProductosService>(context,listen: false).productos.forEach((h){
      final item = new CheckboxListTile(
            title: Text(h.nombre),
            value: h.isSelect,
            onChanged: (bool value) {
              setState(() {
                h.isSelect = value;
              });
              if(h.isSelect){
                //add list
                widget.pedidoBloc.addProducto(h);
              }else{
                //remove list
                widget.pedidoBloc.deleteProducto(h);
              }
            },
          );
      list.add(item);
    });
    return list;
  }
}