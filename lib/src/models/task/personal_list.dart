import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/task/tarea_date_mode.dart';

PersonalList PersonalListFromJson(String str) => PersonalList.fromJson(json.decode(str));

String PersonalListToJson(PersonalList data) => json.encode(data.toJson());

class PersonalList {
    PersonalList({
        this.personal,
    });

    List<Personal> personal;
    
    factory PersonalList.fromJson(Map<String, dynamic> json) => PersonalList(
        personal: List<Personal>.from(json["personal"].map((x) => Personal.fromJson(x))),
    );

    Map<String, dynamic> toJson() => {
        "personal": List<dynamic>.from(personal.map((x) => x.toJson())),
    };
}