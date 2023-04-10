import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/const_files/color_const.dart';
import 'package:musicplayer_flutter/functions/navigate_functions/navigate_functions.dart';
import 'package:musicplayer_flutter/functions/resetapp/reset_app.dart';
import 'package:musicplayer_flutter/songController/song_controller.dart';
import 'package:share_plus/share_plus.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: bgColor,
      appBar: AppBar(
        backgroundColor: bgColor,
        title: const Text(
          'Settings',
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
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(

            children: [
              Expanded(
                flex: 5,
                child: Column(
                  children: [
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .03,
                    ),
                    ListTile(
                      leading: const Icon(Icons.info,color: secondaryCOlor,),
                      onTap: () => navigateToAboutScreen(context),
                      title: const Text(
                        'About Us',
                        style: TextStyle(color: secondaryCOlor),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                     ListTile(
                      leading: const Icon(Icons.share,color: secondaryCOlor,),
                    
                    title: const Text('Share',style: TextStyle(color: secondaryCOlor),),
                    onTap: () {
                      Share.share(
                          'Wanna listen to your musics hastle free?Checkout Melody Box right away. Download Now.https://play.google.com/store/apps/details?id=in.brototype.Melody_Box');
                    },
                  ),
                  SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    ListTile(
                      leading:const Icon(Icons.lock,color: secondaryCOlor,),
                      onTap: () => navigateToPolicyScreen(context),
                      title: const Text(
                        'Privacy And Policy',
                        style: TextStyle(color: secondaryCOlor),
                      ),
              
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    ListTile(
                      leading:const Icon(Icons.text_snippet,color: secondaryCOlor,),
                      onTap: () => navigateToTermsScreen(context),
                      title: const Text(
                        'Terms And Condition',
                        style: TextStyle(color: secondaryCOlor),
                      ),
                    ),
                    SizedBox(
                      height: MediaQuery.of(context).size.height * .02,
                    ),
                    ListTile(
                      leading: const Icon(Icons.restart_alt_sharp,color: secondaryCOlor,),
                      title: const Text(
                        'Reset',
                        style: TextStyle(color: secondaryCOlor),
                      ),
                      onTap: () {
                        showDialog(
                          context: context,
                          builder: (context) {
                            return AlertDialog(
                              backgroundColor: Colors.white,
                              title: const Text(
                                'Reset App',
                                style: TextStyle(
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              content: const Text(
                                """Are you sure do you want to reset the App?
              Your saved data will be deleted.
                                """,
                                style: TextStyle(fontSize: 15),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    Navigator.pop(context);
                                  },
                                  child: const Text('No'),
                                ),
                                TextButton(
                                  onPressed: () {
                                    resetAPP(context);
                                    SongController.audioPlayer.stop();
                                  },
                                  child: const Text(
                                    'Yes',
                                    style: TextStyle(
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          },
                        );
                      },
                    ),
              
                   
                  ],
                ),
              ),
              Expanded(
                     child: Align(
                      alignment: Alignment.bottomCenter,
                       child: Column(
                         children: const[
                           Text('Version',style: TextStyle(color: secondaryCOlor,fontWeight: FontWeight.bold,fontSize: 20),),
                            
                       Text(' 1.0.0',style: TextStyle(color: secondaryCOlor,fontWeight: FontWeight.bold,fontSize: 16),),
                         ],
                       ),
                     ),
                   ),
            ],
          ),
        ),
      ),
    );
  }
}
