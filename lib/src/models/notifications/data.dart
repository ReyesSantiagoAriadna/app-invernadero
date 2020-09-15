
import 'package:app_invernadero_trabajador/app_config.dart';
import 'package:hive/hive.dart';

part 'data.g.dart';

@HiveType(
  typeId: AppConfig.hive_type2, adapterName: AppConfig.hive_adapter_name_2)


class Data {
    Data({
        this.titulo,
        this.tipo,
        this.mensaje,
        this.id,
    });
    @HiveField(0)
    String titulo;
    @HiveField(1)
    String tipo;
    @HiveField(2)
    String mensaje;
    @HiveField(3)
    int id;

    factory Data.fromJson(Map<String, dynamic> json) => Data(
        titulo: json["titulo"],
        tipo: json["tipo"],
        mensaje: json["mensaje"],
        id: json["id"],
    );

    Map<String, dynamic> toJson() => {
        "titulo": titulo,
        "tipo": tipo,
        "mensaje": mensaje,
        "id": id,
    };
}