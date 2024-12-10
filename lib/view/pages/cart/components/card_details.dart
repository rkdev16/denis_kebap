import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:get/get.dart';

import '../../../../consts/app_images.dart';
import '../../../widgets/common/common_app_bar.dart';

class CardDetailsScreen extends StatelessWidget {
  const CardDetailsScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return  Scaffold(
      appBar: CommonAppBar(
        systemUiOverlayStyle:
        SystemUiOverlayStyle.light.copyWith(statusBarColor: Colors.black),
        title: 'card_details'.tr,
        titleTextColor: Colors.white,
        backgroundColor: Colors.black,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const SizedBox(height: 50),
            Row(
              children: [
                Text("€",style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                    fontWeight: FontWeight.w300,
                    fontSize: 50,

                    color: Colors.black)),
                const SizedBox(width: 5.0),
                Text("14.60",style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 50,
                    color: Colors.black)),

              ],
            ),
            Text("card_number".tr,style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(10.0),
                border: Border.all(color: Colors.black.withOpacity(0.5))
              ),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  children: [
                    Image.asset(AppImages.imgCard,scale: 4,),
                  ],
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("valid_until".tr,style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black)),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12.0),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.black.withOpacity(0.5))
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(width: 10.0),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("cvv".tr,style: Theme.of(context)
                          .textTheme
                          .headlineSmall
                          ?.copyWith(
                          fontWeight: FontWeight.w500,
                          fontSize: 14,
                          color: Colors.black)),
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 12.0),
                        height: 50,
                        width: double.infinity,
                        decoration: BoxDecoration(
                            borderRadius: BorderRadius.circular(10.0),
                            border: Border.all(color: Colors.black.withOpacity(0.5))
                        ),
                      ),
                    ],
                  ),
                ),
                Text("".tr,style: Theme.of(context)
                    .textTheme
                    .headlineSmall
                    ?.copyWith(
                    fontWeight: FontWeight.w500,
                    fontSize: 14,
                    color: Colors.black)),
              ],
            ),
            Text("card_holder".tr,style: Theme.of(context)
                .textTheme
                .headlineSmall
                ?.copyWith(
                fontWeight: FontWeight.w500,
                fontSize: 14,
                color: Colors.black)),
            Container(
              margin: const EdgeInsets.symmetric(vertical: 12.0),
              height: 50,
              width: double.infinity,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10.0),
                  border: Border.all(color: Colors.black.withOpacity(0.5))
              ),
            ),
            CommonButton(text: "PAY NOW", clickAction: (){})
          ],
        ),
      ),
    );
  }
}
