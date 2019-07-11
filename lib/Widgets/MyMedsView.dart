import 'dart:async';
import 'dart:convert';
import 'dart:io';
import 'package:barcode_scan/barcode_scan.dart';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_farma_app/Objects/Medicamento.dart';
import 'package:insta_farma_app/Objects/PrincipioActivo.dart';
import 'package:insta_farma_app/Strings/Strings.dart';
import 'package:insta_farma_app/Widgets/InformacionMedicamento.dart';
import 'package:insta_farma_app/Widgets/Notice.dart';
import 'package:http/http.dart' as http;
import 'package:fluttertoast/fluttertoast.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:dio/dio.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shake/shake.dart';


class MyMedsView extends StatefulWidget{
  /*
  List<Medicamento> my_meds;
  List<Medicamento> medicamentos;
  List<PrincipioActivo> pacs;
  int languagePos;*/
  bool showIcon;
  String idUser;

  //MyMedsView({Key key,@required this.pacs,@required this.medicamentos,@required this.my_meds,@required this.idUser,@required this.languagePos}):super(key:key);
  MyMedsView({Key key,@required this.idUser}):super(key:key);
  @override
  _MyMedsViewState createState()=>_MyMedsViewState();

}
class _MyMedsViewState extends State<MyMedsView> with AutomaticKeepAliveClientMixin<MyMedsView>{
  String barcode = "";
  SharedPreferences prefs;
  bool isOnline;
  var subscription;

  List<Medicamento> my_meds;
  List<Medicamento> medicamentos;
  List<PrincipioActivo> pacs;
  //ScrollController controlsito;
  String idUser;
  bool showFab=false;
  bool isLoading=true;
  final number = new ValueNotifier(0);
  ShakeDetector detector;
  bool didShow=false;
  bool _recordaragitar=true;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    showFab=false;
    idUser=widget.idUser;
    check();
    subscription = Connectivity().onConnectivityChanged.listen((ConnectivityResult result) {
      if (result == ConnectivityResult.mobile) {
        setState(() {
          isOnline=true;
        });
      } else if (result == ConnectivityResult.wifi) {
        setState(() {
          isOnline=true;
        });
      }else if(result==ConnectivityResult.none){
        setState(() {
          isOnline=false;
        });
      }

    });
    this.instantiateShared().whenComplete((){
      getPACSFromShared().whenComplete((){
        if(pacs==null || pacs.length<1){
          fetchPacs();
        }
      });
      this.getMyMedsFromShared().whenComplete((){
        if(my_meds==null || my_meds.length<1){
          fetchMeds(idUser);
        }
      });
      setState(() {
        _recordaragitar=prefs.getBool('recordar_agitar')??true;
      });
    });
    detector = ShakeDetector.waitForStart(
        onPhoneShake: () {
          if(didShow==false){
            IterateOverMedsArray().then((e){
              if(e==true){
                navigate_2Notice();
              }
            });
          }

        }
    );

