import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:flutter/material.dart';

class DialogListDistrito extends StatefulWidget {
  DialogListDistrito({Key key}) : super(key: key);

  @override
  _DialogListDistritoState createState() => _DialogListDistritoState();
}

class _DialogListDistritoState extends State<DialogListDistrito> {
  int _radioValue=-1;
  SolarCultivoBloc solarCultivoBloc;

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    solarCultivoBloc = SolarCultivoBloc();
    if(solarCultivoBloc.distrito!=null){
      
    }
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      
    );
  }
}