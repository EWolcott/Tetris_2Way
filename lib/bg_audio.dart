import 'package:audioplayers/audio_cache.dart';
import 'package:audioplayers/audioplayers.dart';


// Custom class for background music control using AudioPlayer's tool and additional properties
class BgMusicTrackPlayer {
  AudioPlayer player;
  bool isPaused;

  // Constructor
  BgMusicTrackPlayer(String file) {
    start(file);
    isPaused = false;
  }
  
  //https://stackoverflow.com/questions/56360083/stop-audio-loop-audioplayers-package for some insight into working with audioplayers
  start(String address) async => player = await AudioCache().loop(address, volume: 1);

  // Functions for BgMusicPlayer player access and adjust isPaused boolean as appriopriate
  void pause() {
    player.pause();
    isPaused = true; 
  }

  void resume() { 
    player.resume();
    isPaused = false;
  }

  void release() => player.release();
  bool getPaused() => isPaused;
}
