
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/providers/solares_cultivos_provider.dart';
import 'package:rxdart/rxdart.dart';

class SolarCultivoBloc{
  static final SolarCultivoBloc _singleton = SolarCultivoBloc._internal();
  factory SolarCultivoBloc() {
    return _singleton;
  }
  SolarCultivoBloc._internal();
  SolaresCultivosProvider _solaresCultivosProvider = SolaresCultivosProvider();

  List<Solar> solaresList = new List();
  final _solaresController = new BehaviorSubject<List<Solar>>();
  final _regionController = new BehaviorSubject<String>();
  final _distritoController = new BehaviorSubject<String>();
  final _municipioController = new BehaviorSubject<String>();
  
  


  Stream<List<Solar>> get solaresStream => _solaresController.stream;

  Stream<String> get regionStream => _regionController.stream;
  Stream<String> get distritoStream => _distritoController.stream;
  Stream<String> get municipioStream => _municipioController.stream;


  Function(String) get changeRegion => _regionController.sink.add;
  Function(String) get changeDistrito => _distritoController.sink.add;
  Function(String) get changeMunicipio => _municipioController.sink.add;



  String get region => _regionController.value;
  String get distrito => _distritoController.value;
  String get municipio => _municipioController.value;
  

  dispose(){
    _solaresController.close();
    _regionController.close();
  }
  
  void solares()async{
    final solares = await _solaresCultivosProvider.loadSolares();
    if(solares!=[] && solares.isNotEmpty){
      solaresList.addAll(solares);
      _solaresController.sink.add(solaresList);
    }
  }
}