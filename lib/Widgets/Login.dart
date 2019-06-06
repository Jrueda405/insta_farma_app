import 'dart:io';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insta_farma_app/Objects/Medicamento.dart';
import 'package:insta_farma_app/Resources/Colores/Colores.dart';
import 'package:insta_farma_app/Strings/Strings.dart';
import 'package:insta_farma_app/Widgets/MainContent.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Login extends StatefulWidget{

  //Login({Key key,@required this.medicamentos});
  @override
  _loginState createState()=> new _loginState();
}
class _loginState extends State<Login> with TickerProviderStateMixin{
  AnimationController _loginButtonController;
  var animationStatus = 0;
  bool signed_up=false;
  final control_user = TextEditingController();
  final control_password = TextEditingController();
  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black);
  SharedPreferences prefs;
  String _username;
  String _id="00000000000000000000";
  int indexlang=0;
  @override
  void initState() {
    super.initState();
    instantiateShared().whenComplete((){
      indexlang= prefs.getInt('poslanguage') ?? 4;
    });
    //print(widget.medicamentos.length);
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final emailField = TextField(
      obscureText: false,
      controller: control_user,
      style: style,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Nombre de usuario",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      style: style,
      controller: control_password,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Clave",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final loginButon = Material(
      elevation: 5.0,
      shadowColor: Colors.white,
      borderRadius: BorderRadius.circular(30.0),
      color: Colores.green1,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          num codigo=num.tryParse(control_user.text);
          if(codigo==null){
            validateUserWithUsername(control_user.text,control_password.text).then((v){
              if(v==true){
                prefs.setString('idUser', _id);
                prefs.setString('username', control_user.text);
                prefs.setString('password', control_password.text);
                prefs.setBool('isAuth', true);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainContent(idUser: _id,languagePos: indexlang)));
              }else{
                Fluttertoast.showToast(
                    msg: "Datos erroneos",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            }
            );
          }else{
            validateUserWithId(control_user.text,control_password.text).then((v){
              if(v==true){
                prefs.setString('idUser', control_user.text);
                prefs.setString('username', _username);
                prefs.setString('password', control_password.text);
                prefs.setBool('isAuth', true);
                Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainContent(idUser: control_user.text,languagePos: indexlang)));
              }else{
                Fluttertoast.showToast(
                    msg: "Datos erroneos",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }
            }
            );
          }

        },
        child: Text("Login",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
      ),
    );
    return Scaffold(
      body: Center(
        child: Container(
            decoration: BoxDecoration(
                color: Color.fromRGBO(255, 255, 255, 0.5),
            ),
          child: Container(
            child: Padding(
              padding: const EdgeInsets.all(30.0),
              child: ListView(
                children: <Widget>[
                  SizedBox(
                    height: 155.0,
                  ),
                  SizedBox(height: 45.0),
                  emailField,
                  SizedBox(height: 25.0),
                  passwordField,
                  SizedBox(
                    height: 35.0,
                  ),
                  loginButon,
                  SizedBox(
                    height: 15.0,
                  ),
                ],
              ),
            ),
          )
        ),
      ),
      resizeToAvoidBottomPadding: true,
    );
  }

  Future<bool> validateUserWithId(String idUser,String clave) async{
    Map<String, dynamic> body = {
      'id': idUser,
      'clave':clave,
    };

    int start=(_id.length)-(idUser.length);
    int end=_id.length;
    _id=_id.replaceRange(start, end, idUser);
    Response response = await Dio().post(Strings.url+"/ValidateUser.php",data:body, options: new Options(contentType:ContentType.parse("application/x-www-form-urlencoded")));
    if(response.statusCode==200){
      //print(response.data);
      if(response.data.toString().contains('OK')){
        String temp=response.data.toString().split(':')[1];
        //print("var temp"+temp);
        setState(() {
          _username=temp;
        });
        return true;
      }else{
        return false;
      }
    }else{return false;}
  }

  Future<bool> validateUserWithUsername(String idUser,String clave) async{
    Map<String, dynamic> body = {
      'username': idUser,
      'clave':clave,
    };
    Response response = await Dio().post(Strings.url+"/ValidateUsername.php",data:body, options: new Options(contentType:ContentType.parse("application/x-www-form-urlencoded")));
    if(response.statusCode==200){
      //print(response.data);
      if(response.data.toString().contains('OK')){
        String temp=response.data.toString().split(':')[1];
        setState(() {
          _id=temp;
        });
        return true;
      }else{
        return false;
      }
    }else{return false;}
  }

  @override
  void dispose() {
    _loginButtonController.dispose();
    control_user.dispose();
    control_password.dispose();
    super.dispose();
  }
  Future<bool> instantiateShared() async{
    prefs = await SharedPreferences.getInstance();
    return true;
  }
}