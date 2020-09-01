import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';

class InputBloc extends StatelessWidget {
  final TextInputType textInputType;
  final String labelText;
  final Widget icon;
  final Stream stream;
  final Function(String) onChange;
  final dynamic initialData;
  final int maxlines;
  const InputBloc({Key key, this.textInputType, this.labelText, this.icon, this.stream, this.onChange, this.initialData, this.maxlines=1}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    

    return Container(
      child:StreamBuilder (
              stream: stream,
              initialData: initialData!=null?initialData:null,
              builder: (BuildContext context,snapshot){
                return TextFormField(
                  maxLines: maxlines,
                  initialValue: snapshot.hasData?snapshot.data:'',
                  keyboardType: textInputType,
                  decoration: 
                  maxlines!=1?
                  InputDecoration(
                    hintText: labelText,
                    icon: icon,
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:MyColors.GreyIcon),
                    ),
                    focusedBorder:  OutlineInputBorder(      
                    borderSide: BorderSide(color:miTema.accentColor)),
                    errorText: snapshot.error =='*' ? null:snapshot.error,
                  )
                  :
                  InputDecoration(
                    icon:  icon,
                    focusedBorder:  UnderlineInputBorder(      
                        borderSide: BorderSide(color:miTema.accentColor)),
                    labelText: labelText,
                    errorText: snapshot.error =='*' ? null:snapshot.error,
                  ),

                  
                  onChanged: onChange,
                  );
              },
            ),
    );
  }
}