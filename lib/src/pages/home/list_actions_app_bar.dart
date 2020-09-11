

import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

List<Widget> homeActionsAppBar(){
  List<Widget> actions = [
    IconButton(icon: Icon(LineIcons.search), onPressed: null),
    IconButton(icon: Icon(LineIcons.sun_o,color: MyColors.GreyIcon,), onPressed: ()=>print("solaress")),

  ];

  return actions;
}