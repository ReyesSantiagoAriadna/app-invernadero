import 'dart:io';
import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/plagasEnfermedades/plaga.dart';
import 'package:app_invernadero_trabajador/src/models/plagasEnfermedades/plagaModel.dart';
import 'package:http/http.dart' as http; 
import 'package:http_parser/http_parser.dart'; 
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:mime_type/mime_type.dart';
 

class PlagaProvider{

  static final PlagaProvider _plagaProvider = PlagaProvider._internal();

  factory PlagaProvider() {
    return _plagaProvider;
  }

  PlagaProvider._internal();

  final _storage = SecureStorage();
  int _page=0;
  bool _loading=false;

  Future<List<Plagas>> cargarPlagas() async{
    if(_loading) return [];
    _loading = true;
    _page++;

    final url = "${AppConfig.base_url}/api/personal/mostrar_plagas?page=$_page"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);
    
    print("-----------------Plagas----------------");
    print(response.body); 
    
    if(response.body.contains('page_on_limit')){
      return [];
    } 

    if(response.body.contains('plagas') && response.body.contains('id')){
      PlagasModel plagas = PlagasModel.fromJson(json.decode(response.body));
      _loading = false;
      return plagas.plagas.values.toList().cast();
    } 

    return [];
  } 

  Future<Plagas> addPlaga(Plagas plaga) async {
    final url = "${AppConfig.base_url}/api/personal/agregar_plaga"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 

      print("-------------insertar-------"); 
      print(plaga.toJson()); 
    
    final response = await http.post(
      url, 
      headers: headers,
      body: { 
        "idCultivo":plaga.idCultivo.toString(),
        "nombre":plaga.nombre,
        "fecha": plaga.fecha,
        "observacion":plaga.observacion,
        "tratamiento":plaga.tratamiento, 
        "url_imagen":plaga.urlImagen
      });

    print("Respues ta ADD----------------");
    print(response.body);
    if(response.body.contains("plaga")&& response.body.contains("id") ){
      Plagas plagaNew = Plagas.fromJson(json.decode(response.body)['plaga']);
      return plagaNew;
    } 
    return null;
  }

   Future<Plagas> updatePlaga(Plagas plaga) async { 
    final url = "${AppConfig.base_url}/api/personal/update_plaga"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 

      print("-------------update-------"); 
      print(plaga.toJson());
    
    final response = await http.put(
      url, 
      headers: headers,
      body: { 
        "id_plaga":plaga.id.toString(),
        "idCultivo": plaga.idCultivo.toString(),
        "nombre":plaga.nombre,
        "fecha": plaga.fecha,
        "observacion":plaga.observacion,
        "tratamiento":plaga.tratamiento, 
        "url_imagen":plaga.urlImagen
      });
 
    if(response.body.contains("plaga") && response.body.contains("id") ){
      print("Respuesta Update----------------${response.body}");
      Plagas plagaUpdate = Plagas.fromJson(json.decode(response.body)['plaga']); 
      return plagaUpdate;
    } 
    return null;
  }
 
  Future<bool> deletePlaga(int idPlaga) async{
    final url = "${AppConfig.base_url}/api/personal/delete_plaga/$idPlaga"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};

    final response = await http.delete(
      url, 
      headers: headers,
      );
    print("PLAGA RESPUESTA DELETE----------------");
    print(response.body);
    
    if(response.body.contains("plaga eliminada") && response.body.contains("success")){
      print("eliminando");
      return true;
    }
    if(response.statusCode==200)
      return true;

    print("Error al eliminar");
    return false;
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

   
  
}