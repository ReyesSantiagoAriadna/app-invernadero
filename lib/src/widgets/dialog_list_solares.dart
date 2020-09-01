import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class DialogListSolares extends StatefulWidget {
  final SolarCultivoBloc solarCultivoBloc;

  const DialogListSolares({Key key,@required this.solarCultivoBloc}) : super(key: key);
  
  @override
  _DialogListSolaresState createState() => _DialogListSolaresState();
}

class _DialogListSolaresState extends State<DialogListSolares> {
  int _radioValue=-1;
  List<Solar> solaresList;
  
  @override
  void initState() {
    
    solaresList =  Provider.of<SolarCultivoService>(context,listen: false).solarList;
    if(widget.solarCultivoBloc.solarActive!=null){
      Solar s = widget.solarCultivoBloc.solarActive;
      _radioValue = solaresList.indexWhere((solar)=>solar==s);
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
      title: new Text("Solar",
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
            Solar solarActive = solaresList[_radioValue];
            widget.solarCultivoBloc.changeSolarActive(solarActive);
            final cultivos = solarActive.cultivos;
           if(cultivos!=null && cultivos.isNotEmpty)
              widget.solarCultivoBloc.changeCultivoActive(cultivos[0]);
            else
              widget.solarCultivoBloc.changeCultivoActive(null);

            // widget.solarCultivoBloc.changeCultivoLiActiv(solarActive.cultivos);
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
    solaresList.forEach((r){
    
      final solar =  ListTile(
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
      list.add(solar);
    });
    return list;
  }
}