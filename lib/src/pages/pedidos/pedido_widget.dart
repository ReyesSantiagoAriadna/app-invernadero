import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_tarea_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/pedido/pedido_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/pedidos/pedido_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/tareas_services.dart';
import 'package:app_invernadero_trabajador/src/services/pedidos/pedidos_service.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_map/flutter_map.dart';
import 'package:flutter_svg/svg.dart';
import 'package:latlong/latlong.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';


class PedidoWidget extends StatefulWidget {
  final Pedido pedido;
  final PedidoBloc pedidoBloc;


  const PedidoWidget({Key key, this.pedido, this.pedidoBloc}) : super(key: key);


 
  @override
  _PedidoWidgetState createState() => _PedidoWidgetState();
}

class _PedidoWidgetState extends State<PedidoWidget> {
  
  TextStyle _style,_styleSub;
  Responsive _responsive;
  @override
  void initState() {
    super.initState();
  }

  @override
  void didChangeDependencies() {
    _responsive = Responsive.of(context);
    super.didChangeDependencies();
  }
  @override
  Widget build(BuildContext context) {  
    _style = TextStyle(color:Colors.black54,fontWeight: FontWeight.w600,fontFamily: AppConfig.quicksand,fontSize: _responsive.ip(1.8));
    _styleSub = TextStyle(color:Colors.black87,fontFamily: AppConfig.quicksand,fontSize:_responsive.ip(1.5));
    var formatter = new DateFormat("yyyy-MM-dd");
    return GestureDetector(
      onTap: (){
      },
      child: new Container(
        margin: EdgeInsets.only(top:10,bottom:5),
        child:Card(
          elevation: 2,
                  child: Column(  
            children:<Widget>[
             // _createFlutterMap(widget.solar.latitud, widget.solar.longitud),
              Container(
                padding: EdgeInsets.all(4),
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    _icon(),
                    // Expanded(child: Container()),
                    Flexible(
                                          child: Container(
                        // color: Colors.red,
                        margin: EdgeInsets.only(left:20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children:<Widget>[
                            Text("# ${widget.pedido.id}",
                              overflow: TextOverflow.ellipsis,
                              style: _style,),
                            SizedBox(height:5),
                            Row(
                              children:<Widget>[
                                Icon(LineIcons.clock_o,size: 20,color: Colors.grey,),
                                Text("${widget.pedido.estatus} \$ ${widget.pedido.total} MXN",
                                  style: _styleSub,
                                )
                              ]),
                            Text("Fecha de entrega: ${formatter.format(widget.pedido.fechaSolicitud)} ",
                              style: TextStyle(
                                color: MyColors.GreyIcon,
                                fontFamily:AppConfig.quicksand,fontWeight:FontWeight.w600
                                ),                            
                             )
                        ]),
                      ),
                    ),
                    //Expanded(child: Container()),
                    Row(
                      children:<Widget>[
                        IconButton(icon:  Icon(LineIcons.eye,color: MyColors.GreyIcon,), 
                          onPressed: ()=>detailsModalBottomSheet(context)),
                        // IconButton(icon:  Icon(LineIcons.ellipsis_v,color: MyColors.GreyIcon,), 
                        //   onPressed: ()=>menuOptions()),
                       
                      ]
                    )
                  ],
                ),
              ),
              
            ]
          ),
        ) ,
        // decoration: BoxDecoration(
        //         color : Colors.white,
        //         borderRadius: BorderRadius.circular(5.0),
        //         boxShadow: <BoxShadow>[
        //           BoxShadow(
                  
        //             color:Colors.black26,
        //             blurRadius: 3.0,
        //             offset : Offset(0.0,3),
        //             spreadRadius: 3.0
        //           )
        //         ]
        //       ),
      ),
    );
  }


  // void _deleteModalBottomSheet(context)async{
  //   showModalBottomSheet(
  //     context: context,
  //     builder: (BuildContext bc){
  //       return Container(
  //         child: new Wrap(
  //         children: <Widget>[ 
  //           new ListTile(
  //             leading: new Icon(LineIcons.trash_o),
  //             title: new Text('Eliminar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
  //             onTap: () { 
  //               Provider.of<TareasService>(context,listen: false)
  //               .deleteTarea(widget.tarea.id)
  //               .then((r){
  //                 Flushbar(
  //                   message:  Provider.of<TareasService>(context,listen: false).response,
  //                   duration:  Duration(seconds: 2),              
  //                 )..show(context).then((r){
  //                   Navigator.pop(context);
  //                 });
  //               });
  //             },
  //           ),

  //           new ListTile(
  //             leading: new Icon(LineIcons.pencil),
  //             title: new Text('Editar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
  //             onTap: () { 
  //               Navigator.pushNamed(context, 'tarea_edit',arguments: widget.tarea);
  //             },
  //           ),
            
  //           ],
  //          ),
  //       );
  //     }
  //   );
  // } 

 

  void customBottomSheet(Widget myWidget,double heightP){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height *heightP,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: Center(
          child: myWidget
        ),
      ),
    );
  }

  void menuOptions(){
    Column myWidget = Column(
            children:<Widget>[
              Container(
                margin: EdgeInsets.only(top:2),
                width:100,
                height:5,
                decoration: BoxDecoration(
                  color:Colors.black87,
                  borderRadius: BorderRadius.circular(5)
                  ),
                ),
               Container(
                child: new ListTile(
                  dense:true,
                  leading: new Icon(LineIcons.archive,color: Colors.white,),
                  title: new Text('Pedido',
                  style: TextStyle(fontFamily:'Quicksand',
                  fontWeight: FontWeight.w400,color: Colors.white),),
                  onTap: null
                ),
                decoration: BoxDecoration(
                  color:miTema.accentColor,
                  borderRadius: BorderRadius.only(topRight:  Radius.circular(25),topLeft:Radius.circular(25))
                ),
              ),
              new ListTile(
                dense: true,
                  leading: new Icon(LineIcons.trash_o),
                  title: new Text('Eliminar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
                  onTap: () { 
                    Provider.of<TareasService>(context,listen: false)
                    .deleteTarea(widget.pedido.id)
                    .then((r){
                      Flushbar(
                        message:  Provider.of<TareasService>(context,listen: false).response,
                        duration:  Duration(seconds: 2),              
                      )..show(context).then((r){
                        Navigator.pop(context);
                      });
                    });
                  },
                ),

                new ListTile(
                  dense: true,
                  leading: new Icon(LineIcons.pencil),
                  title: new Text('Editar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
                  onTap: () { 
                    Navigator.pushNamed(context, 'tarea_edit',arguments: widget.pedido);
                  },
                ),
            ]
          );
    customBottomSheet(myWidget, 0.20);
  }


  void showItem(){
    TextStyle _style = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400,color: MyColors.GreyIcon);
    Column myWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        
        Container(
          child: new ListTile(
            dense:true,
            leading: SvgPicture.asset('assets/icons/order_icon.svg',                  
          height: 20,color: Colors.white,),
            title: new Text('Pedido',
            style: TextStyle(fontFamily:'Quicksand',
            fontWeight: FontWeight.w400,color: Colors.white),),
            onTap: null
          ),
          decoration: BoxDecoration(
            color:miTema.accentColor,
            borderRadius: BorderRadius.only(topRight:  Radius.circular(25),topLeft:Radius.circular(25))
          ),
        ),
         SizedBox(height:10),
        // _element(LineIcons.life_bouy, widget.tarea.nombre),
        // _element(LineIcons.calendar_check_o, widget.tarea.cultivo.nombre),
        // _element(LineIcons.sitemap, widget.tarea.etapa),
        //  _element(LineIcons.clipboard, widget.tarea.detalle),
      ],
    );
    customBottomSheet(myWidget, 0.95);
  }

  _element(IconData icon,String texto){
    TextStyle _style = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w700,color: MyColors.GreyIcon);
    return Container(
      margin: EdgeInsets.only(left:15),
      child:Row(children: <Widget>[
        Icon(icon,color: MyColors.GreyIcon,),
        SizedBox(width:40),
        Text(texto,style: _style,)
      ],)
    );
  }


  _icon(){
    //if(widget.tarea==AppConfig.taskType1){
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Icon(
              Icons.brightness_1,
              size: _responsive.ip(5), color: _color(widget.pedido.estatus)),
           SvgPicture.asset('assets/icons/order_icon.svg',                  
          height: 20,color: Colors.white,),
        ],);
    //}
  }

  Color _color(String type){
    switch (type){
      case "Rechazado":
      return Colors.red;
      case "Aceptado":
      return Colors.purple;
      case "Entregado":
      return Colors.blue;
      default:
      return Colors.greenAccent;
    }
  }


  void detailsModalBottomSheet(context)async{
    TextStyle _itemStyle = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w600);
    //  showModalBottomSheet(
    //   context: context,
    //   isScrollControlled: true,
    //   backgroundColor: Colors.transparent,
    //   builder: (context) => Container(
    //     height: MediaQuery.of(context).size.height *heightP,
    //     decoration: new BoxDecoration(
    //       color: Colors.white,
    //       borderRadius: new BorderRadius.only(
    //         topLeft: const Radius.circular(25.0),
    //         topRight: const Radius.circular(25.0),
    //       ),
    //     ),
    //     child: Center(
    //       child: myWidget
    //     ),
    //   ),
    // );
