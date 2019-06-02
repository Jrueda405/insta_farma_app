// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'PrincipioActivo.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

PrincipioActivo _$PrincipioActivoFromJson(Map<String, dynamic> json) {
  return PrincipioActivo(
      Nombre: json['Nombre'] as String,
      MecanismoDeAccion: json['MecanismoDeAccion'] as String,
      Clasificacion: json['Clasificacion'] as String,
      Advertencias: json['Advertencias'] as String,
      EfectosAsdversos: json['EfectosAsdversos'] as String,
      Indicaciones: json['Indicaciones'] as String,
      ContraIndicaciones: json['ContraIndicaciones'] as String,
      Interacciones: json['Interacciones'] as String);
}

Map<String, dynamic> _$PrincipioActivoToJson(PrincipioActivo instance) =>
    <String, dynamic>{
      'Nombre': instance.Nombre,
      'MecanismoDeAccion': instance.MecanismoDeAccion,
      'Clasificacion': instance.Clasificacion,
      'Advertencias': instance.Advertencias,
      'EfectosAsdversos': instance.EfectosAsdversos,
      'Indicaciones': instance.Indicaciones,
      'ContraIndicaciones': instance.ContraIndicaciones,
      'Interacciones': instance.Interacciones
    };
