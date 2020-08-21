
import '../../../app_config.dart';

class Context {
    Context({
        this.id,
        this.text,
        this.wikidata,
        this.shortCode,
    });
    String id;
    String text;
    String wikidata;
    String shortCode;

    factory Context.fromJson(Map<String, dynamic> json) => Context(
        id: json["id"],
        text: json["text"],
        wikidata: json["wikidata"] == null ? null : json["wikidata"],
        shortCode: json["short_code"] == null ? null : json["short_code"],
    );

    Map<String, dynamic> toJson() => {
        "id": id,
        "text": text,
        "wikidata": wikidata == null ? null : wikidata,
        "short_code": shortCode == null ? null : shortCode,
    };
}