// var formatter = new DateFormat("yyyy-MM-dd");
  var formatter = new DateFormat("dd-MM-yyyy");

    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        
        return Container(
          // height:200,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                color: miTema.accentColor,
                child: new ListTile(
                  dense: false,
                  leading: new SvgPicture.asset('assets/icons/order_icon.svg',color:Colors.white,height: 20,),
                  title: Row(
                    children: <Widget>[
                      new Text('Detalles del pedido',style: TextStyle(color:Colors.white,fontFamily:'Quicksand',fontWeight: FontWeight.w700),),
                      Expanded(child: Container()),
                      GestureDetector(
                        child: Icon(LineIcons.ellipsis_v,color:Colors.white),
                        onTapDown: (TapDownDetails details) {
                            _showPopupMenu(details.globalPosition);
                          },
                      ),

                      // new IconButton(icon: Icon(LineIcons.get_pocket,color: Colors.white,), onPressed: (){
                      //   _showPopupMenu();
                      //   // showDialog(
                      //   //   context: context,
                      //   //   builder: (BuildContext context) {
                      //   //     return SelectHerramientas(tareaBloc: tareaBloc,);
                      //   //   });
                      // })
                    ],
                  ),
                  onTap: null,
                ),
              ),
              Container(
                padding: EdgeInsets.all(10),
                child: Column(
                  // mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: <Widget>[
                  
                  Row(
                    children: <Widget>[
                      Text("Pedido # ${widget.pedido.id}",style: _itemStyle,),
                      Expanded(child: Container()),
                      widget.pedido.totalPagado!=null?
                      Container(
                        child:Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Text("PAGADO",style: TextStyle(color:Colors.white,fontFamily: 'Quicksand',fontWeight: FontWeight.w600),),
                        ),
                        decoration: BoxDecoration(
                          color: miTema.accentColor,
                          borderRadius:BorderRadius.circular(10)
                        ),
                      )
                      :
                      Container()
                    ],
                  ),
                  SizedBox(height:2),
                  Text("Cliente: ${widget.pedido.cliente.nombre} ${widget.pedido.cliente.ap} ${widget.pedido.cliente.am}",
                    style: _itemStyle,
                  ),
                  SizedBox(height:2),
                  widget.pedido.tipoEntrega==null?
                  Text("Recoger en invernadero",style: _itemStyle,)
                  :
                  Text("Enviar a: ${widget.pedido.tipoEntrega}",style: _itemStyle,)                  ,
                  SizedBox(height:2),
                  Text("Total del pedido \$ ${widget.pedido.total}",style: _itemStyle,),
                  SizedBox(height:2),
                  Text("Fecha de entrega \$ ${formatter.format(widget.pedido.fechaSolicitud) }",style: _itemStyle,),
                ],),
              ),
              // new ListTile(
              //   dense: true,
              //   leading: Text(
              //     "Pedido # ${widget.pedido.id} ${widget.pedido.idCliente}",style: _style,),
              //   title: Row(
              //     children: <Widget>[
              //       Text('Nombre',style:_style ,),
              //       Expanded(child: Container()),
              //       Text('Cantidad',style: _style,),
              //     ],
              //   ),
              //   onTap: null,
              // ),
              Container(
                color: Colors.grey[300],
                child: new ListTile(
                  dense: true,
                  leading: Text("#",style: _style,),
                  title: Row(
                    children: <Widget>[
                      Text('Nombre',style:_style ,),
                      Expanded(child: Container()),
                      Text('Cantidad',style: _style,),
                      Expanded(child: Container()),
                      Text('Subtotal',style: _style,),
                    ],
                  ),
                  onTap: null,
                ),
              ),
              Expanded(
                              child: Container(
                  // height: 200,
                  child:  ListView.builder(
                        physics: BouncingScrollPhysics(),
                        itemCount: widget.pedido.detalles.length,
                        itemBuilder: (context,index){
                          return _itemdetallePedido(widget.pedido.detalles[index]);
                        },
                      )
                  
                  
                ),
              ),
            ],
          ),
        );
      }
    );
  } 
  
  _itemdetallePedido(Detalle d){
    TextStyle _itemStyle = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400);
    return new ListTile(
      dense: true,
                leading: Text("${d.idProducto}",style: _itemStyle,),
                title: Row(
                  children: <Widget>[
                    Text(d.nombreProducto,style: _itemStyle,),
                    Expanded(child: Container()),
                    Text("${d.cantidadPedido} ${d.unidadM} (s)",style: _itemStyle,),
                    Expanded(child: Container()),
                    Text("${d.subtotal} ",style: _itemStyle,),

                                     ],
                ),
                onTap: null,
              );
  }

  String _selection ="Value1" ;
  String value;



  _showPopupMenu(Offset offset) async {

    const TextStyle _itemStyle = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400);

    double left = offset.dx;
    double top = offset.dy;
    await showMenu(
    context: context,
    position: RelativeRect.fromLTRB(left, top, 0, 0),
    items: [
      PopupMenuItem<String>(
        enabled:  widget.pedido.estatus=="Rechazado"?false:true,
        child:GestureDetector(
          onTap: ()async{
            await Provider
              .of<PedidosService>(context,listen: false).rechazarPedido(widget.pedido.id);
            Flushbar(
              message:  Provider.of<PedidosService>(context,listen: false).response,
              duration:  Duration(seconds: 2),              
            )..show(context);
          },
          child:  const Text('Rechazar',style:_itemStyle ,), ),
      ),
     PopupMenuItem<String>(
          child:GestureDetector(
            onTap: ()async{
              await Provider
                .of<PedidosService>(context,listen: false).entregarPedido(widget.pedido.id);
              Flushbar(
                        message: widget.pedidoBloc.response!=null?
                        widget.pedidoBloc.response
                        :
                        "Ha ocurrido un error."
                        ,
                        duration:  Duration(seconds: 2),              
                      )..show(context);
            },
            child:  const Text('Entregar',style:_itemStyle ,), ),
          ),
    ],
    elevation: 8.0,
  );
}

 
  

  popupMenu(){
    PopupMenuButton<String>(
    onSelected: (String value) {
    setState(() {
        _selection = value;
    });
  },
  child: ListTile(
    leading: IconButton(
      icon: Icon(Icons.add_alarm),
      onPressed: () {
        print('Hello world');
      },
    ),
    title: Text('Title'),
    subtitle: Column(
      children: <Widget>[
        Text('Sub title'),
        Text(_selection == null ? 'Nothing selected yet' : _selection.toString()),
      ],
    ),
    trailing: Icon(Icons.account_circle),
  ),
  itemBuilder: (BuildContext context) => <PopupMenuEntry<String>>[
        const PopupMenuItem<String>(
          value: 'Value1',
          child: Text('Choose value 1'),
        ),
        const PopupMenuItem<String>(
          value: 'Value2',
          child: Text('Choose value 2'),
        ),
        const PopupMenuItem<String>(
          value: 'Value3',
          child: Text('Choose value 3'),
        ),
      ],
);
  }
}