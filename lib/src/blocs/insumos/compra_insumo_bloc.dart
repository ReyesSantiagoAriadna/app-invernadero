
import 'package:app_invernadero_trabajador/src/blocs/validators.dart';
import 'package:app_invernadero_trabajador/src/models/insumos/insumo.dart';
import 'package:app_invernadero_trabajador/src/models/proveedores/proveedor.dart';
import 'package:app_invernadero_trabajador/src/providers/insumos/insumos_provider.dart';
import 'package:app_invernadero_trabajador/src/services/insumosService/insumos_service.dart';
import 'package:provider/provider.dart';
import 'package:rxdart/rxdart.dart';

class CompraInsumoBloc with Validators{
  static final CompraInsumoBloc _singleton = CompraInsumoBloc._internal();
  factory CompraInsumoBloc(){
    return _singleton;
  }

  CompraInsumoBloc._internal();

  List<Insumo> insumoList=[];

  InsumosProvider insumosProvider;
 
  
  final _proveedorActiveController = new BehaviorSubject<Proveedor>();
  final _insumoController = new BehaviorSubject<List<Insumo>>();
  final _precioController = new BehaviorSubject<String>();
  final _cantidadController = new BehaviorSubject<String>();
  final _totalController = new BehaviorSubject<String>();
  
  Stream<Proveedor> get proveedorActiveStream => _proveedorActiveController.stream;
  Stream<List<Insumo>> get insumosStream => _insumoController.stream.transform(validarInsumosCompra);
  Stream<String> get precioStream => _precioController.stream.transform(validarPrecioCompra);
  Stream<String> get cantidadStream => _cantidadController.stream.transform(validarCantidadCompra);
  Stream<String> get totalStream => _totalController.stream;
  
  Function(Proveedor) get changeProvActive => _proveedorActiveController.sink.add;
  Function(String) get changePrecio => _precioController.sink.add;
  Function(String) get changeCantidad => _cantidadController.sink.add;
  Function(String) get changeTotal => _totalController.sink.add;
  
  Proveedor get proveedorActive => _proveedorActiveController.value;
  List<Insumo> get insumos => _insumoController.value;
  String get precio => _precioController.value;
  String get cantidad => _cantidadController.value;
  String get total => _totalController.value;

  Stream<bool> get formValidStream => 
    CombineLatestStream.combine4(proveedorActiveStream, insumosStream, precioStream, 
                    cantidadStream, (a,b,c,d) => true);

  reset(){
    _precioController.addError('*');
    _cantidadController.addError('*');
    _totalController.addError('*');
    _proveedorActiveController.addError('*');
    _insumoController.addError('*');
    //insumoList = [];
  }

  resetCP(){
    _precioController.addError('*');
    _cantidadController.addError('*');
  }

  Future<List<Insumo>> insumosT()async{
    return await insumosProvider.loadInsumosSelect();
  }

  void getInsumosList(){
    _insumoController.sink.add(insumoList);
  }

  void addInsumo(Insumo insumo){
    insumoList.add(insumo);    
    getInsumosList();    
  }

  void deleteInsumo(Insumo insumo){  
    insumo.precio = 0;
    insumo.cantidadCompra =0;
    insumoList.removeWhere((i)=>i.id==insumo.id);
    totalCompra();
    getInsumosList();
  }

  void updateInsumo(Insumo insumo){
    int index = insumoList.indexWhere((i)=> i.id == insumo.id);
    insumoList[index] = insumo;
    getInsumosList();
  }

  void decCantidadInsumo(Insumo i){
    if(i.cantidad>1){
      i.amountOnTask--;
      updateInsumo(i);
    }
  }

  void incCantidadInsumo(Insumo i){ 
      i.amountOnTask++;
      updateInsumo(i); 
  }

  void addPrecio(Insumo insumo, double precio){
    int index = insumoList.indexWhere((i)=> i.id == insumo.id);
    insumoList[index] = insumo;
    insumo.precio = precio;
    getInsumosList(); 
    totalCompra();
  }

  
  void addCantidad(Insumo insumo, int cantidad){
    int index = insumoList.indexWhere((i)=> i.id == insumo.id);
    insumoList[index] = insumo;
    insumo.cantidadCompra = cantidad;
    getInsumosList();
  }

  void totalCompra(){
    print("3333333333333333");
    print(insumoList.length); 

    _insumoController.sink.add(insumoList);
    var ins = _insumoController.value;
    double total = 0;  

      for (var i = 0; i < ins.length; i++) { 
         total += ins[i].precio;
      }
      _totalController.sink.add(total.toString()); 
       print(total);
  } 

  void disSelect()async{
    final isumos =  await insumosT();
    for (var i = 0; i < isumos.length; i++) {
        if(insumos[i] == insumoList[i]){
          insumos[i].isSelect = false;
        }
    }
  }
}