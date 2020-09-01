import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:lite_rolling_switch/lite_rolling_switch.dart';
class CultivoSensores extends StatefulWidget {
  final SolarCultivoBloc solarCultivoBloc;
  final Responsive responsive;
  final Cultivo cultivo;
  const CultivoSensores({Key key, this.solarCultivoBloc, this.responsive, this.cultivo}) : super(key: key);
  @override
  _CultivoSensoresState createState() => _CultivoSensoresState();
}

class _CultivoSensoresState extends State<CultivoSensores> {
  bool _sensores=false;
  IconData _icon;
  Cultivo cultivo;
  TextStyle _style = TextStyle(
      color: MyColors.GreyIcon,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: 15
    );
  Responsive _responsive;


  @override
  void initState() {
    _responsive = widget.responsive;
    _sensores  = widget.solarCultivoBloc.sensores;
    if(widget.cultivo!=null){
      cultivo = widget.cultivo;
      widget.solarCultivoBloc.onChangeTempMin(cultivo.tempMin.toString());
      widget.solarCultivoBloc.onChangeTempMax(cultivo.tempMax.toString());
      widget.solarCultivoBloc.onChangeHumMin(cultivo.humeMin.toString());
      widget.solarCultivoBloc.onChangeHumMax(cultivo.humeMax.toString());
      widget.solarCultivoBloc.onChangeHumSMin(cultivo.humeSMin.toString());
      widget.solarCultivoBloc.onChangeHumSMax(cultivo.humeSMax.toString());


    }
    if(_sensores){
      _icon = LineIcons.toggle_on;
    }else{
      _icon = LineIcons.toggle_off;
    }
    super.initState();
  }
    
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children:<Widget>[
          Row(
              children: <Widget>[
                SvgPicture.asset('assets/icons/sensor.svg',color:MyColors.GreyIcon,height: 20,),
                // Icon(LineIcons.wi)
                SizedBox(width:18),
                Text("Sensores",style: _style,),
              ],
            ),
          SizedBox(height:5),
          Container(
            margin:EdgeInsets.only(left:40),
            child: IconButton(icon: Icon(_icon,size:45,color: miTema.accentColor,), 
            onPressed: (){
              print("cambiando");
              setState(() {
                _sensores=!_sensores;
          _sensores ? 
            _icon=LineIcons.toggle_on:
            _icon=LineIcons.toggle_off;

             widget.solarCultivoBloc.onChangeSensores(_sensores);
              });
             
           
            }),
          ),
          SizedBox(height:5),
         _sensores? _inputs():Container(),

          SizedBox(height:5),
        ]
      ),
    );
  }


  _inputs(){
    return Column(
      children:<Widget>[
        _temperatura(),
        SizedBox(height:5),
        _humedad(),
        SizedBox(height:5),
        _humeS()
      ]
    );
  }
  
  _temperatura(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
                //SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                Icon(FontAwesomeIcons.thermometerEmpty,color: MyColors.GreyIcon,),
                SizedBox(width:18),
                Text("Temperatura",style: _style,),
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
                    child:StreamBuilder (
                      stream: widget.solarCultivoBloc.tempMinStream,
                      initialData: widget.solarCultivoBloc.tempMin!=null?widget.solarCultivoBloc.tempMin:'',
                      builder: (BuildContext context,snapshot){
                        return TextFormField(
                          initialValue: snapshot.hasData?snapshot.data:'',
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                          focusedBorder:  UnderlineInputBorder(      
                                borderSide: BorderSide(color:miTema.accentColor)),
                          labelText: 'Minima',
                          errorText: snapshot.error =='*' ? null:snapshot.error,
                          ),
                          onChanged: widget.solarCultivoBloc.onChangeTempMin,
                          );
                      },
                      
                    ),
                  ),
                  Text("°C",style: _style,),
                  SizedBox(width:5),
                   Container(
                    width:_responsive.wp(30),
                    child:StreamBuilder<Object>(
                      stream: widget.solarCultivoBloc.tempMaxStream,
                      initialData: widget.solarCultivoBloc.tempMax!=null?widget.solarCultivoBloc.tempMax:'',
                      builder: (context, snapshot) {
                        return TextFormField(
                          initialValue: snapshot.hasData?snapshot.data:'',
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            
                          focusedBorder:  UnderlineInputBorder(      
                                  borderSide: BorderSide(color:miTema.accentColor)),
                          labelText: 'Máxima',
                          errorText: snapshot.error =='*' ? null:snapshot.error,
                  ),
                  onChanged: widget.solarCultivoBloc.onChangeTempMax,
                  );
                      }
                    ),
                  ),
                  Text("°C",style: _style,),
                ]
              ),
            ),
        ]
      )
    );
  }

  _humedad(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
                //SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                Icon(FontAwesomeIcons.thermometerEmpty,color: MyColors.GreyIcon,),
                SizedBox(width:18),
                Text("Humedad",style: _style,),
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
                    child:StreamBuilder (
                      stream: widget.solarCultivoBloc.humMinStream,
                      initialData: widget.solarCultivoBloc.humMin!=null?widget.solarCultivoBloc.humMin:'',
                      builder: (BuildContext context,snapshot){
                        return TextFormField(
                          initialValue: snapshot.hasData?snapshot.data:'',
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                          focusedBorder:  UnderlineInputBorder(      
                                borderSide: BorderSide(color:miTema.accentColor)),
                          labelText: 'Minima',
                          errorText: snapshot.error =='*' ? null:snapshot.error,
                          ),
                          onChanged: widget.solarCultivoBloc.onChangeHumMin,
                          );
                      },
                      
                    ),
                  ),
                  Text("°C",style: _style,),
                  SizedBox(width:5),
                   Container(
                    width:_responsive.wp(30),
                    child:StreamBuilder<Object>(
                      stream: widget.solarCultivoBloc.humMaxStream,
                      initialData: widget.solarCultivoBloc.humMax!=null?widget.solarCultivoBloc.humMax:'',
                      builder: (context, snapshot) {
                        return TextFormField(
                          initialValue: snapshot.hasData?snapshot.data:'',
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            
                          focusedBorder:  UnderlineInputBorder(      
                                  borderSide: BorderSide(color:miTema.accentColor)),
                          labelText: 'Máxima',
                          errorText: snapshot.error =='*' ? null:snapshot.error,
                  ),
                  onChanged: widget.solarCultivoBloc.onChangeHumMax,
                  );
                      }
                    ),
                  ),
                  Text("°C",style: _style,),
                ]
              ),
            ),
        ]
      )
    );
  }


   _humeS(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
                //SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                Icon(FontAwesomeIcons.thermometerEmpty,color: MyColors.GreyIcon,),
                SizedBox(width:18),
                Text("HumedadS",style: _style,),
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
                    child:StreamBuilder (
                      stream: widget.solarCultivoBloc.humSMinStream,
                      initialData: widget.solarCultivoBloc.humSMin!=null?widget.solarCultivoBloc.humSMin:'',
                      builder: (BuildContext context,snapshot){
                        return TextFormField(
                          initialValue: snapshot.hasData?snapshot.data:'',
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                          focusedBorder:  UnderlineInputBorder(      
                                borderSide: BorderSide(color:miTema.accentColor)),
                          labelText: 'Minima',
                          errorText: snapshot.error =='*' ? null:snapshot.error,
                          ),
                          onChanged: widget.solarCultivoBloc.onChangeHumSMin,
                          );
                      },
                      
                    ),
                  ),
                  Text("°C",style: _style,),
                  SizedBox(width:5),
                   Container(
                    width:_responsive.wp(30),
                    child:StreamBuilder<Object>(
                      stream: widget.solarCultivoBloc.humSMaxStream,
                      initialData: widget.solarCultivoBloc.humSMax!=null?widget.solarCultivoBloc.humSMax:'',
                      builder: (context, snapshot) {
                        return TextFormField(
                          initialValue: snapshot.hasData?snapshot.data:'',
                          keyboardType: TextInputType.number,
                          decoration: InputDecoration(
                            
                          focusedBorder:  UnderlineInputBorder(      
                                  borderSide: BorderSide(color:miTema.accentColor)),
                          labelText: 'Máxima',
                          errorText: snapshot.error =='*' ? null:snapshot.error,
                  ),
                  onChanged: widget.solarCultivoBloc.onChangeHumSMax,
                  );
                      }
                    ),
                  ),
                  Text("°C",style: _style,),
                ]
              ),
            ),
        ]
      )
    );
  }
}