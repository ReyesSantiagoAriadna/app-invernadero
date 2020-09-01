import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/etapa_cultivo.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/input_select.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/material.dart';


class DialogSelectCultivoEtapa extends StatelessWidget {
  final SolarCultivoBloc solarCultivoBloc;
  final Responsive responsive;

  const DialogSelectCultivoEtapa({Key key,@required this.solarCultivoBloc,@required this.responsive}) : super(key: key);

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
              Icon(LineIcons.sitemap,color: MyColors.GreyIcon,),
              SizedBox(width:18),
              Text("Etapa",style: _style,),
              ],
            ),
          SizedBox(height:10),
          StreamBuilder(
              stream: solarCultivoBloc.etapaActiveStream,
              initialData: solarCultivoBloc.etapaActive!=null?solarCultivoBloc.etapaActive:null,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                // if(!snapshot.hasData)
                //   return InputSelect(text: "Elije el cultivo",responsive:responsive,);
                Etapa e;
                if(snapshot.hasData)
                  e = snapshot.data;

                return GestureDetector(
                  onTap: (){
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogListCultivo(solarCultivoBloc: solarCultivoBloc,);
                    });
                  },
                  child:InputSelect(text:snapshot.hasData?e.nombre:"Elije la etapa", responsive: responsive),
                );
              },
            ),
        ]
      ),
    );
  }
}



class DialogListCultivo extends StatefulWidget {
  final SolarCultivoBloc solarCultivoBloc;

  const DialogListCultivo({Key key,@required this.solarCultivoBloc}) : super(key: key);
  
  @override
  _DialogListCultivoState createState() => _DialogListCultivoState();
}

class _DialogListCultivoState extends State<DialogListCultivo> {
  int _radioValue=-1;
  List<Etapa> etapasList=[];
  
  @override
  void initState() {
    if(widget.solarCultivoBloc.solarActive!=null && widget.solarCultivoBloc.cultivoActive!=null){
      etapasList = widget.solarCultivoBloc.cultivoActive.etapas;

      Etapa etapa = widget.solarCultivoBloc.etapaActive;

      if(etapa!=null  && etapasList.contains(etapa)){
        _radioValue = etapasList.indexWhere((c)=>c==etapa);
      }else{
        _radioValue = 0;
      }
    }
    

   
    super.initState();
  }

  @override
  void didChangeDependencies() {
  
    super.didChangeDependencies();
  }

  void _handleRadioValueChange(int value) {
    print("value $value");
    setState(() {
      _radioValue = value;
    });
    setState(() {
    });
  }

  @override
  Widget build(BuildContext context) {
    return _cultivos();
  }

  _cultivos(){
    return AlertDialog(
      elevation: 0.0,
      title: new Text("Etapas",
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
            if(etapasList.isNotEmpty){
              Etapa etapa = etapasList[_radioValue];
              widget.solarCultivoBloc.changeEtapaActive(etapa);
            }
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
    etapasList.forEach((e){
    
      final cultivo =  ListTile(
        onTap: (){
         
        },
        dense: false,
        leading: new Radio(
          activeColor: miTema.accentColor,
          value: value,
          groupValue:  _radioValue,
          onChanged: _handleRadioValueChange,
        ),
        title: Text(e.nombre),
      );
      value++;
      list.add(cultivo);
    });
    if(list.isEmpty){
      final empty = ListTile(
        dense: false,
        leading: Icon(LineIcons.close),
        title: Text("No hay etapas"),
      );
      list.add(empty);
    }
    return list;
  }
}


