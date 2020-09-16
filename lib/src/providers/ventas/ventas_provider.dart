
import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/ventas/ventas_model.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http;

class VentasProvider{
  static final VentasProvider _ventasProvider = VentasProvider._internal();

  factory VentasProvider(){
    return _ventasProvider;
  }

  VentasProvider._internal();

  final _storage = SecureStorage();  
  int _page=0;
  bool _loading=false;

  Future<List<Venta>> cargarVentas()async{
    if(_loading)return [];
    _loading=true;    
    _page++;

    final url = "${AppConfig.base_url}/api/personal/ventas?page=$_page"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    print(response.body);
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEE $_page");
      return[];
    } 
    
    if(response.body.contains("ventas") && response.body.contains("id")){
      print(response.body);
      VentasModel ventas = VentasModel.fromJson(json.decode(response.body));
      _loading=false;
      return ventas.ventas.values.toList().cast();
    }
    return [];
  }
}
