import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_solares.dart';
import 'package:flutter/material.dart';
class MainPage extends StatefulWidget {
  @override
  _MainPageState createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  SolarCultivoBloc solarCultivoBloc;

  @override
  void didChangeDependencies() {
    solarCultivoBloc = SolarCultivoBloc();
    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Center(
        child:Container(
            height: 100,
            width: 100,
            //child: DialogList(solarCultivoBloc:solarCultivoBloc),
        )
      ),
    );
  }
}