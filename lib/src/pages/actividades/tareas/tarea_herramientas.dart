import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
class TareaHerramientasPage extends StatefulWidget {
  @override
  _TareaHerramientasPageState createState() => _TareaHerramientasPageState();
}

class _TareaHerramientasPageState extends State<TareaHerramientasPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0.0,
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        title:Text("Agregar Herramientas",style:TextStyle(color: MyColors.GreyIcon,
          fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w800
        )),
        leading: IconButton(
          icon: Icon(LineIcons.angle_left,color:MyColors.GreyIcon), 
          onPressed:()=> Navigator.pop(context)),
        ),
    );
  }
}