
import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/etapa_cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/my_alert_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';


class DetailsSolarPage extends StatefulWidget {
  @override
  _DetailsSolarPageState createState() => _DetailsSolarPageState();
}

class _DetailsSolarPageState extends State<DetailsSolarPage> {
  SolarCultivoBloc solarCultivoBloc;
  Responsive _responsive;
  bool _showAppbar = true ; // esto es para mostrar la barra de aplicaciones
  ScrollController _scrollBottomBarController = new ScrollController (); // establece el controlador en desplazamiento
  bool isScrollingDown = false ;
  bool _show = true ;

  Solar solar;
  @override
  void initState() {
    solarCultivoBloc = SolarCultivoBloc();
    solar = solarCultivoBloc.solar;
     myScroll ();
    super.initState();
  }
  @override
  void dispose() {
    _scrollBottomBarController.removeListener (() {});
    super.dispose();
  }
    @override
  void didChangeDependencies() {


    _responsive = Responsive.of(context);
    super.didChangeDependencies();
  }

  void showBottomBar () {
  setState (() {
    _show = true ;
  });
  }

void hideBottomBar () {
  setState (() {
    _show = false ;
  });
}
void myScroll() async {
  _scrollBottomBarController.addListener(() {
    if (_scrollBottomBarController.position.userScrollDirection ==
        ScrollDirection.reverse) {
      if (!isScrollingDown) {
        isScrollingDown = true;
        _showAppbar = false;
        hideBottomBar();
      }
    }
    if (_scrollBottomBarController.position.userScrollDirection ==
        ScrollDirection.forward) {
      if (isScrollingDown) {
        isScrollingDown = false;
        _showAppbar = true;
        showBottomBar();
      }
    }
  });
}




  @override
Widget build(BuildContext context) {

  print("REINGRESANDO");
  return Scaffold(
    backgroundColor: miTema.accentColor,
    appBar: _showAppbar
        ?  AppBar(
        brightness: Brightness.dark,
        elevation:0.0,
        backgroundColor:miTema.accentColor,
        leading: IconButton(
          icon: Icon(LineIcons.angle_left,color: Colors.white,), onPressed:()=> Navigator.pop(context)),
        // iconTheme: IconThemeData(color:MyColors.GreyIcon),
        title:StreamBuilder<Object>(
          stream: solarCultivoBloc.solarStream,
          builder: (context, snapshot) {
            if(!snapshot.hasData)
              return Container();
            Solar s = snapshot.data;
            return Text(s.nombre,
                  style: TextStyle(color:Colors.white,fontFamily: AppConfig.quicksand,
                  fontWeight: FontWeight.w700
                  ),);
          }
        ),
        actions: <Widget>[
          IconButton(
            icon: Icon(LineIcons.pencil,color:Colors.white),
            onPressed: ()=>Navigator.pushNamed(context, 'solar_edit'))
        ],
      )
        : PreferredSize(
      child: Container(),
      preferredSize: Size(0.0, 0.0),
    ),

    body: _body(),
    // floatingActionButton: FloatingActionButton(
    //     onPressed: () {
    //       Navigator.pushNamed(context, 'cultivo_add');
    //     },
    //     child: Icon(LineIcons.plus),
    //     backgroundColor: miTema.accentColor,
    //   ),
  );
}



