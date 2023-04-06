import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:musicplayer_flutter/screen/home/home_screen.dart';

class MostlyPlayed extends ChangeNotifier {
  static ValueNotifier<List<SongModel>> mostlyPlayedSongNotifier =
      ValueNotifier([]);
  static List<dynamic> mostlyPlayed = [];

  static Future<void> addmostlyPlayed(item) async {
    final mostlyplaydDb = await Hive.openBox('mostlyPlayedDb');
    await mostlyplaydDb.add(item);
    getMostlyPlayed();
    mostlyPlayedSongNotifier.notifyListeners();
  }

  static Future<void> getMostlyPlayed() async {
    final mostlyPlayedDb = await Hive.openBox('mostlyPlayedDb');
    mostlyPlayed = mostlyPlayedDb.values.toList();
    displayMostlyPlayed();
    mostlyPlayedSongNotifier.notifyListeners();
  }

  static List<dynamic> count = [];
  static Future<List> displayMostlyPlayed() async {
    final mostlyPlayedDb = await Hive.openBox('mostlyPlayedDb');
    final mostlyPlayedItems = mostlyPlayedDb.values.toList();
    mostlyPlayedSongNotifier.value.clear();
    int count = 0;
    for (var i = 0; i < mostlyPlayedItems.length; i++) {
      for (var j = 0; j < startSongs.length; j++) {
        if (mostlyPlayedItems[i] == startSongs[j].id) {
          count++;
        }
      }

      if (count > 3) {
        debugPrint('count>3anoo ${count}');
        for (var k = 0; k < startSongs.length; k++) {
          if (mostlyPlayedItems[i] == startSongs[k].id) {
            mostlyPlayedSongNotifier.value.add(startSongs[k]);
            mostlyPlayed.add(startSongs[k]);
          }
        }
        count = 0;
      }
    }
    return mostlyPlayed;
  }
}
