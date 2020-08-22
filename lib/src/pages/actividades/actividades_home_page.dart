import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_cultivos.dart';
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