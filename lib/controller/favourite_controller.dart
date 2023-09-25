import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';

class Favouriteprovider extends ChangeNotifier{
  static bool isIntialized = false;
  List<SongModel> favouriteSongs =[];
  static final musicDb = Hive.box<int>('FavoriteDB');
  

  initialize(List<SongModel>songs){
    for(SongModel song in songs){
      if(isFavour(song)){
        favouriteSongs.add(song);
      }
    }
    isIntialized=true;
  }

   isFavour(SongModel song){
    if(musicDb.values.contains(song.id)){
   
      return true;
    }
  
    return false;
    
  }

    add(SongModel song)async{
    musicDb.add(song.id);
    favouriteSongs.add(song);
    notifyListeners();
  }

   delete(int id)async{
     int deleteKey =0;
     if(!musicDb.values.contains(id)){
      return;
     }
     final Map<dynamic,int> favourMap =musicDb.toMap();
     favourMap.forEach((key, value) { 
      if(value==id){
        deleteKey =key;
      }
      notifyListeners();
     });
     musicDb.delete(deleteKey);
     favouriteSongs.removeWhere((song) => song.id==id);
     notifyListeners();
    
  }

   clear()async{
    Favouriteprovider.musicDb.clear();
    notifyListeners();
  }
}
