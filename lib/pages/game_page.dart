import 'package:flutter/material.dart';

import 'package:Tetra/theme.dart';
import 'package:Tetra/game/playarea.dart';
import 'package:Tetra/game/score_submission.dart';

// GamePage handles the game and score submission
class GamePage extends StatefulWidget {
  @override
  _GamePageState createState() => _GamePageState();
}

class _GamePageState extends State<GamePage> {
  bool endScreen;
  int score;

  @override
  void initState() {
    super.initState();
    endScreen = false;
    score = 0;
  }

  // A callback that accepts a score, sets endScreen to true and rebuild the page
  void endGame(int finalScore) {
    setState(() {
      endScreen = true;
      score = finalScore;
    });
  }

  Widget build(BuildContext context){
    return new WillPopScope (
      onWillPop: () async => false,
      child: new Scaffold(
      backgroundColor: ThemeColors_Map[CurrentThemeKey].BgColor,
      // Body is a Stack for when adding background videos/images
      body: Stack (
        children: <Widget>[
          // Build the PlayArea or ScoreSubmission with a background image if the theme has a background image
          (ThemeAssets_Map[CurrentThemeKey].GameBgImage != '') ? 
            //https://stackoverflow.com/questions/44179889/flutter-sdk-set-background-image
            Container(
              decoration: BoxDecoration(
                image: DecorationImage(
                  image: AssetImage(ThemeAssets_Map[CurrentThemeKey].GameBgImage),
                  fit: BoxFit.cover,
                ),
              )
            )
            : Container(),  
          (!endScreen) ? PlayArea(endState: endGame) : ScoreSubmit(score),
        ],
      ),
    ));
  }
}