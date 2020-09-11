

import 'dart:async';

import 'package:app_invernadero_trabajador/src/pages/actividades/actividades_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/herramientas/herramientas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/home/home_app_bar.dart';
import 'package:app_invernadero_trabajador/src/pages/home/home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/home/list_actions_app_bar.dart';
import 'package:app_invernadero_trabajador/src/pages/home/main_page.dart';
import 'package:app_invernadero_trabajador/src/pages/insumos/insumos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/ofertas/ofertas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/pedidos/pedido_actions_app_bar.dart';
import 'package:app_invernadero_trabajador/src/pages/pedidos/pedidos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/plagas/plagas_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/solar_cultivos_home_page.dart';
import 'package:app_invernadero_trabajador/src/pages/ventas/ventas_home_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:rxdart/rxdart.dart';

// enum Widget{MyHomePage,SolarCultivosHomePage,ActividadesHomePage,HerramientasHomePage,
//   InsumosHomePage,OfertasHomePage,PedidosHomePage,PlagasHomePage,VentasHomePage
// }


class PageBloc{

  static final PageBloc _singleton = PageBloc._internal();

  factory PageBloc() {
    return _singleton;
  }
  
  PageBloc._internal();
  
  List<Widget> arrayWid=List();
  
  
  final StreamController<Widget> _pageController =
      StreamController<Widget>.broadcast();
  
  final  _pageTitleController = 
      BehaviorSubject<String>();
  

  final _scrollController = BehaviorSubject<ScrollController>();
  final _showAppBarController = BehaviorSubject<bool>();
  final _appBarController = BehaviorSubject<Widget>();

  final _listActionAppBar = BehaviorSubject<List<Widget>>();

  
  Widget defaultPage=MyHomePage();

  Stream<Widget> get pageStream => _pageController.stream;
  Stream<List<Widget>> get actionsAppBarStream => _listActionAppBar.stream;

  Stream<Widget> get appBarStream => _appBarController.stream;

  Stream<String> get pageTitleStream => _pageTitleController.stream;
  
  Stream<ScrollController> get scrollControllerStream => _scrollController.stream;
  Stream<bool> get showAppBarStream => _showAppBarController.stream;

  Function(ScrollController) get changeScrollController => _scrollController.sink.add;
  Function(bool) get changeShowAppBar => _showAppBarController.sink.add;
  
  Function(String) get onChangePageTitle => _pageTitleController.sink.add;
  Function(Widget) get onChangePage => _pageController.sink.add;
  Function(Widget) get onChangeAppBar => _appBarController.sink.add;
  Function(List<Widget>) get onChangeListActionsAppBar => _listActionAppBar.sink.add;

  ScrollController get scrollCont => _scrollController.value;
  Widget get appBar => _appBarController.value;



  bool get showAppBar => _showAppBarController.value;
  
  String get pageTitle => _pageTitleController.value;
  
  void pickPage(String route,String pageTitle) {
    // indice = i;
    // _pageTitleController.sink.add(pageTitle);
    onChangePageTitle(pageTitle);
    switch (route) {
      case 'main':
        _pageController.sink.add(MainPage());
      break;
      case 'home':
        // _pageController.sink.add(Widget.MyHomePage);
        _pageController.sink.add(MyHomePage());
        onChangeListActionsAppBar(homeActionsAppBar());
        break;
      case 'solar_cultivos':
      //  _pageController.sink.add(Widget.SolarCultivosHomePage);
       _pageController.sink.add(SolarCultivosHomePage());
        break;
      case 'plagas':
        // _pageController.sink.add(Widget.PlagasHomePage);
        _pageController.sink.add(PlagasHomePage());
        break;
      case 'insumos':
      //  _pageController.sink.add(Widget.InsumosHomePage);
        _pageController.sink.add(InsumosHomePage());
        break;
      case 'herramientas':
      //  _pageController.sink.add(Widget.HerramientasHomePage);
         _pageController.sink.add(HerramientasHomePage());
        break;
      case 'actividades':
        // _pageController.sink.add(Widget.ActividadesHomePage);
         _pageController.sink.add(ActividadesHomePage());
      break;
      case 'pedidos':
        // _pageController.sink.add(Widget.PedidosHomePage);
        _pageController.sink.add(PedidosHomePage());
         onChangeListActionsAppBar(pedidoActionsAppBar());
      break;
      case 'ofertas':
        // _pageController.sink.add(Widget.OfertasHomePage);
        _pageController.sink.add(OfertasHomePage());
      break;
      case 'ventas':
        // _pageController.sink.add(Widget.VentasHomePage);
        _pageController.sink.add(VentasHomePage());
      break;
    }
  }
  
  dispose() {
    //_navBarController?.close();
  }
}