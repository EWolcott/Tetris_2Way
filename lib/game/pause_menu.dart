import 'package:flutter/material.dart';

import 'package:Tetra/theme.dart';

// A widget to display in middle of PlayArea when the game is paused, gives user option to unpause the game or quit
class PauseMenu extends StatelessWidget {
  void Function() pauseCall, quitCall;

  PauseMenu({this.pauseCall, this.quitCall});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: <Widget>[
        Text("PAUSED", style: ThemeTextStyle_Map[CurrentThemeKey].MenuTextStyle),
        Container(
          height: 43,
          child: FlatButton(  
            child: Text("UNPAUSE", style: ThemeTextStyle_Map[CurrentThemeKey].SubTextStyle),
            onPressed: () {
              pauseCall();
            }
          ),
        ),
        Container(
          height: 20,
          child: FlatButton(  
            child: Text("QUIT", style: ThemeTextStyle_Map[CurrentThemeKey].SubTextStyle),
            onPressed: () {
              quitCall();
            }
          ),
        ),      ],
    
    
    );
  }


}