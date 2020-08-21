import 'dart:convert';

import 'package:app_invernadero_trabajador/src/models/feature/context_model.dart';
import 'package:app_invernadero_trabajador/src/models/feature/geometry_model.dart';
import 'package:app_invernadero_trabajador/src/models/feature/properties_model.dart';

class Feature {
    Feature({
        this.id,
        this.type,
        this.placeType,
        this.relevance,
        this.properties,
        this.text,
        this.placeName,
        this.center,
        this.geometry,
        this.context,
    });
    String id;
    String type;
    List<String> placeType;
    double relevance;
    Properties properties;
    String text;
    String placeName;
    List<double> center;
    Geometry geometry;
    List<Context> context;

    factory Feature.fromJson(Map<String, dynamic> json) => Feature(
        id: json["id"],
        type: json["type"],
        placeType: List<String>.from(json["place_type"].map((x) => x)),
        relevance: json["relevance"].toDouble(),
        properties: Properties.fromJson(json["properties"]),
        text: json["text"],
        placeName: json["place_name"],
        center: List<double>.from(json["center"].map((x) => x.toDouble())),
        geometry: Geometry.fromJson(json["geometry"]),
        context: json["context"]!=null? List<Context>.from(json["context"].map((x) => Context.fromJson(x))):List<Context>(),
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "type": type,
        "place_type": List<dynamic>.from(placeType.map((x) => x)),
        "relevance": relevance,
        "properties": properties.toJson(),
        "text": text,
        "place_name": placeName,
        "center": List<dynamic>.from(center.map((x) => x)),
        "geometry": geometry.toJson(),
        "context": List<dynamic>.from(context.map((x) => x.toJson())),
    };

  Feature featureFromJson(String str) => Feature.fromJson(json.decode(str));

  String featureToJson(Feature data) => json.encode(data.toJson());
}

