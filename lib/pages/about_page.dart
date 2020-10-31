import 'package:flutter/material.dart';

import 'package:audioplayers/audio_cache.dart'; // For button press sound effects
import 'package:audioplayers/audioplayers.dart'; // For PlayerMode.LOW_LATENCY

import 'package:Tetra/theme.dart';

// An about page for what this app is and credit the songs
class AboutPage extends StatelessWidget {
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: ThemeColors_Map[CurrentThemeKey].BgColor,
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[        
          Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: <Widget>[
              FlatButton(
                color: Colors.transparent,
                child: Icon(Icons.arrow_back, size: 40, color: ThemeColors_Map[CurrentThemeKey].ContrastColor),
                //https://stackoverflow.com/questions/51071933/navigator-routes-clear-the-stack-of-flutter
                onPressed: () =>  {
                  AudioCache().play('audio/button_press.mp3', mode: PlayerMode.LOW_LATENCY),
                  Navigator.pop(context),
                }
              ),                    
              Padding(padding: EdgeInsets.only(top: 20, right:20, bottom: 20, left: 22.5)),
              Text("ABOUT", style: ThemeTextStyle_Map[CurrentThemeKey].MenuTextStyle),     
              ],
          ),
          Padding(
            padding: EdgeInsets.only(top: 40, bottom: 100),
            child: Image.asset((CurrentThemeKey == "STANDARD") ? 'assets/images/logo_standard.png' : ((CurrentThemeKey == "LIGHT") ? 'assets/images/logo_light.png' : 'assets/images/logo_cowabunga.png')      ),
          ),
          Padding(
            padding: EdgeInsets.all(40),
            child: Text("A game for CS375-1\nAstral Journey - Zapsplat.com\nGliding - Zapsplat.com\nObnoxious Market - 'Prof. Sir'\nMost Sound Effect - Zapsplat.com", style: ThemeTextStyle_Map[CurrentThemeKey].SubTextStyle),
          ),
        ],
      ),
    );
  }
}

