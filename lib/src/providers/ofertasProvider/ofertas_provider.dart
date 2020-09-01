import 'dart:convert';
import 'dart:io';
import 'package:app_invernadero_trabajador/src/models/ofertas/ofertaModel.dart';
import 'package:app_invernadero_trabajador/src/models/ofertas/ofertaTipo.dart';
import 'package:app_invernadero_trabajador/src/models/productos/producto.dart';
import 'package:http/http.dart' as http; 
import 'package:http_parser/http_parser.dart'; 
import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/ofertas/oferta.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mime_type/mime_type.dart';

class OfertaProvider{
  static final OfertaProvider _ofertaProvider = OfertaProvider._internal();

  factory OfertaProvider(){
    return _ofertaProvider;
  }

  OfertaProvider._internal();
  final _storage = SecureStorage();
  int _page=0;
  bool _loading=false;

  Future<List<Oferta>> cargarOfertas()async{
    if(_loading) return [];
    _loading = true;
    _page++;

    final url = "${AppConfig.base_url}/api/personal/mostrar_ofertas?page=$_page"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);
    
    print("-----------------Solares Respuesta----------------");
    print(response.body); 
    
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEEE $_page");
      return [];
    } 

    if(response.body.contains('ofertas') && response.body.contains('id')){
       OfertaModel ofertas = OfertaModel.fromJson(json.decode(response.body));
      
      _loading=false;
      return ofertas.ofertas.values.toList().cast();
    }

    return [];    
  }

  Future<List<OfertaTipo>> cargarOfertasTipos() async {
    final url = "${AppConfig.base_url}/api/personal/tipos_oferta"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);
    
    print("-----------------Tipos ofertas----------------");
    print(response.body); 
    
    if(response.body.contains('error')){
      return [];
    } 

    var decodeData = json.decode(response.body)['tiposOferta'] as List; 
    final List<OfertaTipo> ofertaTipoList = decodeData.map((ofertaTipoJson) => OfertaTipo.fromJson(ofertaTipoJson)).toList();
 

    print(".......................");
    print(ofertaTipoList.length);

    return ofertaTipoList;
  }

  
  Future<Oferta> terminarOferta(int idOferta) async{
    final url = "${AppConfig.base_url}/api/personal/terminarOferta"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
 

    final response = await http.put(
      url, 
      headers: headers,
      body: {
        "idOferta": idOferta.toString(),
      }
      );
    
    if(response.body.contains("oferta") && response.body.contains("id")){
       print("OFERTA TERMINADA RESPUESTA ---------------");  
       print(response.body);
       Oferta ofertTerminada = Oferta.fromJson(json.decode(response.body)['oferta']);
      return ofertTerminada;
    } 
    return null;
  }

  Future<Oferta> addOferta(Oferta oferta)async{
    final url = "${AppConfig.base_url}/api/personal/createOferta"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 

      print("-------------insertar-------"); 
      print(oferta.toJson()); 
    
    final response = await http.post(
      url, 
      headers: headers,
      body: { 
        "tipoOferta": oferta.idTipo.toString(), 
        "id_producto": oferta.idProducto.toString(), 
        "descripcion": oferta.descripcion,
        "url_imagen": oferta.urlImagen,
        "inicio": oferta.inicio,
        "fin": oferta.fin
      });

    print("Respuesta ADD OFERTA----------------");
    print(response.body);
    if(response.body.contains("oferta")&& response.body.contains("id") ){
      Oferta ofertaNew = Oferta.fromJson(json.decode(response.body)['oferta']);
      return ofertaNew;
    } 
    return null;
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