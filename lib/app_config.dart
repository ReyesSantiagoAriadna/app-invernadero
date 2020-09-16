class AppConfig{
  //?lat=17.06542&lon=-96.72365&appid=7cae6ef5886a83a20bcf88ef822bf228&lang=es&units=metric
  static const base_url_open_weather = 'http://api.openweathermap.org/data/2.5/weather';
  static const url_open_weather_icon = "http://openweathermap.org/img/w/";//+ iconcode + ".png";
  static const weather_api_key = '7cae6ef5886a83a20bcf88ef822bf228';
  
  static const weather_bit_url = 'http://api.weatherbit.io/v2.0/current';
  static const weather_bit_api_key = '694f92dc92894c45ad8e75fdff5e3fe4';
  static const weather_bit_url_icon = 'https://www.weatherbit.io/static/img/icons/';

  static const base_url = 'http://ssinvernadero.herokuapp.com';  
  static const provider_api = 'personals'; //personals
  static const String quicksand = 'Quicksand';
  static const nexmo_country_code='52';
  static const twilio_country_code='52';
  static const double default_lat = 17.06542 ;
  static const double default_long = -96.72365;
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


  static const String taskType1 = "Diario";
  static const String taskType2 = "Semanal";
  static const String taskType3 = "Ocasional";
  static const String taskType4 = "Solo una vez";
  // date to string
  //DateFormat('yyyy-MM-dd').format(tasksDateKey)



  static const int statusTaskNueva=0;
  static const int statusTaskConcluida=1;
  static const int statusTaskEnProceso=2;
  static const int statusTaskCancelada=3;
  static const int statusTaskEnEspera=4;
  

  static const String fcm_topic_admin = "admin";
  static const String fcm_topic_employee = "employee";

  static const String rol_empleado = "1";
  static const String rol_admin ="0";


  static const int hive_type1 = 1;  
  static const int hive_type2 = 2;

  static const String hive_adapter_name_1 = "NotificationsAdapter";
  static const String hive_adapter_name_2 = "DataAdapter";


  static const String notif_type_insumo = "AppNotificationsInsumoNotification";
  static const String notif_type_tarea_p = "AppNotificationsTareaPersonalNotification";
  static const String notif_type_pedido = "AppNotificationsOrderNotification";

  static const String event_created = "created";
  static const String event_updated = "updated";
  static const String event_updated_to_admin = "updated_to_admin";


  static const String fcm_type_insumo = "Insumo";
  static const String fcm_type_pedido = "Pedido";
  static const String fcm_type_plaga = "Plaga";
  static const String fcm_type_tarea_personal = "TareaPersonal";
  static const String fcm_type_producto ="Producto";
  
}


//[master e933179