import 'package:app_invernadero_trabajador/src/blocs/page_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/ventas/ventas_model.dart';
import 'package:app_invernadero_trabajador/src/pages/ventas/venta_widget.dart';
import 'package:app_invernadero_trabajador/src/services/ventas/ventas_service.dart'; 
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart'; 
import 'package:provider/provider.dart'; 

class VentasHomePage extends StatefulWidget {
  @override
  _VentasHomePageState createState() => _VentasHomePageState();
}

class _VentasHomePageState extends State<VentasHomePage> {
  Stream<List<Venta>> ventasStream;
  PageBloc _pageBloc;
  ScrollController _hideButtonController;
  bool _isVisible; 
  bool _isLoading=false;
  TextStyle _style,_styleSub;
  Responsive _responsive;

  @override
  void initState() { 
    super.initState();
    _pageBloc = PageBloc();
    _hideButtonController  = _pageBloc.scrollCont;
    super.initState();
    _isVisible = true;
    _hideButtonController.addListener((){
      if(_hideButtonController.position.userScrollDirection == ScrollDirection.reverse){
        if(_hideButtonController.position.pixels==_hideButtonController.position.maxScrollExtent){
          print("final**********");
        
          // setState(() {
          // _isLoading=true;
          // });

          //  Provider.of<SolarCultivoService>(context,listen: false)
          //  .fetchSolares()
          //  .then((v){
          //     if(mounted){
          //     setState(() {
          //       _isLoading=false;
          //     });

              
          //     if(v){
          //       _hideButtonController.animateTo(
          //         _hideButtonController.position.pixels +100,
          //          duration: Duration(milliseconds:250), 
          //          curve: Curves.fastOutSlowIn);
          //     }
          //    }
          //  });
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
    
    ventasStream = Provider.of<VentaService>(context).ventaStream;
    _responsive = Responsive.of(context);
  }

  @override
  Widget build(BuildContext context) { 
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
            child: Container(
              margin: EdgeInsets.only(left: 8, right: 8),
              child: StreamBuilder(
                stream: Provider.of<VentaService>(context).ventaStream , 
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    List<Venta> ventas = snapshot.data;
                    return ListView.builder(
                      controller: _pageBloc.scrollCont,
                      physics: BouncingScrollPhysics(),
                      itemCount: ventas.length,
                      itemBuilder: (BuildContext context, int index){
                        return VentaWidget(venta: ventas[index]);
                      }
                    );
                  }
                  return Container();
                },
              ),
            )
          ),
          Positioned(child: _createLoading())
        ],
      ),
    /*  floatingActionButton: Visibility(
        visible: _isVisible,
        child: FloatingActionButton(
          onPressed: (){},
          child: Icon(LineIcons.plus),
          backgroundColor: miTema.accentColor,
        )
      ),*/
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
}