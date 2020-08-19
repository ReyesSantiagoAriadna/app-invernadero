
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
  Stream<List<Solar>> get solaresStream => _solaresController.stream;


  dispose(){
    _solaresController.close();
  }
  
  void solares()async{
    final solares = await _solaresCultivosProvider.loadSolares();
    if(solares!=[] && solares.isNotEmpty){
      solaresList.addAll(solares);
      _solaresController.sink.add(solaresList);
    }
  }
}