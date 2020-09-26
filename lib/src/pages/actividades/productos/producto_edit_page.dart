import 'dart:io';
import 'dart:ui';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_producto_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/generic_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/productos_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_cultivo.dart';
import 'package:app_invernadero_trabajador/src/widgets/alert_dialogs/dialog_select_solar.dart';
import 'package:app_invernadero_trabajador/src/widgets/inputs/input_svg_icon.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class ProductoEditPage extends StatefulWidget {
  ProductoEditPage({Key key}) : super(key: key);

  @override
  _ProductoEditPageState createState() => _ProductoEditPageState();
}

class _ProductoEditPageState extends State<ProductoEditPage> {
  Responsive _responsive;
  TextStyle _style;
  bool _isLoading=false;
  TextStyle _itemStyle;
  GenericBloc genericBloc;
  SolarCultivoBloc solarCultivoBloc;
  ActividadProductoBloc pBloc;
  Producto producto;
  File foto;
  String urlImagen = '';

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
    if(producto==null){
      producto = ModalRoute.of(context).settings.arguments as Producto;
      genericBloc.onChangeNombre(producto.nombre);
      pBloc.onChangeKilosXcaja(producto.equiKilos.toString());
      pBloc.onChangePrecioMay(producto.precioMay.toString());
      pBloc.onChangePrecioMen(producto.precioMen.toString());
      pBloc.onChangeCantidad(producto.cantExis.toString());
      pBloc.onChangeUrlImagen(producto.urlImagen);

      pBloc.init(context,producto);


    }
    

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
            title:Text("Editar Producto",style:TextStyle(color: MyColors.GreyIcon,
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
            SizedBox(height:15),
            // _inputSolar(), 
             _mostrarFoto(), 
            SizedBox(height:10), 
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
    return Column(
      children:<Widget>[
        InputBloc(
        textInputType: TextInputType.number,labelText:"Precio de mayoreo", 
        icon: Icon(LineIcons.money),
        stream:pBloc.precioMayStream,
        onChange:pBloc.onChangePrecioMay,
        initialData: pBloc.precioMay),
        InputBloc(
              textInputType: TextInputType.number,labelText:"Precio de menudeo", 
              icon: Icon(LineIcons.money),
              stream:pBloc.precioMenStream,
              onChange:pBloc.onChangePrecioMen,
              initialData: pBloc.precioMen),
      ]
    );
  }
  

   _mostrarFoto(){
    if(producto.urlImagen != null && foto == null){
      return Stack(
        alignment: const Alignment(0.8, 1.0),
        children: <Widget>[
           ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: 140,
              width: 140,
              child: FadeInImage(
              image: NetworkImage(producto.urlImagen),
              placeholder: AssetImage('assets/jar-loading.gif'), 
              fit: BoxFit.fill,
          ),
        ),
       ),
       Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(100),
              color: miTema.accentColor,
            ),         
            child: IconButton(
                icon: Icon(LineIcons.camera, color:Colors.white, size: 30,), 
                onPressed: _procesarImagen,
              ),
          ),
      ],
      );
    }else{ 
        //if(foto!=null){
           return  Stack(
             alignment: const Alignment(0.8, 1.0),
             children: <Widget>[
              ClipRRect(
                borderRadius: BorderRadius.circular(100),
                child: Container(
                  height: 140,
                  width: 140,
                  child: (foto!=null) 
                  ? new Image.file(foto,fit: BoxFit.cover)
                  : Image.asset('assets/no-image.png', fit: BoxFit.cover,),
                ),
              ),
              Container(
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(100),
                  color: miTema.accentColor,
                ),         
                child: IconButton(
                    icon: Icon(LineIcons.camera, color:Colors.white, size: 30,), 
                    onPressed: _procesarImagen
                  ),
              ),
             ]
           ); 
    }
  }

  _procesarImagen()async{
      //ImageSource origen = ImageSource.gallery;
      //foto = await ImagePicker.pickImage(source: origen);
      final _picker = ImagePicker();
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      foto = File(pickedFile.path);
      
      if(foto != null){
        urlImagen = null;
      }

      print(foto.path);

      setState(() {
        _guardarImagen();
      });
    }

    _guardarImagen()async{
      if(foto!=null){
       
        setState(() {
          _isLoading=true;
        });

        urlImagen = await pBloc.subirFoto(context,foto);
        print("++++++++++++++++++++++++++++");
        print(urlImagen);
        pBloc.onChangeUrlImagen(urlImagen);
        print("contenido bloc");
        print((pBloc.urlImagen));

        setState(() {
          _isLoading=false;
        });  
      }
    }
  

  
  
  _createButtonSave(){
    return StreamBuilder(
      stream: pBloc.formProducto,
      builder: (BuildContext context, AsyncSnapshot snapshot){
          return IconButton(
          icon: Icon(LineIcons.save,color: MyColors.GreyIcon,), 
          onPressed: snapshot.hasData?()=>_updateProducto():null
          );
      },
    );
  }
  
  _updateProducto()async{
    if(_isLoading)return;
    setState(() {
      _isLoading=true;
    });
    await pBloc.updateProducto(context,producto.id);
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

