import 'package:flutter/material.dart';
import 'package:musicplayer_flutter/utils/color_const.dart';
import 'package:musicplayer_flutter/controller/favourite_controller.dart';
import 'package:musicplayer_flutter/controller/reset_controller.dart';
import 'package:musicplayer_flutter/controller/version_controller.dart';
import 'package:musicplayer_flutter/controller/song_controller.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

class ScreenSettings extends StatelessWidget {
  const ScreenSettings({super.key});

  @override
  Widget build(BuildContext context) {
    final songController = Provider.of<SongController>(context);
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
                      onTap: () =>  Navigator.pushNamed(context,'/screenAbout'),
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
                      onTap: () =>  Navigator.pushNamed(context, '/screenPolicy'),
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
                      onTap: () => Navigator.pushNamed(context, '/screenTermsAndCondition'),
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
                                  Provider.of<ResetController>(context,listen: false).resetAPP(context);
                                    Provider.of<Favouriteprovider>(context,listen: false).clear();
                                    songController.audioPlayer.stop();
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
                         children: [
                           const Text('Version',style: TextStyle(color: secondaryCOlor,fontWeight: FontWeight.bold,fontSize: 20),),
                            
                       Text(Provider.of<VersionContoller>(context,listen: false).version!,style: const TextStyle(color: secondaryCOlor,fontWeight: FontWeight.bold,fontSize: 16),),
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
