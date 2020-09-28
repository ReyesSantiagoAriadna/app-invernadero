import 'dart:async';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:app_invernadero_trabajador/src/providers/nexmo_sms_verify_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/twilio/twilio_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/user_provider.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:rxdart/rxdart.dart';

class LoginBloc with Validators{

  UserProvider _userProvider = UserProvider();
  NexmoSmsVerifyProvider _nexmoSmsVerifyProvider = NexmoSmsVerifyProvider();
  TwilioProvider _twilioProvider = new TwilioProvider();

  static final LoginBloc _singleton = LoginBloc._internal();

  factory LoginBloc() {
    return _singleton;
  }
  
  LoginBloc._internal();
  SecureStorage _prefs = SecureStorage();
  
  
  final _phoneController = BehaviorSubject<String>();
  final _codeController = BehaviorSubject<String>();
  final _passwordController = BehaviorSubject<String>();
  
  final _navRouteController = BehaviorSubject<String>();

  final _loadingController = BehaviorSubject<bool>();
  final _pinCodeController = BehaviorSubject<String>();
  
  Stream<bool> get loadingStream => _loadingController.stream;
  Stream<String> get phoneStream => _phoneController.stream.transform(validarTelefono);
  Stream<String> get passwordStream => _passwordController.stream.transform(validarPassword);
  Stream<String> get pinCodeStream => _pinCodeController.stream.transform(validarPinCode);
  Stream<String> get codeStream => _codeController.stream.transform(validarCodigo);

  Stream<String> get navRouteStream => _navRouteController.stream;


  Function(String) get changeTelefono => _phoneController.sink.add;    
  Function(String) get changePassword => _passwordController.sink.add;
  Function(String) get changeCode => _codeController.sink.add;
  Function(String) get changeNavRoute => _navRouteController.sink.add;
  Function(bool) get changeLoading => _loadingController.sink.add;
  Function(String) get changePinCode => _pinCodeController.sink.add;

  String get phone => _phoneController.value;//.replaceAll(RegExp('[^0-9]'),'');
  String get password => _passwordController.value;
  String get code => _codeController.value;
  String get navRoute => _navRouteController.value;
  bool get loading => _loadingController.value;
  String get pinCode => _pinCodeController.value;

  // String get telefono => _phoneController.value.replaceAll(RegExp('[^0-9]'),'');

  dispose(){
    _codeController.close();
    _navRouteController.close();
    _phoneController.close();
  }
  
  void findPhone(String phone)async{
    print("phone number + $phone");
    changeLoading(true);
    Map response = await _userProvider.findPhone(celular: phone);

    print("responseee: $response");
    if(response['ok']){
      
      switch(response['verificado'].toString().trim()){
        case '0':
          print("verificar");

          Map res = await _twilioProvider.sendCode(celular:AppConfig.twilio_country_code+phone);///await _nexmoSmsVerifyProvider.sendCode(celular: phone);

          if(res['ok'])
            changeNavRoute('pin_code');
          else
            _navRouteController.sink.add('Ha ocurrido un error ${response['message']}');  
        break;
        case '1':
          if(response['password']!=null){
            changeNavRoute('login_password');
          }else{
            changeNavRoute('config_password');            
          }
        break;
        default:
         _navRouteController.sink.add('Ha ocurrido un error ${response['mensaje']}');   
      }
    }else{
      // if(response.containsKey("error")){
        // _navRouteController.sink.add('Ha ocurrido un error ${response['mensaje']}'); 
      //}else{
         _navRouteController.sink.add('Ha ocurrido un error ${response['mensaje']}');      
      // }
      changeLoading(false);
      // changeNavRoute('Ha ocurrido un error ${response['mensaje']}');
    }
  }
  
  void verifyCode(String code)async{
    Map response = await _twilioProvider.verify(code: code); ///_nexmoSmsVerifyProvider.verify(code: code);
    if(response['ok']){
      changeNavRoute('config_password');
    }else{
      print("Ha ocurrido un error en la verificacion");
      changeNavRoute('Ha ocurrido un error en la verificacion');
    }
  } 
  
  void resendOTP()async{
    final phone = await  _prefs.read('celular');
    final response = await _twilioProvider.sendCode(celular:phone);
    if(response['ok'])
      _navRouteController.sink.add('Hemos enviado el código de verificación a tu celular');
    else
      _navRouteController.sink.add('Ha ocurrido un error ${response['message']}');  
  }


  void configPassword(String password)async{
    final phone = await  _prefs.read('celular');
    Map response = await _userProvider.changePassword(celular: phone, password: password);
    if(response['ok']){
      changeNavRoute('menu_drawer');
    }else{
      changeNavRoute('Ha ocurrido un error en la verificacion');
    }
  }

  
  void login(String password)async{
    final phone = await  _prefs.read('celular');
    Map response = await _userProvider.login(celular: phone, password: password);
    
    if(response['ok']){
      changeNavRoute('menu_drawer');
    }else{
      changeNavRoute('Error al ingresar');
    }
  }


  void logOut()async{
    Map response = await _userProvider.logout();
    if(response['ok']){
      changeNavRoute('register_code');
    }else{
      changeNavRoute('Error al ingresar');
    }
  }
}