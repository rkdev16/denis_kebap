

import 'package:denis_kebap/config/size_config.dart';
import 'package:denis_kebap/consts/app_icons.dart';
import 'package:denis_kebap/consts/app_images.dart';
import 'package:denis_kebap/consts/app_raw_res.dart';
import 'package:denis_kebap/controller/dashboard/dashboard_controller.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';
import 'package:just_audio/just_audio.dart';
import 'package:lottie/lottie.dart';

class OrderConfirmationScreen extends StatefulWidget {
  const OrderConfirmationScreen({super.key});

  @override
  State<OrderConfirmationScreen> createState() => _OrderConfirmationScreenState();
}

class _OrderConfirmationScreenState extends State<OrderConfirmationScreen> {

  moveToHome(BuildContext context){
   // Get.until((route) => Get.currentRoute == AppRoutes.routeDashboardScreen);
    Navigator.of(context).pop();
    Get.find<DashboardController>().currentTabPosition.value = 2;

  }

  playSound()async{

  await  Future.delayed(const Duration(milliseconds: 400));
    var audioPlayer = AudioPlayer();
    audioPlayer.setAsset(AppRawRes.audioOrder);
    audioPlayer.play();
  }
  @override
  void initState() {
    super.initState();
    playSound();
  }

  @override
  Widget build(BuildContext context) {
    return  PopScope(
      canPop: true,
      onPopInvoked: (didPop)  {
        Get.find<DashboardController>().currentTabPosition.value = 2;
        return;
        },
      child: AnnotatedRegion(
        value: SystemUiOverlayStyle.light.copyWith(
          statusBarColor: Colors.black
        ),
        child: Scaffold(
          backgroundColor: Colors.black,
          body: LayoutBuilder(
              builder: (context,constraints) {

              return SingleChildScrollView(
                child: Container(
                  constraints: BoxConstraints(minHeight: constraints.maxHeight),
                  child: SafeArea(
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [

                      const  Gap(150),
                

                      Stack(
                        alignment: Alignment.center,
                        children: [
                          Image.asset(AppImages.imgCheckConfirmOrder,width: 150,),
                
                          Lottie.asset(AppRawRes.animSpark,repeat: false,height: 150)
                        ],
                      ),
                
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 16.0),
                          child: Text('order_placed'.tr,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                            fontSize: 26.fontMultiplier,
                            color: Colors.white,
                            fontWeight: FontWeight.w600
                          ),),
                        ),
                
                        Padding(
                          padding: const EdgeInsets.only(left:16,right:16,top: 8.0,),
                          child: Text('order_placed_description'.tr,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                              fontSize: 13.fontMultiplier,
                              color: Colors.white,
                          ),),
                        ),
                
                       Padding(
                         padding: const EdgeInsets.all(8.0),
                         child: Row(
                           mainAxisSize: MainAxisSize.min,
                           children: [
                           SvgPicture.asset(
                             AppIcons.icRestaurant,
                             height: 24,
                           ),
                         const   SizedBox(width: 8,),
                           Text(
                             PreferenceManager.restaurantLocation?.name??'',
                             maxLines: 2,
                             textAlign: TextAlign.center,
                             overflow: TextOverflow.ellipsis,
                             style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                                 fontSize: 13.fontMultiplier, color: Colors.green),
                           ),
                         ],),
                       ),
                
                
                       Row(
                         mainAxisAlignment: MainAxisAlignment.center,
                         children: [
                           CommonButton(text: 'my_orders'.tr,
                             textColor: Colors.black,
                             width: 200,
                             height: 40,
                             margin: const  EdgeInsets.symmetric(horizontal: 24,vertical: 16),
                
                             clickAction: (){
                             moveToHome(context);
                             },
                           backgroundColor: Colors.white,),
                         ],
                       ),
                
                
                        Padding(
                          padding: EdgeInsets.only(left: 16,right: 16,top: SizeConfig.heightMultiplier * 20),
                          child: Text('disclaimer_title'.tr,
                            textAlign: TextAlign.center,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 12.fontMultiplier,
                                color: Colors.white,
                                fontWeight: FontWeight.w600

                            ),),
                        ),

                        Padding(
                          padding: const EdgeInsets.only(left:16,right:16,top: 8.0,bottom: 16),
                          child: Text('disclaimer_description'.tr,
                            textAlign: TextAlign.justify,
                            softWrap: true,
                            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                                fontSize: 10.fontMultiplier,
                                color: Colors.white,
                                fontWeight: FontWeight.w300
                            ),),
                        )
                
                
                
                
                
                
                
                
                      ],),
                  ),
                ),
              );
            }
          ),
        ),
      ),
    );
  }
}
