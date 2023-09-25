import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer_flutter/view/home/home_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';
class RecenetsongPlayedprovider extends ChangeNotifier{

List<SongModel>recentList=[];
static List<dynamic> recentlyPlayed=[];

 Future<void> addrecentlyplayed (songid) async{
final recentDb=await Hive.openBox('recentPlayedsong');

await recentDb.add(songid);
//displayRecent();
await getrecentsong();
notifyListeners();

}

 Future <void>getrecentsong()async{
  final recentDb=await Hive.openBox('recentPlayedsong');
 recentlyPlayed= recentDb.values.toList();
await displayRecent();
notifyListeners();
}

 Future<void>displayRecent() async{
  final recentDb=await Hive.openBox('recentPlayedsong');
  final recentSongitem=recentDb.values.toList();

  recentList.clear();
  recentlyPlayed.clear();
  for (var i = 0; i < recentSongitem.length; i++) {
    for (var j = 0; j < startSongs.length; j++) {
      if (recentSongitem[i]==startSongs[j].id) {
        recentList.add(startSongs[j]);
        recentlyPlayed.add(startSongs[j]);
      }
  
    }
    
  }
}

 recent() async {
   await getrecentsong();
   }

}