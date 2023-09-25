import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:musicplayer_flutter/utils/color_const.dart';
import 'package:musicplayer_flutter/model/model_musicplayer.dart';
import 'package:musicplayer_flutter/view/playlist/moredialogue.dart';
import 'package:musicplayer_flutter/view/playlist/playlist_screen.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class PlaylistGridView extends StatelessWidget {
  PlaylistGridView({
    Key? key,
    required this.musicList,
  }) : super(key: key);
  final List<MusicPlayer> musicList;
  final TextEditingController playlistnamectrl = TextEditingController();

  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(10),
      child: GridView.builder(
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          childAspectRatio: 1.2,
          crossAxisSpacing: 5,
          mainAxisSpacing: 5,
        ),
        shrinkWrap: true,
        itemCount: musicList.length,
        itemBuilder: (context, index) {
          final data = musicList.toList()[index];
          return Consumer<DialogProvider>(
            builder: (context, musiclist, Widget? child) {
              return Padding(
                padding: const EdgeInsets.all(4),
                child: InkWell(
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) {
                          return ScreenPlaylist(
                            playlist: data,
                            findex: index,
                            image: 'assets/images/playlist-image.jpeg',
                          );
                        },
                      ),
                    );
                  },
                  child: Neumorphic(
                    style: NeumorphicStyle(
                      color: const Color.fromARGB(255, 238, 234, 234),
                      shape: NeumorphicShape.convex,
                      depth: 1, // Adjust the depth as needed
                      intensity: 4, // Adjust the intensity as needed
                      lightSource: LightSource.bottomRight,
                      oppositeShadowLightSource: true,
                      //border: NeumorphicBorder(width: 19),
                      boxShape: NeumorphicBoxShape.roundRect(
                        BorderRadius.circular(20),
                      ),
                    ),
                    child: Container(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(15),
                        image: const DecorationImage(
                          fit: BoxFit.cover,
                          image:
                              AssetImage('assets/images/playlist-image.jpeg'),
                        ),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(2.0),
                        child: Column(
                          children: [
                            Container(
                              margin: const EdgeInsets.all(10),
                              height:
                                  MediaQuery.of(context).size.height * .9 / 10,
                              width:
                                  MediaQuery.of(context).size.height * .9 / 10,
                            ),
                            Padding(
                              padding: const EdgeInsets.only(left: 10.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  SizedBox(
                                    width: MediaQuery.of(context).size.width *
                                        0.90 /
                                        4,
                                    child: Text(
                                      data.name,
                                      maxLines: 1,
                                      style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        fontSize: 16,
                                        color: secondaryCOlor,
                                      ),
                                    ),
                                  ),
                                  SizedBox(
                                    height: 40,
                                    width: 40,
                                    child: IconButton(
                                      onPressed: () {
                                        musiclist.moredialogplaylist(
                                            context,
                                            index,
                                            musiclist,
                                            formkey,
                                            playlistnamectrl,
                                            data);
                                      },
                                      icon: const Icon(
                                        Icons.more_vert,
                                        color:
                                            Color.fromARGB(255, 252, 251, 251),
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
