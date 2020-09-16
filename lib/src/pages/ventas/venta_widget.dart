import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/ventas/ventas_model.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart'; 

class VentaWidget extends StatefulWidget {
  final Venta venta;
  const VentaWidget({Key key, this.venta}) : super(key: key);

  @override
  _VentaWidgetState createState() => _VentaWidgetState();
}

class _VentaWidgetState extends State<VentaWidget> {
  TextStyle _style,_styleSub;
  Responsive _responsive;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _responsive = Responsive.of(context);
  }
  
  @override
  Widget build(BuildContext context) {
    _style = TextStyle(color:Colors.black54,fontWeight: FontWeight.w600,fontFamily: AppConfig.quicksand,fontSize: _responsive.ip(1.8));
    _styleSub = TextStyle(color:Colors.black87,fontFamily: AppConfig.quicksand,fontSize:_responsive.ip(1.5));
    
  return GestureDetector(
    onTap: (){},
    child: new Container(
      margin: EdgeInsets.only(top:10,bottom: 5),
      child: Card(
        elevation: 2,
        child: Column(
          children: <Widget>[
            Container(
              padding: EdgeInsets.all(4),
              width: double.infinity,
              child: Row(
                children: <Widget>[
                  _icon(),
                  Flexible(
                   child: Container(
                      margin: EdgeInsets.only(left: 20),
                      child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                       children: <Widget>[
                        Text('Folio: ${widget.venta.id}', style: _style), 
                        Row(
                          children: <Widget>[
                            Icon(LineIcons.calendar, size: 20,color: Colors.grey,),
                            Text('${DateFormat("dd-MM-yyyy").format(DateTime.parse(widget.venta.createdAt))}', style: _styleSub,)
                                //Text('Folio: ${venta.createdAt}', style: _styleSub)
                          ],
                        ),
                       ],
                      ),
                   )
                  ),
                  Row(children: <Widget>[
                    Text('Total: \$${widget.venta.total}', style: _style)
                  ],),
                  SizedBox(width: _responsive.ip(2),),
                  Row(
                    children: <Widget>[
                    IconButton(icon:  Icon(LineIcons.eye,color: MyColors.GreyIcon,), 
                     onPressed: ()=> detalisModalBottomSheet(context)
                    ),
                   ],
                  )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

    _icon(){
    return Stack(
      alignment: Alignment.center,
      children: <Widget>[
        new Icon(
              Icons.brightness_1,
              size: _responsive.ip(5), color: MyColors.GreenAccent),
          new Icon(
            LineIcons.dollar,
            size: _responsive.ip(3),
            color: Colors.white,
          ),
      ],
    );
  }

  detalisModalBottomSheet(context){
    TextStyle _itemStyle = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w600);
    
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
                  leading: new Icon( LineIcons.info_circle,color:Colors.white,),
                  title: Row(
                    children: <Widget>[
                      new Text('Detalles',style: TextStyle(color:Colors.white,fontFamily:'Quicksand',fontWeight: FontWeight.w700),),

                    ],
                  ),
                  onTap: null,
                ),
              ), 
               
             Container(
               padding: EdgeInsets.all(10),
               child: Column(
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children: <Widget>[
                    Text("Atendio: ${widget.venta.personal.nombre} ${widget.venta.personal.ap} ${widget.venta.personal.am}",style: _itemStyle,)                  ,
                    SizedBox(height:2),
                    Text("Cliente: ${widget.venta.cliente.nombre} ${widget.venta.cliente.ap} ${widget.venta.cliente.am}",
                      style: _itemStyle,
                    ),
                    SizedBox(height:2),
                    Text("Total de la venta \$ ${widget.venta.total}",style: _itemStyle,),
                    SizedBox(height:2),
                    Text("Fecha de compra: ${DateFormat("dd-MM-yyyy").format(DateTime.parse(widget.venta.createdAt))}",style: _itemStyle,),
                  
                 ],
               ),
             ),
             Container(
                color: Colors.grey[300],
                child: new ListTile(
                  dense: true,
                 // leading: Text("#",style: _style,),
                  title: Row(
                    children: <Widget>[ 
                      Text("Nombre",style: _style,),
                      Expanded(child: Container()),
                      Text('Precio U.',style:_style ,),
                      Expanded(child: Container()),
                      Text('Cantidad',style: _style,),
                      Expanded(child: Container()),
                      Text('Importe',style: _style,),
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
                        itemCount: widget.venta.detalles.length,
                        itemBuilder: (context,index){
                           return _producto(widget.venta.detalles[index]);
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

  _producto(Detalle detalle){
    TextStyle _itemStyle = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400);
    
    return  
        SingleChildScrollView(
            child: ListTile(
            dense: true, 
            title: Row(
              children: <Widget>[ 
                Container(
                  width: 100,
                  child: Text("${detalle.nombre}",  
                  style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),
                  overflow: TextOverflow.clip),
                ),
                //Expanded(child: Container()),
                Text("\$${detalle.precioU}", style: _itemStyle,),   
                Expanded(child: Container()), 
                Text('${detalle.cantidad} ${detalle.unidadM}(s)',style: _itemStyle,),
                Expanded(child: Container()),
                Text("\$${detalle.subtotal}", style: _itemStyle,)
              ],

            ), 
          ),
        );
  }
}