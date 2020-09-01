import 'dart:io';
  
import 'package:app_invernadero_trabajador/src/models/plagasEnfermedades/plaga.dart';
import 'package:app_invernadero_trabajador/src/providers/plagaProvider/plaga_provider.dart';
import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class PlagaBloc with Validators{
  static final PlagaBloc _singleton = PlagaBloc._internal();
  
  factory PlagaBloc(){
    return _singleton;
  }

  PlagaBloc._internal();
  
  PlagaProvider _plagaProvider = PlagaProvider(); 
 
  final _idCultivoController = BehaviorSubject<int>();
  final _nombreController = BehaviorSubject<String>();
  final _fechaController = BehaviorSubject<String>();
  final _observacionController = BehaviorSubject<String>();
  final _tratamientoController = BehaviorSubject<String>();
  final _urlImagenController = BehaviorSubject<String>(); 


  Stream<int> get idCultivoStream=> _idCultivoController.stream;
  Stream<String> get nombreStream=> _nombreController.stream.transform(validarNombrePlaga);
  Stream<String> get fechaStream=> _fechaController.stream.transform(validarFechaPlaga);
  Stream<String> get observacionStream=> _observacionController.stream.transform(validarTratamientoPlaga);
  Stream<String> get tratamientoStream=> _tratamientoController.stream.transform(validarObservacionPlaga);
  Stream<String> get urlImagenStream=> _urlImagenController.stream; 


  Function(int) get changeIdCultivo => _idCultivoController.sink.add;
  Function(String) get changeNombre => _nombreController.sink.add;
  Function(String) get changeFecha => _fechaController.sink.add;
  Function(String) get changeObservacion => _observacionController.sink.add;
  Function(String) get changeTratamiento => _tratamientoController.sink.add;
  Function(String) get changeUrlImagen => _urlImagenController.sink.add;


  int get idCultivo => _idCultivoController.value;
  String get nombre => _nombreController.value;
  String get fecha => _fechaController.value;
  String get observacion => _observacionController.value;
  String get tratamiento => _tratamientoController.value;
  String get urlImagen => _urlImagenController.value;

  
  final _plagaController = BehaviorSubject<Plagas>();
  Stream<Plagas> get plagaStream => _plagaController.stream;
  Function(Plagas) get changePlaga => _plagaController.sink.add;
  Plagas get plaga => _plagaController.value; 

  Stream<bool> get formValidStream => 
    //CombineLatestStream.combine3(nombreStream,observacionStream,tratamientoStream,(a,b,c) => true);
    CombineLatestStream.combine5(nombreStream, observacionStream, tratamientoStream, 
    fechaStream, urlImagenStream, (a,b,c,d,e) => true);
 
   
  dispose(){ 
        
    /*_idCultivoController.close();
    _nombreController.close();
    _fechaController.close();
    _observacionController.close();
    _tratamientoController.close();*/
  }

  void reset(){
    _nombreController.sink.addError('*');
    _observacionController.sink.addError('*');
    _tratamientoController.sink.addError('*');
    _urlImagenController.sink.addError('*');
    _fechaController.sink.addError('*');

  }

  
}