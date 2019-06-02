import 'package:json_annotation/json_annotation.dart';

part 'Enfermedad.g.dart';
@JsonSerializable()
class Enfermedad{
  String idEnfermedad;
  String enfermedad;

  Enfermedad(this.idEnfermedad, this.enfermedad);
  factory Enfermedad.fromJson(Map<String, dynamic> json) => _$EnfermedadFromJson(json);
  Map<String, dynamic> toJson() => _$EnfermedadToJson(this);

}