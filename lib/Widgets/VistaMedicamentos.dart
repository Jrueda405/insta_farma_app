import 'dart:convert';
import 'dart:io';
import 'package:insta_farma_app/Objects/Language.dart';
import 'package:insta_farma_app/Resources/Colores/Colores.dart';
import 'package:speech_recognition/speech_recognition.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:insta_farma_app/Objects/Medicamento.dart';
import 'package:insta_farma_app/Objects/PrincipioActivo.dart';
import 'package:insta_farma_app/Strings/Strings.dart';
import 'package:insta_farma_app/Widgets/InformacionMedicamento.dart';
import 'package:insta_farma_app/Widgets/Notice.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:connectivity/connectivity.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class VistaMedicamentos extends StatefulWidget {
  /*
  List<Medicamento> my_meds;
  List<Medicamento> medicamentos;
  List<PrincipioActivo> pacs;
  */int languagePos;
  String idUser;

  //VistaMedicamentos({Key key,@required this.pacs,@required this.medicamentos,@required this.my_meds,@required this.idUser,@required this.languagePos}):super(key:key);
  VistaMedicamentos({Key key,@required this.idUser,@required this.languagePos}):super(key:key);
  @override
  _VistaMedicamentosState createState() => new _VistaMedicamentosState();
}
class _VistaMedicamentosState extends State<VistaMedicamentos> with AutomaticKeepAliveClientMixin<VistaMedicamentos>{
  final TextEditingController _filter = new TextEditingController();
  String _searchText = "";
  Widget _searchIcon = new GestureDetector(child:new Icon(Icons.search));
  SpeechRecognition _speech;

  bool _speechRecognitionAvailable = false;
  bool _isListening = false;
  Language selectedLang;
  var isLoading=true;
  Icon fabIcon;
  bool isOnline;
  var subscription;
  http.Client client;
  SharedPreferences prefs;
  //widget objetcs
  List<Medicamento> my_meds;
  List<Medicamento> medicamentos; List<Medicamento> medicamentosfiltrados;
  List<PrincipioActivo> pacs;
  int languagePos;
  String idUser;

  @override
  bool get wantKeepAlive => true;

  @override
  initState() {
    super.initState();
    languagePos=widget.languagePos;
    selectedLang=languages[languagePos];
    idUser=widget.idUser;
    my_meds=new List<Medicamento>();
    pacs=new List<PrincipioActivo>();
    medicamentos=new List<Medicamento>();
    medicamentosfiltrados=new List<Medicamento>();
    client = new http.Client();
    this.setState(() {
      isLoading = true;
    });

    instantiateShared().whenComplete((){
      getPACSFromShared().whenComplete((){
        if(pacs==null || pacs.length<1){
          fetchPacs();
        }
      });
      getMedsFromShared().whenComplete((){
        if(medicamentos==null || medicamentos.length<1){
          print("Se estan trayendo los Medicamentos de internet");
          fetchMeds();
        }
      });
      getMyMedsFromShared();
    });
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
    instantiateShared().whenComplete((){
      setState(() {
        isLoading=false;
      });
    });

    //listener
    _filter.addListener(() {
      if (_filter.text.isEmpty) {
        setState(() {
          _searchText = "";
          _searchIcon = new GestureDetector(child:new Icon(Icons.search));
        });
      } else {
        setState(() {
          _searchText = _filter.text;
          _searchIcon = new GestureDetector(child:new Icon(Icons.cancel),onTap: (){
            _searchText = _filter.text;
            _filter.clear();
            _searchText='';
            _searchIcon = new GestureDetector(child:new Icon(Icons.search));
          } ,);
        });
      }
    });
    fabIcon=Icon(Icons.mic,);
    activateSpeechRecognizer();
  }

  Future<bool> instantiateShared() async{
    prefs = await SharedPreferences.getInstance();
    return true;
  }


  void activateSpeechRecognizer() {
    //print('_MyAppState.activateSpeechRecognizer... ');
    _speech = new SpeechRecognition();
    _speech.setAvailabilityHandler(onSpeechAvailability);
    _speech.setCurrentLocaleHandler(onCurrentLocale);
    _speech.setRecognitionStartedHandler(onRecognitionStarted);
    _speech.setRecognitionResultHandler(onRecognitionResult);
    _speech.setRecognitionCompleteHandler(onRecognitionComplete);
    //_speech.setErrorHandler(errorHandler);
    _speech
        .activate()
        .then((res) => setState(() => _speechRecognitionAvailable = res));
  }

