
import 'package:app_invernadero_trabajador/src/models/feature/feature_model.dart';
import 'package:app_invernadero_trabajador/src/models/weather/weather_bit.dart';
import 'package:app_invernadero_trabajador/src/models/weather/weather_model.dart';
import 'package:app_invernadero_trabajador/src/providers/mapbox_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/weather/weather_provider.dart';
import 'package:geolocator/geolocator.dart';
import 'package:rxdart/subjects.dart';
import 'package:latlong/latlong.dart';

import 'package:flutter_map/flutter_map.dart';

class MapBoxBloc{

  static final MapBoxBloc _singleton = MapBoxBloc._internal();
  factory MapBoxBloc() {
    return _singleton;
  }
  MapBoxBloc._internal();
  
  MapBoxProvider _mapBoxProvider = MapBoxProvider(); 
  WeatherProvider weatherProvider = WeatherProvider();


  final _featureController = new BehaviorSubject<Feature>();
  final  _positionController = new BehaviorSubject<Position>();
  final _weatherController = new BehaviorSubject<WeatherModel>();
  final _weatherBitController = new BehaviorSubject<WeatherBit>();

  Stream<Feature> get featureStream => _featureController.stream;
  Stream<Position> get positionStream => _positionController.stream;
  Stream<WeatherModel> get climaStream => _weatherController.stream;
  Stream<WeatherBit> get weatherBitStream => _weatherBitController.stream;

  Function(Feature) get changeFeature => _featureController.sink.add;
  Function(Position) get changePosition => _positionController.sink.add;
  Function(WeatherBit) get changeWeatherBit => _weatherBitController.sink.add;

  Feature get feature => _featureController.value;
  Position get position => _positionController.value;
  WeatherModel get clima => _weatherController.value;  
  WeatherBit get weatherBit => _weatherBitController.value;


  dipose(){
    _featureController.close();
    _positionController.close();
  }

  void getClima()async{
    final clima =  await weatherProvider.getWeather(position.latitude, position.longitude);
    if(clima!=null){
      _weatherController.sink.add(clima);
    }
  }

  void getWeatherBit()async{
    final clima =  await weatherProvider.getWeatherBit(position.latitude, position.longitude);
    if(clima!=null){
      _weatherBitController.sink.add(clima);
    }
  }

}