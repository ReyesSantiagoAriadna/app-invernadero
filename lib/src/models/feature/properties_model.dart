

import '../../../app_config.dart';

class Properties {
    Properties({
        this.accuracy,
    });
    String accuracy;

    factory Properties.fromJson(Map<String, dynamic> json) => Properties(
        accuracy: json["accuracy"],
    );

    Map<String, dynamic> toJson() => {
        "accuracy": accuracy,
    };
}