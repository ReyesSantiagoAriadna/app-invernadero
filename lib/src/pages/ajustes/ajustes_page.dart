import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:flutter/material.dart';
class AjustesPage extends StatefulWidget {
  @override
  _AjustesPageState createState() => _AjustesPageState();
}

class _AjustesPageState extends State<AjustesPage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation:0.0,
        backgroundColor:Colors.white,
        iconTheme: IconThemeData(color:MyColors.GreyIcon),
        title:Text("Ajustes",
              style: TextStyle(color:MyColors.GreyIcon,fontFamily: AppConfig.quicksand,
              fontWeight: FontWeight.w700
              ),)
      ),
      body: Center(
        child:Text("Ajustes")
      ),
    );
  }
}