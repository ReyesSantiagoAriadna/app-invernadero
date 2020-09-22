import 'dart:io';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/insumos/insumos_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/insumos/insumo.dart';
import 'package:app_invernadero_trabajador/src/services/insumosService/insumos_service.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_tipoInsumo.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_unidadInsumo.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:image_picker/image_picker.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class EditInsumoPage extends StatefulWidget {
  @override
  _EditInsumoPageState createState() => _EditInsumoPageState();
}

class _EditInsumoPageState extends State<EditInsumoPage> {
  InsumosBloc insumosBloc =  new InsumosBloc();
  InsumoService _insumoService;
  Insumo insumo;
  Responsive _responsive;
  File foto;
  String urlImagen = '';
  bool _isLoading=false;
  TextStyle _style;

  
  @override
  void didChangeDependencies() { 
    super.didChangeDependencies();

    if(insumo ==null){
      insumo =  ModalRoute.of(context).settings.arguments; 
      urlImagen = insumo.urlImagen;
      print(urlImagen);
      insumosBloc.changeUrlImagen(insumo.urlImagen);
      insumosBloc.changeNombre(insumo.nombre);
      insumosBloc.changeTipoActive(insumo.tipo);
      insumosBloc.changeUnidadActive(insumo.unidadM);
      insumosBloc.changeCantidadMin(insumo.cantidadMinima.toString());
      insumosBloc.changeComposicion(insumo.composicion);
      insumosBloc.changeObservacion(insumo.observacion);

    print("---------------------------");
              print(insumosBloc.nombre);
              print(insumosBloc.tipoActive);
              print(insumosBloc.unidadActive);
              print(insumosBloc.cantidadMin);
              print(insumosBloc.composicion);
              print(insumosBloc.observacion);
              print(insumosBloc.urlImagen);
    }

    _responsive = Responsive.of(context); 
 
    _insumoService = Provider.of<InsumoService>(context);

    _style = TextStyle(
      color: MyColors.GreyIcon,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: _responsive.ip(1.8)
    );
  }

  @override
  void dispose() { 
    insumosBloc.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
     return Scaffold( 
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
          title: Text("Editar insumo",style:TextStyle(color: MyColors.GreyIcon,
              fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w800),
          ),
          actions: <Widget>[
            _crearBoton()
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
            Text("Información del insumo",style: TextStyle(
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
            _tipo(),
            SizedBox(height:_responsive.ip(1)),
            _inputNombre(),
            SizedBox(height:_responsive.ip(2)),
            _unidadM(),
            SizedBox(height:_responsive.ip(1)),
            _cantidadMin(),
            SizedBox(height:_responsive.ip(2)),
            _composicion(), 
            SizedBox(height:_responsive.ip(2)),
            _observacion(),
            SizedBox(height:_responsive.ip(4)),
          ],
        )
      ),
    );
  }

