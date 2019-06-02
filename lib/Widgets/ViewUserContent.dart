import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/services.dart';
import 'package:insta_farma_app/Objects/Enfermedad.dart';
import 'package:insta_farma_app/Widgets/Enfermedades.dart';
import 'package:insta_farma_app/Widgets/UserInfo.dart';
import 'dart:async';
import 'package:material_design_icons_flutter/material_design_icons_flutter.dart';
import 'dart:math';

import 'package:shared_preferences/shared_preferences.dart';

class ViewUserProfile extends StatefulWidget {
  @override
  _viewUserProfileState createState() => _viewUserProfileState();
}

class _viewUserProfileState extends State<ViewUserProfile>{

  int _selectedIndex = 0;
  final List<Widget> _children = [
    UserInformation(),
    Enfermedades(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }


  @override
  void initState() {
    // TODO: implement initState
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: _children[_selectedIndex],
      bottomNavigationBar: BottomNavigationBar(
        onTap: _onItemTapped, // new
        fixedColor: Colors.black,
        currentIndex: _selectedIndex, // new
        items: [
          new BottomNavigationBarItem(
              icon: Icon(Icons.person),
              title: Text('Perfil')
          ),
          new BottomNavigationBarItem(
              icon: Icon(Icons.list),
              title: Text('Enfermedades')
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    // Clean up the controller when the Widget is disposed
    super.dispose();
  }

}


