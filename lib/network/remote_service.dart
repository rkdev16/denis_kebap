import 'dart:convert';
import 'dart:developer';
import 'package:denis_kebap/model/common_res_model.dart';
import 'package:denis_kebap/network/ApiUrls.dart';
import 'package:denis_kebap/routes/app_routes.dart';
import 'package:denis_kebap/utils/app_alerts.dart';
import 'package:denis_kebap/utils/helpers.dart';
import 'package:denis_kebap/utils/internet_connection.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:http/http.dart' as http;

class RemoteService {
  static var client = http.Client();

  static Map<String, String> getHeaders() {
    String? bearerToken = PreferenceManager.userToken;

    Map<String, String> headers = {
      "Accept": "application/json",
      "Content-Type": "application/json;charset=utf-8"
    };

    debugPrint("Token = $bearerToken");

    headers.addAll({"Authorization": "Bearer $bearerToken"});

    return headers;
  }

  static Map<String, String> getHeadersFileUpload() {
    String? bearerToken = PreferenceManager.userToken;
    Map<String, String> headers = {
      // "Accept": "application/json",
      // "Content-Type": "application/json;charset=utf-8"
    };
    headers.addAll({"Authorization": "Bearer $bearerToken"});

    return headers;
  }

  static Future<CommonResModel?> simplePost(
      {required String endUrl,
      required Map<String, dynamic> requestBody}) async {
    // print("it worked");
    var isConnected = await InternetConnection.isConnected();

    if (!isConnected) {
      return null;
    }

    Helpers.printLog(
        screenName: 'Remote_Service_simple_post',
        message: "request_data = $requestBody");
    debugPrint('request_url = ${ApiUrls.baseUrl + endUrl}');
    var body = json.encode(requestBody);
    final response = await http.post(Uri.parse(ApiUrls.baseUrl + endUrl),
        headers: getHeaders(), body: body);
    Helpers.printLog(
        screenName: 'Remote_Service_simple_post',
        message: "response = ${response.body}");
    debugPrint('request_url = ${ApiUrls.baseUrl + endUrl}');
    var responseCode = response.statusCode;
    if (Helpers.isResponseSuccessful(responseCode)) {
      return CommonResModel(statusCode: responseCode, response: response.body);
    } else if (responseCode == 401) {
      if (Get.currentRoute != AppRoutes.routeLoginScreen) {
        Get.offAllNamed(AppRoutes.routeLoginScreen);
      }
    } else {
      return null;
    }
    return null;
  }

  // static Future<CommonResModel?> simplePost(
  //     Map<String, dynamic> requestBody, String endUrl) async {
  //   // print("it worked");
  //   var isConnected = await InternetConnection.isConnected();
  //
  //   if (!isConnected) {
  //     return null;
  //   }
  //
  //   var body = json.encode(requestBody);
  //   final response = await http.post(Uri.parse(_baseUrl + endUrl),
  //       headers: getHeaders(), body: body);
  //   log("\n\n\nEND_POINT = ${Uri.parse(_baseUrl + endUrl)}"
  //       "\nHEADERS ==>$getHeaders()\n=====>RESPONSE-START\n${response.body}\n\n\n====>RESPONSE-END");
  //   var responseCode = response.statusCode;
  //   if (Helpers.isResponseSuccessful(responseCode)) {
  //     return CommonResModel(statusCode: responseCode, response: response.body);
  //   } else {
  //     return null;
  //   }
  // }

  static Future<CommonResModel?> simpleGet(String endUrl) async {
    bool isConnected = await InternetConnection.isConnected();
    if (!isConnected) {
      return null;
    }
    final response = await http.get(Uri.parse(ApiUrls.baseUrl + endUrl),
        headers: getHeaders());

    log("\n\n\nEND_POINT = ${Uri.parse(ApiUrls.baseUrl + endUrl)}\nHEADERS ==>$getHeaders()\nStatusCode = ${response.statusCode}\n=====>RESPONSE-START\n${response.body}\n\n\n====>RESPONSE-END");

    var responseCode = response.statusCode;

    if (Helpers.isResponseSuccessful(responseCode)) {
      return CommonResModel(statusCode: responseCode, response: response.body);
    } else if (responseCode == 401 &&
        Get.currentRoute != AppRoutes.routeLoginScreen) {
      Get.offAllNamed(AppRoutes.routeLoginScreen);
    } else {
      AppAlerts.error(message: 'message_server_error'.tr);
      return null;
    }
    return null;
  }

  static Future<CommonResModel?> simpleDelete(String endUrl) async {
    bool isConnected = await InternetConnection.isConnected();

    if (!isConnected) {
      return null;
    }

    final response = await http.delete(Uri.parse(ApiUrls.baseUrl + endUrl),
        headers: getHeaders());

    log("\n\n\nEND_POINT = ${Uri.parse(ApiUrls.baseUrl + endUrl)}\nHEADERS ==>$getHeaders()\n=====>RESPONSE-START\n${response.body}\n\n\n====>RESPONSE-END");

    var responseCode = response.statusCode;

    if (Helpers.isResponseSuccessful(responseCode)) {
      return CommonResModel(statusCode: responseCode, response: response.body);
    } else if (responseCode == 401 &&
        Get.currentRoute != AppRoutes.routeLoginScreen) {
      Get.offAllNamed(AppRoutes.routeLoginScreen);
    } else {
      AppAlerts.error(message: 'message_server_error'.tr);
      return null;
    }
    return null;
  }

