
import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/tareas_model.dart';
import 'package:rxdart/rxdart.dart';
import 'package:rxdart/subjects.dart';

class GenericBloc with Validators{

  static final GenericBloc _singleton = GenericBloc._internal();
  factory GenericBloc() {
    return _singleton;
  }
  GenericBloc._internal();
  

  final _nombreController = new BehaviorSubject<String>();
  final _descripcionController = new BehaviorSubject<String>();
  final _horaIniController = new BehaviorSubject<String>();
  final _horaFinController = new BehaviorSubject<String>();
  final _fechaIniController = new BehaviorSubject<String>();
  final _fechaFinController = new BehaviorSubject<String>();

  final _decimalController = new BehaviorSubject<String>();
  final _enteroController = new BehaviorSubject<String>();
  

  Stream<String> get nombreStream => _nombreController.stream.transform(validarNombre);
  Stream<String> get descripcionStream => _descripcionController.stream.transform(validarNombre);
  Stream<String> get horaIniStream => _horaIniController.stream.transform(validarNombre);
  Stream<String> get horaFinStream => _horaFinController.stream.transform(validarNombre);
  Stream<String> get fechaIniStream => _fechaIniController.stream.transform(validarNombre);
  Stream<String> get fechaFinStream => _fechaFinController.stream.transform(validarNombre);
  Stream<String> get decimalStream => _decimalController.stream.transform(validateDecimal);
  Stream<String> get enteroStream => _enteroController.stream.transform(validateInteger);


  Function(String) get onChangeNombre => _nombreController.sink.add;
  Function(String) get onChangeDescripcion => _descripcionController.sink.add;
  Function(String) get onChangeHoraIn => _horaIniController.sink.add;
  Function(String) get onChangeHoraFin => _horaFinController.sink.add;
  Function(String) get onChangeFechaIn => _fechaIniController.sink.add;
  Function(String) get onChangeFechaFin => _fechaFinController.sink.add;
  Function(String) get onChangeDecimal => _decimalController.sink.add;
  Function(String) get onChangeEntero => _enteroController.sink.add;


  String get nombre => _nombreController.value;
  String get descripcion => _descripcionController.value;
  String get horaIni => _horaIniController.value;
  String get horaFin => _horaFinController.value;
  String get fechaIni => _fechaIniController.value;
  String get fechaFin => _fechaFinController.value;
  String get decimal => _decimalController.value;
  String get entero => _enteroController.value;


  Stream<bool> get formTarea => 
    CombineLatestStream.combine4(nombreStream,horaIniStream,horaFinStream,
      descripcionStream,
       (e1, e2,e3,e4) => true);
 
  reset(){
    _nombreController.sink.addError('*');
    _descripcionController.sink.addError('*');
    _horaIniController.sink.addError('*');
    _horaFinController.sink.addError('*');
    _fechaIniController.sink.addError('*');
    _fechaFinController.sink.addError('*');
  }
  dipose(){
    _nombreController.close();
    _descripcionController.close();
    _horaIniController.close();
    _horaFinController.close();
    _fechaIniController.close();
    _fechaFinController.close();
  }

}