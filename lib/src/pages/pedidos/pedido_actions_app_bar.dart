

import 'package:app_invernadero_trabajador/src/services/notifications/notifications_service.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/widgets/badge_bottom_icon.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

List<Widget> pedidoActionsAppBar(){
  List<Widget> actions = [
    IconButton(icon: Icon(LineIcons.archive), onPressed: null),
    StreamBuilder<Object>(
      // stream:  Provider.of<NotificationsService>(context,listen: false).notifIndicatorStream,
      stream: NotificationsService.instance.notifIndicatorStream,
      builder: (context, snapshot) {
        return GestureDetector(
          onTap: ()=>Navigator.pushNamed(context, 'notifications'),
            child: Container(
            margin: EdgeInsets.only(top:15),
            child:BadgeBottomIcon(icon:Icon(LineIcons.bell,color:MyColors.GreyIcon),
            number: snapshot.hasData?snapshot.data:0,)
          ),
        );
      }
    )
  ];

  return actions;
}