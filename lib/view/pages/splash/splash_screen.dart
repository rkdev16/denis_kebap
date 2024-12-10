import 'dart:async';
import 'dart:io';

import 'package:denis_kebap/config/device_info.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import '../../../routes/app_routes.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({Key? key}) : super(key: key);

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}



class _SplashScreenState extends State<SplashScreen> {

  @override
  void initState() {
    super.initState();
    Timer( const Duration(seconds: 5), () {
      Get.offNamed(AppRoutes.routeLoginScreen);
    });
  }

  @override
  Widget build(BuildContext context) {


    // SystemChrome.setEnabledSystemUIOverlays([]);
    return AnnotatedRegion<SystemUiOverlayStyle>(
      value: SystemUiOverlayStyle.dark.copyWith(
        statusBarColor: Colors.transparent
      ),
      child: SizedBox(
        height: double.infinity,
        width: double.infinity,

        child:  Image.asset(
          'assets/images/img_splash.png',
          width: double.infinity,fit: BoxFit.cover,
        ),

      ),
    );
  }



}
