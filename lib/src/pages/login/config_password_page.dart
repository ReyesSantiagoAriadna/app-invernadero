import 'package:app_invernadero_trabajador/src/blocs/login_bloc.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/input_password.dart';
import 'package:app_invernadero_trabajador/src/widgets/rounded_button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:line_icons/line_icons.dart';


class ConfigPasswordPage extends StatefulWidget {
  @override
  _ConfigPasswordPageState createState() => _ConfigPasswordPageState();
}

class _ConfigPasswordPageState extends State<ConfigPasswordPage> {
  Responsive responsive;
  LoginBloc bloc;
  SecureStorage _prefs = SecureStorage();
  final TextStyle _style =  TextStyle(color:Colors.grey,fontSize:18);
  bool _isLoading=false;
  
  
  @override
  void initState() {
    super.initState();
    _prefs.route = 'config_password';
    
  }
  
  @override
  void didChangeDependencies() {
    bloc = LoginBloc();
    responsive  = Responsive.of(context);
    super.didChangeDependencies();
  }
  @override
  void dispose() {
    bloc.dispose();
    super.dispose();
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
              child: GestureDetector(
            onTap: (){
              FocusScope.of(context).unfocus();
            },
            child: Container( 
              height: responsive.height,
              child: Stack(
                children:<Widget>[
                  Positioned(
                    child:Container(
                      padding: EdgeInsets.symmetric(horizontal:20,vertical:20),
                      child:  _content(responsive),
                    ),),

                  _isLoading? Positioned.fill(
                    child:  Container(
                    color:Colors.black45,
                    child: Center(
                      child:SpinKitCircle(color: miTema.accentColor),
                    ),),) :Container(),
                ]
              )
            ),
        ),
      ),
    );
  }
  
  Widget _content(Responsive responsive){
   
    return  Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Text("Configurar contraseña",
          textAlign: TextAlign.left,
          style: TextStyle(
            fontSize: 30,
            fontWeight: FontWeight.w400
        ),),
        SizedBox(height:responsive.ip(5)),
        Text("Configura tu contraseña",
            style: TextStyle(
              color: Colors.grey,
            ),
        ),
        SizedBox(height:responsive.ip(5)),
        Text("Contraseña",style:_style),

        StreamBuilder(
            stream: bloc.passwordStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return InputPassword(
                onChange: bloc.changePassword,
              );
            },
          ),

        SizedBox(height:responsive.ip(4)),
        StreamBuilder(
          stream: bloc.passwordStream,
          builder:(BuildContext context,AsyncSnapshot snapshot){
            return Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: <Widget>[
              Text("Debes incluir al menos 2 numeros, letras o signos.", 
                style: TextStyle(color:Colors.grey,fontSize: responsive.ip(1.5)),
              ),
              
              (bloc.password==null|| snapshot.error!=null)?
               Icon(Icons.close,size: 15,color:Colors.red,)
              :
              Icon(LineIcons.check,size: 15,color:Colors.green,),
            ],
            );
          }
        ),
        SizedBox(height:responsive.ip(1)),
        StreamBuilder(
          stream: bloc.passwordStream,
          builder:(BuildContext context,AsyncSnapshot snapshot){
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: <Widget>[
              
              Text("Tu contraseña debe tener entre 8 y 16 caracteres.",
                style: TextStyle(color:Colors.grey,fontSize: responsive.ip(1.5)),
              ),
              (bloc.password==null|| bloc.password.length>16||bloc.password.length<8)?
              Icon(Icons.close,size: 15,color:Colors.red,)
              :
              Icon(LineIcons.check,size: 15,color:Colors.green,),
              ],
            );
        }),
        SizedBox(height:responsive.ip(2)),
        Expanded(
          child: StreamBuilder(
            stream: bloc.passwordStream,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return  Center(
              child: RoundedButton(
                label: "Siguiente", 
                onPressed: snapshot.hasData?()=>_submit(bloc) : null)
              );
            },
          ),
            
        )
      ],);
  }
  
  _submit(LoginBloc bloc)async{
    if(_isLoading)return;

    if(bloc.password.isNotEmpty){ 
      setState(() {
        _isLoading=true;
      });
      await bloc.configPassword(bloc.password);
      
      setState(() {
        _isLoading=false;
      });

     if(bloc.navRoute.contains("error")){
       Flushbar(
        message:  bloc.navRoute,
        duration:  Duration(seconds: 2),              
      )..show(context);
    }else{
      Navigator.pushReplacementNamed(context, bloc.navRoute);
    }
    }
  }
}