import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/const_files/color_const.dart';
import 'package:musicplayer_flutter/functions/db/favouritedb/favouritedb_functions.dart';
import 'package:musicplayer_flutter/screen/home/listviewScreen/listview_screen.dart';
import 'package:on_audio_query/on_audio_query.dart';

class ScreenFavourite extends StatelessWidget {
  const ScreenFavourite({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text(
          'Favourites',
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
      body: ValueListenableBuilder(
        valueListenable: FavouriteDb.favouriteSongs,
        builder: (context, List<SongModel> favouriteData, Widget? child) {
          if (favouriteData.isEmpty) {
            return const Center(
              child: Text(
                'No data ',
                style: TextStyle(color: secondaryCOlor),
              ),
            );

          }else{
            final temb =favouriteData.reversed.toList();
            favouriteData=temb.toSet().toList();
            return ScreenListView(songModel: favouriteData);
          }
        },
      ),
    );
  }
}
