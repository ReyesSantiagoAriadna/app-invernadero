import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/notifications/notificacion.dart';
import 'package:app_invernadero_trabajador/src/services/notifications/notifications_service.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';


class NotificationsPage extends StatefulWidget {
  @override
  _NotificationsPageState createState() => _NotificationsPageState();
}

class _NotificationsPageState extends State<NotificationsPage> {
  Responsive _responsive;
  NotificationsService notificationsService;
  @override
  void initState() {
    initializeDateFormatting();
    super.initState();
  }

  @override
  void didChangeDependencies() {
    if(_responsive==null){
      _responsive = Responsive.of(context);
      // notificationsService = Provider.of<NotificationsService>(context);
      notificationsService = NotificationsService.instance;
    }
    super.didChangeDependencies();
  }

  @override
  void dispose() {
    notificationsService.markAsReadLocal();
    // notificationsService.markAsReadHive();
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        brightness: Brightness.light,
        backgroundColor: Colors.white,
        elevation: 0.0,
        title:Text("Notificaciones",style: TextStyle(color:MyColors.GreyIcon,fontFamily:AppConfig.quicksand,fontWeight: FontWeight.w700),),
        leading: IconButton(icon: Icon(LineIcons.angle_left,color: MyColors.GreyIcon,), onPressed: ()=>Navigator.pop(context)),

      ),

      body: _body(),
    );
  }

  _body(){
    return Container(
      width: double.infinity,
      height: double.infinity,
      child: StreamBuilder(
        // stream: Provider.of<NotificationsService>(context).notificationsStream ,
        stream: NotificationsService.instance.notificationsStream,
        builder: (BuildContext context, AsyncSnapshot snapshot){

          List<Notificacion> list = new List();
          if(snapshot.hasData)
            list = snapshot.data;
          return ListView.builder(
            itemCount: list.length,
            itemBuilder: (BuildContext context,int index){
              return _itemNotification(list[index]);
            }

          );
        },
      ),
    );
  }

  _itemNotification(Notificacion n){
    // DateTime myDatetime = DateTime.parse(n.createdAt);
    TextStyle _style = TextStyle(color:Colors.black54,fontWeight: FontWeight.w600,fontFamily: AppConfig.quicksand,fontSize: _responsive.ip(1.8));
    TextStyle _styleSub = TextStyle(color:Colors.black87,fontFamily: AppConfig.quicksand,fontSize:_responsive.ip(1.5));
    return new Container(
      // margin: EdgeInsets.only(top:10,bottom:5),
      child:Card(
        elevation: 2,
                child: Column(
          children:<Widget>[
           // _createFlutterMap(widget.solar.latitud, widget.solar.longitud),
            Container(
              margin: EdgeInsets.all(4),
            padding: EdgeInsets.all(4),
            width: double.infinity,
            decoration: BoxDecoration(
              borderRadius:BorderRadius.circular(15),
              // color: n.readAt!=null?Colors.white:miTema.primaryColor.withOpacity(0.2),
            ),
            child: Row(
              children: <Widget>[
                Container(
                  color: n.readAt==null?miTema.accentColor:Colors.white,
                  width: 5,
                  height: _responsive.ip(8),
                ),
                _icon(n.type),
                // Expanded(child: Container()),
                Flexible(
                  child: Container(
                    // color: Colors.red,
                    margin: EdgeInsets.only(left:20),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children:<Widget>[
                        Text("${n.data.titulo}",
                          overflow: TextOverflow.ellipsis,
                          style: _style,),
                        SizedBox(height:5),
                        Row(
                          children:<Widget>[
                            Icon(LineIcons.clock_o,size: 20,color: Colors.grey,),
                            Text("${n.createdAt}",
                              style: _styleSub,
                            )
                          ]),
                        //  Text("${n.type}",
                        //   overflow: TextOverflow.ellipsis,
                        //   style: _style,),
                        Text(
                          new DateFormat.EEEE('es').add_MMMMd().format(n.createdAt) + " a las: "+new DateFormat.jm().format(n.createdAt),
                            style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w900, fontSize: _responsive.ip(1.2),
                            color: Colors.grey),
                              overflow: TextOverflow.ellipsis,
                            )

                    ]),
                  ),
                ),
                //Expanded(child: Container()),
                Row(
                  children:<Widget>[
                    IconButton(icon:  Icon(LineIcons.eye,color: MyColors.GreyIcon,),
                      onPressed: null),
                    IconButton(icon:  Icon(LineIcons.ellipsis_v,color: MyColors.GreyIcon,),
                      onPressed: null),

                  ]
                )
              ],
            ),
              ),

          ]
        ),
      ) ,
    );
  }


  _icon(String  type){
    //if(widget.tarea==AppConfig.taskType1){
      return Stack(
        alignment: Alignment.center,
        children: <Widget>[
          new Icon(
              Icons.brightness_1,
              size: _responsive.ip(6), color: _color(type)),
              _iconD(type),
        ],);
    //}
  }

  Color _color(String type){
    switch(type.replaceAll(r'\', r'')){
      case AppConfig.notif_type_insumo:
        return Colors.redAccent;
      case AppConfig.notif_type_tarea_p:
        return Colors.blueAccent;
      case AppConfig.notif_type_pedido:
        return Colors.purple;
      default:
        return Colors.white;
    }
  }
  
  Widget _iconD(String type){
     switch(type.replaceAll(r'\', r'')){
      case AppConfig.notif_type_insumo:
        return SvgPicture.asset('assets/icons/bottle_icon.svg',color:Colors.white,height: 25,);
      case AppConfig.notif_type_tarea_p:
        return Icon(LineIcons.calendar_check_o,color: Colors.white,);
      case AppConfig.notif_type_pedido:
        return SvgPicture.asset('assets/icons/order_icon.svg',color:Colors.white,height: 25,);
      default:
        return Icon(LineIcons.circle_o_notch);
    }
  }
}