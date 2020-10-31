import 'package:flutter/material.dart';
import 'dart:math';

import 'package:audioplayers/audio_cache.dart'; // For playing sound effects
import 'package:audioplayers/audioplayers.dart'; // For PlayerMode.LOW_LATENCY

import 'package:Tetra/game/game_placepiece.dart';
import 'package:Tetra/game/game_grid.dart';
import 'package:Tetra/game/RoundTimer.dart';
import 'package:Tetra/game/pause_menu.dart';
import 'package:Tetra/theme.dart';
import 'package:Tetra/bg_audio.dart'; // For the background music


// This widget handles gameplay, displaying the grids, accepting user input with option to pause game, tracking score, and managing the timer
class PlayArea extends StatefulWidget{
  Function(int score) endState; // A method given from the page that is for handling the game over
  // Constructor, sets topGrid and bottomGrid to new Grids, endState as a function to call when game over is made
  PlayArea({Key key, this.endState});

  _PlayAreaState createState() => _PlayAreaState();
}

class _PlayAreaState extends State<PlayArea> {
  GameGrid topGrid, bottomGrid; // The grids PlayZone uses
  Duration roundTime; // How long a round is before the piece is forcibly placed randomly up or down
  RoundTimer timer; // Handles the timer in each round

  bool paused = false; // When paused the playArea the timer is stopped and the grids/piece are hidden from view
  double itemX, itemY; // The X, Y coordinates of the PlacePiece widget

  int itemSelection; // Used to choose what item shape is
  int currentScore; // The score during this game
  PlacePiece item; // item for what the current PlacePiece being used is
  bool lastWasUp;

  BgMusicTrackPlayer musicPlayer;

  // The initial state of the PlayArea game
  @override
  initState() {
    super.initState();

    topGrid = new GameGrid();
    bottomGrid = new GameGrid();
     // Default to middle of width and height
    itemX = GridDimW*SizeDim / 4;
    itemY = SizeDim*4.5/10;
    // itemSelection is a random value for an index within PieceList (a list of valid pieces globally accessible found in game_placepiece.dart) for a new piece
    itemSelection = new Random().nextInt(PieceList.length);
    item = PieceList[itemSelection];
    currentScore = 0;    // Initial score is 0 
    lastWasUp = false;
    // music audio file starts playing when BgMusicTrackPlayer constructor is called
    String song;
    switch(MusicSelection){
      case("SYNTH"):
        song = 'audio/Gliding.mp3';
        break;
      case("OBNOXIOUS"):
        song = 'audio/Obnoxious_Market.wav';
        break;
      case("INSTRUMENTAL"):
        song = 'audio/Astral_Journey.mp3' ;
        break;
    }
    (MusicSelection != "NONE") ? musicPlayer = BgMusicTrackPlayer(song) : musicPlayer = null;

    roundTime = Duration(seconds: 10);
    timer = RoundTimer(roundTime, roundTimeout(), callback);
  }
  @override
  void dispose(){
    super.dispose();
    timer.close();
    (MusicSelection != "NONE") ? musicPlayer.release() : null;
  }

  // The round given to the player before a placement is forced, the duration gets smaller dependent on score with a minimum time of 1 second
  Duration getNewRoundTime(){
    int result = 10000;
    switch(Difficulty){
      case("EASY"):
        result -= currentScore*8;
        break;
      case("NORMAL"):
        result -= (currentScore*12 + 1000);
        break;
      case("HARD"):
        result -= (currentScore*24 + 1000);
        break;
    }
    // The minimum time regardless of difficulty is 1000 milloseconds (1 second)
    if (result < 1000){
      result = 1000;
    }
    return Duration(milliseconds: result);
  }

  bool outOfBounds()=> ((itemX / (SizeDim) + item.leftMostColumn()) < 0 || (itemX / (SizeDim) + item.rightMostColumn()) > GridDimW-1);

