import 'package:flutter/material.dart';

import 'package:Tetra/game/score.dart';
import 'package:Tetra/game/score_storage.dart';
import 'package:Tetra/theme.dart';


// A stateful widget for displaying the leaderboard, specifically the top ten scores on the device
class LeaderBoardScreen extends StatefulWidget {
  @override
  _LeaderBoardScreenState createState() => _LeaderBoardScreenState();
}

class _LeaderBoardScreenState extends State<LeaderBoardScreen> {
  Future<List<Score>> _highscores;

  // Set _highscoreList to what the file contains
  Future<List<Score>> getScoresFromFile() async {
    var storage = ScoreStorage();
    var highscoreList = new List<Score>();
    highscoreList = await storage.getScoreList();
    if (highscoreList.length == 0){
      // A default example score if the device has none is added to the list
      highscoreList.add(Score("GEN ERIC", 10));
    }
    return highscoreList;
  }

  @override
  void initState() {
    super.initState();
    _highscores = getScoresFromFile();    
  }

  // Input: A list of scores
  // Output: Returns a scrollable column widget containing the scores
  scoreListView(List<Score> list) {
    return Container(
      color: ThemeColors_Map[CurrentThemeKey].GridBgColor,
      child: SingleChildScrollView(
        child: Column(
          children: <Widget>[
            for (int i = 0; i < list.length; i++) list[i].toWidget(i+1),
          ],
        )
      )
    );
  }

  Widget build(BuildContext context) {
    return
        // Displays the score information
        //https://stackoverflow.com/questions/53800662/how-do-i-call-async-property-in-widget-build-method
        //https://stackoverflow.com/questions/52801201/flutter-renderbox-was-not-laid-out for using Expanded with ListView
        Expanded(child: FutureBuilder<List<Score>> (
          future: _highscores,
          builder: (BuildContext context, AsyncSnapshot<List<Score>> snapshot){
            if (!snapshot.hasData) {
              return Container();
            }
            else {
              return scoreListView(snapshot.data);
            }
        }));
  }
}