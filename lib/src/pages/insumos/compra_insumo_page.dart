import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/insumos/compra_insumo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/insumos/compra_insumos.dart';
import 'package:app_invernadero_trabajador/src/models/insumos/insumo.dart';
import 'package:app_invernadero_trabajador/src/services/insumosService/insumos_service.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_insumos_compras.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_proveedores.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart'; 

class CompraIsumosPage extends StatefulWidget {
  @override
  _CompraIsumosPageState createState() => _CompraIsumosPageState();
}

class _CompraIsumosPageState extends State<CompraIsumosPage> {
  Responsive _responsive;
  TextStyle _style, _itemStyle; 
  CompraInsumoBloc compraInsumoBloc = new CompraInsumoBloc();
  InsumoService _insumoService;

  @override
  void initState() { 
    super.initState();
    compraInsumoBloc.changeTotal("0");
    

  }

  @override
  void didChangeDependencies() { 
    super.didChangeDependencies();
    _responsive = Responsive.of(context); 

    _insumoService = Provider.of<InsumoService>(context); 

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
    // TODO: implement dispose
    super.dispose(); 
    compraInsumoBloc.reset(); 
  }
  
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            elevation: 0.0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(LineIcons.angle_left, color: MyColors.GreyIcon,), 
              onPressed: ()=> Navigator.pop(context)
            ),
            title: Text("Compra de insumos",style:TextStyle(color: MyColors.GreyIcon,
                fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w800)
            ),
            actions: <Widget>[
              IconButton(icon: Icon(LineIcons.plus, color: MyColors.GreyIcon,), 
              onPressed: ()=> Navigator.pushNamed(context,'insumos_add')
              ),
              _crearBoton()
            ],
          ),
          body: _body(),
        )
        )
      ],
    );
  }

  Widget _body(){
    return Container(
      padding: EdgeInsets.all(4),
      width: double.infinity,
      height: double.infinity,
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text('Información de la compra',style:TextStyle(
              fontFamily:AppConfig.quicksand,fontWeight: FontWeight.w700,
              color: MyColors.GreyIcon,fontSize: _responsive.ip(1.9)
            )),
          SizedBox(height: 5,),
            Container(
              width: double.infinity,
              height: 2,
              color: Colors.grey[300],
            ),
          Container(
            margin: EdgeInsets.only(left: 10, top: 10),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                DialogListProveedores(compraInsumoBloc: compraInsumoBloc, responsive: _responsive,)
              ],
            ),
          ),
          SizedBox(height: 20),
          Expanded(child: _tableInsumo()),
          _total()

          
        ],
      ),
    );
     /* margin: EdgeInsets.only(left: 8,right: 12, top: 10),
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text('Información de la compra',style:TextStyle(
              fontFamily:AppConfig.quicksand,fontWeight: FontWeight.w700,
              color: MyColors.GreyIcon,fontSize: _responsive.ip(1.9)
            )),
            SizedBox(height: 5,),
            Container(
              width: double.infinity,
              height: 2,
              color: Colors.grey[300],
            ),
            SizedBox(height: 15,),            
            DialogListProveedores(compraInsumoBloc: compraInsumoBloc, responsive: _responsive,),
            SizedBox(height: _responsive.ip(2),), 
            Container(
              width: double.infinity,
              height: 2,
              color: Colors.grey[300],
            ),
            //SizedBox(height: 10,), 
            _total(),
            _tableInsumo(),  
          ],
        ),
      ),
    );*/
  }

  Widget _tableInsumo(){
    TextStyle _stilo = _style = TextStyle(color:Colors.black54,fontWeight: FontWeight.w600,fontFamily: AppConfig.quicksand,fontSize: _responsive.ip(1.8));
    return Container(  
      margin: EdgeInsets.only(left: 10, right: 10, top: 10), 
      child: Stack(
        children: <Widget>[
          Column(
            children: <Widget>[
              Container(   
              color: miTema.accentColor,
              child: new ListTile(
                dense: false,
                leading: Icon(LineIcons.tint, color: Colors.white,),
                title: Row(
                  children: <Widget>[
                    Text('Insumos',style: TextStyle(color:Colors.white,fontFamily:'Quicksand',fontWeight: FontWeight.w700)),
                    //Expanded(child: Container()),
                    //_total(),
                    Expanded(child: Container()),
                    IconButton(icon: Icon(LineIcons.plus_circle, color: Colors.white,), onPressed: (){
                      showDialog(
                        context: context,
                        builder: (BuildContext context){
                          return DialogInsumosCompras(compraInsumoBloc: compraInsumoBloc,);
                        }
                        );
                      })
                    ],
                  ),
                  onTap: null,
                ),
            ),
            Container(
              color: Colors.grey[300],
              height: 50,
              child:  new ListTile(
                //leading: Text("#", style: _itemStyle),
                title: Row(
                  children: <Widget>[
                    Text('Nombre' , style: _stilo,),
                    Expanded(child: Container()),
                    Text('Medida',style: _stilo,),
                    Expanded(child: Container()),
                    Text('Precio',style: _stilo,),
                    Expanded(child: Container()),
                    Text('Cantidad',style: _stilo,),
                  ],
                ),
                onTap: null,
              ), 
            ),
              
              Stack(
                children: <Widget>[   
                       StreamBuilder(
                      stream: compraInsumoBloc.insumosStream , 
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                        if(!snapshot.hasData)
                        return Container();
                        List<Insumo> insumos =  snapshot.data;
                        return ListView.builder(
                          physics: BouncingScrollPhysics(),
                          scrollDirection: Axis.vertical,
                          shrinkWrap: true,
                          itemCount: insumos.length,
                          itemBuilder: (context, index){
                            return   _itemInsumo(insumos[index]);
                          }
                        );
                      },                   
                 ),
                   
                ],
              )
              
            ],
          )
        ],
      ),
    );  
  }

  

  _itemInsumo(Insumo insumo){
   TextStyle _itemStyle = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400);
     return  
          ListTile(       
        title: Row(
          children: <Widget>[
            Container(
              width: 90,
              child: Text('${insumo.nombre}', style:_itemStyle, overflow: TextOverflow.clip,),
            ),
            //Expanded(child: Container()),
            Text(insumo.unidadM, style: _itemStyle,),
            Expanded(child: Container()),
           // SizedBox(width: _responsive.ip(3)),
            GestureDetector(
              child: (insumo.precio == 0.0) ?Text('\$0.0', style: _itemStyle,) : Text('\$${insumo.precio}', style: _itemStyle,),
              onTap: (){
                showDialog(
                context: context,
                builder: (BuildContext context){
                  return _inputPrecio(insumo);
                }
                );
              },
            ),
            Expanded(child: Container()), 
            GestureDetector(
              child: (insumo.cantidadCompra == 0) ? Text('  0  ', style: _itemStyle,) : Text('${insumo.cantidadCompra}', style: _itemStyle,),
              onTap: (){
                showDialog(
                context: context,
                builder: (BuildContext context){
                  return _inputCantidad(insumo);
                }
                );
              },
            ),
            Expanded(child: Container())
          ],
        ),
        onTap: null,
      
      
    );
  }

  _inputPrecio(Insumo insumo){
    return AlertDialog(
      elevation: 0.0,
      title: new Text('Ingrese el precio', style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w900),),
      content: StreamBuilder(
        stream: compraInsumoBloc.precioStream , 
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return TextFormField( 
            keyboardType: TextInputType.number,
            decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                        borderSide: BorderSide(color:miTema.accentColor)),
              icon: Icon(LineIcons.money, color: MyColors.GreyIcon,),
              labelText: 'Precio',              
              errorText: snapshot.error == '*' ? null :snapshot.error,
            ),
            onChanged: compraInsumoBloc.changePrecio, 
         );
        },
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Aceptar',style: TextStyle(color:miTema.accentColor),),
          onPressed: (){ 
              compraInsumoBloc.addPrecio(insumo, double.parse(compraInsumoBloc.precio)); 
              Navigator.of(context).pop();
            
          }, 
        ),
      ],
    );
  }

  _inputCantidad(Insumo insumo){
    return AlertDialog(
      elevation: 0.0,
      title: new Text('Ingrese la cantidad', style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w900),),
      content: StreamBuilder(
        stream: compraInsumoBloc.cantidadStream, 
        builder: (BuildContext context, AsyncSnapshot snapshot){
          return TextFormField( 
          keyboardType: TextInputType.number,
            decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                        borderSide: BorderSide(color:miTema.accentColor)),
              icon: Icon(LineIcons.codepen, color: MyColors.GreyIcon,),
              labelText: 'Cantidad',              
              errorText:snapshot.error == '*' ? null : snapshot.error,
            ),
            onChanged: compraInsumoBloc.changeCantidad 
          );
        },
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text('Aceptar',style: TextStyle(color:miTema.accentColor),),
          onPressed: (){ 
            compraInsumoBloc.addCantidad(insumo, int.parse(compraInsumoBloc.cantidad));
            Navigator.of(context).pop();
          }, 
        ),
      ],
    );
  }

  _total(){
    return  Stack(      
        alignment: Alignment(-1.0, -1.0),
        children: <Widget>[
          Container(
          margin: EdgeInsets.only(bottom:5,left: 4,right: 4),
          padding: EdgeInsets.all(7),
          height:_responsive.ip(7),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.center,
            children:<Widget>[
              Row(
                children: <Widget>[
                  
                  Icon(LineIcons.info_circle,size: _responsive.ip(3),color: Colors.grey,),
                  SizedBox(width:2),
                  Text("Total: ",
                    style: TextStyle(
                    fontFamily: 'Quicksand',
                    fontWeight: FontWeight.w900,
                    fontSize: _responsive.ip(2)
                ),),
                ],
              ),

              StreamBuilder(  
                      stream: compraInsumoBloc.totalStream,
                      initialData: 0 ,
                      builder: (BuildContext context, AsyncSnapshot snapshot){
                       var total = snapshot.data.toString();
                        return
                     Text( 
                          "\$ ${snapshot.data} MX",
                          //"\$ ${_shoppingCartBloc.totalFinal} MX",
                          style: TextStyle(
                            fontSize: _responsive.ip(2),
                            color:Colors.grey,
                            fontFamily:'Quicksand',
                            fontWeight: FontWeight.w900
                          ),
                        );
                      },
                  ),                
            ]
          ),
        )
        ],
    );
  }

  Widget _crearBoton(){
    return StreamBuilder(
      stream: compraInsumoBloc.formValidStream, 
      builder: (BuildContext context, AsyncSnapshot snapshot){
         return IconButton(
          icon: Icon(LineIcons.save, color: MyColors.GreyIcon,), 
          onPressed:  snapshot.hasData ? ()=>_submit(): _muestraFlush
        );
      },
    );
  }

  _submit() async{
    int proveedor = compraInsumoBloc.proveedorActive.id;
    List<String> listInsumo = [];
    List<String>  listPrecio = [];
    List<String> listCantidad = [];
    List<Insumo> insumos = compraInsumoBloc.insumos;

    for (var i = 0; i < insumos.length; i++) {
       listInsumo.add(insumos[i].id.toString());
       listCantidad.add(insumos[i].cantidadCompra.toString());
       listPrecio.add(insumos[i].precio.toString());
    }
    print(listCantidad.toString());
    print(listInsumo.toString());
    print(listPrecio.toString());
    print(proveedor);

    final respuesta = await _insumoService.addCompra(listInsumo, listCantidad, listPrecio, proveedor);
    //_insumoService.getInsumosACtualizados();
    if(respuesta){
      Flushbar(
        message:  "Agregado correctamente",
        duration:  Duration(seconds: 2),              
      )..show(context).then((r){ 
          Navigator.pop(context);
      });
    }else {
      Flushbar(
        message:  "Ocurrio un error",
        duration:  Duration(seconds: 2),              
      )..show(context).then((r){
         // Navigator.pop(context);
      });
    } 
  }

   _muestraFlush(){
     Flushbar(
          message: "Campos vacios",
          duration:  Duration(seconds: 2),              
     )..show(context).then((r){ 
     }); 
      
  }

}