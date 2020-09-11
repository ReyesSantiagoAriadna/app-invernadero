// To parse this JSON data, do
//
//     final date = dateFromJson(jsonString);

import 'dart:convert';

Date dateFromJson(String str) => Date.fromJson(json.decode(str));

String dateToJson(Date data) => json.encode(data.toJson());

class Date {
    Date({
        this.date,
    });

    DateTime date;

    factory Date.fromJson(Map<String, dynamic> json) => Date(
        date: DateTime.parse(json["date"]),
    );

    Map<String, dynamic> toJson() => {
        "date": date.toIso8601String(),
    };
}