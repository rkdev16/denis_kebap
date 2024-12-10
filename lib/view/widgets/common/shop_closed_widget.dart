



import 'package:denis_kebap/consts/app_raw_res.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class ShopClosedWidget extends StatelessWidget {
  const ShopClosedWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        children: [
          LottieBuilder.asset(AppRawRes.animClosed,
          height: 200,
          ),

          Text('message_shop_closed'.tr,style: Theme.of(context).textTheme.headlineMedium?.copyWith(
            fontSize: 16.fontMultiplier,
            fontWeight: FontWeight.w300,
            color: Colors.white

          ),)

      ],),
    );
  }
}
