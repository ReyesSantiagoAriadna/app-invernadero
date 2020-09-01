import 'dart:ui';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_gasto_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_producto_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/generic_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/gastos_model.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/gastos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/productos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_cultivo.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_cultivo_etapa.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_herramienta.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_personal.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_solar.dart';
import 'package:app_invernadero_trabajador/src/widgets/inputs/input_date.dart';
import 'package:app_invernadero_trabajador/src/widgets/inputs/input_svg_icon.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';

class GastoEditPage extends StatefulWidget {
  GastoEditPage({Key key}) : super(key: key);

  @override
  _GastoEditPageState createState() => _GastoEditPageState();
}

class _GastoEditPageState extends State<GastoEditPage> {
  Responsive _responsive;
  bool _isLoading=false;
  GenericBloc genericBloc;
  SolarCultivoBloc solarCultivoBloc;
  ActividadGastoBloc gastoBloc;
  int _radioValue=0;
  Gasto gasto;

  @override
  void initState() {
    genericBloc = GenericBloc();
    solarCultivoBloc = SolarCultivoBloc();
    gastoBloc = ActividadGastoBloc();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
     if(gasto==null){
      gasto = ModalRoute.of(context).settings.arguments as Gasto;
      var formatter = new DateFormat("yyyy-MM-dd");
      genericBloc.onChangeFechaIn(formatter.format(gasto.fecha));
      genericBloc.onChangeDecimal(gasto.costo.toString());
      genericBloc.onChangeDescripcion(gasto.descripcion);

      gastoBloc.init(context,gasto);
      if(gasto.idHerramienta!=null){
        _radioValue=0;
      }else if(gasto.idPersonal!=null){
        _radioValue=1;
      }else{
        _radioValue=2;
      }
    }

    _responsive = Responsive.of(context);
  }
  @override
  void dispose() {
    genericBloc.reset();
    // pBloc.reset();
    super.dispose();
  }



  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child:Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            elevation: 0.0,
            brightness: Brightness.light,
            backgroundColor: Colors.white,
            title:Text("Editar Gasto",style:TextStyle(color: MyColors.GreyIcon,
              fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w800
            )),
            leading: IconButton(
              icon: Icon(LineIcons.angle_left,color:MyColors.GreyIcon),
              onPressed:()=> Navigator.pop(context)),
            actions: <Widget>[
            //  _createButtonSave(),
              _createButton()
            ],
          ),
          body:GestureDetector(
            onTap: ()=>FocusScope.of(context).unfocus(),
            child: _body()
          ),
        ),
        ),
        _isLoading? Positioned.fill(child:  Container(
                  color:Colors.black45,
                  child: Center(
                    child:SpinKitCircle(color: miTema.accentColor),
                  ),
                ),):Container()
      ],
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
            Text("Información del Gasto",style: TextStyle(
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
            // _inputSolar(),
            DialogSelectSolar(solarCultivoBloc: solarCultivoBloc, responsive: _responsive),
            SizedBox(height:_responsive.ip(2)),
            DialogSelectCultivo(solarCultivoBloc: solarCultivoBloc, responsive: _responsive),
            SizedBox(height:_responsive.ip(2)),

            //_inputNombre(),

            SizedBox(height:_responsive.ip(2)),
            InputDate(title:"Fecha",stream:genericBloc.fechaIniStream,
                    onChange:genericBloc.onChangeFechaIn,
                    initialData:genericBloc.fechaIni,
                    firstDate:genericBloc.fechaIni
            ),
           // _date("Fecha")

            InputBloc(
              textInputType: TextInputType.number,labelText:"Costo",
              icon : Icon(LineIcons.dollar),
              stream: genericBloc.decimalStream,
              onChange:genericBloc.onChangeDecimal,
              initialData: genericBloc.decimal,maxlines: 1,),
            SizedBox(height:_responsive.ip(2)),
            _costo(),
            _widget(),

             SizedBox(height:_responsive.ip(2)),
              InputBloc(
              textInputType: TextInputType.text,labelText:"Descripción",
              icon : Icon(LineIcons.clipboard),
              stream: genericBloc.descripcionStream,
              onChange:genericBloc.onChangeDescripcion,
              initialData: genericBloc.descripcion,maxlines: 5,),
              SizedBox(height:_responsive.ip(2)),
          ],
        )
      ),
    );
  }

  _widget(){
    switch (_radioValue){
      case 0:
        return DialogSelectHerramienta(gastoBloc:gastoBloc,responsive:_responsive);
      case 1:
        return DialogSelectPersonal(gastoBloc:gastoBloc,responsive:_responsive);
      default:
        return Container();

    }
  }
  _costo(){
    return Container(
      width: double.infinity,
      child: Column(
        children: <Widget>[
          Row(
            children:<Widget>[
              Icon(LineIcons.clone,color: MyColors.GreyIcon,),
              SizedBox(width:15),
              Text("Concepto",style: TextStyle(fontFamily:AppConfig.quicksand,color:MyColors.GreyIcon,
                fontWeight: FontWeight.w700,fontSize: 16
              ),)
            ]
          ),
          RadioListTile(activeColor: miTema.accentColor, dense:true,title:Text("Herramienta",overflow: TextOverflow.ellipsis,), value: 0, groupValue: _radioValue, onChanged: _handleRadioValueChange),
          RadioListTile(activeColor: miTema.accentColor,dense:true,title:Text("Personal"), value: 1, groupValue: _radioValue, onChanged: _handleRadioValueChange),
          RadioListTile(activeColor: miTema.accentColor,dense:true,title:Text("Otro"), value: 2, groupValue: _radioValue, onChanged: _handleRadioValueChange)
        ],
      )
    );
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
    setState(() {
    });
  }


  _createButton(){
    switch(_radioValue){
      case 0:
        // print("valida por herramienta");
        return _validateButton(gastoBloc.formGastoHerramienta);
      case 1:
        // print("valida por personal");
        return _validateButton(gastoBloc.formGastoPersonal);
      default:
        return _validateButton(gastoBloc.formBasicBloc);
    }
  }
  _validateButton(Stream stream){
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
          return IconButton(
          icon: Icon(LineIcons.save,color: MyColors.GreyIcon,),
          onPressed: snapshot.hasData?()=>_update():null
          );
      },
    );
  }

  _update()async{
    if(_isLoading)return;
    setState(() {
      _isLoading=true;
    });

    await gastoBloc.updateGasto(context,gasto.id);

    setState(() {
      _isLoading=true;
    });

    Flushbar(
      message: Provider.of<GastosService>(context,listen: false).response,
      duration:  Duration(seconds: 2),
    )..show(context).then((r){
      Navigator.pop(context);

      //if()
    });
  }
}