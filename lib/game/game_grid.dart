import 'package:flutter/material.dart';

import 'package:audioplayers/audio_cache.dart'; // For sound effects
import 'package:audioplayers/audioplayers.dart'; // For PlayerMode.LOW_LATENCY

import 'package:Tetra/game/grid_info.dart';
import 'package:Tetra/game/game_placepiece.dart';


const GridDimH = 8; // For determining the height of the grid 
const GridDimW = 12; // For determining the width of the grid 

// Object for the two grids a game would have that handles receiving a placepiece to place in the grid
class GameGrid {
  List<List<GridInfo>> grid; // The grid is a 2D List of GridInfo

  // Used by place(), this checks for filled rows to be resolved and returns score for any that were completely filled/removed
  int clearRow(){
    bool filled; // Boolean for if the row is completely filled
    int score = 0; // integer value score result of clearing rows (0 if none cleared)
    for (int r = 0; r < GridDimH; r++) {
      filled = true;
      for (int c = 0; c < GridDimW; c++){
        if (grid[c][r].filled == false){
          filled = false;
          break;
        }
      }
      // If row r is filled, we must remove it and add a a new row 
      if (filled){
        // Due to the structure of the grid with it as a list of columns, we must iterate through each column and remove the row element and insert a new one at index 0 (making it appear that the row was cleared and the pieces "above" lowered down to fill in its place)
        for (int f_c = 0; f_c < GridDimW; f_c++){
          grid[f_c].removeAt(r);
          grid[f_c].insert(0, new GridInfo());
        }
        r = r -1; // Back up to make sure we don't skip a filled row due to the remove offset
        
        score *= 2; // Combo, score from previous filled rows during the same instance are doubled along with the addition followed
        score += r*3;
      }
    }
    // Return result of clearRow (0 if no rows were cleared)
    return score;
  }

  // col is left msot column being used, row is top most row being used, piece is piece being used 
  int assign(int refCol, int refRow, PlacePiece piece){
    for (int y = piece.topMostRow(); y <= piece.bottomMostRow(); y++){
      for (int x = piece.leftMostColumn(); x <= piece.rightMostColumn(); x++){
        // If at pieceX,pieceY within the shape is filled and corresponding location in the grid being checked is also filled, set valid to false
        if (piece.shape[x][y]){
          var row = refRow + y - piece.topMostRow();
          var col = refCol + x - piece.leftMostColumn();
          this.grid[col][row].filled = true;
          this.grid[col][row].fill_color = piece.color;
        }
      }
    }
    int clearRowScore = clearRow();
    if (clearRowScore > 0){
      AudioCache().play('audio/clear.wav', mode: PlayerMode.LOW_LATENCY);
    }
    return refRow + clearRow();
  }

  // PlacePiece is assumed to be a 4x4 grid!
  // Input: PlacePiece that is to be added, pColumn that is the left most column that the piece occupies that ranges from 0 to GridDim
  // Output: Grid is updated accordingly with additional piece, returns an integer value reflects score/outcome of the attempt
  //  If output is -1, the placement led to a game over condition (height overflowed into out of bounds)
  //  Otherwise, the output is the score made by placing the piece
  int place(PlacePiece piece, int pColumn) {
    // Values for noting what columns and rows within piece are being used
    int pLeftCol   = piece.leftMostColumn();
    int pRightCol  = piece.rightMostColumn();
    int pTopRow    = piece.topMostRow();
    int pBottomRow = piece.bottomMostRow();

    // Now it's time to try and place the piece,
    bool placed = false;
    // Will be done via starting at the top of the grid and moving down until the last valid row is found (bottom possible row to check is the number of rows in the grid minus the number of rows that the piece occupies)
    for (int r = 0; r <= GridDimH-(pBottomRow - pTopRow + 1); r++){
      bool valid = true; // For row r, initially assume that the placement is valid until proven otherwise

      // We need to check through the relevant portion of piece.shape in relation to row r and left most column
      for (int pieceY = pTopRow; pieceY <= pBottomRow; pieceY++){
        for (int pieceX = pLeftCol; pieceX <= pRightCol; pieceX++){
          // If at pieceX,pieceY within the shape is filled and corresponding location in the grid being checked is also filled, set valid to false
          if (piece.shape[pieceX][pieceY] && grid[pColumn + pieceX - pLeftCol][r + pieceY - pTopRow].filled){
            valid = false;
            break;            
          }
        }
        // If we found this row is invalid, then break out of the check since more checking at this row is unnecessarry
        if (!valid) break;
      }

      // If we checked and it was valid, then we need to continue to the next row
      if (valid) continue;
      
      // Else if it was found to be invalid, then we now know that r-1 is valid placement
      else {
        if (r == 0){ // If it was invalid at the top most possible row, then actually the game over condition was reached
          return -1;
        }
        else { // r-1 >= 0 and so we can place it
          for (int pieceY = pTopRow; pieceY <= pBottomRow; pieceY++){
            for (int pieceX = pLeftCol; pieceX <= pRightCol; pieceX++){
              // If at pieceX,pieceY within the shape is filled and corresponding location in the grid being checked is also filled, set valid to false
              if (piece.shape[pieceX][pieceY]){
                return assign(pColumn, r-1, piece);
              }
            }
          }
          placed = true; // The piece has been successfully placed now
        }
      }  
    }  
    // If iterated through all the rows and never came across an invalid placement, then the bottom most row must be where it's placed
    if (!placed) {
      return assign(pColumn, GridDimH-(pBottomRow - pTopRow + 1), piece);
    }
    else {
      print("Something went wrong, went through entire loop without return and wasn't placed");
    }
  }


  // Return a row of containers that describe the grid's given row
  // Input is a row, assumed to be a valid address within the grid
  // Output is a row widget containing a list of colored containers depending on grid content
  BuildRow(int row){
    return Row(
      children: <Widget>[
        for (int i = 0; i < GridDimW; i++) Container(color:( grid[i][row].filled) ? grid[i][row].fill_color : Colors.white38, width: SizeDim, height: SizeDim, child: Image.asset("assets/images/tile.png",)),
      ],
    );
  }

  // A method that returns a widget display of the contents of the grid
  // Output is a column widget containing rows of colored containers depending on grid content
  widgetBuild(){
    return Column(
      children: <Widget>[
        for (int i = 0; i < GridDimH; i++) BuildRow(i),
      ],
    );
  }

  // The default constructor, sets grid to be a 2D list filled with 2D lists with dimensions based on GridDim with growable set to false for both dimensions
  GameGrid({Key key}) {
    //https://www.reddit.com/r/dartlang/comments/9z89b9/how_can_i_generate_a_2d_array/
    grid = List<List<GridInfo>>.generate(GridDimW, (y) => List<GridInfo>.generate(GridDimH, (x) => new GridInfo()));
  }
}