  // Called when the user wants to pause the game
  void pauseGame() { setState(() => {
      paused = paused ? false : true,                        // Set the bool to false if current true, and vice versa
      (paused) ? timer.pause() : timer.resume(),           // Pause/Resume the timer
    });
  }

  // Called when the user wants to end the game (not a game over by gameplay)
  void quitGame() {
    setState(() {
      widget.endState(currentScore);
    });
  }

  // Method to handle when making a placement, asyncronously
  // Input: Boolean for if the grid the piece is being sent to is downward or not
  // Output: the piece is successfully added into one of the grids and score is tallied, or if game over condition is reached the page's endState is called
  void makeMove(bool downward) {
    // First stop the timer to prevent a chance of accidental firing 
    timer.close();
    int placeResult;
    if (downward){
      int bottomColumnSelection = columnSelection((itemX / (SizeDim) + item.leftMostColumn()));
      placeResult = bottomGrid.place( item ,bottomColumnSelection);
    }
    else if (!downward){ 
      item.mirror();
      int topColumnSelection = columnSelection( (itemX / (SizeDim) + item.leftMostColumn()));
      placeResult = topGrid.place(item, topColumnSelection);
    }
    // Check to ensure that the game over condition wasn't reached (negative result indicates that)
    if (placeResult >= 0){
      itemX = GridDimW*SizeDim / 4;
      itemY = SizeDim*4.5/10;
      //https://api.flutter.dev/flutter/dart-math/Random-class.html
      itemSelection = new Random().nextInt(PieceList.length);
      item = PieceList[itemSelection];
      // The resulting score added is dependent on the difficulty
      if ( (lastWasUp && downward) || (!lastWasUp && !downward)){
        lastWasUp = (downward) ? false : true;
        placeResult *= 2; // Double points if they alternated from the other grid
      }
      // The score added is modified by the difficulty selected
      switch(Difficulty){
        case("EASY"):
          currentScore += placeResult;
          break;
        case("NORMAL"):
          currentScore += placeResult*2.5 ~/ 2;
          break;
        case("HARD"):
          currentScore += placeResult*3;
          break;
      }

      // Now that the move was made, time to reset the timer but with a new roundLength
      AudioCache().play('audio/place.wav', mode: PlayerMode.LOW_LATENCY);
      roundTime = getNewRoundTime();
      timer = new RoundTimer(roundTime, roundTimeout(), callback);
    }
    else { // If placeResult is negative, then game over
      AudioCache().play('audio/game_over.mp3', mode: PlayerMode.LOW_LATENCY);
      widget.endState(currentScore); // Call the endstate, with current score as argument
    }
  }

  // Takes in a double value that is the x coordinate of the piece
  // Returns which column the left most is when placing it
  int columnSelection(double xValue){
    // Get the decimals left of the decimal point
    double decRemainder = xValue - xValue.floor();
    int columnChosen;
    // Do rounding to the nearest whole number
    if (decRemainder >= 0.5) columnChosen = xValue.floor()+1;
    else  columnChosen = xValue.floor();
    // If the columnChosen is actually out of bounds after rounding, set to the max or min values allowed
    if (columnChosen < 0)
      columnChosen = 0;
    if (columnChosen >= GridDimW)
      columnChosen = GridDimW-1;
    // Return result
    return columnChosen;
  }

  // When the timer runs out, this method is used to make a random move and reset the timer for new round
  void Function() roundTimeout() {
    return () => setState(() => {
      makeMove( new Random().nextInt(2) == 1 ? true : false   ),
    });
  }

  // A callback for updating the screen, also makes sure that the item is not out of bounds horizontally
  void callback() => setState(() => {
    if ( (itemX + item.leftMostColumn()*SizeDim ) < 0   ){
      itemX = 0,
    }
    else if ((itemX + item.rightMostColumn()*SizeDim > (GridDimW-1)*SizeDim)){
      itemX = (GridDimW-1)*SizeDim - item.rightMostColumn()*SizeDim,
    }
  });

