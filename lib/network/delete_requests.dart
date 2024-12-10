

import 'package:denis_kebap/model/base_res_model.dart';
import 'package:denis_kebap/network/ApiUrls.dart';
import 'package:denis_kebap/network/remote_service.dart';

class DeleteRequests {
  DeleteRequests._();



  static Future<BaseResModel?> deleteAccount() async {
    var apiResponse = await RemoteService.simpleDelete(ApiUrls.urlDeleteAccount);
    if (apiResponse != null) {
      return baseResModelFromJson(apiResponse.response!);
    } else {
      return null;
    }
  }




}
