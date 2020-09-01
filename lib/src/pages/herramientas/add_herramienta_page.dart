import 'dart:io';
 
import 'package:app_invernadero_trabajador/src/blocs/inventarioBloc/inventario_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/inventario_herramientas/herramienta.dart';
import 'package:app_invernadero_trabajador/src/services/inventarioService/inventario_service.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

import '../../../app_config.dart';

class AddHerramientaPage extends StatefulWidget {
  @override
  _AddHerramientaPageState createState() => _AddHerramientaPageState();
}

class _AddHerramientaPageState extends State<AddHerramientaPage> {
  InventarioBloc inventarioBloc;
  InventarioService inventarioService;
  Responsive _responsive;
  File foto; 
  final picker = ImagePicker();
  String urlImagen = '';
  bool _isLoading=false;
  TextStyle _style;
  double cantidad = 1;
  final scaffolKey = GlobalKey<ScaffoldState>(); 

  @override
  void initState() { 
    imageCache.clear();
    super.initState();
    
  }

  @override
  void didChangeDependencies() { 
    super.didChangeDependencies();
    _responsive = Responsive.of(context); 

    inventarioBloc = new InventarioBloc();
    inventarioService = Provider.of<InventarioService>(context);


    _style = TextStyle(
      color: MyColors.GreyIcon,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: _responsive.ip(1.8)
    );
  }
 
  @override
  void dispose() { 
    inventarioBloc.reset();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffolKey,
        backgroundColor: Colors.white,
        appBar: AppBar(
          brightness: Brightness.light,
          elevation: 0.0,
          backgroundColor: Colors.white,
          leading: IconButton(
            icon: Icon(LineIcons.angle_left, color: MyColors.GreyIcon,), 
            onPressed: (){              
              Navigator.pop(context);
            }
          ),
          title: Text("Nueva herramienta",
              style: TextStyle(color:MyColors.GreyIcon),
          ),
          actions: <Widget>[
            _crearBoton(), 
          ],
        ),
        body: Stack(
          children: <Widget>[
            SafeArea(child: _body()),
            _isLoading ? Positioned.fill(child: Container(
              color: Colors.black45,
              child: Center(
                child: SpinKitCircle(color: miTema.accentColor),
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
            Text("Información de la herramienta",style: TextStyle(
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
            SizedBox(height:_responsive.ip(2)),
            _inputNombre(),
            SizedBox(height:_responsive.ip(2)),
            _descripcion(), 
            SizedBox(height:_responsive.ip(2)),
            _slider()
          ],
        )
      ),
    );
  }

   Widget _mostrarFoto(){   
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
            :Image.asset('assets/no-image.png', fit: BoxFit.cover,),
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


  _procesarImagen()async{
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
      if(foto!=null && urlImagen != ""){
       
        setState(() {
          _isLoading=true;
        });

        urlImagen = await inventarioService.subirFoto(foto); 
        print("++++++++++++++++++++++++++++");
        print(urlImagen);
        inventarioBloc.changeUrlImagen(urlImagen);

        setState(() {
          _isLoading=false;
        });
 
      } 
    }

  Widget  _inputNombre(){
    return StreamBuilder(
      stream: inventarioBloc.nombreStream, 
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(
            decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                        borderSide: BorderSide(color:miTema.accentColor)),
              icon: Icon(LineIcons.wrench),
              labelText: 'Nombre',
              
              errorText: snapshot.error == '*' ? null : snapshot.error,
            ),
            onChanged: inventarioBloc.changeNombre, 
          );
      },
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
                SizedBox(width:18),
                Text("Descripción",style: _style,),
              ],
            ),
           SizedBox(height:_responsive.ip(1)),
          Container(
            margin: EdgeInsets.only(left:30),
            padding: EdgeInsets.all(8), 
            child: StreamBuilder(
              stream: inventarioBloc.descripcionStream,
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
                    onChanged: inventarioBloc.changeDescripcion,  
                  );
              }
            )
          )
        ]
      ),
    );
  } 

  Widget _slider(){
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text('Ingrese la cantidad',style: _style,),
        SliderTheme(
          data: SliderTheme.of(context).copyWith(
            activeTrackColor: MyColors.GreenAccent,
            inactiveTrackColor: Colors.white,
            trackShape: RoundedRectSliderTrackShape(),
            trackHeight: 4.0,
            thumbShape: RoundSliderThumbShape(enabledThumbRadius: 12.0),
            thumbColor: MyColors.GreenAccent,
            overlayColor: Colors.green.withAlpha(32),
            overlayShape: RoundSliderOverlayShape(overlayRadius: 28.0),
            tickMarkShape: RoundSliderTickMarkShape(),
            activeTickMarkColor: MyColors.GreenAccent,
            inactiveTickMarkColor: Colors.green[200],
            valueIndicatorShape: PaddleSliderValueIndicatorShape(),
            valueIndicatorColor: MyColors.GreenAccent,
            valueIndicatorTextStyle: TextStyle(
              color: Colors.white,
            ),
          ),
          child: Slider(
            value: cantidad,
            min: 1,
            max: 50,
            divisions: 50,
            label: '${(cantidad*1.0).round()}',
            onChanged: (value) {
              setState(
                () {
                  cantidad = value;

                  print("Agregando .....");
                  print(cantidad);

                  inventarioBloc.changeCantidad((cantidad*1.0).round());
                }
              );
            },
          ),
        ),
        Padding(
          padding: const EdgeInsets.only(left: 30),
          child: Text("Cantidad:  ${(cantidad*1.0).round()} ",style: TextStyle(
            color:Colors.grey,
            fontFamily:'Quicksand',
            fontWeight:FontWeight.w800,
            fontSize: _responsive.ip(1.8)
          ),),
        ),
      ],
    );
    // return 
  }

  Widget _crearBoton(){
    return StreamBuilder(
        stream: inventarioBloc.formValidStream ,
        builder: (BuildContext context, AsyncSnapshot snapshot){
            return IconButton(
            icon: Icon(LineIcons.save,color: MyColors.GreyIcon,), 
            onPressed:  snapshot.hasData ? ()=>_submit(): _muestraFlush
            );
        },
      );
  }

  void _submit()async{ 
     
    Herramienta newHer = Herramienta(
      nombre: inventarioBloc.nombre,
      descripcion: inventarioBloc.descripcion,
      cantidad: inventarioBloc.cantidad,
      urlImagen: inventarioBloc.urlImagen, 
    );

    print("-----------------------"); 
    print(inventarioBloc.nombre);
    print(inventarioBloc.cantidad);
    print(inventarioBloc.descripcion);
    print(inventarioBloc.urlImagen);

    final respuesta = await inventarioService.addHerramienta(newHer);
   
    setState(() {
          _isLoading=false;
        });

    if(respuesta){
      Flushbar(
        message:  "Agregado correctamente",
        duration:  Duration(seconds: 2),              
      )..show(context).then((r){
          Navigator.pop(context);
      });
    }else {
      Flushbar(
        message:  "La herramienta ya existe",
        duration:  Duration(seconds: 2),              
      )..show(context).then((r){
         // Navigator.pop(context);
      });
    }

    
  }

  _muestraFlush(){
       final snackbar = SnackBar(
      content: Text("Campos vacios"),
      duration: Duration(milliseconds: 1500),
    );
    scaffolKey.currentState.showSnackBar(snackbar);
    }

}