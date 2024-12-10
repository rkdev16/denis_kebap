import 'package:denis_kebap/utils/extensions/extensions.dart';
import 'package:denis_kebap/utils/helpers.dart';
import 'package:denis_kebap/view/pages/cart/components/tip_tab.dart';
import 'package:denis_kebap/view/widgets/common/common_bg_bottom_sheet.dart';
import 'package:denis_kebap/view/widgets/common/common_button.dart';
import 'package:flutter/material.dart';
import 'package:gap/gap.dart';
import 'package:get/get.dart';

class TipBottomSheet {
  static show({
    required num amount,
    required Function(num tip) onTapPay
  }) {
    Get.bottomSheet(
      _TipBottomSheetContent(amount: amount, onTapPay: onTapPay,),
      isDismissible: true,
    );
  }
}

class _TipBottomSheetContent extends StatefulWidget {
  _TipBottomSheetContent({
    super.key,
    required this.amount,
    required this.onTapPay
  });

  num amount;
  Function(num tip) onTapPay;

  @override
  State<_TipBottomSheetContent> createState() => _TipBottomSheetContentState();
}

class _TipBottomSheetContentState extends State<_TipBottomSheetContent> {
  final tips = [0, 5, 10, 20];

  int selectedTip = 0;
  num amount  = 0;
  num tipAmount = 0;


   dynamic getPercentage(int percentage, dynamic amount){

    if(amount ==null) return 0;
    return (amount * percentage) /100;

  }

  calculateAmount(){
    amount = widget.amount;
    tipAmount = getPercentage(selectedTip, amount);
    amount = amount + tipAmount;
  }

  @override
  void initState() {
    super.initState();
    selectedTip = tips[0];

    calculateAmount();
  }

  @override
  Widget build(BuildContext context) {
    return CommonBgBottomSheet(
      child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0,vertical: 8),
          child: Text(
           // '${"tip".tr}?',
            'thank_you_for_the_tip'.tr,
            style: Theme.of(context)
                .textTheme
                .headlineMedium
                ?.copyWith(fontSize: 16.fontMultiplier, color: Colors.white),
          ),
        ),
        Padding(
          padding: const  EdgeInsets.all(16),
          child: Row(
            children: tips.map((e) =>
                TipTab(isSelected: selectedTip == e, title: '$e%', onTap: () {
                  setState(() {
                    selectedTip = e;
                    calculateAmount();
                  });
                })).toList(),
          ),
        ),
        
        Container(
          alignment: Alignment.center,
          padding: const EdgeInsets.all(16.0),
          child: Text('${'total_amount_to_pay'.tr} : ${Helpers.formatPrice(amount)}',style: Theme.of(context).textTheme.headlineSmall?.copyWith(
            fontSize: 16.fontMultiplier,
            color: Colors.white
          ),),
        ),

        CommonButton(text: 'continue_with_online_payment'.tr, clickAction: (){
          debugPrint("Hii : $tipAmount");
          widget.onTapPay(tipAmount);
          Navigator.of(context).pop();
        }),
      const   Gap(32)
      ]),
    );
  }
}
