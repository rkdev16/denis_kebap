import 'package:denis_kebap/consts/app_raw_res.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:lottie/lottie.dart';

class CommonErrorWidget extends StatelessWidget {
  const CommonErrorWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [

          Lottie.asset(AppRawRes.animWindMills,height: 200,width: 200),
          Text('empty_list'.tr,style: Theme.of(context).textTheme.headlineLarge?.copyWith(
              fontSize: 22.fontMultiplier,
              color: Colors.white,
              fontWeight: FontWeight.w700
          ),),

          Text('you_have_no_item_at_this_moment'.tr,
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
              fontSize: 14.fontMultiplier,
              color: Colors.white,
            ),)

        ],),
    );
  }
}