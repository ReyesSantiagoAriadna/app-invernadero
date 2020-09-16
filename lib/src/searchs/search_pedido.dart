import 'package:app_invernadero_trabajador/src/models/pedidos/pedido_model.dart';
import 'package:app_invernadero_trabajador/src/providers/pedidos/pedidos_provider.dart';
import 'package:app_invernadero_trabajador/src/services/pedidos/pedidos_service.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';

import '../../app_config.dart';

class SearchPedido extends SearchDelegate{
  final pedidoProvider = new PedidosProvider();

  
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
    // return IconButton(
    //   icon: AnimatedIcon(
    //     icon: AnimatedIcons.menu_arrow,
    //     progress: transitionAnimation,
    //     ), 
    //   onPressed: (){
    //     close(context, null);
    //   });
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
      return Center(
        child: Container(   
          // child: PlaceHolder(img: 'assets/images/empty_states/empty_search.svg', title: "Buscar productos")
        ),
      );
    }

    
    return FutureBuilder(
      future: pedidoProvider.searchPedido(query),
      builder: (BuildContext context,AsyncSnapshot<List<Pedido>> snapshot){
        if(snapshot.hasData){
          final productos = snapshot.data;
            return ListView(
              children: productos.map((p){
                return ListTile(
                  leading: Icon(LineIcons.archive),
                    title: Text("${p.id}"),
                    subtitle: Text("${p.cliente.nombre}"),
                    onTap: (){
                      close(context, null);
                      // Navigator.pushNamed(context, 'product_detail',arguments: p);
                    },
                );
              }).toList(),
            );
        }else{
          return Center(
            child: Container(
              child: Text("No hay resultados...",style: TextStyle(fontFamily:AppConfig.quicksand,
                color: MyColors.GreyIcon,fontWeight: FontWeight.w700
              ),),
          ),
      ) ;
        }
      }
      );

  }

  
}