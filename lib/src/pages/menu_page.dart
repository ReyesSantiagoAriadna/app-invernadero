
import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/page_bloc.dart';
import 'package:app_invernadero_trabajador/src/pages/zoom_scafold.dart';
import 'package:app_invernadero_trabajador/src/providers/menu_provider.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/icon_string_util.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/circular_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class MenuScreen extends StatefulWidget {
  @override
  _MenuScreenState createState() => _MenuScreenState();
}

class _MenuScreenState extends State<MenuScreen> {

  Responsive _responsive;


  final String imageUrl =
      "https://celebritypets.net/wp-content/uploads/2016/12/Adriana-Lima.jpg";

  

  PageBloc _pageBloc;
  Future<List<dynamic>> opts;

  @override
  void didChangeDependencies() {
    opts =  menuProvider.loadData();
    _responsive = Responsive.of(context);
    _pageBloc = PageBloc();
    super.didChangeDependencies();
  }


  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onPanUpdate: (details) {
        //on swiping left
        if (details.delta.dx < -6) {
          Provider.of<MenuController>(context, listen: true).toggle();
        }

      },
      child: Container(
        padding: EdgeInsets.only(
            top: 62,
            left: 32,
            bottom: 8,
            right: MediaQuery.of(context).size.width / 2.9),
        color:miTema.accentColor,
        child: Column(
          children: <Widget>[
            Row(
              children: <Widget>[
                Padding(
                  padding: const EdgeInsets.only(right: 16),
                  child: CircularImage(
                    NetworkImage(imageUrl),
                  ),
                ),
                Text(
                  'Trabajador',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 20,
                    fontFamily: AppConfig.quicksand,
                    fontWeight: FontWeight.w700
                  ),
                )
              ],
            ),
            Spacer(),
            _options(),
            Spacer(),
            ListTile(
              onTap: () {
                // Provider.of<MenuController>(context, listen: true).toggle();
               
                Navigator.pushNamed(context, 'ajustes');
              },
              leading: Icon(Icons.settings_applications,color:Colors.white),
              title: Text('Ajustes  ',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w500,
                  fontSize: _responsive.ip(1.6)
                ),
                ),
            ),
            ListTile(
              onTap: () {},
              leading: Icon(
                LineIcons.sign_out,
                color: Colors.white ,
                size: 20,
              ),
              title: Text('Salir',
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w500,
                  fontSize: _responsive.ip(1.6)
                ),
                ),
            ),
          ],
        ),
      ),
    );
  }
  
  Widget _options(){
    return FutureBuilder(
        future: opts,
        initialData: [],
        builder: (BuildContext context, AsyncSnapshot<List<dynamic>> snapshot) {
        return Column(
          children: _listItems(snapshot.data),
        );
        },
    );
  }

  List<Widget> _listItems(List<dynamic> data){
    final List<Widget> opciones=[];
    data.forEach((opt){
      final widgetTemp = 
      ListTile(
      title:  Text(opt['texto'],
                style: TextStyle(
                  color: Colors.white,
                  fontFamily: 'Quicksand',
                  fontWeight: FontWeight.w700,
                  fontSize: _responsive.ip(1.5)
                ),
                ),
     // leading: getIcon(opt['icon'],_responsive),
      onTap: (){
        // Navigator.pushNamed(context, opt['ruta']);
        //Provider.of<MenuController>(context, listen: true).toggle();
        _pageBloc.pickPage(opt['ruta'],opt['texto']);

        
      },
      );

      // opciones..add(widgetTemp)..add(Container(
      // padding: EdgeInsets.symmetric(horizontal:5),  
      //                 height: 0,
      //                 color: Color(0xFFEEEEEE),
      //               ),);//..add(Divider());

      opciones.add(widgetTemp);
    });
    return opciones;
  } 
}


class MenuItem {
  String title;
  IconData icon;

  MenuItem(this.icon, this.title);
}