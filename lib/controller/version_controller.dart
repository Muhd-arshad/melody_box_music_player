

import 'package:flutter/material.dart';
import 'package:package_info_plus/package_info_plus.dart';

class VersionContoller extends ChangeNotifier{
   String? version ;
Future<void> showVersion() async {
  PackageInfo packageInfo = await PackageInfo.fromPlatform();
   version = packageInfo.version;

 
}
}