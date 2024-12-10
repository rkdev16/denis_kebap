import 'package:denis_kebap/consts/app_icons.dart';
import 'package:denis_kebap/controller/cart/cart_controller.dart';
import 'package:denis_kebap/model/order/orders_res_model.dart';
import 'package:denis_kebap/model/user.dart';
import 'package:denis_kebap/network/get_requests.dart';
import 'package:denis_kebap/network/post_requests.dart';
import 'package:denis_kebap/routes/app_routes.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/permission_handler.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:denis_kebap/view/dialogs/common/common_alert_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';

class AccountController extends GetxController
    with GetTickerProviderStateMixin {
  RxBool isUpdatingImage = false.obs;
  late TabController tabController;
  RxInt currentTabIndex = 0.obs;
  XFile? selectedImage;
  ImagePicker? _picker;

  Rx<String?> userName = Rx<String?>(null);
  Rx<String?> email = Rx<String?>(null);

  Rx<String?> userImage = Rx<String?>(null);



  List<PopupMenuEntry<dynamic>> menuItems = [
    PopupMenuItem(
      value: 1,
      child: Row(
        children: [
          const Icon(
            Icons.language_rounded,
            color: Colors.white,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'change_language'.tr,
              style: Theme.of(Get.context!)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 14.fontMultiplier, color: Colors.white),
            ),
          )
        ],
      ),
    ),

    PopupMenuItem(
      value: 2,
      child: Row(
        children: [
          SvgPicture.asset(
            AppIcons.icLogout,
            colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Text(
              'logout'.tr,
              style: Theme.of(Get.context!)
                  .textTheme
                  .headlineSmall
                  ?.copyWith(fontSize: 14.fontMultiplier, color: Colors.red),
            ),
          )
        ],
      ),
    ),

  ];

  @override
  void onInit() {
    super.onInit();
    tabController = TabController(length: 2, vsync: this);
    _picker = ImagePicker();

    if(PreferenceManager.userToken != ''){
      userImage.value = PreferenceManager.user?.image;
      getUserProfile();
    }
  }

  @override
  void onReady() {
    super.onReady();
  }

  @override
  void onClose() {
    super.onClose();
  }

  getPrefData() {
    userName.value = PreferenceManager.user?.name;
    email.value = PreferenceManager.user?.email;
    debugPrint("Email = ${email.value}");
  }

  void picImage(ImageSource source) async {
  //  var isHavingPermissions = await PermissionHandler.requestCameraPermission();
  //  if (isHavingPermissions) {
      selectedImage = await _picker?.pickImage(source: source);
      uploadImage(selectedImage!.path);
  //  }
  }

  void uploadImage(String path) async {
    isUpdatingImage.value = true;
    var response = await PostRequests.uploadUserImg(path);
    isUpdatingImage.value = false;
    if (response != null) {
      if (response.success) {
        User? user = PreferenceManager.user;
        user?.image = response.profileImgData?.image;
        PreferenceManager.user = user;
        userImage.value = response.profileImgData?.image;
      } else {
        Get.snackbar('error', response.message);
      }
    } else {
      Get.snackbar('error'.tr, 'message_server_error'.tr);
    }
  }

  getUserProfile() async {
    try {
      var result = await GetRequests.fetchUserProfile();
      if (result != null && result.success) {
        debugPrint("GetEmail = = ${result.user}");

        PreferenceManager.user = result.user;
        getPrefData();
      }
    } finally {}
  }

  showLogoutAlert() {
    CommonAlertDialog.showDialog(
        message: 'message_logout'.tr,
        positiveText: 'no'.tr,
        negativeText: 'yes'.tr,
        negativeBtCallback: () {
          GetRequests.logout().then((value) =>  PreferenceManager.token = null);
          PreferenceManager.user = null;


          Get.offAllNamed(AppRoutes.routeLoginScreen);
        },
        positiveBtCallback: () {
          Get.back();
        });
  }


}
