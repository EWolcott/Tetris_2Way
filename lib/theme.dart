import 'package:flutter/material.dart';

// The three themes available to the user
var ThemeNames = ["STANDARD", "LIGHT", "COWABUNGA"];

var CurrentThemeKey = "STANDARD"; // A global variable that is a key to one of objects in Theme_Map, changed by the Settings Page to change the global theme of the app, when starting it defaults to STANDARD

// The difficulty setting made, later should be placed in seperate more related file
var Difficulty = "NORMAL";

// The music selection to play based on settings, later should be placed in seperate more related file
var MusicSelection = "SYNTH";

// An object for storing a the various colors used in the different theme options
class ThemeColors {
  // The colors used that are not tied to a specific widget constructor
  var BgColor; // The background color of pages
  var ContrastColor; // A color to contrast against the background
  var GridBgColor; // Color for the grid when empty or paused

  // The constructor
  ThemeColors(this.BgColor, this.ContrastColor, this.GridBgColor);
}

// A global map for the various colors avaliable to be used throughout the app
var ThemeColors_Map = {
  ThemeNames[0]: 
    ThemeColors(
      Colors.black,
      Colors.white,
      Color.fromARGB(200, 40, 40, 40),
    ),
  ThemeNames[1]: 
    ThemeColors(
      Colors.white,
      Colors.red,
      Color.fromARGB(50, 40, 40, 40),
    ),
  ThemeNames[2]: 
    ThemeColors(
      Colors.deepPurple, 
      Colors.redAccent,
      Color.fromARGB(200, 60, 40, 80),
    ),
};

// An object for storing a the various TextStyles used in the different theme options
class ThemeTextStyle {
  // For how text is displayed, from font to color
  var TextStyle;     // For normal text, in settings page this is the label for the setting buttons
  var SubTextStyle;  // For exampple in settings page, SubTextStyle is the smaller text below the label of setting buttons
  var AltTextStyle;  // For example in score submission page, AltTextColor is used for the font in name submission field
  var ListTextStyle; // For leaderboard's list of scores
  var MenuTextStyle;

  ThemeTextStyle(this.TextStyle, this.SubTextStyle, this.AltTextStyle, this.MenuTextStyle,this.ListTextStyle, );
}

// A global map for the various textStyles avaliable to be used throughout the app
var ThemeTextStyle_Map = {
  ThemeNames[0]: 
    ThemeTextStyle(
      TextStyle(fontSize: 64, color: Colors.white, fontFamily: 'tccb'),  // TextStyle
      TextStyle(fontSize: 24, color: Colors.white, fontFamily: 'tccb'),  // SubTextStyle
      TextStyle(fontSize: 24, color: Colors.purple, fontFamily: 'tccb'), // AltTextColor
      TextStyle(fontSize: 60, color: Colors.white, fontFamily: 'tccb',), // MenuTextStyle
      TextStyle(fontSize: 40, color: Colors.white, fontFamily: 'tccb',), // ListTextStyle
    ),
  ThemeNames[1]: 
    ThemeTextStyle(
      TextStyle(fontSize: 64, color: Colors.black, fontFamily: 'tccb'), // TextStyle
      TextStyle(fontSize: 24, color: Colors.black, fontFamily: 'tccb'), // SubTextStyle
      TextStyle(fontSize: 24, color: Colors.black, fontFamily: 'tccb'), // AltTextColor
      TextStyle(fontSize: 60, color: Colors.black, fontFamily: 'tccb',),// MenuTextStyle
      TextStyle(fontSize: 40, color: Colors.black, fontFamily: 'tccb',),// ListTextStyle
    ),
  ThemeNames[2]: 
    ThemeTextStyle(
      TextStyle(fontSize: 64, color: Colors.green, fontFamily: 'tccb'), // TextStyle
      TextStyle(fontSize: 24, color: Colors.green,fontFamily: 'tccb'), // SubTextStyle
      TextStyle(fontSize: 24, color: Colors.yellow,   fontFamily: 'tccb'), // AltTextColor
      TextStyle(fontSize: 60, color: Colors.red,   fontFamily: 'tccb'), // MenuTextStyle
      TextStyle(fontSize: 40, color: Colors.green, fontFamily: 'tccb'), // ListTextStyle
    ),
};
// An object for storing a the various assets used in the different theme options, currently just the game background images
class ThemeAssets {
  var GameBgImage;
  
  ThemeAssets(this.GameBgImage);
}

// A global map for the various assets (images and videos) avaliable to be used throughout the app
var ThemeAssets_Map = {
  ThemeNames[0]: 
    ThemeAssets(
      'assets/images/standard_bg.png',
    ),
  ThemeNames[1]:
    ThemeAssets(
      'assets/images/greybg.png',
    ),
  ThemeNames[2]:
    ThemeAssets(
      'assets/images/sewer_bg.png',
    ),
};