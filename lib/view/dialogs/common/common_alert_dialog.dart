import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

import '../../../config/app_colors.dart';
import '../../../consts/app_consts.dart';

class CommonAlertDialog {
  CommonAlertDialog._();

  static showDialog(
      {String? title,
      required String message,
      String? negativeText,
      required String positiveText,
      VoidCallback? negativeBtCallback,
      required VoidCallback positiveBtCallback,
      Color? positiveColorBg,
      Color? positiveColorText,
      Color? negativeColorBg,
      bool? barrierDismissible,
      Color? negativeColorText}) {
    Get.dialog(
        Dialog(
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(24)),
          child: CommonDialogContent(
            title: title,
            message: message,
            negativeText: negativeText,
            positiveText: positiveText,
            positiveBtCallback: positiveBtCallback,
            negativeBtCallback: negativeBtCallback,
            positiveColorText: positiveColorText,
            positiveColorBg: positiveColorBg,
            negativeColorText: negativeColorText,
            negativeColorBg: negativeColorBg,
          ),
        ),
        barrierDismissible: barrierDismissible ?? true);
  }
}

class CommonDialogContent extends StatelessWidget {
  CommonDialogContent({
    Key? key,
    this.title,
    required this.message,
    this.negativeText,
    required this.positiveText,
    required this.positiveBtCallback,
    this.negativeBtCallback,
    this.positiveColorText,
    this.positiveColorBg,
    this.negativeColorText,
    this.negativeColorBg,
  }) : super(key: key);

  String? title;
  String message;
  String? negativeText;
  String positiveText;
  Color? positiveColorBg;
  Color? positiveColorText;
  Color? negativeColorBg;
  Color? negativeColorText;
  VoidCallback positiveBtCallback;
  VoidCallback? negativeBtCallback;

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        /*  Get.offAllNamed(AppRoutes.routeSetupProfileWelcomeScreen,
            predicate: (route) => false);*/
        return false;
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 18),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              (title ?? "alert").tr,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                  fontSize: 18.fontMultiplier,
                  fontWeight: FontWeight.w600,
                  color: AppColors.colorTextPrimary),
            ),
            Visibility(
              visible: message.isNotEmpty,
              child: const Divider(
                height: 32,
              ),
            ),
            Visibility(
              visible: message.isNotEmpty,
              child: Text(
                message.tr,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                    fontSize: 16.fontMultiplier,
                    color: AppColors.colorTextPrimary),
              ),
            ),
            const SizedBox(
              height: 24,
            ),
            Row(
              mainAxisSize: MainAxisSize.max,
              children: [
                Visibility(
                  visible: negativeText != null,
                  child: Expanded(
                      child: CommonButton(
                    text: (negativeText ?? "").tr,
                    height: 45,
                    clickAction: negativeBtCallback ??
                        () {
                          Get.back();
                        },
                    textColor: negativeColorText ?? Colors.white,
                    elevation: 0,
                    borderWidth: 1,
                    borderRadius: 10,
                    marginHorizontal: 0,
                  )),
                ),
                const SizedBox(
                  width: 8,
                ),
                Expanded(
                    child: CommonButton(
                  text: positiveText.tr,
                  height: 45,
                  clickAction: positiveBtCallback,
                  textColor: positiveColorText ?? Colors.white,
                  elevation: 0,
                  borderRadius: 10,
                  borderWidth: 0,
                  marginHorizontal: 0,
                ))
              ],
            )
          ],
        ),
      ),
    );
  }
}
