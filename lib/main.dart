import 'dart:io';

import 'package:country_picker/country_picker.dart';
import 'package:denis_kebap/config/app_theme.dart';
import 'package:denis_kebap/config/device_info.dart';
import 'package:denis_kebap/config/local_strings.dart';
import 'package:denis_kebap/config/size_config.dart';
import 'package:denis_kebap/consts/app_consts.dart';
import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/notification/notification_service.dart';
import 'package:denis_kebap/routes/app_routes.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:get/get.dart';
import 'package:overlay_support/overlay_support.dart';

import 'routes/app_pages.dart';
import 'utils/preference_manager.dart';
import 'package:flutter_localizations/flutter_localizations.dart';


void main() async {
  WidgetsBinding widgetsBinding = WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);

  await PreferenceManager.init();
  await DeviceConfig.init();
  await FlutterDownloader.initialize(
    debug: true,
    ignoreSsl: false
  );
  NotificationService().init();

  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.black,
    systemNavigationBarColor: Colors.black,
    systemNavigationBarIconBrightness: Brightness.light,
    statusBarIconBrightness: Brightness.light,
    statusBarBrightness: Brightness.light,
  ));
  runApp(const MyApp());
  FlutterNativeSplash.remove();
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});


  String getInitialRoute(){
    String route = AppRoutes.routeLoginScreen;

    if(PreferenceManager.user !=null){
      route = AppRoutes.routeDashboardScreen;
    }
    else if(PreferenceManager.restaurantLocation != null){
      route = AppRoutes.routeDashboardScreen;
    }
    else if(Platform.isAndroid){
      if(int.parse(DeviceConfig.deviceDetails.deviceOSVersion) <= 30){
        route = AppRoutes.routeLoginScreen;
      }else{
        route = AppRoutes.routeSplashScreen;
      }
    }else if(Platform.isIOS){
      route = AppRoutes.routeLoginScreen;
    }
    return route;
  }





  @override
  Widget build(BuildContext context) {
    return OverlaySupport(
      child: LayoutBuilder(
        builder: (BuildContext context, BoxConstraints constraints) {
          return OrientationBuilder(
              builder: (BuildContext context, Orientation orientation) {
            SizeConfig().init(constraints, orientation);
            return GetMaterialApp(
              translations: LocalStrings(),
              locale: PreferenceManager.appLanguage == AppLanguage.english
                  ? const Locale('en', 'US')
                  : const Locale('de', 'AT'),
              fallbackLocale: const Locale('de', 'AT'),
              debugShowCheckedModeBanner: false,
              title: AppConsts.appName,
              theme: appTheme(context),
              //  home: OrderConfirmationScreen(),
             initialRoute: getInitialRoute(),
            // initialRoute: AppRoutes.routePaymentFormScreen,
              getPages: AppPages.pages,
              supportedLocales: const [
                Locale('en'),
                Locale('ar'),
                Locale('es'),
                Locale('de'),
                Locale('fr'),
                Locale('el'),
                Locale('et'),
                Locale('nb'),
                Locale('nn'),
                Locale('pl'),
                Locale('pt'),
                Locale('ru'),
                Locale('hi'),
                Locale('ne'),
                Locale('uk'),
                Locale('hr'),
                Locale('tr'),
                Locale('lv'),
                Locale('lt'),
                Locale('ku'),
                Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans'),
                // Generic Simplified Chinese 'zh_Hans'
                Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hant'),
                // Generic traditional Chinese 'zh_Hant'
              ],
              localizationsDelegates: const [
                CountryLocalizations.delegate,
                GlobalMaterialLocalizations.delegate,
                GlobalWidgetsLocalizations.delegate,
                GlobalCupertinoLocalizations.delegate,
              ],
            );
          });
        },
      ),
    );
  }
}
