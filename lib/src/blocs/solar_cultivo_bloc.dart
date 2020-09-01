
import 'dart:async';

import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/regiones.dart';
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
  
  
  BehaviorSubject<String> _solarNombreController = new BehaviorSubject<String>();
  final _solarLargoController = new BehaviorSubject<String>();
  final _solarAnchoController = new BehaviorSubject<String>();
  final _solarDescripController = new BehaviorSubject<String>();

  final _solarActiveController = new BehaviorSubject<Solar>();
  final _cultivoActiveController = new BehaviorSubject<Cultivo>();
  final _regionActiveController = new BehaviorSubject<Region>();
  final _distritoActiveController = new BehaviorSubject<Distrito>();
  final _municipioActiveController = new BehaviorSubject<String>();

  // final _cultivoLiActivController = new BehaviorSubject<List<Cultivo>>();

  Stream<List<Solar>> get solaresStream => _solaresController.stream;



  Stream<String> get solarNombreStream => _solarNombreController.stream.transform(validateSolarNombre);
  Stream<String> get solarLargoStream => _solarLargoController.stream.transform(validateSolarLargo);
  Stream<String> get solarAnchoStream => _solarAnchoController.stream.transform(validateSolarAncho);
  Stream<String> get solarDescripStream => _solarDescripController.stream.transform(validateSolarDescripcion);

  Stream<Solar> get solarActiveStream => _solarActiveController.stream;
  Stream<Cultivo> get cultivoActiveStream => _cultivoActiveController.stream;
  Stream<Region> get regionActiveStream => _regionActiveController.stream;
  Stream<Distrito> get distritoActiveStream => _distritoActiveController.stream;
  Stream<String> get municipioActiveStream => _municipioActiveController.stream;



  Function(String) get changeSolarNombre => _solarNombreController.sink.add;
  Function(String) get changeSolarLargo => _solarLargoController.sink.add;
  Function(String) get changeSolarAncho => _solarAnchoController.sink.add;
  Function(String) get changeSolarDescrip => _solarDescripController.sink.add;

  Function(Solar) get changeSolarActive => _solarActiveController.sink.add;
  Function(Cultivo) get changeCultivoActive => _cultivoActiveController.sink.add;
  Function(Region) get changeRegionActive => _regionActiveController.sink.add;
  Function(Distrito) get changeDistritoActive => _distritoActiveController.sink.add;
  Function(String) get changeMunicipioActive => _municipioActiveController.sink.add;


  List<Solar> get solaresLi => _solaresController.value;

  String get solarNombre => _solarNombreController.value;
  String get solarLargo => _solarLargoController.value;
  String get solarAncho => _solarAnchoController.value;
  String get solarDescrip => _solarDescripController.value;
  

  Solar get solarActive => _solarActiveController.value;
  Cultivo get cultivoActive => _cultivoActiveController.value;
  Region get regionActive => _regionActiveController.value;
  Distrito get distritoActive => _distritoActiveController.value;
  String get municipioActive => _municipioActiveController.value;

  

  Stream<bool> get formValidStream => 
    CombineLatestStream.combine7(solarNombreStream, solarLargoStream,
      solarAnchoStream,solarDescripStream,municipioActiveStream,
      regionActiveStream,distritoActiveStream
      , (n, l,a,d,m,r,di) => true);
  
  
  dispose(){
    formValidStream.shareValueSeeded(false);
    // solarNombreController?.close();
    // _solaresController.close();
    // _solarNombreController.close();
    // _solarNombreController.sink.close();
    // _solarNombreController.value = null;
    // _solarNombreController.add(null);
    // _solarLargoController.close();
    // _solarAnchoController.close();
    // _solarDescripController.close();
    // _municipioActiveController.close();
    // _regionController.close();
    _solarNombreController.close();
    _solarLargoController.close();
    _solarAnchoController.close();
    _solarDescripController.close(); 

    
  }
 
  
  void reset(){
    _solarNombreController.sink.addError('*');
    _solarLargoController.sink.addError('*');
    _solarAnchoController.sink.addError('*');
    _solarDescripController.sink.addError('*');
    _regionActiveController.sink.addError('*');
    _distritoActiveController.sink.addError('*');
    _municipioActiveController.sink.addError('');
  }

  void init(){
    print("agregando falso");
  }
  
  void solares()async{
    final solares = await _solaresCultivosProvider.loadSolares();
    if(solares!=[] && solares.isNotEmpty){
      solaresList.addAll(solares);
      _solaresController.sink.add(solaresList);
    }
  }

  
}