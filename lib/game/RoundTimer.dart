import 'package:flutter/material.dart';
import 'dart:async';

//https://api.flutter.dev/flutter/dart-async/Timer-class.html
// Currently only accurrate within every 10 milliseconds
// A custom class for handling the timer within a round of gameplay (between placing pieces), made so allowing pausing the timer and accessing how much time has passed since starting
class RoundTimer {
  Timer secondsTimer;
  int elapsedMilliSeconds;
  Duration roundLength;
  void Function() callEvent; // What function is called when times is up

  void Function() update; // What function is called to notify that time is passing (used for displaying time left)

  // Constructor, elapsedMilliseconds is set to 0 (since no time has passed at the start) and new Timer is automatically set with 10 millisecond intervals
  // to track passage of time until set roundLength is reached
  RoundTimer(this.roundLength, this.callEvent, this.update){
    elapsedMilliSeconds = 0;
    secondsTimer = new Timer( Duration(milliseconds: 10), increment);
  }

  // Called every 10 milliseconds, increments the counter and checks to see if it's time to call the callEvent(), also calls update() every time
  increment(){ 
    secondsTimer.cancel();
    elapsedMilliSeconds += 10;
    secondsTimer = new Timer( Duration(milliseconds: 10), increment);
    if (elapsedMilliSeconds >= roundLength.inMilliseconds){
      callEvent();
    }
    update(); // Notify that time is passing
  }

  // Resets the timer to have no elapsed time
  reset(){
    secondsTimer.cancel();
    elapsedMilliSeconds = 0;
    secondsTimer = new Timer( Duration(milliseconds: 10), increment);
  }

  // When the timer is no longer to be used
  close(){
    secondsTimer.cancel();
    callEvent = null;
  }

  // Stop the incrementation to roundLength, but save elapsed time and callEvent
  pause() => secondsTimer.cancel();

  // Used after pausing, continues the timer from where last left off
  resume() => secondsTimer = new Timer( Duration(milliseconds: 10 ), increment);

  // Returns a widget that is to display how much time is left before the event is called, two red bars filling from opposite sides with gap inbetween
  // Input is dimensions that the widget can fill, assumed to be atleast 40 in height
  Widget display(double width, double height){
    double perc_timeLeft = (roundLength.inMilliseconds - elapsedMilliSeconds)/(roundLength.inMilliseconds);
    return Column(
      children: <Widget>[
        Row(
          children: <Widget>[
            Container(
              color: Colors.red,
              height: 20, 
              width: width - width*(perc_timeLeft),
            ),
            Spacer(),
          ],
        ),
        Padding(padding: EdgeInsets.only(top: height - 40),),
        Row(
          children: <Widget>[
            Spacer(),
            Container(
              color: Colors.red,
              height: 20, 
              width: width - width*(perc_timeLeft),
            ),
          ],
        ),
      ],);
  }
}