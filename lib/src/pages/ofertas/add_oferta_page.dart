import 'dart:io'; 

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/ofertaBloc/oferta_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/productosBloc/producto_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/ofertas/oferta.dart';
import 'package:app_invernadero_trabajador/src/models/ofertas/ofertaTipo.dart';
import 'package:app_invernadero_trabajador/src/models/productos/producto.dart';
import 'package:app_invernadero_trabajador/src/services/ofertaService/ofertas_service.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_ofertaTipo.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_productos.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart'; 

class AddOfertaPage extends StatefulWidget {
  @override
  _AddOfertaPageState createState() => _AddOfertaPageState();
}

class _AddOfertaPageState extends State<AddOfertaPage> {
  OfertaBloc ofertaBloc;
  OfertaService _ofertaService;
  ProductoBloc productoBloc;
  Responsive _responsive;
  File foto;
  TextStyle _style;
  bool _isLoading=false;
  String urlImagen = '';
  TextEditingController _inputDateController = new TextEditingController();

  @override
  void initState() {
    imageCache.clear();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
    _responsive = Responsive.of(context); 

    ofertaBloc = new OfertaBloc();
    productoBloc = new ProductoBloc();
    _ofertaService = Provider.of<OfertaService>(context);
    
    _style = TextStyle(
      color: MyColors.GreyIcon,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: _responsive.ip(1.8)
    );
  }

