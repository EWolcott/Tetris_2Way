import 'package:flutter/material.dart';

import 'package:shared_preferences/shared_preferences.dart';
import 'package:audioplayers/audio_cache.dart'; // For button press sound effects
import 'package:audioplayers/audioplayers.dart'; // For PlayerMode.LOW_LATENCY

import 'package:Tetra/theme.dart';


// Properties and behaviors of the individual buttons in the settings page
class SettingButton extends StatefulWidget {
  final String label; // Describe what this button setting adjusts (example: Theme)
  var options = [];   // A list of the available options this button iterates through
  var currentSetting; // What the current item within the options list the setting is on
  void Function() update; // Function that is for notifying the parent that a change is made and update needs to be performed (on SettingsPage this is callbakc() )
  
  // Constructor
  SettingButton(
    {
    Key key,
    this.label = "",
    this.currentSetting = "",
    this.options,
    this.update,
    }
  ) : super(key: key);

  _SettingButtonState createState() => _SettingButtonState();  
}

class _SettingButtonState extends State<SettingButton> { 

  void setPref(String key, String value) async {
    final SharedPreferences prefs = await SharedPreferences.getInstance();
    prefs.setString(key, value);
  }

  Widget build(BuildContext context) {
    return FlatButton(
      color: Colors.transparent,
      child: Column(
        children: <Widget>[
          Text(widget.label, style: ThemeTextStyle_Map[CurrentThemeKey].TextStyle),
          Text(widget.currentSetting, style: ThemeTextStyle_Map[CurrentThemeKey].SubTextStyle),
        ],
      ),
      onPressed: () {
        AudioCache().play('audio/button_press.mp3', mode: PlayerMode.LOW_LATENCY);
        // When tapped, set currentSetting to next item on the list with loop back to index 0 if at end of list
        if (widget.options.indexOf(widget.currentSetting) == widget.options.length-1 )
          setState(() => widget.currentSetting = widget.options[0]);
          
        else setState(() => widget.currentSetting = widget.options[widget.options.indexOf(widget.currentSetting)+1]);
        // Then after changing the setting, make the changes to the respective global variables and preferences
        switch (widget.label){
          case("THEME"):
            CurrentThemeKey = widget.currentSetting;
            widget.update(); // Notify the SettingsPage to rebuild
            break;
          case("MUSIC"):
            MusicSelection = widget.currentSetting;
            break;
          case("DIFFICULTY"):
            Difficulty = widget.currentSetting;
            break;
        }
        // Update saved preference with current setting
        setPref(widget.label, widget.currentSetting);
      }
    );
  }
}