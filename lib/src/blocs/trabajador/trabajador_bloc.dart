

import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:rxdart/rxdart.dart';

class TrabajadorBloc with Validators{
  static final TrabajadorBloc _singleton = TrabajadorBloc._internal();

  factory TrabajadorBloc(){
    return _singleton;
  }

  TrabajadorBloc._internal();

  final _nombreController = BehaviorSubject<String>();
  final _apController = BehaviorSubject<String>();
  final _amController = BehaviorSubject<String>();
  final _rfcController = BehaviorSubject<String>();
  final _urlImagenController = BehaviorSubject<String>();

  Stream<String> get nombreStream => _nombreController.stream.transform(validarNombreTrabajador);
  Stream<String> get apStream => _apController.stream.transform(validarApTrabajador);
  Stream<String> get amStream => _amController.stream.transform(validarAmTrabajador);
  Stream<String> get rfcStream => _rfcController.stream.transform(validarRFCTrabajador);
  Stream<String> get urlImagenStream => _urlImagenController.stream.transform(validarImagenTrabajador);

  Function(String) get changeNombre => _nombreController.sink.add;
  Function(String) get changeAp => _apController.sink.add;
  Function(String) get changeAm => _amController.sink.add;
  Function(String) get changeRfc => _rfcController.sink.add;
  Function(String) get changeUrlImagen => _urlImagenController.sink.add;

  String get nombre => _nombreController.value;
  String get ap => _apController.value;
  String get am => _amController.value;
  String get rfc => _rfcController.value;
  String get urlImagen => _urlImagenController.value;

  reset(){
    _nombreController.sink.addError('*');
    _apController.sink.addError('*');
    _amController.sink.addError('*');
    _rfcController.sink.addError('*');
    _urlImagenController.sink.addError('*');
  }

}