import 'package:flutter/material.dart';

import 'package:audioplayers/audio_cache.dart'; // For button press sound effects
import 'package:audioplayers/audioplayers.dart'; // For PlayerMode.LOW_LATENCY

import 'package:Tetra/theme.dart';

import 'package:Tetra/theme.dart';

// A widget for the menu's buttons layed out onto the page
class MainMenuWidget extends StatelessWidget {
  MainMenuWidget({
    Key key,
  }) : super(key: key);

  Widget build(BuildContext context) {
    // Use WillPopScope widget to intercept pop back button on main menu
    // https://stackoverflow.com/questions/45916658/how-to-deactivate-or-override-the-android-back-button-in-flutter
    return Container(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Padding(
            padding:EdgeInsets.only(top:10),
            child: Row(children: <Widget>[ // In the top right of the screen have a button for an about page
              Spacer(),
              FlatButton(
                child: Icon(Icons.info_outline, color: ThemeColors_Map[CurrentThemeKey].ContrastColor),
                onPressed: () {
                  AudioCache().play('audio/button_press.mp3', mode: PlayerMode.LOW_LATENCY);
                  Navigator.pushNamed(context, '/about');
                },
              ),
          ],),
          
          ),

          Padding(
            // Need to add padding, also replace child with image?            
            padding: EdgeInsets.only(top:70),
            child:  Image.asset((CurrentThemeKey == "STANDARD") ? 'assets/images/logo_standard.png' : ((CurrentThemeKey == "LIGHT") ? 'assets/images/logo_light.png' : 'assets/images/logo_cowabunga.png')      ),
  
          ),          
          
          Spacer(),
          // Container of the buttons to go to the other pages (not including about)
          Container(
            decoration: new BoxDecoration(
              borderRadius: new BorderRadius.only(
                topLeft: const Radius.circular(0.0),
                topRight: const Radius.circular(10.0),
                bottomLeft: const Radius.circular(0.0),
                bottomRight: const Radius.circular(10.0),
              ),
            ),
            padding: EdgeInsets.all(10),
            width: 340,
            height: 270,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                ButtonTheme(
                  minWidth: 110.0,
                  child: FlatButton(
                    child: Text('PLAY', style: ThemeTextStyle_Map[CurrentThemeKey].MenuTextStyle,),
                    onPressed: () => {
                      AudioCache().play('audio/button_press.mp3', mode: PlayerMode.LOW_LATENCY),
                      Navigator.popAndPushNamed(context, '/game'),
                      }
                  ),
                ),
                 ButtonTheme(
                  minWidth: 240.0,
                  child: FlatButton(
                    child: Text("SETTINGS", style: ThemeTextStyle_Map[CurrentThemeKey].MenuTextStyle),
                    onPressed: () => {
                      AudioCache().play('audio/button_press.mp3'),
                      Navigator.pushNamed(context, '/settings'),
                    }
                  ),
                ),
                ButtonTheme(
                  minWidth: 340.0,
                  child: FlatButton(
                    child: Text('HIGH SCORES', style: ThemeTextStyle_Map[CurrentThemeKey].MenuTextStyle,),
                    onPressed: () => {
                      AudioCache().play('audio/button_press.mp3', mode: PlayerMode.LOW_LATENCY),
                      Navigator.pushNamed(context, '/high_scores'),
                    }
                  ),
                ),
              ],
            ),
          ),
        ],
      )
    );
  }
}