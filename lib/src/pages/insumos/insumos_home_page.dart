import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/insumos/insumos_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/page_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/insumos/insumo.dart';
import 'package:app_invernadero_trabajador/src/services/insumosService/insumos_service.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_svg/svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
class InsumosHomePage extends StatefulWidget { 
  
  @override
  _InsumosHomePageState createState() => _InsumosHomePageState();
}

class _InsumosHomePageState extends State<InsumosHomePage> {
  Stream<List<Insumo>> insumoStream;
  Responsive _responsive;
  TextStyle _style,_styleSub;
  ScrollController _hideButtonController;
  bool _isVisible;
  PageBloc _pageBloc;
  bool _isLoading=false, _existencia; 

  @override
  void initState() { 
    super.initState();

    _pageBloc = PageBloc();
    _hideButtonController  = _pageBloc.scrollCont;
    
    _isVisible = true;
     _hideButtonController.addListener((){
      if(_hideButtonController.position.userScrollDirection == ScrollDirection.reverse){
        if(_hideButtonController.position.pixels==_hideButtonController.position.maxScrollExtent){
          print("final**********");
        
          setState(() {
          _isLoading=true;
          });

           Provider.of<InsumoService>(context,listen: false)
           .fetchInsumos()
           .then((v){
              if(mounted){
              setState(() {
                _isLoading=false;
              });

              
              if(v){
                _hideButtonController.animateTo(
                  _hideButtonController.position.pixels +100,
                   duration: Duration(milliseconds:250), 
                   curve: Curves.fastOutSlowIn);
              }
             }
           });
        }
        if(_isVisible == true) {
            
            if(mounted){
              setState((){
              _isVisible = false;
            });
            }
        }
      } else {
        if(_hideButtonController.position.userScrollDirection == ScrollDirection.forward){
          if(_isVisible == false) {
               if(mounted){
                 setState((){
                 _isVisible = true;
               });
               }
           }
        }
    }});
  }

  @override
  void didChangeDependencies() { 
    super.didChangeDependencies();
    _responsive = Responsive.of(context);
    insumoStream = Provider.of<InsumoService>(context).insumoStream;  
  }

