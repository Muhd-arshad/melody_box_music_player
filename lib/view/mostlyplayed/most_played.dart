import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/utils/color_const.dart';
import 'package:musicplayer_flutter/controller/mostlyplayed_controller.dart';
import 'package:musicplayer_flutter/view/home/listviewScreen/listview_screen.dart';

import 'package:on_audio_query/on_audio_query.dart';
import 'package:provider/provider.dart';

// ignore: must_be_immutable
class ScreenMostlyPlayed extends StatelessWidget {
 ScreenMostlyPlayed({super.key});

  OnAudioQuery onAudioQuery = OnAudioQuery();

  List<SongModel> mostlyPlayedSongLIst = [];


  @override
  Widget build(BuildContext context) {
    Provider.of<MostlyPlayedprovider>(context,listen: false).getMostlyPlayed();
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
                future: Provider.of<MostlyPlayedprovider>(context,listen: false).getMostlyPlayed(),
                builder: (context, items) {
                  return Consumer<MostlyPlayedprovider>(
                    // valueListenable: MostlyPlayed.mostlyPlayedSongNotifier,
                    builder: (context,  mostlyPlayedprovider, Widget? child) {
                      if (mostlyPlayedprovider.mostlyPlayedSong.isEmpty) {
                        return const Center(
                          child: Text(
                            'No songs',
                            style: TextStyle(color: secondaryCOlor),
                          ),
                        );
                      } else {
                        mostlyPlayedSongLIst = mostlyPlayedprovider.mostlyPlayedSong.reversed.toSet().toList();
                        log(mostlyPlayedprovider.toString());
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
