import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/utils/color_const.dart';
import 'package:musicplayer_flutter/controller/playlist_controller.dart';
import 'package:musicplayer_flutter/model/model_musicplayer.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class PlaylistAddSong extends StatelessWidget {
  const  PlaylistAddSong({super.key, required this.playlist});
  final MusicPlayer playlist;
  //final bool isPlaying = true;

  

  @override
  Widget build(BuildContext context) {
    final OnAudioQuery audioQuery = OnAudioQuery();
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text(
          "Add songs",
          style: TextStyle(color: secondaryCOlor),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: secondaryCOlor,
          ),
        ),
      ),
      body: FutureBuilder<List<SongModel>>(
        future: audioQuery.querySongs(
            sortType: null,
            orderType: OrderType.ASC_OR_SMALLER,
            uriType: UriType.EXTERNAL,
            ignoreCase: true),
        builder: (context, item) {
          if (item.data == null) {
            return const Center(
              child: CircularProgressIndicator(),
            );
          }
          if (item.data!.isEmpty) {
            return const Center(
              child: Text('No songs availble'),
            );
          }
          return ListView.separated(
            padding: const EdgeInsets.all(10),
            shrinkWrap: true,
            itemBuilder: (
              BuildContext context,
              int index,
            ) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 2, horizontal: 8),
                child: ListTile(
                  leading: const CircleAvatar(
                    backgroundImage: AssetImage('assets/images/music-note.png'),
                  ),
                  title: Text(
                    item.data![index].displayNameWOExt,
                    maxLines: 1,
                    style: const TextStyle(color: secondaryCOlor),
                  ),
                  subtitle: Text(
                    item.data![index].artist.toString(),
                    maxLines: 1,
                    style: const TextStyle(color: secondaryCOlor),
                  ),
                  trailing: SizedBox(
                    height: 60,
                    width: 60,
                    child: Consumer<PlaylistProvider>(
                        builder: (context, playListController, child) {
                      return Container(
                        child: !playlist.isValueIn(item.data![index].id)
                            ? IconButton(
                                onPressed: () {
                                  playListController.songAddToPlaylist(
                                      item.data![index],
                                      playlist,
                                      context);
                                },
                                icon: const Icon(Icons.add,
                                    color: secondaryCOlor),
                              )
                            : IconButton(
                                onPressed: () {
                                  playListController.songDeleteFromPlaylist(
                                      item.data![index],
                                      context,
                                      playlist);
                                },
                                icon: const Icon(
                                  Icons.remove,
                                  color: secondaryCOlor,
                                ),
                              ),
                      );
                    }),
                  ),
                ),
              );
            },
            separatorBuilder: (context, index) => const Divider(),
            itemCount: item.data!.length,
          );
        },
      ),
    );
  }
}
