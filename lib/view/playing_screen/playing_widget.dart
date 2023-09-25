import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';

import 'package:just_audio/just_audio.dart';
import 'package:musicplayer_flutter/utils/color_const.dart';
import 'package:musicplayer_flutter/controller/favourite_controller.dart';

import 'package:musicplayer_flutter/controller/song_controller.dart';
import 'package:musicplayer_flutter/view/playlist/songstoplaylist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

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
    final songController = Provider.of<SongController>(context);
    return Scaffold(
      body: SafeArea(
        child: Container(
          color: bgColor,
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceAround,
                children: [
                  Consumer<Favouriteprovider>(
                      builder: (context, favouriteData, Widget? child) {
                    return IconButton(
                      onPressed: () {
                        if (favouriteData.isFavour(widget.favouriteSongModel)) {
                          favouriteData.delete(widget.favouriteSongModel.id);
                          const remove = SnackBar(
                            content: Text('Remove from favourite'),
                            duration: Duration(seconds: 1),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(remove);
                        } else {
                          favouriteData.add(widget.favouriteSongModel);
                          const addfav = SnackBar(
                            content: Text('Added to favourite'),
                            duration: Duration(seconds: 1),
                          );
                          ScaffoldMessenger.of(context).showSnackBar(addfav);
                        }
                        // favouriteData.favouriteSongs.notifyListeners();
                      },
                      icon: favouriteData.isFavour(widget.favouriteSongModel)
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
                          ? songController.audioPlayer
                              .setShuffleModeEnabled(true)
                          : songController.audioPlayer
                              .setShuffleModeEnabled(false);
                    },
                    icon: StreamBuilder<bool>(
                      stream:
                          songController.audioPlayer.shuffleModeEnabledStream,
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
                      songController.audioPlayer.loopMode == LoopMode.one
                          ? songController.audioPlayer.setLoopMode(LoopMode.all)
                          : songController.audioPlayer
                              .setLoopMode(LoopMode.one);
                    },
                    icon: StreamBuilder<LoopMode>(
                      stream: songController.audioPlayer.loopModeStream,
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
                            if (songController.audioPlayer.hasPrevious) {
                              songController.audioPlayer.seekToPrevious();
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
                    child: Neumorphic(
                      style: const NeumorphicStyle(
                        shape: NeumorphicShape.convex,
                        boxShape: NeumorphicBoxShape.circle(),
                        depth: -6, // Adjust the depth as needed
                        lightSource: LightSource.bottomLeft,
                        oppositeShadowLightSource: true,
                        color: secondaryCOlor,
                      ),
                      child: IconButton(
                        onPressed: () {
                          if (mounted) {
                            setState(() {
                              if (songController.audioPlayer.playing) {
                                songController.audioPlayer.pause();
                              } else {
                                songController.audioPlayer.play();
                              }
                              isPlaying = !isPlaying;
                            });
                          }
                        },
                        icon: isPlaying
                            ? const Icon(
                                Icons.pause,
                                color: bgColor,
                                size: 50,
                              )
                            : const Icon(
                                Icons.play_arrow,
                                color: bgColor,
                                size: 50,
                              ),
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
                            if (songController.audioPlayer.hasNext) {
                              songController.audioPlayer.seekToNext();
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
