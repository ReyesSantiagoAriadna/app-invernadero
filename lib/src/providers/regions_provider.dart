

import 'dart:convert';

import 'package:flutter/services.dart' show rootBundle;

class _RegionsProvider{
  List<dynamic> opciones = [];

  _RegionsProvider(){
    loadData();
  }

  Future<List<dynamic>>  loadData() async{
    final resp = await rootBundle.loadString('data/regionalizacion.json');

    Map dataMap = json.decode(resp);
    opciones = dataMap['regiones'];
    return opciones;
  }
}

final regionsProvider = _RegionsProvider();