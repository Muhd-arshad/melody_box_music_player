import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer_flutter/model/model_musicplayer.dart';

class ResetController extends ChangeNotifier {
  Future<void> resetAPP(context) async {
    final playListDb = Hive.box<MusicPlayer>('playlistDb');
    final musicDb = Hive.box<int>('FavoriteDB');
    final recentDb = await Hive.openBox('recentPlayedsong');
    final mostlyPlayedDb = await Hive.openBox('mostlyPlayedDb');
    await musicDb.clear();
    await recentDb.clear();
    await playListDb.clear();
    await mostlyPlayedDb.clear();
    Navigator.of(context).pushNamedAndRemoveUntil(
      '/screenSplash',
      (route) => false,
    );
  }
}
