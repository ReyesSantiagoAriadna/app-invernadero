import 'dart:convert';

import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/regiones.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogListDistrito extends StatefulWidget {
  final SolarCultivoBloc solarCultivoBloc;

  const DialogListDistrito({Key key,@required this.solarCultivoBloc}) : super(key: key);
  
  @override
  _DialogListDistritoState createState() => _DialogListDistritoState();
}

class _DialogListDistritoState extends State<DialogListDistrito> {
  int _radioValue=-1;
  List<Distrito> distritosList;

  @override
  void initState() {
    if(widget.solarCultivoBloc.regionActive!=null){
      distritosList =  widget.solarCultivoBloc.regionActive.distritos;

      if(widget.solarCultivoBloc.distritoActive!=null){
        Distrito d = widget.solarCultivoBloc.distritoActive;
        _radioValue = distritosList.indexWhere((distrito)=>distrito==d);
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
  }

  @override
  Widget build(BuildContext context) {
    return _solares();
  }

  _solares(){
    return AlertDialog(
      elevation: 0.0,
      title: new Text("Distritos",
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
            Distrito distrito = distritosList[_radioValue];
            widget.solarCultivoBloc.changeDistritoActive(distrito);
              List<String> municipios = distrito.municipios;
              if(municipios!=null && municipios.isNotEmpty){
                widget.solarCultivoBloc.changeMunicipioActive(municipios[0]);
              }else
                widget.solarCultivoBloc.changeMunicipioActive(null); 
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
    distritosList.forEach((f){
      final distrito =  ListTile(
        onTap: (){ 
        },
        dense: false,
        leading: new Radio(
          activeColor: miTema.accentColor,
          value: value,
          groupValue:  _radioValue,
          onChanged: _handleRadioValueChange,
        ),
        title: Text(f.distrito),
      );
      value++;
      list.add(distrito);
    });


    return list;
  }
}