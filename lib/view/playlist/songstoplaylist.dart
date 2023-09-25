import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer_flutter/controller/playlist_controller.dart';
import 'package:musicplayer_flutter/model/model_musicplayer.dart';
import 'package:musicplayer_flutter/view/playlist/playlist_pade_screen.dart';


import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

playlistDialogue(BuildContext context, SongModel songModel) {
  showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(20)),
          backgroundColor: Colors.white,
          title: const Text(
            'Select a Playlist',
            style: TextStyle(
              fontWeight: FontWeight.w500,
              fontSize: 18,
            ),
          ),
          content: SizedBox(
            height: 200,
            width: double.maxFinite,
            child: Consumer<PlaylistProvider>(
                
                builder: (contex, musicList, child) {
                  return Hive.box<MusicPlayer>('playlistDb').isEmpty
                      ? const Center(
                          child: Text(
                          'No Playlist found',
                          style: TextStyle(fontSize: 18),
                        ))
                      : ListView.builder(
                          itemCount: musicList.playlist.length,
                          itemBuilder: (context, index) {
                            final data = musicList.playlist.toList()[index];
                            return Card(
                              color: Colors.white,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(10),
                              ),
                              child: ListTile(
                                title: Text(data.name),
                                trailing: const Icon(Icons.playlist_add,
                                    color: Colors.black),
                                onTap: () {
                                  addSongToPlaylist(
                                      context, songModel, data, data.name);
                                },
                              ),
                            );
                          });
                }),
          ),
          actions: [
            TextButton(
              onPressed: () {
                nameController.clear();
                Navigator.pop(context);
                newplaylist(context, formKey);
              },
              child: const Text('New Playlist'),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              child: const Text('Cancel'),
            ),
          ],
        );
      });
}

void addSongToPlaylist(
    BuildContext context, SongModel data, datas, String name) {
  if (!datas.isValueIn(data.id)) {
    datas.add(data.id);
    final songAddSnackBar = SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.fixed,
        content: Text(
          "Song Added To $name",
          textAlign: TextAlign.center,
        ));
    ScaffoldMessenger.of(context).showSnackBar(songAddSnackBar);
    Navigator.pop(context);
  } else {
    final songAlreadyExist = SnackBar(
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        duration: const Duration(seconds: 1),
        behavior: SnackBarBehavior.fixed,
        content: Text(
          "Song Already exist In $name",
          textAlign: TextAlign.center,
        ));
    ScaffoldMessenger.of(context).showSnackBar(songAlreadyExist);
    Navigator.pop(context);
  }
}
