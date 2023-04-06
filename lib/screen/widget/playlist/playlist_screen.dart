import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer_flutter/const_files/color_const.dart';
import 'package:musicplayer_flutter/functions/db/model/model_musicplayer.dart';
import 'package:musicplayer_flutter/screen/playing_screen/nowplaying_screen.dart';
import 'package:musicplayer_flutter/screen/widget/playlist/playlistadd_song.dart';
import 'package:musicplayer_flutter/songController/song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenPlaylist extends StatelessWidget {
  const ScreenPlaylist({
    super.key,
    required this.playlist,
    required this.findex,
    this.image,
  });
  final MusicPlayer playlist;
  final int findex;
  // ignore: prefer_typing_uninitialized_variables
  final image;

  @override
  Widget build(BuildContext context) {
    late List<SongModel> songPlaylist;
    return ValueListenableBuilder(
      valueListenable: Hive.box<MusicPlayer>('playlistDb').listenable(),
      builder: (BuildContext context, Box<MusicPlayer> music, Widget? child) {
        songPlaylist = listPlaylist(music.values.toList()[findex].songId);
        return Scaffold(
          backgroundColor: bgColor,
          body: CustomScrollView(
            slivers: [
              SliverAppBar(
//pop button
                leading: IconButton(
                  icon: const Icon(
                    Icons.arrow_back,
                    color: Colors.white,
                    size: 32,
                  ),
                  onPressed: () {
                    Navigator.pop(context);
                  },
                ),
                actions: [
// Add song
                  IconButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => PlaylistAddSong(
                            playlist: playlist,
                          ),
                        ),
                      );
                    },
                    icon: const Icon(
                      Icons.add,
                      color: Colors.white,
                      size: 32,
                    ),
                  ),
                  const SizedBox(
                    width: 20,
                  )
                ],
                flexibleSpace: FlexibleSpaceBar(
                  centerTitle: true,
//Title
                  title: Text(
                    playlist.name,
                    style: const TextStyle(color: Colors.white),
                  ),
                  expandedTitleScale: 2.9,
                  background: Image.asset(
                    image,
                    fit: BoxFit.cover,
                  ),
                ),

                expandedHeight: MediaQuery.of(context).size.width * 2.5 / 4,
              ),
              SliverList(
                delegate: SliverChildListDelegate(
                  [
                    songPlaylist.isEmpty
                        ? Center(
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                InkWell(
                                  onTap: () {
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => PlaylistAddSong(
                                          playlist: playlist,
                                        ),
                                      ),
                                    );
                                  },
                                  child: const Icon(
                                    Icons.add_box,
                                    size: 50,
                                    color: secondaryCOlor,
                                  ),
                                ),
                                SizedBox(
                                  height:
                                      MediaQuery.of(context).size.height * .02,
                                ),
                                const Center(
                                  child: Text(
                                    'Add Songs To Your playlist',
                                    style: TextStyle(
                                        fontSize: 20, color: secondaryCOlor),
                                  ),
                                ),
                              ],
                            ),
                          )
                        : ListView.separated(
                            padding: const EdgeInsets.all(10),
                            shrinkWrap: true,
                            physics: const ScrollPhysics(),
                            itemBuilder: (context, index) {
                              return Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 2, horizontal: 10),
                                child: ListTile(
                                  leading: const CircleAvatar(
                                    backgroundImage: AssetImage(
                                        'assets/images/music-note.png'),
                                  ),
                                  title: Text(
                                    songPlaylist[index].displayNameWOExt,
                                    maxLines: 1,
                                    style:
                                        const TextStyle(color: secondaryCOlor),
                                  ),
                                  subtitle: Text(
                                    songPlaylist[index].artist.toString(),
                                    maxLines: 1,
                                    style:
                                        const TextStyle(color: secondaryCOlor),
                                  ),
                                  trailing: SizedBox(
                                    width: 60,
                                    height: 60,
                                    child: IconButton(
                                      icon: const Icon(Icons.remove,
                                          color: secondaryCOlor),
                                      onPressed: () {
                                        songDeleteFromPlaylist(
                                            songPlaylist[index], context);
                                      },
                                    ),
                                  ),
                                  onTap: () {
                                    SongController.audioPlayer.setAudioSource(
                                        SongController.createSongList(
                                            songPlaylist),
                                        initialIndex: index);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ScreenNowPlaying(
                                          songModel: songPlaylist,
                                          count: songPlaylist.length,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: songPlaylist.length,
                          )
                  ],
                ),
              )
            ],
          ),
        );
      },
    );
  }

  void songDeleteFromPlaylist(SongModel data, context) {
    playlist.deleteData(data.id);
    final removePlaylist = SnackBar(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(25),
      ),
      width: MediaQuery.of(context).size.width * 3.5 / 5,
      behavior: SnackBarBehavior.floating,
      backgroundColor: Colors.black,
      content: const Text(
        'Song removed from Playlist',
        style: TextStyle(color: Colors.white),
      ),
      duration: const Duration(milliseconds: 550),
    );
    ScaffoldMessenger.of(context).showSnackBar(removePlaylist);
  }

  List<SongModel> listPlaylist(List<int> data) {
    List<SongModel> plsongs = [];
    for (int i = 0; i < SongController.songscopy.length; i++) {
      for (int j = 0; j < data.length; j++) {
        if (SongController.songscopy[i].id == data[j]) {
          plsongs.add(SongController.songscopy[i]);
        }
      }
    }
    return plsongs;
  }
}
