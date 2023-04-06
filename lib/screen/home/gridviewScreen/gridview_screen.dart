import 'package:flutter/material.dart';

import 'package:musicplayer_flutter/const_files/color_const.dart';
import 'package:musicplayer_flutter/functions/db/mostlypaleddb/mostlypayeddb_functions.dart';
import 'package:musicplayer_flutter/functions/db/recentlyplayed/recentlyplayed_db.dart';
import 'package:musicplayer_flutter/screen/playing_screen/nowplaying_screen.dart';
import 'package:musicplayer_flutter/songController/song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenGridView extends StatefulWidget {
  const ScreenGridView({super.key, required this.songModel});
  final List<SongModel> songModel;

  @override
  State<ScreenGridView> createState() => _ScreenGridViewState();
}

class _ScreenGridViewState extends State<ScreenGridView> {
  List<SongModel> allSongs = [];
  @override
  Widget build(BuildContext context) {
    return GridView.builder(
      itemCount: widget.songModel.length,
      // The number of items in the grid
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2, // The number of columns in the grid
        mainAxisSpacing: 5.0, // The spacing between each row
        crossAxisSpacing: 5.0, // The spacing between each column
        childAspectRatio: 1.0,// The aspect ratio of each item
      ),
      itemBuilder: (BuildContext context, int index) {
        allSongs.addAll(widget.songModel);
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                SongController.audioPlayer.setAudioSource(
                  SongController.createSongList(widget.songModel),
                  initialIndex: index,
                );
                RecenetsongPlayed.addRecentPlayedSong(widget.songModel[index].id);
                MostlyPlayed.addmostlyPlayed(widget.songModel[index].id);
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
              child: Stack(
                children: [
                  Container(
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      image: const DecorationImage(
                        image: AssetImage('assets/images/music-note.png'),
                      ),
                    ),
                  ),
                  Align(
                    alignment: Alignment.topRight,
                    child: PopupMenuButton(
                      icon: const Icon(
                        Icons.more_vert,
                        color: secondaryCOlor,
                      ),
                      itemBuilder: (context) => <PopupMenuEntry>[
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('Add to Playlist'),
                          ),
                        ),
                        PopupMenuItem(
                          child: TextButton(
                            onPressed: () {},
                            child: const Text('Add to favourite'),
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(top: 10, left: 23),
              child: Text(
                widget.songModel[index].displayNameWOExt,
                overflow: TextOverflow.ellipsis,
                maxLines: 1,
                style: const TextStyle(color: secondaryCOlor),
              ),
            ),
          ],
        );
      },
    );
  }
}
