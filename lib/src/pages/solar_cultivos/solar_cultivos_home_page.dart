import 'package:app_invernadero_trabajador/src/blocs/page_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/solar_widget.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';
class SolarCultivosHomePage extends StatefulWidget {
  SolarCultivosHomePage({Key key}) : super(key: key);

  @override
  _SolarCultivosHomePageState createState() => _SolarCultivosHomePageState();
}

class _SolarCultivosHomePageState extends State<SolarCultivosHomePage> {
  PageBloc _pageBloc;
  Stream<List<Solar>> solaresStream;
  ScrollController _hideButtonController;
  bool _isVisible;
  SolarCultivoBloc solarCultivoBloc = SolarCultivoBloc();
  bool _isLoading=false;
  @override
  void initState() {
     _pageBloc = PageBloc();
    _hideButtonController  = _pageBloc.scrollCont;
    super.initState();
    _isVisible = true;
    _hideButtonController.addListener((){
      if(_hideButtonController.position.userScrollDirection == ScrollDirection.reverse){
        if(_hideButtonController.position.pixels==_hideButtonController.position.maxScrollExtent){
          print("final**********");
        
          setState(() {
          _isLoading=true;
          });

           Provider.of<SolarCultivoService>(context,listen: false)
           .fetchSolares()
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
  void dispose() {
    //_hideButtonController.dispose();
    super.dispose();
  }

  @override
  void didChangeDependencies() {
    // _solarCultivoBloc = SolarCultivoBloc();
    // _solarCultivoBloc.solares();
   
    solaresStream = Provider.of<SolarCultivoService>(context).solarStream;

    super.didChangeDependencies();
    
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: <Widget>[
          Positioned(
                      child: Container(
              margin:EdgeInsets.only(left:8,right: 8),
              child: StreamBuilder(
                stream: Provider.of<SolarCultivoService>(context).solarStream,
                builder: (BuildContext context, AsyncSnapshot snapshot){
                  if(snapshot.hasData){
                    List<Solar> solares = snapshot.data;
                    return ListView.builder(
                      controller: _pageBloc.scrollCont,
                       physics: BouncingScrollPhysics(),
                      itemCount: solares.length,
                      itemBuilder: (BuildContext context, int index) {
                        print("elemtn");
                      return SolarWidget(solar:solares[index],solarCultivoBloc: solarCultivoBloc,);
                     },
                    );
                  }
                  return Container(
                  );
                },
              ),
            ),
          ),

         Positioned(child:  _createLoading(),)
        ],
      ),
      floatingActionButton: Visibility(
        visible: _isVisible,
              child: FloatingActionButton(
          onPressed: () {
            Navigator.pushNamed(context, 'solar_add');
          },
          child: Icon(LineIcons.plus),
          backgroundColor: miTema.accentColor,
        ),
      ),
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