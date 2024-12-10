



import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class  CommonMessageWidget extends StatelessWidget {
  const  CommonMessageWidget({
    super.key,
    required this.message,
    this.fontWeight,
    this.fontSize,
    this.fontColor
  });

final String message;
final FontWeight? fontWeight;
final double? fontSize;
final Color? fontColor;

  @override
  Widget build(BuildContext context) {
    return Container(
      alignment: Alignment.center,
      constraints: const  BoxConstraints(minHeight: 100),
      child: Text(message.tr,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
        fontWeight:fontWeight??FontWeight.w300,
        fontSize: (fontSize?? 14).fontMultiplier,
        color: fontColor?? Colors.white
      ),),
    );
  }
}
