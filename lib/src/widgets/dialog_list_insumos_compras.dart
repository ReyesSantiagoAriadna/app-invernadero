import 'package:app_invernadero_trabajador/src/blocs/insumos/compra_insumo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/insumos/insumo.dart';
import 'package:app_invernadero_trabajador/src/services/insumosService/insumos_service.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/widgets/loading_bottom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogInsumosCompras extends StatefulWidget {
  final CompraInsumoBloc compraInsumoBloc;
  
  const DialogInsumosCompras({Key key, this.compraInsumoBloc}) : super(key: key);
  
  @override
  _DialogInsumosComprasState createState() => _DialogInsumosComprasState();
}

class _DialogInsumosComprasState extends State<DialogInsumosCompras> {
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
           Provider.of<InsumoService>(context,listen: false)
           .fetchInsumosSelect()
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
    return _insumos();
  }

  _insumos(){
    return AlertDialog(
      elevation: 0.0,
      title: new Text("Insumos",
        style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w900),),
      content: Container(
        //  height: 150,
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
    Provider.of<InsumoService>(context,listen: false).insumoSelect.forEach((i){
      final item = new CheckboxListTile(
            title: Text(i.nombre),
            value: i.isSelect,
            onChanged: (bool value) {
              setState(() {
                i.isSelect = value;
              });
              if(i.isSelect){
                //add list
                Insumo copia = i;
                i.amountOnTask=1;
                widget.compraInsumoBloc.addInsumo(copia);
              }else{
                //remove list
                i.amountOnTask=0;
                widget.compraInsumoBloc.deleteInsumo(i);
              }
            },
          );
      list.add(item);
    });
    return list;
  }
}