  // The build() method
  Widget build(BuildContext context){
    return Column (
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: <Widget>[
          Padding(padding: EdgeInsets.all(5)),
          // Row for Pause and score
          Row(
            children: <Widget>[
              Padding(padding: EdgeInsets.symmetric(horizontal: 35 )),
              // Game Pause Button, also pauses music
              FlatButton(
                child: Icon( (paused) ? Icons.play_arrow : Icons.pause, size: 40, color: ThemeColors_Map[CurrentThemeKey].ContrastColor),
                onPressed: () => pauseGame(),
              ),
              // Music mute button, only showed if the music selection wasnt' NONE
              (MusicSelection != "NONE") ? FlatButton(
                child: Icon( Icons.music_note, size: 40, color: ThemeColors_Map[CurrentThemeKey].ContrastColor),
                onPressed: () => {
                  (MusicSelection != "NONE") ? (( musicPlayer.isPaused) ? musicPlayer.resume() : musicPlayer.pause() ): null,
                }
              ) : Container(width: 80,),
              Padding(padding: EdgeInsets.symmetric(horizontal: 10 )),
              Text(
                "Score: " + currentScore.toString(),
                style: ThemeTextStyle_Map[CurrentThemeKey].SubTextStyle,
              ),
            ]
          ),

          // paused ? for if the game is paused, don't display the grid contents
          // The TopGrid display, rotated to display properly
          Transform(
            alignment: Alignment.center,
            transform: Matrix4.rotationX(pi),
            child: Container(
               width: GridDimW*SizeDim,
               height: GridDimH*SizeDim,
               color: (paused) ? ThemeColors_Map[CurrentThemeKey].GridBgColor : Colors.transparent,
               child: (paused) ? Container() : topGrid.widgetBuild(),
            ),
          ),

          // Input Row
          Row( 
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: <Widget>[
            // The User Input is setup to have a background color with the PlacePice that they interact with being on top
            Stack (children: [
              // Display timer, or if paused the text that says PAUSED
              Container(
                width: GridDimW*SizeDim,
                height: SizeDim*4.1,
                color: ThemeColors_Map[CurrentThemeKey].GridBgColor,
                child: (paused) ? Center(child: PauseMenu(pauseCall: pauseGame, quitCall: quitGame))
                                
                                
                                : timer.display(GridDimW*SizeDim, SizeDim*4.1),
              ),

              // The PlacePiece is a child of a positioned GesetureDetector with dynamic position itemY and itemX
              // If game is paued, do not build the positioned piece
              (paused) ? Container() : Positioned(
                top: 2.05,
                left: itemX,
                child: GestureDetector(
                  behavior: HitTestBehavior.translucent,
                  child: item,
                  //https://stackoverflow.com/questions/54238808/flutter-gesturedetector-detect-the-direction-of-horizontal-and-vertical-drag
                  onHorizontalDragUpdate: (details) {
                    setState(() {
                      itemX += (details.delta.dx);
                      if ( outOfBounds() ) {
                        itemX -= (details.delta.dx ) ;
                      }
                    });
                  },
                  onVerticalDragEnd: (details) {
                    if (details.primaryVelocity > 15){ // If the movement is downward, send the grid upward
                      setState(() => makeMove(true) );
                    }
                    else if (details.primaryVelocity < -15){ // If the movement is upward, send the grid upward
                      setState(() => makeMove(false) );
                    }
                  },
                ),
              )
          ]),
        ],),

        // paused ? for if the game is paused, don't display the grid or piece
        // Bottom Grid display
        Container(
          width: GridDimW*SizeDim,
          height: GridDimH*SizeDim,
          color: (paused) ? ThemeColors_Map[CurrentThemeKey].GridBgColor : Colors.transparent,
          child: (paused) ? Container() : bottomGrid.widgetBuild(),
        ),
      ]);
  }
}