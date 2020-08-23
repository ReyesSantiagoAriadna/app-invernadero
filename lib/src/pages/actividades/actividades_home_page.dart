import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/regiones.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/providers/regions_provider.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_cultivos.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_distrito.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_mun.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_region.dart';
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
  Future<List<dynamic>> data;
  @override
  void didChangeDependencies() {
    solarCultivoBloc  = SolarCultivoBloc();

    responsive = Responsive.of(context);
    data =  regionsProvider.loadData();
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {
    return Container(
      height: double.infinity,
      width: double.infinity,
      margin: EdgeInsets.only(left:10,right: 10),
      child: Center(
      child:Column(
        crossAxisAlignment: CrossAxisAlignment.start,
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
                child:snapshot.hasData?
                 _select(solar.nombre):
                 _select("Elije el solar"),
              );
            },
          ),
          SizedBox(height:responsive.ip(2)),
          Text("Cultivo"),
          SizedBox(height:responsive.ip(2)),
          StreamBuilder(
            stream: solarCultivoBloc.cultivoActiveStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){            
              Cultivo cultivo = snapshot.data;
              return GestureDetector(
                onTap: (){
                   showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogListCultivo(solarCultivoBloc: solarCultivoBloc,);
                  });
                },
                child:snapshot.hasData
                
                ? _select((
                  cultivo.nombre),
                ):_select("Elije el cultivo"),
              );
            },
          ),

          SizedBox(height:responsive.ip(2)),
          Text("Región"),
          SizedBox(height:responsive.ip(2)),
           StreamBuilder(
            stream: solarCultivoBloc.regionActiveStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              Region region = snapshot.data;
              return GestureDetector(
                onTap: (){
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogListRegion(solarCultivoBloc: solarCultivoBloc,);
                  });
                },
                child:snapshot.hasData?
                 _select(region.region):
                 _select("Elije la región"),
              );
            },
          ),


          SizedBox(height:responsive.ip(2)),
          Text("Distrito"),
          SizedBox(height:responsive.ip(2)),
           StreamBuilder(
            stream: solarCultivoBloc.distritoActiveStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              Distrito distrito = snapshot.data;
              return GestureDetector(
                onTap: (){
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogListDistrito(solarCultivoBloc: solarCultivoBloc,);
                  });
                },
                child:snapshot.hasData?
                 _select(distrito.distrito):
                 _select("Elije el distrito"),
              );
            },
          ),


          SizedBox(height:responsive.ip(2)),
          Text("Municipio"),
          SizedBox(height:responsive.ip(2)),
           StreamBuilder(
            stream: solarCultivoBloc.municipioActiveStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return GestureDetector(
                onTap: (){
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogListMunicipio(solarCultivoBloc: solarCultivoBloc,);
                  });
                },
                child:snapshot.hasData?
                 _select(snapshot.data):
                 _select("Elije el distrito"),
              );
            },
          ),
        ],
      )
      ),
    );
  }

  _select(String data){
    return Container(
      height: 50,
      margin: EdgeInsets.only(left:10,right:10),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        width: 1,
        color: MyColors.GreyIcon)  
      ),
      child: Row(
        children:<Widget>[
         Text(data,style: TextStyle(color:MyColors.GreyIcon,fontFamily: AppConfig.quicksand,
          fontSize: responsive.ip(1.5),fontWeight: FontWeight.w700
        ),),
        Expanded(child:Container()),
        Icon(Icons.expand_more,color: MyColors.GreyIcon,)
        ]
      )
    );
  }


}