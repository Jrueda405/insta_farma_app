import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:insta_farma_app/Objects/Choice.dart';
import 'package:insta_farma_app/Objects/Medicamento.dart';
import 'package:insta_farma_app/Objects/PrincipioActivo.dart';
import 'package:insta_farma_app/Resources/Colores/Colores.dart';
import 'package:insta_farma_app/Strings/Strings.dart';
import 'package:insta_farma_app/Widgets/LobbyInterface.dart';
import 'package:insta_farma_app/Widgets/MyMedsView.dart';
import 'package:insta_farma_app/Widgets/NewsView.dart';
import 'package:insta_farma_app/Widgets/ViewUserContent.dart';
import 'package:insta_farma_app/Widgets/VistaMedicamentos.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'dart:convert';


const List<Choice> choices = const <Choice>[
  const Choice(title: 'Cerrar Sesión', icon: MdiIcons.logout),

];

class MainContent extends StatefulWidget{
  /*List<Medicamento> my_meds;
  List<Medicamento> medicamentos;
  List<PrincipioActivo> pacs;*/
  int languagePos;
  String idUser;
  MainContent({Key key,@required this.idUser,@required this.languagePos}):super(key:key);
  @override
  _MainContentState createState()=> _MainContentState();
}

class _MainContentState extends State<MainContent> with SingleTickerProviderStateMixin{

  TabController _tabController;
  Widget _appBarTitle = new Text( 'InstaFarma' );
  Choice _selectedChoice = choices[0];
  List<Medicamento> my_meds;
  List<Medicamento> medicamentos;
  List<PrincipioActivo> pacs;
  int languagePos;
  String idUser;
  SharedPreferences prefs;

  ValueListenable<int> number;

  final key = new GlobalKey<_MainContentState>();
  @override
  void initState() {
    super.initState();
    languagePos=widget.languagePos;
    idUser=widget.idUser;
    _tabController = new TabController(vsync: this, length: 3);
  }
  void _select(Choice choice) async{
    setState(() {
      _selectedChoice = choice;
    });
    if(choice==choices[0]){//cerrar sesion
      prefs = await SharedPreferences.getInstance();
      prefs.setBool('isAuth', false);
      prefs.setString('jsonmymeds', null);
      Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => Lobby()));
    }
  }
  @override
  Widget build(BuildContext context) {
    return new Scaffold(
      appBar:(_buildBar(context)),
      body: new TabBarView(
        children: <Widget>[
          MyMedsView(idUser: idUser,key: key,),
          VistaMedicamentos(idUser: idUser,languagePos: languagePos,),
          NewsView(),
        ],
        controller: _tabController,
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
  Widget _buildBar(BuildContext context) {
    return new AppBar(
      title: _appBarTitle,
      backgroundColor: Colores.green1,
      actions: <Widget>[
        GestureDetector(
          child: Icon(MdiIcons.faceProfile),
          onTap: (){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) => ViewUserProfile()),
            );
          },
        ),
        PopupMenuButton<Choice>(
          onSelected: _select,
          initialValue: _selectedChoice,
          itemBuilder: (BuildContext context) {
            return choices.map((Choice choice) {
              return PopupMenuItem<Choice>(
                value: choice,
                child: Text(choice.title),
              );
            }).toList();
          },
        ),

      ],
      bottom: new TabBar(
        indicatorColor: Colors.black,
        tabs: <Tab>[
          new Tab(
            text: "Recipe",
            icon: new Icon(MdiIcons.pill),
          ),
          new Tab(
            text: "Medicamentos",
            icon: Icon(Icons.search),
          ),
          new Tab(
            text: "Noticias",
            icon: new Icon(MdiIcons.newspaper),
          ),
        ],
        controller: _tabController,
      ),
    );
  }
  Future<bool> instantiateShared() async{
    prefs = await SharedPreferences.getInstance();
    return true;
  }
}
