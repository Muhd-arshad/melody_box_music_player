import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/const_files/color_const.dart';
import 'package:musicplayer_flutter/functions/db/favouritedb/favouritedb_functions.dart';
import 'package:musicplayer_flutter/functions/db/mostlypaleddb/mostlypayeddb_functions.dart';
import 'package:musicplayer_flutter/screen/playing_screen/nowplaying_screen.dart';
import 'package:musicplayer_flutter/screen/widget/playlist/songstoplaylist.dart';
import 'package:musicplayer_flutter/songController/song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

import '../../../functions/db/recentlyplayed/recentlyplayed_db.dart';

class ScreenListView extends StatefulWidget {
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
  State<ScreenListView> createState() => _ScreenListViewState();
}

class _ScreenListViewState extends State<ScreenListView> {
  @override
  Widget build(BuildContext context) {
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
            widget.songModel[index].displayNameWOExt,
            style: const TextStyle(
              color: secondaryCOlor,
              overflow: TextOverflow.ellipsis,
            ),
            maxLines: 1,
          ),
          subtitle: Text(
            widget.songModel[index].artist.toString(),
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
                  playlistDialogue(context, widget.songModel[index]);
                },
                child: const Text('Add to Playlist'),
              )),
              PopupMenuItem(
                child: Wrap(
                  children: [
                    ValueListenableBuilder(
                      valueListenable: FavouriteDb.favouriteSongs,
                      builder: (context, List<SongModel> favouriteData,
                          Widget? child) {
                        return TextButton(
                          onPressed: () {
                            if (FavouriteDb.isFavour(widget.songModel[index])) {
                              FavouriteDb.delete(widget.songModel[index].id);
                              const remove = SnackBar(
                                content: Text('song removed from favourite'),
                                duration: Duration(seconds: 1),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(remove);
                              Navigator.of(context).pop();
                            } else {
                              FavouriteDb.add(widget.songModel[index]);
                              const favadd = SnackBar(
                                content: Text('song added to favourite'),
                                duration: Duration(seconds: 1),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(favadd);
                              Navigator.of(context).pop();
                            }
                            FavouriteDb.favouriteSongs.notifyListeners();
                          },
                          child: FavouriteDb.isFavour(widget.songModel[index])
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
            
            SongController.audioPlayer.setAudioSource(
              SongController.createSongList(widget.songModel),
              initialIndex: index,
            );
            MostlyPlayed.addmostlyPlayed(widget.songModel[index].id);
            RecenetsongPlayed.addRecentPlayedSong(widget.songModel[index].id);
            
            Navigator.push(
              context,
              MaterialPageRoute(
                builder: (context) => ScreenNowPlaying(
                  songModel: widget.songModel,
                  count: widget.songModel.length,
                ),
              ),
              
            );
          },
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount:
          widget.isRecent || widget.isMostly ? widget.recentlength : widget.songModel.length,
    );
  }
}