  @override
  Widget build(BuildContext context) { 
    _style = TextStyle(color:Colors.black,fontFamily: AppConfig.quicksand,fontSize: _responsive.ip(2.0));
    _styleSub = TextStyle(color:Colors.black,fontFamily: AppConfig.quicksand,fontSize:_responsive.ip(1.5));
  
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
            margin: EdgeInsets.only(left:8,right: 8),
            child: StreamBuilder(
              stream: insumoStream,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  List<Insumo> insumos = snapshot.data; 
                  return ListView.builder(
                    controller: _pageBloc.scrollCont,
                    physics: BouncingScrollPhysics(),
                    itemCount: insumos.length,
                    itemBuilder: (context, i){
                      _existencia = (insumos[i].cantidad==0)?true:false;
                     return  _crearItem(context, insumos[i]);
                    },
                  );
                }
                return Container(
                );
              },
            ),
          ),      
          ),
          Positioned(child: _createLoading())
        ],
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
        child: FloatingActionButton(
          onPressed: (){
            Navigator.pushNamed(context,'insumos_add');
          },
          child: Icon(LineIcons.plus),
          backgroundColor: miTema.accentColor,
        ),
      )
    ); 
  }

  _createLoading(){
    if(_isLoading){
      return Column(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.end,
          children: <Widget>[
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                CircularProgressIndicator()
            ],),
            SizedBox(height:15.0)
          ],
      );
     
    }
    return Container();
  }

    Widget _crearItem(BuildContext context, Insumo insumo){ 
    return Container(
      margin: EdgeInsets.only(top: 2, bottom:15),
      child: Column(
        children: <Widget>[
          Stack(
            children: <Widget>[
              SafeArea(
                child: Container(
                  height: _responsive.ip(18),
                  width: double.infinity,
                  child: (insumo.urlImagen == null)
                  ? Image(image: AssetImage('assets/tools1.png'),fit: BoxFit.fitHeight ,)
                  :FadeInImage(
                    image: NetworkImage(insumo.urlImagen),
                    placeholder: AssetImage('assets/jar-loading.gif'), 
                    height: double.infinity,
                    width: double.infinity,
                    fit: BoxFit.cover,
                  ),
                ),
              ),
              _existencia ? Positioned.fill(child: Container(
                color: Colors.white54
              )
              ):Container()
            ],
          ),

          Container(
             padding: EdgeInsets.all(4),
             width: double.infinity,
             child: Row(
               children: <Widget>[
               Column(
                 mainAxisAlignment: MainAxisAlignment.start,
                 crossAxisAlignment: CrossAxisAlignment.start,
                 children:<Widget>[
                   Text('${insumo.nombre }',style: _style, overflow: TextOverflow.ellipsis,),
                   Text('${insumo.tipo}',style: _styleSub,),
                   Text('Existencia: ${insumo.cantidad}',
                    style:TextStyle(color: (_existencia)? Colors.red : Colors.black,
                    fontFamily: AppConfig.quicksand,
                    fontWeight: FontWeight.w900,
                    fontSize: _responsive.ip(1.5)) 
                   )
                 ]
               ), 

                
                Expanded(child: Container()),

                Stack(
                  children: <Widget>[
                    Row( 
                      children: <Widget>[
                        IconButton(icon:  Icon(LineIcons.eye,color: MyColors.GreyIcon,), 
                        onPressed: ()=> showItem(insumo)
                        ),
                        IconButton(icon: Icon(LineIcons.pencil,color: MyColors.GreyIcon), 
                        onPressed: ()=>Navigator.pushNamed(context, 'insumos_edit', arguments: insumo)
                        
                        )
                      ],
                    )
                     
                  ],
                ), 
                                           
               ],
             )
          ),        
        ],
      ),
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
    );
  }

  void customBottomSheet(Widget myWidget,double heightP){
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        height: MediaQuery.of(context).size.height *heightP,
        decoration: new BoxDecoration(
          color: Colors.white,
          borderRadius: new BorderRadius.only(
            topLeft: const Radius.circular(25.0),
            topRight: const Radius.circular(25.0),
          ),
        ),
        child: Center(
          child: myWidget
        ),
      ),
    );
  }
 
  void showItem(Insumo insumo){
    TextStyle _style = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400,color: MyColors.GreyIcon);
    Column myWidget = Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: <Widget>[
        Container(
          child: new ListTile(
            dense:true,
            leading: new Icon(LineIcons.tint,color: Colors.white,),
            title: new Text('Insumo',
            style: TextStyle(fontFamily:'Quicksand',
            fontWeight: FontWeight.w700,color: Colors.white,fontSize: 18),),
            onTap: null
          ),
          decoration: BoxDecoration(
            color:miTema.accentColor,
            borderRadius: BorderRadius.only(topRight:  Radius.circular(25),topLeft:Radius.circular(25))
          ),
        ),
         SizedBox(height:10),
        _element(Icon(LineIcons.flask, color: MyColors.GreyIcon),insumo.nombre),
        SizedBox(height:2),
        _element(SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 21,),"${  insumo.unidadM}"),
         SizedBox(height:2),
        _element(Icon(LineIcons.codepen, color: MyColors.GreyIcon,), "Existente ${insumo.cantidad} "),
         SizedBox(height:2),
        _element(Icon(LineIcons.money,color: MyColors.GreyIcon,), "Precio promedio ${insumo.precioPromedio}"),
         SizedBox(height:2),
        _element(Icon(LineIcons.dollar, color: MyColors.GreyIcon),"Valor ${insumo.totalSales}")

        // _element(LineIcons.sitemap, widget.tarea.etapa),
        //  _element(LineIcons.clipboard, widget.tarea.detalle),
      ],
    );
    customBottomSheet(myWidget, 0.25);
  }

  _element(Widget icon,String texto){
    TextStyle _style = TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w700,color: MyColors.GreyIcon);
    return Container(
      margin: EdgeInsets.only(left:15),
      child:Row(children: <Widget>[
        icon,
        SizedBox(width:40),
        Text(texto,style: _style,)
      ],)
    );
  }
}