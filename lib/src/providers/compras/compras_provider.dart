import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/compras/compras_model.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http; 


class ComprasProvider{
  static final ComprasProvider _ComprasProvider = ComprasProvider._internal();
  factory ComprasProvider(){
    return _ComprasProvider;
  }
  ComprasProvider._internal();
  int _page=0;
  bool _loading=false;
  final _storage = SecureStorage();

  Future<List<Compra>> compras()async{
    if(_loading) return [];
    _loading= false;
    _page++;

    final url = "${AppConfig.base_url}/api/personal/compras?page=$_page"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    print("-----------------compras----------------");
    print(response.body); 
    
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEEE $_page");
       _loading=false;
      return [];
    }  

    
    if(response.body.contains('compras') && response.body.contains('id')){
      CompraModel compras = CompraModel.fromJson(json.decode(response.body));
      _loading=false;
      return compras.compras.values.toList().cast();
    }    
     _loading=false;
    return [];
  }
}