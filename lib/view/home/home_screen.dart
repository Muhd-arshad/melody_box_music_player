import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/controller/search_controller.dart';
import 'package:musicplayer_flutter/utils/color_const.dart';
import 'package:musicplayer_flutter/controller/favourite_controller.dart';
import 'package:musicplayer_flutter/controller/homescreen_controller.dart';
import 'package:musicplayer_flutter/controller/mostlyplayed_controller.dart';
import 'package:musicplayer_flutter/controller/playlist_controller.dart';
import 'package:musicplayer_flutter/controller/version_controller.dart';
import 'package:musicplayer_flutter/view/home/gridviewScreen/gridview_screen.dart';
import 'package:musicplayer_flutter/view/home/listviewScreen/listview_screen.dart';
import 'package:musicplayer_flutter/view/home/miniPlayer/miniplayer.dart';
import 'package:musicplayer_flutter/view/widget/container_list_widget.dart';
import 'package:musicplayer_flutter/controller/song_controller.dart';
import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';
    List<SongModel> startSongs = [];

class ScreenHome extends StatelessWidget {
  const ScreenHome({super.key});

  @override
  Widget build(BuildContext context) {
     final songController =Provider.of<SongController>(context);
    final homecontroller = Provider.of<HomeController>(context);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      homecontroller.requestPermission();
    });
    double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          onPressed: () async{
            await Provider.of<VersionContoller>(context,listen: false).showVersion();
            // ignore: use_build_context_synchronously
            Navigator.pushNamed(context,'/screenSettings');
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
              homecontroller.list == true
                  ? IconButton(
                      onPressed: () {
                        homecontroller.toggleList();
                      },
                      icon: const Icon(
                        Icons.grid_view_rounded,
                        color: secondaryCOlor,
                      ))
                  : IconButton(
                      onPressed: () {
                        homecontroller.toggleList();
                      },
                      icon: const Icon(
                        Icons.list,
                        color: secondaryCOlor,
                      ),
                    ),
              IconButton(
                onPressed: () async{
                await  Provider.of<SearchScreenController>(context,listen: false).songLoading();
                   // ignore: use_build_context_synchronously
                   Navigator.pushNamed(context,'/screenSearch');
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
              child: GridView.count(
                padding: const EdgeInsets.all(10),
                physics: const NeverScrollableScrollPhysics(),
                crossAxisCount: 2,
                crossAxisSpacing: screenWidth * 0.01,
                mainAxisSpacing: screenWidth * 0.01,
                childAspectRatio: 1.7,
                children: [
                  GestureDetector(
                    onTap: () {
                      Navigator.pushNamed(context, '/screenFavourite');
                    },
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
                    onTap: () {
                      Provider.of<PlaylistProvider>(context, listen: false)
                          .getAllPlaylist();
                      Navigator.pushNamed(context, '/screenPlaylist');
                    },
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
                    onTap: () {
                    Navigator.pushNamed(context, '/screenRecentlyPlayed');
                      // Provider.of<RecenetsongPlayedprovider>(context,listen: false).getrecentsong();
                    },
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
                    onTap: () => Navigator.pushNamed(context, '/screenMostlyPlayed'),
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
                            future: homecontroller.audioQuery.querySongs(
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
                              if (!Favouriteprovider.isIntialized) {
                                Provider.of<Favouriteprovider>(context)
                                    .initialize(item.data!);
                              }
                              songController.songscopy = item.data!;

                              return homecontroller.list
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
                    child: Consumer<MostlyPlayedprovider>(
                      builder: (context, value, child) {
                        return Column(
                          children: [
                            if (songController.audioPlayer.currentIndex != null)
                              const Column(
                                children: [MiniPlayer()],
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
