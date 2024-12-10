
import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';

class AddTipConfirmationDialog{
  AddTipConfirmationDialog._();
  static show(){

  }
}

class _DialogContent extends StatelessWidget {
  const _DialogContent({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(children: [

      Container(child: Column(children: [

        Text('message_want_to_add_tip'.tr,style: Theme.of(context).textTheme.headlineSmall?.copyWith(
          fontSize: 18.fontMultiplier,
          fontWeight: FontWeight.w500
        ),),




      ],),)

    ],);
  }
}
