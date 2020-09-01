
import 'dart:io';

import 'package:app_invernadero_trabajador/src/models/ofertas/oferta.dart';
import 'package:app_invernadero_trabajador/src/models/ofertas/ofertaTipo.dart';
import 'package:app_invernadero_trabajador/src/models/productos/producto.dart';
import 'package:app_invernadero_trabajador/src/providers/ofertasProvider/ofertas_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/productosProvider/productos_provider.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

class OfertaService with ChangeNotifier {
   OfertaProvider ofertaProvider = new OfertaProvider();
   ProductosProvider productosProvider = new ProductosProvider(); 

   List<Oferta> ofertaList = List();
   List<OfertaTipo> ofertaTipoList = List();
   List<Producto> productosList = List();

   final _ofertasController = new BehaviorSubject<List<Oferta>>();
   final _responseController = new BehaviorSubject<String>();
   final _ofertaTipoController = new BehaviorSubject<List<OfertaTipo>>();
   final _prodcutoController = new BehaviorSubject<List<Producto>>();

   Stream<List<Oferta>> get ofertaStream => _ofertasController.stream;
   Stream<List<OfertaTipo>> get ofertaTipoStream => _ofertaTipoController.stream;
   Stream<List<Producto>> get productoStream => _prodcutoController.stream;

   Function(String) get changeResponse => _responseController.sink.add;
   String get response => _responseController.value;

   List<Oferta> get oferta => ofertaList;
   List<OfertaTipo> get ofertaTipo => ofertaTipoList;
   List<Producto> get producto => productosList;

   OfertaService(){
     this.getOfertas();
     this.getOfertaTipo();
     this.getProductos();
   }

   dispose(){
     _ofertasController.close();
     _ofertaTipoController.close();
     _prodcutoController.close();
     _responseController.close();
   }

   void getOfertas() async{ 
     final list = await ofertaProvider.cargarOfertas();
     if(list != [] && list.isNotEmpty){
       this.ofertaList.addAll(list);
       _ofertasController.sink.add(ofertaList);
     }
     notifyListeners();
   }

   Future<bool> fetchOfertas()async{
     final list =  await ofertaProvider.cargarOfertas();
     if(list !=[] && list.isNotEmpty){
       this.ofertaList.addAll(list);
       _ofertasController.sink.add(ofertaList);
       return true;
     }
     return false;
   }

   void getOfertaTipo() async{
     final list = await ofertaProvider.cargarOfertasTipos();
     if(list != null && list.isNotEmpty){
       this.ofertaTipoList.addAll(list);
       _ofertaTipoController.sink.add(list);
       print("&&&&&&&&&&&&&");
       print(list.length);
     }
     notifyListeners();
   }

   void getProductos() async{
     final list =  await productosProvider.cargarProductos();
     if(list != null && list.isNotEmpty){
       this.productosList.addAll(list);
       _prodcutoController.sink.add(list);
     }
     notifyListeners();
   }

   Future<bool> terminarOferta(int idOferta)async{
     print("%%%%%%%%%%%%entro%%%%%%%%%%%%%%%%5");
     final resp = await ofertaProvider.terminarOferta(idOferta);
     if(resp != null){
       int index = this.ofertaList.indexWhere((item) => item.id==idOferta);
       this.ofertaList[index] = resp;
       _ofertasController.sink.add(ofertaList);
       changeResponse('Oferta terminada');
       return true;

     }else {
       changeResponse('Algo salio mal');
       return false;
     }
   }

   void addOferta(Oferta oferta)async{
     final resp= await ofertaProvider.addOferta(oferta);
     if(resp != null){
       this.ofertaList.add(resp);
       _ofertasController.sink.add(ofertaList);
       changeResponse('success');
     }else {
       changeResponse('Algo salio mal');
     }
   }

   Future<String> subirFoto(File foto) async{
    final fotoUrl = await ofertaProvider.subirImagenCloudinary(foto);
    changeResponse('Imagen cargada');
    return fotoUrl;
    
  }
}