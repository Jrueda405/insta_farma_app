import 'package:insta_farma_app/Objects/PrincipioActivo.dart';
import 'package:json_annotation/json_annotation.dart';
import 'dart:async';
import 'dart:convert';

part 'Medicamento.g.dart';
@JsonSerializable()

class Medicamento{
  String Nombre;
  String Presentacion;
  String Codigo;
  List<String> Compuestos;


  Medicamento(this.Nombre, this.Presentacion, this.Codigo, this.Compuestos);

  factory Medicamento.fromJson(Map<String,dynamic> json)=> _$MedicamentoFromJson(json);

  Map<String, dynamic> toJson()=> _$MedicamentoToJson(this);

  static bool validarInteraccionMedicamentosa(Medicamento m1, Medicamento m2, List<PrincipioActivo> pac_list){
    bool interact=false;
    List<String> pacs1=m1.Compuestos;
    for(int i=0;i<pacs1.length;i++){
      String pacName1=pacs1[i];
      PrincipioActivo pac1;
      if(pac_list.indexWhere((p)=> p.Nombre==pacName1)>=0){
        pac1=pac_list[pac_list.indexWhere((p)=> p.Nombre==pacName1)];
      }else{
        continue;
      }
      List<String> pacs2=m2.Compuestos;
      for(int j=0;j<pacs2.length;j++){
        String pacName2=pacs2[j];
        if(pac_list.indexWhere((p)=> p.Nombre==pacName2)>=0){
          PrincipioActivo pac2=pac_list[pac_list.indexWhere((p)=> p.Nombre==pacName2)];
          if(PrincipioActivo.determniarInteraccion(pac1, pac2)==true){
            interact=true;
            return interact;
          }
        }else{
          continue;
        }
      }
    }
    return interact;
  }

}
