import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import 'package:Tetra/pages/menu_page.dart';
import 'package:Tetra/pages/settings_page.dart';
import 'package:Tetra/pages/hs_page.dart';
import 'package:Tetra/pages/game_page.dart';
import 'package:Tetra/pages/about_page.dart';
void main() => runApp(MyApp());

// The Tetris 2 Way App
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    SystemChrome.setEnabledSystemUIOverlays([SystemUiOverlay.bottom]);
    return MaterialApp(
      title: 'Tetra Project',
      initialRoute: '/',
      routes: {
        '/': (context) => MainMenuPage(),
        '/settings': (context) => SettingsPage(),
        '/high_scores': (context) => HighScorePage(),
        '/game': (context) => GamePage(),
        '/about': (context) => AboutPage(),
      }
    );
  }
}