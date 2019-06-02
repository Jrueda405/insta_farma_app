import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:insta_farma_app/Objects/Medicamento.dart';
import 'package:insta_farma_app/Objects/PrincipioActivo.dart';
import 'package:shared_preferences/shared_preferences.dart';


class InformacionMedicamento extends StatefulWidget{

  Medicamento medicamento;
  List<PrincipioActivo> principios;
  InformacionMedicamento({Key key,@required this.medicamento}):super(key:key);
  @override
  _InformacionMedicamentoState createState()=> _InformacionMedicamentoState();
}
class _InformacionMedicamentoState extends State<InformacionMedicamento>{

  Medicamento _medicamento;
  PrincipioActivo _principioActivo;
  List<PrincipioActivo> pacs;
  int index = 0;
  var isLoading = false;
  List<String> _listViewData=new List();
  List<int> iterador=[1,2,3,4,5,6];
  String clasi;
  String meca;
  String indi;
  String contra;
  String adv;
  String efe;


  @override
  void initState() {
    super.initState();
    _medicamento=widget.medicamento;
    _listViewData=_medicamento.Compuestos;
    setState(() {
      isLoading=true;
    });
    getPACSFromShared().whenComplete((){
      int x=pacs.indexWhere((p)=> p.Nombre==_medicamento.Compuestos[index]);
      //print("resultado "+x.toString());
      if(x>=0){//quiere decir que esta
        setState(() {
          _principioActivo=pacs[x];
          clasi=_principioActivo.Clasificacion!=null ?_principioActivo.Clasificacion:"";
          meca=_principioActivo.MecanismoDeAccion!=null? _principioActivo.MecanismoDeAccion:"";
          indi=_principioActivo.Indicaciones!=null?_principioActivo.Indicaciones:"";
          contra=_principioActivo.ContraIndicaciones!=null?_principioActivo.ContraIndicaciones:"";
          adv=_principioActivo.Advertencias!=null?_principioActivo.Advertencias:"";
          efe=_principioActivo.EfectosAsdversos!=null?_principioActivo.EfectosAsdversos:"";
        });
      }else { //no esta
      }
    });
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: new AppBar(
        title: Text(_medicamento.Nombre),
      ),
      body:  LayoutBuilder(
        builder:
            (BuildContext context, BoxConstraints viewportConstraints) {
          return ListView(
            padding: EdgeInsets.all(8.0),
            children:
            getLista().map((expansionTile) => expansionTile).toList(),
          );
        },
      ),
      resizeToAvoidBottomPadding: true,
    );

  }


  @override
  void dispose() {
    super.dispose();
  }

  @override
  void reassemble() {
    super.reassemble();
  }

  Future getPACSFromShared() async{
    setState(() {
      isLoading = true;
    });
    final String membershipKey = 'jsonpacs';
    SharedPreferences sp = await SharedPreferences.getInstance();
    List<PrincipioActivo> temp_list=new List<PrincipioActivo>();
    json
        .decode(sp.getString(membershipKey))
        .forEach((map) => temp_list.add(new PrincipioActivo.fromJson(map)));
    setState(() {
      pacs=temp_list;
    });
  }

  List<ExpansionTile> getLista(){

    List<ExpansionTile> _listOfExpansions=[
      ExpansionTile(
        title: Text(
            "Compuestos",
            textAlign: TextAlign.justify,
            style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black)
        ),
        children: _listViewData
            .map((data) => ListTile(
          onTap: (){
            setState(() {
              var x=pacs.indexWhere((p)=> p.Nombre==_medicamento.Compuestos[index]);
              //print('x: '+x.toString());
              if(x>0){
                _principioActivo=pacs[x];
                clasi=_principioActivo.Clasificacion!=null ?_principioActivo.Clasificacion:"";
                meca=_principioActivo.MecanismoDeAccion!=null? _principioActivo.MecanismoDeAccion:"";
                indi=_principioActivo.Indicaciones!=null?_principioActivo.Indicaciones:"";
                contra=_principioActivo.ContraIndicaciones!=null?_principioActivo.ContraIndicaciones:"";
                adv=_principioActivo.Advertencias!=null?_principioActivo.Advertencias:"";
                efe=_principioActivo.EfectosAsdversos!=null?_principioActivo.EfectosAsdversos:"";
              }
              // _principioActivo=pacs[index];
            });
          },
          leading:  CircleAvatar(
            foregroundColor: Colors.white,
            child: new Text((_listViewData.indexOf(data)+1).toString()),
            backgroundColor: Colors.blueGrey,
          ),
          title: Text(data),
        ))
            .toList(),
      ),

      ExpansionTile(
        title: Text(
            "Clasificacion",
            textAlign: TextAlign.justify,
            style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black)
        ),
        children: <Widget>[
          Text(
              clasi,
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black)
          ),
        ],
      ),

      ExpansionTile(
        title: Text(
            "Mecanismo de accion",
            textAlign: TextAlign.justify,
            style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black)
        ),
        children: <Widget>[
          Text(
              meca,
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black)
          ),
        ],
      ),
      ExpansionTile(
        title: Text(
            "Indicaciones",
            textAlign: TextAlign.justify,
            style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black)
        ),
        children: <Widget>[
          Text(
              indi,
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black)
          ),
        ],
      ),
      ExpansionTile(
        title: Text(
            "Contraindicaciones",
            textAlign: TextAlign.justify,
            style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black)
        ),
        children: <Widget>[
          Text(
              contra,
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black)
          ),
        ],
      ),
      ExpansionTile(
        title: Text(
            "Advertencias",
            textAlign: TextAlign.justify,
            style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black)
        ),
        children: <Widget>[
          Text(
              adv,
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black)
          ),
        ],
      ),
      ExpansionTile(
        title: Text(
            "Efectos adversos",
            textAlign: TextAlign.justify,
            style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black)
        ),
        children: <Widget>[
          Text(
              efe,
              textAlign: TextAlign.justify,
              style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black)
          ),
        ],
      ),
    ];
    return _listOfExpansions;
  }

}

