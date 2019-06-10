import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:insta_farma_app/Objects/Enfermedad.dart';
import 'package:insta_farma_app/Strings/Strings.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:convert';
import 'dart:io';

import 'package:shared_preferences/shared_preferences.dart';


class Enfermedades extends StatefulWidget{

  @override
  EnfermedadesState createState() => new EnfermedadesState();

}

class EnfermedadesState extends State<Enfermedades>{
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  Widget _searchIcon = new GestureDetector(child:new Icon(Icons.search));

  List<Enfermedad> enfermedades_filtradas;
  List<Enfermedad> mis_enfermedades;
  SharedPreferences prefs;
  bool isLoading=true;
  String idUser;
  @override
  void initState() {
    super.initState();
    mis_enfermedades=new List<Enfermedad>();
    //listener
    /*_filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          //print('vacia');
          _searchIcon = new GestureDetector(child:new Icon(Icons.search));
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          //print(_searchText);
          _searchIcon = new GestureDetector(child:new Icon(Icons.cancel),onTap: (){
            _searchText = _filter.text;
            _filter.clear();
            _searchText='';
            _searchIcon = new GestureDetector(child:new Icon(Icons.search));
          } ,);
        });
      }
    });*/
    instantiateShared().whenComplete((){
      setState(() {
        idUser=prefs.getString('idUser') ?? "";
      });
      this.fetchMisEnfermedades();
    });


  }
  Future<bool> instantiateShared() async{
    prefs = await SharedPreferences.getInstance();
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Emfermedades'),),
      body: !isLoading? Column(
        children: <Widget>[
          _buildList()
        ],
      ):
      Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          Center(child: CircularProgressIndicator(),)
        ],
      ),
    );
  }


  @override
  void reassemble() {
    super.reassemble();
  }
  Widget _buildList() {
    return ListView.separated(
      separatorBuilder: (context, index)=> Divider(
        color: Colors.black,
      )
      ,itemCount: mis_enfermedades.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        Enfermedad enfermedad=mis_enfermedades[index];
        return new ListTile(
          title: Padding(padding: EdgeInsets.only(left: 5),child: Text(enfermedad.nombre,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 24,color: Colors.black)),),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[

            ],
          ),

        );
      },
    );
  }
  Future fetchMisEnfermedades() async{
    Map<String, dynamic> body = {
      'id': idUser,
    };
    Response response = await Dio().post(Strings.url+"/GetEnfermedades.php",data:body, options: new Options(contentType:ContentType.parse("application/x-www-form-urlencoded")));
    print("llego enfermedad: "+response.data);
    if (response.statusCode == 200) {
      List<Enfermedad> list = (json.decode(response.data) as List)
          .map((data) => new Enfermedad.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
        mis_enfermedades=list;
      });
    } else {
      throw Exception('Failed to load enfermedades');
    }
    return;

  }
  /**
   * Padding(
      padding: EdgeInsets.all(10),
      child: GridView.count(
      childAspectRatio: (4 / 2),
      crossAxisCount: 3,
      physics: ScrollPhysics(), // to disable GridView's scrolling
      shrinkWrap: true,
      children: mis_enfermedades.map((str) => Padding(padding: EdgeInsets.all(5),child:  Container(
      height: 1,
      color: Colors.blue[200],
      child: Center(child: Text(str.enfermedad,style: TextStyle(color: Colors.white),),),
      ),)).toList(),
      ),
      ),
   * */

/**
 * !_status?
    Column(
    children: <Widget>[
    Padding(padding: EdgeInsets.all(10),child: new TextField(
    controller: _filter,
    decoration: InputDecoration(
    contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
    hintText: "Nombre del medicamento",
    prefixIcon: _searchIcon,
    border:
    OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
    ),),
    _buildList(),
    ],
    )
    :new Container(),
 * */
}