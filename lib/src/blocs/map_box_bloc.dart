
import 'package:app_invernadero_trabajador/src/models/feature/feature_model.dart';
import 'package:app_invernadero_trabajador/src/providers/mapbox_provider.dart';
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

  final _featureController = new BehaviorSubject<Feature>();
  final  _positionController = new BehaviorSubject<Position>();

  Stream<Feature> get featureStream => _featureController.stream;
  Stream<Position> get positionStream => _positionController.stream;


  Function(Feature) get changeFeature => _featureController.sink.add;
  Function(Position) get changePosition => _positionController.sink.add;


  Feature get feature => _featureController.value;
  Position get position => _positionController.value;

  dipose(){
    _featureController.close();
    _positionController.close();
  }

}