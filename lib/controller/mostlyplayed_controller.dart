import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer_flutter/view/home/home_screen.dart';
// import 'package:on_audio_query/on_audio_query.dart';

import 'package:on_audio_query/on_audio_query.dart';

class MostlyPlayedprovider with ChangeNotifier {
  List<SongModel> mostlyPlayedSong = [];
  List<dynamic> mostlyPlayed = [];

  Future<void> addmostlyPlayed(item) async {
    final mostlyplaydDb = await Hive.openBox('mostlyPlayedDb');
    await mostlyplaydDb.add(item);
    getMostlyPlayed();
    notifyListeners();
  }

  Future<void> getMostlyPlayed() async {
    final mostlyPlayedDb = await Hive.openBox('mostlyPlayedDb');
    mostlyPlayed.add(mostlyPlayedDb.values.toList());

    displayMostlyPlayed();
    notifyListeners();
  }

  Future<List> displayMostlyPlayed() async {
    final mostlyPlayedDb = await Hive.openBox('mostlyPlayedDb');
    final mostlyPlayedItems = mostlyPlayedDb.values.toList();
    mostlyPlayedSong.clear();
    int counts = 0;
    for (var i = 0; i < mostlyPlayedItems.length; i++) {
      for (var j = 0; j < startSongs.length; j++) {
        if (mostlyPlayedItems[i] == startSongs[j].id) {
          counts++;
        }
      }

      if (counts > 3) {
        for (var k = 0; k < startSongs.length; k++) {
          if (mostlyPlayedItems[i] == startSongs[k].id) {
            mostlyPlayedSong.add(startSongs[k]);
            mostlyPlayed.add(startSongs[k]);
          }
        }
        counts = 0;
      }
    }
    return mostlyPlayed;
  }
}
