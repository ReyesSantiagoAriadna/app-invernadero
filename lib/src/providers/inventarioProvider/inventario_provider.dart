import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero_trabajador/src/models/inventario_herramientas/herramientasModel.dart';
import 'package:http/http.dart' as http; 
import 'package:http_parser/http_parser.dart'; 
import 'package:mime_type/mime_type.dart';
import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/inventario_herramientas/herramienta.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';

class InventarioProvider{
  static final InventarioProvider _inventarioProvider = InventarioProvider._internal();

  factory InventarioProvider(){
    return _inventarioProvider;
  }

  InventarioProvider._internal();

  final _storage = SecureStorage();
  int _page=0;
  bool _loading=false;

  Future<List<Herramienta>> cargarHerramientas() async{
    if(_loading) return [];
    _loading = true;
    _page++;

    final url = "${AppConfig.base_url}/api/personal/mostrar_inventario?page=$_page"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    print("-----------------Herramientas----------------");
    print(response.body); 
    
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEEE $_page");
      return [];
    }  

    if(response.body.contains('herramientas') && response.body.contains('id')){
      HerramientasModel herramientas = HerramientasModel.fromJson(json.decode(response.body));
      _loading=false;
      return herramientas.herramientas.values.toList().cast();
    }    
    return [];
  }

  Future<Herramienta> addHerramienta(Herramienta herramienta) async{
    final url = "${AppConfig.base_url}/api/personal/add_herramienta"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 

      print("-------------insertar-------"); 
      //print(herramienta.toJson()); 
    
    final response = await http.post(
      url, 
      headers: headers,
      body: {  
        "nombre":herramienta.nombre,
        "descripcion": herramienta.descripcion,
        "cantidad":herramienta.cantidad.toString(),
        "urlImagen": herramienta.urlImagen,
      });

    print("Respuesta ADD herramienta----------------");
    print(response.body);
    if(response.body.contains("herramienta")&& response.body.contains("id") ){
      Herramienta herramientaNew = Herramienta.fromJson(json.decode(response.body)['herramienta']);
      return herramientaNew;
    } 
    return null;
  }

  Future<Herramienta> updateHerramienta(Herramienta herramienta) async{
    final url = "${AppConfig.base_url}/api/personal/upd_herramienta"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 

      print("-------------update-------");  
      print(herramienta.urlImagen);

      final response =  await http.put(
        url,
        headers: headers,
        body: {
          "id_herramienta":herramienta.id.toString(),
          "nombre":herramienta.nombre,
          "descripcion": herramienta.descripcion,
          "cantidad":herramienta.cantidad.toString(),
          "urlImagen": herramienta.urlImagen,
        }
      );

      if(response.body.contains('herramienta') && response.body.contains('id')){
        print("Respuesta Update herramienta---------------${response.body}");
        Herramienta herramientaUpdate = Herramienta.fromJson(json.decode(response.body)['herramienta']);
        return herramientaUpdate;
      }else if(response.body.contains('message') && response.body.contains('existe')){
        return null;
      }

  }


   Future<String> subirImagenCloudinary(File imagen) async{
    final url = Uri.parse('https://api.cloudinary.com/v1_1/dtev8lpem/image/upload?upload_preset=f9k9os9d');
    final mimeType = mime(imagen.path).split('/'); //image/jpeg

    final imageUploadRequest = http.MultipartRequest( //peticion para subir el archivo
      'POST',
      url
    );

    final file = await http.MultipartFile.fromPath( //se carga el archivo
      'file', 
      imagen.path,
      contentType: MediaType(mimeType[0], mimeType[1]),
    );

    imageUploadRequest.files.add(file);
    
    final streamResponse = await imageUploadRequest.send();
    final resp = await http.Response.fromStream(streamResponse);

    if (resp.statusCode != 200 && resp.statusCode != 201) {
        print('Algo salio mal');
        print(resp.body);
        return null;
    }

    final respData = json.decode(resp.body);
    print(respData);

    return respData['secure_url'];
  } 

   Future<bool> deleteHerramienta(int idHerramienta) async{
    final url = "${AppConfig.base_url}/api/personal/delete_herramienta/$idHerramienta"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};

    final response = await http.delete(
      url, 
      headers: headers, 
      );
    print("HERRAMIENTAS RESPUESTA DELETE----------------");
    print(response.body);
    
    if(response.body.contains("message") && response.body.contains("success")){
      print("eliminando");
      return true;
    }
    if(response.statusCode==200)
      return true;

    print("Error al eliminar");
    return false;
  }

}