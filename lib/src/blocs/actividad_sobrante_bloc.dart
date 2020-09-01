import 'package:app_invernadero_trabajador/src/blocs/generic_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/sobrantes_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/providers/actividades/sobrantes_provider.dart';
import 'package:app_invernadero_trabajador/src/services/actividades/sobrantes_services.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';
import 'package:intl/intl.dart';


class ActividadSobranteBloc with Validators{
  static final ActividadSobranteBloc _singleton = ActividadSobranteBloc._internal();
  SobrantesProvider sobrantesProvider = SobrantesProvider();
  factory ActividadSobranteBloc() {
    return _singleton;
  }
  ActividadSobranteBloc._internal();
  GenericBloc gB = GenericBloc();
  SolarCultivoBloc solarBloc = SolarCultivoBloc();
  List<Producto> listProductos = new List();

  final _productActiveController = new BehaviorSubject<Producto>();

  Stream<Producto> get activeProductoStream => _productActiveController.stream;

  Producto get productoActive => _productActiveController.value;

  Function(Producto) get onChangeActiveProduc => _productActiveController.sink.add;

  final _productosController = new BehaviorSubject<List<Producto>>();

  Stream<List<Producto>> get productosStream => _productosController.stream;

  List<Producto> get productos => _productosController.value;

  Stream<bool> get formSobrante => 
    CombineLatestStream.combine4(activeProductoStream, gB.fechaIniStream,
      gB.enteroStream,gB.descripcionStream,
       (e1, e2,e3,e4) => true);


  void productosCultivo(String cultivo)async{
    final list = await sobrantesProvider.productosCultivo(cultivo);
    if(list.isNotEmpty){
      listProductos.addAll(list);
      _productosController.sink.add(listProductos);
    }
  }

   Future<List<Producto>> productosC(String cultivo)async{
    final list = await sobrantesProvider.productosCultivo(cultivo);
    if(list.isEmpty)
      return list;
    return [];
  }

  reset(){
    _productActiveController.sink.addError('*');
  }
  void init(BuildContext context, Sobrante p){
    Solar sun = Provider
      .of<SolarCultivoService>(context,listen: false)
      .solares.firstWhere((item)=>item.id==p.producto.solar);
      solarBloc.changeSolarActive(sun);
      Cultivo cultivo = sun.cultivos.firstWhere((item)=>item.id == p.producto.idCultivo);
      solarBloc.changeCultivoActive(cultivo);

      // Producto producto = Provider
      // .of<SobrantesService>(context,listen: false)
      // .productos.firstWhere((item)=>item.id==p.producto.id);
      onChangeActiveProduc(p.producto);
  }
  Sobrante prepareParameters(){
    Sobrante object = Sobrante(
      idProducto: productoActive.id,
      fecha:  DateFormat("yyyy-MM-dd").parse(gB.fechaIni),//Date
      cantidad: int.parse(gB.entero),
      observacion: gB.descripcion
    );
    return object;
  }

  Future<bool> addSobrante(BuildContext context)async{
    Sobrante object = prepareParameters();

     final resp = await Provider
      .of<SobrantesService>(context,listen: false).addSobrante(object);
    if(resp)
      return true;
    return false;
  }

  Future<bool> updateSobrante(BuildContext context,int sobrante)async{
    Sobrante object = prepareParameters();
    object.id = sobrante;
     final resp = await Provider
      .of<SobrantesService>(context,listen: false).updateSobrante(object);
    if(resp)
      return true;
    return false;
  }
}