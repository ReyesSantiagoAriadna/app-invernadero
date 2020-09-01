import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class DialogListTipoCultivo extends StatefulWidget {
  final SolarCultivoBloc solarCultivoBloc;
  const DialogListTipoCultivo({Key key,@required this.solarCultivoBloc}) : super(key: key);
  @override
  _DialogListTipoCultivoState createState() => _DialogListTipoCultivoState();
}

class _DialogListTipoCultivoState extends State<DialogListTipoCultivo> {
  int _radioValue=-1;
  List<String> tiposList=['DialogListTipoCultivo','MacroTunel','MicroTunel',
  'Campo Abierto','Invernadero','Hidroponia','Frutales'];

  @override
  void initState() {
    
    if(widget.solarCultivoBloc.cultivoTipo!=null){
      String tipo = widget.solarCultivoBloc.cultivoTipo;
      _radioValue = tiposList.indexWhere((t)=>t==tipo);
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
      title: new Text("Tipo",
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
            String tipo = tiposList[_radioValue];
            widget.solarCultivoBloc.onChangeCultivoTipo(tipo);

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
    tiposList.forEach((f){
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
        title: Text(f),
      );
      value++;
      list.add(tipo);
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