import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/input_select.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class DialogSelectSolar extends StatelessWidget {
  final SolarCultivoBloc solarCultivoBloc;
  final Responsive responsive;

  const DialogSelectSolar({Key key,@required this.solarCultivoBloc,@required this.responsive}) : super(key: key);

  
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
              Icon(LineIcons.sun_o,color: MyColors.GreyIcon,),
              SizedBox(width:18),
              Text("Solar",style: _style,),
              ],
            ),
          SizedBox(height:10),
          StreamBuilder(
              stream: solarCultivoBloc.solarActiveStream ,
              initialData: solarCultivoBloc.solarActive!=null?solarCultivoBloc.solarActive:null,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                // if(!snapshot.hasData)
                //   return InputSelect(text: "Elije el solar",responsive:responsive,);
                Solar s;
                if(snapshot.hasData)
                 s = snapshot.data;

                return GestureDetector(
                  onTap: (){
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogListSolares(solarCultivoBloc: solarCultivoBloc,);
                    });
                  },
                  child:InputSelect(text:snapshot.hasData?s.nombre:"Elije el solar", responsive: responsive),
                );
              },
            ),
        ]
      ),
    );
  }
}



class DialogListSolares extends StatefulWidget {
  final SolarCultivoBloc solarCultivoBloc;

  const DialogListSolares({Key key,@required this.solarCultivoBloc}) : super(key: key);
  
  @override
  _DialogListSolaresState createState() => _DialogListSolaresState();
}

class _DialogListSolaresState extends State<DialogListSolares> {
  int _radioValue=-1;
  List<Solar> solaresList=[];
  
  @override
  void initState() {
    
    solaresList =  Provider.of<SolarCultivoService>(context,listen: false).solarList;
    // if(widget.solarCultivoBloc.solarActive!=null){
      Solar s = widget.solarCultivoBloc.solarActive;
      _radioValue = solaresList.indexWhere((solar)=>solar==s);
    // }

   
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
      print("cambiando de unidad");
    });
  }

  @override
  Widget build(BuildContext context) {
    return _solares();
  }

  _solares(){
    return AlertDialog(
      elevation: 0.0,
      title: new Text("Solar",
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
           
            Solar solarActive = solaresList[_radioValue];
            widget.solarCultivoBloc.changeSolarActive(solarActive);
            final cultivos = solarActive.cultivos;
            
            if(cultivos!=null && cultivos.isNotEmpty){
              widget.solarCultivoBloc.changeCultivoActive(cultivos[0]);
              final etapas = cultivos[0].etapas;
              if(etapas!=null&& etapas.isNotEmpty){
                widget.solarCultivoBloc.changeEtapaActive(etapas[0]);
              }
            }
            else{
              widget.solarCultivoBloc.changeCultivoActive(null);
              widget.solarCultivoBloc.changeEtapaActive(null);
            }
             
           
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
    solaresList.forEach((r){
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