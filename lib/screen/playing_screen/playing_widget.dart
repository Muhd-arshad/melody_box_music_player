import 'package:flutter/material.dart';

import 'package:just_audio/just_audio.dart';
import 'package:musicplayer_flutter/const_files/color_const.dart';
import 'package:musicplayer_flutter/functions/db/favouritedb/favouritedb_functions.dart';
import 'package:musicplayer_flutter/screen/widget/playlist/playlist_pade_screen.dart';
import 'package:musicplayer_flutter/screen/widget/playlist/songstoplaylist.dart';
import 'package:musicplayer_flutter/songController/song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';

class PlayingControls extends StatefulWidget {
  const PlayingControls(
      {super.key,
      required this.count,
      required this.firstSong,
      required this.lastSong,
      required this.favouriteSongModel});
  final int count;
  final bool firstSong;
  final bool lastSong;
  final SongModel favouriteSongModel;

  @override
  State<PlayingControls> createState() => _PlayingControlsState();
}

class _PlayingControlsState extends State<PlayingControls> {
  bool isPlaying = true;
  bool isShuffling = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: bgColor,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  ValueListenableBuilder(
                      valueListenable: FavouriteDb.favouriteSongs,
                      builder: (context, List<SongModel> favouriteData,
                          Widget? child) {
                        return IconButton(
                          onPressed: () {
                            if (FavouriteDb.isFavour(
                                widget.favouriteSongModel)) {
                              FavouriteDb.delete(widget.favouriteSongModel.id);
                              const remove = SnackBar(
                                content: Text('Remove from favourite'),
                                duration: Duration(seconds: 1),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(remove);
                            } else {
                              FavouriteDb.add(widget.favouriteSongModel);
                              const addfav = SnackBar(
                                content: Text('Added to favourite'),
                                duration: Duration(seconds: 1),
                              );
                              ScaffoldMessenger.of(context)
                                  .showSnackBar(addfav);
                            }
                            FavouriteDb.favouriteSongs.notifyListeners();
                          },
                          icon: FavouriteDb.isFavour(widget.favouriteSongModel)
                              ? const Icon(
                                  Icons.favorite,
                                  color: Colors.red,
                                )
                              : const Icon(
                                  Icons.favorite_outline,
                                  color: secondaryCOlor,
                                ),
                        );
                      }),
                  IconButton(
                    onPressed: () {
                       playlistDialogue(context, widget.favouriteSongModel);
                    },
                    icon: const Icon(
                      Icons.playlist_add,
                      size: 30,
                      color: secondaryCOlor,
                    ),
                  ),
                  const SizedBox(
                    width: 15,
                  ),
                  IconButton(
                    onPressed: () {
                      isShuffling == false
                          ? SongController.audioPlayer
                              .setShuffleModeEnabled(true)
                          : SongController.audioPlayer
                              .setShuffleModeEnabled(false);
                    },
                    icon: StreamBuilder<bool>(
                      stream:
                          SongController.audioPlayer.shuffleModeEnabledStream,
                      builder: (BuildContext context, AsyncSnapshot snapshot) {
                        if (snapshot.hasData) {
                          isShuffling = snapshot.data;
                        }
                        if (isShuffling) {
                          return const Icon(
                            Icons.shuffle,
                            size: 30,
                            color: Colors.red,
                          );
                        } else {
                          return const Icon(
                            Icons.shuffle,
                            color: Colors.white,
                          );
                        }
                      },
                    ),
                  ),
                  //repeat button
                  IconButton(
                    onPressed: () {
                      SongController.audioPlayer.loopMode == LoopMode.one
                          ? SongController.audioPlayer.setLoopMode(LoopMode.all)
                          : SongController.audioPlayer
                              .setLoopMode(LoopMode.one);
                    },
                    icon: StreamBuilder<LoopMode>(
                      stream: SongController.audioPlayer.loopModeStream,
                      builder: (context, snapshot) {
                        final loopMode = snapshot.data;
                        if (LoopMode.one == loopMode) {
                          return const Icon(
                            Icons.repeat,
                            size: 30,
                            color: Colors.red,
                          );
                        } else {
                          return const Icon(
                            Icons.repeat,
                            color: secondaryCOlor,
                          );
                        }
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(
                height: 10,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  //previous Button
                  widget.firstSong
                      ? const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.skip_previous,
                            color: Color.fromARGB(255, 189, 186, 186),
                            size: 30,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            if (SongController.audioPlayer.hasPrevious) {
                              SongController.audioPlayer.seekToPrevious();
                            }
                          },
                          icon: const Icon(
                            Icons.skip_previous,
                            color: secondaryCOlor,
                            size: 30,
                          ),
                        ),
                  const SizedBox(
                    width: 25,
                  ),
                  //play and pause
                  Center(
                    child: IconButton(
                      onPressed: () {
                        if (mounted) {
                          setState(() {
                            if (SongController.audioPlayer.playing) {
                              SongController.audioPlayer.pause();
                            } else {
                              SongController.audioPlayer.play();
                            }
                            isPlaying = !isPlaying;
                          });
                        }
                      },
                      icon: isPlaying
                          ? const Icon(
                              Icons.pause,
                              color: secondaryCOlor,
                              size: 50,
                            )
                          : const Icon(
                              Icons.play_arrow,
                              color: secondaryCOlor,
                              size: 50,
                            ),
                    ),
                  ),
                  const SizedBox(
                    width: 25,
                  ),
                  //next button
                  widget.lastSong
                      ? const IconButton(
                          onPressed: null,
                          icon: Icon(
                            Icons.skip_next,
                            color: secondaryCOlor,
                            size: 30,
                          ),
                        )
                      : IconButton(
                          onPressed: () {
                            if (SongController.audioPlayer.hasNext) {
                              SongController.audioPlayer.seekToNext();
                            }
                          },
                          icon: const Icon(
                            Icons.skip_next,
                            color: secondaryCOlor,
                            size: 30,
                          ),
                        )
                ],
              )
            ],
          ),
        ),
      ),
    );
  }
}
