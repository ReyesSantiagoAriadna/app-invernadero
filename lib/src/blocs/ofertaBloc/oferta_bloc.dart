
import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:app_invernadero_trabajador/src/models/ofertas/ofertaTipo.dart';
import 'package:rxdart/rxdart.dart';

class OfertaBloc with Validators {
  static final OfertaBloc _singleton = OfertaBloc._internal();

  factory OfertaBloc(){
    return _singleton;
  }

  OfertaBloc._internal();
  
  final _descripcionController = BehaviorSubject<String>();
  final _urlImagenController = BehaviorSubject<String>();
  final _inicioDateController = BehaviorSubject<String>();
  final _finDateController = BehaviorSubject<String>();

  final _tipoActiveController = new BehaviorSubject<OfertaTipo>(); 
 
  Stream<String> get descripcionStream => _descripcionController.stream.transform(validarDescripcionOferta);
  Stream<String> get urlImagenStream => _urlImagenController.stream.transform(validarImagenOferta);
  Stream<String> get inicioDateStream => _inicioDateController.stream.transform(validarFechaIniOferta);
  Stream<String> get finDateStream => _finDateController.stream.transform(validarFechaFinOferta);

  Stream<OfertaTipo> get tipoActivoStream => _tipoActiveController.stream; 

  Function(String) get changeDescripcion => _descripcionController.sink.add;
  Function(String) get changeUrlImagen => _urlImagenController.sink.add;
  Function(String) get changeInicioDate => _inicioDateController.sink.add;
  Function(String) get changeFinDate => _finDateController.sink.add;

  Function(OfertaTipo) get changeTipoActive => _tipoActiveController.sink.add; 
 
  String get descripcion => _descripcionController.value;
  String get urlImagen => _urlImagenController.value;
  String get inicioDate => _inicioDateController.value;
  String get finDate => _finDateController.value;

  OfertaTipo get tipoActive => _tipoActiveController.value;

  Stream<bool> get formValidStream => 
    CombineLatestStream.combine4(descripcionStream, urlImagenStream, inicioDateStream, finDateStream, (a,b,c,d) => true);

  void reset(){
    _tipoActiveController.sink.addError('*');
    _descripcionController.sink.addError('*');
    _urlImagenController.sink.addError('*');
    _inicioDateController.sink.addError('*');
    _finDateController.sink.addError('*');
  }
}