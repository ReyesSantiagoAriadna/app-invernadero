import 'dart:convert';

import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/etapa_cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/regiones.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class DialogEtapa extends StatefulWidget {
  final SolarCultivoBloc solarCultivoBloc;
  const DialogEtapa({Key key,@required this.solarCultivoBloc}) : super(key: key);
  
  @override
  _DialogEtapaState createState() => _DialogEtapaState();
}

class _DialogEtapaState extends State<DialogEtapa> {
  

  @override
  void initState() {
    
    super.initState();
  }

  @override
  void didChangeDependencies() {
  
    super.didChangeDependencies();
  }

  
  @override
  Widget build(BuildContext context) {
    return _solares();
  }

  _solares(){
    return AlertDialog(
      elevation: 0.0,
      title: new Text("Etapa",
        style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w900),),
      content: Container(
        height: 200,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
          children: <Widget>[
            _inputNombre(),
            SizedBox(height:10),
            _inputDias()
            
            
          ],
          ),
        ),
      ),
      actions: <Widget>[
        StreamBuilder<Object>(
          stream: widget.solarCultivoBloc.formEtapaValidStream,
          builder: (context, snapshot) {
            return new FlatButton(
              child: new Text("Agregar",style: TextStyle(color:miTema.accentColor),),
              onPressed: snapshot.hasData?_addEtapa:null,
            );
          }
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

  _addEtapa(){
    Etapa etapa = Etapa(
      
      nombre: widget.solarCultivoBloc.etapaNombre,
      dias: int.parse(widget.solarCultivoBloc.etapaDias),
    );
    
    etapa.uniqueKey = UniqueKey().toString();
    widget.solarCultivoBloc.addEtapa(etapa);

    Navigator.of(context).pop();
  }
  _inputNombre(){
    return StreamBuilder(
      stream: widget.solarCultivoBloc.etapaNombreStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return  TextFormField(
          decoration: InputDecoration(
            focusedBorder:  UnderlineInputBorder(      
                      borderSide: BorderSide(color:miTema.accentColor)),
            icon: Icon(LineIcons.sitemap ,color: MyColors.GreyIcon),
            labelText: 'Nombre', 
            errorText: snapshot.error =='*' ? null:snapshot.error,
          ),
          onChanged: widget.solarCultivoBloc.onChangeEtapaNombre,
          
        );
        }
    );
  }
  
  _inputDias(){
    return StreamBuilder(
      stream: widget.solarCultivoBloc.etapaDiasStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return  TextFormField(
          decoration: InputDecoration(
            focusedBorder:  UnderlineInputBorder(      
                      borderSide: BorderSide(color:miTema.accentColor)),
            icon: Icon(LineIcons.calendar,color: MyColors.GreyIcon),
            labelText: 'Dias', 
            errorText: snapshot.error =='*' ? null:snapshot.error,
          ),
          onChanged: widget.solarCultivoBloc.onChangeEtapaDias,
          
        );
        }
    );
  }
  @override
  void dispose() {
    super.dispose();
    widget.solarCultivoBloc.resetEtapa();
  }
}