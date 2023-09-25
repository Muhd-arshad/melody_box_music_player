
import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:musicplayer_flutter/utils/color_const.dart';


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
    return  Scaffold(
      backgroundColor: bgColor,
      body: SafeArea(
        child: Center(
          child: NeumorphicText(
          "Melody Box",
         
          style: const NeumorphicStyle(
            shape: NeumorphicShape.convex,
          depth:2, 
          intensity: 0.7, 
          lightSource: LightSource.bottomRight,
          oppositeShadowLightSource: true,
            color: Colors.grey,
          ),
          textStyle: NeumorphicTextStyle(
            fontSize: 45, 
            fontWeight: FontWeight.bold
          ),
              ),
        )),
    );
  }

  navigateToHome() async {
    await Future.delayed(
      const Duration(seconds: 3),
    );
     //ignore: use_build_context_synchronously
    Navigator.pushReplacementNamed(context, '/screenHome');
  }
}
