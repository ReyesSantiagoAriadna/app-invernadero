

import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';

void showMyDialog(BuildContext context,String title,String content,Function function) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: new Text(title),
        content: new Text(content),
        actions: <Widget>[
          new FlatButton(
           child: new Text("Cerrar",style: TextStyle(color:miTema.accentColor),),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
          new FlatButton(
            child: new Text("Aceptar",style: TextStyle(color:miTema.accentColor),),
            onPressed: (){
              function();
              Navigator.of(context).pop();
            },
          ),
        ],
      );
    },
  );
}
