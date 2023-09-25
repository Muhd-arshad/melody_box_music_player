import 'package:flutter/material.dart';
import 'package:hive_flutter/adapters.dart';
import 'package:musicplayer_flutter/controller/favourite_controller.dart';
import 'package:musicplayer_flutter/controller/homescreen_controller.dart';
import 'package:musicplayer_flutter/controller/mostlyplayed_controller.dart';
import 'package:musicplayer_flutter/controller/playlist_controller.dart';
import 'package:musicplayer_flutter/controller/recentlyplayed_controller.dart';
import 'package:musicplayer_flutter/controller/reset_controller.dart';
import 'package:musicplayer_flutter/controller/search_controller.dart';
import 'package:musicplayer_flutter/controller/song_controller.dart';
import 'package:musicplayer_flutter/controller/version_controller.dart';
import 'package:musicplayer_flutter/model/model_musicplayer.dart';
import 'package:musicplayer_flutter/view/favourite/favourite_screen.dart';
import 'package:musicplayer_flutter/view/home/home_screen.dart';
import 'package:musicplayer_flutter/view/mostlyplayed/most_played.dart';
import 'package:musicplayer_flutter/view/playlist/moredialogue.dart';
import 'package:musicplayer_flutter/view/playlist/playlist_pade_screen.dart';
import 'package:musicplayer_flutter/view/recentlyPlayed/recently_played.dart';
import 'package:musicplayer_flutter/view/search/search_screen.dart';
import 'package:musicplayer_flutter/view/settings_screen/about_screen.dart';
import 'package:musicplayer_flutter/view/settings_screen/policy_screen.dart';
import 'package:musicplayer_flutter/view/settings_screen/settings_screen.dart';
import 'package:musicplayer_flutter/view/settings_screen/termsandcondition_screen.dart';
import 'package:musicplayer_flutter/view/splashScreen/splash_screen.dart';
import 'package:provider/provider.dart';

Future<void> main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (!Hive.isAdapterRegistered(MusicPlayerAdapter().typeId)) {
    Hive.registerAdapter(MusicPlayerAdapter());
  }
  await Hive.initFlutter();
  await Hive.openBox<int>('FavoriteDB');
  await Hive.openBox<MusicPlayer>('playlistDB');
  await Hive.openBox('mostlyPlayedDb');

  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiProvider(
      providers: [
        ChangeNotifierProvider(
          create: (context) => Favouriteprovider(),
        ),
        ChangeNotifierProvider(
          create: (context) => MostlyPlayedprovider(),
        ),
        ChangeNotifierProvider(
          create: (context) => RecenetsongPlayedprovider(),
        ),
        ChangeNotifierProvider(
          create: (context) => PlaylistProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => DialogProvider(),
        ),
        ChangeNotifierProvider(
          create: (context) => HomeController(),
        ),
        ChangeNotifierProvider(
          create: (context) => VersionContoller(),
        ),
        ChangeNotifierProvider(
          create: (context) => SongController(),
        ),
        ChangeNotifierProvider(
          create: (context) => ResetController(),
        ),
        ChangeNotifierProvider(
          create: (context) => SearchScreenController(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          useMaterial3: true,
        ),
        routes: {
          '/screenSplash': (context) => const ScreenSPlash(),
          '/screenHome': (context) => const ScreenHome(),
          '/screenFavourite': (context) => const ScreenFavourite(),
          '/screenPlaylist': (context) => const PlaylistPage(),
          '/screenRecentlyPlayed': (context) => const ScreenRecentlyPlayed(),
          '/screenMostlyPlayed': (context) => ScreenMostlyPlayed(),
          '/screenSettings': (context) => const ScreenSettings(),
          '/screenAbout': (context) => const ScreenAbout(),
          '/screenTermsAndCondition': (context) =>
              const ScreenTermsAndCondition(),
          '/screenPolicy': (context) => const ScreenPolicy(),
          '/screenSearch': (context) => const ScreenSearch(),
        },
        initialRoute: '/screenSplash',
      ),
    );
  }
}
