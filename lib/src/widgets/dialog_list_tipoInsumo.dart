import 'package:app_invernadero_trabajador/src/blocs/insumos/insumos_bloc.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class DialogListInsumoTipo extends StatefulWidget {
  final InsumosBloc insumosBloc;
  const DialogListInsumoTipo({Key key,@required this.insumosBloc}) : super(key: key);
   
  @override
  _DialogListInsumoTipoState createState() => _DialogListInsumoTipoState();
}

class _DialogListInsumoTipoState extends State<DialogListInsumoTipo> {
  int _radioValue=-1;
  List<String> insumoTipoList; 

  @override
  void initState() {
    insumoTipoList = ['Abono','Fertilizante','Semilla','Plantula'];
    if(widget.insumosBloc.tipoActive != null){
      String t = widget.insumosBloc.tipoActive;
      _radioValue = insumoTipoList.indexWhere((tipo)=>tipo==t);
    }
    super.initState();
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
    return _tipoInsumo();
  }

  _tipoInsumo(){
       return AlertDialog(
      elevation: 0.0,
      title: new Text("Tipos de insumos",
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
              String tipoActive = insumoTipoList[_radioValue];
              widget.insumosBloc.changeTipoActive(tipoActive); 
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
    insumoTipoList.forEach((r){
    
      final tipo =  ListTile(
        onTap: (){
         
        },
        dense: false,
        leading: new Radio(
          activeColor: miTema.accentColor,
          value: value,
          groupValue:  _radioValue,
          onChanged: _handleRadioValueChange,
        ),
        title: Text(r),
      );
      value++;
      list.add(tipo);
    });
    if(list.isEmpty){
      final empty = ListTile(
        dense: false,
        leading: Icon(LineIcons.close),
        title: Text("No hay tipos"),
      );
      list.add(empty);
    }
    return list;
  }
}