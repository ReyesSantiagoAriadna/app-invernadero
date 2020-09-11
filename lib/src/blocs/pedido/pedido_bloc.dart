import 'package:app_invernadero_trabajador/src/blocs/generic_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/models/pedidos/fecha_pedido_model.dart';
import 'package:app_invernadero_trabajador/src/models/pedidos/pedido_model.dart';
import 'package:app_invernadero_trabajador/src/services/pedidos/pedidos_service.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';


class PedidoBloc with Validators{

  static final PedidoBloc _PedidoBloc = PedidoBloc._internal();

  factory PedidoBloc(){
    return _PedidoBloc;
  }

  PedidoBloc._internal();

  GenericBloc gB = GenericBloc();
  List<Producto> productsList=new List();

  final _fechaEntregaController = BehaviorSubject<String>();
  final _productosAgregadosController = BehaviorSubject<List<Producto>>();
  final _responseController = BehaviorSubject<String>();

  Stream<String> get fechaEntregaStream => _fechaEntregaController.stream.transform(validarNombre);
  Stream<List<Producto>> get productosAddStream => _productosAgregadosController.stream.transform(validateProductsList);

  Stream<String> get responseStream => _responseController.stream;

  Function(String) get onChangeFechaEntrega => _fechaEntregaController.sink.add;
  Function(String) get onChangeResponse => _responseController.sink.add;

  String get fechaEntrega => _fechaEntregaController.value;
  String get response => _responseController.value;

  Stream<bool> get formFechaPedido => 
    CombineLatestStream.combine4(gB.fechaIniStream,
      gB.fechaFinStream,fechaEntregaStream,productosAddStream,
       (e1, e2,e3,e4) => true);


  FechaPedidoModel prepareParameters(){
    List<ProductoPedido> list= new List();
    productsList.forEach((i){
      ProductoPedido p = ProductoPedido(
        idProducto: i.id
      );
      list.add(p);
    });

    FechaPedidoModel object = FechaPedidoModel(
      fechaInicio:  DateFormat("yyyy-MM-dd").parse(gB.fechaIni),
      fechaFinal:  DateFormat("yyyy-MM-dd").parse(gB.fechaFin),
      fechaEntrega:  DateFormat("yyyy-MM-dd").parse(fechaEntrega),
      productoPedido: list

    );

    return object;
  } 
  
  Future<bool> addFechaPedido(BuildContext context)async{
     FechaPedidoModel object = prepareParameters();

    final resp = await Provider
      .of<PedidosService>(context,listen: false).fechaPedido(object);
    if(resp)
      return true;
    return false;
  }

  void addProducto(Producto p){
    productsList.add(p);
    _productosAgregadosController.sink.add(productsList);
  } 

  void deleteProducto(Producto p){
    productsList.removeWhere((i)=> i.id == p.id);
    _productosAgregadosController.sink.add(productsList);
  }

 
}