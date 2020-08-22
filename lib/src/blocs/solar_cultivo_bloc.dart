
import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/providers/solares_cultivos_provider.dart';
import 'package:rxdart/rxdart.dart';

class SolarCultivoBloc with Validators{
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
  
  final _solarNombreController = new BehaviorSubject<String>();
  final _solarLargoController = new BehaviorSubject<String>();
  final _solarAnchoController = new BehaviorSubject<String>();
  final _solarDescripController = new BehaviorSubject<String>();

  final _solarActiveController = new BehaviorSubject<Solar>();
  final _cultivoActiveController = new BehaviorSubject<Cultivo>();
  final _cultivoLiActivController = new BehaviorSubject<List<Cultivo>>();

  Stream<List<Solar>> get solaresStream => _solaresController.stream;
  Stream<String> get regionStream => _regionController.stream;
  Stream<String> get distritoStream => _distritoController.stream;
  Stream<String> get municipioStream => _municipioController.stream;


  Stream<String> get solarNombreStream => _solarNombreController.stream.transform(validateSolarNombre);
  Stream<String> get solarLargoStream => _solarLargoController.stream.transform(validateSolarLargo);
  Stream<String> get solarAnchoStream => _solarAnchoController.stream.transform(validateSolarAncho);
  Stream<String> get solarDescripStream => _solarDescripController.stream.transform(validateSolarDescripcion);

  Stream<Solar> get solarActiveStream => _solarActiveController.stream;
  Stream<List<Cultivo>> get cultivosLiActive => _cultivoLiActivController.stream;
  Stream<Cultivo> get cultivoActiveStream => _cultivoActiveController.stream;


  Function(String) get changeRegion => _regionController.sink.add;
  Function(String) get changeDistrito => _distritoController.sink.add;
  Function(String) get changeMunicipio => _municipioController.sink.add;

  Function(String) get changeSolarNombre => _solarNombreController.sink.add;
  Function(String) get changeSolarLargo => _solarLargoController.sink.add;
  Function(String) get changeSolarAncho => _solarAnchoController.sink.add;
  Function(String) get changeSolarDescrip => _solarDescripController.sink.add;

  Function(Solar) get changeSolarActive => _solarActiveController.sink.add;
  Function(Cultivo) get changeCultivoActive => _cultivoActiveController.sink.add;
  Function(List<Cultivo>) get changeCultivoLiActiv => _cultivoLiActivController.sink.add;

  List<Solar> get solaresLi => _solaresController.value;
  String get region => _regionController.value;
  String get distrito => _distritoController.value;
  String get municipio => _municipioController.value;
  String get solarNombre => _solarNombreController.value;
  String get solarLargo => _solarLargoController.value;
  String get solarAncho => _solarAnchoController.value;
  String get solarDescrip => _solarDescripController.value;
  
  List<Cultivo> get cultivoLi => _cultivoLiActivController.value;

  Solar get solarActive => _solarActiveController.value;
  Cultivo get cultivoActive => _cultivoActiveController.value;

  Stream<bool> get formValidStream => 
    CombineLatestStream.combine2(solarNombreStream, solarLargoStream, (e, p) => true);

  dispose(){
    // _solaresController.close();
    // _regionController.close();
    _solarNombreController.close();
    _solarLargoController.close();
    _solarAnchoController.close();
    _solarDescripController.close();
  }
  

  void solares()async{
    final solares = await _solaresCultivosProvider.loadSolares();
    if(solares!=[] && solares.isNotEmpty){
      solaresList.addAll(solares);
      _solaresController.sink.add(solaresList);
    }
  }
}