  static Future<CommonResModel?> simplePut(
      {required String endUrl, Map<String, dynamic>? requestBody}) async {
    var isConnected = await InternetConnection.isConnected();

    if (!isConnected) {
      return null;
    }

    Helpers.printLog(
        screenName: 'Remote_Service_simple_put',
        message: "request_data = $requestBody");
    debugPrint('request_url = ${ApiUrls.baseUrl + endUrl}');
    var body = json.encode(requestBody ?? {});
    final response = await http.put(Uri.parse(ApiUrls.baseUrl + endUrl),
        headers: getHeaders(), body: body);

    Helpers.printLog(
        screenName: 'Remote_Service_simple_put',
        message: "response = ${response.body}");
    debugPrint('request_url = ${ApiUrls.baseUrl + endUrl}');
    var responseCode = response.statusCode;
    if (Helpers.isResponseSuccessful(responseCode)) {
      return CommonResModel(statusCode: responseCode, response: response.body);
    } else if (responseCode == 401 &&
        Get.currentRoute != AppRoutes.routeLoginScreen) {
      Get.offAllNamed(AppRoutes.routeLoginScreen);
    } else {
      return null;
    }
    return null;
  }

  static Future<CommonResModel?> uploadPhotos(
      String endUrl, List<String> keys, List<dynamic?> paths) async {
    var isConnected = await InternetConnection.isConnected();

    if (!isConnected) {
      return null;
    }

    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(ApiUrls.baseUrl + endUrl));
    request.headers.addAll(getHeadersFileUpload());

    for (int i = 0; i < paths.length; i++) {
      String? path = paths[i];
      if (path == null) continue;
      request.files.add(await http.MultipartFile.fromPath(keys[i], path));
    }

    http.StreamedResponse streamedResponse = await request.send();
    // var responseBytes = await streamedResponse.stream.toBytes();
    // var responseString =  utf8.decode(responseBytes);

    var response = await http.Response.fromStream(streamedResponse);

    log("\n\n\nEND_POINT = ${Uri.parse(ApiUrls.baseUrl + endUrl)}\nHEADERS ==>$getHeaders()\n=====>RESPONSE-START\n${response.body}\n\n\n====>RESPONSE-END");

    var responseCode = response.statusCode;
    if (Helpers.isResponseSuccessful(responseCode)) {
      return CommonResModel(statusCode: responseCode, response: response.body);
    } else if (responseCode == 401 &&
        Get.currentRoute != AppRoutes.routeLoginScreen) {
      Get.offAllNamed(AppRoutes.routeLoginScreen);
    } else {
      AppAlerts.error(message: 'message_server_error'.tr);
      return null;
    }
    return null;
  }

  static Future<CommonResModel?> uploadPhoto(
      String endUrl, String key, String imagePath) async {
    var isConnected = await InternetConnection.isConnected();

    if (!isConnected) {
      return null;
    }

    http.MultipartRequest request =
        http.MultipartRequest('POST', Uri.parse(ApiUrls.baseUrl + endUrl));
    request.headers.addAll(getHeadersFileUpload());

    request.files.add(await http.MultipartFile.fromPath(key, imagePath));

    http.StreamedResponse streamedResponse = await request.send();
    // var responseBytes = await streamedResponse.stream.toBytes();
    // var responseString =  utf8.decode(responseBytes);

    var response = await http.Response.fromStream(streamedResponse);
    log("\n\n\nEND_POINT = ${Uri.parse(ApiUrls.baseUrl + endUrl)}\nHEADERS ==>$getHeaders()\n=====>RESPONSE-START\n${response.body}\n\n\n====>RESPONSE-END");
    var responseCode = response.statusCode;
    if (Helpers.isResponseSuccessful(responseCode)) {
      return CommonResModel(statusCode: responseCode, response: response.body);
    } else if (responseCode == 401 &&
        Get.currentRoute != AppRoutes.routeLoginScreen) {
      Get.offAllNamed(AppRoutes.routeLoginScreen);
    } else {
      AppAlerts.error(message: 'message_server_error'.tr);
      return null;
    }
    return null;
  }

  static Future<CommonResModel?> uploadPhotoPut(
      String endUrl, String key, String imagePath) async {
    var isConnected = await InternetConnection.isConnected();

    if (!isConnected) {
      return null;
    }

    http.MultipartRequest request =
        http.MultipartRequest('PUT', Uri.parse(ApiUrls.baseUrl + endUrl));
    request.headers.addAll(getHeadersFileUpload());

    request.files.add(await http.MultipartFile.fromPath(key, imagePath));

    http.StreamedResponse streamedResponse = await request.send();
    // var responseBytes = await streamedResponse.stream.toBytes();
    // var responseString =  utf8.decode(responseBytes);

    var response = await http.Response.fromStream(streamedResponse);
    log("\n\n\nEND_POINT = ${Uri.parse(ApiUrls.baseUrl + endUrl)}\nHEADERS ==>$getHeaders()\n=====>RESPONSE-START\n${response.body}\n\n\n====>RESPONSE-END");
    var responseCode = response.statusCode;
    if (Helpers.isResponseSuccessful(responseCode)) {
      return CommonResModel(statusCode: responseCode, response: response.body);
    } else if (responseCode == 401 &&
        Get.currentRoute != AppRoutes.routeLoginScreen) {
      Get.offAllNamed(AppRoutes.routeLoginScreen);
    } else {
      AppAlerts.error(message: 'message_server_error'.tr);
      return null;
    }
    return null;
  }
}
