import 'package:denis_kebap/consts/app_formatters.dart';
import 'package:denis_kebap/consts/enums.dart';
import 'package:denis_kebap/controller/account/account_controller.dart';
import 'package:denis_kebap/network/delete_requests.dart';
import 'package:denis_kebap/network/put_requests.dart';
import 'package:denis_kebap/routes/app_routes.dart';
import 'package:denis_kebap/utils/app_alerts.dart';
import 'package:denis_kebap/view/dialogs/common/common_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../../utils/preference_manager.dart';

class EditAccountController extends GetxController {
  RxBool isLoading = false.obs;

  late TextEditingController nameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;

  Rx<ProfileEditingType?> profileEditingType = Rx<ProfileEditingType?>(null);

  @override
  void onInit() {
    super.onInit();
    initTextEditingControllers();
    getPrefData();
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void dispose() {
    disposeTextEditingControllers();
    super.dispose();
  }

  initTextEditingControllers() {
    nameController = TextEditingController();
    emailController = TextEditingController();
    phoneController = TextEditingController();
  }

  void getPrefData() {
    nameController.text = PreferenceManager.user?.name ?? '';
    emailController.text = PreferenceManager.user?.email ?? '';
    phoneController.text =
        '${PreferenceManager.user?.countryCode ?? ''} ${PreferenceManager.user?.mobile ?? ''}';
  }

  disposeTextEditingControllers() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
  }

  updateUserName() async {
    var name = nameController.text.toString().trim();

    if (name.isEmpty) {
      AppAlerts.alert(message: 'message_enter_name'.tr);
      return;
    }

    var requestBody = {'name': name};

    try {
      isLoading.value = true;
      var result = await PutRequests.updateUser(requestBody);
      if (result != null) {
        if (result.success) {
          AppAlerts.success(message: result.message);
          PreferenceManager.user = result.user;
          profileEditingType.value = null;
          Get.find<AccountController>().getPrefData();
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoading.value = false;
    }
  }

  updateUserEmail() async {
    var email = emailController.text.toString().trim();

    if (email.isEmpty) {
      AppAlerts.alert(message: 'message_enter_email'.tr);
      return;
    }

    if (!AppFormatters.validEmailExp.hasMatch(email)) {
      AppAlerts.alert(message: 'message_invalid_email'.tr);
      return;
    }

    var requestBody = {'email': email};

    try {
      isLoading.value = true;
      var result = await PutRequests.updateUser(requestBody);
      if (result != null) {
        if (result.success) {
          AppAlerts.success(message: result.message);
          profileEditingType.value = null;
          PreferenceManager.user = result.user;
          Get.find<AccountController>().getPrefData();
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoading.value = false;
    }
  }

  showDeleteAccountAlert() {
    CommonAlertDialog.showDialog(
        message: 'message_delete_account'.tr,
        positiveText: 'no'.tr,
        negativeText: 'yes'.tr,
        negativeBtCallback: () {
          Get.back();
          deleteAccount();
        },
        positiveBtCallback: () {
          Get.back();
        });
  }

  deleteAccount() async {
    try {
      isLoading.value = true;
      var result = await DeleteRequests.deleteAccount();
      if (result != null) {
        if (result.success) {
          PreferenceManager.user = null;
          PreferenceManager.token = null;
          Get.offAllNamed(AppRoutes.routeLoginScreen);
        } else {
          AppAlerts.error(message: result.message);
        }
      } else {
        AppAlerts.error(message: 'message_server_error'.tr);
      }
    } finally {
      isLoading.value = false;
    }
  }
}
