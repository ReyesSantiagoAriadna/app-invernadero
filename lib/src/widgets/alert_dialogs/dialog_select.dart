import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/input_select.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class DialogSelectGeneric extends StatelessWidget {
  final Stream stream;
  final dynamic initialData;
  final Function(dynamic) onchange;
  final Responsive responsive;
  final String title;
  final String content;
  final List<dynamic> list;
  final Widget icon;
  final bool isClickable;
  const DialogSelectGeneric({Key key, this.stream, this.initialData, this.onchange, this.responsive, this.title, this.content, this.list, this.icon, this.isClickable=true}) : super(key: key);  
  @override
  Widget build(BuildContext context) {
    TextStyle _style = TextStyle(
      color: MyColors.GreyIcon,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: responsive.ip(1.8)
    );
     return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
              icon!=null?icon:Container(),
              SizedBox(width:18),
              Text(title,style: _style,),
              ],
            ),
          SizedBox(height:10),
          StreamBuilder(
              stream:stream ,
              initialData: initialData!=null?initialData:null,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                // if(!snapshot.hasData)
                //   return InputSelect(text: "Elije el solar",responsive:responsive,);
                dynamic obj;
                if(snapshot.hasData)
                  obj = snapshot.data;
              
                return GestureDetector(
                  onTap:isClickable? (){
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogListGeneric(
                        list:list,
                        initialData: initialData,
                        onChange: onchange,
                        title: title,
                        radioValue: radioValue(snapshot.data),
                        );
                    });
                  }:null,
                  child:InputSelect(
                    text:snapshot.hasData?obj.nombre:content, 
                    responsive: responsive),
                );
              },
            ),
        ]
      ),
    );
  }

  int radioValue(dynamic initial){
    int _radioValue =-1;
    if(initial!=null){
      dynamic obj = initial;
      if(list.isNotEmpty && list!=null)
      _radioValue = list.indexWhere((i)=>i.id==obj.id);
    }
    return _radioValue;
  }
}



class DialogListGeneric extends StatefulWidget {
  final List<dynamic> list;
  final dynamic initialData;
  final Function(dynamic) onChange;
  final String title;
  final int radioValue;
  const DialogListGeneric({Key key, this.list, this.initialData, this.onChange, this.title, this.radioValue}) : super(key: key);
  
  @override
  _DialogListGenericState createState() => _DialogListGenericState();
}

class _DialogListGenericState extends State<DialogListGeneric> {
  int _radioValue=-1;
  
  
  @override
  void initState() {
    _radioValue = widget.radioValue;
    super.initState();
  }

  @override
  void didChangeDependencies() {
  
    super.didChangeDependencies();
  }

  void _handleRadioValueChange(int value) {
    setState(() {
      _radioValue = value;
    });
  }

  @override
  Widget build(BuildContext context) {
    return _body();
  }

  _body(){
    return AlertDialog(
      elevation: 0.0,
      title: new Text(widget.title,
        style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w900),),
      content: Container(
        // height: 150,
        // width: 70,
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
          children:_options()
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Aceptar",style: TextStyle(color:miTema.accentColor),),
          onPressed: () {
              if(widget.list.isNotEmpty){
                dynamic item = widget.list[_radioValue];
                widget.onChange(item);
              }
            Navigator.of(context).pop();
          },
        ),
        new FlatButton(
          child: new Text("Cancelar",style: TextStyle(color:miTema.accentColor)),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
      ],
    );
  }
  _options(){
    List<Widget> list = [];
    int value = 0;
    widget.list.forEach((r){
      final item = 
      RadioListTile(
        title: Text(r.nombre),
        dense: false,
        activeColor: miTema.accentColor,
        value: value, 
        groupValue: _radioValue, 
        onChanged: _handleRadioValueChange);
      value++;
      list.add(item);
    });
    return list;
  }
}