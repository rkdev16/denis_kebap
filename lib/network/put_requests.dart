

import 'package:denis_kebap/model/base_res_model.dart';
import 'package:denis_kebap/model/login_res_model.dart';
import 'package:denis_kebap/model/upload_profile_img_res_model.dart';
import 'package:denis_kebap/network/remote_service.dart';

import 'ApiUrls.dart';

class PutRequests{

  PutRequests._();




  static Future<LoginResModel?> updateUser(
      Map<String, dynamic> requestBody) async {
    var apiResponse =
    await RemoteService.simplePut(endUrl: ApiUrls.urlUserUpdate,requestBody: requestBody);

    if (apiResponse != null) {
      return loginResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }




  static Future<BaseResModel?> editProductInCart(
     String cartItemId, Map<String, dynamic> requestBody) async {
    var apiResponse =
    await RemoteService.simplePut(endUrl: ApiUrls.urlEditProductInCart + cartItemId,requestBody: requestBody);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<BaseResModel?> cancelOrder(
      String? orderId) async {
    var apiResponse =
    await RemoteService.simplePut(endUrl: '${ApiUrls.urlCancelOrder}$orderId');
    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }


  static Future<void> updateFcmToken(String fcmToken) async{

    Map<String,dynamic> requestBody = {
      'fcmToken':fcmToken
    };
    await RemoteService.simplePut(endUrl: ApiUrls.urlUpdateFcmToken,requestBody: requestBody);
    //todo handle update fcm token response

  }



}