    detector.startListening();
  }
  void showToast(){
    Fluttertoast.showToast(
        msg: "Agita el dispositivo para comprobar si hay interaccion",
        toastLength: Toast.LENGTH_SHORT,
        gravity: ToastGravity.BOTTOM,
        timeInSecForIos: 1,
        backgroundColor: Colors.black,
        textColor: Colors.white,
        fontSize: 16.0);
  }
  Future fetchMeds(String idUser) async {
    setState(() {
      isLoading = true;
    });
    Map<String, String> body = {
      'id': idUser,
    };
    Response response = await Dio().post(Strings.url+"/GetMyMeds.php",data:body, options: new Options(contentType:ContentType.parse("application/x-www-form-urlencoded")));
    if (response.statusCode == 200) {
      List<Medicamento> list = (json.decode(response.data) as List)
          .map((data) => new Medicamento.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
        my_meds=list;
      });
      persist_my_meds();

    } else {
      throw Exception('Failed to load Meds');
    }
    return;
  }
  Future fetchPacs() async {
    setState(() {
      isLoading = true;
    });
    final response =
    await http.get(Strings.url+"/GetPacs.php");
    print('llego: '+response.body);
    if (response.statusCode == 200) {
      List<PrincipioActivo> list = (json.decode(response.body) as List)
          .map((data) => new PrincipioActivo.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
        pacs=list;
      });
      persist_paclist();
    } else {
      throw Exception('Failed to load Pacs');
    }
    return;
  }
  Future<Null> getMyMedsFromShared() async{
    print("Obteniendo my meds");
    setState(() {
      isLoading = true;
    });
    final String membershipKey = 'jsonmymeds';
    List<Medicamento> temp_list=new List<Medicamento>();
    String valueStored=prefs.getString(membershipKey)?? "";
    if(valueStored!=''){
      json
          .decode(valueStored)
          .forEach((map){
        temp_list.add(new Medicamento.fromJson(map));
      });
      setState(() {
        my_meds=temp_list;
        isLoading = false;
      });
    }
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    if(_recordaragitar==true){
      showToast();
    }
  }

  void persist_my_meds() async{
    final String membershipKey = 'jsonmymeds';
    await prefs.setString(membershipKey, json.encode(my_meds));
  }
  void persist_paclist() async{
    final String membershipKey = 'jsonpacs'; // maybe use your domain + appname
    print('Se estan guardando los pacs');
    await prefs.setString(membershipKey, json.encode(pacs));
  }

  Future removeMed(String idUser,idMed) async{
    Map<String, dynamic> body = {
      'idUser': idUser,
      'codMed': idMed,
    };
    Response response = await Dio().post(Strings.url+"/RemoveMyMed.php",data:body, options: new Options(contentType:ContentType.parse("application/x-www-form-urlencoded")));
    if(response.statusCode==200){
      //print(response.data);
    }
  }
  Future<bool> instantiateShared() async{
    prefs = await SharedPreferences.getInstance();
    return true;
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: !isLoading?Column(
            children: <Widget>[
              new Expanded(child: _buildList(),
                flex:10,
              ),
            ],
          ): CircularProgressIndicator(),
        ),
        bottom: true,
        left: true,
        right: true,
        top: true,
      ),
      resizeToAvoidBottomPadding: false,
    );
  }

  Future scan() async {
    try {
      String barcode = await BarcodeScanner.scan();
      setState(() => this.barcode = barcode);
    } on PlatformException catch (e) {
      if (e.code == BarcodeScanner.CameraAccessDenied) {
        setState(() {
          this.barcode = 'El usuario no ha dado los permisos necesarios';
        });
      } else {
        setState(() => this.barcode = 'Error inesperado: $e');
      }
    } on FormatException{
      setState(() => this.barcode = 'Se cancelo la escaneada');
    } catch (e) {
      setState(() => this.barcode = 'Error desconocido: $e');
    }
  }
  void navigate_2Notice(){
    //print("Long "+my_meds.length.toString());
    setState(() {
      didShow=true;
    });
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Notice()),
    );
  }
  Widget _buildList() {

    return ListView.separated(
      separatorBuilder: (context, index)=> Divider(
        color: Colors.black,
      ),
      itemCount: my_meds.length,shrinkWrap: true,itemBuilder: (BuildContext context,int pos){
      Medicamento _medicamentoActual=my_meds[pos];
      return new ListTile(
        trailing: Row(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            GestureDetector(
              child: CircleAvatar(
                foregroundColor: Colors.white,
                child: Icon(MdiIcons.delete),
                backgroundColor: Colors.red,
              ),
              onTap: (){
                _showDialogRemoveMed(pos);
              },
            )

          ],
        ),
        title: Padding(padding: EdgeInsets.only(left: 5),child: Text(_medicamentoActual.Nombre,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 24,color: Colors.black)),),
        onTap: (){
          if(_medicamentoActual.Compuestos.isEmpty==false){
            Navigator.push(
              context,
              MaterialPageRoute(builder: (context) =>
                  InformacionMedicamento(medicamento: _medicamentoActual,)),
            );

          }else{
            //print("is null");
            Fluttertoast.showToast(
                msg: "No hay datos suficientes",
                toastLength: Toast.LENGTH_SHORT,
                gravity: ToastGravity.BOTTOM,
                timeInSecForIos: 1,
                backgroundColor: Colors.black,
                textColor: Colors.white,
                fontSize: 16.0);
          }

        },
      );
    },
    );
  }
  void _showDialogRemoveMed(int pos) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Aviso"),
          content: new Text("Se eliminara el medicamento seleccionado"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Eliminar"),
              onPressed: (){
                if(isOnline){
                  removeMed(idUser, my_meds[pos].Codigo);
                  setState(() {
                    my_meds.removeAt(pos);
                  });
                  persist_my_meds();
                  Fluttertoast.showToast(
                      msg: "Eliminado",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );

                }else{
                  Fluttertoast.showToast(
                      msg: "Se necesita conexion a internet",
                      toastLength: Toast.LENGTH_LONG,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 2,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0
                  );
                }
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
  check() async {
    var connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile) {
      setState(() {
        isOnline=true;
        //print('hay conexion');
      });
    } else if (connectivityResult == ConnectivityResult.wifi) {
      setState(() {
        isOnline=true;
      });
      //print('hay conexion');
    } else if (connectivityResult == ConnectivityResult.none) {
      setState(() {
        isOnline=false;
      });
      //print('hay conexion');
    }
  }

  @override
  void dispose() {
    super.dispose();
    subscription.cancel();
    detector.stopListening();
  }
  Future<bool> IterateOverMedsArray()async{
    print("estoy verificando si hay interacciones");
    bool interact=false;
    for(int i=0;i<my_meds.length-1;i++){
      Medicamento m1=my_meds[i];
      for(int j=i+1;j<my_meds.length;j++){
        Medicamento m2=my_meds[j];
        if(Medicamento.validarInteraccionMedicamentosa(m1, m2, pacs)){
          //debo postear
          //RegistrarInteraccion(idUser,m1.Codigo,m2.Codigo);
          interact=true;
        }
      }
    }
    //se hace ahora otra verificacion

    for(int i=0;i<my_meds.length-1;i++){
      Medicamento m1=my_meds[i];
      for(int j=i+1;j<my_meds.length;j++){
        Medicamento m2=my_meds[j];
        if(Medicamento.validarInteraccionMedicamentosa(m2, m1, pacs)){
          //RegistrarInteraccion(idUser,m1.Codigo,m2.Codigo);
          interact=true;
        }
      }
    }
    return interact;
  }
  Future getPACSFromShared() async{
    setState(() {
      isLoading = true;
    });
    final String membershipKey = 'jsonpacs';
    List<PrincipioActivo> temp_list=new List<PrincipioActivo>();
    String valueStored=prefs.getString(membershipKey)??"";
    if(valueStored!=null){
      json
          .decode(valueStored)
          .forEach((map) => temp_list.add(new PrincipioActivo.fromJson(map)));
      setState(() {
        pacs=temp_list;
        isLoading = false;
      });
      //persistiran aqui
    }

  }
}