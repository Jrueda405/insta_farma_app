import 'package:flutter/material.dart';
import 'package:insta_farma_app/Resources/Colores/Colores.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:insta_farma_app/Strings/Strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class RetrievePassword extends StatefulWidget {
  @override
  RetrievePasswordState createState() => new RetrievePasswordState();
}

class RetrievePasswordState extends State<RetrievePassword> {
  final TextStyle style =
  TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black);
  SharedPreferences prefs;
  String idUser;
  final control_email = TextEditingController();

  @override
  void initState() {
    super.initState();
    instantiateShared().whenComplete(() {
      setState(() {
        idUser = prefs.getString('idUser');
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    final email = TextField(
      obscureText: false,
      controller: control_email,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Email",
          hintStyle: TextStyle(),
          border:
          OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );


    final sendEmail = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colores.green1,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          _sendEmail(control_email.text);
        },
        child: Text("Enviar clave",
            textAlign: TextAlign.center,
            style: style.copyWith(
                color: Colors.white, fontWeight: FontWeight.bold)),
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
                email,
                SizedBox(
                  height: 25.0,
                ),
                sendEmail
              ],
            ),
          ),
        ),
      ),
      resizeToAvoidBottomPadding: true,
    );
  }

  @override
  void dispose() {
    super.dispose();
  }

  Future<bool> _sendEmail(String email) async {
    Map<String, dynamic> body = {
      'email': email,
    };
    Response response = await Dio().post(Strings.url + "/RetrievePassword.php",
        data: body,
        options: new Options(
            contentType:
            ContentType.parse("application/x-www-form-urlencoded")));
    if (response.statusCode == 200) {
      //print(response.data);
      Fluttertoast.showToast(
          msg: response.data,
          toastLength: Toast.LENGTH_SHORT,
          gravity: ToastGravity.BOTTOM,
          timeInSecForIos: 1,
          backgroundColor: Colors.black,
          textColor: Colors.white,
          fontSize: 16.0);
    }
  }

  Future<bool> instantiateShared() async {
    prefs = await SharedPreferences.getInstance();
    return true;
  }
}

