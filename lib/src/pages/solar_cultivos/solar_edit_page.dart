import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/map_widget.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';

class SolarEditPAge extends StatefulWidget {
  @override
  _SolarEditPAgeState createState() => _SolarEditPAgeState();
}

class _SolarEditPAgeState extends State<SolarEditPAge> {
  Responsive _responsive; 
  TextStyle _style;
  TextStyle _secundaryStyle;
  
  @override
  void didChangeDependencies() {
    _responsive = Responsive.of(context);

     _style = TextStyle(
      color: MyColors.GreyIcon,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: _responsive.ip(1.8)
    );

    _secundaryStyle = TextStyle(
      color: Colors.black87,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: _responsive.ip(1.5));

    super.didChangeDependencies();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(LineIcons.angle_left,color: MyColors.GreyIcon,), 
          onPressed: ()=> Navigator.pop(context)  ),
        title: Text("Editar Solar",style:TextStyle(color: MyColors.GreyIcon,
          fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w800
        )),
        actions: <Widget>[
          IconButton(
            icon: Icon(
              LineIcons.save,color: MyColors.GreyIcon,), 
              onPressed:()=>_saveSolar() )
        ],
      ),

      body: _body(),
    );
  }

   _body(){
    return Container(
      margin: EdgeInsets.only(left:8,right:12,top: 10),
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Información del Solar",style: TextStyle(
              fontFamily:AppConfig.quicksand,fontWeight: FontWeight.w700,
              color: MyColors.GreyIcon,fontSize: _responsive.ip(1.9)
            ),),
            SizedBox(height:5),
            Container(
              width: double.infinity,
              height: 2,
              color: Colors.grey[300],
            ),
            SizedBox(height:5),
            
            TextFormField(
              
              decoration: InputDecoration(
                 focusedBorder:  UnderlineInputBorder(      
                          borderSide: BorderSide(color:miTema.accentColor)),
                icon: Icon(LineIcons.sun_o),
                labelText: 'Nombre'
              ),
            ),
            SizedBox(height:_responsive.ip(2)),
            Row(
              children: <Widget>[
                SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                SizedBox(width:18),
                Text("Medidas",style: _style,),
              ],
            ),
            Container(
              margin: EdgeInsets.only(left:35),
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.end,
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children:<Widget>[
                  Container(
                    width:_responsive.wp(30),
                    child:TextFormField(
                       keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      focusedBorder:  UnderlineInputBorder(      
                            borderSide: BorderSide(color:miTema.accentColor)),
                      labelText: 'Largo'
                    ),
                    ),
                  ),
                  Text("m",style: _style,),
                  SizedBox(width:5),
                   Container(
                    width:_responsive.wp(30),
                    child:TextFormField(
                       keyboardType: TextInputType.number,
                    decoration: InputDecoration(
                      
                     focusedBorder:  UnderlineInputBorder(      
                          borderSide: BorderSide(color:miTema.accentColor)),
                    labelText: 'Ancho',
                  ),
                  ),
                  ),
                  Text("m",style: _style,),
                ]
              ),
            ),
            SizedBox(height:_responsive.ip(2)),
            _description(),
            SizedBox(height:_responsive.ip(2)),

            
           MapWidget(responsive: _responsive,),
            // Row(
            //   children:<Widget>[
            //     _region(),
            //     _distrito(),
            //   ]
            // ),
            // SizedBox(height:_responsive.ip(2)),
            // _municipio(),

          ],
        )
      ),
    );
  }

  
_description(){
    return Container(
      
     
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
               // SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                Icon(LineIcons.clipboard,color: MyColors.GreyIcon,),
                SizedBox(width:18),
                Text("Descripción",style: _style,),
              ],
            ),
           SizedBox(height:_responsive.ip(2)),
          Container(
            margin: EdgeInsets.only(left:40),
            padding: EdgeInsets.all(8),
            // decoration: BoxDecoration(
            //   borderRadius: BorderRadius.circular(5),
            //   border: Border.all(
            //     width: 1,
            //     color: MyColors.GreyIcon)  
            //   ),
            child: TextFormField(
              maxLines: 4,
              decoration: InputDecoration(
               hintText: "Ingresa una descripción..",
                enabledBorder: OutlineInputBorder(
                  borderSide: BorderSide(color:MyColors.GreyIcon),
                ),
                     focusedBorder:  OutlineInputBorder(      
                          borderSide: BorderSide(color:miTema.accentColor)),
                    //labelText: 'Largo'
                  ),
              // decoration: InputDecoration.collapsed(

               
            ),
          )
        ]
      ),
    );
  }

  _saveSolar(){
    Flushbar(
      message:  "Actualizado correctamente",
      duration:  Duration(seconds: 2),              
    )..show(context).then((r){
      Navigator.pop(context);
    });
  }
}