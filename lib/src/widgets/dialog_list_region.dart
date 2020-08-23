import 'dart:convert';

import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/regiones.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogListRegion extends StatefulWidget {
  final SolarCultivoBloc solarCultivoBloc;

  const DialogListRegion({Key key,@required this.solarCultivoBloc}) : super(key: key);
  
  @override
  _DialogListRegionState createState() => _DialogListRegionState();
}

class _DialogListRegionState extends State<DialogListRegion> {
  int _radioValue=-1;
  List<Region> regionesList;

  @override
  void initState() {

    regionesList =  Provider.of<SolarCultivoService>(context,listen: false).regionList;

  
    if(widget.solarCultivoBloc.regionActive!=null){
      Region r = widget.solarCultivoBloc.regionActive;
      _radioValue = regionesList.indexWhere((region)=>region==r);
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
      title: new Text("Regiones",
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
            Region region = regionesList[_radioValue];
            widget.solarCultivoBloc.changeRegionActive(region);
            final distritos = region.distritos;

            if(distritos!=null && distritos.isNotEmpty){
              widget.solarCultivoBloc.changeDistritoActive(distritos[0]);
              List<String> municipios = distritos[0].municipios;

              if(municipios!=null && municipios.isNotEmpty){
                widget.solarCultivoBloc.changeMunicipioActive(distritos[0].municipios[0]);
              }else{
                widget.solarCultivoBloc.changeMunicipioActive(null);
              }
            }
            else{
              widget.solarCultivoBloc.changeDistritoActive(null);
              widget.solarCultivoBloc.changeMunicipioActive(null);
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

    regionesList.forEach((f){
      print(f.region);

      final region =  ListTile(
        onTap: (){ 
        },
        dense: false,
        leading: new Radio(
          activeColor: miTema.accentColor,
          value: value,
          groupValue:  _radioValue,
          onChanged: _handleRadioValueChange,
        ),
        title: Text(f.region),
      );
      value++;
      list.add(region);
    });


    return list;
  }
}