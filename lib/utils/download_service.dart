

import 'dart:io';
import 'dart:isolate';
import 'dart:ui';
import 'dart:async';

import 'package:denis_kebap/utils/app_alerts.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:flutter/material.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:flutter_local_notifications/flutter_local_notifications.dart';
import 'package:get/get.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';



const   portName = 'downloader_send_port';
class DownloadService {

  FlutterLocalNotificationsPlugin flutterLocalNotificationsPlugin =
  FlutterLocalNotificationsPlugin();

  static final DownloadService _instance = DownloadService._internal();



  late  ReceivePort _port;




  late String _localPath ;
  String? _taskId ;


  factory DownloadService (){
    return _instance;
  }


  DownloadService._internal();

  init(){
   _port = ReceivePort();
    _bindBackgroundIsolate();
    FlutterDownloader.registerCallback(downloadCallback,step: 1);

  }


  dispose(){
    _unbindBackgroundIsolate();

  }




  _bindBackgroundIsolate(){

    final isSuccess = IsolateNameServer.registerPortWithName(_port.sendPort,
        portName);

    debugPrint("ISSuccess : $isSuccess");

    if(!isSuccess){
      _unbindBackgroundIsolate();
      _bindBackgroundIsolate();
      return;
    }

     _port.listen((message) {
      final taskId = (message as List<dynamic>)[0] as String;
      final status = DownloadTaskStatus.fromInt(message[1] as int);
      final progress = message[2] as int;


      debugPrint("Callback on UI isolate: task $taskId is in status $status and process $progress");

      if(Platform.isIOS){
        if(status == DownloadTaskStatus.complete ){
          Get.snackbar("download_complete".tr,"file_downloaded_successfully".tr,
            duration: const  Duration(minutes: 1),
            mainButton: TextButton(onPressed: () async{
              Get.closeAllSnackbars();

             await _openDownloadedFile(_taskId);
            }, child: Text("open".tr,style: TextStyle(
              fontFamily: 'Poppins',
              fontSize: 14.fontMultiplier,
              fontWeight: FontWeight.w400
            )))
          );



         // showDownloadNotification('Notification','File downloaded successfully');
        }
      };
    });
  }

  _unbindBackgroundIsolate(){
    IsolateNameServer.removePortNameMapping(portName);

  }


  @pragma('vm:entry-point')
  static void downloadCallback(
      String id,
      int status,
      int progress
      ){

    debugPrint(""
        "Callback on background isolate: task $id is in status $status and progress $progress");

    IsolateNameServer.lookupPortByName(portName)?.send([id,status,progress]);

  }






   _checkPermission() async{
    if(Platform.isIOS){
      return true;
    }



    if(Platform.isAndroid){
      final info = await  DeviceInfoPlugin().androidInfo;
      if(info.version.sdkInt > 28){
        return true;
      }

      final status = await Permission.storage.request();
      if(status == PermissionStatus.granted){
        return true;
      }

      final result = await Permission.storage.request();
      return result == PermissionStatus.granted;
    }
    throw StateError("unknown platform");

  }



  downloadLink(String url) async{
    final permissionReady = await _checkPermission();
    if(permissionReady){
      await _prepareSaveDir();
    }

    debugPrint('======> ${_localPath}');
   _taskId =  await FlutterDownloader.enqueue(url: url,
        savedDir: _localPath,
      saveInPublicStorage: true,

    );


  }



   _prepareSaveDir() async{
    _localPath = (await _getSaveDir());
    final saveDir = Directory(_localPath);
    if(!saveDir.existsSync()){
      await saveDir.create();
    }

  }


  _getSaveDir()async{
    String? externalStorageDirPath;
    externalStorageDirPath = (await getApplicationDocumentsDirectory()).absolute.path;
    return externalStorageDirPath;

  }


  Future<void> showDownloadNotification(String title, String body) async {
    const DarwinNotificationDetails iOSPlatformChannelSpecifics = DarwinNotificationDetails();
    const NotificationDetails platformChannelSpecifics = NotificationDetails(iOS: iOSPlatformChannelSpecifics);

    final DarwinInitializationSettings initializationSettingsDarwin =
    DarwinInitializationSettings(
        onDidReceiveLocalNotification: onDidReceiveLocalNotification);
     InitializationSettings initializationSettings = InitializationSettings(
      iOS: initializationSettingsDarwin
    );
    
    await flutterLocalNotificationsPlugin.initialize(initializationSettings);
    
    
    await flutterLocalNotificationsPlugin.show(
      0, // Notification ID
      title,
      body,
      platformChannelSpecifics,
      payload: 'item x',
    );
  }


  _openDownloadedFile(String? taskId) async{
    if(taskId ==null) return;

    if(taskId != null){
      await OpenFile.open(_localPath);
    }




    // try{
    //   final isOpened = await  FlutterDownloader.open(taskId: taskId);
    //   if(!isOpened){
    //     Get.snackbar('error'.tr, "cant_able_to_open_file".tr);
    //   }
    // }catch(e){}


  }

  void onDidReceiveLocalNotification(
      int id, String? title, String? body, String? payload) async {
    _openDownloadedFile(_taskId);

  }



















}