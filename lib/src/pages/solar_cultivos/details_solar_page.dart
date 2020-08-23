import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/cultivo.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';


class DetailsSolarPage extends StatefulWidget {
  @override
  _DetailsSolarPageState createState() => _DetailsSolarPageState();
}

class _DetailsSolarPageState extends State<DetailsSolarPage> {
  Solar solar; 
  Responsive _responsive;
  bool _showAppbar = true ; // esto es para mostrar la barra de aplicaciones 
  ScrollController _scrollBottomBarController = new ScrollController (); // establece el controlador en desplazamiento 
  bool isScrollingDown = false ; 
  bool _show = true ; 
  
  @override
  void initState() {
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
    solar = ModalRoute.of(context).settings.arguments as Solar;
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
  return Scaffold(
    appBar: _showAppbar
        ?  AppBar(
        brightness: Brightness.light,
        elevation:0.0,
        backgroundColor:miTema.accentColor,
        leading: IconButton(
          icon: Icon(LineIcons.angle_left,color: Colors.white,), onPressed:()=> Navigator.pop(context)),
        // iconTheme: IconThemeData(color:MyColors.GreyIcon),
        title:Text(solar.nombre,
              style: TextStyle(color:Colors.white,fontFamily: AppConfig.quicksand,
              fontWeight: FontWeight.w700
              ),),
        actions: <Widget>[
          IconButton(
            icon: Icon(LineIcons.pencil,color:Colors.white), 
            onPressed: ()=>Navigator.pushNamed(context, 'solar_edit',arguments: solar))
        ],
      )
        : PreferredSize(
      child: Container(),
      preferredSize: Size(0.0, 0.0),
    ),
   
    body: _body(),
    floatingActionButton: FloatingActionButton(
        onPressed: () {
        },
        child: Icon(LineIcons.plus),
        backgroundColor: miTema.accentColor,
      ),
  );
}

  

  _elements(){
    TextStyle _style = TextStyle(fontFamily:AppConfig.quicksand,color: Colors.white);
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: <Widget>[
        Column(
          children: <Widget>[
            IconButton(
              icon: SvgPicture.asset('assets/icons/ruler_icon.svg',color:Colors.white,height: 20,),onPressed: (){},),
            Text("${solar.largo} x ${solar.ancho}",style: _style,)
          ],
        ),
        SizedBox(width:10),
        Column(
          children: <Widget>[
            IconButton(icon: Icon(LineIcons.map_marker,color:Colors.white),onPressed: (){},),
            Text("${solar.region} ${solar.distrito}",style: _style,)
          ],
        )
      ],
    );
  }

  List<Widget> _cultivos(){
    final List<Widget> list=[];
    
    list.add(_elements());
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
        decoration:BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10)
        ),
        child:ListTile(
        leading: SvgPicture.asset('assets/icons/seelding_icon.svg',color:MyColors.GreyIcon,height: 20,),
        title: Text(cultivo.nombre),
        subtitle: Text(cultivo.observacion),
        trailing: IconButton(icon: Icon(LineIcons.ellipsis_v), onPressed: null),
      )
      );

      list2..add(element)..add(Container(height: 5,));
    });

    // list.add(stack);
    return list;
  }

  _subtitle(){
    return Container(
      margin: EdgeInsets.only(left:25,right:8,top: 15,bottom: 5),
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
            height: _responsive.wp(39),
          ),

          Container(
            color: MyColors.Grey,
            width: double.infinity,
            height: _responsive.ip(55.1),
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
  
 
}