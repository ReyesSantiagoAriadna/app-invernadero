import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:app_invernadero_trabajador/src/blocs/map_box_bloc.dart';
import 'package:app_invernadero_trabajador/src/blocs/solar_cultivo_bloc.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/regiones.dart';
import 'package:app_invernadero_trabajador/src/models/solares_cultivos/solar.dart';
import 'package:app_invernadero_trabajador/src/pages/solar_cultivos/map_widget.dart';
import 'package:app_invernadero_trabajador/src/services/solares_services.dart';
import 'package:app_invernadero_trabajador/src/theme/theme.dart';
import 'package:app_invernadero_trabajador/src/utils/colors.dart';
import 'package:app_invernadero_trabajador/src/utils/responsive.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_distrito.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_mun.dart';
import 'package:app_invernadero_trabajador/src/widgets/dialog_list_region.dart';
import 'package:flushbar/flushbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_spinkit/flutter_spinkit.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:line_icons/line_icons.dart';
import 'package:provider/provider.dart';

class SolarEditPAge extends StatefulWidget {


  @override
  _SolarEditPAgeState createState() => _SolarEditPAgeState();
}

class _SolarEditPAgeState extends State<SolarEditPAge> {
  Responsive _responsive;
  TextStyle _style;
  TextStyle _secundaryStyle;
  SolarCultivoBloc solarCultivoBloc;
  Solar solar;
  bool _isLoading = false;
  Region region;
  @override
  void initState() {
    super.initState();
  }
  @override
  void didChangeDependencies() {
    solarCultivoBloc = SolarCultivoBloc();
    solar = ModalRoute.of(context).settings.arguments as Solar;
    print("SOLAR ${solar.nombre}");
    _responsive = Responsive.of(context);

    solarCultivoBloc.changeSolarNombre(solar.nombre);
    solarCultivoBloc.changeSolarLargo(solar.largo.toString());
    solarCultivoBloc.changeSolarAncho(solar.ancho.toString());
    solarCultivoBloc.changeSolarDescrip(solar.descripcion);


    List<Region> regions = Provider.of<SolarCultivoService>(context,listen: false).regionList;

    region = regions.firstWhere((r)=>r.region==solar.region);
    solarCultivoBloc.changeRegionActive(region);

    List<Distrito> distritos = region.distritos;

    Distrito distrito = distritos.firstWhere((d)=>d.distrito==solar.distrito);

    solarCultivoBloc.changeDistritoActive(distrito);
    solarCultivoBloc.changeMunicipioActive(solar.municipio);
    
    solarCultivoBloc.init();

     _style = TextStyle(
      color: MyColors.GreyIcon,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: _responsive.ip(1.8)
    );

    _secundaryStyle = TextStyle(
      color: Colors.black87,
      fontFamily: AppConfig.quicksand,
      fontWeight: FontWeight.w600,
      fontSize: _responsive.ip(1.5));

    super.didChangeDependencies();
  }

