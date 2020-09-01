 
import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:app_invernadero_trabajador/src/models/productos/producto.dart';
import 'package:rxdart/rxdart.dart';

class ProductoBloc with Validators{
  static final ProductoBloc _singleton = ProductoBloc._internal();

  factory ProductoBloc(){
    return _singleton;
  }

  ProductoBloc._internal();

  final _productoActiveController = new BehaviorSubject<Producto>();
  Stream<Producto> get productoActiveStream => _productoActiveController.stream;
  Function(Producto) get changeProductoActive => _productoActiveController.sink.add;
  Producto get productoActive => _productoActiveController.value;

  void reset(){
    _productoActiveController.sink.addError('*');
  }
}