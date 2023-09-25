import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/utils/color_const.dart';
import 'package:musicplayer_flutter/controller/recentlyplayed_controller.dart';
import 'package:musicplayer_flutter/view/home/listviewScreen/listview_screen.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

class ScreenRecentlyPlayed extends StatefulWidget {
  const ScreenRecentlyPlayed({super.key});

  @override
  State<ScreenRecentlyPlayed> createState() => _ScreenRecentlyPlayedState();
}

class _ScreenRecentlyPlayedState extends State<ScreenRecentlyPlayed> {
  final OnAudioQuery audioQuery = OnAudioQuery();
  static List<SongModel> recentSong = [];

  // @override
  // void initState() {
  //   RecenetsongPlayed.getRecentSongs();

  //   super.initState();
  // }

  @override
  Widget build(BuildContext context) {
   
    Provider.of<RecenetsongPlayedprovider>(context,listen: false).getrecentsong();
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text(
          'Recenely Played',
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
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          children: [
           const Padding(
              padding:  EdgeInsets.all(20.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children:  [
                  Text(
                    'Songs ',
                    style: TextStyle(color: secondaryCOlor, fontSize: 30),
                  ),
                ],
              ),
            ),
            Expanded(
              child: FutureBuilder(
                future: Provider.of<RecenetsongPlayedprovider>(context,listen: false).getrecentsong(),
                builder: (context, items) {
                  return Consumer<RecenetsongPlayedprovider>(
                   
                    builder: (context, renctvalue, child) {
                      if ( renctvalue.recentList.isEmpty) {
                        return const Center(
                          child: Text(
                            'No Songs',
                            style: TextStyle(color: secondaryCOlor),
                          ),
                        );
                      } else {
                        recentSong =  renctvalue.recentList.reversed.toSet().toList();
                        return FutureBuilder<List<SongModel>>(
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
                                child: Text('No available songs'),
                              );
                            }
                            return ScreenListView(
                              songModel: recentSong,
                              isRecent: true,
                              recentlength:
                                  recentSong.length > 8 ? 8 : recentSong.length,
                            );
                          },
                        );
                      }
                    },
                  );
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
