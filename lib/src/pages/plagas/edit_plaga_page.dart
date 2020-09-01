import 'dart:io';

import 'package:app_invernadero_trabajador/src/blocs/plagaBloc/plaga_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/plagasEnfermedades/plaga.dart'; 
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/plagasService/plaga_services.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_cultivos.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_solares.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:image_picker/image_picker.dart';  
import 'package:intl/intl.dart'; //
import 'package:provider/provider.dart';

import '../../../app_config.dart';


class PlagaEditPage extends StatefulWidget {
  PlagaEditPage({Key key}) : super(key: key);

  @override
  _PlagaEditPageState createState() => _PlagaEditPageState();
}

class _PlagaEditPageState extends State<PlagaEditPage> {
  PlagaService _plagaService;
  SolarCultivoBloc solarCultivoBloc = new SolarCultivoBloc();
  PlagaBloc plagaBloc = new PlagaBloc();
  bool _isLoading=false;
  Responsive _responsive;
  Plagas _plagaModel;
  File foto;
  TextEditingController _inputDateController = new TextEditingController(); 
  String _fecha= '';
  String urlImagen = '';
  TextStyle _style;
  Solar solar;
  final key = GlobalKey<ScaffoldState>();

  @override
  void initState() { 
    super.initState();
    imageCache.clear();    
  }

  @override
  void didChangeDependencies() { 
    super.didChangeDependencies();    

    if(_plagaModel == null){
      _plagaModel = ModalRoute.of(context).settings.arguments;

    plagaBloc.changeNombre(_plagaModel.nombre); 
    plagaBloc.changeObservacion(_plagaModel.observacion); 
    plagaBloc.changeTratamiento(_plagaModel.tratamiento);  
    plagaBloc.changeFecha(_plagaModel.fecha);
    plagaBloc.changeUrlImagen(_plagaModel.urlImagen);

    List<Solar> solares = Provider.of<SolarCultivoService>(context,listen: false).solarList;
    solar = solares.firstWhere((r) =>r.id==_plagaModel.idSolar);
    solarCultivoBloc.changeSolarActive(solar);


    if(solar.cultivos != null && solar.cultivos.isNotEmpty){
      List<Cultivo> cultivos = solar.cultivos;
      Cultivo cultivo = cultivos.firstWhere((c)=>c.id==_plagaModel.idCultivo);
      solarCultivoBloc.changeCultivoActive(cultivo); 
    } 
    } 

    
    
    _plagaService = Provider.of<PlagaService>(context); 

    _responsive = Responsive. of(context);      
        
     _style = TextStyle(
      color: MyColors.GreyIcon,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: _responsive.ip(1.8)
    );

    _inputDateController.text = _plagaModel.fecha;  

  } 

  @override
  void dispose() {
    plagaBloc.reset();
    solarCultivoBloc.reset();
    super.dispose();
  }
 

