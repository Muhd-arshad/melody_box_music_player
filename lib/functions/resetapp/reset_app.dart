 import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer_flutter/functions/db/favouritedb/favouritedb_functions.dart';
import 'package:musicplayer_flutter/functions/db/model/model_musicplayer.dart';
import 'package:musicplayer_flutter/screen/splashScreen/splash_screen.dart';

Future<void> resetAPP(context) async {
    final playListDb = Hive.box<MusicPlayer>('playlistDb');
    final musicDb = Hive.box<int>('FavoriteDB');
   final recentDb = await Hive.openBox('recentPlayedsong');
    final mostlyPlayedDb = await Hive.openBox('mostlyPlayedDb') ;
    await musicDb.clear();
    await recentDb.clear();
    await playListDb.clear();
    await mostlyPlayedDb.clear();
   

    FavouriteDb.favouriteSongs.value.clear();
    Navigator.of(context).pushAndRemoveUntil(
        MaterialPageRoute(
          builder: (context) => const ScreenSPlash(),
        ),
        (route) => false);
  }