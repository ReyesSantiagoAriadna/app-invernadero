import 'dart:ui';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_gasto_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_producto_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_sobrante_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/generic_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/pedido/pedido_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/pages/pedidos/select_productos.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/gastos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/productos_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/sobrantes_services.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/services/pedidos/pedidos_service.dart';
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
import 'package:intl/intl.dart';


class PedidoAgendarPage extends StatefulWidget {
  PedidoAgendarPage({Key key}) : super(key: key);

  @override
  _PedidoAgendarPageState createState() => _PedidoAgendarPageState();
}

class _PedidoAgendarPageState extends State<PedidoAgendarPage> {
  Responsive _responsive;
  bool _isLoading=false;
  GenericBloc genericBloc;
  PedidoBloc pedidoBloc;


  @override
  void initState() {
    genericBloc = GenericBloc();
    pedidoBloc = PedidoBloc();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
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
            title:Text("Agendar pedido",style:TextStyle(color: MyColors.GreyIcon,
              fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w800
            )),
            leading: IconButton(
              icon: Icon(LineIcons.angle_left,color:MyColors.GreyIcon),
              onPressed:()=> Navigator.pop(context)),
            actions: <Widget>[
              IconButton(
                icon:Icon(LineIcons.archive,color: MyColors.GreyIcon,), 
                onPressed: ()=>customBottomSheet()
                ),
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
            Text("Información",style: TextStyle(
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
            

            //_fechas(),
            InputDate(title:"Fecha de inicio",
              initialDate: genericBloc.fechaIni,
              stream:genericBloc.fechaIniStream,                     
              onChange:genericBloc.onChangeFechaIn,
            ),

          

            StreamBuilder(
              stream: genericBloc.fechaIniStream,
              initialData: genericBloc.fechaIni ,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                
                return  InputDate(title:"Fecha de Finalización",
                  stream:genericBloc.fechaFinStream,                     
                  onChange:genericBloc.onChangeFechaFin,
                  initialDate: genericBloc.fechaIni,
                  firstDate: genericBloc.fechaIni,
                );
              },
            ),

             StreamBuilder(
              stream: genericBloc.fechaFinStream ,
              initialData: genericBloc.fechaFin,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                
                return  InputDate(title:"Fecha de Entrega",
                  stream:pedidoBloc.fechaEntregaStream,                     
                  onChange:pedidoBloc.onChangeFechaEntrega,
                  initialDate:pedidoBloc.fechaEntrega!=null?pedidoBloc.fechaEntrega: genericBloc.fechaFin,
                  firstDate: genericBloc.fechaFin,
                );
              },
            ),

         
            SizedBox(height:_responsive.ip(2)),
           

          ],
        )
      ),
    );
  }
  void customBottomSheet(){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: 300,//MediaQuery.of(context).size.height *1,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: Center(
          child: Column(
            children:<Widget>[
              // Container(
              //   margin: EdgeInsets.only(top:2),
              //   width:100,
              //   height:5,
              //   decoration: BoxDecoration(
              //     color:Colors.black87,
              //     borderRadius: BorderRadius.circular(5)
              //     ),
              //   ),
                 Container(
          child: new ListTile(
            dense:true,
            leading: new Icon(LineIcons.archive,color: Colors.white,),
            title: new Text('Productos',
            style: TextStyle(fontFamily:'Quicksand',
            fontWeight: FontWeight.w400,color: Colors.white),),
            onTap: null,
            trailing: IconButton(
              icon: Icon(LineIcons.plus,color: Colors.white,), 
              onPressed: (){
                showDialog(
                      context: context,
                      builder: (BuildContext context) {
                        return SelectProductos(pedidoBloc: pedidoBloc,);
                      });
              }),
          ),
          decoration: BoxDecoration(
            color:miTema.accentColor,
            borderRadius: BorderRadius.only(topRight:  Radius.circular(25),topLeft:Radius.circular(25))
          ),
        ),
             
              StreamBuilder(
                stream: pedidoBloc.productosAddStream ,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(!snapshot.hasData)
                    return Container();
                  List<Producto> products = snapshot.data;
                  return Expanded(
                      child: ListView.builder(
                      itemCount: products.length,
                      itemBuilder: (BuildContext context, int index) {
                        return ListTile(
                          dense: true,
                          title:Text("# ${products[index].id}  ${products[index].nombre}",
                            style: TextStyle(fontFamily:AppConfig.quicksand,fontWeight: FontWeight.w500),
                          ),
                          trailing: IconButton(
                            icon: Icon(LineIcons.trash), 
                            onPressed:()=> pedidoBloc.deleteProducto(products[index])),
                        );
                     },
                    ),
                  );
                },
              ),
            ]
          )
        ),
      ),
    );
  } 


  _createButton(){
    return StreamBuilder(
      stream: pedidoBloc.formFechaPedido,
      builder: (BuildContext context, AsyncSnapshot snapshot){
          return IconButton(
          icon: Icon(LineIcons.save,color: MyColors.GreyIcon,),
          onPressed: snapshot.hasData?()=>_agendarFechPedido():null
          );
      },
    );
  }

  _agendarFechPedido()async{
    if(_isLoading)return;
    setState(() {
      _isLoading=true;
    });

    await pedidoBloc.addFechaPedido(context);

    setState(() {
      _isLoading=true;
    });
    
    Flushbar(
      message: Provider.of<PedidosService>(context,listen: false).response,
      duration:  Duration(seconds: 2),
    )..show(context).then((r){
      Navigator.pop(context);

      //if()
    });
  }
}