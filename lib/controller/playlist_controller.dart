import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer_flutter/controller/song_controller.dart';
import 'package:musicplayer_flutter/model/model_musicplayer.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlaylistProvider extends ChangeNotifier {
  late List<SongModel> songPlaylist;
  // static ValueNotifier<List<MusicPlayer>> playlistNotifier = ValueNotifier([]);
  List<MusicPlayer> playlist = [];
  final playlistdb = Hive.box<MusicPlayer>('playlistDB');

  Future<void> addPlaylist(MusicPlayer value) async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDB');
    await playlistDb.add(value);
    playlist.add(value);
    notifyListeners();
  }

  Future<void> getAllPlaylist() async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDB');
    // playlistDb.clear();
    playlist.clear();
    playlist.addAll(playlistDb.values);
    notifyListeners();
  }

  Future<void> editList(int index, MusicPlayer value) async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDB');
    playlistDb.putAt(index, value);
    getAllPlaylist();
    notifyListeners();
  }

  Future<void> deletePlaylist(int index) async {
    final playlistDb = Hive.box<MusicPlayer>('playlistDB');
    getAllPlaylist();
    playlist.removeAt(index);
    playlistDb.deleteAt(index);
    notifyListeners();
  }
   void songDeleteFromPlaylist(SongModel data, context,MusicPlayer playlist) {
  
    playlist.deleteData(data.id);
    
    final removePlaylist = SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      width: MediaQuery.of(context).size.width * 3.5 / 5,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      content: const Center(
        child:  Text(
          'Song removed from Playlist',
          style: TextStyle(color: Colors.white),
        ),
      ),
      duration: const Duration(milliseconds: 550),
    );
    ScaffoldMessenger.of(context).showSnackBar(removePlaylist);
    notifyListeners();
  }
    List<SongModel> listPlaylist(List<int> data,BuildContext context) {
    final songController = context.read<SongController>();
    List<SongModel> plsongs = [];
    for (int i = 0; i < songController.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (songController.songscopy[i].id == data[j]) {
          plsongs.add(songController.songscopy[i]);
        }
      }
    }
    return plsongs;
  }
    void songAddToPlaylist(SongModel data, final MusicPlayer playlist,BuildContext context) {
  playlist.add(data.id);
    final addedToPlaylist = SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      width: MediaQuery.of(context).size.width * 3.5 / 5,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      content: const Text(
        'Song added to playlist',
        textAlign: TextAlign.center,
        style: TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 550),
    );
    ScaffoldMessenger.of(context).showSnackBar(addedToPlaylist);
    notifyListeners();
  }
}
