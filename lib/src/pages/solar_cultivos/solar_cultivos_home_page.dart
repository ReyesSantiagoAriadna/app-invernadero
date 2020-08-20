import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/solar_widget.dart';
import 'package:flutter/material.dart';
class SolarCultivosHomePage extends StatefulWidget {
  SolarCultivosHomePage({Key key}) : super(key: key);

  @override
  _SolarCultivosHomePageState createState() => _SolarCultivosHomePageState();
}

class _SolarCultivosHomePageState extends State<SolarCultivosHomePage> {
  SolarCultivoBloc _solarCultivoBloc;
  
  @override
  void didChangeDependencies() {
    _solarCultivoBloc = SolarCultivoBloc();
    _solarCultivoBloc.solares();
    super.didChangeDependencies();
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
        margin:EdgeInsets.all(8),
        child: StreamBuilder(
          stream: _solarCultivoBloc.solaresStream ,
          builder: (BuildContext context, AsyncSnapshot snapshot){
            if(snapshot.hasData){
              List<Solar> solares = snapshot.data;
             /// print("solares lengt: ${solares.length}");
              return ListView.builder(
                 physics: BouncingScrollPhysics(),
                itemCount: solares.length,
                itemBuilder: (BuildContext context, int index) {
                return SolarWidget(solar:solares[index]);
               },
              );
            }
            return Container(
            );
          },
        ),
      ),
      
    );
  }
}