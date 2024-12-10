


import 'package:denis_kebap/model/base_res_model.dart';
import 'package:denis_kebap/model/login_res_model.dart';
import 'package:denis_kebap/model/request_otp_res_model.dart';
import 'package:denis_kebap/model/upload_profile_img_res_model.dart';
import 'package:denis_kebap/network/ApiUrls.dart';
import 'package:denis_kebap/network/remote_service.dart';
import 'package:denis_kebap/utils/preference_manager.dart';




class PostRequests {
  PostRequests._();

  static Future<RequestOtpResModel?> requestOtp(Map<String,dynamic> requestBody) async {

    var apiResponse =
    await RemoteService.simplePost(endUrl: ApiUrls.urlRequestOtpEmail,requestBody: requestBody);

    if (apiResponse != null) {
      return requestOtpResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<BaseResModel?> verifyOtp(Map<String,dynamic> requestBody) async {

    var apiResponse =
    await RemoteService.simplePost(endUrl: ApiUrls.urlVerifyOtp,requestBody:  requestBody);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }


  static Future<LoginResModel?> otpSignIn(Map<String,dynamic> requestBody) async {
    var apiResponse =
    await RemoteService.simplePost(endUrl: ApiUrls.urlEmailOtpSignIn,requestBody:  requestBody);

    if (apiResponse != null) {
      return loginResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<LoginResModel?> createPin(Map<String,dynamic> requestBody) async {
    var apiResponse =
    await RemoteService.simplePost(endUrl: ApiUrls.createPin,requestBody: requestBody);

    if (apiResponse != null) {
      return loginResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }


  static Future<LoginResModel?> login(Map<String,dynamic> requestBody) async {
    var apiResponse =
    await RemoteService.simplePost(endUrl:ApiUrls.urlLogin,requestBody: requestBody);

    if (apiResponse != null) {
      return loginResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }


  static Future<BaseResModel?> addProductToCart(
      Map<String, dynamic> requestBody) async {
    var apiResponse =
    await RemoteService.simplePost(endUrl: ApiUrls.urlAddToCart,requestBody: requestBody);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }





  static Future<BaseResModel?> cartBulkUpdate(
      Map<String, dynamic> requestBody) async {
    var apiResponse =
    await RemoteService.simplePost(endUrl: ApiUrls.urlCartBulkUpdate,requestBody: requestBody);

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }


  static Future<UploadProfileImgResModel?> uploadUserImg(String imagePath) async {
    var apiResponse = await RemoteService.uploadPhoto(ApiUrls.urlUploadProfileImage, 'image', imagePath);

    if (apiResponse != null) {
      return uploadProfileImgResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }

  static Future<BaseResModel?> placeOrder(String locationId,Map<String,dynamic> requestBody) async {
    var apiResponse = await RemoteService.simplePost(
        endUrl: '${ApiUrls.urlPlaceOrder}?location=$locationId',
      requestBody: requestBody
    );

    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }


  static Future<BaseResModel?> checkEmailExists(Map<String,dynamic> requestBody) async {
    var apiResponse = await RemoteService.simplePost(
        endUrl: ApiUrls.urlCheckEmailExists,
        requestBody: requestBody
    );
    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }


  static Future<BaseResModel?> checkPhoneExists(Map<String,dynamic> requestBody) async {
    var apiResponse = await RemoteService.simplePost(
        endUrl: ApiUrls.urlCheckPhoneExists,
        requestBody: requestBody
    );
    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }



  
}