  @override
  void dispose() { 
    ofertaBloc.reset();
    productoBloc.reset();
    super.dispose(); 
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      //key: scaffolKey,
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(LineIcons.angle_left, color: MyColors.GreyIcon), 
          onPressed: ()=> Navigator.pop(context)
        ),
        title:Text("Nueva oferta",style:TextStyle(color: MyColors.GreyIcon,
            fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w800)
        ),
        actions: <Widget>[
          _crearBoton()
        ],
      ),
      body: Stack(
        children: <Widget>[
          SafeArea(
            child: _body()
          ),
          _isLoading ? Positioned.fill(child: Container(
            color: Colors.black45,
            child: Center(
              child: SpinKitCircle(color: miTema.accentColor,),
            ),
          )
          ):Container()
        ],
      ),
    );
  }

    Widget _body(){
     return Container( 
      margin: EdgeInsets.only(left:10,right:10,top: 10),
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        child:Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Text("Información de la oferta",style: TextStyle(
              fontFamily:AppConfig.quicksand,fontWeight: FontWeight.w700,
              color: MyColors.GreyIcon,fontSize: _responsive.ip(1.8)
            ),),
            SizedBox(height:2),
            Container(
              width: double.infinity,
              height: 2,
              color: Colors.grey[300],
            ),
            SizedBox(height:15),
            _mostrarFoto(),
            SizedBox(height:_responsive.ip(3)), 
           _mostrarTipos(),
            SizedBox(height:_responsive.ip(1)),   
            _descripcion(),                       
            SizedBox(height:_responsive.ip(2)),
            _fechas(),          
            SizedBox(height:_responsive.ip(2)),
            _mostrarProductos(),
            SizedBox(height:_responsive.ip(2)),

          ],
        )
      ),
    );
  }

   Widget _mostrarFoto(){     
     return Stack(
        alignment: const Alignment(0.8, 1.0),
        children: <Widget>[          
            ClipRRect(
              borderRadius: BorderRadius.circular(100),
              child: Container(
                height: 140,
                width: 140,
                child: (foto!=null) 
                ? new Image.file(foto, fit: BoxFit.cover)
                : Image.asset('assets/no-image.png', fit: BoxFit.cover,)
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
        ],
      );
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

      setState(() {
        _guardarImagen();
      });
    }

    _guardarImagen()async{
      if(foto!=null){
       
        setState(() {
          _isLoading=true;
        });

        urlImagen = await _ofertaService.subirFoto(foto);
        print("++++++++++++++++++++++++++++");
        print(urlImagen);
        ofertaBloc.changeUrlImagen(urlImagen);

        setState(() {
          _isLoading=false;
        });
      }
  }

  _mostrarTipos(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(LineIcons.certificate,color: MyColors.GreyIcon,),
            SizedBox(width:10),
            Text("Tipo de oferta",style: _style,),
          ],
        ),
        SizedBox(height: _responsive.ip(2),),
        StreamBuilder(
          stream: ofertaBloc.tipoActivoStream, 
          builder: (BuildContext context, AsyncSnapshot snapshot){
             OfertaTipo ofertaTipo = snapshot.data;
             return GestureDetector(
               onTap: (){
                 showDialog(
                   context: context, 
                   builder: (BuildContext context){
                     return DialogListOfertaTipo(ofertaBloc: ofertaBloc);
                   });
               },
               child: snapshot.hasData ? 
               _select(ofertaTipo.tipo):
               _select("Elije el tipo de oferta"),
             );
          },
        ),
        SizedBox(height: _responsive.ip(2),),
        
      ],
    );
  }

  _select(String data){
    return Container(
      height: 50,
      margin: EdgeInsets.only(left: 35, right: 10),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        border: Border.all(
          width: 1,
          color: MyColors.GreyIcon
        )
      ),
      child: Row(
        children: <Widget>[
          Text(data, style: TextStyle(color:MyColors.GreyIcon, fontFamily: AppConfig.quicksand,
          fontSize: _responsive.ip(1.5), fontWeight: FontWeight.w700),),
          Expanded(child: Container()),
          Icon(Icons.expand_more,color: MyColors.GreyIcon,)
        ],
      ),
    );
  }

   Widget _descripcion(){
     return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
               // SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                Icon(LineIcons.clipboard,color: MyColors.GreyIcon,),
                SizedBox(width:10),
                Text("Descripción",style: _style,),
              ],
            ),
           SizedBox(height:_responsive.ip(1)),
          Container(
            margin: EdgeInsets.only(left:30),
            padding: EdgeInsets.all(8), 
            child: StreamBuilder(
              stream: ofertaBloc.descripcionStream,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return TextFormField(
                    maxLines: 3,
                    decoration: InputDecoration(
                    hintText: "Ingresa una descripción..",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:MyColors.GreyIcon),
                      ),
                          focusedBorder:  OutlineInputBorder(      
                          borderSide: BorderSide(color:miTema.accentColor)),
                          errorText: snapshot.error == '*' ? null : snapshot.error
                        ), 
                    onChanged: ofertaBloc.changeDescripcion,  
                  );
              }
            )
          )
        ]
      ),
    );
  } 
  
  _fechas(){
    return Row(
      children: <Widget>[
        _fechaa(ofertaBloc.inicioDateStream, "Fecha de Inicio",
         ofertaBloc.changeInicioDate,1),
        SizedBox(width:5),
        _fechaa(ofertaBloc.finDateStream, "Fecha de Terminación"
        , ofertaBloc.changeFinDate,2)

      ],
    );
  }
   _fechaa(Stream stream,String title,Function(String) onChange,int tipo){
    return StreamBuilder(
      stream: stream,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return GestureDetector(
          onTap: (){
            print("tapp=>>");
            if(tipo==1)
              _selectDate(context,onChange,null);
            else if(tipo==2){
              if(ofertaBloc.inicioDate!=null){
                _selectDate(context, onChange, ofertaBloc.inicioDate);
              }
            }
          },
          child: Column(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Icon(LineIcons.calendar,color: MyColors.GreyIcon,),
                  Container(
                    margin: EdgeInsets.only(left:10),
                    child: Text(title,style: _style,)),
                 
                ],
              ),
              SizedBox(height:5),
               Container(
                margin: EdgeInsets.only(left:45),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.start, 
                  children: <Widget>[
                    Text(
                      snapshot.hasData? "${snapshot.data}": "",
                    ),
                    SizedBox(height:5),
                    Container(
                      height:1,
                       width:100,
                      color:Colors.grey
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }

   _selectDate(BuildContext context,Function(String) onChange,String firstDate) async{
     DateTime parsedDate; 
    if(firstDate!=null)
    parsedDate = DateTime.parse(firstDate);
      new DateFormat("yyyy-MM-dd");
       DateTime picked = await showDatePicker(
        context: context, 
        initialDate: new DateTime.now(), 
        firstDate:  parsedDate !=null?parsedDate: new DateTime(2020), 
        lastDate: new DateTime(2021), 
        locale: Locale('es'),
      );

      if(picked != null){
          String _fecha;
          var formatter = new DateFormat("yyyy-MM-dd");
          _fecha = formatter.format(picked);
          // solarCultivoBloc.onChangeFechaIncio(_fecha);
          onChange(_fecha);
      }
  }

  _mostrarProductos(){
     return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(LineIcons.shopping_cart,color: MyColors.GreyIcon,),
            SizedBox(width:10),
            Text("Producto",style: _style,),
          ],
        ),
        SizedBox(height: _responsive.ip(2),),
        StreamBuilder(
          stream: productoBloc.productoActiveStream, 
          builder: (BuildContext context, AsyncSnapshot snapshot){
             Producto prod = snapshot.data;
             return GestureDetector(
               onTap: (){
                 showDialog(
                   context: context, 
                   builder: (BuildContext context){
                     return DialogListProductos(productoBloc: productoBloc);
                   });
               },
               child: snapshot.hasData ? 
               _select(prod.nombre):
               _select("Elije el producto"),
             );
          },
        ),
        SizedBox(height: _responsive.ip(2),),
        
      ],
    );
  } 

  Widget _crearBoton(){
     return StreamBuilder(
       stream: ofertaBloc.formValidStream, 
       builder: (BuildContext context, AsyncSnapshot snapshot){
        return  IconButton(
          icon: Icon(LineIcons.save,color: MyColors.GreyIcon,), 
          onPressed: snapshot.hasData ? ()=>_submit():_muestraFlush,        
        );
      }
     );
  }

  void _submit(){
    if(productoBloc.productoActive != null){
      Oferta ofertaNew = Oferta( 
        idTipo: ofertaBloc.tipoActive.id,
        tipo: ofertaBloc.tipoActive.tipo,
        idProducto: productoBloc.productoActive.id,
        producto: productoBloc.productoActive.nombre,
        descripcion: ofertaBloc.descripcion,
        urlImagen: ofertaBloc.urlImagen,
        inicio: ofertaBloc.inicioDate,
        fin: ofertaBloc.finDate
      );
 
      _ofertaService.addOferta(ofertaNew);
      
       Flushbar(
          message:  "Agregado correctamente",
          duration:  Duration(seconds: 2),              
        )..show(context).then((r){
          Navigator.pop(context);
        });
    }
  }

  _muestraFlush(){
    Flushbar(
      message:  "Compos vacios",
      duration:  Duration(seconds: 2),              
    )..show(context).then((r){ 
    });
  }
}