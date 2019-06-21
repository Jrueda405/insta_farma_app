import 'dart:async';
import 'package:chewie/chewie.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:video_player/video_player.dart';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'package:vibration/vibration.dart';

import 'package:flutter_text_to_speech/flutter_text_to_speech.dart';
import 'package:flutter/services.dart';

class Notice extends StatefulWidget{

  @override
  _NoticeState createState()=> _NoticeState();
}
enum TtsState { playing, stopped }

class _NoticeState extends State<Notice>{

  TextStyle style = TextStyle(fontFamily: 'Montserrat', fontSize: 20.0, color: Colors.black);
  VideoPlayerController _videoPlayerController1;
  ChewieController _chewieController;

  VoiceController controller;
  Widget _vista;
  @override
  void initState() {
    super.initState();
    this.startVibrator();
    _videoPlayerController1 = VideoPlayerController.asset('assets/videos/notice.mp4',
      );
    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController1,
      aspectRatio: 4 / 3,
      allowMuting: true,
      allowFullScreen: false,
      autoPlay: true,
      showControls: true,
      looping: true,
    );
    _vista=_vistaTexto();

    controller = FlutterTextToSpeech.instance.voiceController();
    controller.init().then((_) {
      controller.setLanguage('es-US');
      controller.speak('Acuda a su médico tratante, se encontró que hay una interacción entre los medicamentos');
    });
  }

  void startVibrator() async {
    Vibration.hasVibrator().then((valor){
      if(valor){
        Vibration.vibrate(pattern: [500, 1000, 500,1000]);
      }
    });

  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.red[400],
      body: SafeArea(child: _vista,
        bottom: true,
        left: true,
        right: true,
        top: true,)
      ,resizeToAvoidBottomPadding: false,
    );
  }

  @override
  void dispose() {
    super.dispose();
    _videoPlayerController1.dispose();
    _chewieController.dispose();
    controller.stop();
  }

  Widget _vistaTexto(){
    return Padding(
        padding: EdgeInsets.fromLTRB(5, 80, 5, 80),
        child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Icon(MdiIcons.doctor,color: Colors.amber,size: 150.0,),
                Card(
                  color: Colors.white.withOpacity(0),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      const ListTile(
                        title: Text(
                          'Acuda a su médico tratante, se encontró que hay una interacción entre los medicamentos',
                          textAlign: TextAlign.center,
                          style: TextStyle(fontWeight: FontWeight.bold,fontSize: 24,color: Colors.white),
                        ),
                        dense: true,
                      )
                      ,
                      ButtonTheme.bar( // make buttons use the appropriate styles for cards
                        padding: EdgeInsets.all(8.0),
                        child: ButtonBar(
                          children: <Widget>[
                            GestureDetector(
                              onTap: (){
                                controller.speak('Acuda a su médico tratante, se encontró que hay una interacción entre los medicamentos');
                              }
                              ,child: Icon(Icons.volume_up,color: Colors.white,size: 45,),

                            ),
                            GestureDetector(
                              onTap: (){
                                setState(() {
                                  _vista=_vistaVideo();
                                });
                              },
                              child: Icon(Icons.video_library,color: Colors.white,size: 45,),
                            )

                          ],
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            )
        )
    );

  }

  Widget _vistaVideo(){
    return Padding(
        padding: EdgeInsets.fromLTRB(5, 40, 5, 40),
        child: Center(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                Chewie(
                  controller: _chewieController,
                ),
                SizedBox(
                  height: 60,
                ),
                Text(
                  'Traduccion por: Claudia Patricia Hernández Valdivieso',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontWeight: FontWeight.bold,fontSize: 20,color: Colors.white)),
                SizedBox(
                  height: 60,
                ),
                Center(
                  child: Row(
                    mainAxisSize: MainAxisSize.min,
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      GestureDetector(
                        child: CircleAvatar(
                          foregroundColor: Colors.white,
                          child: Icon(MdiIcons.textToSpeech,color: Colors.white,size: 45,),
                          radius: 40.0,
                          backgroundColor: Colors.amberAccent,
                        ),
                        onTap: (){
                          setState(() {
                            _vista=_vistaTexto();
                          });
                        },
                      ),
                    ],
                  ),
                )
              ],
            )
        )
    );

  }
}
