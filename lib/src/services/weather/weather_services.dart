import 'package:app_invernadero_trabajador/src/models/actividades/gastos_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:app_invernadero_trabajador/src/models/pedidos/fecha_pedido_model.dart';
import 'package:app_invernadero_trabajador/src/models/pedidos/pedido_model.dart';
import 'package:app_invernadero_trabajador/src/models/weather/weather_model.dart';
import 'package:app_invernadero_trabajador/src/providers/actividades/gastos_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/pedidos/pedidos_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/weather/weather_provider.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class WeatherService with ChangeNotifier{
  
  WeatherProvider weatherProvider = WeatherProvider();

  final _weatherController = new BehaviorSubject<WeatherModel>();

  Stream<WeatherModel> get climaStream => _weatherController.stream;

  WeatherModel get clima => _weatherController.value;  
  
  // WeatherService(){
  //   this.getClima();
  // }
  


  // Future<bool> getClima(double lat,double long)async{
  //   final clima =  await weatherProvider.getWeather(lat, long);
  //   if(clima!=null){
  //     _weatherController.sink.add(clima);
  //   }
  //   notifyListeners();
  //   return false;
  // }

  
}