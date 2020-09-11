import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

import '../../../app_config.dart';


class MyTimePicker extends StatelessWidget {
  final Stream stream;
  final Function(String) onChange;
  final String initialTime;
  final Responsive responsive;
  final String title;
  const MyTimePicker({Key key, this.stream, this.onChange, this.initialTime, this.responsive, this.title}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    MaterialLocalizations localizations = MaterialLocalizations.of(context);
    TextStyle _style = TextStyle(fontFamily:AppConfig.quicksand,fontWeight: FontWeight.w700,color: MyColors.GreyIcon);
     return GestureDetector(
      onTap: (){
       _selectTime(context, localizations, onChange,initialTime);
      },
      child: Container(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children:<Widget>[
           Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(LineIcons.clock_o,color: MyColors.GreyIcon,),
                Container(
                  margin: EdgeInsets.only(left:20),
                  child: Text(title,style: _style,)),
              ],
              ),
            SizedBox(height:10),
            Container(
              //color: Colors.yellow,
              margin: EdgeInsets.only(left:40),
              padding: EdgeInsets.all(5),
              child: StreamBuilder<Object>(
                stream: stream,
                initialData: initialTime!=null?initialTime:"",
                builder: (context, snapshot) {
                  return Text(snapshot.hasData?snapshot.data:"00:00",
                  style: TextStyle(
                    color: Colors.black87,
                    fontFamily:AppConfig.quicksand,fontWeight:FontWeight.w700,
                    fontSize: responsive.ip(1.8)
                    ),);
                }
              ),
              decoration: BoxDecoration(
                // color: Colors.red,
              borderRadius: BorderRadius.circular(5),
              border: Border.all(
                width: 1,
                color: MyColors.GreyIcon)  
              ),
                
                )
          ]
        ),
      ),
    );
  }

  

  _selectTime(BuildContext context,MaterialLocalizations localizations,Function(String) onChange,String initialTime) async{
      TimeOfDay _startTime ;
      if(initialTime!=null)
        _startTime  = TimeOfDay(hour:int.parse(initialTime.split(":")[0]),minute: int.parse(initialTime.split(":")[1]));
      
      TimeOfDay  picked = await showTimePicker(
        
        context: context, 
        initialTime:_startTime !=null?_startTime: new TimeOfDay.now(),
        
      );

      

      if(picked != null){
        String formattedTime = localizations.formatTimeOfDay(picked,
        
          alwaysUse24HourFormat: true);
        if (formattedTime != null) {
          formattedTime = formattedTime+":00";
          print(formattedTime);
          onChange(formattedTime);
        }
      }
  }
}