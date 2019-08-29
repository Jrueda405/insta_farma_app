import 'package:flutter/material.dart';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:insta_farma_app/Resources/Colores/Colores.dart';
import 'package:insta_farma_app/Strings/Strings.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:fluttertoast/fluttertoast.dart';

class ChangePassword extends StatefulWidget {
  @override
  ChangePasswordState createState() => ChangePasswordState();
}

class ChangePasswordState extends State<ChangePassword> {
  final TextStyle style =
      TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black);
  SharedPreferences prefs;
  String idUser;
  final control_password1 = TextEditingController();
  final control_password2 = TextEditingController();
  final control_password3 = TextEditingController();

  @override
  void initState() {
    instantiateShared().whenComplete(() {
      setState(() {
        idUser = prefs.getString('idUser');
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final lastPassword = TextField(
      obscureText: true,
      controller: control_password1,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Clave anterior",
          hintStyle: TextStyle(),
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );
    final newPassword = TextField(
      obscureText: true,
      controller: control_password2,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Nueva clave",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final passwordField2 = TextField(
      obscureText: true,
      controller: control_password3,
      decoration: InputDecoration(
          contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
          hintText: "Confirme nueva clave",
          border:
              OutlineInputBorder(borderRadius: BorderRadius.circular(32.0))),
    );

    final ChangeButton = Material(
      elevation: 5.0,
      borderRadius: BorderRadius.circular(30.0),
      color: Colores.green1,
      child: MaterialButton(
        minWidth: MediaQuery.of(context).size.width,
        padding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
        onPressed: () {
          if (control_password2.text.isNotEmpty &&
              control_password3.text.isNotEmpty) {
            if (control_password2.text.compareTo(control_password3.text) == 0) {
              sendChanges(control_password1.text, control_password2.text);
            } else {
              Fluttertoast.showToast(
                  msg: "Las nuevas claves no coinciden",
                  toastLength: Toast.LENGTH_SHORT,
                  gravity: ToastGravity.BOTTOM,
                  timeInSecForIos: 1,
                  backgroundColor: Colors.black,
                  textColor: Colors.white,
                  fontSize: 16.0);
            }
          }
        },
        child: Text("Cambiar clave",
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
                lastPassword,
                SizedBox(
                  height: 25.0,
                ),
                newPassword,
                SizedBox(
                  height: 25.0,
                ),
                passwordField2,
                SizedBox(
                  height: 25.0,
                ),
                ChangeButton
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

  Future<bool> sendChanges(String claveVieja, String claveNueva) async {
    Map<String, dynamic> body = {
      'id': idUser,
      'oldpass': claveVieja,
      'newpass': claveNueva,
    };
    Response response = await Dio().post(Strings.url + "/CambiarClave.php",
        data: body,
        options: new Options(
            contentType:
                ContentType.parse("application/x-www-form-urlencoded")));
    if (response.statusCode == 200) {
      print(response.data);
      if (response.data.toString().compareTo("Se ha actualizado la clave") ==
          0) {
        prefs.setString("password", claveNueva);
      }
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
