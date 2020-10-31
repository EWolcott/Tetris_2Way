import 'package:flutter/material.dart';

import 'package:audioplayers/audio_cache.dart'; // For playing sound effects
import 'package:audioplayers/audioplayers.dart'; // For PlayerMode.LOW_LATENCY

const double SizeDim = 31; // For determining how big the PlacePiece appears 

// Object for the various pieces the player would use in the game
class PlacePiece extends StatefulWidget {
  List<List<bool>> shape;
  Color color;

  PlacePiece({Key key, this.shape, this.color});
  
  // Return a value (between 0 and 3) that is the left most used column that occupies a true
  int leftMostColumn() {
    for (int col = 0; col < 4; col++){
      if (shape[col].contains(true)){
        return col;
      }
    }
    return 0;
  }

  // Return a value (between 0 and 3) that is the right most used column that occupies a true
  int rightMostColumn(){
    for (int col = 3; col >= 0; col--){
      if (shape[col].contains(true)){
        return col;
      }
    }
    return 3;
  }

  // Return a value (between 0 and 3) that is the top most used row that occupies a true
  int topMostRow(){
    for (int row = 0; row < 4; row++){
      if (shape[0][row] || shape[1][row] || shape[2][row] || shape[3][row]  )
        return row;
    }
    return 0;
  }

  // Return a value (between 0 and 3) that is the bottom most used row that occupies a true
  int bottomMostRow(){
    for (int row = 3; row >= 0; row--){
      if (shape[0][row] || shape[1][row] || shape[2][row] || shape[3][row]  )
        return row;
    }
    return 0;
  }

  // Rotate the contents of shape by 90 degrees
  //https://www.geeksforgeeks.org/inplace-rotate-square-matrix-by-90-degrees/ for seeing how to implement
  void rotate(){
    for (int x = 0; x < 2; x++){
      for (int y = x; y < 3 - x; y++){
        bool temp = shape[x][y];
        shape[x][y] = shape[y][3 - x];
        shape[y][3 - x] = shape[3 - x][3 - y];
        shape[3 - x][3 - y] = shape[3 - y][x];
        shape[3 - y][x] = temp;
      }
    }
    AudioCache().play('audio/rotate.mp3', mode: PlayerMode.LOW_LATENCY);
  }

  void mirror(){
    for (int x = 0; x < 4; x++){
      for (int y = 0; y < 2; y++){
        bool temp = shape[x][y];
        shape[x][y] = shape[x][3-y];
        shape[x][3-y] = temp;
      }
    }
  }


  // Return a row of container widgets with given column to show colors if filled 
  Widget PlacePieceRow(int row){
    return  Row(children: <Widget>[
        for (int i = 0; i < 4; i++) Container(color: (shape[i][row] == true) ? color : Colors.transparent, width: SizeDim, height: SizeDim, child:(shape[i][row] == true) ? Image.asset("assets/images/tile.png",): Container()),
      ],
    );
  }

  _PlacePieceState createState() => _PlacePieceState();
}

class _PlacePieceState extends State<PlacePiece> {
  Widget build(BuildContext context){
    return GestureDetector(
      behavior: HitTestBehavior.deferToChild,
      child: Column(
        children: <Widget>[
          for (int i = 0; i < 4; i++) widget.PlacePieceRow(i),
        ],
      ),
      onTap: () => {
        setState(() => {
          //not sure if rotate audio should be placed here or in the actual function
          //so i just put it in the function
          widget.rotate(),            
        }),
      }
    );
  }
}

// List of PlacePieces used in the game
List<PlacePiece> PieceList = 
  [ // Z shape
    new PlacePiece( shape: [
      [false,false,false,false],
      [ true, true,false,false],
      [false, true, true,false],
      [false,false,false,false],
      ], color: Colors.red,), 
    // O shape
    new PlacePiece( shape: [
      [false, false,false,false],
      [false,  true, true,false],
      [false,  true, true,false],
      [false, false,false,false],
    ], color: Colors.orange,),
    // L shape
    new PlacePiece( shape: [
      [false, true,false,false],
      [false, true,false,false],
      [false, true, true,false],
      [false,false,false,false],
    ], color: Colors.deepPurple, ),
    // J shape
    new PlacePiece( shape: [
      [false,false,false,false],
      [ true, true, true,false],
      [false,false, true,false],
      [false,false,false,false],
    ], color: Colors.green, ),
    // S shape
    new PlacePiece( shape: [
      [false,false,false,false],
      [false,false, true, true],
      [false, true, true,false],
      [false,false,false,false],
    ], color: Colors.yellow , ),
    // T shape
    new PlacePiece( shape: [
      [false,false,false,false],
      [false,false, true,false],
      [false, true, true, true],
      [false,false,false,false],
    ], color: Colors.indigo, ),
    // I shape
    new PlacePiece( shape: [
      [false,false,false,false],
      [false,false,false,false],
      [ true, true, true, true],
      [false,false,false,false],
    ], color: Colors.indigo,),

  ];