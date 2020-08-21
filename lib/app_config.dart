class AppConfig{
  static const base_url = 'http://ssinvernadero.herokuapp.com';  
  static const provider_api = 'personals'; //personals
  static const String quicksand = 'Quicksand';
  static const nexmo_country_code='52';

  //** MAPBOX */
  static const mapbox_base_url= 'https://api.mapbox.com/geocoding/v5/mapbox.places';
  static const String mapbox_api_token='pk.eyJ1IjoiYXphZWxtb3JhbGVzcyIsImEiOiJjazhqNmdwZ3UwMGN3M2VxYnNkNWp2cW85In0.QrGCrwp63Tf0kU2ceIjIww';

//'Seleccione', 'Tunel' => 'Tunel','MacroTunel'=>'MacroTunel', 'MicroTunel' => 'MicroTunel', 'Campo Abierto' => 'Campo Abierto', 'Invernadero' => 'Invernadero', 'Hidroponia' => 'Hidroponia', 'Frutales' => 'Frutales'],null,['class'=>'form-control col-md-7 select2','required','id'=>'tipo'])!!}
  
  static const   List<String> regiones = ["Cañada","Costa","Istmo","Mixteca",
    "Papaloapan","Sierra Norte","Sierra Sur","Valles Centrales"
  ];

  static const String caniada = "Cañada";
  static const String costa = "Costa";
  static const String istmo = "Istmo";
  static const String mixteca = "Mixteca";
  static const String papaloapan = "Papaloapan";
  static const String sierran = "Sierra Norte";
  static const String sierras = "Sierra Sur";
  static const String valles = "Valles Centrales";


  static const String uniMedidaCaja = "Caja";

}
