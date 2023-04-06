import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer_flutter/functions/db/model/model_musicplayer.dart';

class PlaylistDB {
  static ValueNotifier<List<MusicPlayer>> playlistNotifier = ValueNotifier([]);
  static final playlistDb = Hive.box<MusicPlayer>('playlistDb');

  static Future<void> addPlaylist(MusicPlayer value) async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDb');
    await playlistDb.add(value);
    playlistNotifier.value.add(value);
  }

  static Future<void> getAllPlaylist() async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDb');
    playlistNotifier.value.clear();
    playlistNotifier.value.addAll(playlistDb.values);
    playlistNotifier.notifyListeners();
  }

  static Future<void> editList(int index, MusicPlayer value) async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDb');
    playlistDb.putAt(index, value);
    getAllPlaylist();
  }
}
