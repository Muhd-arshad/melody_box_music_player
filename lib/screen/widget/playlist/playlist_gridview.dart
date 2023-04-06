import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:musicplayer_flutter/const_files/color_const.dart';
import 'package:musicplayer_flutter/functions/db/model/model_musicplayer.dart';
import 'package:musicplayer_flutter/screen/widget/playlist/moredialogue.dart';
import 'package:musicplayer_flutter/screen/widget/playlist/playlist_screen.dart';

class PlaylistGridView extends StatefulWidget {
  const PlaylistGridView({
    Key? key,
    required this.musicList,
  }) : super(key: key);
  final Box<MusicPlayer> musicList;
  @override
  State<PlaylistGridView> createState() => _PlaylistGridViewState();
}

class _PlaylistGridViewState extends State<PlaylistGridView> {
  final TextEditingController playlistnamectrl = TextEditingController();
  GlobalKey<FormState> formkey = GlobalKey<FormState>();

  @override
  void initState() {
    // playlistnamectrl.text = widget.musicList.name;
    super.initState();
  }

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
        itemCount: widget.musicList.length,
        itemBuilder: (context, index) {
          final data = widget.musicList.values.toList()[index];
          return ValueListenableBuilder(
            valueListenable: Hive.box<MusicPlayer>('playlistDb').listenable(),
            builder: (BuildContext context, Box<MusicPlayer> musicList,
                Widget? child) {
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
                  child: Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(15),
                      image: const DecorationImage(
                        fit: BoxFit.cover,
                        image: AssetImage('assets/images/playlist-image.jpeg'),
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(2.0),
                      child: Column(
                        children: [
                          Container(
                            margin: const EdgeInsets.all(10),
                            height: MediaQuery.of(context).size.height * .9 / 10,
                            width: MediaQuery.of(context).size.height * .9 / 10,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 10.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
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
                                      moredialogplaylist(
                                          context,
                                          index,
                                          musicList,
                                          formkey,
                                          playlistnamectrl,
                                          data);
                                    },
                                    icon: const Icon(
                                      Icons.more_vert,
                                      color: Color.fromARGB(255, 252, 251, 251),
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
              );
            },
          );
        },
      ),
    );
  }
}
