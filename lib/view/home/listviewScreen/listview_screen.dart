import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/utils/color_const.dart';
import 'package:musicplayer_flutter/controller/favourite_controller.dart';
import 'package:musicplayer_flutter/controller/mostlyplayed_controller.dart';
import 'package:musicplayer_flutter/controller/recentlyplayed_controller.dart';

import 'package:musicplayer_flutter/controller/song_controller.dart';
import 'package:musicplayer_flutter/view/playing_screen/nowplaying_screen.dart';
import 'package:musicplayer_flutter/view/playlist/songstoplaylist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';



class ScreenListView extends StatelessWidget {
  const ScreenListView(
      {super.key,
      required this.songModel,
      this.recentlength,
      this.isRecent = false, this.isMostly=false});
  final List<SongModel> songModel;
  final dynamic recentlength;
  final bool isRecent;
  final bool isMostly;

  @override
  Widget build(BuildContext context) {
     final songController =Provider.of<SongController>(context);
    return ListView.separated(
      shrinkWrap: true,
      physics: const ClampingScrollPhysics(),
      padding: const EdgeInsets.all(10),
      itemBuilder: (context, index) {
        return ListTile(
          leading: const CircleAvatar(
            backgroundImage: AssetImage('assets/images/music-note.png'),
          ),
          title: Text(
            songModel[index].displayNameWOExt,
            style: const TextStyle(
              color: secondaryCOlor,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
          subtitle: Text(
            songModel[index].artist.toString(),
            style: const TextStyle(color: secondaryCOlor),
          ),
          trailing: PopupMenuButton(
            icon: const Icon(
              Icons.more_vert,
              color: secondaryCOlor,
            ),
            itemBuilder: (context) => <PopupMenuEntry>[
              PopupMenuItem(
                  child: TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  playlistDialogue(context, songModel[index]);
                },
                child: const Text('Add to Playlist'),
              )),
              PopupMenuItem(
                child: Wrap(
                  children: [
                    // Provider.of<Favouriteprovider>(context,listen: false).favouriteSongs.isEmpty ?
                    // const Center(child: Text('No Data'),) :
                    Consumer<Favouriteprovider>(
                      
                      builder: (context, favouriteData,
                          Widget? child) {
                        return TextButton(
                          onPressed: () {
                            if (favouriteData.isFavour(songModel[index])) {
                              favouriteData.delete(songModel[index].id);
                              const remove = SnackBar(
                                content: Text('song removed from favourite'),
                                duration: Duration(seconds: 1),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(remove);
                              Navigator.of(context).pop();
                            } else {
                              favouriteData.add(songModel[index]);
                              const favadd = SnackBar(
                                content: Text('song added to favourite'),
                                duration: Duration(seconds: 1),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(favadd);
                              Navigator.of(context).pop();
                            }
                            // FavouriteDb.favouriteSongs.notifyListeners();
                          },
                          child: favouriteData.isFavour(songModel[index])
                              ? const Text('Remove from favourite')
                              : const Text('Add to favourite'),
                        );
                      },
                    ),
                  ],
                ),
              ),
            ],
          ),
          onTap: () {
            
            songController.audioPlayer.setAudioSource(
              songController.createSongList(songModel),
              initialIndex: index,
            );
            Provider.of<MostlyPlayedprovider>(context,listen: false).addmostlyPlayed(songModel[index].id);
            Provider.of<RecenetsongPlayedprovider>(context,listen: false).addrecentlyplayed(songModel[index].id);
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScreenNowPlaying(
                  songModel: songModel,
                  count: songModel.length,
                ),
              ),
              
            );
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount:
          isRecent || isMostly ? recentlength : songModel.length,
    );
  }
}
