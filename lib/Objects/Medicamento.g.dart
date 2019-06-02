// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Medicamento.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Medicamento _$MedicamentoFromJson(Map<String, dynamic> json) {
  return Medicamento(
      json['Nombre'] as String,
      json['Presentacion'] as String,
      json['Codigo'] as String,
      (json['Compuestos'] as List)?.map((e) => e as String)?.toList());
}

Map<String, dynamic> _$MedicamentoToJson(Medicamento instance) =>
    <String, dynamic>{
      'Nombre': instance.Nombre,
      'Presentacion': instance.Presentacion,
      'Codigo': instance.Codigo,
      'Compuestos': instance.Compuestos
    };
