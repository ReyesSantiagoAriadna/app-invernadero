import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/page_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/plagaBloc/plaga_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/plagasEnfermedades/plaga.dart';  
import 'package:app_invernadero_trabajador/src/services/plagasService/plaga_services.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/widgets/my_alert_dialog.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/rendering.dart'; 
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart'; 
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class PlagasHomePage extends StatefulWidget {
  @override
  _PlagasHomePageState createState() => _PlagasHomePageState();
}

class _PlagasHomePageState extends State<PlagasHomePage> {
  Stream<List<Plagas>> plagaStream;
  Responsive _responsive;
  TextStyle _style,_styleSub;
  PageBloc _pageBloc;
  ScrollController _hideButtonController;
  bool _isVisible;
  bool _isLoading=false;
  PlagaBloc plagaBloc;

  @override
  void initState() {
    // TODO: implement initState
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

           Provider.of<PlagaService>(context,listen: false)
           .fetchPlagas()
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
    plagaStream = Provider.of<PlagaService>(context).plagaStream;
    
  }

  @override
  Widget build(BuildContext context) {
     _style = TextStyle(color:Colors.black,fontFamily: AppConfig.quicksand,fontSize: _responsive.ip(2.2));
    _styleSub = TextStyle(color:Colors.black,fontFamily: AppConfig.quicksand,fontSize:_responsive.ip(1.5));
  
    return Scaffold(
      backgroundColor: Colors.white,
      body:Stack(
        children: <Widget>[
          Positioned(
            child:  Container(
            margin: EdgeInsets.only(left:8,right: 8),
            child: StreamBuilder(
              stream: plagaStream,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                if(snapshot.hasData){
                  List<Plagas> plagas = snapshot.data; 
                  return ListView.builder(
                    controller: _pageBloc.scrollCont,
                    physics: BouncingScrollPhysics(),
                    itemCount: plagas.length,
                    itemBuilder: (context, i) => _crearItem(context, plagas[i]),
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
            Navigator.pushNamed(context,'plaga_add');
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

  Widget _crearItem(BuildContext context, Plagas plaga){ 
    return Container(
      margin: EdgeInsets.only(top: 2, bottom:15),
      child: Column(
        children: <Widget>[
          Container(
            height: _responsive.ip(18),
            width: double.infinity,
            child: (plaga.urlImagen == null)
            ? Image(image: AssetImage('assets/bug-96.png'),fit: BoxFit.fitHeight,)
            :FadeInImage(
               image: NetworkImage(plaga.urlImagen),
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
                   Text('${plaga.nombre }',style: _style,),
                   Text('Detección: ${plaga.fecha}',style: _styleSub,),
                   Row(
                     children: <Widget>[
                        //Text('Solar: ${plaga.idSolar}   ',style: _styleSub,),
                        SizedBox(height:_responsive.ip(2)),
                        Text('Cultivo: ${plaga.nombreCultivo}',style: _styleSub,)
                     ],
                   )
                 ]
               ), 
                
                Expanded(child: Container()),
 
                IconButton(icon:  Icon(LineIcons.trash,color: MyColors.GreyIcon,), 
                onPressed: ()=> _deleteModalBottomSheet(context, plaga.id)),

                IconButton(icon:  Icon(LineIcons.pencil,color: MyColors.GreyIcon,), 
                onPressed: (){  
                   Navigator.pushNamed(context, 'plaga_edit', arguments: plaga);
                  } 
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

   void _deleteModalBottomSheet(context, int idPlaga)async{
    showModalBottomSheet(
      context: context,
      builder: (BuildContext bc){
        return Container(
          child: new Wrap(
          children: <Widget>[ 
            new ListTile(
              leading: new Icon(LineIcons.trash_o),
              title: new Text('Eliminar',style: TextStyle(fontFamily:'Quicksand',fontWeight: FontWeight.w400),),
              onTap: (){
                showMyDialog(context, 
                  'Eliminar plaga', 
                  '¿Estas seguro de eliminar la plaga?', 
                  ()=> Provider.of<PlagaService>(context, listen: false)
                    .deletePlaga(idPlaga)
                    .then((r){
                      Flushbar(
                      message:  Provider.of<PlagaService>(context,listen: false).response,
                      duration:  Duration(seconds: 2),              
                    )..show(context).then((r){
                      Navigator.pop(context);
                    });
                    })
                );
              },
            ),
            ],
           ),
        );
      }
    );
  } 
}


/*
GestureDetector( 
      onTap: ()=>Navigator.pushNamed(context, 'details_plagas',arguments: plaga),
      child: Container(
      margin: EdgeInsets.only(top:4,bottom:4),
      height: _responsive.ip(28),
      width: double.infinity,
      child: Card(
        child: Column(
           children: <Widget>[
            Container(
             padding: EdgeInsets.all(4),
             width: double.infinity,
             child: Column(
               mainAxisAlignment: MainAxisAlignment.start,
               crossAxisAlignment: CrossAxisAlignment.start,
               children:<Widget>[ 
                  Container(
                     height: _responsive.ip(18),
                     width: double.infinity,
                     child: (plaga.urlImagen == null)
                      ? Image(image: AssetImage('assets/no-image.png'),fit: BoxFit.fitHeight,)
                      :FadeInImage(
                        image: NetworkImage(plaga.urlImagen),
                        placeholder: AssetImage('assets/jar-loading.gif'), 
                        height: double.infinity,
                        width: double.infinity,
                        fit: BoxFit.cover,
                        ),
                  ),
                  Container(
                    padding: EdgeInsets.all(4),
                    width: double.infinity,
                    child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:<Widget>[
                      Text('${plaga.nombre }',style: _style,),
                      Text('Detección: ${_fecha}',style: _styleSub,),
                      Text('Cultivo: ${plaga.nombreCultivo}',style: _styleSub,)
                    ]
                  ), 
                  ),
                  
              ]
             ),
            ), 
           ],
         ),
      ),
      ),
    );
 */