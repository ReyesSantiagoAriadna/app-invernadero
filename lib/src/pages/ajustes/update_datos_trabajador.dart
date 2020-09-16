import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/trabajador/trabajador_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/trabajador/trabajador.dart';
import 'package:app_invernadero_trabajador/src/services/trabajadorService/trabajador_service.dart';import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/rounded_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class UpdateDatosTrabajador extends StatefulWidget {
  UpdateDatosTrabajador({Key key}) : super(key: key);

  @override
  _UpdateDatosTrabajadorState createState() => _UpdateDatosTrabajadorState();
}

class _UpdateDatosTrabajadorState extends State<UpdateDatosTrabajador> {
  final TextStyle _style =  TextStyle(color:Colors.grey, fontSize:20 ,fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w700);
  Responsive responsive;
  TrabajadorBloc trabajadorBloc = new TrabajadorBloc();
  Trabajador _trabajador;
  TrabajadorService _trabajadorService;
  String opcion;
  bool _isLoading=false;

  @override
  void didChangeDependencies() {
    // TODO: implement didChangeDependencies
    super.didChangeDependencies();
     
    if(_trabajador==null){
      List data = ModalRoute.of(context).settings.arguments;
       
        opcion = data[0]; 
        _trabajador = data[1];  

      trabajadorBloc.changeNombre(_trabajador.nombre);
      trabajadorBloc.changeAp(_trabajador.ap);
      trabajadorBloc.changeAm(_trabajador.am);
      trabajadorBloc.changeRfc(_trabajador.rfc);
    }
 
    _trabajadorService = Provider.of<TrabajadorService>(context);
    responsive = Responsive.of(context); 
  }
  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    trabajadorBloc.reset();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        SafeArea(
          child: Scaffold(
          appBar: AppBar(
            brightness: Brightness.light,
            elevation: 0.0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(LineIcons.angle_left, color: MyColors.GreyIcon,), 
              onPressed: () => Navigator.pop(context),
            ),
            title: Text("Editar datos", style: TextStyle(color: MyColors.GreyIcon),),
            actions: <Widget>[
              _crearBoton(opcion)
            ],
          ),
          body: Container(
            padding: EdgeInsets.all(30.0),
            child: Column( 
              children: <Widget>[
                _opciones(opcion),
                SizedBox(height: responsive.ip(4),),
                //_crearBoton(opcion)
              ],
            ),
          ),
        )
        ),
        _isLoading ? Positioned.fill(child: Container(
          color: Colors.white60,
          child: Center(
            child: SpinKitCircle(color: miTema.accentColor,),
          ),
        )):Container()
      ],
    );
  }
 
  Widget _opciones(String input){  
     switch (input) {
       case 'nombre':
          return _nombre();
        break;
        
        case 'ap':
          return _apPaterno();
        break;
        
        case 'am':
          return _apMaterno();
        break; 

        case 'rfc':
          return _rfc();
        break;
  
       default:
     }
  } 

  Widget _nombre(){
    return StreamBuilder(
      stream: trabajadorBloc.nombreStream,
      initialData: trabajadorBloc.nombre,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(  
          initialValue: snapshot.hasData ? snapshot.data:'',
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd))),
              enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd)),),
              hintStyle: TextStyle(color:Colors.grey), 
              labelText: 'Nombre *', 
              labelStyle: _style,
              errorText: snapshot.error
          ), 
          onChanged: trabajadorBloc.changeNombre, 
        );
      },
    );
  }

  Widget _apPaterno(){
   return StreamBuilder(
      stream: trabajadorBloc.apStream, 
      initialData: trabajadorBloc.ap,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(  
          initialValue: snapshot.hasData ? snapshot.data:'',
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd))),
              enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd)),),
              hintStyle: TextStyle(color:Colors.grey), 
              labelText: 'Apellido paterno *', 
              labelStyle: _style,
              errorText: snapshot.error
          ), 
          onChanged: trabajadorBloc.changeAp, 
        );
      },
    );
  }
  Widget _apMaterno(){
    return StreamBuilder(
      stream: trabajadorBloc.amStream, 
      initialData: trabajadorBloc.am,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(  
          initialValue: snapshot.hasData ? snapshot.data:'',
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd))),
              enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd)),),
              hintStyle: TextStyle(color:Colors.grey), 
              labelText: 'Apellido materno *',
              labelStyle: _style,
              errorText: snapshot.error
          ), 
          onChanged: trabajadorBloc.changeAm, 
        );
      },
    );
  }
  Widget _rfc(){
    return StreamBuilder(
      stream: trabajadorBloc.rfcStream, 
      initialData: trabajadorBloc.rfc,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(  
          initialValue: snapshot.hasData ? snapshot.data:'',
          textCapitalization: TextCapitalization.sentences,
          keyboardType: TextInputType.text,
          decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd))),
              enabledBorder: UnderlineInputBorder(      
                              borderSide: BorderSide(color:Color(0xffdddddd)),),
              hintStyle: TextStyle(color:Colors.grey), 
              labelText: 'RFC *',
              labelStyle: _style,
              errorText: snapshot.error
          ), 
          onChanged: trabajadorBloc.changeRfc, 
        );
      },
    );
  }
 

  Widget _crearBoton(String opcion){
   Stream stream ; 
   if(opcion == 'nombre'){
     stream = trabajadorBloc.nombreStream;
   }else if(opcion == 'ap'){
     stream = trabajadorBloc.apStream;
   }else if(opcion == 'am'){
     stream = trabajadorBloc.amStream;
   }else if(opcion == 'rfc'){
     stream= trabajadorBloc.rfcStream;
   } 

    return  StreamBuilder(
      stream: stream, 
      builder: (BuildContext context, AsyncSnapshot snapshot){
       return  IconButton(
         icon: Icon(LineIcons.save, color: MyColors.GreyIcon,), 
         onPressed: snapshot.hasData ? () => _submit(opcion) : null,      
      );
      },
    );
  }


  void _submit(String input){  
    print('actualizar usuario');  
    print("+++++++++++++++++++++++++++++++++");  

    setState(() {
     _isLoading=true;
    });

     switch (input) {
       case 'nombre':
          print(trabajadorBloc.nombre);
          _trabajadorService.updateNombre(trabajadorBloc.nombre);
          setState(() {_isLoading=false;});
          Navigator.pop(context); 
          
        break;
        case 'ap': 
          print(trabajadorBloc.ap); 
          _trabajadorService.updateApaterno(trabajadorBloc.ap);
          setState(() {_isLoading=false;});
          Navigator.pop(context);
        break;
        
        case 'am': 
          print(trabajadorBloc.am);
          _trabajadorService.updateAmaterno(trabajadorBloc.am);
          setState(() {_isLoading=false;});
          Navigator.pop(context);
        break; 

        case 'rfc': 
          print(trabajadorBloc.rfcStream);
          _trabajadorService.updateRfc(trabajadorBloc.rfc);
           setState(() {_isLoading=false;});
          Navigator.pop(context);
        break;
 
       default:
     } 
   
  }
}
 