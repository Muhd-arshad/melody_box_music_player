import 'package:flutter/material.dart';
import 'package:just_audio/just_audio.dart';
import 'package:musicplayer_flutter/const_files/color_const.dart';
import 'package:musicplayer_flutter/functions/db/favouritedb/favouritedb_functions.dart';
import 'package:musicplayer_flutter/functions/db/recentlyplayed/recentlyplayed_db.dart';
import 'package:musicplayer_flutter/functions/navigate_functions/navigate_functions.dart';
import 'package:musicplayer_flutter/lists/container_list.dart';
import 'package:musicplayer_flutter/screen/home/gridviewScreen/gridview_screen.dart';
import 'package:musicplayer_flutter/screen/home/listviewScreen/listview_screen.dart';
import 'package:musicplayer_flutter/screen/home/miniPlayer/miniplayer.dart';
import 'package:musicplayer_flutter/songController/song_controller.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:permission_handler/permission_handler.dart';

class ScreenHome extends StatefulWidget {
  const ScreenHome({super.key});

  @override
  State<ScreenHome> createState() => _ScreenHomeState();
}

List<SongModel> startSongs = [];

class _ScreenHomeState extends State<ScreenHome> {
  final audioQuery = OnAudioQuery();
  final audioPlayer = AudioPlayer();
  List<SongModel> allSongs = [];

  bool list = true;
  @override
  void initState() {
    super.initState();
    requestPermission();
  }

  // requestPermission() async {
  //   dynamic permsion = await audioQuery.permissionsStatus();
  //   if (!permsion) {
  //     await audioQuery.permissionsRequest();
  //   }
  // }
   void requestPermission() async {
    bool permissionStatus = await audioQuery.permissionsStatus();
    if (!permissionStatus) {
      await audioQuery.permissionsRequest();
    }
    setState(() {});
    Permission.storage.request();
  }

  playsong(String? uri) {
    audioPlayer.setAudioSource(
      AudioSource.uri(
        Uri.parse(uri!),
      ),
    );
    audioPlayer.play();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          onPressed: () {
            navigateToSettings(context);
          },
          icon: const Icon(
            Icons.settings,
            color: secondaryCOlor,
            size: 30,
          ),
        ),
        actions: [
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              list == true
                  ? IconButton(
                      onPressed: () {
                        setState(() {
                          list = false;
                        });
                      },
                      icon: const Icon(
                        Icons.list,
                        color: secondaryCOlor,
                      ))
                  : IconButton(
                      onPressed: () {
                        setState(() {
                          list = true;
                        });
                      },
                      icon: const Icon(
                        Icons.grid_view_rounded,
                        color: secondaryCOlor,
                      ),
                    ),
              IconButton(
                onPressed: () {
                  navigateToSearchScreen(context);
                },
                icon: const Icon(
                  Icons.search,
                  color: secondaryCOlor,
                ),
              ),
            ],
          ),
        ],
      ),
      body: SizedBox(
        height: MediaQuery.of(context).size.height,
        child: Column(
          children: [
            Flexible(
              flex: 1,
              child: Padding(
                padding: const EdgeInsets.all(8),
                child: GridView.count(
                  physics: const NeverScrollableScrollPhysics(),
                  crossAxisCount: 2,
                  crossAxisSpacing: MediaQuery.of(context).size.width *0.02,
                  mainAxisSpacing: MediaQuery.of(context).size.width *0.02,
                  childAspectRatio: 1.7,
                  children: [
                    GestureDetector(
                      onTap: () => navigateToFavourite(context),
                      child: const ContainerList(
                        name: 'Favorite',
                        icon: Icon(
                          Icons.favorite,
                          color: secondaryCOlor,
                        ),
                        color: Colors.purple,
                      ),
                    ),
                    GestureDetector(
                      onTap: () => navigateToPlaylist(context),
                      child: const ContainerList(
                        name: 'Playlist',
                        icon: Icon(
                          Icons.playlist_add_circle,
                          color: secondaryCOlor,
                        ),
                        color: Color.fromRGBO(13, 105, 25, 0.612),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => navigateToRecentlyPlayed(context),
                      child: const ContainerList(
                        name: 'Recently played',
                        icon: Icon(
                          Icons.timelapse,
                          color: secondaryCOlor,
                        ),
                        color: Color.fromRGBO(219, 156, 39, 0.612),
                      ),
                    ),
                    GestureDetector(
                      onTap: () => navigateToMOstlyPlayed(context),
                      child: const ContainerList(
                        name: 'Mostly played',
                        icon: Icon(
                          Icons.headphones,
                          color: secondaryCOlor,
                        ),
                        color: Color.fromARGB(255, 145, 93, 74),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Flexible(
              flex: 2,
              child: Stack(
                children: [
                  Container(
                    color: bgColor,
                    height: double.infinity,
                    width: double.infinity,
                    child: Column(
                      children: [
                        const Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: EdgeInsets.only(left: 25, top: 20),
                            child: Text(
                              'All Songs',
                              style: TextStyle(
                                  color: secondaryCOlor, fontSize: 25),
                            ),
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Expanded(
                          child: FutureBuilder<List<SongModel>>(
                            future: audioQuery.querySongs(
                              sortType: null,
                              orderType: OrderType.ASC_OR_SMALLER,
                              uriType: UriType.EXTERNAL,
                              ignoreCase: true,
                            ),
                            builder: (context, item) {
                              if (item.data == null) {
                                return const Center(
                                  child: CircularProgressIndicator(),
                                );
                              }
                              if (item.data!.isEmpty) {
                                return const Center(
                                  child: Text(
                                    "No Songs Found!!",
                                    style: TextStyle(color: secondaryCOlor),
                                  ),
                                );
                              }
                              startSongs = item.data!;
                              if (!FavouriteDb.isIntialized) {
                                FavouriteDb.initialize(item.data!);
                              }
                              SongController.songscopy = item.data!;

                              return list
                                  ? ScreenListView(songModel: item.data!)
                                  : ScreenGridView(songModel: item.data!);
                            },
                          ),
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    
                   bottom: 0,
                    right: 5,
                    left: 5,
                    child: ValueListenableBuilder(
                      valueListenable: RecenetsongPlayed.recentsongNotifier,
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            if (SongController.audioPlayer.currentIndex != null)
                              Column(
                                children: const [MiniPlayer()],
                              )
                            else
                              const SizedBox()
                          ],
                        );
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
