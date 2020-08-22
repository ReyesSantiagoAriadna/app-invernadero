import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class DialogListCultivo extends StatefulWidget {
  final SolarCultivoBloc solarCultivoBloc;

  const DialogListCultivo({Key key,@required this.solarCultivoBloc}) : super(key: key);
  
  @override
  _DialogListCultivoState createState() => _DialogListCultivoState();
}

class _DialogListCultivoState extends State<DialogListCultivo> {
  int _radioValue=-1;
  List<Cultivo> cultivosList;
  
  @override
  void initState() {
    
    // cultivos =  Provider.of<SolarCultivoService>(context,listen: false).solarList;
    cultivosList = widget.solarCultivoBloc.solarActive.cultivos;
    
    Cultivo cultivo = widget.solarCultivoBloc.cultivoActive;

    if(cultivo!=null  && cultivosList.contains(cultivo)){
      _radioValue = cultivosList.indexWhere((c)=>c==cultivo);
    }else{
      _radioValue = 0;
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
    });
  }

  @override
  Widget build(BuildContext context) {
    return _cultivos();
  }

  _cultivos(){
    return AlertDialog(
      elevation: 0.0,
      title: new Text("Cultivos",
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
            Cultivo cultivo = cultivosList[_radioValue];
            widget.solarCultivoBloc.changeCultivoActive(cultivo);
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
    cultivosList.forEach((r){
    
      final cultivo =  ListTile(
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
      list.add(cultivo);
    });
    if(list.isEmpty){
      final empty = ListTile(
        dense: false,
        leading: Icon(LineIcons.close),
        title: Text("No hay cultivos"),
      );
      list.add(empty);
    }
    return list;
  }
}