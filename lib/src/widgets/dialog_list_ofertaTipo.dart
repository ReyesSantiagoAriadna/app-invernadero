import 'package:app_invernadero_trabajador/src/blocs/ofertaBloc/oferta_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/ofertas/ofertaTipo.dart';
import 'package:app_invernadero_trabajador/src/services/ofertaService/ofertas_service.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class DialogListOfertaTipo extends StatefulWidget {
  final OfertaBloc ofertaBloc;

  const DialogListOfertaTipo({Key key,@required this.ofertaBloc}) : super(key: key);

  @override
  _DialogListOfertaTipoState createState() => _DialogListOfertaTipoState();
}

class _DialogListOfertaTipoState extends State<DialogListOfertaTipo> {
  int _radioValue=-1;
  List<OfertaTipo> ofertaTipoList;
  OfertaBloc ofertaBloc;

  @override
  void initState() { 
    ofertaTipoList = Provider.of<OfertaService>(context,listen: false).ofertaTipoList;
    print("%%%%%%%%%%%%%%");
    print(ofertaTipoList.length);
    if( widget.ofertaBloc.tipoActive != null){
      OfertaTipo of = widget.ofertaBloc.tipoActive;
      _radioValue = ofertaTipoList.indexWhere((tipo)=>tipo==of);
    }
    super.initState();
  }

  @override
  void didChangeDependencies() { 
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
    return _tiposOfertas();
  }

  _tiposOfertas(){
     return AlertDialog(
      elevation: 0.0,
      title: new Text("Tipos de oferta",
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
              OfertaTipo tipoActive = ofertaTipoList[_radioValue];
              widget.ofertaBloc.changeTipoActive(tipoActive); 
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
    ofertaTipoList.forEach((r){
    
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
        title: Text(r.tipo),
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