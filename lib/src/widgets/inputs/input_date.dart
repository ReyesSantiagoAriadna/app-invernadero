import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

class InputDate extends StatelessWidget {
  final String title;
  final Stream stream;
  final Function(String) onChange;
  final dynamic initialData;
  final String firstDate;

  const InputDate({Key key, this.title, this.stream, this.onChange, this.initialData, this.firstDate}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
    child: Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: <Widget>[
        Row(
          children: <Widget>[
            Icon(LineIcons.calendar,color:MyColors.GreyIcon,),
            SizedBox(width:12),
            Text(title,style: TextStyle(color:Colors.grey,fontFamily:AppConfig.quicksand,fontWeight:FontWeight.w700,fontSize: 16),),
          ],
        ),
        SizedBox(height:10),
        StreamBuilder<Object>(
          stream: stream,
           initialData: initialData!=null?initialData:null,
          builder: (context, snapshot) {
            return GestureDetector(
              onTap: ()=>_selectDate(context,onChange,initialData),
              child: Container(
                padding: const EdgeInsets.all(5.0),
                decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(
                  width: 1,
                  color: MyColors.GreyIcon)  
                ),
                margin: EdgeInsets.only(left:40),
                child: Text(
                  snapshot.hasData?snapshot.data:'00/00/00'
                  ,style: TextStyle(fontFamily:AppConfig.quicksand,fontWeight:FontWeight.w700,fontSize: 15)),
              ),
            );
          }
        ),
      ],
    ),
      );
  }
  
         

  _selectDate(BuildContext context,Function(String) onChange,String firstDate) async{
    print("initial date :  $firstDate");
    DateTime parsedDate;
    if(firstDate!=null)
      parsedDate = DateTime.parse(firstDate);

      new DateFormat("yyyy-MM-dd");
       DateTime picked = await showDatePicker(
        context: context, 
        initialDate: new DateTime.now(), 
        firstDate:  firstDate !=null?parsedDate: new DateTime(2020), 
        lastDate: new DateTime(2021), 
        locale: Locale('es'),
      );

      if(picked != null){
          String _fecha;
          var formatter = new DateFormat("yyyy-MM-dd");
          _fecha = formatter.format(picked);
          onChange(_fecha);
      }
  }
}