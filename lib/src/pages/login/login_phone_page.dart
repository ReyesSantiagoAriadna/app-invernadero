import 'package:app_invernadero_trabajador/src/blocs/login_bloc.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/input_text.dart';
import 'package:app_invernadero_trabajador/src/widgets/mask_text_input_formatter.dart';
import 'package:app_invernadero_trabajador/src/widgets/rounded_button.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_statusbarcolor/flutter_statusbarcolor.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
class LoginPhonePage extends StatefulWidget {
  LoginPhonePage({Key key}) : super(key: key);

  @override
  _LoginPhonePageState createState() => _LoginPhonePageState();
}


class _LoginPhonePageState extends State<LoginPhonePage> {
  SecureStorage _prefs = SecureStorage();
  Responsive responsive;
  LoginBloc bloc;
  var textEditingController = TextEditingController();
  var maskTextInputFormatter = MaskTextInputFormatter(mask: "(###) ###-##-##", 
  filter: { "#": RegExp(r'[0-9]') });
  bool _isLoading = false;

  @override
  void initState() {
    // FlutterStatusbarcolor.setStatusBarColor(Colors.white);
    // FlutterStatusbarcolor.setStatusBarWhiteForeground(false);
     _prefs.route = 'login_phone'; //save route
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
                    Text("¿Cuál es tu número de teléfono?",
                      textAlign: TextAlign.center,
                      style: TextStyle(
                        fontSize:30.0,
                        fontWeight:FontWeight.bold),
                    ),
                    SizedBox(height: responsive.ip(2),),        
                    Text("Ingresa tu numéro de teléfono",
                      style: TextStyle(color:Color(0xffbbbbbb),),
                      textAlign: TextAlign.left,
                    ),
                    SizedBox(height: responsive.ip(4),),
                    _inputText(bloc),
                    SizedBox(height: responsive.ip(5),),       
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
      stream: bloc.phoneStream,
      builder: (BuildContext context,AsyncSnapshot snapshot){
        return RoundedButton(
          label: "Siguiente", 
          onPressed: snapshot.hasData
          ?()=>_loginOrRegister()
          :null
        );
      }
    );
  }


  Widget _image() {
    return AspectRatio(
      aspectRatio: 16/6,
      child: LayoutBuilder(
        builder:(_,contraints){
          return Container(
            child:  SvgPicture.asset('assets/images/login_img.svg',
              height: contraints.maxHeight*.4,
              width: contraints.maxWidth,
            ),
          );
        }
      )
    );
  }


  _loginOrRegister()async{
    if(_isLoading)return;
    
    setState(() {
      _isLoading=true;
    });

    await bloc.findPhone(bloc.phone);
    
    setState(() {
      _isLoading = false;
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

  Widget _inputText(LoginBloc bloc) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal:40),
      child: StreamBuilder(
        
        stream: bloc.phoneStream,
        builder: (BuildContext context,AsyncSnapshot snapshot){
        return InputText(
          placeholder: 'Teléfono',
          validator: (String text){
          },
          inputType: TextInputType.phone,
          icon: LineIcons.mobile_phone,
          onChange: bloc.changeTelefono,
          errorText: snapshot.error,
          inputFormatters: [maskTextInputFormatter], 
                        autocorrect: false, 
        );
      }),
    );
  }
}

