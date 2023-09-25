import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/controller/search_controller.dart';
import 'package:musicplayer_flutter/utils/color_const.dart';
import 'package:musicplayer_flutter/view/home/listviewScreen/listview_screen.dart';
import 'package:provider/provider.dart';

class ScreenSearch extends StatelessWidget {
  const ScreenSearch({super.key});

  @override
  Widget build(BuildContext context) {
    final searchController = Provider.of<SearchScreenController>(context);
     WidgetsBinding.instance.addPostFrameCallback((_) {
       searchController.songLoading();
    });
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        leading: IconButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          icon: const Icon(
            Icons.arrow_back,
            color: secondaryCOlor,
          ),
        ),
        title: TextField(
          textAlign: TextAlign.start,
          onChanged: (value) =>searchController.updateSearchList(value),
          style: const TextStyle(color: secondaryCOlor, fontWeight: FontWeight.bold),
          decoration: InputDecoration(
            hintText: 'Search Songs',
            hintStyle: const TextStyle(color: secondaryCOlor),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(25),
              borderSide: BorderSide.none,
            ),
          ),
        ),
      ),
      body: searchController.searchSongs.isNotEmpty
          ? ScreenListView(songModel: searchController.searchSongs)
          : const Center(
              child: Text(
                'No Songs',
                style: TextStyle(
                    color: secondaryCOlor,
                    fontSize: 20,
                    fontWeight: FontWeight.bold),
              ),
            ),
    );
  }
}
