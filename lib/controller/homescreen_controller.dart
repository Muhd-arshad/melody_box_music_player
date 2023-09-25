import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class HomeController extends ChangeNotifier{
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  List<SongModel> allSongs = [];
   bool _list = false;

  bool get list => _list;

  void toggleList() {
    _list = !_list;
    notifyListeners();
  }
   void requestPermission() async {
   
    bool permissionStatus = await audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await audioQuery.permissionsRequest();
      notifyListeners();
    }
    Permission.storage.request();
  }
 playsong(String? uri) {
    audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(uri!),
      ),
    );
    audioPlayer.play();
    notifyListeners();
  }
}