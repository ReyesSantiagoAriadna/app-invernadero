import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/actividad_sobrante_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/actividades/producto_model.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/input_select.dart';
import 'package:flutter/material.dart';
import 'package:line_icons/line_icons.dart';

class DialogSelectProducto extends StatelessWidget {
  final SolarCultivoBloc solarCultivoBloc;
  final ActividadSobranteBloc sobranteBloc;
  final Responsive responsive;

  const DialogSelectProducto({Key key, this.solarCultivoBloc, this.sobranteBloc, this.responsive}) : super(key: key);

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
              Icon(LineIcons.archive,color: MyColors.GreyIcon,),
              SizedBox(width:18),
              Text("Producto",style: _style,),
              ],
          ),
          SizedBox(height:10),
          StreamBuilder(
            stream: solarCultivoBloc.cultivoActiveStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              if(snapshot.hasData){
                Cultivo cultivo = snapshot.data;
                return StreamBuilder(
                stream: sobranteBloc.activeProductoStream ,
                initialData:sobranteBloc.productoActive!=null?sobranteBloc.productoActive:null,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  Producto object;
                  if(snapshot.hasData)
                  object = snapshot.data;
                  sobranteBloc.productosCultivo(cultivo.id.toString());
                  return StreamBuilder(
                    stream: sobranteBloc.productosStream ,
                    builder: (BuildContext context, AsyncSnapshot snapshot){
                      if(!snapshot.hasData)
                        return Container();
                      List<Producto> list = snapshot.data; 
                      return GestureDetector(
                        onTap: (){
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return DialogListProducto(sobranteBloc:sobranteBloc,list: list);
                          });
                        },
                        child:InputSelect(text: object!=null?object.nombre: "Elije el Producto", responsive: responsive),
                      );
                    },
                  );
                },
              );
            }
            return Container(
            );
            },
          ),
        ]
      ),
    );
  }
}



class DialogListProducto extends StatefulWidget {
  final ActividadSobranteBloc sobranteBloc;
  final List<Producto> list;

  const DialogListProducto({Key key, this.sobranteBloc, this.list}) : super(key: key);


  @override
  _DialogListProductoState createState() => _DialogListProductoState();
}

class _DialogListProductoState extends State<DialogListProducto> {
  int _radioValue=-1;

  @override
  void initState() {
     if(widget.sobranteBloc.productoActive!=null){
      _radioValue =  widget.list.indexWhere((i)=>i.id==widget.sobranteBloc.productoActive.id);
     }
    super.initState();
  }

  @override
  void didChangeDependencies() {

    super.didChangeDependencies();
  }

  void _handleRadioValueChange(int value) {
    print("value $value");
    setState(() {
      _radioValue = value;
    });
    setState(() {
      print("cambiando de unidad");
    });
  }

  @override
  Widget build(BuildContext context) {
    return _solares();
  }

  _solares(){
    return AlertDialog(
      elevation: 0.0,
      title: new Text("Productos",
        style: TextStyle(fontFamily: 'Quicksand',fontWeight: FontWeight.w900),),
      content: Container(
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            children:  _options(),
          ),
        ),
      ),
      actions: <Widget>[
        new FlatButton(
          child: new Text("Aceptar",style: TextStyle(color:miTema.accentColor),),
          onPressed: () {
            Producto p = widget.list[_radioValue];
            widget.sobranteBloc.onChangeActiveProduc(p);
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
    List<Widget> listW = [];
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
      listW.add(item);
    });
    return listW;
  }
}