  _elements(){
    TextStyle _style = TextStyle(fontFamily:AppConfig.quicksand,color: Colors.white);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            Text("Medidas",style: _style,),
            IconButton(
              icon: SvgPicture.asset('assets/icons/ruler_icon.svg',color:Colors.white,height: 20,),onPressed: (){},),
            StreamBuilder<Object>(
              stream: solarCultivoBloc.solarStream,
              builder: (context, snapshot) {
                if(!snapshot.hasData)
                  return Container();
                Solar s = snapshot.data;
                return Text("${s.largo} x ${s.ancho}",style: _style,);
              }
            )
          ],
        ),
        SizedBox(width:10),
        Column(
          children: <Widget>[
             Text("Ubicación",style: _style,),
            IconButton(icon: Icon(LineIcons.map_marker,color:Colors.white),onPressed: (){},),
            StreamBuilder<Object>(
              stream: solarCultivoBloc.solarStream,
              builder: (context, snapshot) {
                if(!snapshot.hasData)
                  return Container();
                  Solar s = snapshot.data;
                return Text("${s.region} ${s.distrito}",style: _style,);
              }
            )
          ],
        )
      ],
    );
  }

  List<Widget> _cultivos(){
    final List<Widget> list=[];
    list.add(_elements());
    list.add(SizedBox(height: _responsive.ip(1),));
    list.add(

      StreamBuilder<Object>(
        stream: solarCultivoBloc.solarStream,
        builder: (context, snapshot) {
          if(!snapshot.hasData)
            return Container();
          Solar s = snapshot.data;
          return Text(s.descripcion,style: TextStyle(
          color:Colors.white70, fontSize: 15
    ),);
        }
      ));
    list.add(_subtitle());
    final List<Widget> list2=[];

    Container container = Container(

        margin: EdgeInsets.only(left:20,right: 20),
        decoration: BoxDecoration(

         // color:Colors.white,
          borderRadius: BorderRadius.circular(15)
        ),
        child: Column(
          children: list2,
        ),
      );

    list.add(container);


    solar.cultivos.forEach((c){
    Cultivo cultivo = c;

      final element = Container(
        height: 70,
        decoration: BoxDecoration(
        color : Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color:Colors.black26,
            blurRadius: 3.0,
            offset : Offset(0.0,3),
            spreadRadius: 3.0
          )
        ]
      ),
      child: Container(
        // width: 180,
        padding: EdgeInsets.all(8),
        child: Row(children: <Widget>[
          SvgPicture.asset('assets/icons/seelding_icon.svg',color:MyColors.GreyIcon,height: 25,),
          Expanded(
            child: Container(
              margin: EdgeInsets.only(left:25),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: <Widget>[
                  Text("${cultivo.nombre}".toUpperCase(),
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      
                      fontFamily: AppConfig.quicksand,
                      fontWeight: FontWeight.w600,
                     
                      fontSize: _responsive.ip(1.7)
                    ),),
                  Text("${cultivo.observacion}",
                  maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: TextStyle(
                      color: MyColors.GreyIcon,

                    ),
                  )
                ],
              ))),

          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: IconButton(
                    icon: Icon(LineIcons.ellipsis_v,color: MyColors.GreyIcon,), 
                    onPressed: ()=>_deleteModalBottomSheet(context,cultivo) )),
                Container(
                  child: IconButton(icon: Icon(LineIcons.eye,color: MyColors.GreyIcon,), 
                  onPressed: ()=>_showEtapasModalBottomSheet(context,cultivo.nombre,cultivo.etapas)))
              ],
            ),
           ),
        ],),
      ),
      );

      list2..add(element)..add(Container(height: 10,));
    });

    // list.add(_itemsCultivos());
    // list.add(stack);
    return list;
  }

  _subtitle(){
    return Container(
      margin: EdgeInsets.only(left:25,right:8,top: 15,bottom: 15),
      width: double .infinity,
      height: 25,
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.center,
        children:<Widget>[
          // FaIcon(LineIcons.leaf,color:Colors.white,),

          Text(
            "Cultivos",
            style: TextStyle(
              color: Colors.white,
              fontSize: _responsive.ip(2.3),
              fontWeight: FontWeight.w700,
              fontFamily:AppConfig.quicksand,
            ),
          ),
          Expanded(child:Container()),
          IconButton(
            icon:Icon(LineIcons.plus,color: Colors.white,), 
            onPressed: (){
              Navigator.pushNamed(context, 'cultivo_add');
            })
        ]
      )
    );
  }


  _background(){
    return Container(
      height: double.infinity,
      width: double.infinity,
      child: Column(
        children:<Widget>[
          Container(
            color: miTema.accentColor,
            width: _responsive.wp(100),
            height: _responsive.wp(45),
          ),

          Expanded(
                      child: Container(
              color: Colors.white,
              width: double.infinity,
              //height: _responsive.ip(55.1),
            ),
          )
        ]
      ),
    );
  }

  _body(){
    return Container(
        height:double.infinity,
        width:_responsive.widht,
        child: Stack(
      children: <Widget>[
        Positioned(
        child: _background(),),
        Positioned(
        child: Container(
     height: double.infinity,
      width: double.infinity,
    child: SingleChildScrollView(
      controller: _scrollBottomBarController,
      physics: BouncingScrollPhysics(),
                      child: Column(
          children:_cultivos()
        ),
    ),
        ),
        ),
      ],
    ),
      );
  }

  void _deleteModalBottomSheet(context,Cultivo cultivo)async{
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: new Wrap(
          children: <Widget>[ 
            new ListTile(
              leading: new Icon(LineIcons.trash_o),
              title: new Text('Eliminar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
              onTap: () { 
                showMyDialog(context, "Eliminar cultivo", "¿Estas seguro de eliminar el cultivo?",
                  ()=>Provider.of<SolarCultivoService>(context,listen: false)
                  .deleteCultivo(solar.id, cultivo.id)
                  .then((r){
                    Flushbar(
                      message:  Provider.of<SolarCultivoService>(context,listen: false).response,
                      duration:  Duration(seconds: 2),              
                    )..show(context).then((r){
                      Navigator.pop(context);
                    });
                  })
                
                  );
              },
            ),

            new ListTile(
              leading: new Icon(LineIcons.pencil),
              title: new Text('Editar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
              onTap: () { 
                Navigator.pushNamed(context, 'cultivo_edit',arguments: cultivo);
              },
            ),
            ],
           ),
        );
      }
    );
  } 

  void _showEtapasModalBottomSheet(context,String cultivo,List<Etapa> etapas)async{
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        

        return Container(
          child: new Wrap(
          children: _etapas(cultivo,etapas),
           ),
        );
      }
    );
  } 

  List<Widget> _etapas(String cultivo,List<Etapa> etapas){
    TextStyle _style = TextStyle(fontFamily:AppConfig.quicksand);
    List<Widget> list = [];

    ListTile title = ListTile(
      leading: Icon(LineIcons.sitemap),
      title: Text("$cultivo".toUpperCase(),style: _style,),
    );
    
    ListTile subtile = ListTile(
      dense: false,
      title: Text("Etapas de cultivo",style: _style,),
    );

    list.add(title);
    list.add(Container(height: 5,));
    list.add(subtile);

    if(etapas.isEmpty){
      ListTile msg = ListTile(
        leading: Icon(LineIcons.close,color: MyColors.GreyIcon,),
        title: Text("No hay datos",style: _style,),
      );
      list.add(msg);
    }
    etapas.forEach((e){
      ListTile tile =  ListTile(
        dense: false,
        leading: Icon(LineIcons.angle_right),
        title: Text(e.nombre),
        subtitle: Text("Dias: ${e.dias}"),
      );

      list.add(tile);
    });
    return list;
  }


  _itemsCultivos(){
    return StreamBuilder(
      stream: solarCultivoBloc.solarStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        if(snapshot.hasData){
          Solar s = snapshot.data;
          List<Cultivo> cultivos= s.cultivos;
          return ListView.builder(
            itemCount: cultivos.length,
            itemBuilder: (context,index){
              return _itemCultivo(cultivos[index]);
            }
          );
        }

        return Container();
      },
    );
  }

  _itemCultivo(Cultivo cultivo){

    return Container(
        height: 70,
        decoration: BoxDecoration(
        color : Colors.white,
        borderRadius: BorderRadius.circular(5.0),
        boxShadow: <BoxShadow>[
          BoxShadow(
            color:Colors.black26,
            blurRadius: 3.0,
            offset : Offset(0.0,3),
            spreadRadius: 3.0
          )
        ]
      ),
      child: Container(
        // width: 180,
        padding: EdgeInsets.all(8),
        child: Row(children: <Widget>[
          SvgPicture.asset('assets/icons/seelding_icon.svg',color:MyColors.GreyIcon,height: 25,),
          Expanded(
            child: Container(
              color: Colors.red,
              height: 70,
              margin: EdgeInsets.only(left:25),
              child: Row(
                children: <Widget>[
                  // Text("${cultivo.nombre}",
                  //   overflow: TextOverflow.ellipsis,
                  //   style: TextStyle(
                  //     fontFamily: AppConfig.quicksand,
                  //     fontWeight: FontWeight.w700,
                  //     fontSize: _responsive.ip(1.7)
                  //   ),),
                  Text(cultivo.observacion),
                ],
              ))),

          Container(
            child: Row(
              children: <Widget>[
                Container(
                  child: IconButton(
                    icon: Icon(LineIcons.ellipsis_v,color: MyColors.GreyIcon,), 
                    onPressed: ()=>_deleteModalBottomSheet(context,cultivo) )),
                Container(
                  child: IconButton(icon: Icon(LineIcons.eye,color: MyColors.GreyIcon,), 
                  onPressed: ()=>_showEtapasModalBottomSheet(context,cultivo.nombre,cultivo.etapas)))
              ],
            ),
           ),
        ],),
      ),
      );
  }
  
}