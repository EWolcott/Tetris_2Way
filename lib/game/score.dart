import 'package:Tetra/theme.dart';
import 'package:flutter/material.dart';

// Simple object to store a score's name and value with display as a widget
class Score {
  int scoreValue; // The numeric score value
  String scoreName; // The name that corresponds to it
  // Constructor
  Score(this.scoreName, this.scoreValue);

  // toString used when saving onto the text file
  toString() => ("$scoreName $scoreValue");
  
  // Return the information in a widget form that could be used to display in highscore page
  toWidget(int position) {
    // For seeing spacers() https://stackoverflow.com/questions/52376287/positioning-widget-inside-a-row-to-the-end-of-row
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5),
      child: Row(
        children: <Widget>[
          Padding(padding: EdgeInsets.all(8),),

          Text('$position: ', style: ThemeTextStyle_Map[CurrentThemeKey].ListTextStyle),
          Text(scoreName, style:ThemeTextStyle_Map[CurrentThemeKey].ListTextStyle),

          new Spacer(), // Make a gap from the name to the score for consistent formatting

          Text('$scoreValue', style:ThemeTextStyle_Map[CurrentThemeKey].ListTextStyle),

          Padding(padding: EdgeInsets.all(8),),

        ]),
    );
  }
}