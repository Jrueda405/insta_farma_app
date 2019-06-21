
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:insta_farma_app/Objects/Noticia.dart';
import 'package:insta_farma_app/Strings/Strings.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';

class NewsView extends StatefulWidget{

  @override
  _stateNews createState()=> new _stateNews();
}
class _stateNews extends State<NewsView>{

  List<Noticia> noticias;
  bool isLoading=true;
  @override
  void initState() {
    super.initState();
    _fetchNews();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(child: _buildList(),
        bottom: true,
        left: true,
        right: true,
        top: true,),
    );
  }
  Future _fetchNews()async {
    final response =
    await http.get(Strings.url+"/GetNews.php");
    //print('llego: '+response.body);
    if (response.statusCode == 200) {
      List<Noticia> list = (json.decode(response.body) as List)
          .map((data) => new Noticia.fromJson(data))
          .toList();
      if(mounted){
        setState(() {
          isLoading = false;
          noticias=list;
        });
      }else{
        return;
      }

    } else {
      throw Exception('Failed to load Pacs');
    }
    return;

  }
  Widget _buildList(){
    if(isLoading==true){
      return Center(child: CircularProgressIndicator(),);
    }else{
      return ListView.separated(
        separatorBuilder: (context, index)=> Divider(
          color: Colors.black,
        )
        ,shrinkWrap: true,
        itemCount: noticias.length,
        itemBuilder: (BuildContext context, int index) {
          Noticia _current=noticias[index];
          return Card(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
                Image(image: NetworkImage(_current.urlImage),),
                Text(_current.titulo,style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: Colors.black)),
                SizedBox( height: 10,),
                Text(_current.cuerpo,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 18,color: Colors.black)),
                Row(
                  mainAxisSize: MainAxisSize.max,
                  mainAxisAlignment: MainAxisAlignment.end,
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: <Widget>[
                    IconButton( icon: Icon(MdiIcons.web), onPressed: () {
                      _launchURL(_current.urlPage);
                    },),
                  ],
                ),

              ],

            ),
          );
        },

      );
    }

  }

  _launchURL(String url) async {
    if (await canLaunch(url)) {
      await launch(url);
    } else {
      throw 'Could not launch $url';
    }
  }


  @override
  void reassemble() {
    super.reassemble();
  }

  @override
  void dispose() {
    super.dispose();
  }

}