import 'package:app_invernadero_trabajador/src/blocs/map_box_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/feature/feature_model.dart';
import 'package:app_invernadero_trabajador/src/providers/mapbox_provider.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:line_icons/line_icons.dart';

class PlacesSearch extends SearchDelegate{
  final mapboxProvider = MapBoxProvider();
  final mapBoxBloc = MapBoxBloc();

  @override
  List<Widget> buildActions(BuildContext context) {
    // acciones del appbar(icon para limpiar o cancelar bussqueda)
    return [
      IconButton(
        icon:Icon(LineIcons.times_circle),
        onPressed: (){
          query='';
        },)
    ];
  }

  @override
  Widget buildLeading(BuildContext context) {
    // icono a la izquierda
    return Row(
      children: <Widget>[
        IconButton(
          icon:Icon(LineIcons.angle_left),
          onPressed:()=>close(context,null)
        ),
      ],
    );
  }

  @override
  Widget buildResults(BuildContext context) {
    // crea los resultados a mostrar
    return Container();
  }

  @override
  String get searchFieldLabel => 'Buscar';

  @override
  Widget buildSuggestions(BuildContext context) {
    // sugerencias que aparecen al escribir
    if(query.isEmpty){
      return Container(child: Text("data"),);
    }
    
    return FutureBuilder(
      future: mapboxProvider.searchPlace(query),
      builder: (BuildContext context,AsyncSnapshot<List<Feature>> snapshot){
        if(snapshot.hasData){
          final places = snapshot.data;
            return ListView(
              children: places.map((p){
                //Placemark place = p.toJson();
                Feature feature = p;
                return ListTile(
                  title: Text(p.placeName),
                    subtitle: Text("${p.placeName}"),
                    onTap: (){
                      Position position = Position(
                          latitude: p.geometry.coordinates[1],
                          longitude: p.geometry.coordinates[0],
                      );
                      // //_featureBloc.addCoordinate(p.geometry.coordinates);
                      // _featureBloc.addPosition(position);
                      
                      // _featureBloc.insertFeature(feature);
                      // _featureBloc.features();

                      mapBoxBloc.changeFeature(feature);
                      mapBoxBloc.changePosition(position);
                      print("To json ${p.toJson()}");
                      
                      print("FEATURE");
                      print(feature.toJson());
                      // AddressModel _address = AddressModel.fromJson(p.toJson());
                      // _clientBloc.insertAddress(_address);

                      close(context, null);
                      //Navigator.pushNamed(context, 'product_detail',arguments: p);
                    },
                );
              }).toList(),
            );
        }else{
          return Center(
            child: CircularProgressIndicator(),
          );
        }
      }
      );

  }

}