  Widget build(BuildContext context) {
    return Scaffold(

      body: SafeArea(
        child: Container(
          child: !isLoading? Column(
            children: <Widget>[
              Padding(padding: EdgeInsets.all(10),child: new TextField(
                controller: _filter,
                decoration: InputDecoration(
                    contentPadding: EdgeInsets.fromLTRB(20.0, 15.0, 20.0, 15.0),
                    hintText: "Nombre del medicamento",
                    prefixIcon: _searchIcon,
                    suffixIcon:  GestureDetector(
                      onTap: (){
                        if(_speechRecognitionAvailable && !_isListening){
                          start();
                        }else{
                          activateSpeechRecognizer();
                        }

                      },child: fabIcon,
                    ),
                    border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10.0))),
              ),),
              new Expanded(
                flex: 10,
                child: _buildList(),
              ),
            ],
          ): Center(child: CircularProgressIndicator(),),
        ),
        bottom: true,
        left: true,
        right: true,
        top: true,
      ),
      resizeToAvoidBottomPadding: false,
    );
  }
  @override
  void reassemble() {
    super.reassemble();
  }

  Widget _buildList() {
    if(medicamentosfiltrados==null){
      medicamentosfiltrados=medicamentos;
    }else if(medicamentosfiltrados.length<1){
      medicamentosfiltrados=medicamentos;
    }
    if ((_searchText.isNotEmpty)) {
      List<Medicamento> tempList = new List<Medicamento>();
      for (int i = 0; i < medicamentosfiltrados.length; i++) {
        if (medicamentosfiltrados[i].Nombre.toString().toLowerCase().contains(_searchText.toLowerCase())) {
          tempList.add(medicamentosfiltrados[i]);
        }
      }
      medicamentosfiltrados = tempList;
    }else{
      medicamentosfiltrados=medicamentos;
    }
    return ListView.separated(
      separatorBuilder: (context, index)=> Divider(
        color: Colors.black,
      )
      ,itemCount: medicamentos == null ? 0 : medicamentosfiltrados.length,
      shrinkWrap: true,
      itemBuilder: (BuildContext context, int index) {
        Medicamento med=medicamentosfiltrados[index];
        return new ListTile(

            title: Padding(padding: EdgeInsets.only(left: 5),child: Text(med.Nombre,style: TextStyle(fontWeight: FontWeight.normal,fontSize: 24,color: Colors.black)),),
            trailing: Row(
              mainAxisSize: MainAxisSize.min,
              children: <Widget>[
                GestureDetector(
                  child: CircleAvatar(
                    foregroundColor: Colors.white,
                    child: Icon(MdiIcons.plus),
                    backgroundColor: Colores.green2,
                  ),
                  onTap: (){
                    _showDialogAddMed(med);
                  },
                )

              ],
            ),
            onTap: () {
            if(med.Compuestos.isEmpty==false){
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) =>
                      InformacionMedicamento(medicamento: med,)),
                );

              }else{
                Fluttertoast.showToast(
                    msg: "No hay datos suficientes",
                    toastLength: Toast.LENGTH_SHORT,
                    gravity: ToastGravity.BOTTOM,
                    timeInSecForIos: 1,
                    backgroundColor: Colors.black,
                    textColor: Colors.white,
                    fontSize: 16.0);
              }

            }

        );
      },
    );
  }

  void start() {
    _speech
        .listen(locale: selectedLang.code)
        .then((result) => print('Start SR => result $result'));

  }

  void cancel(){
    _speech.cancel().then((result) {
      //print('el resultado fue: '+result);
      setState(() {
        _isListening = result;
        _speechRecognitionAvailable=true;
      });
    });
  }


  void stop() => _speech.stop().then((result) {
    //print('el resultado fue: '+result);
    setState(() => _isListening = result);
  });

  void onSpeechAvailability(bool result) =>
      setState(() => _speechRecognitionAvailable = result);

  void onCurrentLocale(String locale) {
    //print('_MyAppState.onCurrentLocale... $locale');
    setState(
            () => selectedLang = languages.firstWhere((l) => l.code == locale));
  }

  void onRecognitionStarted() => setState(() => _isListening = true);

  void onRecognitionResult(String text) => setState(() {
    _searchText = text;
    _filter.text=text;
  } );

  void onRecognitionComplete() => setState(() => _isListening = false);

  void errorHandler() => activateSpeechRecognizer();

  void _showDialogAddMed(Medicamento m) {
    // flutter defined function
    showDialog(
      context: context,
      builder: (BuildContext context) {
        // return object of type Dialog
        return AlertDialog(
          title: new Text("Aviso"),
          content: new Text("Se agregara el medicamento seleccionado"),
          actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Cancelar"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            new FlatButton(
              child: new Text("Agregar"),
              onPressed: () {
                if(isOnline){
                  int _searchValue = my_meds.indexWhere((med) =>
                  med.Nombre == m.Nombre);
                  //print("valor "+_searchValue.toString());
                  if (_searchValue < 0) {//quiere decir que no esta
                    setState(() {
                      my_meds.add(m);
                      persist_my_meds();
                      uploadMed(idUser);
                      IterateOverMedsArray().then((e){
                        if(e==true){
                          navigate_2Notice();
                        }
                      });
                    });
                    Fluttertoast.showToast(
                        msg: "Agregado",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }else{
                    Fluttertoast.showToast(
                        msg: "El medicamento ya se encuentra agregado",
                        toastLength: Toast.LENGTH_SHORT,
                        gravity: ToastGravity.BOTTOM,
                        timeInSecForIos: 1,
                        backgroundColor: Colors.black,
                        textColor: Colors.white,
                        fontSize: 16.0);
                  }
                }else{
                  Fluttertoast.showToast(
                      msg: "Se necesita internet para completar esta operacion",
                      toastLength: Toast.LENGTH_SHORT,
                      gravity: ToastGravity.BOTTOM,
                      timeInSecForIos: 1,
                      backgroundColor: Colors.black,
                      textColor: Colors.white,
                      fontSize: 16.0);
                }
                Navigator.of(context).pop();
              }
            ),
          ],
        );
      },
    );
  }

  Future<bool> IterateOverMedsArray()async{
    //print("estoy verificando si hay interacciones");
    bool interact=false;
    for(int i=0;i<my_meds.length-1;i++){
      Medicamento m1=my_meds[i];
      for(int j=i+1;j<my_meds.length;j++){
        Medicamento m2=my_meds[j];
        if(Medicamento.validarInteraccionMedicamentosa(m1, m2, pacs)){
          //debo postear
          interact=true;
          RegistrarInteraccion(idUser,m1.Codigo,m2.Codigo);
        }
      }
    }
    //se hace ahora otra verificacion

    for(int i=0;i<my_meds.length-1;i++){
      Medicamento m1=my_meds[i];
      for(int j=i+1;j<my_meds.length;j++){
        Medicamento m2=my_meds[j];
        if(Medicamento.validarInteraccionMedicamentosa(m2, m1, pacs)){
          interact=true;
          RegistrarInteraccion(idUser,m1.Codigo,m2.Codigo);
        }
      }
    }
    return interact;
  }


  Future uploadMed(String idUser) async{
    for(int i=0;i<my_meds.length;i++){
      Medicamento current=my_meds[i];
      Map<String, dynamic> body = {
        'idUser': idUser,
        'codMed': current.Codigo,
      };
      Response response = await Dio().post(Strings.url+"/SubirMyMed.php",data:body, options: new Options(contentType:ContentType.parse("application/x-www-form-urlencoded")));
      if(response.statusCode==200){
        //print(response.data);
      }
    }
  }
  Future RegistrarInteraccion(String idUser,String idMed1, String idMed2) async{
    Map<String, dynamic> body = {
      'idUser': idUser,
      'idm1': idMed1,
      'idm2': idMed2,
    };
    Response response = await Dio().post(Strings.url+"/RegistrarInteraccion.php",data:body, options: new Options(contentType:ContentType.parse("application/x-www-form-urlencoded")));
    if(response.statusCode==200){
      //print(response.data);
    }
  }
  void navigate_2Notice(){
    //print("Long "+my_meds.length.toString());
    Navigator.push(
      context,
      MaterialPageRoute(builder: (context) => Notice()),
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
    _filter.dispose();
    _speech.stop();
    super.dispose();
    subscription.cancel();
  }
  Future getMedsFromShared() async{
    print("Obteniendo meds");
    setState(() {
      isLoading = true;
    });
    final String membershipKey = 'jsonmeds';
    List<Medicamento> temp_list=new List<Medicamento>();
    String valueStored=prefs.getString(membershipKey)?? "";
    print("valor: "+valueStored);
    if(valueStored!=null){
      json
          .decode(valueStored)
          .forEach((map) => temp_list.add(new Medicamento.fromJson(map)));
      setState(() {
        medicamentos=temp_list;
        isLoading=false;
      });
    }
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
  Future fetchMeds() async {
    setState(() {
      isLoading = true;
    });
    final response =
    await http.get(Strings.url+"/GetMeds.php");
    print('llego: '+response.body);
    if (response.statusCode == 200) {
      List<Medicamento> list = (json.decode(response.body) as List)
          .map((data) => new Medicamento.fromJson(data))
          .toList();
      setState(() {
        isLoading = false;
        medicamentos=list;
      });
      persist_medlist();
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
  void persist_medlist() async{
    final String membershipKey = 'jsonmeds'; // maybe use your domain + appname
    print('Se estan guardando los meds');
    await prefs.setString(membershipKey, json.encode(medicamentos));
  }
  void persist_paclist() async{
    final String membershipKey = 'jsonpacs'; // maybe use your domain + appname
    print('Se estan guardando los pacs');
    await prefs.setString(membershipKey, json.encode(pacs));
  }
  void persist_my_meds() async{
    final String membershipKey = 'jsonmymeds';
    await prefs.setString(membershipKey, json.encode(my_meds));
  }

}

