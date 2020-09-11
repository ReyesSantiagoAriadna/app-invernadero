import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/input_select.dart';
import 'package:line_icons/line_icons.dart';
import 'package:flutter/material.dart';


class DialogSelectCultivo extends StatelessWidget {
  final SolarCultivoBloc solarCultivoBloc;
  final Responsive responsive;

  const DialogSelectCultivo({Key key,@required this.solarCultivoBloc,@required this.responsive}) : super(key: key);

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
              Icon(LineIcons.try_icon ,color: MyColors.GreyIcon,),
              SizedBox(width:18),
              Text("Cultivo",style: _style,),
              ],
            ),
          SizedBox(height:10),
          StreamBuilder(
              stream: solarCultivoBloc.cultivoActiveStream,
              initialData: solarCultivoBloc.cultivoActive!=null?solarCultivoBloc.cultivoActive:null,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                // if(!snapshot.hasData)
                //   return InputSelect(text: "Elije el cultivo",responsive:responsive,);
                Cultivo c;
                if(snapshot.hasData)
                  c = snapshot.data;

                return GestureDetector(
                  onTap: (){
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogListCultivo(solarCultivoBloc: solarCultivoBloc,);
                    });
                  },
                  child:InputSelect(text:snapshot.hasData?c.nombre:"Elije el cultivo", responsive: responsive),
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
  final int type; // 0->normal 1->homeSlect
  
  const DialogListCultivo({Key key,@required this.solarCultivoBloc, this.type=0}) : super(key: key);
  
  @override
  _DialogListCultivoState createState() => _DialogListCultivoState();
}

class _DialogListCultivoState extends State<DialogListCultivo> {
  int _radioValue=-1;
  List<Cultivo> cultivosList=[];
  
  @override
  void initState() {
    
    if(widget.type==0){
      if(widget.solarCultivoBloc.solarActive!=null){
      cultivosList = widget.solarCultivoBloc.solarActive.cultivos;
      Cultivo cultivo = widget.solarCultivoBloc.cultivoActive;
      if(cultivo!=null  && cultivosList.contains(cultivo)){
        _radioValue = cultivosList.indexWhere((c)=>c==cultivo);
      }else{
        _radioValue = 0;
      }
      }
    }else{
      if(widget.solarCultivoBloc.solarHome!=null){
      cultivosList = widget.solarCultivoBloc.solarHome.cultivos;
      Cultivo cultivo = widget.solarCultivoBloc.cultivoHome;
      if(cultivo!=null  && cultivosList.contains(cultivo)){
        _radioValue = cultivosList.indexWhere((c)=>c==cultivo);
      }else{
        _radioValue = 0;
      }
      }
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
    return _cultivos();
  }


  _cultivos(){
    return AlertDialog(
      elevation: 0.0,
      title: new Text("Cultivos",
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
            if(cultivosList.isNotEmpty){
              if(widget.type==0){
                 Cultivo cultivo = cultivosList[_radioValue];
              widget.solarCultivoBloc.changeCultivoActive(cultivo);

              final etapas = cultivo.etapas;
              if(etapas!=null && etapas.isNotEmpty)
                widget.solarCultivoBloc.changeEtapaActive(etapas[0]);
              else
                widget.solarCultivoBloc.changeEtapaActive(null);
              }else if(widget.type==1){
                 Cultivo cultivo = cultivosList[_radioValue];
                widget.solarCultivoBloc.changeCultivoHome(cultivo);
              }
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
    cultivosList.forEach((r){
    
      // final cultivo =  ListTile(
      //   onTap: (){
         
      //   },
      //   dense: false,
      //   leading: new Radio(
      //     activeColor: miTema.accentColor,
      //     value: value,
      //     groupValue:  _radioValue,
      //     onChanged: _handleRadioValueChange,
      //   ),
      //   title: Text(r.nombre),
      // );
      // 
      final item = RadioListTile(
        activeColor: miTema.accentColor,
        title: Text(r.nombre),
        value: value, 
        groupValue: _radioValue, 
        onChanged: _handleRadioValueChange);
        value++;
      list.add(item);
    });
    if(list.isEmpty){
      final empty = ListTile(
        dense: false,
        leading: Icon(LineIcons.close),
        title: Text("No hay cultivos"),
      );
      list.add(empty);
    }
    return list;
  }
}


