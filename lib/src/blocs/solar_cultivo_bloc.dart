
import 'dart:async';

import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/etapa_cultivo.dart';
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
  
  List<Etapa> etapasList = [];
  
  BehaviorSubject<String> _solarNombreController = new BehaviorSubject<String>();
  final _solarLargoController = new BehaviorSubject<String>();
  final _solarAnchoController = new BehaviorSubject<String>();
  final _solarDescripController = new BehaviorSubject<String>();
  
  final _solarHomeController = new BehaviorSubject<Solar>();
  final _cultivoHomeController = new BehaviorSubject<Cultivo>();

  final _solarActiveController = new BehaviorSubject<Solar>();
  final _cultivoActiveController = new BehaviorSubject<Cultivo>();
  final _etapaActiveController = new BehaviorSubject<Etapa>();

  final _regionActiveController = new BehaviorSubject<Region>();
  final _distritoActiveController = new BehaviorSubject<Distrito>();
  final _municipioActiveController = new BehaviorSubject<String>();

  final _solarController = new BehaviorSubject<Solar>();
  final _cultivoTipoController = new BehaviorSubject<String>();
  // final _cultivoLiActivController = new BehaviorSubject<List<Cultivo>>();

  final _cultivoSensoresController = new BehaviorSubject<bool>();
  final _tempMinController = new BehaviorSubject<String>();
  final _tempMaxController = new BehaviorSubject<String>();
  final _humMinController = new BehaviorSubject<String>();
  final _humMaxController = new BehaviorSubject<String>();
  final _humSMinController = new BehaviorSubject<String>();
  final _humSMaxController = new BehaviorSubject<String>();

  final _fechaInicioController =  new BehaviorSubject<String>();
  final _fechaTerminacionController = new BehaviorSubject<String>();

  final _listEtapasController = new BehaviorSubject<List<Etapa>>();
  final _etapaNombreController = new BehaviorSubject<String>();
  final _etapaDiasController = new BehaviorSubject<String>();
  final _stageController = new BehaviorSubject<bool>();



  Stream<List<Solar>> get solaresStream => _solaresController.stream;


  
  Stream<String> get solarNombreStream => _solarNombreController.stream.transform(validateSolarNombre);
  Stream<String> get solarLargoStream => _solarLargoController.stream.transform(validateDecimal);
  Stream<String> get solarAnchoStream => _solarAnchoController.stream.transform(validateDecimal);
  Stream<String> get solarDescripStream => _solarDescripController.stream.transform(validateSolarDescripcion);
  Stream<Solar> get solarHomeStream => _solarHomeController.stream;
  Stream<Cultivo> get cultivoHomeStream => _cultivoHomeController.stream;
  
  Stream<Solar> get solarActiveStream => _solarActiveController.stream;
  Stream<Cultivo> get cultivoActiveStream => _cultivoActiveController.stream.transform(validateCultivo);
  Stream<Etapa> get etapaActiveStream => _etapaActiveController.stream.transform(validateEtapa);



  Stream<Region> get regionActiveStream => _regionActiveController.stream;
  Stream<Distrito> get distritoActiveStream => _distritoActiveController.stream;
  Stream<String> get municipioActiveStream => _municipioActiveController.stream;
  
  Stream<Solar> get solarStream => _solarController.stream;
  Stream<String> get tipoCultivoStream =>  _cultivoTipoController.stream;

  Stream<bool> get sensoresStream => _cultivoSensoresController.stream;
  Stream<String> get tempMinStream => _tempMinController.stream.transform(validateDecimal);
  Stream<String> get tempMaxStream => _tempMaxController.stream.transform(validateDecimal);
  Stream<String> get humMinStream => _humMinController.stream.transform(validateDecimal);
  Stream<String> get humMaxStream => _humMaxController.stream.transform(validateDecimal);
  Stream<String> get humSMinStream => _humSMinController.stream.transform(validateDecimal);
  Stream<String> get humSMaxStream => _humSMaxController.stream.transform(validateDecimal);

  Stream<String> get fechaInicioStream => _fechaInicioController.stream.transform(validateSolarNombre);
  Stream<String> get fechaTerminacionStream => _fechaTerminacionController.stream.transform(validateSolarNombre);


  Stream<List<Etapa>>  get listEtapasStream =>_listEtapasController.stream;
  Stream<String> get etapaNombreStream => _etapaNombreController.stream.transform(validateSolarNombre);
  Stream<String> get etapaDiasStream => _etapaDiasController.stream.transform(validateInteger);
  Stream<bool> get stageStream => _stageController.stream;



  Function(String) get changeSolarNombre => _solarNombreController.sink.add;
  Function(Solar) get changeSolarHome => _solarHomeController.sink.add;
  Function(Cultivo) get changeCultivoHome => _cultivoHomeController.sink.add;


  Function(String) get changeSolarLargo => _solarLargoController.sink.add;
  Function(String) get changeSolarAncho => _solarAnchoController.sink.add;
  Function(String) get changeSolarDescrip => _solarDescripController.sink.add;

  Function(Solar) get changeSolarActive => _solarActiveController.sink.add;
  Function(Cultivo) get changeCultivoActive => _cultivoActiveController.sink.add;
  Function(Etapa) get changeEtapaActive => _etapaActiveController.sink.add;

  Function(Region) get changeRegionActive => _regionActiveController.sink.add;
  Function(Distrito) get changeDistritoActive => _distritoActiveController.sink.add;
  Function(String) get changeMunicipioActive => _municipioActiveController.sink.add;
  Function(Solar) get onChangeSolar => _solarController.sink.add;
  Function(String) get onChangeCultivoTipo => _cultivoTipoController.sink.add;

  Function(bool) get onChangeSensores => _cultivoSensoresController.sink.add;
  Function(String) get onChangeTempMin => _tempMinController.sink.add;
  Function(String) get onChangeTempMax => _tempMaxController.sink.add;
  Function(String) get onChangeHumMin => _humMinController.sink.add;
  Function(String) get onChangeHumMax => _humMaxController.sink.add;
  Function(String) get onChangeHumSMin => _humSMinController.sink.add;
  Function(String) get onChangeHumSMax => _humSMaxController.sink.add;

  Function(String) get onChangeFechaInicio => _fechaInicioController.sink.add;
  Function(String) get onChangeFechaTerminacion => _fechaTerminacionController.sink.add;

  Function(List<Etapa>) get onChangeEtapas => _listEtapasController.sink.add;
  Function(String) get onChangeEtapaNombre => _etapaNombreController.sink.add;
  Function(String) get onChangeEtapaDias => _etapaDiasController.sink.add;
  Function(bool) get onChangeStage => _stageController.sink.add;


  List<Solar> get solaresLi => _solaresController.value;
  
  String get solarNombre => _solarNombreController.value;
  String get solarLargo => _solarLargoController.value;
  String get solarAncho => _solarAnchoController.value;
  String get solarDescrip => _solarDescripController.value;
  

  Solar get solarActive => _solarActiveController.value;
  Cultivo get cultivoActive => _cultivoActiveController.value;
  Region get regionActive => _regionActiveController.value;
  Etapa get etapaActive => _etapaActiveController.value;

  Distrito get distritoActive => _distritoActiveController.value;
  String get municipioActive => _municipioActiveController.value;
  Solar get solar => _solarController.value;
  String get cultivoTipo => _cultivoTipoController.value;


  bool get sensores => _cultivoSensoresController.value;
  String get tempMin => _tempMinController.value;
  String get tempMax => _tempMaxController.value;
  String get humMin => _humMinController.value;
  String get humMax => _humMaxController.value;
  String get humSMin => _humSMinController.value;
  String get humSMax => _humSMaxController.value;
  
  String get fechaInicio => _fechaInicioController.value;
  String get fechaTerminacion => _fechaTerminacionController.value;

  List<Etapa> get listEtapas => _listEtapasController.value;
  String get etapaNombre => _etapaNombreController.value;
  String get etapaDias => _etapaDiasController.value;
  bool get stage => _stageController.value;
  Solar get solarHome => _solarHomeController.value;
  Cultivo get cultivoHome => _cultivoHomeController.value;

  Stream<bool> get formValidStream => 
    CombineLatestStream.combine7(solarNombreStream, solarLargoStream,
      solarAnchoStream,solarDescripStream,municipioActiveStream,
      regionActiveStream,distritoActiveStream
      , (n, l,a,d,m,r,di) => true);
  
  Stream<bool> get formAddCultivoValidStream => 
    CombineLatestStream.combine8(tipoCultivoStream,solarNombreStream, solarLargoStream,
      solarAnchoStream,solarDescripStream,sensoresStream,fechaInicioStream,fechaTerminacionStream
      , (e1, e2,e3,e4,e5,e6,e7,e8) => true);

   Stream<bool> get formSensores => 
    CombineLatestStream.combine6(tempMinStream,tempMaxStream, humMinStream,
      humMaxStream,humSMinStream,humSMaxStream,
       (e1, e2,e3,e4,e5,e6) => true);


  Stream<bool> get formAddCultivoWitSensoresValidStream => 
  CombineLatestStream.combine3( formAddCultivoValidStream,formSensores, stageStream,
       (e1, e2,e3) => true);


  Stream<bool> get formEtapaValidStream => 
  CombineLatestStream.combine2( etapaNombreStream,etapaDiasStream,
       (e1, e2) => true);
  


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
    // _solarNombreController.close();
    // _solarLargoController.close();
    // _solarAnchoController.close();
    // _solarDescripController.close(); 

    
  }
 
  
  void reset(){
    _solarNombreController.sink.addError('*');
    _solarLargoController.sink.addError('*');
    _solarAnchoController.sink.addError('*');
    _solarDescripController.sink.addError('*');
    _regionActiveController.sink.addError('*');
    _distritoActiveController.sink.addError('*');
    _municipioActiveController.sink.addError('*');
  }

  void resetEtapa(){
    _etapaNombreController.sink.addError('*');
    _etapaDiasController.sink.addError('*');
  }

  void resetCultivo(){
    _solarNombreController.sink.addError('*');
    _solarLargoController.sink.addError('*');
    _solarAnchoController.sink.addError('*');
    _solarDescripController.sink.addError('*');

    _cultivoSensoresController.sink.addError('*');
    _tempMinController.sink.addError('*');
    _tempMaxController.sink.addError('*');
    _humMinController.sink.addError('*');
    _humMaxController.sink.addError('*');
    _humSMinController.sink.addError('*');
    _humSMaxController.sink.addError('*');

    _fechaInicioController.sink.addError('*');
    _fechaTerminacionController.sink.addError('*');

    etapasList = [];
    onChangeEtapas(etapasList);
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

  void setName(String n){
    _solarNombreController.sink.add(n);
  }
  
  void addEtapa(Etapa etapa){
    if(etapasList.isEmpty)
      onChangeStage(true);
    etapasList.add(etapa);
    onChangeEtapas(etapasList);
    
  }

  void deleteEtapa(Etapa etapa){
    etapasList.removeWhere(
      (item)=> item.uniqueKey == etapa.uniqueKey);
    if(etapasList.isEmpty){
      onChangeStage(false);
    }
    onChangeEtapas(etapasList);
  }
}