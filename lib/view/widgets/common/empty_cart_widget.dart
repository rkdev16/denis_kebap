import 'package:denis_kebap/consts/app_images.dart';
import 'package:denis_kebap/controller/dashboard/dashboard_controller.dart';
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class EmptyCartWidget extends StatelessWidget {
  const EmptyCartWidget({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const SizedBox(height: 50),
          Image.asset(AppImages.imgEmptyCard, scale: 4.8),
          Text(
            "message_empty_cart".tr,textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  color: Colors.white,
              fontWeight: FontWeight.w600,
                  fontSize: 16.fontMultiplier,
                ),
          ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 8.0),
          //   child: Text(
          //     "check_out_what_is_trending".tr,textAlign: TextAlign.center,
          //     style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          //       color: Colors.white,
          //       fontSize: 16.fontMultiplier,
          //     ),
          //   ),
          // ),

          CommonButton(

            width: 200,
              margin: const  EdgeInsets.only(top: 16),
              text: 'order'.tr,
              backgroundColor: Colors.white,

              textColor: Colors.black,
              clickAction: (){
              Get.find<DashboardController>().currentTabPosition.value = 0;
          })
        ],
      ),
    );
  }
}
