import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/etapa_cultivo.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/etapa_widget.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class CultivoEtapasPage extends StatefulWidget {
  @override
  _CultivoEtapasPageState createState() => _CultivoEtapasPageState();
}

class _CultivoEtapasPageState extends State<CultivoEtapasPage> {
  SolarCultivoBloc solarCultivoBloc;
  @override
  void initState() {
    solarCultivoBloc = SolarCultivoBloc();
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title:Text("Etapas de Cultivo",style:TextStyle(color: MyColors.GreyIcon,
          fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w800
        )),
        leading: IconButton(
          icon: Icon(LineIcons.angle_left,color:MyColors.GreyIcon), 
          onPressed:()=> Navigator.pop(context)),
        ),
      body: _body(),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
         // Navigator.pushNamed(context, 'cultivo_etapas');
          showDialog(
          context: context,
          builder: (BuildContext context) {
            return DialogEtapa(solarCultivoBloc: solarCultivoBloc,);
          });
        },
        child: Icon(LineIcons.plus),
        backgroundColor: miTema.accentColor,
      ),
      );
  }

  _body(){
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: StreamBuilder(
        stream: solarCultivoBloc.listEtapasStream,
        builder: (BuildContext context, AsyncSnapshot snapshot){
          if(snapshot.hasData){
            List<Etapa> etapa = snapshot.data;
            return ListView.builder(
              // controller: _pageBloc.scrollCont,
               physics: BouncingScrollPhysics(),
              itemCount: etapa.length,
              itemBuilder: (BuildContext context, int index) {
              return _etapaElement(etapa[index]);
             },
            );
          }
          return Container(
          );
        },
      ),
    );  
  }


  _etapaElement(Etapa etapa){
    return Container(
      margin: EdgeInsets.only(left:8,right:8,top:4,bottom:4),
      child: ListTile(
        title: Text(etapa.nombre,
         style: TextStyle(
            fontFamily:AppConfig.quicksand,
            fontWeight: FontWeight.w700
            
            )),
        subtitle: Text("Dias: ${etapa.dias}",
          style: TextStyle(
            fontFamily:AppConfig.quicksand,
            fontWeight: FontWeight.w700
            
            ),),
        leading: Icon(LineIcons.sitemap),
        trailing: IconButton(
          icon: Icon(LineIcons.trash_o), 
          onPressed:()=> _delete(etapa)),
      ),

      decoration: BoxDecoration(
        color : Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color:Colors.black26,
            blurRadius: 3.0,
            offset : Offset(0.0,3),
            spreadRadius: 3.0
          )
        ]
      ),
    );
  }

  _delete(Etapa etapa){
    solarCultivoBloc.deleteEtapa(etapa);
  }

}