  @override
  void dispose() {
    solarCultivoBloc.reset();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: <Widget>[
        Positioned(
          child: Scaffold(
          backgroundColor: Colors.white,
          appBar: AppBar(
            brightness: Brightness.light,
            elevation: 0.0,
            backgroundColor: Colors.white,
            leading: IconButton(
              icon: Icon(LineIcons.angle_left,color: MyColors.GreyIcon,),
              onPressed: ()=> Navigator.pop(context)  ),
            title: Text("Editar Solar",style:TextStyle(color: MyColors.GreyIcon,
              fontFamily: AppConfig.quicksand,fontWeight: FontWeight.w800
            )),
            actions: <Widget>[
              _createActionSave(),
            ],
          ),

          body: _body(),)
        ),
         _isLoading? Positioned.fill(child:  Container(
                    color:Colors.black45,
                    child: Center(
                      child:SpinKitCircle(color: miTema.accentColor),
                    ),
                  ),):Container()
      ],
    );
  }

   _body(){
    //  _isLoading=true;
    return Container(
      margin: EdgeInsets.only(left:8,right:12,top: 10),
      height: double.infinity,
      width: double.infinity,
      child: SingleChildScrollView(
        physics: BouncingScrollPhysics(),
        child:Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Text("Información del Solar",style: TextStyle(
            fontFamily:AppConfig.quicksand,fontWeight: FontWeight.w700,
            color: MyColors.GreyIcon,fontSize: _responsive.ip(1.9)
          ),),
          SizedBox(height:5),
          Container(
            width: double.infinity,
            height: 2,
            color: Colors.grey[300],
          ),
          SizedBox(height:5),

          _inputNombre(),
          SizedBox(height:_responsive.ip(2)),
          Row(
            children: <Widget>[
              SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
              SizedBox(width:18),
              Text("Medidas",style: _style,),
            ],
          ),
          Container(
            margin: EdgeInsets.only(left:35),
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children:<Widget>[
                Container(
                  width:_responsive.wp(30),
                  child:

                  StreamBuilder<Object>(
                    stream: solarCultivoBloc.solarLargoStream,
                    initialData: solarCultivoBloc.solarLargo,
                    builder: (context, snapshot) {
                      return TextFormField(
                          initialValue: solarCultivoBloc.solarLargo,
                         keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        focusedBorder:  UnderlineInputBorder(
                              borderSide: BorderSide(color:miTema.accentColor)),
                        labelText: 'Largo',
                        errorText: snapshot.error
                      ),
                      onChanged: solarCultivoBloc.changeSolarLargo,
                      );
                    }
                  ),
                ),
                Text("m",style: _style,),
                SizedBox(width:5),
                 Container(
                  width:_responsive.wp(30),
                  child:StreamBuilder<Object>(
                    stream: solarCultivoBloc.solarAnchoStream,
                    initialData: solarCultivoBloc.solarAncho,
                    builder: (context, snapshot) {
                      return TextFormField(
                        initialValue: solarCultivoBloc.solarAncho,
                         keyboardType: TextInputType.number,
                      decoration: InputDecoration(

                       focusedBorder:  UnderlineInputBorder(
                            borderSide: BorderSide(color:miTema.accentColor)),
                      labelText: 'Ancho',
                      errorText: snapshot.error
                ),
                onChanged: solarCultivoBloc.changeSolarAncho,
                );
                    }
                  ),
                ),
                Text("m",style: _style,),
              ]
            ),
          ),
          SizedBox(height:_responsive.ip(2)),
          _description(),
          SizedBox(height:_responsive.ip(2)),
          _region(),
          SizedBox(height:_responsive.ip(2)),
          _distrito(),
          SizedBox(height:_responsive.ip(2)),
          _municipio(),
          MapWidget(responsive: _responsive,),
        ],
        )
      ),
    );
  }

  _inputNombre(){
    return StreamBuilder(
      stream: solarCultivoBloc.solarNombreStream,
      initialData: solarCultivoBloc.solarNombre,
      builder: (BuildContext context, AsyncSnapshot snapshot){
        return TextFormField(
          initialValue: snapshot.data,
              decoration: InputDecoration(
                 focusedBorder:  UnderlineInputBorder(
                          borderSide: BorderSide(color:miTema.accentColor)),
                icon: Icon(LineIcons.sun_o),
                labelText: 'Nombre',
                errorText: snapshot.error
              ),
              onChanged: solarCultivoBloc.changeSolarNombre,
            );
      },
    );
  }

