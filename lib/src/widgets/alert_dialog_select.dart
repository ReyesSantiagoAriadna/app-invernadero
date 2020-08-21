
import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

enum Regiones { caniada, costa, papaloapan,istmo,valles,sieras,sierran,mixteca }

class AlertDialogSelect extends StatefulWidget {
  final String region;

  const AlertDialogSelect({Key key,this.region}) : super(key: key);

  @override
  _AlertDialogSelectState createState() => _AlertDialogSelectState();
}

class _AlertDialogSelectState extends State<AlertDialogSelect> {
   // state variable
  int _radioValue=-1;
  SolarCultivoBloc solarCultivoBloc;
  List<String> regiones = ["Cañada","Costa","Istmo","Mixteca",
    "Papaloapan","Sierra Norte","Sierra Sur","Valles Centrales"
  ];
String re="";

  
  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    solarCultivoBloc = SolarCultivoBloc();
    if(solarCultivoBloc.region!=null){
      switch(widget.region){
      case AppConfig.caniada:
        _radioValue=0;
        break;
      case AppConfig.costa:
        _radioValue=1;
      break;

      case AppConfig.istmo:
      _radioValue=2;
      break;

      case AppConfig.mixteca:
      _radioValue=3;
      break;
      case AppConfig.papaloapan:
      _radioValue=4;
      break;
      case AppConfig.sierran:
      _radioValue=5;
      break;
      case AppConfig.sierras:
      _radioValue=6;
      break;

      case AppConfig.valles:
      _radioValue=7;
      break;
    }
    }
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
   

    return AlertDialog(
      elevation: 0.0,
          title: new Text("Región",
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
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Aceptar",style: TextStyle(color:miTema.accentColor),),
              onPressed: () {
               
                Navigator.of(context).pop();

              
                // setState(() {
                //   switch (_radioValue){
                //   case 0:
                //     productoBloc.addUniMedida(AppConfig.uniMedidaCaja, FontAwesomeIcons.box,_radioValue);
                //   break;
                //   case 1:
                //   productoBloc.addUniMedida(AppConfig.uniMedidaTonelada, FontAwesomeIcons.weightHanging,_radioValue);
                //   break;
                //   case 2:
                //   productoBloc.addUniMedida(AppConfig.uniMedidaKilo, FontAwesomeIcons.weight,_radioValue);
                //   break;
                // }
                // });
                switch(_radioValue){
      case 0:
        solarCultivoBloc.changeRegion(AppConfig.caniada);
        break;
      case 1:
        solarCultivoBloc.changeRegion(AppConfig.costa);
      break;

      case 2:
        solarCultivoBloc.changeRegion(AppConfig.istmo);
      break;

      case 3:
        solarCultivoBloc.changeRegion(AppConfig.mixteca);
      break;
      case 4:
        solarCultivoBloc.changeRegion(AppConfig.papaloapan);
      break;
      case 5:
        solarCultivoBloc.changeRegion(AppConfig.sierran);
      break;
      case 6:
        solarCultivoBloc.changeRegion(AppConfig.sierras);
      break;

      case 7:
        solarCultivoBloc.changeRegion(AppConfig.valles);
      break;
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
    AppConfig.regiones.forEach((r){

      final region =  ListTile(
        onTap: (){
          re = r;
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
      list.add(region);
    });
    return list;
  }
}