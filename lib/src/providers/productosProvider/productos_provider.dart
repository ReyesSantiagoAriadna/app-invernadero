import 'dart:convert';
import 'dart:io';
import 'package:app_invernadero_trabajador/src/models/productos/productosModel.dart';
import 'package:http/http.dart' as http; 
import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/productos/producto.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';

class ProductosProvider{
  static final ProductosProvider _productosProvider = ProductosProvider._internal();

  factory ProductosProvider(){
    return _productosProvider;
  }

  ProductosProvider._internal();
  final _storage = SecureStorage(); 
   int _page=0;
   bool _loading=false;

  Future<List<Producto>> cargarProductos() async{
    if(_loading) return [];
    _loading = true;
    _page++;

    final url = "${AppConfig.base_url}/api/personal/productosOfertas?page=$_page"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);
    
    print("-----------------Producto Respuesta----------------");
    print(response.body); 
    
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEEE $_page");
      return [];
    } 

    if(response.body.contains('productos') && response.body.contains('id')){
       ProductosModel producto = ProductosModel.fromJson(json.decode(response.body));
      
      _loading=false;
      return producto.productos.values.toList().cast();
    }

    return [];    
  }
}