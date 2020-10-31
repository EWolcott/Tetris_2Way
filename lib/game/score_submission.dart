import 'package:flutter/material.dart';

import 'package:audioplayers/audio_cache.dart'; // For playing sound effects
import 'package:audioplayers/audioplayers.dart'; // For PlayerMode.LOW_LATENCY

import 'package:Tetra/theme.dart';
import 'package:Tetra/game/score_storage.dart';
import 'package:Tetra/game/score.dart';

// Page for making a submission for high score
class ScoreSubmit extends StatelessWidget {
  final _score;
  // Constructor, sets what the score value is
  ScoreSubmit(this._score);

  final nameController = TextEditingController(); // Used by TextField to manage scoreName submission

  Widget build(BuildContext context){
    return Container(
      color: ThemeColors_Map[CurrentThemeKey].GridBgColor,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: <Widget>[
          // Simple text to say game over and display the score from the game
          Container(),
          Text("GAME OVER", style: ThemeTextStyle_Map[CurrentThemeKey].MenuTextStyle),
          Text("SCORE: " + _score.toString(), style: ThemeTextStyle_Map[CurrentThemeKey].MenuTextStyle),
          Padding(
            padding: EdgeInsets.all(20),
            child: Text("ENTER YOUR FIRST NAME BELOW", style: ThemeTextStyle_Map[CurrentThemeKey].SubTextStyle),
          ),
          //https://flutter.dev/docs/cookbook/forms/retrieve-input
          // Container for text field to input the name, followed by a submit button
          Container(
            width: 200,
            height: 40,
            color: ThemeColors_Map[CurrentThemeKey].ContrastColor,
            child: TextField(
              obscureText: false,
              style: ThemeTextStyle_Map[CurrentThemeKey].AltTextStyle,
              controller: nameController,
            ),
          ),
          FlatButton( // Save the score
            child: Text("SAVE", style: ThemeTextStyle_Map[CurrentThemeKey].SubTextStyle),
            onPressed: () {
              // Only get the first "name" by space
              String inputName = (nameController.text.split(' ')[0]);
              // Don't save the score if they did not input a name or if there are spaces
              if (inputName != ""){
                AudioCache().play('audio/button_press.mp3', mode: PlayerMode.LOW_LATENCY);
                ScoreStorage().saveScore(Score(inputName, _score));
                Navigator.popAndPushNamed(context, '/');
              }
            },
          ),
          FlatButton( // if the user doesn't want to save their score
            child: Text("DO NOT SAVE", style: ThemeTextStyle_Map[CurrentThemeKey].SubTextStyle),
            onPressed: () => {
              AudioCache().play('audio/button_press.mp3', mode: PlayerMode.LOW_LATENCY),
              Navigator.popAndPushNamed(context, '/')
            },
          ),
        ],
      ));
  }
}