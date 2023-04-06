import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/const_files/color_const.dart';
import 'package:musicplayer_flutter/screen/home/home_screen.dart';

class ScreenSPlash extends StatefulWidget {
  const ScreenSPlash({super.key});

  @override
  State<ScreenSPlash> createState() => _ScreenSPlashState();
}

class _ScreenSPlashState extends State<ScreenSPlash> {
  @override
  void initState() {
    super.initState();
    navigateToHome();
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: Text(
            'MUSIC',
            style: TextStyle(
              fontSize: 30,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
        ),
      ),
    );
  }

  navigateToHome() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
    // ignore: use_build_context_synchronously
    Navigator.pushReplacement(
      context,
      MaterialPageRoute(
        builder: (context) => const ScreenHome(),
      ),
    );
  }
}
