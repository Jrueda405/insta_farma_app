import 'package:flutter/material.dart';
import 'package:insta_farma_app/Objects/Enfermedad.dart';
import 'package:insta_farma_app/Strings/Strings.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';
import 'dart:io';
import 'package:http/http.dart' as http;

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
  //SharedPreferences prefs;
  bool isLoading=false;
  @override
  void initState() {
    super.initState();
    enfermedades_filtradas=new List<Enfermedad>();
    mis_enfermedades=new List<Enfermedad>();
    //listener
    _filter.addListener(() {
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
    });

    this.fetchMisEnfermedades();

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Emfermedades'),),
      body:
      Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(10),child: new TextField(
            controller: _filter,
            decoration: InputDecoration(
                contentPadding: EdgeInsets.fromLTRB(0.0, 15.0, 0.0, 15.0),
                hintText: "Enfermedad",
                prefixIcon: _searchIcon,
                border:
                OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
          ),),
          _buildList(),
        ],
      ),
    );
  }


  @override
  void reassemble() {
    super.reassemble();
  }
  Widget _buildList() {

    if (!(_searchText.isEmpty)) {
      List<Enfermedad> tempList = new List<Enfermedad>();
      for (int i = 0; i < enfermedades_filtradas.length; i++) {
        if (enfermedades_filtradas[i].enfermedad.toString().toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(enfermedades_filtradas[i]);
        }
      }
      enfermedades_filtradas = tempList;
    }else{
      enfermedades_filtradas=new List();
    }
    return ListView.separated(
      separatorBuilder: (context, index)=> Divider(
        color: Colors.black,
      )
      ,itemCount: mis_enfermedades == null ? 0 : enfermedades_filtradas.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        Enfermedad med=enfermedades_filtradas[index];
        return new ListTile(
          title: Padding(padding: EdgeInsets.only(left: 5),child: Text(med.enfermedad,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 24,color: Colors.black)),),
          trailing: Row(
            mainAxisSize: MainAxisSize.min,
            children: <Widget>[
              GestureDetector(
                child: CircleAvatar(
                  foregroundColor: Colors.white,
                  child: Icon(MdiIcons.plus),
                  backgroundColor: Colors.amber,
                ),
                onTap: (){

                },
              )

            ],
          ),

        );
      },
    );
  }
  Future fetchMisEnfermedades() async{
    setState(() {
      isLoading = true;
    });
    final response =
    await http.get(Strings.url+"/GetEnfermedades.php");
    if (response.statusCode == 200) {
      List<Enfermedad> list = (json.decode(response.body) as List)
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