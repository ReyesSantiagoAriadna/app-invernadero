import 'package:app_invernadero_trabajador/src/blocs/ofertaBloc/oferta_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/productosBloc/producto_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/productos/producto.dart';
import 'package:app_invernadero_trabajador/src/services/ofertaService/ofertas_service.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class DialogListProductos extends StatefulWidget {
  final ProductoBloc productoBloc;

  const DialogListProductos({Key key,@required this.productoBloc}) : super(key: key);
  @override
  _DialogListProductosState createState() => _DialogListProductosState();
}

class _DialogListProductosState extends State<DialogListProductos> {
  int _radioValue = -1;
  List<Producto> productoLits;

  @override
  void initState() {
    productoLits = Provider.of<OfertaService>(context,listen: false).productosList;
    if(widget.productoBloc.productoActive != null){
      Producto prod = widget.productoBloc.productoActive;
      _radioValue = productoLits.indexWhere((producto)=>producto==prod);
    }
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
  }

  void _handleRadioValueChange(int value) {
    print("value $value");
    setState(() {
      _radioValue = value;
    });
    setState(() {
      print("cambiando de unidad");
    });
  }

  @override
  Widget build(BuildContext context) {
    return _productos();
  }

  _productos(){
      return AlertDialog(
      elevation: 0.0,
      title: new Text("Productos",
        style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w900),),
      content: Container(
        height: 150,
        width: 70,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
          children:_options()
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Aceptar",style: TextStyle(color:miTema.accentColor),),
          onPressed: () {
            if(_radioValue != -1){
              Producto prodActive = productoLits[_radioValue];
              widget.productoBloc.changeProductoActive(prodActive); 
              Navigator.of(context).pop();
            }
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
  }
  _options(){
    List<Widget> list = [];
    int value = 0;
    productoLits.forEach((r){
    
      final producto =  ListTile(
        onTap: (){
         
        },
        dense: false,
        leading: new Radio(
          activeColor: miTema.accentColor,
          value: value,
          groupValue:  _radioValue,
          onChanged: _handleRadioValueChange,
        ),
        title: Text(r.nombre),
      );
      value++;
      list.add(producto);
    });
    if(list.isEmpty){
      final empty = ListTile(
        dense: false,
        leading: Icon(LineIcons.close),
        title: Text("No hay productos"),
      );
      list.add(empty);
    }
    return list;
  }
  
}