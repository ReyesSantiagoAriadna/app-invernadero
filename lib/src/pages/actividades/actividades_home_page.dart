import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_solares.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
class ActividadesHomePage extends StatefulWidget {
  const ActividadesHomePage({Key key}) : super(key: key);

  @override
  _ActividadesHomePageState createState() => _ActividadesHomePageState();
}

class _ActividadesHomePageState extends State<ActividadesHomePage> {
  SolarCultivoBloc solarCultivoBloc;
  Responsive responsive;
  @override
  void didChangeDependencies() {
    solarCultivoBloc  = SolarCultivoBloc();
    responsive = Responsive.of(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Center(
      child:Column(
        children: <Widget>[
          Text("Solar"),
          SizedBox(height:responsive.ip(2)),
          StreamBuilder(
            stream: solarCultivoBloc.solarActiveStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              Solar solar = snapshot.data;
              return GestureDetector(
                onTap: (){
                   showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogList(solarCultivoBloc: solarCultivoBloc,);
                  });
                },
                child: Text(
                  solar.nombre,
                ),
              );
            },
          ),
          SizedBox(height:responsive.ip(2)),
          Text("Cultivo"),
          SizedBox(height:responsive.ip(2)),
          
        ],
      )
      ),
    );
  }
}