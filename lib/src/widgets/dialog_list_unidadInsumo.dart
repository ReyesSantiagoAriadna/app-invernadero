import 'package:app_invernadero_trabajador/src/blocs/insumos/insumos_bloc.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class DialogListUnidadInsumo extends StatefulWidget {
  final InsumosBloc insumosBloc;
  const DialogListUnidadInsumo({Key key,@required this.insumosBloc}) : super(key: key);
  
  @override
  _DialogListUnidadInsumoState createState() => _DialogListUnidadInsumoState();
}

class _DialogListUnidadInsumoState extends State<DialogListUnidadInsumo> {
  int _radioValue=-1;
  List<String> unidadList=['Gramos','Mililitros','kilo','Costal','Pieza']; 

  @override
  void initState() { 
    if(widget.insumosBloc.unidadActive != null){
      String t = widget.insumosBloc.unidadActive;
      _radioValue = unidadList.indexWhere((uni)=>uni==t);
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
    return _unidadInsumo();
  }

  _unidadInsumo(){
       return AlertDialog(
      elevation: 0.0,
      title: new Text("Tipos de unidad",
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
              String uniActive = unidadList[_radioValue];
              widget.insumosBloc.changeUnidadActive(uniActive); 
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
    unidadList.forEach((r){
    
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
        title: Text("No hay unidades"),
      );
      list.add(empty);
    }
    return list;
  }
}