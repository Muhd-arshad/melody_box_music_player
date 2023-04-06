import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer_flutter/screen/home/home_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class RecenetsongPlayed extends ChangeNotifier {
  static ValueNotifier<List<SongModel>> recentsongNotifier = ValueNotifier([]);
  static List<dynamic> recentPlayedSong = [];

  static Future<void> addRecentPlayedSong(item) async {
    final recentDb = await Hive.openBox('recentPlayedsong');
    await recentDb.add(item);
    getRecentSongs();
    recentsongNotifier.notifyListeners();
  }

  static Future<void> getRecentSongs() async {
    final recentDb = await Hive.openBox('recentPlayedsong');
    recentPlayedSong = recentDb.values.toList();
    displayRecentlyPlayed();
    recentsongNotifier.notifyListeners();
  }

  static Future<void> displayRecentlyPlayed() async {
    final recentDb = await Hive.openBox('recentPlayedsong');
    final recentlyPlayedItems = recentDb.values.toList();
    recentsongNotifier.value.clear();
    recentPlayedSong.clear();
    for (int i = 0; i < recentlyPlayedItems.length; i++) {
      for (int j = 0; j < startSongs.length; j++) {
        if (recentlyPlayedItems[i] == startSongs[j].id) {
          recentsongNotifier.value.add(startSongs[j]);//ui refress avan
          recentPlayedSong.add(startSongs[j]);
          
        }
      }
    }
  }
  
}
