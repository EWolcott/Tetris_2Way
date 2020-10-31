import 'package:flutter/material.dart';

import 'package:Tetra/settings_button.dart';
import 'package:Tetra/theme.dart';

import 'package:audioplayers/audio_cache.dart'; // For button press sound effects
import 'package:audioplayers/audioplayers.dart'; // For PlayerMode.LOW_LATENCY

// Setting Page that is stateful so it responds to when user makes changes to the settings
class SettingsPage extends StatefulWidget {
  SettingsPage({Key key}) : super(key: key);
  @override
  _SettingsPageState createState() => _SettingsPageState();
}

class _SettingsPageState extends State<SettingsPage> {
  // The lists for the different avaliable options, theme's is accessed by the global map rather than a provided list here
  var _settingMusic =      ["OBNOXIOUS", "INSTRUMENTAL", "SYNTH", "NONE"];
  var _settingDifficulty = ["EASY", "NORMAL", "HARD"];



  // A callback for to give to the Setting Buttons for when the screen needs to be updated (such as Theme)
  void callback() {
    setState(() {});
  }


  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: ThemeColors_Map[CurrentThemeKey].BgColor,
      body: Stack (
        children: <Widget> [
          Center(
            child: Column (
              children: <Widget> [        
                Padding(padding: EdgeInsets.all(8),),
                // Header Row
                Row(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: <Widget>[
                    FlatButton(
                      color: Colors.transparent,
                      child: Icon(Icons.arrow_back, size: 40, color: ThemeColors_Map[CurrentThemeKey].ContrastColor),
                      //https://stackoverflow.com/questions/51071933/navigator-routes-clear-the-stack-of-flutter
                      onPressed: () =>{
                         AudioCache().play('audio/button_press.mp3', mode: PlayerMode.LOW_LATENCY),
                         Navigator.pushNamedAndRemoveUntil(context, '/', (r)=>false),
                      } 
                      
                    ),
                    Padding(padding:EdgeInsets.all(8)),
                    Text("SETTINGS", style: ThemeTextStyle_Map[CurrentThemeKey].MenuTextStyle),
                  ],
                ),
                Padding(padding: EdgeInsets.all(20),),
                // The three setting buttons for the preference
                SettingButton(label: "THEME", currentSetting: CurrentThemeKey, options: ThemeColors_Map.keys.toList(), update: callback,),
                        
                Padding(padding: EdgeInsets.all(20),),
                SettingButton(label: "MUSIC", currentSetting: MusicSelection, options: _settingMusic, update: callback,),

                Padding(padding: EdgeInsets.all(20),),
                SettingButton(label: "DIFFICULTY", currentSetting: Difficulty, options: _settingDifficulty, update: callback,),

                Padding(padding: EdgeInsets.all(20),),  
             ]
            )
          )
        ]
      )
    );
  }
}