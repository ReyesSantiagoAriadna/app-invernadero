

import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:app_invernadero_trabajador/src/models/inventario_herramientas/herramienta.dart';
import 'package:rxdart/rxdart.dart';

class InventarioBloc with Validators{
  static final InventarioBloc _inventarioBloc = InventarioBloc._internal();

  factory InventarioBloc(){
    return _inventarioBloc;
  }

  InventarioBloc._internal();

  final _nombreController = BehaviorSubject<String>();
  final _descripcionController = BehaviorSubject<String>();
  final _cantidadController = BehaviorSubject<int>();
  final _urlImagenController = BehaviorSubject<String>();

  Stream<String> get nombreStream => _nombreController.stream.transform(validarNombreHerramienta);
  Stream<String> get descripcionStream => _descripcionController.stream.transform(validarDescripcionHerramienta);
  Stream<int> get cantidadStream => _cantidadController.stream;
  Stream<String> get urlImagenStream => _urlImagenController.stream;

  Function(String) get changeNombre => _nombreController.sink.add;
  Function(String) get changeDescripcion => _descripcionController.sink.add;
  Function(int) get changeCantidad => _cantidadController.sink.add;
  Function(String) get changeUrlImagen => _urlImagenController.sink.add;

  String get nombre => _nombreController.value;
  String get descripcion => _descripcionController.value;
  int get cantidad => _cantidadController.value;
  String get urlImagen => _urlImagenController.value;

  final _herramientaController = BehaviorSubject<Herramienta>();
  Stream<Herramienta> get herramientaStream => _herramientaController.stream;
  Function(Herramienta) get changeHerramienta => _herramientaController.sink.add;
  Herramienta get herramienta => _herramientaController.value;

   Stream<bool> get formValidStream => 
     CombineLatestStream.combine4(nombreStream, descripcionStream, cantidadStream, 
     urlImagenStream, (a,b,c,d) => true);

    

  void reset(){
     _nombreController.sink.addError('*');
     _descripcionController.sink.addError('*');
   }   
}