  _mostrarFoto(){
    if(insumo.urlImagen != null && foto == null){
      return Stack(
        alignment: const Alignment(0.8, 1.0),
        children: <Widget>[
           ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: 140,
              width: 140,
              child: FadeInImage(
              image: NetworkImage(insumo.urlImagen),
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
      urlImagen = await _insumoService.subirFoto(foto);
      print("++++++++++++++++++++++++++++");
      print(urlImagen);
      insumosBloc.changeUrlImagen(urlImagen);
      print("contenido bloc");
      print((insumosBloc.urlImagen));

      setState(() {
         _isLoading=false;
      });  
   }
  }

  _tipo(){
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(LineIcons.shield,color: MyColors.GreyIcon,),
            SizedBox(width:10),
            Text("Tipo de insumo",style: _style,),
          ],
        ),
        SizedBox(height: _responsive.ip(2),),
        StreamBuilder(
          stream: insumosBloc.tipoActiveStream, 
          builder: (BuildContext context, AsyncSnapshot snapshot){
             String insumoTipo = snapshot.data;
             return GestureDetector(
               onTap: (){
                 showDialog(
                   context: context, 
                   builder: (BuildContext context){
                     return DialogListInsumoTipo(insumosBloc: insumosBloc);
                   });
               },
               child: snapshot.hasData ? 
               _select(insumoTipo):
               _select("Elije el tipo de insumo"),
             );
          },
        ),
        //SizedBox(height: _responsive.ip(1),),
        
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

  Widget  _inputNombre(){
    return StreamBuilder(
      stream: insumosBloc.nombreStream, 
      initialData: insumosBloc.nombre,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(
          initialValue: snapshot.hasData ? snapshot.data : '',
            decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                        borderSide: BorderSide(color:miTema.accentColor)),
              icon: SvgPicture.asset('assets/icons/insumo_icon.svg',color:MyColors.GreyIcon,height: 20,),
              labelText: 'Nombre',              
              errorText: snapshot.error,
            ),
            onChanged: insumosBloc.changeNombre, 
          );
      },
    );
  }

  _unidadM(){ 
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(LineIcons.eyedropper,color: MyColors.GreyIcon,),
            SizedBox(width:10),
            Text("Tipo de unidad",style: _style,),
          ],
        ),
        SizedBox(height: _responsive.ip(2),),
        StreamBuilder(
          stream: insumosBloc.unidadActiveStream, 
          builder: (BuildContext context, AsyncSnapshot snapshot){
             String insumoUni = snapshot.data;
             return GestureDetector(
               onTap: (){
                 showDialog(
                   context: context, 
                   builder: (BuildContext context){
                     return DialogListUnidadInsumo(insumosBloc: insumosBloc);
                   });
               },
               child: snapshot.hasData ? 
               _select(insumoUni):
               _select("Elije el tipo de unidad"),
             );
          },
        ),
        //SizedBox(height: _responsive.ip(1),),
        
      ],
    );
  }

  _cantidadMin(){
    return StreamBuilder(
      stream: insumosBloc.cantidadMinStream, 
      initialData: insumosBloc.cantidadMin,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(
          initialValue: snapshot.hasData ? snapshot.data : '',
          keyboardType: TextInputType.number,
            decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                        borderSide: BorderSide(color:miTema.accentColor)),
              icon: SvgPicture.asset('assets/icons/insumo_icon.svg',color:MyColors.GreyIcon,height: 20,),
              labelText: 'Cantidad minima',              
              errorText: snapshot.error,
            ),
            onChanged: insumosBloc.changeCantidadMin, 
          );
      },
    );
  }

  Widget _composicion(){
   return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[ 
                Icon(LineIcons.flask,color: MyColors.GreyIcon,),
                SizedBox(width:15),
                Text("Composición",style: _style,),
              ],
            ),
           SizedBox(height:_responsive.ip(1)),
          Container(
            margin: EdgeInsets.only(left:30),
            padding: EdgeInsets.all(8), 
            child: StreamBuilder(
              stream: insumosBloc.composicionStream,
              initialData: insumosBloc.composicion,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return TextFormField(
                  initialValue: snapshot.hasData ? snapshot.data:'', 
                    maxLines: 3,
                    decoration: InputDecoration(
                    hintText: "Ingresa la composición..",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:MyColors.GreyIcon),
                      ),
                          focusedBorder:  OutlineInputBorder(      
                          borderSide: BorderSide(color:miTema.accentColor)),
                          errorText: snapshot.error
                        ), 
                    onChanged: insumosBloc.changeComposicion,  
                    //onSaved: (value) => _plagaModel.observacion = value 
                  );
              }
            )
          )
        ]
      ),
    );
  }

   Widget _observacion(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[ 
                Icon(LineIcons.clipboard,color: MyColors.GreyIcon,),
                SizedBox(width:15),
                Text("Observaciones",style: _style,),
              ],
            ),
           SizedBox(height:_responsive.ip(2)),
          Container(
            margin: EdgeInsets.only(left:30),
            padding: EdgeInsets.all(8), 
            child: StreamBuilder(
              stream: insumosBloc.observacionStream,
              initialData: insumosBloc.observacion,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return TextFormField(
                  initialValue: snapshot.hasData ? snapshot.data:'', 
                    maxLines: 3,
                    decoration: InputDecoration(
                    hintText: "Ingresa las observaciones..",
                      enabledBorder: OutlineInputBorder(
                        borderSide: BorderSide(color:MyColors.GreyIcon),
                      ),
                          focusedBorder:  OutlineInputBorder(      
                          borderSide: BorderSide(color:miTema.accentColor)),
                          errorText: snapshot.error
                        ), 
                    onChanged: insumosBloc.changeObservacion,  
                    //onSaved: (value) => _plagaModel.observacion = value 
                  );
              }
            )
          )
        ]
      ),
    );
  }

  Widget _crearBoton(){
    return StreamBuilder(
      stream: insumosBloc.formValidStream, 
      builder: (BuildContext context, AsyncSnapshot snapshot){
         return IconButton(
          icon: Icon(LineIcons.save, color: MyColors.GreyIcon,), 
          onPressed:  snapshot.hasData ? ()=>_submit(): _muestraFlush
        );
      },
    );
  }

  void _submit() async{
    print("---------------------------");
              print(insumosBloc.nombre);
              print(insumosBloc.tipoActive);
              print(insumosBloc.unidadActive);
              print(insumosBloc.cantidadMin);
              print(insumosBloc.composicion);
              print(insumosBloc.observacion);
              print(urlImagen); 
      Insumo insumoUpd = Insumo(
      id: insumo.id,
      nombre: insumosBloc.nombre,
      tipo: insumosBloc.tipoActive,
      unidadM: insumosBloc.unidadActive,
      especie: insumo.especie,
      tamano: insumo.tamano,
      composicion: insumosBloc.composicion,
      cantidad: insumo.cantidad,
      cantidadMinima: int.parse(insumosBloc.cantidadMin),
      observacion: insumosBloc.observacion,
      urlImagen: urlImagen,
      //precioPromedio: insumo.precioPromedio,
      //totalSales: insumo.totalSales
    );  

    final respuesta = await _insumoService.updateInsumo(insumoUpd);    
    if(respuesta){
      Flushbar(
        message:  "Actualizado correctamente",
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
     Flushbar(
          message: "Campos vacios",
          duration:  Duration(seconds: 2),              
     )..show(context).then((r){ 
     }); 
      
  }

}