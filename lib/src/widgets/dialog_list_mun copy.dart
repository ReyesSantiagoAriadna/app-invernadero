import 'dart:convert';

import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/regiones.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class DialogListMunicipio extends StatefulWidget {
  final SolarCultivoBloc solarCultivoBloc;
  const DialogListMunicipio({Key key,@required this.solarCultivoBloc}) : super(key: key);
  
  @override
  _DialogListMunicipioState createState() => _DialogListMunicipioState();
}

class _DialogListMunicipioState extends State<DialogListMunicipio> {
  int _radioValue=-1;
  List<String> municipiosList=[];

  @override
  void initState() {
    if(widget.solarCultivoBloc.regionActive!=null){
      if(widget.solarCultivoBloc.distritoActive!=null){
        if( widget.solarCultivoBloc.municipioActive!=null && 
            widget.solarCultivoBloc.distritoActive.municipios!=null &&
            widget.solarCultivoBloc.distritoActive.municipios.isNotEmpty
        ){
          municipiosList = widget.solarCultivoBloc.distritoActive.municipios;
          String municipio = widget.solarCultivoBloc.municipioActive;
          _radioValue = municipiosList.indexWhere((m)=>m==municipio);
        }
      }
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
    return _solares();
  }

  _solares(){
    return AlertDialog(
      elevation: 0.0,
      title: new Text("Municipios",
        style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w900),),
      content: Container(
        height: 150,
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
            String municipio = municipiosList[_radioValue];
            widget.solarCultivoBloc.changeMunicipioActive(municipio);

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
    municipiosList.forEach((f){
      final municipio =  ListTile(
        onTap: (){ 
        },
        dense: false,
        leading: new Radio(
          activeColor: miTema.accentColor,
          value: value,
          groupValue:  _radioValue,
          onChanged: _handleRadioValueChange,
        ),
        title: Text(f),
      );
      value++;
      list.add(municipio);
    });

    if(list.isEmpty){
      final empty = ListTile(
        dense: false,
        leading: Icon(LineIcons.close),
        title: Text("No hay datos"),
      );
      list.add(empty);
    }

    return list;
  }
}