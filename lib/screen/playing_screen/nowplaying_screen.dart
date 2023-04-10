import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/const_files/color_const.dart';
import 'package:musicplayer_flutter/screen/playing_screen/playing_widget.dart';
import 'package:musicplayer_flutter/songController/song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';


class ScreenNowPlaying extends StatefulWidget {
  const ScreenNowPlaying({super.key, required this.songModel, this.count = 0});
  final List<SongModel> songModel;
  final int count;

  @override
  State<ScreenNowPlaying> createState() => _ScreenNowPlayingState();
}

class _ScreenNowPlayingState extends State<ScreenNowPlaying> {
  Duration _duration = const Duration();
  Duration _position = const Duration();
  int large = 0;
  int currentIndex = 0;
  bool firstSong = false;
  bool lastSong = false;

  @override
  void initState() {
    SongController.audioPlayer.currentIndexStream.listen(
      (index) {
        if (index != null) {
          if (mounted) {
            setState(
              () {
                large = widget.count - 1;
                currentIndex = index;
                index == 0 ? firstSong = true : firstSong = false;
                index == large ? lastSong = true : lastSong = false;
              },
            );
          }
        }
      },
    );

    super.initState();
    playSong();
   
  }

  void playSong() {
    SongController.audioPlayer.play();
    SongController.audioPlayer.durationStream.listen(
      (d) {
        if (mounted) {
          setState(
            () {
              _duration = d!;
            },
          );
        }
      },
    );
    SongController.audioPlayer.positionStream.listen(
      (p) {
        if (mounted) {
          setState(
            () {
              _position = p;
            },
          );
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text(
          'Now Playing',
          style: TextStyle(color: secondaryCOlor),
        ),
        centerTitle: true,
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
      body: SafeArea(
        child: SizedBox(
          height: MediaQuery.of(context).size.height ,
          width: MediaQuery.of(context).size.width,
          child: Column(
            children: [
               Padding(
                padding: const EdgeInsets.only(top: 20, left: 8),
                child: Align(
                  alignment: Alignment.topCenter,
                  child: CircleAvatar(
                    radius: MediaQuery.of(context).size.width *.35,
                    backgroundImage:
                        AssetImage('assets/images/music-note.png'),
                  ),
                ),
              ),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 16,right: 5),
                child: Text(
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                  widget.songModel[currentIndex].displayNameWOExt,
                  style: const TextStyle(color: secondaryCOlor),
                ),
              ),
              const SizedBox(
                height: 20,
              ),
              Text(
                widget.songModel[currentIndex].artist.toString() ==
                        '<unknown>'
                    ? "Unknown Artist"
                    : widget.songModel[currentIndex].artist.toString(),
                overflow: TextOverflow.clip,
                maxLines: 1,
                style: const TextStyle(color: secondaryCOlor),
              ),
              const SizedBox(
                height: 50,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 8, right: 8, top: 8),
                child: SliderTheme(
                  data: SliderTheme.of(context).copyWith(
                    thumbColor: Colors.transparent,
                    thumbShape: const RoundSliderThumbShape(
                      enabledThumbRadius: 7,
                      elevation: 5,
                      pressedElevation: 5,
                    ),
                  ),
                  child: Slider(
                    activeColor: Colors.black,
                    inactiveColor: secondaryCOlor,
                    value: _position.inSeconds.toDouble(),
                    max: _duration.inSeconds.toDouble(),
                    min: const Duration(microseconds: 0).inSeconds.toDouble(),
                    onChanged: (value) {
                      if (mounted) {
                        setState(
                          () {
                            changeToSeconds(
                              value.toInt(),
                            );
                            value = value;
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 28, vertical: 0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      _formatDuration(_position),
                      style: const TextStyle(color: secondaryCOlor),
                    ),
                    Text(
                      _formatDuration(_duration),
                      style: const TextStyle(color: secondaryCOlor),
                    ),
                  ],
                ),
              ),
              const SizedBox(
                height: 15,
              ),
              Expanded(
                child: PlayingControls(
                  count: widget.count,
                  lastSong: lastSong,
                  firstSong: firstSong,
                  favouriteSongModel: widget.songModel[currentIndex],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  void changeToSeconds(int seconds) {
    Duration duration = Duration(seconds: seconds);
    SongController.audioPlayer.seek(duration);
  }

  String _formatDuration(Duration? duration) {
    if (duration == null) {
      return '--:--';
    } else {
      String minutes = duration.inMinutes.toString().padLeft(2, '0');
      String seconds =
          duration.inSeconds.remainder(60).toString().padLeft(2, '0');
      return "$minutes:$seconds";
    }
  }
}
