
import 'package:app_invernadero_trabajador/src/blocs/validators.dart'; 
import 'package:app_invernadero_trabajador/src/models/insumos/insumo.dart';
import 'package:rxdart/rxdart.dart';

class InsumosBloc with Validators{
  static final InsumosBloc _insumosBloc = InsumosBloc._internal();

  factory InsumosBloc(){
    return _insumosBloc;
  }

  InsumosBloc._internal();

  final _nombreController = BehaviorSubject<String>();
  final _tipoActiveController = BehaviorSubject<String>(); 
  final _cantidadMinController = BehaviorSubject<String>();
  final _composicionController = BehaviorSubject<String>();
  final _observacionController = BehaviorSubject<String>();
  final _urlImagenController = BehaviorSubject<String>();
  final _unidadActiveController = BehaviorSubject<String>();
   
  Stream<String> get nombreStream => _nombreController.stream.transform(validarNombreInsumo);
  Stream<String> get tipoActiveStream =>  _tipoActiveController.stream;
  Stream<String> get cantidadMinStream => _cantidadMinController.stream.transform(validarCantidadInsumo);
  Stream<String> get composicionStream => _composicionController.stream.transform(validarComposicionInsumo);
  Stream<String> get observacionStream => _observacionController.stream.transform(validarObservacionInsumo);
  Stream<String> get urlImagenStream => _urlImagenController.stream.transform(validarImagenInsumo);
  Stream<String> get unidadActiveStream => _unidadActiveController.stream;
   

  Function(String) get changeNombre => _nombreController.sink.add;
  Function(String) get changeTipoActive => _tipoActiveController.sink.add; 
  Function(String) get changeCantidadMin => _cantidadMinController.sink.add;
  Function(String) get changeComposicion => _composicionController.sink.add;
  Function(String) get changeObservacion => _observacionController.sink.add;
  Function(String) get changeUrlImagen => _urlImagenController.sink.add;
  Function(String) get changeUnidadActive => _unidadActiveController.sink.add;
   
  String get nombre => _nombreController.value;
  String get tipoActive => _tipoActiveController.value; 
  String get cantidadMin => _cantidadMinController.value;
  String get composicion => _composicionController.value;
  String get observacion => _observacionController.value;
  String get urlImagen => _urlImagenController.value;
  String get unidadActive => _unidadActiveController.value;
   
  final _insumoController = BehaviorSubject<Insumo>();
  Stream<Insumo> get insumoStream => _insumoController.stream;
  Function(Insumo) get changeInsumo => _insumoController.sink.add;
  Insumo get insumo => _insumoController.value;

  

  Stream<bool> get formValidStream => 
    CombineLatestStream.combine7(urlImagenStream,nombreStream, tipoActiveStream, unidadActiveStream, cantidadMinStream, composicionStream, observacionStream, (a,b,c,d,e,f,g) => true);

  void reset(){
    _nombreController.sink.addError('*');
    _tipoActiveController.sink.addError('*'); 
    _cantidadMinController.sink.addError('*');
    _composicionController.sink.addError('*');
    _observacionController.sink.addError('*'); 
    _urlImagenController.sink.addError('*');
    _unidadActiveController.sink.addError('*');
  }
}