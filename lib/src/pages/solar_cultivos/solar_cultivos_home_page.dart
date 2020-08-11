import 'package:flutter/material.dart';
class SolarCultivosHomePage extends StatefulWidget {
  SolarCultivosHomePage({Key key}) : super(key: key);

  @override
  _SolarCultivosHomePageState createState() => _SolarCultivosHomePageState();
}

class _SolarCultivosHomePageState extends State<SolarCultivosHomePage> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title:Text("Solares")
      ),
      
    );
  }
}