import 'dart:convert';
import 'dart:io';
import 'package:app_invernadero_trabajador/src/models/productos/productosModel.dart';
import 'package:app_invernadero_trabajador/src/models/weather/weather_bit.dart';
import 'package:app_invernadero_trabajador/src/models/weather/weather_model.dart';
import 'package:http/http.dart' as http; 
import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/productos/producto.dart';
import 'package:app_invernadero_trabajador/src/storage/secure_storage.dart';

class WeatherProvider{
  static final WeatherProvider _WeatherProvider = WeatherProvider._internal();

  factory WeatherProvider(){
    return _WeatherProvider;
  }

  WeatherProvider._internal();

  String lang="es";
  String unitss ="metric";

  Future<WeatherModel> getWeather(double lat,double long) async{
    
    final url = "${AppConfig.base_url_open_weather}?lat=$lat&lon=$long&appid=${AppConfig.weather_api_key}&lang=$lang&units=$unitss"; 
   
    
    final response = await http.get(
      url,);
    
    print("-----------------whether Response----------------");
    print(response.body); 
    
    if(response.statusCode!=200){
      return  null;
    }

    if(response.body.contains("weather")&& response.body.contains("main")){
      WeatherModel clima = WeatherModel.fromJson(json.decode(response.body));
      return clima;
    }
    return null;
  }


  
  Future<WeatherBit> getWeatherBit(double lat,double long) async{
    
    final url = "${AppConfig.weather_bit_url}?lang=$lang&lat=$lat&lon=$long&key=${AppConfig.weather_bit_api_key}"; 
    
    final response = await http.get(
      url,);
    
    print("-----------------whether Response----------------");
    print(response.body); 
  
    if(response.statusCode!=200){
      return  null;
    }
    if(response.body.contains("weather")&& response.body.contains("temp")){
      WeatherBit clima = WeatherBit.fromJson(json.decode(response.body));
      return clima;
    }
    return null;
  }

  //?lang=es&lat=17.06542&lon=-96.72365&key=694f92dc92894c45ad8e75fdff5e3fe4
}