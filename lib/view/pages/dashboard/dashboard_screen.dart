import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/controller/dashboard/dashboard_controller.dart';
import 'package:denis_kebap/routes/app_routes.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/preference_manager.dart';
import 'package:denis_kebap/view/pages/dashboard/components/custom_bottom_nav_bar.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class DashboardScreen extends StatelessWidget {
  DashboardScreen({Key? key}) : super(key: key);

  double bottomBarIconSize = 20.0;

  final _dashboardController = Get.find<DashboardController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Obx(() => _dashboardController
          .tabs[_dashboardController.currentTabPosition.value]),
      bottomNavigationBar: Obx(
        () => CustomBottomNavBar(
          selectedIndex: _dashboardController.currentTabPosition.value,
          onTabChange: (int position) {
            /*if(position ==2 ){
              if(PreferenceManager.userToken != ''){
                debugPrint("OnTabChanged: $position");
                _dashboardController.currentTabPosition.value = position;
              }
              else{
                _loginDialog(context, 'login_first_orders'.tr);
              }
            }
            else*/
            if (position == 1) {
              if (PreferenceManager.userToken != '') {
                debugPrint("OnTabChanged: $position");
                _dashboardController.currentTabPosition.value = position;
              } else {
                _loginDialog(context, 'login_first_carts'.tr);
              }
            } else {
              debugPrint("OnTabChanged: $position");
              _dashboardController.currentTabPosition.value = position;
            }
          },
        ),
      ),
    );
  }

  _loginDialog(context, message) => Get.dialog(Column(
        mainAxisSize: MainAxisSize.min,
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          Container(
            margin: EdgeInsets.symmetric(
              horizontal: 20,
            ),
            padding: EdgeInsets.symmetric(horizontal: 15, vertical: 20),
            decoration: BoxDecoration(
                color: Colors.white, borderRadius: BorderRadius.circular(10)),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(
                  message,
                  textAlign: TextAlign.center,
                  style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontSize: 18.fontMultiplier,
                      fontWeight: FontWeight.w600,
                      color: Colors.black),
                ).paddingOnly(bottom: 15, left: 20, right: 20),
                Row(
                  children: [
                    Expanded(
                        child: CommonButton(
                      text: 'cancel'.tr,
                      borderColor: AppColors.kPrimaryColor,
                      textColor: AppColors.kPrimaryColor,
                      backgroundColor: Colors.white,
                      clickAction: () {
                        Get.back();
                      },
                    )),
                    Expanded(
                        child: CommonButton(
                      text: 'login_register'.tr,
                      clickAction: () {
                        Get.offAllNamed(AppRoutes.routeLoginScreen);
                      },
                    )),
                  ],
                )
              ],
            ),
          )
        ],
      ));
}
