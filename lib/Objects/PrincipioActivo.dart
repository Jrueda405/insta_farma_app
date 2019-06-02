import 'package:json_annotation/json_annotation.dart';
import 'dart:async';
import 'dart:convert';
part 'PrincipioActivo.g.dart';
@JsonSerializable()
class PrincipioActivo{
  String Nombre;
  String MecanismoDeAccion;
  String Clasificacion;
  String Advertencias;
  String EfectosAsdversos;
  String Indicaciones;
  String ContraIndicaciones;
  String Interacciones;

  PrincipioActivo({this.Nombre, this.MecanismoDeAccion, this.Clasificacion,
      this.Advertencias, this.EfectosAsdversos, this.Indicaciones,
      this.ContraIndicaciones, this.Interacciones});

  PrincipioActivo.Constructor(String nombre){
    this.Nombre=nombre;
    this.MecanismoDeAccion="";
    this.Clasificacion="";
    this.Advertencias="";
    this.EfectosAsdversos="";
    this.Indicaciones="";
    this.ContraIndicaciones="";
    this.Interacciones="";
  }

  factory PrincipioActivo.fromJson(Map<String, dynamic> json) => _$PrincipioActivoFromJson(json);

  Map<String, dynamic> toJson() => _$PrincipioActivoToJson(this);

  static bool determniarInteraccion(PrincipioActivo p1, PrincipioActivo p2){
    bool interac=false;
    var interacciones = p2.Interacciones;
    var nombre=p1.Nombre;
    String argument=r''+nombre;
    //print(argument);
    RegExp exp = new RegExp(argument,caseSensitive: false,);
    if(exp.hasMatch(interacciones)==true){
      interac=true;
      return interac;
    }else{
      //print("no match");
    }
    return interac;
  }

}