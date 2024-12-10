import 'package:denis_kebap/consts/app_consts.dart';
import 'package:denis_kebap/controller/order/orders_controller.dart';
import 'package:denis_kebap/model/payment_link_res_model.dart';
import 'package:denis_kebap/view/widgets/common/common_app_bar.dart';
import 'package:denis_kebap/view/widgets/common/common_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';
import 'package:webview_flutter/webview_flutter.dart';



class PaymentFormScreen extends StatefulWidget {
  const PaymentFormScreen({super.key});

  @override
  State<PaymentFormScreen> createState() => _PaymentFormScreenState();
}

class _PaymentFormScreenState extends State<PaymentFormScreen> {

  late  WebViewController _controller;
  bool isLoading = true;

  PaymentLinkData? paymentLinkData;


  getArguments(){
    Map<String,dynamic>? data = Get.arguments;
    if(data !=null && data.containsKey(AppConsts.keyPaymentLinkData)){
      paymentLinkData = data[AppConsts.keyPaymentLinkData];
    }
  }



  initWebViewController(String? url){
    if(url == null) return;
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
        onUrlChange: (UrlChange urlChange) {
          // Add logic when the URL changes
          final url = urlChange.url??'';
          print('URL changed: $url');

          // You can add conditional logic here based on the URL
          if (url.contains('sumup/payment-success')) {
           Future.delayed( const Duration(seconds: 5),()=>
           Navigator.of(context).pop(true)
           );
          }
        },

        onWebResourceError: (WebResourceError error) {},
      ),
      )

      ..loadRequest(Uri.parse(url??''));
  }

  @override
  void initState() {
    super.initState();
    getArguments();

    initWebViewController(paymentLinkData?.checkoutUrl);
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
          title: 'payment'.tr,),
        body: isLoading ? const CommonProgressBar() :   WebViewWidget(controller: _controller)
    );
  }
}


