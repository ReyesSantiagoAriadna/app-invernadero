import 'dart:ui';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_producto_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/generic_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/productos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_cultivo.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_cultivo_etapa.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_solar.dart';
import 'package:app_invernadero_trabajador/src/widgets/inputs/input_svg_icon.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class ProductoAddPage extends StatefulWidget {
  ProductoAddPage({Key key}) : super(key: key);

  @override
  _ProductoAddPageState createState() => _ProductoAddPageState();
}

class _ProductoAddPageState extends State<ProductoAddPage> {
  Responsive _responsive;
  TextStyle _style;
  bool _isLoading=false;
  TextStyle _itemStyle;
  GenericBloc genericBloc;
  SolarCultivoBloc solarCultivoBloc;
  ActividadProductoBloc pBloc;

  @override
  void initState() {
    genericBloc = GenericBloc();
    solarCultivoBloc = SolarCultivoBloc();
    pBloc = ActividadProductoBloc();
    super.initState();
  }
  
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _responsive = Responsive.of(context);
 
    _itemStyle = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400);
    _style = TextStyle(
      color: MyColors.GreyIcon,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: _responsive.ip(1.8)
    );

    
  }
  @override
  void dispose() {
    genericBloc.reset();
    pBloc.reset();
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
            title:Text("Nuevo Producto",style:TextStyle(color: MyColors.GreyIcon,
              fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w800
            )),
            leading: IconButton(
              icon: Icon(LineIcons.angle_left,color:MyColors.GreyIcon), 
              onPressed:()=> Navigator.pop(context)),
            actions: <Widget>[
             _createButtonSave(),
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
            Text("Información de producto",style: TextStyle(
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
            InputBloc(
              textInputType: TextInputType.text,labelText:"Nombre",
              icon : SvgPicture.asset('assets/icons/box.svg',color:MyColors.GreyIcon,height: 20,),
              stream:genericBloc.nombreStream,onChange:genericBloc.onChangeNombre,initialData: genericBloc.nombre),
            
            SizedBox(height:_responsive.ip(2)),
            
            InputBloc(
              textInputType: TextInputType.number,labelText:"Kilos por Caja", 
              icon : SvgPicture.asset('assets/icons/weight.svg',color:MyColors.GreyIcon,height: 20,),
              stream:pBloc.kilosXcajaStream,
              onChange:pBloc.onChangeKilosXcaja,
              initialData: pBloc.kilosXcaja),
            SizedBox(height:_responsive.ip(2)),
            _precios(),
            SizedBox(height:_responsive.ip(2)),
            InputBloc(
              textInputType: TextInputType.number,labelText:"Cantidad existente", 
              icon : SvgPicture.asset('assets/icons/boxes.svg',color:MyColors.GreyIcon,height: 20,),
              stream:pBloc.cantidadStream,
              onChange:pBloc.onChangeCantidad,
              initialData: pBloc.cantidad),
          ],
        )
      ),
    );
  }

  _precios(){
    return Row(
      children:<Widget>[
        Expanded(
              child: InputBloc(
              textInputType: TextInputType.number,labelText:"Precio de mayoreo", 
              icon: Icon(LineIcons.money),
              stream:pBloc.precioMayStream,
              onChange:pBloc.onChangePrecioMay,
              initialData: pBloc.precioMay),
        ),
        Expanded(
                  child: InputBloc(
              textInputType: TextInputType.number,labelText:"Precio de menudeo", 
              icon: Icon(LineIcons.money),
              stream:pBloc.precioMenStream,
              onChange:pBloc.onChangePrecioMen,
              initialData: pBloc.precioMen),
        ),
      ]
    );
  }
  

 
  

  
  
  _createButtonSave(){
    return StreamBuilder(
      stream: pBloc.formProducto,
      builder: (BuildContext context, AsyncSnapshot snapshot){
          return IconButton(
          icon: Icon(LineIcons.save,color: MyColors.GreyIcon,), 
          onPressed: snapshot.hasData?()=>_addProducto():null
          );
      },
    );
  }
  
  _addProducto()async{
    if(_isLoading)return;
    setState(() {
      _isLoading=true;
    });
    await pBloc.addProducto(context);
    setState(() {
      _isLoading=true;
    });     
    
    Flushbar(
      message:Provider.of<ProductosService>(context,listen: false).response,
      duration:  Duration(seconds: 2),              
    )..show(context).then((r){
      Navigator.pop(context);

      //if()
    });
  }
}

