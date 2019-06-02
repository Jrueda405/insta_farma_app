// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'Noticia.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

Noticia _$NoticiaFromJson(Map<String, dynamic> json) {
  return Noticia(json['titulo'] as String, json['cuerpo'] as String,
      json['urlImage'] as String,json['urlPage'] as String);
}

Map<String, dynamic> _$NoticiaToJson(Noticia instance) => <String, dynamic>{
      'titulo': instance.titulo,
      'cuerpo': instance.cuerpo,
      'urlImage': instance.urlImage,
      'urlPage': instance.urlPage,
    };
