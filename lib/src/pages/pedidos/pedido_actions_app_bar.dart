

import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

List<Widget> pedidoActionsAppBar(){
  List<Widget> actions = [
    IconButton(icon: Icon(LineIcons.archive), onPressed: null),
   /// IconButton(icon: Icon(LineIcons.sun_o), onPressed: ()=>print("solaress")),
  ];

  return actions;
}