import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';
class InputSelect extends StatelessWidget {
  final String text;
  final Responsive responsive;
  const InputSelect({Key key,@required this.text,@required this.responsive}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      margin: EdgeInsets.only(left:40,right:10),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        width: 1,
        color: MyColors.GreyIcon)  
      ),
      child: Row(
        children:<Widget>[
         Text(text,style: TextStyle(color:MyColors.GreyIcon,fontFamily: AppConfig.quicksand,
          fontSize: responsive.ip(1.5),fontWeight: FontWeight.w700
        ),),
        Expanded(child:Container()),
        Icon(Icons.expand_more,color: MyColors.GreyIcon,)
        ]
      )
    );
  }
}