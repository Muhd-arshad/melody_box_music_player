import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:musicplayer_flutter/utils/color_const.dart';
import 'package:musicplayer_flutter/controller/favourite_controller.dart';
import 'package:musicplayer_flutter/controller/mostlyplayed_controller.dart';
import 'package:musicplayer_flutter/controller/recentlyplayed_controller.dart';
import 'package:musicplayer_flutter/controller/song_controller.dart';
import 'package:musicplayer_flutter/view/playing_screen/nowplaying_screen.dart';
import 'package:musicplayer_flutter/view/playlist/songstoplaylist.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ScreenGridView extends StatelessWidget {
  ScreenGridView({super.key, required this.songModel});
  final List<SongModel> songModel;

  List<SongModel> allSongs = [];

  @override
  Widget build(BuildContext context) {
    final songController =Provider.of<SongController>(context);
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: GridView.builder(
        itemCount: songModel.length,
        // The number of items in the grid
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2, //? The number of columns in the grid
          mainAxisSpacing: 10, //? The spacing between each row
          crossAxisSpacing: 10, //? The spacing between each column
          childAspectRatio: 1.2, //? The aspect ratio of each item
        ),
        itemBuilder: (BuildContext context, int index) {
          allSongs.addAll(songModel);
          return Neumorphic(
            style: NeumorphicStyle(
              color: const Color.fromARGB(255, 51, 49, 49),
              shape: NeumorphicShape.concave,
              depth: -5, // Adjust the depth as needed
              intensity: 0.5, // Adjust the intensity as needed
              lightSource: LightSource.bottomRight,
              oppositeShadowLightSource: true,

              border: const NeumorphicBorder(
                  width: 20, color: Color.fromARGB(0, 51, 49, 49)),
              boxShape: NeumorphicBoxShape.roundRect(
                BorderRadius.circular(20),
              ),
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                GestureDetector(
                  onTap: () {
                    songController.audioPlayer.setAudioSource(
                      songController.createSongList(songModel),
                      initialIndex: index,
                    );
                    Provider.of<RecenetsongPlayedprovider>(context,
                            listen: false)
                        .addrecentlyplayed(songModel[index].id);
                    Provider.of<MostlyPlayedprovider>(context, listen: false)
                        .addmostlyPlayed(songModel[index].id);
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
                  child: Stack(
                    children: [
                      Container(
                        height: 80,
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
                                onPressed: () {
                                  Navigator.of(context).pop();
                                  playlistDialogue(context, songModel[index]);
                                },
                                child: const Text('Add to Playlist'),
                              ),
                            ),
                            PopupMenuItem(
                              child: Consumer<Favouriteprovider>(builder:
                                  (context, favouriteController, child) {
                                return TextButton(
                                  onPressed: () {
                                    if (favouriteController
                                        .isFavour(songModel[index])) {
                                      favouriteController
                                          .delete(songModel[index].id);
                                      const remove = SnackBar(
                                        content:
                                            Text('song removed from favourite'),
                                        duration: Duration(seconds: 1),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(remove);
                                      Navigator.of(context).pop();
                                    } else {
                                      favouriteController.add(songModel[index]);
                                      const favadd = SnackBar(
                                        content:
                                            Text('song added to favourite'),
                                        duration: Duration(seconds: 1),
                                      );
                                      ScaffoldMessenger.of(context)
                                          .showSnackBar(favadd);
                                      Navigator.of(context).pop();
                                    }
                                  },
                                  child: favouriteController
                                          .isFavour(songModel[index])
                                      ? const Text('Remove from favourite')
                                      : const Text('Add to favourite'),
                                );
                              }),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 13, left: 30),
                  child: Text(
                    songModel[index].displayNameWOExt,
                    overflow: TextOverflow.fade,
                    maxLines: 1,
                    style: const TextStyle(
                        color: secondaryCOlor,
                        fontSize: 15,
                        fontWeight: FontWeight.w900),
                  ),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
