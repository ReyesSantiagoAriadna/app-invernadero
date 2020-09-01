
import 'package:app_invernadero_trabajador/src/models/productos/producto.dart';
import 'package:app_invernadero_trabajador/src/providers/productosProvider/productos_provider.dart'; 
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class ProductosService with ChangeNotifier{
  ProductosProvider productosProvider = ProductosProvider();

  List<Producto> productoList = List();

  final _productosController = new BehaviorSubject<List<Producto>>();
  final _responseController = new BehaviorSubject<String>();

  Stream<List<Producto>> get productoStream => _productosController.stream;

  Function(String) get changeResponse => _responseController.sink.add;

  String get response => _responseController.value;

  List<Producto> get productos => productoList;

  PlagaService(){
    this.getProductos();
  }

  dispose(){
    _productosController.close();
    _responseController.close();
  }

  void getProductos()async{
    final list = await productosProvider.cargarProductos();
    if(list != null && list.isNotEmpty){
      this.productoList.addAll(list);
      _productosController.sink.add(productoList);
    }
    notifyListeners();
  }

  Future<bool> fetchProductos()async{
    final list = await productosProvider.cargarProductos();
    if(list != null && list.isNotEmpty){
      this.productoList.addAll(list);
      _productosController.sink.add(productoList);    
      return true;
    }
    return false;
  }
}