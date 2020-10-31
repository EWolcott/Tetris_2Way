import 'package:flutter/material.dart';

import 'package:audioplayers/audio_cache.dart'; // For button press sound effects
import 'package:audioplayers/audioplayers.dart'; // For PlayerMode.LOW_LATENCY

import 'package:Tetra/theme.dart';
import 'package:Tetra/leaderboard.dart';

// HighscorePage is the page for showing the scores saved on the device
class HighScorePage extends StatelessWidget {
  Widget build(BuildContext context){
    return Scaffold(
      backgroundColor: ThemeColors_Map[CurrentThemeKey].BgColor,
      body:  Column(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(8),),
          // Header Row
          Row(children: <Widget>[
            // Button to return back to the MainMenu
            FlatButton(
              color: Colors.transparent,
              child: Icon(Icons.arrow_back, size: 40, color: ThemeColors_Map[CurrentThemeKey].ContrastColor),
              //https://stackoverflow.com/questions/51071933/navigator-routes-clear-the-stack-of-flutter
              onPressed: () => {
                AudioCache().play('audio/button_press.mp3', mode: PlayerMode.LOW_LATENCY),
                Navigator.pop(context),
              } 
            ),
            Padding(padding: EdgeInsets.only(top:20, right: 8, bottom: 20,)),
            Text("TOP SCORES", style: ThemeTextStyle_Map[CurrentThemeKey].MenuTextStyle),
            Padding(padding: EdgeInsets.all(20)),
          ],),
          // Display the highscorees in LeaderBoardScreen widget
          LeaderBoardScreen(),
        ]
      )
    );
  }
}