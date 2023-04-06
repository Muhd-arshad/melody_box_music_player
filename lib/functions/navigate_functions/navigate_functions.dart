import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/screen/home/home_screen.dart';
import 'package:musicplayer_flutter/screen/widget/settings_screen/about_screen.dart';
import 'package:musicplayer_flutter/screen/widget/settings_screen/policy_screen.dart';
import 'package:musicplayer_flutter/screen/widget/settings_screen/termsandcondition_screen.dart';
import 'package:musicplayer_flutter/screen/widget/favourite/favourite_screen.dart';
import 'package:musicplayer_flutter/screen/widget/mostlyplayed/most_played.dart';
import 'package:musicplayer_flutter/screen/widget/playlist/playlist_pade_screen.dart';
import 'package:musicplayer_flutter/screen/widget/recentlyPlayed/recently_played.dart';
import 'package:musicplayer_flutter/screen/widget/search/search_screen.dart';
import 'package:musicplayer_flutter/screen/widget/settings_screen/settings_screen.dart';

navigateToHome(BuildContext context) {
  Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => const ScreenHome(),
      ));
}

navigateToFavourite(BuildContext ctx) {
  Navigator.push(
    ctx,
    MaterialPageRoute(
      builder: (context) => const ScreenFavourite(),
    ),
  );
}

navigateToPlaylist(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const PlaylistPage(),
    ),
  );
}

navigateToPlyingScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ScreenHome(),
    ),
  );
}

navigateToRecentlyPlayed(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ScreenRecentlyPlayed(),
    ),
  );
}

navigateToMOstlyPlayed(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ScreenMostlyPlayed(),
    ),
  );
}

navigateToSettings(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ScreenSettings(),
    ),
  );
}

navigateToAboutScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ScreenAbout(),
    ),
  );
}

navigateToPolicyScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ScreenPolicy(),
    ),
  );
}

navigateToTermsScreen(BuildContext context) {
  Navigator.push(
    context,
    MaterialPageRoute(
      builder: (context) => const ScreenTermsAndCondition(),
    ),
  );
}
navigateToSearchScreen(BuildContext context){
  Navigator.push(context, MaterialPageRoute(builder: (context) => const ScreenSearch(),),);
}
