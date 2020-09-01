
import 'package:app_invernadero_trabajador/src/blocs/actividad_tarea_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/herramienta_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/widgets/loading_bottom.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

class SelectHerramientas extends StatefulWidget {
  final ActividadTareaBloc tareaBloc;

  const SelectHerramientas({Key key, this.tareaBloc}) : super(key: key);

  
  @override
  _SelectHerramientasState createState() => _SelectHerramientasState();
}

class _SelectHerramientasState extends State<SelectHerramientas> {
  ScrollController _scrollController;
  bool _isLoading =false;
  
  @override
  void initState() {
    _scrollController = ScrollController();
    _scrollController.addListener((){
      if(_scrollController.position.pixels==_scrollController.position.maxScrollExtent){
          setState(() {
          _isLoading=true;
          });
           Provider.of<TareasService>(context,listen: false)
           .fetchHerramientas()
           .then((v){
              if(mounted){
                setState(() {
                  _isLoading=false;
                });
              if(v){
                _scrollController.animateTo(
                _scrollController.position.pixels +100,
                  duration: Duration(milliseconds:250), 
                  curve: Curves.fastOutSlowIn);
              }
             }
           });
        }
    });
    // solaresList =  Provider.of<SolarCultivoService>(context,listen: false).solarList;
    // if(widget.solarCultivoBloc.solarActive!=null){
    //   Solar s = widget.solarCultivoBloc.solarActive;
    //   _radioValue = solaresList.indexWhere((solar)=>solar==s);
    // }

   
    super.initState();
  }

  @override
  void didChangeDependencies() {
  
    super.didChangeDependencies();
  }

 
  @override
  Widget build(BuildContext context) {
    return _herramientas();
  }

  _herramientas(){
    return AlertDialog(
      elevation: 0.0,
      title: new Text("Herramientas",
        style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w900),),
      content: Container(
        //  height: 150,
        child: Stack(
          children: <Widget>[
            Positioned(child: Container(
              child: SingleChildScrollView(
                controller: _scrollController,
                physics: BouncingScrollPhysics(),
                child: Column(
                children: 
                _options()
                ),
              ),
            ),),
            Positioned(child:  LoadingBottom(isLoading:_isLoading),)
          ],
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Aceptar",style: TextStyle(color:miTema.accentColor),),
          onPressed: () {
          //   Solar solarActive = solaresList[_radioValue];
          //   widget.solarCultivoBloc.changeSolarActive(solarActive);
          //   final cultivos = solarActive.cultivos;
          //  if(cultivos!=null && cultivos.isNotEmpty)
          //     widget.solarCultivoBloc.changeCultivoActive(cultivos[0]);
          //   else
          //     widget.solarCultivoBloc.changeCultivoActive(null);

            // widget.solarCultivoBloc.changeCultivoLiActiv(solarActive.cultivos);
            Navigator.of(context).pop();
          },
        ),

        // new FlatButton(
        //   child: new Text("Cancelar",style: TextStyle(color:miTema.accentColor)),
        //   onPressed: () {
        //     Navigator.of(context).pop();
        //   },
        // ),
      ],
    );
  }
  _options(){
    List<Widget> list = [];
    int value = 0;
    Provider.of<TareasService>(context,listen: false).herramientas.forEach((h){
    
      // final solar =  ListTile(
      //   onTap: (){
         
      //   },
      //   dense: false,
      //   leading: new Radio(
      //     activeColor: miTema.accentColor,
      //     value: value,
      //    // groupValue:  _radioValue,
      //     onChanged: _handleRadioValueChange,
      //   ),
      //   title: Text(h.nombre),
      // );
      

      final item = new CheckboxListTile(
            title: Text(h.nombre),
            value: h.isSelect,
            onChanged: (bool value) {
              setState(() {
                h.isSelect = value;
              });
              if(h.isSelect){
                //add list
                h.amountOnTask=1;
                widget.tareaBloc.addHerramienta(h);
              }else{
                //remove list
                h.amountOnTask=0;
                widget.tareaBloc.deleteHerramienta(h);
              }
            },
          );
      value++;
      list.add(item);
    });
    return list;
  }
}