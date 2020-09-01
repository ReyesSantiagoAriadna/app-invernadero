import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_producto_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_tarea_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/sobrantes_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/productos_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';


class ProductoWidget extends StatefulWidget {
  final Producto producto;
  final ActividadProductoBloc  productoBloc;

  const ProductoWidget({Key key, this.producto, this.productoBloc}) : super(key: key);


 
  @override
  _ProductoWidgetState createState() => _ProductoWidgetState();
}

class _ProductoWidgetState extends State<ProductoWidget> {
  
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
    
    return GestureDetector(
      onTap: (){
      },
      child: new Container(
        margin: EdgeInsets.only(top:10,bottom:5),
        child:Card(
          elevation: 5,
          child: Column(  
            children:<Widget>[
              Container(
                child:Hero(
                  tag: widget.producto.id,
                  child:  (widget.producto.urlImagen!=null)? FadeInImage(
                  placeholder: AssetImage('assets/images/placeholder.png'), 
                  image: NetworkImage(widget.producto.urlImagen),
                  fit : BoxFit.cover,
                  height: _responsive.ip(18),
                  ):
                Container(
                  height:_responsive.ip(15),
                  child:Image.asset('assets/images/placeholder.png')
                )
                ),
              ),
              Container(
                padding: EdgeInsets.all(4),
                width: double.infinity,
                child: Row(
                  children: <Widget>[
                    Icon(FontAwesomeIcons.productHunt,color: MyColors.GreyIcon,),
                            SizedBox(width:5),
                    Expanded(
                        child: Container(
                        margin: EdgeInsets.only(left:20),
                        child: Text("${widget.producto.nombre}",
                          overflow: TextOverflow.ellipsis,
                          style: _style,),
                      ),
                    ),
                    IconButton(icon:  Icon(LineIcons.eye,color: MyColors.GreyIcon,), 
                      onPressed: ()=>showItem()),
                    IconButton(icon:  Icon(LineIcons.ellipsis_v,color: MyColors.GreyIcon,), 
                      onPressed: ()=>menuOptions())
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
              new ListTile(
                dense: true,
                  leading: new Icon(LineIcons.trash_o),
                  title: new Text('Eliminar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
                  onTap: () { 
                    Provider.of<ProductosService>(context,listen: false)
                    .deleteProducto(widget.producto.id)
                    .then((r){
                      Flushbar(
                        message:  Provider.of<ProductosService>(context,listen: false).response,
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
                    Navigator.pushNamed(context, 'producto_edit',arguments: widget.producto);
                  },
                ),
            ]
          );
    customBottomSheet(myWidget, 0.15);
  }


  void showItem(){
    TextStyle _style = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400,color: MyColors.GreyIcon);
    Column myWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: new ListTile(
            dense:true,
            leading: new Icon(LineIcons.archive,color: Colors.white,),
            title: new Text('Producto',
            style: TextStyle(fontFamily:'Quicksand',
            fontWeight: FontWeight.w700,color: Colors.white,fontSize: 18),),
            onTap: null
          ),
          decoration: BoxDecoration(
            color:miTema.accentColor,
            borderRadius: BorderRadius.only(topRight:  Radius.circular(25),topLeft:Radius.circular(25))
          ),
        ),
         SizedBox(height:10),
        _element(Icon(LineIcons.life_bouy,color: Colors.white,), widget.producto.nombre),
        SizedBox(height:2),
        _element(
          SvgPicture.asset('assets/icons/weight.svg',color:MyColors.GreyIcon,height: 20,),
          "Contenido de caja ${widget.producto.equiKilos} kg"),
         SizedBox(height:2),
        _element(Icon(LineIcons.dollar,color: MyColors.GreyIcon,), "Precio de Mayoreo \$ ${widget.producto.precioMay}"),
         SizedBox(height:2),
        _element(Icon(LineIcons.dollar,color: Colors.white,), "Precio de Menudeo \$ ${widget.producto.precioMen}"),
         SizedBox(height:2),
        _element(SvgPicture.asset('assets/icons/boxes.svg',color:MyColors.GreyIcon,height: 20,),
               "Cantidad existente ${widget.producto.cantExis}")

        // _element(LineIcons.sitemap, widget.tarea.etapa),
        //  _element(LineIcons.clipboard, widget.tarea.detalle),
      ],
    );
    customBottomSheet(myWidget, 0.25);
  }

  _element(Widget icon,String texto){
    TextStyle _style = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w700,color: MyColors.GreyIcon);
    return Container(
      margin: EdgeInsets.only(left:15),
      child:Row(children: <Widget>[
        icon,
        SizedBox(width:40),
        Text(texto,style: _style,)
      ],)
    );
  }
}