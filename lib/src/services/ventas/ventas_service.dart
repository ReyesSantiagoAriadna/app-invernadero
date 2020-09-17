
import 'package:app_invernadero_trabajador/src/models/ventas/ventas_model.dart';
import 'package:app_invernadero_trabajador/src/providers/ventas/ventas_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:rxdart/rxdart.dart';

class VentaService with ChangeNotifier{
    static VentaService instance = new VentaService();

    VentasProvider ventasProvider = VentasProvider();

    List<Venta> ventasList = List();
    Cliente cliente = Cliente();
    Personal personal = Personal();
    
    final _ventasController = new BehaviorSubject<List<Venta>>(); 
    final _responseController = new BehaviorSubject<String>();

    Stream<List<Venta>> get ventaStream => _ventasController.stream;
    
    Function(String) get changeResponse => _responseController.sink.add;
    String get response => _responseController.value;

    List<Venta> get ventas => ventasList;

    VentaService(){
      this.getVentas();
    }
    
    dispose(){
      _ventasController.close();
      _responseController.close();
    }


    void getVentas()async{
      print(">>>>>>>>>>>>>cargando ventas>>>>>>>>>>>>>");
      final list= await ventasProvider.cargarVentas();
      if(list!=[] && list.isNotEmpty){
        this.ventasList.addAll(list);
        _ventasController.sink.add(ventasList);
      }
      notifyListeners();
    }

    void addVenta(Venta v){   
    // p.isNew=true;
    ventasList.insert(0,v);
    _ventasController.sink.add(ventasList);  
  }
}