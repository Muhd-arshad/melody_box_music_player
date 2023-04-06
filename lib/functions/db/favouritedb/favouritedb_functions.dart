import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class FavouriteDb {
  static bool isIntialized = false;
  static final musicDb = Hive.box<int>('FavoriteDB');
  static ValueNotifier<List<SongModel>> favouriteSongs = ValueNotifier([]);

  static initialize(List<SongModel>songs){
    for(SongModel song in songs){
      if(isFavour(song)){
        favouriteSongs.value.add(song);
      }
    }
    isIntialized=true;
  }

  static isFavour(SongModel song){
    if(musicDb.values.contains(song.id)){
      return true;
    }
    return false;
  }

  static add(SongModel song)async{
    musicDb.add(song.id);
    favouriteSongs.value.add(song);
    FavouriteDb.favouriteSongs.notifyListeners();
  }

  static delete(int id)async{
     int deleteKey =0;
     if(!musicDb.values.contains(id)){
      return;
     }
     final Map<dynamic,int> favourMap =musicDb.toMap();
     favourMap.forEach((key, value) { 
      if(value==id){
        deleteKey =key;
      }
     });
     musicDb.delete(deleteKey);
     favouriteSongs.value.removeWhere((song) => song.id==id);
  }

  static clear()async{
    FavouriteDb.favouriteSongs.value.clear();
  }
}
