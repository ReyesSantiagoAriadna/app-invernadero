import 'dart:ui';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_gasto_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_producto_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_sobrante_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/generic_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/sobrantes_model.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/gastos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/productos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/sobrantes_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_cultivo.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_cultivo_etapa.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_herramienta.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_personal.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_productos.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_solar.dart';
import 'package:app_invernadero_trabajador/src/widgets/inputs/input_date.dart';
import 'package:app_invernadero_trabajador/src/widgets/inputs/input_svg_icon.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class SobranteEditPage extends StatefulWidget {
  SobranteEditPage({Key key}) : super(key: key);

  @override
  _SobranteEditPageState createState() => _SobranteEditPageState();
}

class _SobranteEditPageState extends State<SobranteEditPage> {
  Responsive _responsive;
  bool _isLoading=false;
  GenericBloc genericBloc;
  SolarCultivoBloc solarCultivoBloc;
  ActividadSobranteBloc sobranteBloc;
  Sobrante sobrante;

  @override
  void initState() {
     genericBloc = GenericBloc();
      solarCultivoBloc = SolarCultivoBloc();
      sobranteBloc = ActividadSobranteBloc();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _responsive = Responsive.of(context);
    if(sobrante==null){
     

      sobrante = ModalRoute.of(context).settings.arguments as Sobrante;
      
      genericBloc.onChangeFechaIn(sobrante.fecha.toString());
      genericBloc.onChangeEntero(sobrante.cantidad.toString());
      genericBloc.onChangeDescripcion(sobrante.observacion);

        print("sobrante solar ${sobrante.producto.solar}");
      sobranteBloc.init(context, sobrante);
      
    }
  }
  @override
  void dispose() {
    genericBloc.reset();
    sobranteBloc.reset();
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
            title:Text("Editar Sobrante",style:TextStyle(color: MyColors.GreyIcon,
              fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w800
            )),
            leading: IconButton(
              icon: Icon(LineIcons.angle_left,color:MyColors.GreyIcon),
              onPressed:()=> Navigator.pop(context)),
            actions: <Widget>[
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
            Text("Información del Sobrante",style: TextStyle(
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

            DialogSelectProducto(solarCultivoBloc:solarCultivoBloc,sobranteBloc:sobranteBloc,responsive: _responsive,),
            //_inputNombre(),
            
            SizedBox(height:_responsive.ip(2)),
            InputDate(title:"Fecha",stream:genericBloc.fechaIniStream,
                    onChange:genericBloc.onChangeFechaIn,
                    initialData:genericBloc.fechaIni,
                    firstDate:null
            ),
           // _date("Fecha")

            InputBloc(
              textInputType: TextInputType.number,labelText:"Cantidad",
              icon : SvgPicture.asset('assets/icons/boxes.svg',color:MyColors.GreyIcon,height: 20,),
              stream: genericBloc.enteroStream,
              onChange:genericBloc.onChangeEntero,
              initialData: genericBloc.entero),
            SizedBox(height:_responsive.ip(2)),
           

             SizedBox(height:_responsive.ip(2)),
              InputBloc(
              textInputType: TextInputType.text,labelText:"Observación",
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

  // _widget(){
  //   switch (_radioValue){
  //     case 0:
  //       return DialogSelectHerramienta(gastoBloc:gastoBloc,responsive:_responsive);
  //     case 1:
  //       return DialogSelectPersonal(gastoBloc:gastoBloc,responsive:_responsive);
  //     default:
  //       return Container();

  //   }
  // }


 


  // _createButton(){
  //   switch(_radioValue){
  //     case 0:
  //       // print("valida por herramienta");
  //       return _validateButton(gastoBloc.formGastoHerramienta);
  //     case 1:
  //       // print("valida por personal");
  //       return _validateButton(gastoBloc.formGastoPersonal);
  //     default:
  //       return _validateButton(gastoBloc.formBasicBloc);
  //   }
  // }

  _createButton(){
    return StreamBuilder(
      stream: sobranteBloc.formSobrante,
      builder: (BuildContext context, AsyncSnapshot snapshot){
          return IconButton(
          icon: Icon(LineIcons.save,color: MyColors.GreyIcon,),
          onPressed: snapshot.hasData?()=>_editSobrante():null
          );
      },
    );
  }

  _editSobrante()async{
    if(_isLoading)return;
    setState(() {
      _isLoading=true;
    });

    await sobranteBloc.updateSobrante(context,sobrante.id);

    setState(() {
      _isLoading=true;
    });

    Flushbar(
      message:  Provider.of<SobrantesService>(context,listen: false).response,
      duration:  Duration(seconds: 2),
    )..show(context).then((r){
      Navigator.pop(context);

      //if()
    });
  }
}