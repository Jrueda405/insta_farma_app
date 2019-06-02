import 'dart:async';
import 'package:flutter/material.dart';
import 'package:permission/permission.dart';
import 'dart:io' show Platform;
import 'package:insta_farma_app/Widgets/MainContent.dart';
import 'package:insta_farma_app/Widgets/LobbyInterface.dart';
import 'package:shared_preferences/shared_preferences.dart';

class MySplashScreen extends StatefulWidget{
  @override
  State<StatefulWidget> createState() {
    return MySplashScreenState();
  }
}

class MySplashScreenState extends State<MySplashScreen> {
  bool isAuth;
  SharedPreferences prefs;
  var isLoading = true;
  int counter;
  String idUser;

  @override
  void initState() {
    super.initState();
    instantiateShared().whenComplete(() {
      loadData();
    });
  }
  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    checPermission().then((status){
      if(status==PermissionStatus.notDecided ||status==PermissionStatus.deny||status==PermissionStatus.notAgain){
        requestPermission();
      }
    });

  }

  requestPermission() async {
    print("requesting permission");
    if (Platform.isAndroid) {
      // Android-specific code
      await Permission.requestPermissions([PermissionName.Microphone]);
    } else if (Platform.isIOS) {
      // iOS-specific code
      await Permission.requestSinglePermission(PermissionName.Microphone);
    }
    //print("permission request result is " + res.toString());
  }

  Future<PermissionStatus> checPermission() async{
    PermissionStatus status;
    print("checking permission");
    if (Platform.isAndroid) {
      print("is android");
      List<Permissions> permissions = await Permission.getPermissionsStatus([PermissionName.Microphone]);
      status=permissions[0].permissionStatus;
      print(status.toString());
    } else if (Platform.isIOS) {
      print("is IOS");
      status = await Permission.getSinglePermissionStatus(PermissionName.Microphone);
    }
    return status;
  }
  Future<bool> instantiateShared() async {
    prefs = await SharedPreferences.getInstance();
    return true;
  }

  Future<Timer> loadData() async {
    int temp;
    if(prefs!=null){
      temp= prefs.getInt('poslanguage') ?? 4;
      print("sacando lenguaje "+temp.toString());
      counter=temp;
      String stemp=prefs.getString('idUser') ?? "";
      idUser=stemp;
      bool btemp=prefs.getBool('isAuth')??false;
      setState(() {
        counter=temp;
        idUser=stemp;
        isAuth=btemp;
      });
    }
    return new Timer(Duration(seconds: 3), onDoneLoading);
  }

  onDoneLoading() async {
    //pacs: pacs,medicamentos: medicamentos,my_meds: my_meds,idUser: idUser,languagePos: counter
    Navigator.of(context).pushReplacement(MaterialPageRoute(
        builder: (context) => (isAuth) ? MainContent(idUser: idUser,languagePos: counter) : Lobby()));
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: new BoxDecoration(
        image: DecorationImage(
            image: AssetImage("assets/images/medicamentos.jpg"),
            fit: BoxFit.cover),
      ),
      child: Center(
        child: RichText(
          text: TextSpan(
            text: 'InstaFarma',
            style: TextStyle(
              color: Colors.red,
              fontSize: 55.0,
              fontWeight: FontWeight.bold,
              fontStyle: FontStyle.italic,
              decoration: TextDecoration.none,
              decorationColor: Colors.yellow,
              decorationStyle: TextDecorationStyle.wavy,
            ),
          ),
        ),
      ),
    );
  }

}
//(isAuth)?Home():Login()