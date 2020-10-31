import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';

import 'package:Tetra/main_menu.dart';
import 'package:Tetra/theme.dart';

// A stateful widget that is for the default main page, uses future builder to get preferences before displaying contents
class MainMenuPage extends StatefulWidget {
  @override
  _MainMenuPageState createState() => _MainMenuPageState();
}

class _MainMenuPageState extends State<MainMenuPage> {
  Future<bool> _gotPrefs;

  // Get the preferences, if null (preference wasn't set for it) assign default values
  Future<bool> getPreferences() async{
    SharedPreferences pref = await SharedPreferences.getInstance();
    CurrentThemeKey = pref.getString('THEME')      ?? "STANDARD";
    Difficulty      = pref.getString('DIFFICULTY') ?? "NORMAL";
    MusicSelection  = pref.getString("MUSIC")      ?? "INSTRUMENTAL";
    return true;
  }

  @override
  void initState() {
    super.initState();
    _gotPrefs = getPreferences();
  }

  // Returns what would be the main menu page, a stack to layer the video into background with buttons on top
  Widget menuStack(){
    return Container(
      color: ThemeColors_Map[CurrentThemeKey].BgColor,
      child: Stack(
        children: <Widget>[
          //https://stackoverflow.com/questions/44179889/flutter-sdk-set-background-image
          Container(
            decoration: BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/images/title_screen.png'),
                fit: BoxFit.cover,
              ),
            )
          ),
          MainMenuWidget(),
        ],
      )
    );
  }

  Widget build(BuildContext context){
    return new WillPopScope (
      onWillPop: () async => false,
      child: new Scaffold(
        backgroundColor: ThemeColors_Map[CurrentThemeKey].BgColor,
        body: FutureBuilder<bool> (
          future: _gotPrefs,
          builder: (BuildContext context, AsyncSnapshot<bool> snapshot){
            if (!snapshot.hasData || !snapshot.data){
              return Container();
            }
            else {
              return menuStack();
            }
          }
        ),
      )
    );
  }
}
