import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/page_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/ofertas/oferta.dart';
import 'package:app_invernadero_trabajador/src/models/productos/producto.dart';
import 'package:app_invernadero_trabajador/src/providers/ofertasProvider/ofertas_provider.dart';
import 'package:app_invernadero_trabajador/src/providers/productosProvider/productos_provider.dart';
import 'package:app_invernadero_trabajador/src/services/ofertaService/ofertas_service.dart';
import 'package:app_invernadero_trabajador/src/services/productoService/produtos_service.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_icons/line_icons.dart';
import 'package:intl/intl.dart'; 
import 'package:provider/provider.dart';

class OfertasHomePage extends StatefulWidget {
  @override
  _OfertasHomePageState createState() => _OfertasHomePageState();
}

class _OfertasHomePageState extends State<OfertasHomePage> {
  Stream<List<Oferta>> ofertaStream;
  PageBloc _pageBloc;
  TextStyle _style,_styleSub;
  Responsive _responsive;
  ScrollController _hideButtonController;
  bool _isVisible,_estado; 
  bool _isLoading=false;
 

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

           Provider.of<OfertaService>(context,listen: false)
           .fetchOfertas()
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
    // TODO: implement didChangeDependencies
    super.didChangeDependencies(); 
 
    _responsive = Responsive.of(context);
    ofertaStream = Provider.of<OfertaService>(context).ofertaStream;   

  }
  @override
  Widget build(BuildContext context) {
     _style = TextStyle(color:Colors.black,fontFamily: AppConfig.quicksand,fontSize: _responsive.ip(2.2));
    _styleSub = TextStyle(color:Colors.black,fontFamily: AppConfig.quicksand,fontSize:_responsive.ip(1.5));
   
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              margin: EdgeInsets.only(left:8,right: 8),
              child: StreamBuilder(
                stream: Provider.of<OfertaService>(context).ofertaStream,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    List<Oferta> oferta = snapshot.data; 
                    return ListView.builder(
                      controller: _pageBloc.scrollCont,
                      physics: BouncingScrollPhysics(),
                      itemCount: oferta.length,
                      itemBuilder: (context, i){ 
                        _estado = (oferta[i].estado == "1") ? true : false; 
                        return  _crearItem(context, oferta[i]);
                      } ,
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
            Navigator.pushNamed(context,'oferta_add');
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

   Widget _crearItem(BuildContext context, Oferta oferta){  
    return Container(
      margin: EdgeInsets.only(top: 2, bottom:15),
      child: Column(
        children: <Widget>[
          Container(
            height: _responsive.ip(18),
            width: double.infinity,
            child: (oferta.urlImagen == null)
            ? Image(image: AssetImage('assets/bug-96.png'),fit: BoxFit.fitHeight,)
            :FadeInImage(
               image: NetworkImage(oferta.urlImagen),
               placeholder: AssetImage('assets/jar-loading.gif'), 
               height: double.infinity,
               width: double.infinity,
               fit: BoxFit.cover,
            ),
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
                   Text('${oferta.tipo}',style: _style,),
                   Text('${oferta.producto}',style: _styleSub,), 
                   Row(
                     children: <Widget>[
                        Text('Del: ${DateFormat("dd-MM-yyyy").format(DateTime.parse(oferta.inicio))}   ',style: _styleSub,),
                        SizedBox(height:_responsive.ip(2)),
                        Text('Al: ${DateFormat("dd-MM-yyyy").format(DateTime.parse(oferta.fin ))}',style: _styleSub,)
                     ],
                   ),
                   Container(
                     width: 285,
                     child: Text('Descripción: ${oferta.descripcion}',
                     style: TextStyle(color:Colors.grey,fontFamily: AppConfig.quicksand,fontSize:_responsive.ip(1.4)),
                     overflow: TextOverflow.ellipsis,
                    ),
                   )
                    
                 ]
               ), 
                
                Expanded(child: Container()),
 
                Stack(
                  children: <Widget>[
                    Row( 
                      children: <Widget>[
                       (_estado) 
                        ? IconButton(icon:  Icon(LineIcons.trash,color: MyColors.GreyIcon,), 
                          onPressed: ()=> _deleteModalBottomSheet(context, oferta.id))
                        : Container(),                        
                       ],
                    )
                  ],
                )                             
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

  void _deleteModalBottomSheet(context, int idOferta)async{
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: new Wrap(
          children: <Widget>[ 
            new ListTile(
              leading: new Icon(LineIcons.trash_o),
              title: new Text('Terminar oferta',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
              onTap: () {   
                Provider.of<OfertaService>(context,listen: false)
                .terminarOferta(idOferta)
                .then((r){ 
                  Flushbar(
                    message:  Provider.of<OfertaService>(context,listen: false).response,
                    duration:  Duration(seconds: 2),              
                  )..show(context).then((r){  
                    Navigator.pop(context);
                  });
                });
              },
            ),
            ],
           ),
        );
      }
    );
  } 
}