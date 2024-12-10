import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/view/widgets/common/common_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonButtonOutline extends StatelessWidget {
  String text;
  Color? borderColor;
  Color? backgroundColor;
  Color? textColor;
  VoidCallback clickAction;
  RxBool? isEnable = false.obs;
  double? borderRadius;
  double? elevation;
  RxBool? isLoading;

  CommonButtonOutline(
      {Key? key,
        required this.text,
        this.textColor,
        this.borderColor,
        required this.clickAction,
        this.isEnable,
        this.borderRadius,
        this.elevation,
        this.backgroundColor,
        this.isLoading
      })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
      ()=> (isLoading?.value??false) ? const CommonProgressBar() :  Container(
        height: 51,
        margin: const EdgeInsets.symmetric(
          horizontal: 16,
        ),
        width: double.infinity,
        decoration: const BoxDecoration(),
        child: Obx(
              () => ElevatedButton(
            onPressed: isEnable?.value??RxBool(true).value ? clickAction: null,
            style: ButtonStyle(
                backgroundColor: MaterialStateProperty.all(backgroundColor??Colors.white),
                shape: MaterialStateProperty.all(RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(borderRadius??10),
                  side: BorderSide(color: borderColor??AppColors.kPrimaryColor),

                )),
                elevation: MaterialStateProperty.all(elevation??2.0)
            ),
            child: Center(
              child: Text(
                text.tr,
                style: Theme.of(context)
                    .textTheme
                    .labelLarge
                    ?.copyWith(color: textColor ?? AppColors.kPrimaryColor),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
