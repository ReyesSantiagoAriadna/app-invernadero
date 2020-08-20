import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';


class DetailsSolarPage extends StatefulWidget {
  @override
  _DetailsSolarPageState createState() => _DetailsSolarPageState();
}

class _DetailsSolarPageState extends State<DetailsSolarPage> {
  Solar solar; 

  @override
  void didChangeDependencies() {
    solar = ModalRoute.of(context).settings.arguments as Solar;
 
    super.didChangeDependencies();
  }  
  
  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      appBar: AppBar(
        brightness: Brightness.light,
        elevation:0.0,
        backgroundColor:Colors.white,
        leading: IconButton(
          icon: Icon(LineIcons.angle_left,color: MyColors.GreyIcon,), onPressed: null),
        // iconTheme: IconThemeData(color:MyColors.GreyIcon),
        title:Text(solar.nombre,
              style: TextStyle(color:MyColors.GreyIcon,fontFamily: AppConfig.quicksand,
              fontWeight: FontWeight.w700
              ),),
        actions: <Widget>[
          IconButton(icon: Icon(LineIcons.edit,color:MyColors.GreyIcon), onPressed: (){})
        ],
      ),
      backgroundColor: Colors.white,
      body: Container(
        margin: EdgeInsets.only(left:8,right:8),
        width: double.infinity,
        height: double.infinity,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child:_content(),
        )
      ),
    );
  }


  _content(){
    return Column(
      children: _cultivos(),
      // children:<Widget>[
      //   Text(solar.nombre),
      //   _elements(),
        
      // ]
    );
  }

  _elements(){
    TextStyle _style = TextStyle(fontFamily:AppConfig.quicksand);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            IconButton(icon: Icon(FontAwesomeIcons.rulerCombined,color: MyColors.GreyIcon,),onPressed: (){},),
            Text("${solar.largo} x ${solar.ancho}",style: _style,)
          ],
        ),
        SizedBox(width:10),
        Column(
          children: <Widget>[
            IconButton(icon: Icon(Icons.location_on,color: MyColors.GreyIcon),onPressed: (){},),
            Text("${solar.region} ${solar.distrito}",style: _style,)
          ],
        )
      ],
    );
  }

  List<Widget> _cultivos(){
    final List<Widget> list=[];
    
    list.add(_elements());
    list.add(_subtitle());
    solar.cultivos.forEach((c){
      Cultivo cultivo = c;

      final element = ListTile(
        title: Text(cultivo.nombre),
        subtitle: Text(cultivo.observacion),
      );

      list.add(element);
    });

    return list;
  }

  _subtitle(){
    return Container(
      margin: EdgeInsets.only(left:8,right:8),
      width: double .infinity,
      height: 25,
      child: Text(
        "Cultivos",
        style: TextStyle(
          fontFamily:AppConfig.quicksand,
        ),
      ),
    );
  }
}