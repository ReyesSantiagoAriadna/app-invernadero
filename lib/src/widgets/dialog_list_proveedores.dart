import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/insumos/compra_insumo_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/insumos/insumos_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/proveedores/proveedor.dart';
import 'package:app_invernadero_trabajador/src/services/insumosService/insumos_service.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart'; 
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/input_select.dart';
import 'package:app_invernadero_trabajador/src/widgets/loading_bottom.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
 

class DialogListProveedores extends StatefulWidget {
  final CompraInsumoBloc compraInsumoBloc;
  final Responsive responsive;
  const DialogListProveedores({Key key, this.compraInsumoBloc, this.responsive}) : super(key: key);

  @override
  _DialogListProveedoresState createState() => _DialogListProveedoresState();
}

class _DialogListProveedoresState extends State<DialogListProveedores> {
  

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

  }
  @override
  Widget build(BuildContext context) {
    TextStyle _style = TextStyle(
      color: MyColors.GreyIcon,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: widget.responsive.ip(1.8)
    );
    return Container( 
      child: Column(
        children: <Widget>[
          Row(
            children: <Widget>[
              Icon(LineIcons.users, color: MyColors.GreyIcon,),
              SizedBox(width: 18),
              Text("Proveedor", style: _style,)
            ],
          ),
          SizedBox(height: 10,),
          StreamBuilder(
            stream: widget.compraInsumoBloc.proveedorActiveStream, 
            initialData: widget.compraInsumoBloc.proveedorActive!=null?widget.compraInsumoBloc.proveedorActive:null,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              Proveedor p;
              if(snapshot.hasData)
                p = snapshot.data;
              
              return GestureDetector( 
                onTap: (){
                showDialog(
                  context: context,
                  builder: (BuildContext context){
                    return DialogProveedor(compraInsumoBloc: widget.compraInsumoBloc);
                  });
                },
                child: InputSelect(text: snapshot.hasData?p.rs:"Elije el proveedor", responsive: widget.responsive),
              );
            },
          ),
        ],
      ),
    );
  }
}


class DialogProveedor extends StatefulWidget {
  final CompraInsumoBloc compraInsumoBloc;

  const DialogProveedor({Key key,@required this.compraInsumoBloc}) : super(key: key);
  
  @override
  _DialogProveedorState createState() => _DialogProveedorState();
}

class _DialogProveedorState extends State<DialogProveedor> {
  int _radioValue=-1;
  List<Proveedor> proveedoresList=[];
  ScrollController _scrollController;
  bool _isLoading =false;

  @override
  void initState() {
   proveedoresList = Provider.of<InsumoService>(context,listen: false).proveedorList;
    if(widget.compraInsumoBloc.proveedorActiveStream!=null){
      Proveedor p =  widget.compraInsumoBloc.proveedorActive;
      _radioValue = proveedoresList.indexWhere((i)=>i==p);
    }

    
    _scrollController = ScrollController();
    _scrollController.addListener((){
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
          setState(() {
          _isLoading=true;
          });
           Provider.of<InsumoService>(context,listen: false)
           .fetchProveedores()
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

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return _proveedores();
  }

  _proveedores(){
 return AlertDialog(
      elevation: 0.0,
      title: new Text("Proveedores",
        style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w900),),
      content: Container(
        height: 300,
        child: Stack(
          children: <Widget>[
            Positioned(child: Container(
              child:  SingleChildScrollView(
              controller: _scrollController,
              physics: BouncingScrollPhysics(),
              child: Column(
              children:_options()
              ),
            ),
            )),
            Positioned(child:  LoadingBottom(isLoading:_isLoading),)
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Aceptar",style: TextStyle(color:miTema.accentColor),),
          onPressed: () {
              if(proveedoresList.isNotEmpty){
                Proveedor item = proveedoresList[_radioValue];
                widget.compraInsumoBloc.changeProvActive(item);
              } 
            Navigator.of(context).pop();
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
    proveedoresList.forEach((r){
      final item = 
      RadioListTile(
        title: Text(r.rs),
        dense: false,
        activeColor: miTema.accentColor,
        value: value, 
        groupValue: _radioValue, 
        onChanged: _handleRadioValueChange);
      value++;
      list.add(item);
    });
    return list;
  }
}