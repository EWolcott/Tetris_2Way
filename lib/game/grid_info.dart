import 'package:flutter/material.dart';

// Object for the grid as a way of storing not only if filled but also the color for that square
class GridInfo {
  bool filled; // True means that it is filled
  Color fill_color; // If filled, this will provide what color the container when displayed should be

  // Default constructor
  GridInfo(){
    filled = false;
    fill_color = Colors.transparent;
  }
}