  @override
  Widget build(BuildContext context) {
    return Scaffold(
       key: key,
      appBar: AppBar(
        brightness: Brightness.light,
        elevation: 0.0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(LineIcons.angle_left, color: MyColors.GreyIcon,), 
          onPressed: () => Navigator.pop(context),
        ),
        title: Text("Editar Plaga", style: TextStyle(color: MyColors.GreyIcon),),
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
      )
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
            Text("Información de la plaga",style: TextStyle(
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
            SizedBox(height:_responsive.ip(1)),             
            _mostrarSolares(),            
            SizedBox(height:_responsive.ip(0.5)),
            _inputDeteccionDate(), 
            SizedBox(height:_responsive.ip(2)),
             _inputNombre(),
            SizedBox(height:_responsive.ip(2)),
            _observaciones(),
            SizedBox(height:_responsive.ip(2)),
            _tratamiento(),
            SizedBox(height:_responsive.ip(3)), 

          ],
        )
      ),
    );
  }

  Widget _mostrarFoto(){     
    if(_plagaModel.urlImagen != null){
      return Stack(
        alignment: const Alignment(0.8, 1.0),
        children: <Widget>[
           ClipRRect(
            borderRadius: BorderRadius.circular(100),
            child: Container(
              height: 140,
              width: 140,
              child: FadeInImage(
              image: NetworkImage(_plagaModel.urlImagen),
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
              ? new Image.file(foto, fit: BoxFit.cover)
              : Image.asset('assets/bug-96.png', fit: BoxFit.cover,)
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
     
  } 

    _procesarImagen()async{
      //ImageSource origen = ImageSource.gallery;
      //foto = await ImagePicker.pickImage(source: origen);
      final _picker = ImagePicker();
      final pickedFile = await _picker.getImage(source: ImageSource.gallery);
      foto = File(pickedFile.path);

      if(foto != null){
        urlImagen = null;
        _plagaModel.urlImagen = null;
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

        urlImagen = await _plagaService.subirFoto(foto);
        print("++++++++++++++++++++++++++++");
        print(urlImagen);
        plagaBloc.changeUrlImagen(urlImagen);

        setState(() {
          _isLoading=false;
        });
      }
    }

    _mostrarSolares(){
    return  Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
           Row(
            children: <Widget>[
              Icon(LineIcons.sun_o,color: MyColors.GreyIcon,),
              SizedBox(width:10),
              Text("Solar",style: _style,),
            ],
          ),
          SizedBox(height:_responsive.ip(2)),
          StreamBuilder(
            stream: solarCultivoBloc.solarActiveStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              Solar solar = snapshot.data;
              return GestureDetector(
                onTap: (){
                   showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogList(solarCultivoBloc: solarCultivoBloc,);
                  });
                },
                child:snapshot.hasData?
                 _select(solar.nombre):
                 _select("Elije el solar"),
              );
            },
          ),
          SizedBox(height:_responsive.ip(2)),
          Row(
            children: <Widget>[
              SvgPicture.asset('assets/icons/seelding_icon.svg',color:MyColors.GreyIcon,height: 20,),
              SizedBox(width:10),
              Text("Cultivo",style: _style,),
            ],
          ),
          SizedBox(height:_responsive.ip(2)),
          StreamBuilder(
            stream: solarCultivoBloc.cultivoActiveStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){            
              Cultivo cultivo = snapshot.data;
              return GestureDetector(
                onTap: (){
                   showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogListCultivo(solarCultivoBloc: solarCultivoBloc,);
                  });
                },
                child:snapshot.hasData
                
                ? _select((
                  cultivo.nombre),
                ):_select("Elije el cultivo"),
              );
            },
          ),
        ], 
    ); 
  }

    _select(String data){
    return Container(
      height: 50,
      margin: EdgeInsets.only(left:35,right:10),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        width: 1,
        color: MyColors.GreyIcon)  
      ),
      child: Row(
        children:<Widget>[
         Text(data,style: TextStyle(color:MyColors.GreyIcon,fontFamily: AppConfig.quicksand,
          fontSize: _responsive.ip(1.5),fontWeight: FontWeight.w700
        ),),
        Expanded(child:Container()),
        Icon(Icons.expand_more,color: MyColors.GreyIcon,)
        ]
      )
    );
  }

   _inputDeteccionDate(){
    return StreamBuilder(
              initialData: _inputDateController,
              stream: plagaBloc.fechaStream,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                return TextFormField( 
                  enableInteractiveSelection: false, 
                  controller: _inputDateController,
                  decoration: InputDecoration(
                    focusedBorder:  UnderlineInputBorder(      
                              borderSide: BorderSide(color:miTema.accentColor)),
                    icon: Icon(LineIcons.calendar),
                    labelText: 'Deteccion', 
                    errorText: snapshot.error
                  ),
                  onChanged: plagaBloc.changeFecha,
                  onTap: (){
                    FocusScope.of(context).requestFocus(new FocusNode()); //quitar foco
                    _selectDate(context);
                  }, 
                );
              }
            );
  }

  _selectDate(BuildContext context) async{
       DateTime picked = await showDatePicker(
        context: context,  
        initialDate: new DateTime.now(), 
        firstDate: new DateTime(2020), 
        lastDate: new DateTime.now(), 
        locale: Locale('es')
      );

      if(picked != null){
        setState(() {
          //_fecha = picked.toString()
          var formatter = new DateFormat("yyyy-MM-dd");
          _fecha = formatter.format(picked);
          _inputDateController.text = _fecha; 
          plagaBloc.changeFecha(_fecha);
          print(_fecha);
        });
      }
  }

  _inputNombre(){
    return StreamBuilder(   
      stream: plagaBloc.nombreStream, 
      initialData: plagaBloc.nombre,   
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(
            initialValue: snapshot.hasData ? snapshot.data:'', 
            decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                        borderSide: BorderSide(color:miTema.accentColor)),
              icon: Icon(LineIcons.bug),
              labelText: 'Nombre',              
              errorText: snapshot.error,
            ),
            onChanged: plagaBloc.changeNombre,  
          );
      },
    );
  }

   Widget _observaciones(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[ 
                Icon(LineIcons.clipboard,color: MyColors.GreyIcon,),
                SizedBox(width:18),
                Text("Observaciones",style: _style,),
              ],
            ),
           SizedBox(height:_responsive.ip(2)),
          Container(
            margin: EdgeInsets.only(left:30),
            padding: EdgeInsets.all(8), 
            child: StreamBuilder(
              stream: plagaBloc.observacionStream,
              initialData: plagaBloc.observacion,
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
                    onChanged: plagaBloc.changeObservacion,  
                    //onSaved: (value) => _plagaModel.observacion = value 
                  );
              }
            )
          )
        ]
      ),
    );
  }

   Widget _tratamiento(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
               // SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                Icon(LineIcons.clipboard,color: MyColors.GreyIcon,),
                SizedBox(width:18),
                Text("Tratamiento",style: _style,),
              ],
            ),
           SizedBox(height:_responsive.ip(2)),
          Container(
            margin: EdgeInsets.only(left:30),
            padding: EdgeInsets.all(8), 
            child: StreamBuilder(
              stream: plagaBloc.tratamientoStream,
              initialData: plagaBloc.tratamiento,
              builder: (BuildContext context, AsyncSnapshot snapshot){
              return TextFormField(
                initialValue: snapshot.hasData ? snapshot.data:'', 
                maxLines: 4,
                decoration: InputDecoration(
                hintText: "Ingresa un tratamiento..",
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color:MyColors.GreyIcon),
                  ),
                      focusedBorder:  OutlineInputBorder(      
                      borderSide: BorderSide(color:miTema.accentColor)),
                      errorText: snapshot.error 
                    ), 
                    onChanged: plagaBloc.changeTratamiento, 
                    //onSaved: (value) => _plagaModel.tratamiento = value
               );
              }
            )
          )
        ]
      ),
    );
 }

  _crearBoton(){  
      return StreamBuilder(
        stream: plagaBloc.formValidStream ,
        builder: (BuildContext context, AsyncSnapshot snapshot){
            return IconButton(
            icon: Icon(LineIcons.save,color: MyColors.GreyIcon,), 
            onPressed: snapshot.hasData ? ()=> _submit(): _muestraFlush 
            //_submit
            );
        },
      ); 
    }   

    void _submit(){      
       if(_inputCorrectos()){
         print("${solarCultivoBloc.cultivoActive.id}, ${plagaBloc.observacion},${plagaBloc.nombre},${plagaBloc.tratamiento}"); 
        Plagas plagaUp = Plagas(
          id: _plagaModel.id,
          idSolar: solarCultivoBloc.solarActive.id,
          idCultivo: solarCultivoBloc.cultivoActive.id,
          nombreCultivo: solarCultivoBloc.cultivoActive.nombre,
          nombre: plagaBloc.nombre,
          fecha:plagaBloc.fecha,
          observacion: plagaBloc.observacion,
          tratamiento: plagaBloc.tratamiento,
          urlImagen: plagaBloc.urlImagen
        );
         
        _plagaService.updatePlaga(plagaUp);
        
        Flushbar(
          message:  "Actualizado correctamente",
          duration:  Duration(seconds: 2),              
        )..show(context).then((r){
          Navigator.pop(context);
        });

      }else{
        _muestraFlush();
      }
       
    }

    bool _inputCorrectos(){
      if(solarCultivoBloc.solarActive != null && solarCultivoBloc.cultivoActive != null){
           return true;
      }
      return false;
    }

    _muestraFlush(){
       final snackbar = SnackBar(
      content: Text("Campos vacios"),
      duration: Duration(milliseconds: 1500),
    );
    key.currentState.showSnackBar(snackbar);
    }





}