import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/utils/color_const.dart';
import 'package:musicplayer_flutter/controller/recentlyplayed_controller.dart';

import 'package:musicplayer_flutter/controller/song_controller.dart';
import 'package:musicplayer_flutter/view/playing_screen/nowplaying_screen.dart';

import 'package:provider/provider.dart';

class MiniPlayer extends StatefulWidget {
  const MiniPlayer({
    Key? key,
  }) : super(key: key);
  @override
  State<MiniPlayer> createState() => _MiniPlayerState();
}

bool firstSong = false;

bool isPlaying = false;

class _MiniPlayerState extends State<MiniPlayer> {
  @override
  void initState() {
    final songController = context.read<SongController>();
    songController.audioPlayer.currentIndexStream.listen(
      (index) {
        if (index != null && mounted) {
          setState(
            () {
              index == 0 ? firstSong = true : firstSong = false;
            },
          );
        }
      },
    );

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
   final songController =Provider.of<SongController>(context);

    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ScreenNowPlaying(
              songModel: songController.playingsong,
            ),
          ),
        );
      },
      child: Align(
        alignment: Alignment.bottomCenter,
        child: Padding(
          padding: const EdgeInsets.only(left: 8.0, right: 8, bottom: 6),
          child: Container(
            decoration: BoxDecoration(
                color: bgColor,
                border: Border.all(color: Colors.white),
                borderRadius: BorderRadius.circular(10)),
            height: 60,
            width: MediaQuery.of(context).size.width,
            child: Stack(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: MediaQuery.of(context).size.width * 1.5 / 4,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          StreamBuilder<bool>(
                            stream: songController.audioPlayer.playingStream,
                            builder: (context, snapshot) {
                              bool? playingStage = snapshot.data;
                              if (playingStage != null && playingStage) {
                                return Text(
                                  songController
                                      .playingsong[songController
                                          .audioPlayer.currentIndex!]
                                      .displayNameWOExt,
                                  maxLines: 1,
                                  overflow: TextOverflow.ellipsis,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(color: secondaryCOlor),
                                );
                              } else {
                                return Text(
                                  songController
                                      .playingsong[songController
                                          .audioPlayer.currentIndex!]
                                      .displayNameWOExt,
                                  textAlign: TextAlign.center,
                                  style: const TextStyle(
                                      overflow: TextOverflow.ellipsis,
                                      color: secondaryCOlor,
                                      fontSize: 16,
                                      fontWeight: FontWeight.bold),
                                );
                              }
                            },
                          ),
                          Text(
                            songController
                                        .playingsong[songController
                                            .audioPlayer.currentIndex!]
                                        .artist
                                        .toString() ==
                                    "<unknown>"
                                ? "Unknown Artist"
                                : songController
                                    .playingsong[songController
                                        .audioPlayer.currentIndex!]
                                    .artist
                                    .toString(),
                            style: const TextStyle(
                                fontSize: 10, color: Colors.white),
                          ),
                        ],
                      ),
                    ),
// previous
                    firstSong
                        ? const IconButton(
                            iconSize: 32,
                            onPressed: null,
                            icon: Icon(
                              Icons.skip_previous,
                              color: secondaryCOlor,
                            ),
                          )
                        : IconButton(
                            iconSize: 32,
                            onPressed: () async {
                              Provider.of<RecenetsongPlayedprovider>(context,listen: false).addrecentlyplayed(
                                  songController
                                      .playingsong[songController
                                          .audioPlayer.currentIndex!]
                                      .id);
                              if (songController.audioPlayer.hasPrevious) {
                                await songController.audioPlayer
                                    .seekToPrevious();
                                await songController.audioPlayer.play();
                              } else {
                                await songController.audioPlayer.play();
                              }
                            },
                            icon: const Icon(Icons.skip_previous),
                            color: secondaryCOlor,
                          ),
// play and Pause
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: const CircleBorder(),
                      ),
                      onPressed: () async {
                        setState(() {
                          isPlaying = !isPlaying;
                        });
                        if (songController.audioPlayer.playing) {
                          await songController.audioPlayer.pause();
                          setState(() {});
                        } else {
                          await songController.audioPlayer.play();
                          setState(() {});
                        }
                      },
                      child: StreamBuilder<bool>(
                        stream: songController.audioPlayer.playingStream,
                        builder: (context, snapshot) {
                          bool? playingStage = snapshot.data;
                          if (playingStage != null && playingStage) {
                            return const Icon(
                              Icons.pause_circle,
                              color: secondaryCOlor,
                              size: 35,
                            );
                          } else {
                            return const Icon(
                              Icons.play_circle,
                              color: secondaryCOlor,
                              size: 35,
                            );
                          }
                        },
                      ),
                    ),
// next
                    IconButton(
                      iconSize: 35,
                      onPressed: () async {
                        Provider.of<RecenetsongPlayedprovider>(context,listen: false).addrecentlyplayed(songController
                            .playingsong[
                                songController.audioPlayer.currentIndex!]
                            .id);
                        if (songController.audioPlayer.hasNext) {
                          await songController.audioPlayer.seekToNext();
                          await songController.audioPlayer.play();
                        } else {
                          await songController.audioPlayer.play();
                        }
                      },
                      icon: const Icon(
                        Icons.skip_next,
                        size: 32,
                      ),
                      color: secondaryCOlor,
                    )
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
