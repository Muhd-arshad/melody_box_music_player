import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:on_audio_query/on_audio_query.dart';

class SearchScreenController extends ChangeNotifier{

List<SongModel> allsongs = [];
List<SongModel> searchSongs = [];
final OnAudioQuery onAudioQuery = OnAudioQuery();
Future<void> songLoading() async {
  log('caling');
    allsongs = await onAudioQuery.querySongs(
      sortType: null,
      orderType: OrderType.ASC_OR_SMALLER,
      uriType: UriType.EXTERNAL,
      ignoreCase: true,
    );
      searchSongs = allsongs;
      // notifyListeners();
    
  }
  void updateSearchList(String enteredText) {
    List<SongModel> results = [];
    if (enteredText.isEmpty ) {
      results = allsongs;
    } else {
      results = allsongs
          .where(
            (element) => element.displayNameWOExt.toLowerCase().trim().contains(
                  enteredText.toLowerCase().trim(),
                ),
          )
          .toList();
    }
      searchSongs = results;
      notifyListeners();
    
  }
}