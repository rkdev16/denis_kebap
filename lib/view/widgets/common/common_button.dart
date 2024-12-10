import 'package:denis_kebap/config/app_colors.dart';
import 'package:denis_kebap/view/widgets/common/common_progress_bar.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class CommonButton extends StatelessWidget {
  String text;
  Color? backgroundColor;
  Color? textColor;
  VoidCallback clickAction;
  RxBool? isEnable = true.obs;
  double? borderRadius;
  double? elevation;
  EdgeInsets? margin;
  double? marginHorizontal;
  double? height;
  double? width;
  TextStyle? textStyle;
  double? borderWidth;
  RxBool? isLoading;
  Color? borderColor;





  CommonButton({Key? key,
    required this.text,
    this.textColor,
    this.backgroundColor,
    required this.clickAction,
    this.isEnable,
    this.borderRadius,
    this.elevation,
    this.margin,
    this.marginHorizontal,
    this.height,
    this.width,
    this.textStyle,
    this.borderWidth,
    this.isLoading,
    this.borderColor,

  })
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Obx(
        ()=> AnimatedOpacity(
        opacity: (isEnable?.value??RxBool(true).value)? 1.0 : 0.5,
        duration: const Duration(milliseconds: 400),
        child: Container(
          height: height ?? 51,
          margin:margin??  EdgeInsets.symmetric(
            horizontal: marginHorizontal ?? 16,
          ),
          width: width ?? double.infinity,

          child: Obx(
                () => (isLoading?.value??false) ?
               Center(
                    child: SizedBox(
                      height:height??51,
                      width: height??51,
                      child: const  Padding(
                        padding: EdgeInsets.all(8.0),
                        child: CommonProgressBar(),
                      ),
                    )):
                ElevatedButton(
                  onPressed: isEnable?.value ?? RxBool(true).value
                      ? clickAction
                      : null,
                  style: ButtonStyle(
                    padding: MaterialStateProperty.all(const EdgeInsets.symmetric(horizontal: 8)),
                      elevation: MaterialStateProperty.all(elevation),
                      backgroundColor: MaterialStateProperty.all(backgroundColor ?? AppColors.kPrimaryColor),
                      shape: MaterialStateProperty.all(RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                            borderRadius ?? 10),
                          side: BorderSide(color: borderColor??Colors.transparent, width:borderWidth??0)
                      ))),
                  child: Center(
                    child: FittedBox(
                      fit: BoxFit.scaleDown,
                      child: Text(
                        text.tr,
                        maxLines: 1,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle ??
                            Theme
                                .of(context)
                                .textTheme
                                .labelLarge
                                ?.copyWith(
                                color: textColor ?? Colors.white,

                            ),
                      ),
                    ),
                  ),
                ),
          ),
        ),
      ),
    );
  }
}
