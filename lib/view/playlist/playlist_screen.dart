import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/utils/color_const.dart';
import 'package:musicplayer_flutter/controller/playlist_controller.dart';
import 'package:musicplayer_flutter/model/model_musicplayer.dart';

import 'package:musicplayer_flutter/controller/song_controller.dart';
import 'package:musicplayer_flutter/view/playing_screen/nowplaying_screen.dart';
import 'package:musicplayer_flutter/view/playlist/playlistadd_song.dart';
import 'package:provider/provider.dart';

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
    final songController = Provider.of<SongController>(context);
    return Consumer<PlaylistProvider>(
      builder: (context, playlistController, Widget? child) {
        playlistController.songPlaylist = playlistController.listPlaylist(playlistController.playlist[findex].songId,context);
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
                    playlistController.songPlaylist.isEmpty
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
                                    playlistController.songPlaylist[index].displayNameWOExt,
                                    maxLines: 1,
                                    style:
                                        const TextStyle(color: secondaryCOlor),
                                  ),
                                  subtitle: Text(
                                    playlistController.songPlaylist[index].artist.toString(),
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
                                        Provider.of<PlaylistProvider>(context,listen: false)
                                            .songDeleteFromPlaylist(
                                          playlistController.songPlaylist[index],
                                          context,
                                          playlist,
                                        );
                                      },
                                    ),
                                  ),
                                  onTap: () {
                                    songController.audioPlayer.setAudioSource(
                                        songController
                                            .createSongList(playlistController.songPlaylist),
                                        initialIndex: index);

                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => ScreenNowPlaying(
                                          songModel: playlistController.songPlaylist,
                                          count: playlistController.songPlaylist.length,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              );
                            },
                            separatorBuilder: (context, index) =>
                                const Divider(),
                            itemCount: playlistController.songPlaylist.length,
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
}
