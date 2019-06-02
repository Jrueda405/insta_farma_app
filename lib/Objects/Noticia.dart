import 'package:insta_farma_app/Objects/PrincipioActivo.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:async';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
part 'Noticia.g.dart';

@JsonSerializable()

class Noticia{
  String titulo;
  String cuerpo;
  String urlImage;
  String urlPage;


  Noticia(this.titulo, this.cuerpo, this.urlImage, this.urlPage);

  factory Noticia.fromJson(Map<String,dynamic> json)=> _$NoticiaFromJson(json);
  Map<String, dynamic> toJson()=> _$NoticiaToJson(this);

}