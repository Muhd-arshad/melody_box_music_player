import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/utils/color_const.dart';
import 'package:musicplayer_flutter/controller/favourite_controller.dart';
import 'package:musicplayer_flutter/view/home/listviewScreen/listview_screen.dart';

import 'package:provider/provider.dart';

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
      body: Consumer<Favouriteprovider>(
        
        builder: (context,  favouriteData, Widget? child) {
          if (favouriteData.favouriteSongs.isEmpty) {
            return const Center(
              child: Text(
                'No data ',
                style: TextStyle(color: secondaryCOlor),
              ),
            );

          }else{
           favouriteData.favouriteSongs.reversed.toList().toList();
            // favouriteData=favouriteData.favouriteSongs.toSet().toList();
            return ScreenListView(songModel: favouriteData.favouriteSongs);
          }
        },
      ),
    );
  }
}
