import 'package:flutter_neumorphic_plus/flutter_neumorphic.dart';
import 'package:musicplayer_flutter/utils/color_const.dart';

class ContainerList extends StatelessWidget {
  final String name;
  final Icon icon;
  final Color color;

  const ContainerList(
      {super.key, required this.name, required this.icon, required this.color});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(8.0),
      child: Neumorphic(
        style: NeumorphicStyle(
          color: const Color.fromARGB(255, 196, 191, 191),
          shape: NeumorphicShape.concave,
          depth: -5, // Adjust the depth as needed
          intensity: 0.7, // Adjust the intensity as needed
          lightSource: LightSource.bottomRight,
          oppositeShadowLightSource: true,
      
         //border: NeumorphicBorder(width: 19),
          boxShape: NeumorphicBoxShape.roundRect(
            BorderRadius.circular(20),
          ),
        ),
        child: Container(
          decoration: BoxDecoration(
            color: color,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              icon,
              Text(
                name,
                style: const TextStyle(color: secondaryCOlor),
              )
            ],
          ),
        ),
      ),
    );
  }
}