_description(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
               // SvgPicture.asset('assets/icons/ruler_icon.svg',color:MyColors.GreyIcon,height: 20,),
                Icon(LineIcons.clipboard,color: MyColors.GreyIcon,),
                SizedBox(width:18),
                Text("Descripción",style: _style,),
              ],
            ),
           SizedBox(height:_responsive.ip(2)),
          Container(
            margin: EdgeInsets.only(left:40),
            padding: EdgeInsets.all(8),
            child: StreamBuilder<Object>(
              stream: solarCultivoBloc.solarDescripStream,
              initialData: solarCultivoBloc.solarDescrip,
              builder: (context, snapshot) {
                return TextFormField(
                  maxLines: 4,
                  decoration: InputDecoration(
                   hintText: "Ingresa una descripción..",
                    enabledBorder: OutlineInputBorder(
                      borderSide: BorderSide(color:MyColors.GreyIcon),
                    ),
                         focusedBorder:  OutlineInputBorder(
                              borderSide: BorderSide(color:miTema.accentColor)),
                        //labelText: 'Largo'
                        errorText: snapshot.error==''?null:snapshot.error
                      ),
                  // decoration: InputDecoration.collapsed(
                  onChanged: solarCultivoBloc.changeSolarDescrip,

                );
              }
            ),
          )
        ]
      ),
    );
  }
  _region(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
                Icon(LineIcons.globe,color: MyColors.GreyIcon,),
                SizedBox(width:18),
                Text("Región",style: _style,),
              ],
            ),
          SizedBox(height:5),
          StreamBuilder(
              stream: solarCultivoBloc.regionActiveStream ,
              builder: (BuildContext context, AsyncSnapshot snapshot){
                Region region = snapshot.data;
                return GestureDetector(
                  onTap: (){
                    showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return DialogListRegion(solarCultivoBloc: solarCultivoBloc,);
                    });
                  },
                  child:snapshot.hasData?
                  _select(region.region):
                  _select("Elije la región"),
                );
              },
            ),
        ]
      ),
    );
  }

   _distrito(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
                Icon(LineIcons.globe,color: Colors.white,),
                SizedBox(width:18),
                Text("Distrito",style: _style,),
              ],
            ),
          SizedBox(height:5),
          StreamBuilder(
            stream: solarCultivoBloc.distritoActiveStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              Distrito distrito = snapshot.data;
              return GestureDetector(
                onTap: (){
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogListDistrito(solarCultivoBloc: solarCultivoBloc,);
                  });
                },
                child:snapshot.hasData?
                 _select(distrito.distrito):
                 _select("Elije el distrito"),
              );
            },
          ),
        ]
      ),
    );
  }

  _municipio(){
    return Container(
      child: Column(
        children:<Widget>[
          Row(
              children: <Widget>[
                Icon(LineIcons.globe,color: Colors.white,),
                SizedBox(width:18),
                Text("Municipio",style: _style,),
              ],
            ),
          SizedBox(height:5),
          StreamBuilder(
            stream: solarCultivoBloc.municipioActiveStream ,
            builder: (BuildContext context, AsyncSnapshot snapshot){
              return GestureDetector(
                onTap: (){
                  showDialog(
                  context: context,
                  builder: (BuildContext context) {
                    return DialogListMunicipio(solarCultivoBloc: solarCultivoBloc,);
                  });
                },
                child:snapshot.hasData?
                 _select(snapshot.data):
                 _select("Elije el distrito"),
              );
            },
          ),
        ]
      ),
    );
  }
   _select(String data){
    return Container(
      height: 40,
      margin: EdgeInsets.only(left:40,right:10),
      padding: const EdgeInsets.all(5.0),
      decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(5),
      border: Border.all(
        width: 1,
        color: MyColors.GreyIcon)
      ),
      child: Row(
        children:<Widget>[
         Text(data,style: TextStyle(color:MyColors.GreyIcon,fontFamily: AppConfig.quicksand,
          fontSize: _responsive.ip(1.5),fontWeight: FontWeight.w700
        ),),
        Expanded(child:Container()),
        Icon(Icons.expand_more,color: MyColors.GreyIcon,)
        ]
      )
    );
  }
  _createActionSave(){
    return StreamBuilder(
      stream: solarCultivoBloc.formValidStream ,
      builder: (BuildContext context, AsyncSnapshot snapshot){
         print("DATA BOOL: ${snapshot.data}");
        return IconButton(
          icon: Icon(LineIcons.save,color: MyColors.GreyIcon,),
          onPressed: ()=>snapshot.hasData? _saveSolar():print("no se que ostia"),
        );
      },
    );
  }
  _saveSolar()async{
    MapBoxBloc mapBoxBloc = MapBoxBloc();
    if(mapBoxBloc.position==null)
      return;

    if(_isLoading)return;

    setState(() {
      _isLoading=true;
    });

    Solar solar= Solar(
      nombre: solarCultivoBloc.solarNombre,
      largo: double.parse(solarCultivoBloc.solarLargo),
      ancho: double.parse(solarCultivoBloc.solarAncho),
      descripcion: solarCultivoBloc.solarDescrip,
      region: solarCultivoBloc.regionActive.region,
      distrito: solarCultivoBloc.distritoActive.distrito,
      municipio: solarCultivoBloc.municipioActive,
      latitud:mapBoxBloc.position.latitude,
      longitud: mapBoxBloc.position.longitude,
    );

    // await Provider.of<SolarCultivoService>(context,listen: false)
    //   .updateSolar(solar);
    //     setState(() {
    //       _isLoading=true;
    //     });
    //   Flushbar(
    //     message:  Provider.of<SolarCultivoService>(context,listen: false).response,
    //     duration:  Duration(seconds: 2),
    //   )..show(context).then((r){
    //     Navigator.pop(context);
    //   });


     Flushbar(
        message:  Provider.of<SolarCultivoService>(context,listen: false).response,
        duration:  Duration(seconds: 2),
      )..show(context).then((r){
        Navigator.pop(context);
      });
  }
}