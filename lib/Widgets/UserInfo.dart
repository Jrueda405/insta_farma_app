import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:insta_farma_app/Objects/Enfermedad.dart';
import 'package:insta_farma_app/Resources/Colores/Colores.dart';
import 'package:insta_farma_app/Strings/Strings.dart';
import 'package:insta_farma_app/Widgets/ChangePassword.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

class UserInformation extends StatefulWidget {
  @override
  UserInformationState createState() => new UserInformationState();
}

class UserInformationState extends State<UserInformation>
    with SingleTickerProviderStateMixin {
  bool _status = true;
  SharedPreferences prefs;
  bool isLoading = false;
  var _username;
  var _password;
  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);
  final control_user = TextEditingController();
  final control_password = TextEditingController();
  final FocusNode myFocusNode = FocusNode();
  bool acceptChanges = false;
  bool obscureText = true;
  @override
  void initState() {
    super.initState();
    instantiateShared().whenComplete(() {
      getUserInfo();
    });
  }

  void _toggle() {
    setState(() {
      obscureText = !obscureText;
    });
  }

  @override
  Widget build(BuildContext context) {
    final key = new GlobalKey<ScaffoldState>();
    return new Scaffold(
        key: key,
        //floatingActionButton: _status ? _getEditIcon() : new Container(),
        appBar: AppBar(
          title: Text('Perfil'),
          backgroundColor: Colores.green1,
        ),
        body: SafeArea(
          child: !isLoading
              ? Container(
                  color: Colors.white,
                  child: new ListView(
                    children: <Widget>[
                      Column(
                        children: <Widget>[
                          new Align(
                            child: new Column(
                              children: <Widget>[
                                Padding(
                                  padding: EdgeInsets.only(top: 5.0),
                                  child: new Stack(
                                      fit: StackFit.loose,
                                      children: <Widget>[
                                        new Row(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.center,
                                          mainAxisAlignment:
                                              MainAxisAlignment.center,
                                          children: <Widget>[
                                            new Container(
                                                width: 120.0,
                                                height: 120.0,
                                                decoration: new BoxDecoration(
                                                  shape: BoxShape.circle,
                                                  image: new DecorationImage(
                                                    image: new ExactAssetImage(
                                                        'assets/images/user.png'),
                                                    fit: BoxFit.cover,
                                                  ),
                                                )),
                                          ],
                                        ),
                                      ]),
                                ),
                                Padding(
                                    padding: EdgeInsets.only(
                                        left: 10, right: 10, top: 10),
                                    child: Align(
                                      alignment: Alignment.centerLeft,
                                      child: new Text(
                                        'Enfermedades',
                                        style: TextStyle(
                                            fontSize: 18.0,
                                            fontWeight: FontWeight.bold),
                                      ),
                                    )),
                              ],
                            ),
                          ),
                          new Container(
                            color: Color(0xffFFFFFF),
                            child: Padding(
                              padding:
                                  EdgeInsets.only(left: 10, right: 10, top: 10),
                              child: new Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: <Widget>[
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 0, right: 0, top: 0),
                                      child: new Row(
                                        mainAxisAlignment:
                                            MainAxisAlignment.start,
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Informacion',
                                                style: TextStyle(
                                                    fontSize: 18.0,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, top: 0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Nombre de usuario',
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                              icon: Icon(MdiIcons.contentCopy),
                                              onPressed: () {
                                                Clipboard.setData(
                                                    new ClipboardData(
                                                        text: _username));
                                                key.currentState
                                                    .showSnackBar(new SnackBar(
                                                  content: new Text("Copiado"),
                                                ));
                                              }),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, top: 0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Flexible(
                                            child: new TextField(
                                              decoration: const InputDecoration(
                                                hintText: "username",
                                              ),
                                              enabled: !_status,
                                              autofocus: !_status,
                                              controller: control_user,
                                            
                                            ),
                                          ),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, top: 0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.start,
                                            mainAxisSize: MainAxisSize.min,
                                            children: <Widget>[
                                              new Text(
                                                'Clave',
                                                style: TextStyle(
                                                    fontSize: 12.0,
                                                    fontStyle: FontStyle.italic,
                                                    fontWeight:
                                                        FontWeight.bold),
                                              ),
                                            ],
                                          ),
                                          IconButton(
                                              icon: Icon(MdiIcons.contentCopy),
                                              onPressed: () {
                                                Clipboard.setData(
                                                    new ClipboardData(
                                                        text: _password));
                                                key.currentState
                                                    .showSnackBar(new SnackBar(
                                                  content: new Text("Copiado"),
                                                ));
                                              }),
                                          IconButton(
                                              icon: Icon(MdiIcons.eye),
                                              onPressed: () {
                                                _toggle();
                                              }),
                                        ],
                                      )),
                                  Padding(
                                      padding: EdgeInsets.only(
                                          left: 10, right: 10, top: 2.0),
                                      child: new Row(
                                        mainAxisSize: MainAxisSize.max,
                                        children: <Widget>[
                                          new Flexible(
                                            child: new TextField(
                                              decoration: const InputDecoration(
                                                  hintText: "password"),
                                              enabled: !_status,
                                              controller: control_password,
                                              obscureText: obscureText,
                                            ),
                                          ),
                                        ],
                                      )),

                                  new Row(
                                    mainAxisSize: MainAxisSize.max,
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    children: <Widget>[
                                      Expanded(
                                        child: Container(
                                            child: new RaisedButton(
                                          child: new Text("Cambiar clave"),
                                          textColor: Colors.white,
                                          color: Colors.green[700],
                                          onPressed: () {
                                            //lanzar el nuevo widget cambio de clave
                                            Navigator.of(context).push(MaterialPageRoute(builder: (context) =>ChangePassword()));
                                          },
                                          shape: new RoundedRectangleBorder(
                                              borderRadius:
                                                  new BorderRadius.circular(
                                                      20.0)),
                                        ) //border radius
                                            ), //container
                                        flex: 1,
                                      ), //expanded
                                    ], //children
                                  ) //row

                                  //!_status ? _getActionButtons() : new Container(),
                                ],
                              ),
                            ),
                          )
                        ],
                      ),
                    ],
                  ),
                )
              : Center(
                  child: CircularProgressIndicator(),
                ),
          bottom: true,
          left: true,
          right: true,
          top: true,
        ));
  }

  @override
  void reassemble() {
    this.reassemble();
  }

  Widget _getActionButtons() {
    return Padding(
      padding: EdgeInsets.only(left: 0, right: 25.0, top: 45.0),
      child: new Row(
        mainAxisSize: MainAxisSize.max,
        mainAxisAlignment: MainAxisAlignment.start,
        children: <Widget>[
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(right: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Guardar"),
                textColor: Colors.white,
                color: Colors.green[700],
                onPressed: () {
                  setState(() {
                    _status = true;
                    control_user.text = _username;
                    control_password.text = _password;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
          Expanded(
            child: Padding(
              padding: EdgeInsets.only(left: 10.0),
              child: Container(
                  child: new RaisedButton(
                child: new Text("Cancelar"),
                textColor: Colors.white,
                color: Colors.red,
                onPressed: () {
                  setState(() {
                    _status = true;
                    control_user.text = _username;
                    control_password.text = _password;
                    FocusScope.of(context).requestFocus(new FocusNode());
                  });
                },
                shape: new RoundedRectangleBorder(
                    borderRadius: new BorderRadius.circular(20.0)),
              )),
            ),
            flex: 2,
          ),
        ],
      ),
    );
  }

  Widget _getEditIcon() {
    return SizedBox(
      width: 80.0,
      height: 80.0,
      child: new FloatingActionButton(
        backgroundColor: Colores.green1,
        onPressed: () {
          setState(() {
            _status = false;
          });
        },
        child: new Icon(
          Icons.edit,
          color: Colors.white,
          size: 16.0,
        ),
      ),
    );
  }

  Future<bool> instantiateShared() async {
    prefs = await SharedPreferences.getInstance();
    return true;
  }

  getUserInfo() {
    if (prefs != null) {
      setState(() {
        this._password = prefs.getString('password') ?? "";
        this._username = prefs.getString('username') ?? "";
        control_user.text = this._username;
        control_password.text = this._password;
      });
    }
    //se dejaran aqui para probar
  }

  @override
  void dispose() {
    control_user.dispose();
    control_password.dispose();
    super.dispose();
  }
}
