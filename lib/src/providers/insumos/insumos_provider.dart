import 'dart:convert';
import 'dart:io';

import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/insumos/insumo.dart';
import 'package:app_invernadero_trabajador/src/models/insumos/insumosModel.dart';
import 'package:app_invernadero_trabajador/src/models/proveedores/proveedor.dart';
import 'package:app_invernadero_trabajador/src/models/proveedores/proveedoresModel.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';
import 'package:http/http.dart' as http; 
import 'package:http_parser/http_parser.dart';
import 'package:mime_type/mime_type.dart'; 
 

class InsumosProvider{
  static final InsumosProvider _insumosProvider = InsumosProvider._internal();

  factory InsumosProvider(){
    return _insumosProvider;
  }

  InsumosProvider._internal();

  final _storage = SecureStorage();
  int _page=0;
  bool _loading=false;

  //proveedores
  bool __loadingP = false;
  int _pageP=0;

  bool __loadingS = false;
  int _pageS=0;

  /*Future<List<Insumo>> getInsumos()async{
    if(_loading) return [];
    _loading= false;
    _page++;

    final url = "${AppConfig.base_url}/api/personal/mostrar_insumos?page=$_page"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    print("-----------------Insumos----------------");
    print(response.body); 
    
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEEE $_page");
      return [];
    }  

    if(response.body.contains('insumos') && response.body.contains('id')){
      InsumosModel insumos = InsumosModel.fromJson(json.decode(response.body));
      _loading=false; 
      return insumos.insumos.values.toList().cast();
    }    
    return [];
  } */

   Future<List<Insumo>> getInsumosTerminales()async{
    if(_loading) return [];
    _loading= false;
    _page++;

    final url = "${AppConfig.base_url}/api/personal/in_terminales?page=$_page"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    print("-----------------Insumos terminales----------------");
    print(response.body); 
    
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEEE $_page");
      return [];
    }  

    if(response.body.contains('insumos') && response.body.contains('id')){
      InsumosModel insumos = InsumosModel.fromJson(json.decode(response.body));
      _loading=false;
      return insumos.insumos.values.toList().cast();
    }    
    return [];
  }

  Future<Insumo> addInsumo(Insumo insumo) async {
    final url = "${AppConfig.base_url}/api/personal/addInsumo"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 

      print("-------------insertar-------");  
    
    final response = await http.post(
      url, 
      headers: headers,
      body: {  
          "nombre":insumo.nombre,
          "tipo": insumo.tipo,
          "unidadM":insumo.unidadM,  
          "composicion":insumo.composicion,  
          "cantidadMinima":insumo.cantidadMinima.toString(),
          "observacion": insumo.observacion,
          "url_imagen": insumo.urlImagen
      });

    print("Respues ta ADD----------------");
    print(response.body);
    if(response.body.contains("insumo")&& response.body.contains("id") ){
      Insumo insumoNew = Insumo.fromJson(json.decode(response.body)['insumo']);
      return insumoNew;
    } 
    return null;
  }


  Future<Insumo> updateInsumo(Insumo insumo) async { 
    final url = "${AppConfig.base_url}/api/personal/updInsumo"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",}; 

      print("-------------update-------");  
      print(insumo.toJson());
    
    final response = await http.put(
      url, 
      headers: headers,
      body: { 
          "id_insumo":insumo.id.toString(),
          "nombre":insumo.nombre,
          "tipo": insumo.tipo,
          "unidadM":insumo.unidadM,
          "especie": insumo.especie,
          "tamano":insumo.tamano.toString(),
          "composicion":insumo.composicion, 
          "cantidad": insumo.cantidad.toString(),
          "cantidadMinima":insumo.cantidadMinima.toString(),
          "observacion": insumo.observacion,
          "url_imagen": insumo.urlImagen
      });
 
    if(response.body.contains("insumo") && response.body.contains("id") ){
      print("Respuesta Update----------------${response.body}");
      Insumo insumoUpt = Insumo.fromJson(json.decode(response.body)['insumo']); 
      return insumoUpt;
    } else if(response.body.contains('message') && response.body.contains('existe')){
        return null;
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

   Future<List<Proveedor>> getProveedores()async{
    if( __loadingP) return [];
    __loadingP = true;
    _pageP++;

    final url = "${AppConfig.base_url}/api/personal/getProveedores?page=$_pageP"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);
    
    print("-----------------Proveedores----------------");
    print(response.body); 
    
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEEE $_page");
      return [];
    }  
    if(response.body.contains('proveedores') && response.body.contains('id')){
       ProveedorModel prov = ProveedorModel.fromJson(json.decode(response.body));
      
      __loadingP=false;
      return prov.proveedores.values.toList().cast();
    }

    return []; 
  }

  Future<List<Insumo>> addCompra(List<String> insumos, List<String> cantidades,List<String> precios, int proveedor)async{
    final url = "${AppConfig.base_url}/api/personal/addCompra"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Content-Type" : "application/json",
      "Accept": "application/json",}; 

    final response = await http.post(
      url, 
      headers: headers,
      body: json.encode(
        {           
          "proveedor": proveedor, 
          "insumos":insumos,
          "cantidades":cantidades,
          "precios": precios,
        }
    ));

    print("COMPRA AGREGADA----------------");
    print(response.body);
    
    var decodeData = json.decode(response.body)['insumos'] as List; 
    final List<Insumo> lista = decodeData.map((ofertaTipoJson) => Insumo.fromJson(ofertaTipoJson)).toList();
 

    print(".......................");
    print(lista.length);

    return lista;
  }

 Future<List<Insumo>> loadInsumos()async{  
    if(_loading)return [];
    _loading=true;
    
    _page++;
    
    final url = "${AppConfig.base_url}/api/personal/getInsumosAll?page=$_page"; 
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
    
    if(response.body.contains("insumos") && response.body.contains("id")){
      InsumosModel insumos = InsumosModel.fromJson(json.decode(response.body));
      _loading=false;
      return insumos.insumos.values.toList().cast();
    }
    return [];
  }

  Future<List<Insumo>> loadInsumosSelect()async{  
    if(__loadingS)return [];
    __loadingS=true;
    
    _pageS++;
    
    final url = "${AppConfig.base_url}/api/personal/getInsumosSelect?page=$_pageS"; 
    final token = await _storage.read('token');
    Map<String, String> headers = {
      HttpHeaders.authorizationHeader: "Bearer $token",
      "Accept": "application/json",};
    
    final response = await http.get(
      url, 
      headers: headers,);

    print(response.body);
    if(response.body.contains('page_on_limit')){
      print("PAGEEEEEE $_pageS");
      return[];
    } 
    
    if(response.body.contains("insumos") && response.body.contains("id")){
      InsumosModel insumos =  InsumosModel.fromJson(json.decode(response.body));
      __loadingS=false;
      return insumos.insumos.values.toList().cast();
    }
    return [];
  }
}


