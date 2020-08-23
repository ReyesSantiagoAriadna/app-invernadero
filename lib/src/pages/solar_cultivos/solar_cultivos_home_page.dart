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


  @override
  void didChangeDependencies() {
    // _solarCultivoBloc = SolarCultivoBloc();
    // _solarCultivoBloc.solares();
    _pageBloc = PageBloc();
    _hideButtonController  = _pageBloc.scrollCont;
    solaresStream = Provider.of<SolarCultivoService>(context).solarStream;
    super.didChangeDependencies();
     _isVisible = true;
    _hideButtonController.addListener((){
      if(_hideButtonController.position.userScrollDirection == ScrollDirection.reverse){
        if(_isVisible == true) {
            setState((){
              _isVisible = false;
            });
        }
      } else {
        if(_hideButtonController.position.userScrollDirection == ScrollDirection.forward){
          if(_isVisible == false) {
               setState((){
                 _isVisible = true;
               });
           }
        }
    }});
  }
  
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Container(
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
                  print("Solares=>>> ${solares[index].nombre}");
                return SolarWidget(solar:solares[index]);
               },
              );
            }
            return Container(
            );
          },
        ),
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
}