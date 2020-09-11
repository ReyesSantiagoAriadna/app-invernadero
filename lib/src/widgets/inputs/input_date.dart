import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:line_icons/line_icons.dart';

class InputDate extends StatelessWidget {
  final String title;
  final Stream stream;
  final Function(String) onChange;
  final String initialDate;
  final String firstDate;

  const InputDate({Key key, this.title, this.stream, this.onChange, this.initialDate, this.firstDate}) : super(key: key);


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
          builder: (context, snapshot) {
            print("fecha en el text ${snapshot.data}");
            return GestureDetector(
              onTap: ()=>_selectDate(context,onChange,snapshot.hasData?snapshot.data: initialDate,
              firstDate,snapshot.hasData?0:1),
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
  
         

  _selectDate(BuildContext context,Function(String) onChange,String initialDate,String firstDate,int sumar) async{
    
    DateTime _firstDate,_initialDate;
    // if(firstDate!=null)
    //   _firstDate = DateTime.parse(firstDate);
    // if(initialDate!=null)
    //   _initialDate = DateTime.parse(initialDate);
      
    if(firstDate!=null){
       var d1 =  DateTime.parse(firstDate);
      _firstDate = new DateTime(d1.year, d1.month, d1.day + 1);
    }
      // _firstDate = DateTime.parse(firstDate);
    if(initialDate!=null && sumar==1){
        var d1 =  DateTime.parse(initialDate);
      _initialDate = new DateTime(d1.year, d1.month, d1.day + 1);
    }else if(initialDate!=null && sumar==0){
       _initialDate =  DateTime.parse(initialDate);
    }
      // _initialDate = DateTime.parse(initialDate);
    new DateFormat("yyyy-MM-dd");
      
      DateTime picked = await showDatePicker(
        context: context, 
        initialDate: _initialDate!=null?_initialDate: new DateTime.now(), 
        firstDate: _firstDate !=null?_firstDate: new DateTime(2020), 
        lastDate: new DateTime(2030), 
        locale: Locale('es'),
      );

      if(picked != null){
          String _fecha;
          var formatter = new DateFormat("yyyy-MM-dd");
          _fecha = formatter.format(picked);
          onChange(_fecha);

          // print("FEcha seleecionada $_fe");
      }
  }
}