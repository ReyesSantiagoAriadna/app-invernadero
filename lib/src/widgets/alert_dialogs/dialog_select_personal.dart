import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_gasto_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/gastos_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/gastos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/input_select.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class DialogSelectPersonal extends StatelessWidget {
  final ActividadGastoBloc gastoBloc;
  final Responsive responsive;

  const DialogSelectPersonal({Key key, this.gastoBloc, this.responsive}) : super(key: key);


  
  @override
  Widget build(BuildContext context) {
    TextStyle _style = TextStyle(
      color: MyColors.GreyIcon,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: responsive.ip(1.8)
    );
     return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
              Icon(LineIcons.comment_o ,color: MyColors.GreyIcon,),
              SizedBox(width:18),
              Text("Personal",style: _style,),
              ],
            ),
          SizedBox(height:10),
          StreamBuilder(
              stream: gastoBloc.personalActiveStream ,
              initialData: gastoBloc.personalActive!=null?gastoBloc.personalActive:null,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                // if(!snapshot.hasData)
                //   return InputSelect(text: "Elije el solar",responsive:responsive,);
                Personal item;
                if(snapshot.hasData)
                item = snapshot.data;

                return GestureDetector(
                  onTap: (){
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogListPersonal(gastoBloc: gastoBloc,);
                    });
                  },
                  child:InputSelect(text:snapshot.hasData?item.nombre:"Elije el personal", responsive: responsive),
                );
              },
            ),
        ]
      ),
    );
  }
}



class DialogListPersonal extends StatefulWidget {
  final ActividadGastoBloc gastoBloc;

  const DialogListPersonal({Key key, this.gastoBloc}) : super(key: key);

  
  @override
  _DialogListPersonalState createState() => _DialogListPersonalState();
}

class _DialogListPersonalState extends State<DialogListPersonal> {
  int _radioValue=-1;
  List<Personal> personalList=[];
  
  @override
  void initState() {
    
    personalList =  Provider.of<GastosService>(context,listen: false).personalList;
    if(widget.gastoBloc.personalActive!=null){
      Personal p = widget.gastoBloc.personalActive;
      _radioValue = personalList.indexWhere((i)=>i.id==p.id);
    }

   
    super.initState();
  }

  @override
  void didChangeDependencies() {
  
    super.didChangeDependencies();
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return _solares();
  }

  _solares(){
    return AlertDialog(
      elevation: 0.0,
      title: new Text("Personal",
        style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w900),),
      content: Container(
        // height: 150,
        // width: 70,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
          children:_options()
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Aceptar",style: TextStyle(color:miTema.accentColor),),
          onPressed: () {
              if(personalList.isNotEmpty){
                Personal item = personalList[_radioValue];
                widget.gastoBloc.onChangePersonalActive(item);
              }
            // Solar solarActive = solaresList[_radioValue];
            // widget.solarCultivoBloc.changeSolarActive(solarActive);
            // final cultivos = solarActive.cultivos;
            
            // if(cultivos!=null && cultivos.isNotEmpty){
            //   widget.solarCultivoBloc.changeCultivoActive(cultivos[0]);
            //   final etapas = cultivos[0].etapas;
            //   if(etapas!=null&& etapas.isNotEmpty){
            //     widget.solarCultivoBloc.changeEtapaActive(etapas[0]);
            //   }
            // }
            // else{
            //   widget.solarCultivoBloc.changeCultivoActive(null);
            //   widget.solarCultivoBloc.changeEtapaActive(null);
            // }
             
           
            // widget.solarCultivoBloc.changeCultivoLiActiv(solarActive.cultivos);
            Navigator.of(context).pop();
          },
        ),

        new FlatButton(
          child: new Text("Cancelar",style: TextStyle(color:miTema.accentColor)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
  _options(){
    List<Widget> list = [];
    int value = 0;
    personalList.forEach((r){
      final item = 
      RadioListTile(
        title: Text(r.nombre),
        dense: false,
        activeColor: miTema.accentColor,
        value: value, 
        groupValue: _radioValue, 
        onChanged: _handleRadioValueChange);
      value++;
      list.add(item);
    });
    return list;
  }
}