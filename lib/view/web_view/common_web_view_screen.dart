import 'package:denis_kebap/view/widgets/common/common_app_bar.dart';
import 'package:denis_kebap/view/widgets/common/common_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';

class CommonWebViewScreen extends StatefulWidget {

  const CommonWebViewScreen({Key? key}) : super(key: key);

  @override
  State<CommonWebViewScreen> createState() => _CommonWebViewScreenState();
}

class _CommonWebViewScreenState extends State<CommonWebViewScreen> {
  late  WebViewController _controller;

   String? title;
   String? url;
   
   bool isLoading = true;



   getArguments(){
     Map<String,dynamic>? data = Get.arguments;
     if(data !=null){
       title = data['title'];
       url = data['url'];
     }
   }


  initWebViewController(String? url){
    _controller  = WebViewController()
      ..setJavaScriptMode(JavaScriptMode.unrestricted)
      ..setBackgroundColor(Colors.black)
      ..setNavigationDelegate(NavigationDelegate(
        onProgress: (int progress) {
          debugPrint('Progress = $progress');
        },
        onPageStarted: (String url) {
          setState(() {
            isLoading= true;
          });
          debugPrint('PageStarted');
        },
        onPageFinished: (String url) {
          Future.delayed( const Duration(seconds: 2),(){
            setState(() {
              isLoading= false;
            });
          });

          debugPrint('PageFinished');
        },
        onWebResourceError: (WebResourceError error) {},
      ))
      ..loadRequest(Uri.parse(url??''));
  }




  @override
  void initState() {
    super.initState();
    getArguments();
    initWebViewController(url);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
     appBar:  CommonAppBar(
       systemUiOverlayStyle: SystemUiOverlayStyle.light.copyWith(
         statusBarColor: Colors.black
       ),
       backgroundColor: Colors.black,
       onBackTap: ()=> Get.back(),
       title: (title??"").tr,),
      body: isLoading ? const CommonProgressBar() :   WebViewWidget(controller: _controller)
    );
  }
}
