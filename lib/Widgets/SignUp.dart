import 'package:flutter/material.dart';
import 'dart:async';
import 'package:flutter/services.dart';
import 'package:flutter/scheduler.dart' show timeDilation;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:insta_farma_app/Resources/Colores/Colores.dart';
import 'package:insta_farma_app/Strings/Strings.dart';
import 'dart:io';
import 'package:flutter_calendar/flutter_calendar.dart';
import 'package:insta_farma_app/Widgets/MainContent.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';

class SignUp extends StatefulWidget{
  @override
  _signUpState createState()=> new _signUpState();
}
class _signUpState extends State<SignUp> with TickerProviderStateMixin{
  AnimationController _loginButtonController;
  var animationStatus = 0;
  bool signed_up=false;
  final control_user = TextEditingController();
  final control_password = TextEditingController();

  String dropdownValue = 'Masculino';
  String _language= 'Español';
  List<String> lista_lang=['Francais','English','Pусский','Italiano','Español'];
  int _poslang= -1;

  DateTime selectedDate;
  String dateString="";
  String _id;
  SharedPreferences prefs;

  final TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black);
  @override
  void initState() {
    super.initState();
    instantiateShared();
    _loginButtonController = new AnimationController(
        duration: new Duration(milliseconds: 3000), vsync: this);
  }
  Future<Null> _playAnimation() async {
    try {
      await _loginButtonController.forward();
      await _loginButtonController.reverse();
    } on TickerCanceled {}
  }
  Future<String> RegisterUser(String username,String clave) async{
    Map<String, dynamic> body = {
      'username': username,
      'fecha': dateString,
      'language':_poslang,
      'genero':dropdownValue,
    };
    Response response = await Dio().post(Strings.url+"/RegistrarUsuario.php",data:body, options: new Options(contentType:ContentType.parse("application/x-www-form-urlencoded")));
    if(response.statusCode==200){
      //print(response.data);
      return response.data;
    }else{
      return "SEOMTHING WENT WRONG";
    }
  }

  @override
  Widget build(BuildContext context) {
    timeDilation = 0.4;
    SystemChrome.setSystemUIOverlayStyle(SystemUiOverlayStyle.light);
    final emailField = TextField(
      obscureText: false,
      controller: control_user,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Nombre de usuario",
          hintStyle: TextStyle(),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final passwordField = TextField(
      obscureText: true,
      controller: control_password,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Clave",
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final signUpButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colores.green1,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () async {
          if(selectedDate==null || control_user.text.isEmpty){
            if(selectedDate==null){
              Fluttertoast.showToast(
                  msg: "Seleccione fecha de nacimiento",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
            if(control_user.text.isEmpty){
              Fluttertoast.showToast(
                  msg: "Ingrese nombre de usuario",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }else{
            RegisterUser(control_user.text, control_password.text).then((s){
              if(s!='EXISTS'){
                if(s!="SOMETHING WENT WRONG"){//es el id
                  prefs.setString('idUser', s);
                  prefs.setString('username', control_user.text);
                  prefs.setString('password', control_password.text);
                  prefs.setBool('isAuth', true);
                  Navigator.of(context).pushReplacement(MaterialPageRoute(builder: (context) => MainContent(idUser: s,languagePos: null,)));
                }else{
                  Fluttertoast.showToast(
                      msg: "Error",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }

              }else{
                Fluttertoast.showToast(
                    msg: "El usuario ya se encuentra registrado",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }

            });

          }

        },
        child: Text("Registrar",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)
            ),
      ),
    );
    return Scaffold(
      body: Center(
        child: SingleChildScrollView(
        child: Container(
          padding: EdgeInsets.fromLTRB(15, 0, 10, 15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: MainAxisSize.max,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
              SizedBox(
                height: 10.0,
              ),
              SizedBox(height: 45.0),
              emailField,
              SizedBox(height: 25.0),
              passwordField,
              SizedBox(
                height: 25.0,
              ),
            Material(
              elevation: 5.0,
              color: Colors.amber,
              borderRadius: BorderRadius.circular(30.0),
              child: MaterialButton(
                child: Text("Fecha de nacimiento",
                    textAlign: TextAlign.center,
                    style: style.copyWith(
                        color: Colors.white, fontWeight: FontWeight.bold)
                ),
                onPressed: (){
                  _selectDate(context).then((date){
                    if (date != null && date != selectedDate)
                      setState(() {
                        selectedDate = date;
                        dateString=DateFormat("yyy-MM-dd").format(selectedDate).toString();
                      });
                  });
                },
              ),
            ),

              SizedBox(
                height: 15.0,
              ),
              Column(
                mainAxisSize: MainAxisSize.max,
                mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
                children: <Widget>[
                  Text('Selecciona el lenguaje para poder enterdernos'),
                  DropdownButton<String>(
                    value: _language,
                    onChanged: (String newValue){
                      setState(() {
                        _language=newValue;
                        _poslang=lista_lang.indexOf(_language);
                      });
                    },
                    items: lista_lang.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                  Text('Selecciona el género'),
                  DropdownButton<String>(
                    value: dropdownValue,
                    hint: Text('Género'),
                    onChanged: (String newValue) {
                      setState(() {
                        dropdownValue = newValue;
                      });
                    },
                    items: <String>[ 'Masculino', 'Femenino', 'Otro']
                        .map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                  ),
                ],
              ),
              SizedBox(
                height: 15.0,
              ),
              signUpButton,

            ],
          ),
        ),

        ),
      ),
      resizeToAvoidBottomPadding: true,
    );
  }
  Future<bool> instantiateShared() async{
    prefs = await SharedPreferences.getInstance();
    return true;
  }
  Future<DateTime> _selectDate(BuildContext context) async {
    final DateTime picked = await showDatePicker(
        context: context,
        initialDate: DateTime(1979,12),
        firstDate: DateTime(1800, 8),
        lastDate: DateTime(2101));
    return picked;
  }
  @override
  void dispose() {
    _loginButtonController.dispose();
    control_password.dispose();
    control_user.dispose();
    super.dispose();
  }
}