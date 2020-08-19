import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/login_bloc.dart';
import 'package:app_invernadero_trabajador/src/providers/user_provider.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/input_text.dart';
import 'package:app_invernadero_trabajador/src/widgets/rounded_button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';

class CodeRegisterPage extends StatefulWidget {
  @override
  _CodeRegisterPageState createState() => _CodeRegisterPageState();
}

class _CodeRegisterPageState extends State<CodeRegisterPage> {
  Responsive responsive;
  LoginBloc bloc;
  UserProvider userProvider;
  bool _isLoading=false;
  SecureStorage _prefs = SecureStorage();

  @override
  void initState() {
    userProvider = UserProvider();
    _prefs.route = 'register_code'; //save route
    FlutterStatusbarcolor.setStatusBarColor(Colors.transparent);
    FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
    super.initState();
  }

  @override
  void didChangeDependencies() {
    responsive = Responsive.of(context);
    bloc = LoginBloc();

    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
     return Scaffold(
      backgroundColor: Colors.white,
      body: GestureDetector(
          onTap: (){
            FocusScope.of(context).unfocus();
          },
          child: Container( 
            height: responsive.height,
            child: Stack(
              children:<Widget>[
                Positioned(
                  child: Column(  
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                  _image(),
                  SizedBox(height: responsive.ip(2),),
                  Text("Ingresa tu código de SSInvernadero",
                    textAlign: TextAlign.center,
                    style: TextStyle(
                      fontSize:responsive.ip(3.5),
                      fontWeight:FontWeight.bold),
                  ),
                  SizedBox(height: responsive.ip(4),),
                  _inputText(bloc),
                  SizedBox(height: responsive.ip(2),),    
                  GestureDetector(
                    onTap: ()=>Navigator.pushReplacementNamed(context, 'login_phone'),
                    child:  Text("Ya tengo una cuenta",style: TextStyle(
                    color:miTema.accentColor, fontFamily:AppConfig.quicksand,
                    fontWeight: FontWeight.w700,fontSize: responsive.ip(1.5)
                  ),),
                  ) , 
                  SizedBox(height: responsive.ip(2),),  
                  Align(
                    alignment: Alignment.bottomCenter,
                    child: _createButon(bloc),
                  )
                ],),),

                 _isLoading? Positioned.fill(child:  Container(
                    color:Colors.black45,
                    child: Center(
                      child:SpinKitCircle(color: miTema.accentColor),
                    ),
                  ),):Container()
              ]
            )
          ),
      ),
    );
  }
  Widget _createButon(LoginBloc bloc){
    return StreamBuilder(
      stream: bloc.codeStream,
      builder: (BuildContext context,AsyncSnapshot snapshot){
        return RoundedButton(
          label: "Siguiente", 
          onPressed: 
          snapshot.hasData?
          ()=>_registerCode()
          :null
        );
      }
    );
  } 

  _registerCode()async{
    if(_isLoading)return;
    
    setState(() {
      _isLoading=true;
    });

    Map info = await userProvider.findCode(code: bloc.code);
    
    setState(() {
      _isLoading=false;
    });

    if(info['ok']){
      print("CELULAR:");
      print(info['celular']);
      Navigator.pushReplacementNamed(context, 'login_phone');
    }else{
      Flushbar(
        message:  "El código es incorrecto",
        duration:  Duration(seconds: 2),              
      )..show(context);
      print("Ha ocurrido un error");   
    }
    
    
  }
  
  Widget _inputText(LoginBloc bloc) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:40),
      child: StreamBuilder( 
        stream: bloc.codeStream,
        builder: (BuildContext context,AsyncSnapshot snapshot){
        return InputText(
          placeholder: 'Código',
          validator: (String text){
          },
          inputType: TextInputType.text,
          icon: LineIcons.qrcode,
          onChange: bloc.changeCode,
          errorText: snapshot.error,
        );
      }),
    );
  }
  
  Widget _image() {
    return AspectRatio(
      aspectRatio: 16/7,
      child: LayoutBuilder(
        builder:(_,contraints){
          return Container(
            child:  SvgPicture.asset('assets/images/code_img.svg',
              height: contraints.maxHeight*.4,
              width: contraints.maxWidth,
            ),
          );
        }
      )
    );
  }
}