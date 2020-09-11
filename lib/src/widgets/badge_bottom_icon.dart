import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';


class BadgeBottomIcon extends StatelessWidget {
  final Icon icon;
  final int number;

  const BadgeBottomIcon({Key key, this.icon, this.number}) : super(key: key);


  @override
  Widget build(BuildContext context) {
    Responsive _responsive = Responsive.of(context);

    return  new Container( 
      width: _responsive.ip(3),
      // color: Colors.green,
      child: new Stack(
        children: <Widget>[
          icon,
          (number>0)?
          new Positioned(
          right: _responsive.ip(0.3),
          top: _responsive.ip(-0.1),
            child: new Stack(
            alignment: Alignment.center,
            children: <Widget>[
              new Icon(
                  Icons.brightness_1,
                  size: _responsive.ip(1.8), color:Colors.redAccent),
              new Text(
              number.toString(),
                style: new TextStyle(
                    color: Colors.white,
                    fontSize: _responsive.ip(1),
                    fontWeight: FontWeight.w500
                ),
              ),
            ],
          ))
          :
          Container()
        ],
      )
    );
  }
}