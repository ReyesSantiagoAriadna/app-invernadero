import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class InputName extends StatelessWidget {
  final Function(String) onChange;
  final String initialData;
  final String error;
  const InputName({Key key, this.onChange, this.initialData, this.error}) : super(key: key);

  @override
  Widget build(BuildContext context) {

        

          return  TextFormField(
            initialValue: initialData,
            decoration: InputDecoration(
              focusedBorder:  UnderlineInputBorder(      
                        borderSide: BorderSide(color:miTema.accentColor)),
              icon: Icon(LineIcons.sun_o),
              labelText: 'Nombre', 
              errorText: error,
            ),
            onChanged: onChange,
          
      );
  }  
}