import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/const_files/color_const.dart';
import 'package:musicplayer_flutter/functions/db/mostlypaleddb/mostlypayeddb_functions.dart';
import 'package:musicplayer_flutter/screen/home/listviewScreen/listview_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenMostlyPlayed extends StatefulWidget {
  const ScreenMostlyPlayed({super.key});

  @override
  State<ScreenMostlyPlayed> createState() => _ScreenMostlyPlayedState();
}

class _ScreenMostlyPlayedState extends State<ScreenMostlyPlayed> {
  OnAudioQuery onAudioQuery = OnAudioQuery();
  List<SongModel> mostlyPlayedSongLIst = [];
  @override
  void initState() {
    // MostlyPlayed.getMostlyPlayed();
    getMostPlayedSongs();
    super.initState();
  }
   Future<void> getMostPlayedSongs() async {
    await MostlyPlayed.getMostlyPlayed();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text(
          'Mostly Played',
          style: TextStyle(color: secondaryCOlor),
        ),
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(
            Icons.arrow_back,
            color: secondaryCOlor,
          ),
        ),
        centerTitle: true,
      ),
      backgroundColor: bgColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.all(20.0),
              child: Text(
                'Songs',
                style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold,
                    color: secondaryCOlor),
              ),
            ),
            // const SizedBox(height: 20,),
            Expanded(
              child: FutureBuilder(
                future: MostlyPlayed.getMostlyPlayed(),
                builder: (context, items) {
                  return ValueListenableBuilder(
                    valueListenable: MostlyPlayed.mostlyPlayedSongNotifier,
                    builder: (context, List<SongModel> value, Widget? child) {
                      if (value.isEmpty) {
                        return const Center(
                          child: Text(
                            'No songs',
                            style: TextStyle(color: secondaryCOlor),
                          ),
                        );
                      } else {
                        mostlyPlayedSongLIst = value.reversed.toSet().toList();
                        return FutureBuilder<List<SongModel>>(
                          future: onAudioQuery.querySongs(
                            sortType: null,
                            orderType: OrderType.ASC_OR_SMALLER,
                            uriType: UriType.EXTERNAL,
                            ignoreCase: true,
                          ),
                          builder: (context, items) {
                            if (items.data == null) {
                              return const Center(
                                child: CircularProgressIndicator(),
                              );
                            }
                            if (items.data!.isEmpty) {
                              return const Center(
                                child: Text(
                                  'No songs found',
                                  style: TextStyle(color: secondaryCOlor),
                                ),
                              );
                            }
                            return ScreenListView(
                              songModel: mostlyPlayedSongLIst,
                              isMostly: true,
                              recentlength: mostlyPlayedSongLIst.length > 10
                                  ? 10
                                  : mostlyPlayedSongLIst.length,
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
