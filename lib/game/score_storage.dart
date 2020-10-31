import 'dart:io';

import 'package:path_provider/path_provider.dart';

import 'package:Tetra/game/score.dart';

// URL links to sources used in learning Flutter file i/o
//https://stackoverflow.com/questions/54122850/how-to-read-and-write-a-text-file-in-flutter
//https://medium.com/@suragch/reading-a-text-file-from-assets-in-flutter-af4cb6063a7a
//https://api.flutter.dev/flutter/dart-io/File-class.html
//https://flutter.dev/docs/cookbook/persistence/reading-writing-files#4-read-data-from-the-file
//https://www.youtube.com/watch?time_continue=350&v=Hqqz2BaPUis&feature=emb_title

// A class object for managing the file storage of the score lists
class ScoreStorage {
  ScoreStorage();

  Future<String> get localPath async {
    var dir = await getApplicationDocumentsDirectory();
    return dir.path;
  }

  Future<File> get localFile async {
    final path = await localPath;
    return File('$path/score.txt');
  }

  // A simple sort for the contents of a score list, order from highest scoreValue to lowest
  void sortList(List<Score> list) {
    bool sorted = false;
    while (!sorted) {
    sorted = true;
      for (int i = 0; i < list.length-1; i++){
        if (list[i].scoreValue < list[i+1].scoreValue){
          Score temp = list[i];
          list[i] = list[i+1];
          list[i+1] = temp;
          sorted = false;
        }
      }
    }
  }

  // Retrive the list of scores from the file, returning as a List of type Score
  Future<List<Score>> getScoreList() async {
    var _highscoreList = List<Score>();
    try {
      final fileString = (await localFile).readAsStringSync();

      // Parse through the string, first splitting by lines (character '\n') and then by the words
      // Assumed order the data is stored is name followed by the score, for loop for number of lines in the file
      List<String> lines = fileString.split('\n');
      for (int i = 0; i < lines.length-1; i++){

        List<String> words = lines[i].split(' ');
        String listingName = words[0];
        int listingValue = int.parse(words[1]);
        _highscoreList.add( Score(listingName, listingValue) );
      }
      // Sort list in case it was not saved in order
      sortList(_highscoreList);
      return _highscoreList;
    }
    catch(e){
      print('$e - Error in readScoreData() for ScoreStorage');
      return _highscoreList; // return what was retrieved at least
    }
  }
  // Method for saving a score, currently does not care about order, newest on end
  saveScore(Score newScore) async{
    List<Score> list = await getScoreList();
    list.add(newScore);
    print(list.toString());
    final file = await localFile;
    var result = '';
    for (int i = 0; i < list.length; i++){
      result += list[i].toString() + '\n';
    }
    await file.writeAsString(result);
  }
}