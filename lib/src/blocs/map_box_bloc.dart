
import 'package:app_invernadero_trabajador/src/models/feature/feature_model.dart';
import 'package:app_invernadero_trabajador/src/providers/mapbox_provider.dart';
import 'package:rxdart/subjects.dart';

class MapBoxBloc{

  static final MapBoxBloc _singleton = MapBoxBloc._internal();
  factory MapBoxBloc() {
    return _singleton;
  }
  MapBoxBloc._internal();
  
  MapBoxProvider _mapBoxProvider = MapBoxProvider(); 

  final _featureController = new BehaviorSubject<Feature>();
  
  Stream<Feature> get featureStream => _featureController.stream;


  Function(Feature) get changeFeature => _featureController.sink.add;
  
  Feature get feature => _featureController.value;


}